<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<%pageContext.setAttribute("currentHeader", "party");%>
<%pageContext.setAttribute("currentMenu", "party");%>
<!doctype html>
<html>

  <head>
    <%@include file="/common/meta.jsp"%>
    <title>列表</title>
    <%@include file="/common/s3.jsp"%>
  </head>

  <body>
    <%@include file="/header/party.jsp"%>

    <div class="row-fluid">
	  <%@include file="/menu/party.jsp"%>

	<!-- start of main -->
    <section id="m-main" class="col-md-10" >

      <div class="panel panel-default">
        <div class="panel-heading">
				  <i class="glyphicon glyphicon-list"></i>
					备份
				</div>

				<div class="panel-body">
					<form name="orgForm" method="post" action="backup-db.do" class="form-inline">
						<button class="btn btn-default" title="备份数据库不到1分钟完成"><spring:message code='org.tree.list.view' text='备份'/></button>
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

