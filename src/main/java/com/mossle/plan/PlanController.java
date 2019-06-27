package com.mossle.plan;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.history.HistoricProcessInstance;
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
import com.mossle.api.process.ProcessConnector;
import com.mossle.api.tenant.TenantHolder;
import com.mossle.core.mapper.JsonMapper;
import com.mossle.core.page.Page;
import com.mossle.core.query.PropertyFilter;
import com.mossle.device.persistence.domain.DeviceInfo;
import com.mossle.device.persistence.manager.DeviceInfoManager;
import com.mossle.plan.persistence.domain.PlanInfo;
import com.mossle.plan.persistence.manager.PlanInfoManager;
import com.mossle.user.persistence.domain.AccountInfo;
import com.mossle.user.persistence.domain.AccountOperation;
import com.mossle.user.persistence.manager.AccountInfoManager;
import com.mossle.user.persistence.manager.AccountOperationManager;

@Controller("com.mossle.plan.PlanController")
@RequestMapping("plan")
public class PlanController {
	
	private static Logger logger = LoggerFactory
            .getLogger(PlanController.class);
	
	private JsonMapper jsonMapper = new JsonMapper();
	private DeviceInfoManager deviceInfoManager;
	private CurrentUserHolder currentUserHolder;
	private AccountInfoManager accountInfoManager;
	private AccountOperationManager accountOperationManager;
	
	//新的
	private PlanInfoManager planInfoManager;
	private TenantHolder tenantHolder;
    private ProcessConnector processConnector;
	
    @RequestMapping("index")
    public String index(Model model) {
//        List<Map<String, Object>> list = this.init();
//        model.addAttribute("list", list);

        return "plan/index";
    }
    
    @RequestMapping(value = "plan-list", method = RequestMethod.POST)
    public void getPlanListByType(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	String jsonResult = getJSONString(request);
        renderData(response, jsonResult);
    }
    
    private String getJSONString(HttpServletRequest request) throws IOException {
        String type = request.getParameter("currentType");
        List<PlanInfo> planInfoList = new ArrayList<PlanInfo>();
        String userId = currentUserHolder.getUserId();
        if(type.equalsIgnoreCase("task")){
//        	String userName = currentUserHolder.getUsername();
        	planInfoList = planInfoManager.getPlanListByUserId(userId);
        }else{
        	planInfoList = planInfoManager.getPlanListByType(type,userId);
        }
        
        String jsonResult = jsonMapper.toJson(planInfoList);
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
      
      @RequestMapping(value = "plan-dialog", method = RequestMethod.POST)
      public void getPlanDialogInfo(HttpServletRequest request,HttpServletResponse response) throws IOException {
    	  //查找用户
    	  Page accountPage = new Page();
          String tenantId = tenantHolder.getTenantId();
          List<PropertyFilter> propertyFilters = new ArrayList<PropertyFilter>();
          propertyFilters.add(new PropertyFilter("EQS_tenantId", tenantId));
          accountPage = accountInfoManager.pagedQuery(accountPage, propertyFilters);
          List<AccountInfo> accountList = (List<AccountInfo>) accountPage.getResult();
          JSONArray accountArray = new JSONArray();
          for(AccountInfo account : accountList){
        	  JSONObject obj = new JSONObject();
        	  obj.put("userId", account.getCode());
        	  obj.put("userName", account.getDisplayName());
        	  accountArray.put(obj);
          }
          
          //查找实验
          Page processPage = new Page();
          String userId = currentUserHolder.getUserId();
          processPage = processConnector.findRunningProcessInstances(userId, tenantId,
        		  processPage);
          List<HistoricProcessInstance> hpiList = (List<HistoricProcessInstance>) processPage.getResult();
          JSONArray processArray = new JSONArray();
          for(HistoricProcessInstance hpi : hpiList){
        	  JSONObject obj = new JSONObject();
        	  obj.put("processId", hpi.getId());
        	  obj.put("processName", hpi.getName());
        	  processArray.put(obj);
          }
    	  
          JSONObject obj = new JSONObject();
	      obj.put("userList", accountArray);
	      obj.put("processList", processArray);
          String jsonResult = obj.toString();
          renderData(response, jsonResult);
      }
      
      
      @RequestMapping(value = "plan-save", method = RequestMethod.POST)
      public void savePlan(HttpServletRequest request, HttpServletResponse response){
    	  try{
    		    String planId = request.getParameter("planId");
    	      	String process = request.getParameter("process");
    	      	String user = request.getParameter("user");
    	      	String userId = request.getParameter("userId");
    	      	String time = request.getParameter("time");
    	      	String content = request.getParameter("content");
    	      	String type = request.getParameter("type");
    	      	String stage = request.getParameter("stage");
    	      	PlanInfo planInfo= new PlanInfo();
    	      	String logStr = "";
    	      	if(!StringUtils.isEmpty(planId)){
    	      		planInfo = planInfoManager.get(Long.valueOf(planId));
//    	      		logStr = "编辑设备";
    	      	}else{
//    	      		logStr = "添加设备";
    	      	}
    	      	DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
    	      	planInfo.setContent(content);
    	      	planInfo.setProcess(process);
    	      	planInfo.setStage(stage);
    	      	planInfo.setTime(format1.parse(time));
    	      	planInfo.setType(type);
    	      	planInfo.setUser(user);
    	      	planInfo.setUserId(userId);
    	      	planInfo.setStatus("未完成");
    	      	String creatUserId = currentUserHolder.getUserId();
    	      	planInfo.setCreatUserId(creatUserId);
    	      	planInfoManager.save(planInfo);
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
      
      @RequestMapping(value = "plan-delete", method = RequestMethod.POST)
      public void deletePlan(HttpServletRequest request, HttpServletResponse response){
    	  try{
    		  
    	      	String planId = request.getParameter("planId");
    	      	if(!StringUtils.isEmpty(planId)){
    	      		planInfoManager.removeById(Long.valueOf(planId));
    	      	}
    	  } catch (Exception ex) {
    		  logger.error("设备实验计划出错", ex);
          }
//    	  renderData(response, "sucess");
      	
      }
      
      @RequestMapping(value = "plan-edit", method = RequestMethod.POST)
      public void editPlanInfo(HttpServletRequest request,HttpServletResponse response) throws IOException {
    	  PlanInfo plansInfo= new PlanInfo();
    	  try{
  	      	String planId = request.getParameter("planId");
  	      	if(!StringUtils.isEmpty(planId)){
  	      	plansInfo = planInfoManager.get(Long.valueOf(planId));
  	      	}
	  	  } catch (Exception ex) {
	  		  logger.error("获取单个实验计划出错", ex);
	      }
    	  String jsonResult = jsonMapper.toJson(plansInfo);
    	  renderData(response, jsonResult);
      }
      
      @RequestMapping(value = "plan-done", method = RequestMethod.POST)
      public void donePlanInfo(HttpServletRequest request,HttpServletResponse response) throws IOException {
    	  PlanInfo plansInfo= new PlanInfo();
    	  try{
  	      	String planId = request.getParameter("planId");
  	      	if(!StringUtils.isEmpty(planId)){
  	      	plansInfo = planInfoManager.get(Long.valueOf(planId));
  	      	}
  	      plansInfo.setStatus("完成");
  	      planInfoManager.save(plansInfo);
	  	  } catch (Exception ex) {
	  		  logger.error("完成实验计划出错", ex);
	      }
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
      
      //新的
      
      @Resource
      public void setPlanInfoManager(PlanInfoManager planInfoManager) {
          this.planInfoManager = planInfoManager;
      }
      
      @Resource
      public void setTenantHolder(TenantHolder tenantHolder) {
          this.tenantHolder = tenantHolder;
      }
    
      @Resource
      public void setProcessConnector(ProcessConnector processConnector) {
          this.processConnector = processConnector;
      }
}
