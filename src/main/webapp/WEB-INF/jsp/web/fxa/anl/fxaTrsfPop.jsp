<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoDtl.jsp
 * @desc    : 자산 상세정보 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.09.11  IRIS05		최초생성
 * 1.1  2019.03.26  IRIS05		멀티건으로 개선
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
var prjSearchDialog; //프로젝트 코드 팝업 dialog

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
        
        
	 	// 프로젝트 팝업 DIALOG
	    prjSearchDialog = new Rui.ui.LFrameDialog({
	        id: 'prjSearchDialog',
	        title: '프로젝트 조회',
	        width: 620,
	        height: 460,
	        modal: true,
	        visible: false
	    });
	 
	    openPrjSearchDialog = function(f,p) {
			var param = '?searchType=';
			if( !Rui.isNull(p) && p != ''){
				param += p;
			}
			_callback = f;

			prjSearchDialog.setUrl('<c:url value="/prj/rsst/mst/retrievePrjSearchPopup.do"/>' + param);
			prjSearchDialog.show();
		};
		
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
				, { id: 'obtPce'}
				, { id: 'bkpPce'}
				, { id: 'prjNm'}
				, { id: 'wbsCd'}
				, { id: 'crgrNm'}
				, { id: 'crgrId'}
				, { id: 'toWbsNm'}
				, { id: 'toWbsCd'}
				, { id: 'toCrgrNm'}
				, { id: 'toCrgrId'}
				, { id: 'trsfRson'}
				, { id: 'fxaInfoId'}
			]
        });

        dataSet.on('load', function(e){
	   
        });

        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                      { field: 'fxaNo'      , label: '자산번호',  	sortable: false,	align:'center', width: 70}
                    , { field: 'fxaNm'      , label: '자산명',  		sortable: false,	align:'left', 	width:260}
                    , { field: 'fxaQty'     , label: '수량',  		sortable: false,	align:'right', 	width:40}
                    , { field: 'fxaUtmNm'	, label: '단위',  		sortable: false,	align:'center', width:40}
                    , { field: 'obtPce' 	, label: '취득가',  		sortable: false,	align:'right', width: 90, renderer: function(value, p, record){
     	        		return Rui.util.LFormat.numberFormat(parseInt(value));
     		       			 }
                 		}
                    , { field: 'bkpPce' 	, label: '장부가',  		sortable: false,	align:'right', width: 90, renderer: function(value, p, record){
     	        		return Rui.util.LFormat.numberFormat(parseInt(value));
     		        		}
                		 }
                    , { id: 'G1', label: '이관 前' }
                   	, { field: 'wbsCd'    	, label: 'PJT코드', groupId: 'G1',  sortable: false,	align:'center', width: 60 }
                    , { field: 'crgrNm'     , label: '담당자', groupId: 'G1',	sortable: false,	align:'center', width: 60}
                    , { id: 'G2', label: '이관 後' }
                    , { field: 'toWbsCd'   	, label: 'PJT코드',  groupId : 'G2',	sortable: false,	align:'center', 	width: 70, renderer: Rui.util.LRenderer.popupRenderer() }
                    , { field: 'toCrgrNm'   , label: '담당자',  groupId : 'G2',	sortable: false,	align:'center', 	width: 70, renderer: Rui.util.LRenderer.popupRenderer() }
                   // , { field: 'trsfRson'   , label: '이관사유', 	sortable: false,	align:'center', width: 70}
            	    , { field: 'crgrId'     , hidden : true}
            	    , { field: 'toCrgrId'   , hidden : true}
            	    , { field: 'toWbsNm'    , hidden : true}
            	    , { field: 'fxaInfoId'  , hidden : true}
            ]
        });

        /** default grid **/
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 1200,
            height: 430,
            autoWidth: true
        });

        grid.on('popup', function(e) {
            popupRow = e.row;
            var column = columnModel.getColumnAt(e.col, true);
            
        	if(column.id == 'toWbsCd') {
            	openPrjSearchDialog(setPrjInfo,'ALL');
            }else{
	            openUserSearchDialog(setGridUserInfo, 1, '');
            }
        });
        
        prjSearchDialog.render(document.body);
        grid.render('defaultGrid');
        	
        fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/trsf/retrieveFxaTrsfPopList.do"/>' ,
	            params :{
	    		    fxaNos : '${inputData.fxaNos}'
                }
            });
        }
        
        // 화면로드시 조회
	    fnSearch();
		
        //담당자 정보
	    setGridUserInfo = function(userInfo){
	    	dataSet.setNameValue(popupRow, "toCrgrId", userInfo.saSabun);
		    dataSet.setNameValue(popupRow, "toCrgrNm", userInfo.saName);
	    }
        // wbs코드정보	
		setPrjInfo = function(prjInfo) {
			dataSet.setNameValue(popupRow, "toWbsCd", prjInfo.wbsCd);
		    dataSet.setNameValue(popupRow, "toWbsNm", prjInfo.prjNm);
	    };
	
	    
	    /* 닫기  */
		var butClose = new Rui.ui.LButton('butClose');
		butClose.on('click', function(){
			parent.fxaTrsfDialog.submit(true);
        });
		
		/* 자산이관신청 등록 저장 */
		var butSave = new Rui.ui.LButton('butSave');
		butSave.on('click', function(){
			dm.on('success', function(e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);
					var guid = resultData.records[0].guid;

					Rui.alert(resultData.records[0].rtnMsg);
					
					if( resultData.records[0].rtnSt == "S"){
		   		    //parent.fnSearch();
		   			parent.fxaTrsfDialog.submit(true);
		   			var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00338&from=iris&guid='+guid;
		       		openWindow(url, 'fxaTrsfPop', 800, 500, 'yes');
					}
			    });

		    dm.on('failure', function(e) {      // 업데이트 실패시
		    	var resultData = resultDataSet.getReadData(e);
				Rui.alert(resultData.records[0].rtnMsg);
		    });
			if(fncVaild()){
				if(confirm("이관하시겠습니까?")) {
		   			dm.updateDataSet({
	                    url:'<c:url value="/fxa/trsf/insertFxaTrsfInfo.do"/>',
	                    dataSets:[dataSet]
	                });
	    	    }
			}
        });
		
		 var fncVaild = function(){
				var  chkCnt =0;
				var  chkCnt1 =0;
				
				for( var i=0; i < dataSet.getCount() ; i++ ){
					var chkWbsCd = dataSet.getNameValue(i, 'toWbsCd'); 
					var chkCrgrId = dataSet.getNameValue(i, 'toCrgrId'); 
					
					if (Rui.isEmpty(chkWbsCd)){
						chkCnt++;					
					}
					if (Rui.isEmpty(chkCrgrId)){
						chkCnt1++;					
					}
				}
				if ( chkCnt > 0 ){
					alert("이전할 프로젝트를 선택하셔야 합니다.");
					return false;
				}
				
				if ( chkCnt > 0 ){
					alert("이전할 담당자를 선택하셔야 합니다.");
					return false;
				}
				
				return true;
		}
	}); // end RUI Lodd

	
    
	</script>
</head>

<body>
<form id="aform">
	<div id="defaultGrid"></div>
	
	<div class="titArea">
		<h3></h3>
		<div class="LblockButton">
			<button type="button" id="butSave">이관요청</button>
			<button type="button" id="butClose">닫기</button>
		</div>
	</div>
</form>
</body>
</html>