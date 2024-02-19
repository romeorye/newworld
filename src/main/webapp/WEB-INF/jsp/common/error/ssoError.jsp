<%--
/*------------------------------------------------------------------------------
 * NAME : error.jsp
 * DESC : 에러처리 
 * VER  : V1.0
 * PROJ : LG CNS 창호완성창시스템 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 *  2016.09.09 김수예 	최초생성
 *------------------------------------------------------------------------------*/
--%>
<%@ page language ="java"  pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript">
	function init(){
			top.location = contextPath+"/ssoError.html";
	}


</script>

<body onload="init();">

<!--
 <div class="errorArea">
		<div class="errorTop">
			<h2>
				<strong>죄송합니다.</strong><br />
				요청하신 페이지를 찾을 수 없습니다.
			</h2>
			<p>
				이용하시려는 페이지의 주소가 잘못되었거나, <br />
				페이지의 주소가 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다. <br />
				입력하신 주소가 정확한지 다시 한번 확인해 주시기 바랍니다. <br />
				관련 문의사항은 고객센터(02-6987-7396)에 알려주시면 친절하게 안내해 드리겠습니다. <br />
			</p>
			<br>
			<br>
			<br>
		</div>
		<div class="errorBot">
			개인정보취급방침  TEL : 080-005-4000 ( 평일 09:00~ 18:00 토, 일요일 및 공휴일 휴무 )  <br />
			서울시 영등포구 국제금융로 10 ONE IFC빌딩 15-19F LG하우시스  <br />
			Copyright (C) 2016  All Rights Reserved. <br />
		</div>
	</div>
	 -->
</body>
