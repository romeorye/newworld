<%--
/*------------------------------------------------------------------------------
 * NAME : searchAuthFail.jsp
 * DESC : 에러처리 
 * VER  : V1.0
 * PROJ : IRIS
 * Copyright 2017 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 *  2017.11.30   	최초생성
 *------------------------------------------------------------------------------*/
--%>
<%@ page language ="java"  pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title>Error Page</title>
</head>
<script type="text/javascript">
var openRetrieveRequestInfo;

		Rui.onReady(function() {
			
			//alert($( window ).width());
			
			//alert($( document ).width());
            /*******************
             * 변수 및 객체 선언
             *******************/
     	    
     	    // 조회요청 팝업 시작
     	    retrieveRequestInfoDialog = new Rui.ui.LFrameDialog({
     	        id: 'retrieveRequestInfoDialog', 
     	        title: '조회 요청',
     	        width: 850,
     	        height: 330,
     	        modal: true,
     	        visible: false
     	    });
     	    
     	    retrieveRequestInfoDialog.render(document.body);
     	    var rqDocNm 	= '${inputData.rqDocNm}';
     	    var rtrvRqDocCd = '${inputData.rtrvRqDocCd}';
     	    var docNo 		= '${inputData.docNo}';
     	    var pgmPath 	= '${inputData.pgmPath}';
     	    var rgstId 		= '${inputData.apprId}';
     	    var rgstNm 		= '${inputData.apprName}';
     	    var reUrl 		= '${inputData.reUrl}';
     	  
     	   var params = '?rqDocNm=' + escape(encodeURIComponent(rqDocNm))
					   + '&rtrvRqDocCd=' + rtrvRqDocCd
					   + '&docNo=' + docNo
					   + '&pgmPath=' + escape(encodeURIComponent(pgmPath))
					   + '&rgstId=' + rgstId
					   + '&docUrl=' + reUrl
					   + '&rgstNm=' + escape(encodeURIComponent(rgstNm))
					   ;
     	   
     	    fncRq = function(){
     	    	if(Rui.isEmpty(rgstId)){
     	    		Rui.alert("해당내용은 담당자 부재로 관리자에게 문의하세요");
     	    		return ;
     	    	}
     	    	
	     	    retrieveRequestInfoDialog.setUrl('<c:url value="/knld/rsst/retrieveRequestInfo.do"/>' + params);
		    	retrieveRequestInfoDialog.show();
     	    }
     	   
     	    // 조회요청 팝업 끝
     	    
     	    // 조회요청 승인/반려 팝업 시작
     	    retrieveRequestTodoInfoDialog = new Rui.ui.LFrameDialog({
     	        id: 'retrieveRequestTodoInfoDialog', 
     	        title: '조회 요청',
     	        width: 700,
     	        height: 400,
     	        modal: true,
     	        visible: false
     	    });
     	    retrieveRequestTodoInfoDialog.render(document.body);

        });
	
		function openRetrieveRequestInfo(){
			fncRq();
		}
	</script>

<body>
<div class="errorArea">
		<div class="errorTop">
			<h2>
				<strong>권한이 없습니다.</strong>
			</h2>
			<p>
			 	해당 정보열람에 대한 권한이 없습니다. <br />
			 	<a href="#" onClick="javascript:openRetrieveRequestInfo();" ><span>권한요청</span></a>
			<!-- 	<a href="http://search.lghausys.com:8501/iris/search.jsp"><span>통합검색으로 이동하기</span></a> -->
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
</body>
</html>