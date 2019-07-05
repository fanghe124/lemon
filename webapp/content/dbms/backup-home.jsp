<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<%pageContext.setAttribute("currentHeader", "party");%>
<%pageContext.setAttribute("currentMenu", "party");%>
<%@page import="java.util.*"%>
<%@page import="com.mossle.party.persistence.domain.*"%>
<%!
	public String generatePartyEntities(List<PartyEntity> partyEntities, long partyStructTypeId) {
		if (partyEntities == null) {
			return "";
		}
		try {
			String text = "<ul>";
			for (PartyEntity partyEntity : partyEntities) {
				text += generatePartyEntity(partyEntity, partyStructTypeId);
			}
			text += "</ul>";
			return text;
		} catch(Exception ex) {
			System.out.println("19 : " + ex);
			// ex.printStackTrace();
			return "";
		}
	}

	public String generatePartyEntity(PartyEntity partyEntity, long partyStructTypeId) {
		try {
			String text = "<li>";
			text += partyEntity.getName();
			List<PartyEntity> partyEntities = new ArrayList<PartyEntity>();
			for (PartyStruct partyStruct : partyEntity.getChildStructs()) {
				if (partyStruct.getPartyStructType().getId() == partyStructTypeId) {
					partyEntities.add(partyStruct.getChildEntity());
				}
			}
			text += generatePartyEntities(partyEntities, partyStructTypeId);
			text += "</li>";
			return text;
		} catch(Exception ex) {
			ex.printStackTrace();
			System.out.println("35 : " + ex);
			return "";
		}
	}
%>
<!doctype html>
<html>

  <head>
    <%@include file="/common/meta.jsp"%>
    <title>列表</title>
    <%@include file="/common/s3.jsp"%>
    <script type="text/javascript">
$(function() {
    $("#tree-listForm").validate({
        submitHandler: function(form) {
			bootbox.animate(false);
			var box = bootbox.dialog('<div class="progress progress-striped active" style="margin:0px;"><div class="bar" style="width: 100%;"></div></div>');
            form.submit();
        },
        errorClass: 'validate-error'
    });
})
    </script>
  </head>

  <body>
    <%@include file="/header/party.jsp"%>

    <div class="row-fluid">
	  <%@include file="/menu/party.jsp"%>

	<!-- start of main -->
    <section id="m-main" class="col-md-10" style="padding-top:65px;">

      <div class="panel panel-default">
        <div class="panel-heading">
				  <i class="glyphicon glyphicon-list"></i>
					备份
				</div>

				<div class="panel-body">
					<form name="orgForm" method="post" action="backup-db.do" class="form-inline">
						<button class="btn btn-default"><spring:message code='org.tree.list.view' text='备份'/></button>
					</form>
				</div>
		  </div>

			<c:if test="${BackupState == true}">
				<div class="alert alert-info" role="alert">
					<button type="button" class="close" data-dismiss="alert" style="margin-right:30px;">×</button>
					<strong>备份成功</strong>
				</div>
			</c:if>

			<c:if test="${BackupState == false}">
				<div class="alert alert-info" role="alert">
					<button type="button" class="close" data-dismiss="alert" style="margin-right:30px;">×</button>
					<strong>备份失败</strong>
				</div>
			</c:if>

      <!-- <div class="panel panel-default">
        <div class="panel-heading">
		  	<i class="glyphicon glyphicon-list"></i>
		  	&nbsp;
			</div> -->

    </section>
	<!-- end of main -->
	</div>

  </body>

</html>

