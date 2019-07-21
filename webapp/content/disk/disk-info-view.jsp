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
	<link rel="stylesheet" href="${cdnPrefix}/public/mossle/0.0.11/css/style.css">
	<script type="text/javascript" src="${cdnPrefix}/public/jquery-qrcode/1.0/jquery.qrcode.min.js"></script>
  </head>
  <body>
    <div id="wrap" style="height: 100%">&nbsp;
      <div class="container" style="padding: 0px 40px; height: 95%" id="top">
        <div class="row">
          <div class="col-md-4"> <h2>${diskInfo.name} </h2></div>
          <div class="col-md-2" style="padding-top:20px"> <a href="disk-info-download.do?id=${diskInfo.id}" class="btn btn-default fixed-button">下载</a> </div>
					<div class="col-md-2" style="padding-top:20px"> 
						<button type="button" class="btn btn-default fixed-button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">获取二维码</button>
					</div>
					<ul class="dropdown-menu">
						<li><span id="qrcode"></span></li>
						<script>
							$('#qrcode').qrcode("<tags:baseUrl/>/disk/disk-info-download.do?id=${diskInfo.id}");
						</script>
					</ul>
				</div>
				
				<div class="row margin-30">
					<div class="col-md-3">
						文件大小:	&nbsp;
						<tags:fileSize fileSize="${diskInfo.fileSize}"/>
					</div>
					<div class="col-md-3">
						文件类型:	&nbsp;
					</div>
				</div>
				<div class="row margin-20">
					<div class="col-md-3">
						文件大小:	&nbsp;
						<tags:fileSize fileSize="${diskInfo.fileSize}"/>
					</div>
					<div class="col-md-3">
						文件类型:	&nbsp;
					</div>
				</div>

				<hr style="border: 2px solid #ccc;">

<div class="row" style="height: 70%">
	<div class="col-md-12" style="height: 100%">
  	<c:if test="${diskInfo.type == 'pdf'}">
  	  <div style="width:100%; height: 700px; background-color: #F9F9F9;">
				<object src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="width:100%;height:100%;">
					<embed src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="width:100%;height:100%;"></embed>
				</object>  	
      </div>
  	</c:if>
		<c:if test="${diskInfo.type == 'txt' || diskInfo.type == 'html' || 
									diskInfo.type == 'doc' || diskInfo.type == 'docx' || 
									diskInfo.type == 'xls' || diskInfo.type == 'xlsx' || diskInfo.type == 'csv'}">
  	  <nav style="width:100%; height: 100%; box-shadow: 0 0 0 2px #ccc inset; padding: 20px 20px; background-color: #FcFcFc;">
				<object src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="width:100%;height:100%;">
					<embed src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="width:100%;height:100%;"></embed>
				</object>  	
      </nav>
  	</c:if>
  	<c:if test="${diskInfo.type == 'jpg' || diskInfo.type == 'jpeg' || diskInfo.type == 'png'}">
			<nav style="width:100%; box-shadow: 0 0 0 2px #ccc inset; padding: 15px 15px; background-color: #F9F9F9;">
				<div style="display: flex; align-items: center; justify-content: center; height: 700px;">
					<img src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" style="max-height:700px;">
				</div>
			</nav>
		</c:if>
		<c:if test="${diskInfo.type == 'mp4'}">
			<nav style="width:100%; box-shadow: 0 0 0 2px #ccc inset; padding: 15px 15px; background-color: #F9F9F9;">
				<div style="display: flex; align-items: center; justify-content: center;">
					<video controls style="max-height:700px;">
						<source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="video/webm">
						<source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="video/ogg"> 
						<source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="video/quicktime">
					</video>
				</div>
			</nav>
  	</c:if>
  	<c:if test="${diskInfo.type == 'mp3'}">
    	<nav style="text-align:center; width:100%; box-shadow: 0 0 0 2px #ccc inset; padding: 30px 30px; background-color: #F9F9F9;">
				<audio controls style="width:80%;">
					<source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="audio/mpeg">
					<source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="audio/ogg"> 
					<source src="${ctx}/disk/api/<tags:currentUsername/>?id=${diskInfo.id}" type="audio/mp3">
				</audio>
			</nav>
  	</c:if>
	</div>
</div>

			</div>
    </div>
  </body>
</html>
