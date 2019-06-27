package com.mossle.device.persistence.manager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.mossle.core.hibernate.HibernateEntityDao;
import com.mossle.device.persistence.domain.DeviceInfo;


@Service
public class DeviceInfoManager extends HibernateEntityDao<DeviceInfo> {
	
	private static Logger logger = LoggerFactory
            .getLogger(DeviceInfoManager.class);
	
	public final static List<String> statusList = Arrays.asList("use","free","dump");
	
	@SuppressWarnings("unchecked")
	public List<String> getDeviceClass() {
		List<String> result = new ArrayList<String>();

		try {
			String hql = "select distinct device.deviceClass from DeviceInfo device ";
			List<Object> classList =  createQuery(hql).list();
		
			if(!CollectionUtils.isEmpty(classList)){
				for(Object obj : classList){
					result.add((String) obj);
				}
			}
			return result;
		} catch (Exception e) {
			logger.error("查询设备种类出错", e);
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String,String> getDeviceClassAndStatus(String deviceClass ) {
		Map<String,String> result = new HashMap<String,String>();
		try {
			String hql = "";
			if(deviceClass.endsWith("all")){
				hql = "select count(*) AS number from DeviceInfo as device where "
						+ "device.status =?";
				for(String status:statusList){
					List<Object> classList =  createQuery(hql, status).list();
					if(!CollectionUtils.isEmpty(classList)){
						for(Object obj : classList){
							result.put(status, String.valueOf(obj) );
						}
					}
				}
			}else{
				hql = "select count(*) AS number from DeviceInfo as device where "
						+ "device.status =? and device.deviceClass = ?";
				for(String status:statusList){
					List<Object> classList =  createQuery(hql, status, deviceClass).list();
					if(!CollectionUtils.isEmpty(classList)){
						for(Object obj : classList){
							result.put(status, String.valueOf(obj));
						}
					}
				}
			}
			return result;
		} catch (Exception e) {
			logger.error("查询设备种类出错", e);
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<DeviceInfo> getDeviceListByClassName(String className) {
		try {
			String hql = "from DeviceInfo device where device.deviceClass = ?";
			return createQuery(hql, className).list();
		} catch (Exception e) {
			logger.error("查询设备种类出错", e);
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<DeviceInfo> getDeviceListByOccupationId(String className) {
		try {
			String hql = "from DeviceInfo device where device.occupationId = ?";
			return createQuery(hql, className).list();
		} catch (Exception e) {
			logger.error("查询设备占用任务出错", e);
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<DeviceInfo> getDeviceListByStatus (String status) {
		try {
			String hql = "from DeviceInfo device where device.status = ?";
			return createQuery(hql, status).list();
		} catch (Exception e) {
			logger.error("查询设备状态出错", e);
		}
		return null;
	}

}
