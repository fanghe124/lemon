<%@ page language="java" pageEncoding="UTF-8" %>

<%@include file="_header_first.jsp"%>
<link rel="stylesheet" href="${cdnPrefix}/public/mossle/0.0.11/css/style.css">

<!--<div class="navbar navbar-default navbar-fixed-top">-->
<div class="navbar-fixed-top navbar-nav header-style">
  <div class="container-fluid">
    <%@include file="_header_title.jsp"%>

    <div class="navbar-collapse collapse">
      <ul class="nav navbar-nav" id="navbar-menu">
		<tags:menuNav3 systemCode="pim"/>
      </ul>

	  <%@include file="_header_second.jsp"%>

    </div>

  </div>
</div>
