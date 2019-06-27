package com.mossle.plan.persistence.manager;

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
import com.mossle.plan.persistence.domain.PlanInfo;

@Service
public class PlanInfoManager extends HibernateEntityDao<PlanInfo> {
	
	private static Logger logger = LoggerFactory
            .getLogger(PlanInfoManager.class);
	
	
	@SuppressWarnings("unchecked")
	public List<PlanInfo> getPlanListByType(String type,String creatUserId) {
		try {
			String hql = "from PlanInfo plan where plan.type = ? and plan.creatUserId = ?";
			return createQuery(hql, type, creatUserId).list();
		} catch (Exception e) {
			logger.error("根据计划类型查询实验计划出错", e);
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<PlanInfo> getPlanListByUserId(String userId) {
		try {
			String hql = "from PlanInfo plan where plan.userId = ?";
			return createQuery(hql, userId).list();
		} catch (Exception e) {
			logger.error("根据用户查询实验计划出错", e);
		}
		return null;
	}

}
