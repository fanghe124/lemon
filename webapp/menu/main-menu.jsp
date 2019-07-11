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
  <ul class="nav navbar-nav">
    <li><a href="${tenantPrefix}/portal/index.do" class="${currentMenu == 'dashboard' ? 'active' : ''}"><i class="fa fa-user"></i>个人中心</a></li>
    <li><a href="${tenantPrefix}/bpm/workspace-home.do"><i class="fa fa-flask"></i>实验中心</a></li>
    <li><a href="${tenantPrefix}/pim/pim-schedule-list.do"><i class="fa fa-server"></i>设备管理</a></li>

    <li data-toggle="collapse" href="#collapse-disk"><a href="#"><i class="fa fa-file-alt"></i>文件管理</a></li>
    <ul id="collapse-disk" class="nav navbar-nav panel-collapse collapse ${currentMenu == 'pim-schedule' ? 'in' : ''}">
      <li><a href="${tenantPrefix}/disk/index.do"><i class="fa fa-chart-line menu-icon"></i>数据管理</a></li>
      <li><a href="${tenantPrefix}/disk/index.do"><i class="fa fa-chart-line menu-icon"></i>数据处理</a></li>
      <li><a href="${tenantPrefix}/disk/index.do"><i class="fa fa-chart-line menu-icon"></i>数据分析</a></li>
    </ul>

    <li><a href="${tenantPrefix}/report/view.do?code=mostActiveProcess" class="${currentMenu == 'chart' ? 'active' : ''}"><i class="fa fa-chart-line"></i>实验统计</a></li>
    <li><a href="${tenantPrefix}/cms/cms-site-view.do"><i class="fa fa-comments"></i>实验交流</a></li>
    <li><a href="${tenantPrefix}/pim/pim-schedule-list.do" class="${currentMenu == 'chart1' ? 'active' : ''}"><i class="fa fa-cogs"></i>系统配置</a></li>
  </ul>
</div>