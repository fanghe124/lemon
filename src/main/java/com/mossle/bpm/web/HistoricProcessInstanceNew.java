package com.mossle.bpm.web;

import java.util.Date;
import java.util.Map;

public class HistoricProcessInstanceNew{

	private String articleNum;
	private String Id;
	private String businessKey;
	private String processDefinitionId;
	private Date startTime;
	private Date endTime;
	private Long durationInMillis;
	private String endActivityId;
	private String startUserId;
	private String startActivityId;
	private String deleteReason;
	private String superProcessInstanceId;
	private String tenantId;
	private String name;
	private Map<String, Object> processVariables;

	public String getArticleNum() {
		return articleNum;
	}

	public void setArticleNum(String articleNum) {
		this.articleNum = articleNum;
	}

	public String getBusinessKey() {
		return businessKey;
	}

	public void setBusinessKey(String businessKey) {
		this.businessKey = businessKey;
	}

	public String getProcessDefinitionId() {
		return processDefinitionId;
	}

	public void setProcessDefinitionId(String processDefinitionId) {
		this.processDefinitionId = processDefinitionId;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public Long getDurationInMillis() {
		return durationInMillis;
	}

	public void setDurationInMillis(Long durationInMillis) {
		this.durationInMillis = durationInMillis;
	}

	public String getEndActivityId() {
		return endActivityId;
	}

	public void setEndActivityId(String endActivityId) {
		this.endActivityId = endActivityId;
	}

	public String getStartUserId() {
		return startUserId;
	}

	public void setStartUserId(String startUserId) {
		this.startUserId = startUserId;
	}

	public String getStartActivityId() {
		return startActivityId;
	}

	public void setStartActivityId(String startActivityId) {
		this.startActivityId = startActivityId;
	}

	public String getDeleteReason() {
		return deleteReason;
	}

	public void setDeleteReason(String deleteReason) {
		this.deleteReason = deleteReason;
	}

	public String getSuperProcessInstanceId() {
		return superProcessInstanceId;
	}

	public void setSuperProcessInstanceId(String superProcessInstanceId) {
		this.superProcessInstanceId = superProcessInstanceId;
	}

	public String getTenantId() {
		return tenantId;
	}

	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Map<String, Object> getProcessVariables() {
		return processVariables;
	}

	public void setProcessVariables(Map<String, Object> processVariables) {
		this.processVariables = processVariables;
	}

	public String getId() {
		return Id;
	}

	public void setId(String id) {
		Id = id;
	}

}
