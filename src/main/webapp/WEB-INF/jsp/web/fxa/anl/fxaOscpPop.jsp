<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaOscpPop.jsp
 * @desc    : 자산 상세정보 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019. 10. 16  IRIS05		최초생성
  * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>


<script type="text/javascript">
	Rui.onReady(function() {
		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
                , { id: 'guid' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
        
		/** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'fxaNo'}
				, { id: 'fxaNm'}
				, { id: 'fxaQty'}
				, { id: 'fxaUtmNm'}
				, { id: 'bkpPce'}
				, { id: 'fxaLoc'}
				, { id: 'fxaInfoId'}
			]
        });

        dataSet.on('load', function(e){
	   
        });

        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                      { field: 'fxaNo'      , label: '자산번호',  	sortable: false,	align:'center', width: 80}
                    , { field: 'fxaNm'      , label: '자산명',  		sortable: false,	align:'left', 	width:300}
                    , { field: 'fxaQty'     , label: '수량',  		sortable: false,	align:'right', 	width:40}
                    , { field: 'fxaUtmNm'	, label: '단위',  		sortable: false,	align:'center', width:40}
                    , { field: 'bkpPce' 	, label: '장부가',  		sortable: false,	align:'right', width: 80, renderer: function(value, p, record){
     	        		return Rui.util.LFormat.numberFormat(parseInt(value));
     		        		}
                		 }
                    , { field: 'fxaLoc'	, label: '위치',  sortable: false,	align:'center', width:200, editor: new Rui.ui.form.LTextBox() }
            	    , { field: 'fxaInfoId'  , hidden : true}
            ]
        });

        /** default grid **/
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 800,
            height: 430,
            autoWidth: true
        });

        grid.render('defaultGrid');
        	
        fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/oscp/retrieveFxaOscpPopList.do"/>' ,
	            params :{
	    		    fxaNos : '${inputData.fxaNos}'
                }
            });
        }
        
        // 화면로드시 조회
	    fnSearch();
	    
	    /* 닫기  */
		var butClose = new Rui.ui.LButton('butClose');
		butClose.on('click', function(){
			parent.fxaOscpDialog.submit(true);
        });
		
		/* 사외자산이관신청 등록 저장 */
		var butSave = new Rui.ui.LButton('butSave');
		butSave.on('click', function(){
			dm.on('success', function(e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);
					var guid = resultData.records[0].guid;

					Rui.alert(resultData.records[0].rtnMsg);
					
					if( resultData.records[0].rtnSt == "S"){
		   		    //parent.fnSearch();
		   			parent.fxaOscpDialog.submit(true);
		   			var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00418&from=iris&guid='+guid;
		   			openWindow(url, 'fxaOscpPop', 800, 500, 'yes');
					}
			    });

		    dm.on('failure', function(e) {      // 업데이트 실패시
		    	var resultData = resultDataSet.getReadData(e);
				Rui.alert(resultData.records[0].rtnMsg);
		    });
		    
		    for( var i=0; i < dataSet.getCount() ; i++ ){
				var chkFxaLoc = dataSet.getNameValue(i, 'fxaLoc'); 

				if( Rui.isEmpty(chkFxaLoc) ){
		    		alert("위치정보가 없으면 요청하실수 없습니다.");
		    		return;
		    	}
		    }		    

		    if(confirm("진행하시겠습니까?")) {
		    	dm.updateDataSet({
                    url:"<c:url value='/fxa/oscp/insertFxaOscpInfo.do'/>",
                    dataSets:[dataSet],
                    modifiedOnly: false
                });
		    }
        });
		
		 
	}); // end RUI Lodd

	
    
	</script>
</head>

<body>
<form id="aform">
	<div id="defaultGrid"></div>
	
	<div class="titArea">
		<h3><font color="red">사외자산이 있을 위치를 입력하세요. (Ex. 업체명 / 경기도 안양시 )</font></h3>
		<div class="LblockButton">
			<button type="button" id="butSave">품의요청</button>
			<button type="button" id="butClose">닫기</button>
		</div>
	</div>
</form>
</body>
</html>