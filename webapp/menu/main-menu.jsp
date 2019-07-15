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
    <!-- 个人中心 -->
    <li><a href="${tenantPrefix}/portal/index.do" class="${currentMenu == 'dashboard' ? 'active' : ''}"><i class="fa fa-user"></i>个人中心</a></li>

    <!-- 实验中心 -->
    <li data-toggle="collapse" href="#collapse-workhome"><a href="#"><i class="fa fa-flask"></i>实验中心</a></li>
    <ul id="collapse-workhome" class="nav navbar-nav panel-collapse collapse ${parentMenu == 'workhome' ? 'in' : ''}">
      <div class="submenu-title">我的实验</div>
      <li><a href="${tenantPrefix}/bpm/workspace-home.do" class="${currentMenu == 'dashboard' ? 'workspace-home' : ''}"><i class="fa fa-dot-circle"></i>发起实验</a></li>
      <li><a href="${tenantPrefix}/bpm/workspace-listRunningProcessInstances.do" class="${currentMenu == 'workspace-listRunningProcessInstances' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>进行中实验</a></li>
      <li><a href="${tenantPrefix}/bpm/workspace-listCompletedProcessInstances.do" class="${currentMenu == 'workspace-listCompletedProcessInstances' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>结束实验</a></li>
      <li><a href="${tenantPrefix}/bpm/workspace-listInvolvedProcessInstances.do" class="${currentMenu == 'workspace-listInvolvedProcessInstances' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>参与的实验</a></li>
      <li><a href="${tenantPrefix}/operation/process-operation-listDrafts.do" class="${currentMenu == 'process-operation-listDrafts' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>草稿箱</a></li>
      <div class="submenu-title">我的任务</div>
      <li><a href="${tenantPrefix}/humantask/workspace-personalTasks.do" class="${currentMenu == 'workspace-personalTasks' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>待办任务</a></li>
      <li><a href="${tenantPrefix}/humantask/workspace-groupTasks.do" class="${currentMenu == 'workspace-groupTasks' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>待领任务</a></li>
      <li><a href="${tenantPrefix}/humantask/workspace-historyTasks.do" class="${currentMenu == 'workspace-historyTasks' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>已办任务</a></li>
      <li><a href="${tenantPrefix}/humantask/workspace-delegatedTasks.do" class="${currentMenu == 'workspace-delegatedTasks' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>经手任务</a></li>
      <div class="submenu-title">规则设置</div>
      <li><a href="${tenantPrefix}/delegate/delegate-listMyDelegateInfos.do" class="${currentMenu == 'delegate-listMyDelegateInfos' ? 'active' : ''}"><i class="fa fa-dot-circle"></i>代理规则</a></li>
    </ul>


    <!-- 设备管理 -->
    <li><a href="${tenantPrefix}/device/index.do" class="${currentMenu == 'device' ? 'active' : ''}"><i class="fa fa-server"></i>设备管理</a></li>

    <!-- 文件管理 -->
    <li data-toggle="collapse" href="#collapse-disk"><a href="#"><i class="fa fa-file-alt"></i>文件管理</a></li>
    <ul id="collapse-disk" class="nav navbar-nav panel-collapse collapse ${parentMenu == 'disk' ? 'in' : ''}">
      <li><a href="${tenantPrefix}/disk/index.do" class="${currentMenu == 'disk-home' ? 'active' : ''}"><i class="fa fa-database"></i>数据管理</a></li>
      <li><a href="${tenantPrefix}/disk/disk-process.do" class="${currentMenu == 'disk-process' ? 'active' : ''}"><i class="fa fa-video"></i>数据处理</a></li>
      <li><a href="${tenantPrefix}/disk/disk-analysis.do" class="${currentMenu == 'disk-analysis' ? 'active' : ''}"><i class="fa fa-chart-pie"></i>数据分析</a></li>
      <!--<li><a href="${tenantPrefix}/disk/disk-extapp.do" class="${currentMenu == 'disk-extapp' ? 'active' : ''}"><i class="fa-app-store"></i>外程序管理</a></li>-->
    </ul>

    <!-- 实验统计 -->
    <li><a href="${tenantPrefix}/report/view.do?code=mostActiveProcess" class="${currentMenu == 'chart' ? 'active' : ''}"><i class="fa fa-chart-line"></i>实验统计</a></li>
    
    <!-- 实验交流 -->
    <li><a href="${tenantPrefix}/cms/view"><i class="fa fa-comments"></i>实验交流</a></li>
    
    <!-- 系统配置 -->
    <li data-toggle="collapse" href="#collapse-system"><a href="#" class="${currentMenu == 'chart1' ? 'active' : ''}"><i class="fa fa-cogs"></i>系统配置</a></li>
    <ul id="collapse-system" class="nav navbar-nav panel-collapse collapse ${currentMenu == 'pim-schedule' ? 'in' : ''}">
      <li><a href="${tenantPrefix}/user/account-info-list.do"><i class="fa fa-dot-circle"></i>用户管理</a></li>
      <li><a href="${tenantPrefix}/bpm/bpm-process-list.do"><i class="fa fa-dot-circle"></i>实验管理</a></li>
      <li><a href="${tenantPrefix}/cms/cms-catalog-list.do"><i class="fa fa-dot-circle"></i>实验问答</a></li>
      <li><a href="${tenantPrefix}/template/template-info-list.do"><i class="fa fa-dot-circle"></i>系统服务</a></li>
    </ul>
  </ul>
</div>