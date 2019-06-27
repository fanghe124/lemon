package com.mossle.humantask.listener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import com.mossle.auth.persistence.domain.Role;
import com.mossle.auth.persistence.domain.UserStatus;
import com.mossle.auth.persistence.manager.UserStatusManager;
import com.mossle.core.page.Page;
import com.mossle.humantask.persistence.domain.TaskInfo;
import com.mossle.humantask.persistence.domain.TaskParticipant;
import com.mossle.humantask.persistence.manager.TaskParticipantManager;
import com.mossle.humantask.rule.ActivityAssigneeRule;
import com.mossle.humantask.rule.AssigneeRule;
import com.mossle.humantask.rule.EqualsRuleMatcher;
import com.mossle.humantask.rule.ExperManagerAssigneeRule;
import com.mossle.humantask.rule.ExperUserAssigneeRule;
import com.mossle.humantask.rule.InitiatorAssigneeRule;
import com.mossle.humantask.rule.PositionAssigneeRule;
import com.mossle.humantask.rule.PrefixRuleMatcher;
import com.mossle.humantask.rule.RuleMatcher;
import com.mossle.humantask.rule.SuperiorAssigneeRule;

import com.mossle.spi.process.InternalProcessConnector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 处理负责人配置的别名.
 */
public class AssigneeAliasHumanTaskListener implements HumanTaskListener {
    private static Logger logger = LoggerFactory
            .getLogger(AssigneeAliasHumanTaskListener.class);
    private InternalProcessConnector internalProcessConnector;
    private TaskParticipantManager taskParticipantManager;
	
	@Autowired
    private UserStatusManager userStatusManager;
    private Map<RuleMatcher, AssigneeRule> assigneeRuleMap = new HashMap<RuleMatcher, AssigneeRule>();

    public AssigneeAliasHumanTaskListener() {
        SuperiorAssigneeRule superiorAssigneeRule = new SuperiorAssigneeRule();
        PositionAssigneeRule positionAssigneeRule = new PositionAssigneeRule();
        InitiatorAssigneeRule initiatorAssigneeRule = new InitiatorAssigneeRule();
        ActivityAssigneeRule activityAssigneeRule = new ActivityAssigneeRule();
        ExperManagerAssigneeRule experManagerAssigneeRule =new ExperManagerAssigneeRule();
        ExperUserAssigneeRule experUserAssigneeRule =new ExperUserAssigneeRule();
        
        assigneeRuleMap.put(new EqualsRuleMatcher("常用语:直接上级"),
                superiorAssigneeRule);
        assigneeRuleMap.put(new EqualsRuleMatcher("常用语:流程发起人"),
                initiatorAssigneeRule);
        assigneeRuleMap.put(new PrefixRuleMatcher("岗位"), positionAssigneeRule);
        assigneeRuleMap.put(new PrefixRuleMatcher("环节处理人"),
                activityAssigneeRule);
        assigneeRuleMap.put(new EqualsRuleMatcher("常用语:试验总体单位"),
        		experManagerAssigneeRule);
        assigneeRuleMap.put(new EqualsRuleMatcher("常用语:参加试验单位"),
        		experUserAssigneeRule);
    }

    @Override
    public void onCreate(TaskInfo taskInfo) throws Exception {
        String assignee = taskInfo.getAssignee();
        logger.debug("assignee : {}", assignee);

        if (assignee == null) {
            return;
        }

        if (assignee.startsWith("${")) {
            assignee = (String) internalProcessConnector.executeExpression(
                    taskInfo.getTaskId(), assignee);
            taskInfo.setAssignee(assignee);

            return;
        }

        for (Map.Entry<RuleMatcher, AssigneeRule> entry : assigneeRuleMap
                .entrySet()) {
            RuleMatcher ruleMatcher = entry.getKey();

            if (!ruleMatcher.matches(assignee)) {
                continue;
            }

            String value = ruleMatcher.getValue(assignee);
            AssigneeRule assigneeRule = entry.getValue();
            logger.debug("value : {}", value);
            logger.debug("assigneeRule : {}", assigneeRule);

            if (assigneeRule instanceof SuperiorAssigneeRule) {
                this.processSuperior(taskInfo, assigneeRule, value);
            } else if (assigneeRule instanceof InitiatorAssigneeRule) {
                this.processInitiator(taskInfo, assigneeRule, value);
            } else if (assigneeRule instanceof ActivityAssigneeRule) {
                this.processActivityAssignee(taskInfo, assigneeRule, value);
            } else if (assigneeRule instanceof PositionAssigneeRule) {
                this.processPosition(taskInfo, assigneeRule, value);
            } else if (assigneeRule instanceof ExperManagerAssigneeRule) {
                this.processExperMana(taskInfo, assigneeRule, value);
            } else if (assigneeRule instanceof ExperUserAssigneeRule) {
                this.processExperUser(taskInfo, assigneeRule, value);
            }
        }
    }

    @Override
    public void onComplete(TaskInfo taskInfo) throws Exception {
    }

    public void processSuperior(TaskInfo taskInfo, AssigneeRule assigneeRule,
            String value) {
        String processInstanceId = taskInfo.getProcessInstanceId();
        String startUserId = internalProcessConnector
                .findInitiator(processInstanceId);
        String userId = assigneeRule.process(startUserId);
        logger.debug("userId : {}", userId);
        taskInfo.setAssignee(userId);
    }

    public void processInitiator(TaskInfo taskInfo, AssigneeRule assigneeRule,
            String value) {
        String processInstanceId = taskInfo.getProcessInstanceId();
        String startUserId = internalProcessConnector
                .findInitiator(processInstanceId);
        String userId = assigneeRule.process(startUserId);
        logger.debug("userId : {}", userId);
        taskInfo.setAssignee(userId);
    }

    public void processActivityAssignee(TaskInfo taskInfo,
            AssigneeRule assigneeRule, String value) {
        String processInstanceId = taskInfo.getProcessInstanceId();
        List<String> userIds = assigneeRule.process(value, processInstanceId);
        logger.debug("userIds : {}", userIds);

        if (!userIds.isEmpty()) {
            taskInfo.setAssignee(userIds.get(0));
        }
    }

    public void processPosition(TaskInfo taskInfo, AssigneeRule assigneeRule,
            String value) {
        String processInstanceId = taskInfo.getProcessInstanceId();
        String startUserId = internalProcessConnector
                .findInitiator(processInstanceId);
        List<String> userIds = assigneeRule.process(value, startUserId);
        logger.debug("userIds : {}", userIds);

        if (userIds.isEmpty()) {
            logger.info("{} userIds is empty", taskInfo.getCode());
        } else if (userIds.size() == 1) {
            taskInfo.setAssignee(userIds.get(0));
        } else {
            for (String userId : userIds) {
                TaskParticipant taskParticipant = new TaskParticipant();
                taskParticipant.setTaskInfo(taskInfo);
                taskParticipant.setCategory("candidate");
                taskParticipant.setType("user");
                taskParticipant.setRef(userId);
                taskParticipantManager.save(taskParticipant);
            }
        }
    }
    
    @SuppressWarnings("unchecked")
	public void processExperMana(TaskInfo taskInfo, AssigneeRule assigneeRule,
            String value) {
      
        List<String> userIds = new ArrayList<String>();
		String hql = "from UserStatus where tenantId=?";
		Page page =new Page();
        page = userStatusManager.pagedQuery(hql, 1,
                65535, "1");

        List<UserStatus> userStatuses = (List<UserStatus>) page.getResult();
        for(UserStatus status:  userStatuses)
        {
       	    Set<Role> roleSet= status.getRoles();
       	    for(Role role : roleSet){
       		    if(role.getName().equals("试验总体单位"))
       		    {
       		    	userIds.add(status.getRef());
       			     break;
       		    }
       	    }
        }
        logger.debug("userIds : {}", userIds);

        if (userIds.isEmpty()) {
            logger.info("{} userIds is empty", taskInfo.getCode());
        } else if (userIds.size() == 1) {
            taskInfo.setAssignee(userIds.get(0));
        } else {
            for (String userId : userIds) {
                TaskParticipant taskParticipant = new TaskParticipant();
                taskParticipant.setTaskInfo(taskInfo);
                taskParticipant.setCategory("candidate");
                taskParticipant.setType("user");
                taskParticipant.setRef(userId);
                taskParticipantManager.save(taskParticipant);
            }
        }
    }

    @SuppressWarnings("unchecked")
	public void processExperUser(TaskInfo taskInfo, AssigneeRule assigneeRule,
            String value) {
        List<String> userIds = new ArrayList<String>();
        String hql = "from UserStatus where tenantId=?";
		Page page =new Page();
        page = userStatusManager.pagedQuery(hql, 1,
                65535, "1");

        List<UserStatus> userStatuses = (List<UserStatus>) page.getResult();
        for(UserStatus status:  userStatuses)
        {
       	    Set<Role> roleSet= status.getRoles();
       	    for(Role role : roleSet){
       		    if(role.getName().equals("参加试验单位"))
       		    {
       		    	userIds.add(status.getRef());
       			     break;
       		    }
       	    }
        }
        logger.debug("userIds : {}", userIds);

        if (userIds.isEmpty()) {
            logger.info("{} userIds is empty", taskInfo.getCode());
        } else if (userIds.size() == 1) {
            taskInfo.setAssignee(userIds.get(0));
        } else {
            for (String userId : userIds) {
                TaskParticipant taskParticipant = new TaskParticipant();
                taskParticipant.setTaskInfo(taskInfo);
                taskParticipant.setCategory("candidate");
                taskParticipant.setType("user");
                taskParticipant.setRef(userId);
                taskParticipantManager.save(taskParticipant);
            }
        }
    }

    @Resource
    public void setInternalProcessConnector(
            InternalProcessConnector internalProcessConnector) {
        this.internalProcessConnector = internalProcessConnector;
    }

    @Resource
    public void setTaskParticipantManager(
            TaskParticipantManager taskParticipantManager) {
        this.taskParticipantManager = taskParticipantManager;
    }
}
