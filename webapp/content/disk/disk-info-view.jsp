<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <title>文件管理</title>
    <%@include file="/common/s3.jsp"%>
	<link rel="stylesheet" href="${cdnPrefix}/public/mossle-disk/0.0.3/sprite_list_icon.css">
	<script type="text/javascript" src="${cdnPrefix}/public/jquery-qrcode/1.0/jquery.qrcode.min.js"></script>
	<style type="text/css">
body {
    padding-top: 50px;
}
	</style>
  </head>
  <body>
    <div id="wrap">&nbsp;

<%@include file="/header/_disk.jsp"%>

      <div class="container" style="padding: 0px 15px 0;" id="top">
        <div class="row">
          <div class="col-md-12">
            <div class="alert-fixed-top" data-alerts="alerts" data-titles="{}" data-ids="myid" data-fade="1000"></div>


<div class="row">
  <div class="col-md-12">
    <a href="index.do"><i class=" glyphicon glyphicon-arrow-left"></i>返回</a>
  </div>
  <div class="col-md-12 text-center">
    <i class="icon-62 icon-62-${diskInfo.type}"></i>
	<div>
      ${diskInfo.name}
	</div>
	<div>

<div class="btn-group" role="group" aria-label="...">
  <a href="disk-info-download.do?id=${diskInfo.id}" class="btn btn-default">下载</a>

  <div class="btn-group" role="group">
    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      二维码
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      <li><span id="qrcode"></span></li>
	  <script>
$('#qrcode').qrcode("<tags:baseUrl/>/disk/disk-info-download.do?id=${diskInfo.id}");
	  </script>
    </ul>
  </div>
</div>

	  <hr>
	</div>
  </div>
  <div class="col-md-12">
    <table class="table">
	  <tbody>
	    <tr>
	      <td class="col-md-3">文件类型</td>
	      <td class="col-md-3">${diskInfo.type}</td>
	      <td class="col-md-3">文件大小</td>
	      <td class="col-md-3"><tags:fileSize fileSize="${diskInfo.fileSize}"/></td>
		</tr>
	    <tr>
	      <td>创建人</td>
	      <td><tags:user userId="${diskInfo.creator}"/></td>
	      <td>创建时间</td>
	      <td><fmt:formatDate value="${diskInfo.createTime}" type="both"/></td>
		</tr>
	  </tbody>
	</table>
  <c:if test="${diskInfo.type == 'doc' || diskInfo.type == 'docx'}">
  	<iframe class="doc" src="https://docs.google.com/gview?url=${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}&embedded=true"></iframe>
  	</c:if>
  	<c:if test="${diskInfo.type == 'pdf'}">
  	  <div style="width:100%; height: 700px; background-color: #F9F9F9;">
	  <object src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="width:100%;height:100%;">
  	  	<embed src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="width:100%;height:100%;"></embed>
    </object>  	
      </div>
  </c:if>
  	<c:if test="${diskInfo.type == 'txt' || diskInfo.type == 'html'}">
  	  <nav style="width:100%; height: 700px; box-shadow: 0 0 0 10px #606060 inset; padding: 30px 30px; background-color: #F9F9F9;">
	  <object src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="width:100%;height:100%;">
  	  	<embed src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="width:100%;height:100%;"></embed>
    </object>  	
      </nav>
  </c:if>
  	<c:if test="${diskInfo.type == 'jpg' || diskInfo.type == 'jpeg' || diskInfo.type == 'png'}">
  	  <nav style="width:100%; box-shadow: 0 0 0 10px #606060 inset; padding: 30px 30px; background-color: #F9F9F9;">
  	<img src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}">
  	  </nav>
  </c:if>
  <c:if test="${diskInfo.type == 'mp4'}">
  	  <nav style="width:100%; box-shadow: 0 0 0 10px #606060 inset; padding: 30px 30px; background-color: #F9F9F9;">
	  <video controls style="width:100%;height:100%;">
	  <source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="video/webm">
	  <source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="video/ogg"> 
	  <source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="video/quicktime">
	</video>
	  </nav>
  </c:if>
  <c:if test="${diskInfo.type == 'mp3'}">
      <nav style="width:100%; box-shadow: 0 0 0 10px #606060 inset; padding: 30px 30px; background-color: #F9F9F9;">
	  <audio controls style="width:100%;height:100%;">
	  	<source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="audio/mpeg">
	    <source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="audio/ogg"> 
	    <source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="audio/mp3">
	  </audio>
	  </nav>
  </c:if>
</div>
</div>

          </div>
        </div><!--/col-->
      </div><!--/row-->
      <hr class="soften">
    </div>

    <%@include file="_footer.jsp"%>

  </body>
</html>
