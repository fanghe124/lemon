<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<%pageContext.setAttribute("currentHeader", "report");%>
<%pageContext.setAttribute("currentMenu", "chart");%>
<!doctype html>
<html lang="en">

  <head>
    <%@include file="/common/meta.jsp"%>
    <title>报表</title>
    <%@include file="/common/s3.jsp"%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
	<title>index</title> 
	<!-- 引入样式 -->
	<link rel="stylesheet" href="${cdnPrefix}/public/mossle-device/index.css">
	<link rel="stylesheet" href="${cdnPrefix}/public/mossle-device/device.css">
	<!-- 引入组件库 -->
	<script src='${cdnPrefix}/public/mossle-device/vue.js' type='text/javascript'></script>
	<script src='${cdnPrefix}/public/mossle-device/index.js' type='text/javascript'></script>
	
  </head>

  <body>
    <%@include file="/header/report.jsp"%>
    <div id="app1">
    <div class="panel-group col-md-2" id="accordion" role="tablist" aria-multiselectable="true" style="padding-top:65px;">

		  <div class="panel panel-default">
		    <div class="panel-heading" role="tab" id="collapse-header-report" data-toggle="collapse" data-parent="#accordion" href="#collapse-body-report" aria-expanded="true" aria-controls="collapse-body-bpm-process">
		      <h4 class="panel-title">
			    <i class="glyphicon glyphicon-list"></i>
		        	实验计划
		      </h4>
		    </div>
		    <div id="collapse-body-report" class="panel-collapse " role="tabpanel" aria-labelledby="collapse-header-report">
		      <div class="panel-body">
		        <ul class="nav nav-list">
		          <li @click="setTable('plan')"><a ><i class="glyphicon glyphicon-list"></i>我的实验计划</a></li>
			      <li @click="setTable('week-plan')"><a ><i class="glyphicon glyphicon-list"></i>我的实验周计划</a></li>
			      <li @click="setTable('task')"><a ><i class="glyphicon glyphicon-list"></i>我的任务</a></li>
		        </ul>
		      </div>
		    </div>
		  </div>
		</div>
	    <div id="app" style="padding-top:60px;" class="col-md-10">
			<el-row :gutter="0">
			  <el-col :span="24">
			    <div style="background-color: #fff;height:100%;margin-top:15px;padding:0 10px;">
						<el-button
					          size="mini" 
					          v-if="currentType === 'plan' || currentType === 'week-plan'"
					          @click="setDialogForm()" >填加</el-button>
					<div >
					<el-table id="plan-list-id"
					:data="planTableData"
					style="width: 100%" >
					      <el-table-column prop="id" label="id" v-if="flag"></el-table-column>
					      <el-table-column prop="process" label="实验" show-overflow-tooltip="true"></el-table-column>
					      <el-table-column prop="stage" label="阶段" 
					      v-if="currentType === 'plan' || currentType === 'task'"></el-table-column>
					      <el-table-column prop="user" label="用户" ></el-table-column>
					      <el-table-column prop="time" label="时间"></el-table-column>
					      <el-table-column prop="content" label="计划内容" v-if="false"></el-table-column>
					      <el-table-column prop="type" label="类型" v-if="currentType === 'task'"></el-table-column>
					      <el-table-column prop="status" label="状态"></el-table-column>
				          <el-table-column label="操作" width="150">
					      <template slot-scope="scope">
					        <el-button
					          size="mini"
					          type="danger"
					          @click="handleDelete(scope.$index, scope.row)">删除</el-button>
					        <el-button
					          size="mini"
					          v-if="currentType === 'plan' || currentType === 'week-plan'"
					          @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
					          <el-button
					          v-if="currentType === 'task'"
					          size="mini"
					          @click="handleDone(scope.$index, scope.row)">完成</el-button>
					      </template>
					    </el-table-column>
				    </el-table>
			           <el-pagination background  v-show="filterTableData.length>5" 
			              @current-change="handleCurrentChange"
					      @size-change="handleSizeChange" 
					      :current-page="currentPage"
					      :page-sizes="[5,30,50,100,500]"
					      :page-size="pageSize"
					      layout="total, sizes, prev, pager, next"
					      :total="totalSize" style="margin-top:15px;float:right">
					    </el-pagination>
				</div>
			    </div>
			  </el-col>
			</el-row>
			
			<el-dialog
			  title="完成实验计划"
			  :visible.sync="dialogVisible2"
			  width="30%"
			  >
			  <span>{{selectedContent}}</span>
			  <span slot="footer" class="dialog-footer">
			    <el-button @click="dialogVisible = false">取 消</el-button>
			    <el-button type="primary" @click="dialogVisible2 = false">确 定</el-button>
			  </span>
			</el-dialog>
			
			<el-dialog title="实验计划信息" :visible.sync="dialogFormVisible" @close="closeDialog">
			  <el-form :model="form" >
			    <el-form-item label="实验" :label-width="formLabelWidth">
			      <el-select v-model="process" placeholder="请选择">
				    <el-option
				      v-for="item in processList"
				      :key="item.processName"
				      :label="item.processName"
				      :value="item.processName">
				    </el-option>
				  </el-select>
			    </el-form-item>
			    <el-form-item label="时间" :label-width="formLabelWidth" v-if="currentType === 'plan'">
			        <el-date-picker
				      v-model="timeDay"
				      type="date"
				      value-format="yyyy-MM-dd"
				      format="yyyy-MM-dd"
				      placeholder="选择日期">
				    </el-date-picker>
			    </el-form-item>
			    <el-form-item label="周时间" :label-width="formLabelWidth" v-if="currentType === 'week-plan'">
			          <el-date-picker
					    v-model="timeWeek"
					    type="week"
					    format="yyyy 第 WW 周"
					    @change="getMyDateTime(timeWeek)"
					    placeholder="选择周">
					  </el-date-picker>
			    </el-form-item>
			    <el-form-item label="用户" :label-width="formLabelWidth">
			      <el-select v-model="user" placeholder="请选择">
				    <el-option
				      v-for="item in userList"
				      :key="item.userName"
				      :label="item.userName"
				      :value="item.userName">
				    </el-option>
				  </el-select>
			    </el-form-item>
			    <el-form-item label="阶段" :label-width="formLabelWidth" v-if="currentType === 'plan'">
			        <el-select v-model="stageValue" placeholder="请选择">
				    <el-option
				      v-for="item in options"
				      :key="item.value"
				      :label="item.label"
				      :value="item.value">
				    </el-option>
				  </el-select>
			    </el-form-item>
			    <el-form-item label="计划内容" :label-width="formLabelWidth">
			        <el-input
					  type="textarea"
					  :rows="2"
					  placeholder="请输入内容"
					  v-model="content">
					</el-input>
			    </el-form-item>
			  </el-form>
			  <div slot="footer" class="dialog-footer">
			    <el-button @click="dialogFormVisible = false">取 消</el-button>
			    <el-button type="primary" @click="savePlanInfo">确 定</el-button>
			  </div>
			</el-dialog>
	  </div>
	  </div>
<script src='${cdnPrefix}/public/mossle-plan/plan.js' type='text/javascript'></script>

  </body>

</html>
