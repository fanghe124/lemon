<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<%pageContext.setAttribute("currentHeader", "report");%>
<%pageContext.setAttribute("currentMenu", "chart");%>
<!doctype html>
<html lang="en">

  <head>
    <%@include file="/common/meta.jsp"%>
    <title>设备审批失败</title>
    <%@include file="/common/s3.jsp"%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />     
    
<script>
    function toDeviceManagement(){
      var curWwwPath = window.document.location.href;
   	 //获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
       var pathName = window.document.location.pathname;
   	   var pos = curWwwPath.indexOf(pathName);
   	 //获取主机地址，如： http://localhost:8083
       this.path = curWwwPath.substring(0, pos);
       window.location.href=path+"/lemon/device/index.do";
    }
    
    function toPortal(){
        var curWwwPath = window.document.location.href;
      	 //获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
        var pathName = window.document.location.pathname;
      	var pos = curWwwPath.indexOf(pathName);
      	 //获取主机地址，如： http://localhost:8083
        this.path = curWwwPath.substring(0, pos);
    	window.location.href=path+"/lemon/portal/index.do";
    }
    
</script>
    
  </head>
   
    <body>
      <%@include file="/header/report.jsp"%>
    <div style="padding-top:65px;font-size:20px;text-align: center;">资源不足设备审批失败</div>
    <div  style="margin-top:20px;text-align: center;">
        <button onclick="toDeviceManagement()">设备管理</button>
        <button onclick="toPortal()">返回主页</button>
    </div>
    </body>
</html>
    