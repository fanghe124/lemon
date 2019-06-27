package com.mossle.humantask.rule;

import java.util.ArrayList;
import java.util.List;

public class ExperUserAssigneeRule implements AssigneeRule{
		
	@Override
	public String process(String initiator) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<String> process(String value, String initiator) {
		List<String> managerList  = new ArrayList<String>();
//		 String hql = "from UserStatus where tenantId=?";
//		 Page page =new Page();
//        page = userStatusManager.pagedQuery(hql, 1,
//                65535, "1");
//
//        List<UserStatus> userStatuses = (List<UserStatus>) page.getResult();
//        for(UserStatus status:  userStatuses)
//        {
//       	 Set<Role> roleSet= status.getRoles();
//       	 for(Role role : roleSet){
//       		 if(role.getName().equals("参加试验单位"))
//       		 {
//       			 managerList.add(status.getRef());
//       			 break;
//       		 }
//       	 }
//        }
        return managerList;
	}

}
