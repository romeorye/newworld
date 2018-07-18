<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoRlisTodoList.jsp
 * @desc    : 자산관리 >  자산실사 TO_do
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.21     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">

var fxaRlisId;
	document.domain = 'lghausys.com';

	fxaRlisId = '<c:out value="${inputData.MW_TODO_REQ_NO}"/>';
	//fxaRlisId = '<c:out value="${inputData.fxaRlisId}"/>';
	Rui.onReady(function() {
		
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
		
		/*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
         dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
 				  { id: 'prjNm'}
 				, { id: 'fxaNo'}
 				, { id: 'fxaNm'}
 				, { id: 'fxaQty'}
 				, { id: 'fxaUtmNm'}
 				, { id: 'crgrNm'}
 				, { id: 'fxaClss'}
 				, { id: 'rlisDt'}
 				, { id: 'fxaSsisYn'}
 				, { id: 'fxaRem'}
 				, { id: 'rlisMappId'}
 				, { id: 'fxaInfoId'}
 				, { id: 'deptCd'}
 				, { id: 'crgrId'}
             	, { id: 'wbsCd'}
 			]
         });
		
         dataSet.on('load', function(e){
        	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
  	    });

         var columnModel = new Rui.ui.grid.LColumnModel({
             columns: [
	            	  { field: 'prjNm'      , label: '프로젝트명', 	sortable: false,	align:'left', 	width: 230}
	                  , { field: 'fxaNo'    , label: '자산번호',  	sortable: false,	align:'center', width: 100}
	                  , { field: 'fxaNm'    , label: '자산명',  	sortable: false,	align:'left', 	width:300}
	                  , { field: 'fxaQty' 	, label: '수량',  		sortable: false,	align:'center', width: 30}
	                  , { field: 'fxaUtmNm' , label: '단위',  		sortable: false,	align:'center', width: 40}
	                  , { field: 'crgrNm'   , label: '담당자',  	sortable: false,	align:'center', width: 70}
	                  , { field: 'fxaClss'  , label: '자산클래스', 	sortable: false,	align:'center', width: 80}
                     , { field: 'rlisDt' 	, label: '최근실사일', 	sortable: false,	align:'center', width: 80}
                     , { field: 'fxaSsisYn' , label: '자산유무',  	sortable: false,	align:'center', width: 70, editor: new Rui.ui.form.LCheckBox({
                         gridFixed: true,
                         bindValues : ['Y', 'N']
                     }) },
                     , { field: 'fxaRem'     , label: '비고',  	   sortable: false,	align:'center', width: 150, editor: new Rui.ui.form.LTextBox() }
 					 , { field: 'wbsCd'      , label: 'WBS 코드', hidden: true}
             	     , { field: 'rlisMappId' , hidden : true}
             	     , { field: 'fxaInfoId'  , hidden : true}
             	     , { field: 'deptCd'     , hidden : true}
             	     , { field: 'crgrId'     , hidden : true}
             ]
         });

         /** default grid **/
         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             width: 600,
             height: 300,
             autoToEdit: false,
             autoWidth: true
         });

         grid.render('defaultGrid');
		
         fnSearch = function() {
 	    	dataSet.load({
 	            url: '<c:url value="/fxa/rlis/retrieveFxaRlisTodo.do"/>',
 	            params :{
 	            	fxaRlisId : fxaRlisId
                 }
             });
         }

         // 화면로드시 조회
 	    fnSearch();
         
        /* [버튼] : 자산실사 To_do 정보 저장 */
     	var butSave = new Rui.ui.LButton('butSave');
     	butSave.on('click', function(){
     		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    		 	
    			if( resultData.records[0].rtnSt == "S"){
    				// parent.TodoCallBack();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    	    });

    	    if(dataSet.getCount() > 0 ) {
    	    	for( var i = 0 ; i < dataSet.getCount() ; i++ ){
    	    		if(dataSet.getNameValue(i, "fxaSsisYn") == "N"){
    	    			Rui.alert("자산유무 결과를 체크하십시오.");
    	    			return;
    	    		}
    	    	}
    	    }
    	    
    	    Rui.confirm({
    			text: '저장하시겠습니까?',
    	        handlerYes: function() {
    	        	dm.updateDataSet({
    	        	    url: "<c:url value='/fxa/rlis/saveFxaRlisTodoInfo.do'/>"
    	        	  ,	dataSets : [dataSet]
    	        	  , params : {
    	        		  fxaRlisId : fxaRlisId
    	        	  }
    	        	});
    	        }
    		});
     	});
     	
     	
     	/* [버튼] : 자산실사 To_do 결재 품의 저장 */
     	var butAppr = new Rui.ui.LButton('butAppr');
     	butAppr.on('click', function(){
     		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    		 	
    			if( resultData.records[0].rtnSt == "S"){
	    			var guId = "R"+fxaRlisId; 
	    			
	    			var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00338&from=iris&guid='+guId;
               		openWindow(url, 'fxaRlisPop', 800, 500, 'yes');
    				parent.TodoCallBack();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    	    });

    	    if(dataSet.getCount() > 0 ) {
    	    	for( var i = 0 ; i < dataSet.getCount() ; i++ ){
    	    		if(dataSet.getNameValue(i, "fxaSsisYn") == "N"){
    	    			Rui.alert("자산유무 결과를 체크하십시오.");
    	    			return;
    	    		}
    	    	}
    	    }

    	    Rui.confirm({
    			text: '결재하시겠습니까?',
    	        handlerYes: function() {
    	        	dm.updateDataSet({
    	        	    url: "<c:url value='/fxa/rlis/saveFxaRlisTodoApprInfo.do'/>"
    	        	  ,	dataSets : [dataSet]
    	        	  , params : {
    	        		  fxaRlisId : fxaRlisId
    	        	  }
    	        	});
    	        }
    		});
     		
     		
     		
     	});
	});		//end ready

</script>
    </head>
    <body >
    		<div class="contents">
    			<div class="titleArea">
    				<h2>자산실사처리 To_do</h2>
    		    </div>
    			<div class="sub-content">
					<form name="aform" id="aform" method="post">
    				<div class="titArea">
    					<span class="table_summay_number" id="cnt_text"></span>
						<div class="LblockButton">
    						<button type="button" id="butSave">저장</button>
    						<button type="button" id="butAppr">결재의뢰</button>
    					</div>
    				</div>
					</form>
					<table class="table table_txt_right">
    				</table>
    				<div id="defaultGrid"></div>
	    			<span style="color:red;">자산점검하신 후 해당 자산이 존재하면 자산유무 필드에 체크 하시기 바랍니다.</span>
    			</div><!-- //sub-content -->
    		</div><!-- //contents -->
    </body>
    </html>