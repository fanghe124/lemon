<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<%pageContext.setAttribute("parentMenu", "disk");%>
<%pageContext.setAttribute("currentMenu", "disk-home");%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <title>文件管理</title>
    <%@include file="/common/s3.jsp"%>
    <link rel="stylesheet" href="${cdnPrefix}/public/mossle-disk/0.0.3/sprite_list_icon.css">
    <link rel="stylesheet" href="${cdnPrefix}/public/jquery-ui/1.12.0/themes/themes/smoothness/jquery-ui.css">
    <script src="${cdnPrefix}/public/jquery-ui/1.12.0/ui/jquery-ui.js"></script>
	  <style type="text/css">
.text-left .disk-tool {
	display: none;
	float: right;
}
.text-left.active .disk-tool {
	display: inline-block;
}
.ui-datepicker-trigger {
  margin-left: -23px;
}
.ui-datepicker {
	width: 17em;
	padding: .2em .2em 0;
	display: none;
    background:#846733;  
}
.ui-datepicker .ui-datepicker-title {
	margin: 0 2.3em;
	line-height: 1.8em;
	text-align: center;
    color:#FFFFFF;
    background:#846733;  
}
.ui-datepicker table {
	width: 100%;
	font-size: .7em;
	border-collapse: collapse;
    font-family:verdana;
	margin: 0 0 .4em;
    color:#000000;
    background:#FDF8E4;    
}
.ui-datepicker td {
	border: 0;
	padding: 1px;
}
.ui-datepicker td span,
.ui-datepicker td a {
	display: block;
	padding: .8em;
	text-align: right;
	text-decoration: none;
}
</style>
  </head>
  <body>
    <%@include file="/header/portal.jsp"%>
    <div id="wrap">
      <div id="top">
        <div class="row-fluid">
		      <%@include file="/menu/main-menu.jsp"%>

          <div class="col-md-10">
            <div class="alert-fixed-top" data-alerts="alerts" data-titles="{}" data-ids="myid" data-fade="1000"></div>
            
            <%pageContext.setAttribute("listType", "list");%> 
            <%@include file="_upload.jsp"%>

    <table id="tablereimburserecord1" class="table table-hover table-bordered">
      <thead>
        <tr>
          <th class="m-table-check"><input type="checkbox" name="checkAll" onchange="toggleSelectedItems(this.checked)"></th>
          <th class="col-md-4 text-left">文件名</th>
          <th class="col-md-1 text-left">大小</th>
          <!--<th class="col-md-2 text-left">管理类别</th>-->
          <th class="col-md-1 text-left">创建人</th>
          <th class="col-md-1 text-left">地方</th>
          <th class="col-md-2 text-left">创建时间</th>
          <th class="col-md-1 text-left">最近更新人</th>
          <th class="col-md-2 text-left">最近更新时间</th>
        </tr>
      </thead>
      <tbody id="tbodyFileInfo">
	      <c:forEach items="${diskInfos}" var="item">
        <tr>
          <td><input type="checkbox" class="selectedItem a-check" name="selectedItem" value="${item.id}"></td>
          <td class="text-left" onmouseover="this.className='text-left active'" onmouseout="this.className='text-left'">
		        <i class="icon-16 icon-16-${item.type}"></i>
			      <c:if test="${item.type == 'dir'}">
			      <a href="index.do?path=${path}/${item.name}">
		          <span class="file-16-name">${item.name}</span>
			      </a>
			      </c:if>
			      <c:if test="${item.type != 'dir'}">
		        <a data-target="#contentPreviewDialog" data-toggle="modal" href="disk-info-view.do?id=${item.id}">
			        <span class="file-16-name">${item.name}</span>
			      </a>
			      </c:if>
          
          </td>
          <td class="text-left"><tags:fileSize fileSize="${item.fileSize}"/></td>
          <td class="text-left">${item.username}</td>
          <td class="text-left">${item.location}</td>
          <td class="text-left"><fmt:formatDate value="${item.createTime}" type="both"/></td>
          <td class="text-left">${item.username}</td>
          <td class="text-left"><fmt:formatDate value="${item.lastModifiedTime}" type="both"/></td>
        </tr>
		    </c:forEach>
      </tbody>
    </table>

<!-- Modal HTML -->
<div id="contentPreviewDialog" class="modal fade come-from-modal right" tabindex="-1">
  <div class="modal-dialog">
      <div class="modal-content" style="background-color: #FeFeFe">
          <div class="modal-header">
              <h5 class="modal-title">Preview</h5>
              <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <div class="modal-body"></div>
      </div>
  </div>
</div>

<div id="removeDialog" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
	  <form action="disk-info-remove.do" method="post">
	  <input type="hidden" name="path" value="${path}">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">确认删除？</h4>
      </div>
      <div class="modal-footer">
	  <form action="disk-info-remove.do">
	    <input id="removeId" type="hidden" name="id" value="">
        <button id="removeCancelButton" type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button id="removeConfirmButton" type="submit" class="btn btn-primary">确认</button>
	  </form>
      </div>
	  </form>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script type="text/javascript">
function removeFile(id) {
	$('#removeId').val(id);
	$('#removeDialog').modal("show");
}
</script>

<div id="moveDialog" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
	  <form action="disk-info-move.do" method="post">
	  <input id="moveId" type="hidden" name="id" value="">
	  <input id="moveParentId" type="hidden" name="parentId" value="">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">移动</h4>
      </div>
      <div class="modal-body">
	    <ul id="moveFileTree" class="ztree"></ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button type="submit" class="btn btn-primary">保存</button>
      </div>
	  </form>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div id="shareDialog" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
	  <form action="disk-info-share.do" method="post">
	  <input id="shareId" type="hidden" name="id" value="">
	  <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">分享</h4>
      </div>
      <div class="modal-body">
        <p>
          <button class="btn btn-default" name="type" value="public">公开分享</button>
        </p>
        <p>
          <button class="btn btn-default" name="type" value="private">私密分享</button>
        </p>
      </div>
	  </form>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script type="text/javascript">
var setting = {
	async: {
		enable: true,
		url: 'disk-info-tree.do'
	},
	callback: {
		onClick: function(event, treeId, treeNode) {
			$('#moveParentId').val(treeNode.id);
		}
	}
};

var zNodes =[];

function moveFile(id) {
	$('#moveId').val(id);
	$('#moveDialog').modal("show");
	
	$.fn.zTree.init($("#moveFileTree"), setting, zNodes);
}

function shareFile(id) {
	// location.href = 'disk-share-sharePublic.do?id=' + id;
	$('#shareId').val(id);
	$('#shareDialog').modal('show');
}

</script>

          </div>
        </div><!--/col-->
      </div><!--/row-->
      <hr class="soften">
    </div>

    <%@include file="_footer.jsp"%>

  </body>
</html>
