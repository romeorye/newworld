<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: codeRegPop.jsp
 * @desc    : 통계 > 공통코드 관리 >공통코드 등록 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.11.16     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>


<script type="text/javascript">

	Rui.onReady(function(){
		
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
        
		/* dataSet */
		var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
	        	  { id: 'comCdCd'}
	        	, { id: 'comOrd'}
 				, { id: 'comCdNm'}
 				, { id: 'comCdExpl'}
 				, { id: 'comDtlCd'}
 				, { id: 'comDtlNm'}
 				, { id: 'delYn'}
 				, { id: '_userId'}
        		 ]
	    });

		var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	  { field: 'comCdCd' 	, label: '코드구분',  	editor: new Rui.ui.form.LTextBox(), align:'center', width: 180}
                , { field: 'comCdNm'   	, label: '코드명', 		editor: new Rui.ui.form.LTextBox(), align:'left', 	width: 200}
                , { field: 'comOrd'    	, label: '순서', 		editor: new Rui.ui.form.LNumberBox(), align:'center', width: 40}
                , { field: 'comCdExpl'  , label: '코드상세',  	editor: new Rui.ui.form.LTextBox(), align:'center', width: 210}
                , { field: 'comDtlCd'  	, label: '코드',  		editor: new Rui.ui.form.LTextBox(), align:'center', width: 130}
                , { field: 'comDtlNm'   , label: '코드값',  	editor: new Rui.ui.form.LTextBox(), align:'left', 	width: 60}
                , { field: '_userId'   ,hidden:true}
	        ]
	    });

	    var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width:  850,
	        height: 400,
	        autoToEdit: true,
	        autoWidth: true
	    });

	    grid.render('codeGrid');

	    /* [버튼] : 코드 등록(리스트 추가) */
	    var butReg = new Rui.ui.LButton('butReg');
	    
	    butReg.on('click', function(){
	    	var row = dataSet.newRecord();
            var record = dataSet.getAt(row);
            record.set('_userId', '${inputData._userId}'); 
		});
	    
	    /* [버튼] : 코드 등록 저장 */
	    var butSave = new Rui.ui.LButton('butSave');
	    
	    butSave.on('click', function(){
	    	var dm = new Rui.data.LDataSetManager();
	        dm.on('success', function(e) {      // 업데이트 성공시 
	        	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    		 	
    			if( resultData.records[0].rtnSt == "S"){
    				parent.fnSearch();
    				parent.fncPopCls();
    			}
	        });
	     
	        dm.on('failure', function(e) {      // 업데이트 실패시
	        	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
	        });
	     
	        dm.updateDataSet({                            				// 데이터 변경시 호출함수 입니다.
	            url: '<c:url value="/stat/code/saveCodeInfo.do"/>' ,	// 서버측 URL을 기술합니다.
	            dataSets:[dataSet]
	        });
		});
	    
	    /* [버튼] : 코드 팝업창 종료 */
	    var butClose = new Rui.ui.LButton('butClose');
	    
	    butClose.on('click', function(){
	    	parent.fncPopCls();
		});
	    

	});			//end Ready

</script>
</head>
<body>
	<div class="pop_in">
		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<div class="titArea">
					<div class="LblockButton">
						<button type="button" id="butReg">추가</button>
						<button type="button" id="butSave">저장</button>
						<button type="button" id="butClose">닫기</button>
					</div>
				</div>
			
			<div id="codeGrid"></div>


		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
			</form>
</body>
</html>