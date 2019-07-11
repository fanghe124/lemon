<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<%pageContext.setAttribute("currentHeader", "report");%>
<%pageContext.setAttribute("currentMenu", "device");%>
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
		<%@include file="/header/portal.jsp"%>
		<div id="app" class="row-fluid">
			<%@include file="/menu/main-menu.jsp"%>
			
			<section id="m-main" class="col-md-10">
				<el-row :gutter="0">
					<el-col :span="6">
						<div style="background-color: #fff;height:100%;padding-left:10px;">
						<div class="title-position" style="background-color: #f5f5f5;height:45px;line-height:45px;">设备种类</div>
						<el-table id="class-list-id" :data="classTableData" style="width: 100%" 
											ref="singleTable" @current-change="handleCurrentRowChange">
								<el-table-column prop="className" label="名称" >
											<template slot-scope="scope" >
										<span  :title="scope.row.className" style="cursor:pointer"  >{{ scope.row.classCutName}}</span>  
										<el-tag title="" type="danger" style="float:right">报废{{ scope.row.dump}}</el-tag>
										<el-tag title="" type="success" style="float:right">使用{{ scope.row.use}}</el-tag>
										<el-tag title="" style="float:right">空闲{{ scope.row.free}}</el-tag>
										</template>
								</el-table-column>
							</el-table>
						</div>
					</el-col>
					<el-col :span="18">
						<div style="background-color: #fff;height:100%;margin-top:15px;padding:0 10px;">
							<el-button
											size="mini" 
											@click="dialogFormVisible = true" >填加</el-button>
						<div v-if="showFlag">
						<el-table id="device-list-id"
						:data="deviceTableData"
						style="width: 100%" >
									<el-table-column prop="id" label="id" v-if="flag"></el-table-column>
									<el-table-column prop="name" label="名称" ></el-table-column>
									<el-table-column prop="number" label="编号" ></el-table-column>
									<el-table-column prop="deviceClass" label="类别" ></el-table-column>
									<el-table-column prop="status" label="状态" ></el-table-column>
									<el-table-column prop="nodeName" label="占用节点" ></el-table-column>
										<el-table-column label="操作" width="150">
									<template slot-scope="scope">
										<el-button
											size="mini"
											type="danger"
											@click="handleDelete(scope.$index, scope.row)">删除</el-button>
										<el-button
											size="mini"
											@click="handleEdit(scope.$index, scope.row)">编辑</el-button>
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
				<el-dialog title="设备信息" :visible.sync="dialogFormVisible" @close="closeDialog">
						<el-form :model="form" >
							<el-form-item label="设备名称" :label-width="formLabelWidth">
								<el-input v-model="form.name" autocomplete="off"></el-input>
							</el-form-item>
							<el-form-item label="设备编号" :label-width="formLabelWidth">
								<el-input v-model="form.number" autocomplete="off"></el-input>
							</el-form-item>
							<el-form-item label="设备种类" :label-width="formLabelWidth">
								<el-input v-model="form.className" autocomplete="off"></el-input>
							</el-form-item>
							<el-form-item label="设备状态" :label-width="formLabelWidth">
									<el-select v-model="statusValue" placeholder="请选择">
								<el-option
									v-for="item in options"
									:key="item.value"
									:label="item.label"
									:value="item.value">
								</el-option>
							</el-select>
							</el-form-item>
						</el-form>
						<div slot="footer" class="dialog-footer">
							<el-button @click="dialogFormVisible = false">取 消</el-button>
							<el-button type="primary" @click="saveDeviceInfo">确 定</el-button>
						</div>
					</el-dialog>
			</section>
	  </div>
		<script src='${cdnPrefix}/public/mossle-device/device.js' type='text/javascript'></script>
  </body>
</html>
