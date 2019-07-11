<%@ page language="java" pageEncoding="UTF-8" %>
<style type="text/css">
#accordion .panel-heading {
	cursor: pointer;
}
#accordion .panel-body {
	padding:0px;
}
</style>

      <!-- start of sidebar -->
<div class="panel-group col-md-2" id="accordion" role="tablist" aria-multiselectable="true" >

  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
	    <i class="glyphicon glyphicon-list"></i>
        账号管理
      </h4>
    </div>
    <div id="collapse-body-user" class="panel-collapse collapse ${currentMenu == 'user' ? 'in' : ''}" role="tabpanel" aria-labelledby="collapse-header-user">
      <div class="panel-body">
        <ul class="nav nav-list">
		  <li><a href="${tenantPrefix}/user/account-info-list.do"><i class="glyphicon glyphicon-list"></i> 账号列表</a></li>
		  <li><a href="${tenantPrefix}/user/account-info-input.do"><i class="glyphicon glyphicon-list"></i> 添加账号</a></li>
	    </ul>
	  </div>
    </div>
  </div>

  <!--
  <div class="panel panel-default" style="margin-top:20px;">
    <div class="panel-heading" role="tab" id="collapse-header-user-import" data-toggle="collapse" data-parent="#accordion" href="#collapse-body-user-import" aria-expanded="true" aria-controls="collapse-body-user">
      <h4 class="panel-title">
	    <i class="glyphicon glyphicon-list"></i>
        导入导出
      </h4>
    </div>
    <div id="collapse-body-user" class="panel-collapse collapse ${currentMenu == 'user' ? 'in' : ''}" role="tabpanel" aria-labelledby="collapse-header-user">
      <div class="panel-body">
        <ul class="nav nav-list">
		  <li><a href="${tenantPrefix}/user/dev/import-view.do"><i class="glyphicon glyphicon-list"></i> 批量导入</a></li>
		  <li><a href="${tenantPrefix}/user/dev/export-view.do"><i class="glyphicon glyphicon-list"></i> 批量导出</a></li>
        </ul>
      </div>
    </div>
  </div>
  -->

		<footer id="m-footer" class="text-center">
		  <hr>
		  2019 &copy; lemon, by Diana
		</footer>

</div>
      <!-- end of sidebar -->

