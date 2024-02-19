<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purRqLabEquipDetail.jsp
 * @desc    : 구매요청시스템 화면(실험용 설비 - 투자)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.12.09   홍상의		최초생성
 * 1.1  2019.05.29  IRIS005 	전체 리뉴얼
 * ---	-----------	----------	-----------------------------------------
 * PRS 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="/iris/rui/plugins/ui/grid/LTotalSummary.js"></script>
<title><%=documentTitle%></title>
<style>
 .L-tssLable {
 border: 0px
 }
</style>

<script type="text/javascript">
var lvAttcFilId;
var callback;
var openPrjSearchDialog; //프로젝트 코드 팝업 dialog
var banfnPrs;
var bnfpoPrs;
var nextBnfpoPrs;
var frm = document.aform;
var tmpScode;

	Rui.onReady(function() {
		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		banfnPrs = '${inputData.banfnPrs}';
		bnfpoPrs = '${inputData.bnfpoPrs}';
	
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            fields: [
                  { id: 'cmd' }   	//command
                , { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
        
        openPrjSearchDialog = new Rui.ui.LFrameDialog({
	        id: 'openPrjSearchDialog',
	        title: 'Project Code',
	        width:  900,
	        height: 550,
	        modal: true,
	        visible: false,
	        buttons : [
	            { text:'닫기', handler: function() {
	              	this.cancel(false);
	              }
	            }
	        ]
	    });

        openPrjSearchDialog.render(document.body);
	
        var purRqUserDataSet = new Rui.data.LJsonDataSet({
			id: 'purRqUserDataSet',
			remainRemoved: true,
            lazyLoad: true,
            fields: [
            	 { id : 'banfnPrs'}   
            	,{ id : 'bnfpoPrs'}   
            	,{ id : 'seqNum'}     
            	,{ id : 'sCode'}       /* 품목구분 */ 
            	,{ id : 'banfn'}       
            	,{ id : 'bnfpo'}       
            	,{ id : 'knttp'}       
            	,{ id : 'pstyp'}       
            	,{ id : 'meins'}       /* 단위 */
            	,{ id : 'eeind'}       
            	,{ id : 'afnam'}       
            	,{ id : 'matkl'}       
            	,{ id : 'ekgrp'}       /* 구매그룹 */
            	,{ id : 'bednr'}       
            	,{ id : 'peinh'}       
            	,{ id : 'anlkl'}       
            	,{ id : 'txt50'}       
            	,{ id : 'itemTxt'}       
            	,{ id : 'kostl'}       
            	,{ id : 'posid'}       
            	,{ id : 'post1'}       
            	,{ id : 'prsFlag'}    
            	,{ id : 'bizCd'}      
            	,{ id : 'attcFilId'}	
            	,{ id : 'txz01'}		/* 요청품명 */
		    	,{ id : 'maker'}		/* 메이커 */
		    	,{ id : 'vendor'}		/* 벤더 */
		    	,{ id : 'modelno'}	/* 카탈로그 NO */
		    	,{ id : 'waers'}		/* 요청단위 콤보 */
		    	,{ id : 'menge'}		/* 요청수량 */
		    	,{ id : 'meins'}		/* 요청단위 */
		    	,{ id : 'preis'}		/* 예상단가 */
		    	,{ id : 'anln1'}		/* 자산클래스코드 */
		    	,{ id : 'anln1nm'}		/* 자산클래스명 */
		    	,{ id : 'usedCode'}		/* */
		    	,{ id : 'werks'}		/* 플랜트 */
		    	,{ id : 'wbsCd'}		/* 프로젝트코드 */
		    	,{ id : 'sCodeSeq'}     /* 품목구분 Seq */ 
            ]
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
	    <h2>투자요청(구매) 상세내용</h2>
    </div>

	<form id="aform" name ="aform">
	<input type="hidden" id="tabId" name="tabId" value="<c:out value='${inputData.tabId}'/>">  
	<input type="hidden" id="banfnPrs" name="banfnPrs" value="<c:out value='${inputData.banfnPrs}'/>">
	
	<div class="sub-content">
	   		<div class="titArea mt0" style="margin-bottom:5px !important;">
   				<div class="LblockButton mt0">
   					<button type="button" id="btnPopupPurRq" name="btnPopupPurRq" >구매요청방법?</button>
   					<button type="button" id="btnPopupExplain" name="btnPopupExplain" >납품요청일?</button>
   				</div>
			</div>
	
			<table class="table table_txt_right">
            	<colgroup>
                	<col width="145px">
                    <col width="305px">
                    <col width="145px">
                    <col width="305px">
                    <col width="145px">
                    <col width="*">
                 </colgroup>
			     <tbody>
			     	<tr>
			        	<th>품목구분</th>
			            <td>
			            	<select id="sCode" name="sCode"></select> 
			            </td>
			            <th>납품요청일</th>
			            <td colspan="3" >
			            	<div id="eeind"></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>수입품:2개월 이상, 제작:1개월 이상</span>
			            </td>
			        </tr>
			        <tr>
			        	<th>성명</th>
			            <td>
			            	${inputData._userNm}
			            </td>
			        	<th>납품위치</th>
			            <td>
			            	<select id="position" name="position"></select>
			            </td>
			            <th>구매그룹</th>
			            <td>
			                <select id="ekgrp" name="ekgrp"></select>
			            </td>
					</tr>
			         <tr>
			         	<th>요청사유 및 세부스펙<br/>(400자 이내)</th>
			            <td colspan="5">
			            	<textarea id="itemTxt" name="itemTxt"></textarea>
			            </td>
					</tr>	
					<tr>
			        	<th>요청품명</th>
			            <td>
			            	<input type="text" id="txz01" name="txz01" />
			            </td>
	                    <th align="right">첨부파일</th>
	                    <td colspan="2" id="attchFileView">&nbsp;</td>
	                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prsPolicy', '*')">첨부파일등록</button></td>
	                </tr>
			     	<tr>
			        	<th>자산클래스</th>
			            <td>
			            	<input type="text" id="anln1" name="anln1"  value=""  />&nbsp;<span id="anln1nm" name="anln1nm"></span>
			            </td>
			        	<th>Maker</th>
			            <td>
			            	<input type="text" id="maker" name="maker" maxlength="35" /> (35자 이내)
			            </td>
			        	<th>Vendor</th>
			            <td>
			            	<input type="text" id="vendor" name="vendor" maxlength="35" /> (35자 이내)
			            </td>
			        </tr>
			        <tr>
			        	<th>Model No.</th>
			            <td>
			            	<input type="text" id="modelno" name="modelno" maxlength="15" /> (15자 이내)
			            </td>
			            <th>WBS요소</th>
			            <td>
							<input type="text" class="" id=wbsCd name="wbsCd" value=""  />&nbsp;<span id="wbsCdName" name="wbsCdName"></span>
			            </td>
			        	<th>플랜트</th>
			            <td>
			                <select id="werks" name="werks"></select>
			            </td>
					</tr>
			        <tr>
			        	<th>요청 수량</th>
			            <td>
			            	<input type="text" id="menge" name="menge" /> <select id="meins" name="meins"></select>
			            </td>
			        	<th>예상단가</th>
			            <td>
			            	<input type="text" id="preis" name="preis" /> KRW (금액*환율*1.08로 환산) 
			            </td>
			        	<th>예상 금액</th>
			            <td>
			            	<span id="totPreis"></span>
			            </td>
					</tr>
				</tbody>

			</table>
	    <div class="titArea">
	    	<span class="Ltotal" id="cnt_text">총 : 0건 </span>
	    	<div class="LblockButton">
	    	    <button type="button" id="btnClearItemContents" name="btnClearItemContents" >초기화</button>
	    		<button type="button" id="btnDeleteItem" name="btnDeleteItem" >삭제</button>
	    		<button type="button" id="btnModifyItem" name="btnModifyItem" >수정</button>
	    	 	<button type="button" id="btnAddPurRq" name="btnAddPurRq" class="redBtn">추가</button>
	    	</div>
	    </div>
	    
	    <div id="purItemGridDiv"></div> 
	</div> <!-- //sub-content -->
</div> <!-- //contents -->   
		
	<div id="purRqGrid"></div>

</form>
</body>
</html>