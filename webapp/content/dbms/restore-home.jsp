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
		<section id="m-main" class="col-md-10" style="padding-top:65px;">

			<div class="panel panel-default">
				<div class="panel-heading">
					<i class="glyphicon glyphicon-list"></i>
					恢复
				</div>

				<div class="panel-body">
					<form name="orgForm" method="post" action="restore-db.do" class="form-inline">
						<button class="btn btn-default"><spring:message code='org.tree.list.view' text='恢复'/></button>
					</form>
				</div>
			</div>
			
			<c:if test="${RestoreState == true}">
				<div class="alert alert-info" role="alert">
					<button type="button" class="close" data-dismiss="alert" style="margin-right:30px;">×</button>
					<strong>恢复成功</strong>
				</div>
			</c:if>

			<c:if test="${RestoreState == false}">
				<div class="alert alert-info" role="alert">
					<button type="button" class="close" data-dismiss="alert" style="margin-right:30px;">×</button>
					<strong>恢复失败</strong>
				</div>
			</c:if>

		<!-- <div class="panel panel-default">
			<div class="panel-heading">
				<i class="glyphicon glyphicon-list"></i>
				&nbsp;
			</div>
		</div> -->

		</section>
	<!-- end of main -->
	</div>

  </body>

</html>

