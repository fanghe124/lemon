package com.mossle.device;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.impl.util.json.JSONArray;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mossle.api.auth.CurrentUserHolder;
import com.mossle.core.mapper.JsonMapper;
import com.mossle.device.persistence.domain.DeviceInfo;
import com.mossle.device.persistence.manager.DeviceInfoManager;
import com.mossle.user.persistence.domain.AccountInfo;
import com.mossle.user.persistence.domain.AccountOperation;
import com.mossle.user.persistence.manager.AccountInfoManager;
import com.mossle.user.persistence.manager.AccountOperationManager;

@Controller("com.mossle.device.DeviceController")
@RequestMapping("device")
public class DeviceController {
	
	private static Logger logger = LoggerFactory
            .getLogger(DeviceController.class);
	
	private JsonMapper jsonMapper = new JsonMapper();
	private DeviceInfoManager deviceInfoManager;
	private CurrentUserHolder currentUserHolder;
	private AccountInfoManager accountInfoManager;
	private AccountOperationManager accountOperationManager;
	
    @RequestMapping("index")
    public String index(Model model) {
//        List<Map<String, Object>> list = this.init();
//        model.addAttribute("list", list);

        return "device/index";
    }
    
    @RequestMapping(value = "device-list", method = RequestMethod.POST)
    public void getDeviceList(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	String jsonResult = getJSONString(request);
        renderData(response, jsonResult);
    }
    
    private String getJSONString(HttpServletRequest request) throws IOException {
        String selectedClassName = request.getParameter("selectedClassName");
        List<DeviceInfo> deviceInfoList = new ArrayList<DeviceInfo>();
        if(!StringUtils.isEmpty(selectedClassName) && !selectedClassName.equals("all")){
        	deviceInfoList = deviceInfoManager.getDeviceListByClassName(selectedClassName);
        }else{
        	deviceInfoList = deviceInfoManager.getAll();
        }
        String jsonResult = jsonMapper.toJson(deviceInfoList);
        return jsonResult;
      }

      /**
       * 通过PrintWriter将响应数据写入response，ajax可以接受到这个数据
       * 
       * @param response
       * @param data 
       */
      private void renderData(HttpServletResponse response, String data) {
        PrintWriter printWriter = null;
        try {
          printWriter = response.getWriter();
          printWriter.print(data);
        } catch (IOException ex) {
        	logger.error("读写出错", ex);
        } finally {
          if (null != printWriter) {
            printWriter.flush();
            printWriter.close();
          }
        }
      }
      
      @RequestMapping(value = "device-class-list", method = RequestMethod.POST)
      public void getDeviceClassList(HttpServletRequest request,HttpServletResponse response) throws IOException {
          List<String> deviceClassList = new ArrayList<String>();
          deviceClassList.add("all");
          deviceClassList.addAll(deviceInfoManager.getDeviceClass()); 
          JSONArray result = new JSONArray();
    	  for(String deviceClass : deviceClassList){
    		  JSONObject obj = new JSONObject();
		      obj.put("className", deviceClass);
    		  Map<String,String> deviceClassStatus = deviceInfoManager.getDeviceClassAndStatus(deviceClass);
    		  for (Map.Entry<String, String> entry : deviceClassStatus.entrySet()) {
    		      obj.put(entry.getKey(), entry.getValue());
    		    }
    		  result.put(obj);
    	  }
          String jsonResult = result.toString();
          renderData(response, jsonResult);
      }
      
      @RequestMapping(value = "device-save", method = RequestMethod.POST)
      public void saveDevice(HttpServletRequest request, HttpServletResponse response){
    	  try{
    		    String deviceId = request.getParameter("deviceId");
    	      	String deviceName = request.getParameter("deviceName");
    	      	String deviceNumber = request.getParameter("deviceNumber");
    	      	String deviceClass = request.getParameter("deviceClass");
    	      	String deviceStatus = request.getParameter("deviceStatus");
    	      	DeviceInfo deviceInfo= new DeviceInfo();
    	      	String logStr = "";
    	      	if(!StringUtils.isEmpty(deviceId)){
    	      		deviceInfo = deviceInfoManager.get(Long.valueOf(deviceId));
    	      		logStr = "编辑设备";
    	      	}else{
    	      		logStr = "添加设备";
    	      	}
    	      	deviceInfo.setName(deviceName);
    	      	deviceInfo.setNumber(deviceNumber);
    	      	deviceInfo.setDeviceClass(deviceClass);
    	      	deviceInfo.setStatus(deviceStatus);
    	      	deviceInfoManager.save(deviceInfo);
    	      	if(!StringUtils.isEmpty(deviceName)){
    	      		logStr= logStr + "-"+deviceName;
    	      	}
    	      	//记录日志
    	      	addLog(logStr);
    	  } catch (Exception ex) {
    		  logger.error("保存设备出错", ex);
          }
//    	  renderData(response, "sucess");
      	
      }
      
      private void addLog(String operationStr){
    	  try{
    		//记录日志
  	      	AccountOperation accountOperation = new AccountOperation();
  	      	 String userId = currentUserHolder.getUserId();
  	         AccountInfo accountInfo = accountInfoManager.findUniqueBy("code",
  	                 userId); 
  	        String accountName = "";
  	        String tenantId = "";
  	        if(accountInfo != null){
  	        	accountName = accountInfo.getDisplayName();
  	        	tenantId = accountInfo.getTenantId();
  	        }
  	        accountOperation.setName(accountName);
  	        accountOperation.setOperation(operationStr);
  	        accountOperation.setTime(new Date());
  	        accountOperation.setTenantId(tenantId);
  	        accountOperationManager.save(accountOperation);
    	  }catch(Exception e){
    		  logger.error("添加日志出错", e);
    	  }
      }
      
      @RequestMapping(value = "device-delete", method = RequestMethod.POST)
      public void deleteDevice(HttpServletRequest request, HttpServletResponse response){
    	  try{
    		  
    	      	String deviceId = request.getParameter("deviceId");
    	      	String logStr = "删除设备";
    	      	if(!StringUtils.isEmpty(deviceId)){
    	      		DeviceInfo deviceInfo = deviceInfoManager.get(Long.valueOf(deviceId));
    	      		if(deviceInfo != null && !StringUtils.isEmpty(deviceInfo.getName())){
    	      			logStr = logStr +"-"+ deviceInfo.getName();
    	      		}
    	      		deviceInfoManager.removeById(Long.valueOf(deviceId));
    	      	}
    	      	addLog(logStr);
    	  } catch (Exception ex) {
    		  logger.error("设备删除出错", ex);
          }
//    	  renderData(response, "sucess");
      	
      }
      
      @RequestMapping(value = "device-edit", method = RequestMethod.POST)
      public void getDeviceInfo(HttpServletRequest request,HttpServletResponse response) throws IOException {
    	  DeviceInfo deviceInfo= new DeviceInfo();
    	  try{
  	      	String deviceId = request.getParameter("deviceId");
  	      	if(!StringUtils.isEmpty(deviceId)){
  	      	deviceInfo = deviceInfoManager.get(Long.valueOf(deviceId));
  	      	}
	  	  } catch (Exception ex) {
	  		  logger.error("获取单个设备出错", ex);
	      }
    	  String jsonResult = jsonMapper.toJson(deviceInfo);
    	  renderData(response, jsonResult);
      }
      
      @Resource
      public void setDeviceInfoManager(DeviceInfoManager deviceInfoManager) {
          this.deviceInfoManager = deviceInfoManager;
      }
      
      @Resource
      public void setCurrentUserHolder(CurrentUserHolder currentUserHolder) {
          this.currentUserHolder = currentUserHolder;
      }
      
      @Resource
      public void setAccountInfoManager(AccountInfoManager accountInfoManager) {
          this.accountInfoManager = accountInfoManager;
      }
      
      @Resource
      public void setAccountOperationManager(AccountOperationManager accountOperationManager) {
          this.accountOperationManager = accountOperationManager;
      }
    
}
