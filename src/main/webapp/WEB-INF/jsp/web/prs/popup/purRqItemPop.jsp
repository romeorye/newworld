<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purRqItemPop.jsp
 * @desc    : 구매요청 Item 등록 팝업 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.11.23   김연태		최초생성
 * ---	-----------	----------	-----------------------------------------
 * PRS 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>

<script type="text/javascript">
	
	Rui.onReady(function() {
		var frm = document.aform;
		
		var dataSet = new Rui.data.LJsonDataSet({
			id: 'dataSet',
		    remainRemoved: true,
		    fields: [
		    	  { id: 'txz01'}	/*요청품명*/
		    	 ,{ id: 'maker'}	/*메이커*/
		    	 ,{ id: 'vendor'}	/* 벤더*/
		    	 ,{ id: 'catalogno'}	/*카탈로그 no*/
		    	 ,{ id: 'waers'}	/* 요청단위 콤보*/
		    	 ,{ id: 'menge'}	/* 수량*/
		    	 ,{ id: 'preis'}	/* 단가*/
		    	 ,{ id: 'sakto'}	/* 계정코드*/
		    	 ,{ id: 'usedCode'}	/* 사번*/
		    	 ,{ id: 'prsFlag'}	/* 구매진행*/
		    ]
		});	
		
		dataSet.on('load', function(e){
		
		});
		
		
		
		
		
		/* [버튼] 추가 */
	    var btnSave = new Rui.ui.LButton('btnSave');
	    btnSave.on('click', function() {
			//구매요청 Item 정보 저장	 
			
		});
		
		
		
		
	});

</script>
</head>
<body>
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
			<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			<span class="hidden">Toggle 버튼</span>
	   	</a>
	    <h2>구매요청 Item 정보</h2>
    </div>

	<form id="aform" name ="aform">
	<input type="hidden" id="tabId" name="tabId" value="<c:out value='${inputData.tabId}'/>">  
	<input type="hidden" id="bednr" name="bednr" value="<c:out value='${inputData._userSabun}'/>">  
	<input type="hidden" id="PrjCd" name="PrjCd" />  
	
	<div class="sub-content">
			<table class="table table_txt_right">
            	<colgroup>
                	<col width="200px">
                    <col width="500px">
                 </colgroup>
			     <tbody>
			     	<tr>
			        	<th>요청품명</th>
			            <td>
			            	<select id="sCode" name="sCode"></select> 
			            </td>
			        </tr>
			        <tr>
			        	<th>Maker</th>
			            <td>
			            	${inputData._userNm}
			            </td>
					</tr>
			        <tr>
			        	<th>Vendor</th>
			            <td>
			            	${inputData._userNm}
			            </td>
					</tr>
			        <tr>
			        	<th>Catalog No.</th>
			            <td>
			            	${inputData._userNm}
			            </td>
					</tr>
			        <tr>
			        	<th>요청 수량</th>
			            <td>
			            	<input type="text" id="position" name="position" />
			                <select id="ekgrp" name="ekgrp"></select>
			            </td>
			         </tr>
			         <tr>
			        	<th>예상단가</th>
			            <td>
			            	<input type="text" id="position" name="position" /> KRW (원화환산) 
			            </td>
					 </tr>
			         <tr>
			        	<th>예상 금액</th>
			            <td>
			            	<input type="text" id="position" name="position" />
			            </td>
					 </tr>
			         <tr>
			        	<th>계정</th>
			            <td>
			            	
			            </td>
					</tr>
					<tr>
			        	<th>플랜트</th>
			            <td>
			                <select id="ekgrp" name="ekgrp"></select>
			            </td>
			         </tr>
			         <tr>
			        	<th>사용용도</th>
			            <td>
			                	실험용
			            </td>
			         </tr>
			         
				</tbody>
			</table>
	</div>
	    <div class="titArea">
	    	<div class="LblockButton">
	    	 	<button type="button" id="btnSave" name="btnSave">저장</button>
	    	</div> 
	    </div>
</body>
</html>