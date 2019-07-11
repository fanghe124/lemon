<%@ page language="java" pageEncoding="UTF-8" %>
      <!-- start of sidebar -->
<style type="text/css">
#accordion .panel-heading {
	cursor: pointer;
}
#accordion .panel-body {
	padding:0px;
}
</style>

<div class="panel-group col-md-2 menu-container" id="accordion" role="tablist" aria-multiselectable="true">
    <!--<div class="panel panel-default">
        <div class="panel-heading" role="tab" id="collapse-header-schedule" data-toggle="collapse" data-parent="#accordion" href="#collapse-body-schedule" aria-expanded="true" aria-controls="collapse-body-delegate">
          <h4 class="panel-title">
          <i class="glyphicon glyphicon-list"></i>
            日程管理
          </h4>
        </div>
        <div id="collapse-body-schedule" class="panel-collapse collapse ${currentMenu == 'pim-schedule' ? 'in' : ''}" role="tabpanel" aria-labelledby="collapse-header-schedule">
          <div class="panel-body">
            <ul class="nav nav-list">
          <li><a href="${tenantPrefix}/pim/pim-schedule-list.do"><i class="glyphicon glyphicon-list"></i> 管理日程</a></li>
          <li><a href="${tenantPrefix}/pim/pim-schedule-view.do"><i class="glyphicon glyphicon-list"></i> 日程视图</a></li>
            </ul>
          </div>
        </div>
      </div>
    
    <div class="list-group" id="list-tab" role="tablist">
        <a class="list-group-item list-group-item-action active" id="list-home-list" data-toggle="list" href="#list-home" role="tab" aria-controls="home">个人中心</a>
        <a class="list-group-item list-group-item-action" id="list-profile-list" data-toggle="list" href="#list-profile" role="tab" aria-controls="profile">设备管理</a>
        <a class="list-group-item list-group-item-action" id="list-messages-list" data-toggle="list" href="#list-messages" role="tab" aria-controls="messages">文件管理</a>
        <a class="list-group-item list-group-item-action" id="list-settings-list" data-toggle="list" href="#list-settings" role="tab" aria-controls="settings">实验统计</a>
        <a class="list-group-item list-group-item-action" id="list-settings-list" data-toggle="list" href="#list-settings" role="tab" aria-controls="settings">实验交流</a>
        <a class="list-group-item list-group-item-action" id="list-settings-list" data-toggle="list" href="#list-settings" role="tab" aria-controls="settings">系统配置</a>
      </div>
    -->
    
  <ul class="nav navbar-nav">
    <li data-toggle="collapse" href="#collapse-body-schedule">
      <a href="${tenantPrefix}/portal/index.do"><i class="fa fa-user"></i>个人中心</a>
      
    </li>
    <li><a href="${tenantPrefix}/bpm/workspace-home.do"><i class="fa fa-flask"></i>实验中心</a></li>
    <li><a href="${tenantPrefix}/pim/pim-schedule-list.do"><i class="fa fa-server"></i>设备管理</a></li>
    <li data-toggle="collapse" href="#collapse-disk">
      <a href="${tenantPrefix}/pim/pim-schedule-list.do"><i class="fa fa-file-alt"></i>文件管理</a>
      <i class="icon-arrow-down"></i>
      <ul id="collapse-disk" class="nav navbar-nav panel-collapse collapse ${currentMenu == 'pim-schedule' ? 'in' : ''}">
        <li><a href="index.html"><i class="fa fa-chart-line menu-icon"></i>数据管理</a></li>
        <li><a href="index2.html"><i class="fa fa-chart-line menu-icon"></i>数据处理</a></li>
        <li><a href="index2.html"><i class="fa fa-chart-line menu-icon"></i>数据分析</a></li>
      </ul>
    
    
    </li>

    <li><a href="${tenantPrefix}/pim/pim-schedule-list.do"><i class="fa fa-chart-line"></i>实验统计</a></li>
    <li><a href="${tenantPrefix}/cms/cms-site-view.do"><i class="fa fa-comments"></i>实验交流</a></li>
    <li><a href="${tenantPrefix}/pim/pim-schedule-list.do"><i class="fa fa-cogs"></i>系统配置</a></li>
  </ul>
</div>