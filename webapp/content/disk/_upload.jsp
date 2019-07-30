<%@page contentType="text/html;charset=UTF-8"%>
<div>
  <div class="panel panel-default">
    <div class="panel-body">
      <form name="disk-searchForm" method="post" action="index.do" class="form-inline">
        <label for="disk-search_username"><spring:message code='disk-info.disk-info.list.search.name' text='用户名'/>:</label>
        <input type="text" id="disk-search_username" name="filter_LIKES_username" value="${param.filter_LIKES_username}" class="form-control" style="margin-right: 20px; width: 120px;">
        <label for="disk-search_location"><spring:message code='disk-info.disk-info.list.search.name' text='地点'/>:</label>
        <input type="text" id="disk-search_location" name="filter_LIKES_location" value="${param.filter_LIKES_location}" class="form-control" style="margin-right: 20px; width: 120px;">
        <!--<label for="disk-search_tyle"><spring:message code='disk-info.disk-info.list.search.name' text='管理类别'/>:</label>
        <select style="width: 50%; text-align: center; height: 35px;">
          <option value="shiyan">实验数据</option>
        </select>-->
        <label for="disk-search_time"><spring:message code='disk-info.disk-info.list.search.name' text='最近更新时间'/>:</label>
        <input type="text" id="txtStartDate" name="filter_LIKES_startdate" value="${param.filter_LIKES_startdate}" style="padding: 6px 3px;" /> 
        &nbsp; ~ &nbsp;
        <input type="text" id="txtEndDate" name="filter_LIKES_enddate" value="${param.filter_LIKES_enddate}" style="padding: 6px 3px;"/>
        <label for="disk-search_filename" style="margin-left: 30px"><spring:message code='disk-info.disk-info.list.search.name' text='文件名'/>:</label>
        <input type="text" id="disk-search_filename" name="filter_LIKES_name" value="${param.filter_LIKES_name}" class="form-control">
        <button class="btn btn-default a-search fixed-button" style="right:10%; position:absolute;" onclick="document.disk-searchForm.submit()">查询</button>
      </form>
    </div>
  </div>

  <div class="form-inline">
    地点: <input type="text" id="locationInput" name="locationParam" value="${param.locationParam}" class="form-control" style="margin-right: 20px;">
    <button id="uploadFileButton" class="btn btn-default fixed-button fileinput-button">
      上传文件
    </button>
    <button id="createDirButton" class="btn btn-default fixed-button" data-toggle="modal" data-target="#createDirDialog">新建文件夹</button>
    <button id="createShareButton" class="btn btn-default fixed-button" data-toggle="modal" data-target="#createShareDialog" onclick="$('#createShareInfoId').val($('.selectedItem').val())">共享</button>
    <button id="removeDirButton" class="btn btn-default fixed-button" data-toggle="modal" data-target="#removeDirDialog" onclick="$('#removeDirInfoId').val($('.selectedItem').val())">删除</button>
    <a class="btn btn-default fixed-button"  href="${tenantPrefix}/disk/index.do">更新</a>
  </div>
</div>

<div style="margin-top:10px;margin-bottom:10px;" class="clearfix">
  <div class="pull-left">
<c:if test="${not empty path}">
  <a href="disk-index-parentDir.do?path=${path}">返回上一级</a>
  |
  <%
  String path = (String) request.getAttribute("path");
	String currentPath = "";
	String[] array = path.split("/");
	for (int i = 0; i < array.length; i++) {
	  String item = array[i];
      if (i != 0) {
        currentPath += "/" + item;
      }
	  pageContext.setAttribute("item", item);
	  pageContext.setAttribute("currentPath", currentPath);
	  if (i < array.length - 1) {
  %>
  <a href="?path=${currentPath}">${item == '' ? '根目录' : item}</a>
  /
  <%
	  } else {
  %>
	    ${item}
  <%
      }
    }
  %>
</ol>
</c:if>
  </div>
  <div class="pull-right">
    	
  </div>
</div>

<div id="uploadFileProgress" class="modal fade" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">上传文件</h4>
      </div>
      <div class="modal-body">
        <div class="form-inline">
          <div class="row" style="margin: 5px 0px;">
            <div class="col-md-1"></div>
            <div class="col-md-1" style="padding: 6px 0px">名称:</div>
            <div class="col-md-9"><input type="text" id="nameInput" name="nameParam" value="${param.nameParam}" class="form-control" style="width: 100%;"></div>
          </div>
          <div class="row" style="margin: 5px 0px;">
            <div class="col-md-1"></div>
            <div class="col-md-1" style="padding: 6px 0px">文件:</div>
            <div class="col-md-6"><label id="fileInput" name="fileParam" value="${param.fileParam}" class="form-control" style="width: 100%;"></label></div>
            <div class="col-md-3"><button id="openFileDialog" class="btn btn-default" style="width: 100%;">选择文件</button></div>
            <input type="file" name="file" id="selectFileDialog" style="display: none" class="fileupload" data-no-uniform="true" data-url="upload.do" data-form-data='{"path":"${path}","spaceId":"${diskSpace.id}"}'>          </div>
          <div class="row" style="margin: 5px 0px;">
            <div class="col-md-1"></div>
            <div class="col-md-1" style="padding: 6px 0px">描述:</div>
            <div class="col-md-9"><textarea id="descInput" name="descParam" value="${param.descParam}" rows="5" style="width: 100%;"></textarea></div>
          </div>
        </div>
        <div style="height: 50px; padding-top: 20px">
          <div class="progress" style="display: none">
            <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
            <span class="sr-only">0%</span>
            </div>
          </div>
        </div>
      </div>
     
      <div class="modal-footer">
        <button id="uploadFile" class="btn btn-primary"><i class="fa fa-cloud-upload-alt"></i>  上传</button>
        <button id="uploadFileConfirmButton" type="button" class="btn btn-primary" onclick="location.reload()">确认</button>
        <button id="uploadFileCancelButton" type="button" class="btn btn-default" data-dismiss="modal" onclick="location.reload()">取消</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div id="createDirDialog" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
    <form action="create-dir.do" method="post">
      <input type="hidden" name="path" value="${path}">
      <input type="hidden" name="spaceId" value="${diskSpace.id}">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">创建目录</h4>
      </div>
      <div class="modal-body">
        <input type="text" class="form-control" id="dirName" placeholder="目录名" name="name">
      </div>
      <div class="modal-footer">
        <button id="uploadFileCancelButton" type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button id="uploadFileConfirmButton" type="submit" class="btn btn-primary">保存</button>
      </div>
    </form>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div id="removeDirDialog" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
    <form action="remove-dir.do" method="post">
      <input type="hidden" name="infoId" value="" id="removeDirInfoId">
      <input type="hidden" name="spaceId" value="${diskSpace.id}">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">删除</h4>
      </div>
      <div class="modal-body" style="font-size: 16px;">
        你确定删除吗?
      </div>
      <div class="modal-footer">
        <button id="uploadFileCancelButton" type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button id="uploadFileConfirmButton" type="submit" class="btn btn-primary">确认</button>
      </div>
    </form>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<link rel="stylesheet" href="${cdnPrefix}/public/jquery-file-upload/5.42.0/css/jquery.fileupload.css">
<script src="${cdnPrefix}/public/jquery-file-upload/5.42.0/js/vendor/jquery.ui.widget.js"></script>
<script src="${cdnPrefix}/public/jquery-file-upload/5.42.0/js/jquery.iframe-transport.js"></script>
<script src="${cdnPrefix}/public/jquery-file-upload/5.42.0/js/jquery.fileupload.js"></script>

<script type="text/javascript">
$("#selectFileDialog").change(function(){
  $("#fileInput").text(this.files[0].name);
});
$('#uploadFileButton').click(function(){
  if($.trim($('#locationInput').val()) == ''){
    alert('请输入地点');
    $('#locationInput').focus();
  } else {
    $('#uploadFileProgress').modal('show');
    //$('#selectFileDialog').click();
  }
});
$('#openFileDialog').click(function(){
  $('#selectFileDialog').click();
});
function generateFileupload(maxLimitedSize) {
  $('.fileupload').fileupload({
    dataType: 'json',
    maxFileSize: 100000000,
    add: function (e, data) {
      var file = data.files[0];
      if (file.size > maxLimitedSize) {
        alert("图片过大");
      } else {
        $("#uploadFile").off('click').on('click', function () {
          $(".progress").css('display','');
          data.submit();
        });
      }
    },
		submit: function (e, data) {
			var $this = $(this);
			data.formData = {
				lastModified: data.files[0].lastModified,
				path: '${path}',
        spaceId: '${diskSpace.id}',
        location: $('#locationInput').val()
			};
			data.jqXHR = $this.fileupload('send', data);
			$('.progress-bar').css(
        'width',
        '0%'
      ).html('0%');
			$('#uploadFileConfirmButton').hide();
			$('#uploadFileProgress').modal('show');
			return false;
		},
    done: function (e, data) {
			$('#uploadFileConfirmButton').show();
			// location.reload();
        },
		fail: function (e, data) {
			alert("上传失败");
		},
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('.progress-bar').css(
                'width',
                progress + '%'
            ).html(progress + '%');
        }
    });
}

$(function () {
	generateFileupload(1024 * 1024 * 1024);
  $('#txtStartDate, #txtEndDate').datepicker({
    showOn: "button",
    buttonImage: "${cdnPrefix}/public/mossle/0.0.11/img/calendar.png",
    buttonImageOnly: true,
    buttonText: "Choose",
    showAnim: "fade",
    beforeShow: customRange,
    dateFormat: "yy-m-dd",
  });
});

function customRange(input) {
  if (input.id == 'txtEndDate') {
    var minDate = new Date($('#txtStartDate').val());
    minDate.setDate(minDate.getDate() + 1)
    return {
        minDate: minDate
    };
  }
  return {}
}

</script>

  <link href="${cdnPrefix}/public/select2/4.0.5/css/select2.min.css" rel="stylesheet" />
  <script src="${cdnPrefix}/public/select2/4.0.5/js/select2.min.js"></script>
<div id="createShareDialog" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
    <form action="create-share.do" method="post">
      <input type="hidden" name="infoId" value="" id="createShareInfoId">
      <input type="hidden" name="mask" value="15">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">共享</h4>
      </div>
      <div class="modal-body">
        <div>
          路径: 个人文件/xxx
        </div>
        <div>
          <div style="float:left;">用户:</div>
          <select class="form-control" id="username_search" name="username" style="float:left;width:200px;clear:none;" multiple></select>
        </div>
        <table class="table">
        <thead>
          <tr>
            <th>用户</th>
            <th>权限</th>
            <th>有效期</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>用户</td>
            <td>显示/预览/下载/复制</td>
            <td>永久有效</td>
            <td><i class="glyphicon glyphicon-remove"></i></td>
          </tr>
        </tbody>
      </table>
      </div>
      <div class="modal-footer">
        <button id="createShareCancelButton" type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button id="createShareConfirmButton" type="submit" class="btn btn-primary">保存</button>
      </div>
    </form>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<script>
  $('#username_search').select2({
    ajax: {
      url: '${ctx}/localuser/rs/search/select2',
      dataType: 'json'
    }
  });
</script>



