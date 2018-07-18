<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoList.jsp
 * @desc    : 고정자산 >  자산실사기간관리 목록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.18    IRIS05		최초생성
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
var fxaRlisAnlDialog;

	Rui.onReady(function() {
		/** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
				  { id: 'rlisTitl'}
				, { id: 'fromRlisDt'}
				, { id: 'toRlisDt'}
            	, { id: 'rlisClNm' }
            	, { id: 'apprCnt'}
            	, { id: 'totalCnt' }
            	, { id: 'rlisMgrNm'}
				, { id: 'rlisMgrId'}
				, { id: 'rlisClCd'}
				, { id: 'rlisTrmId' }
			]
        });

        dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    });

        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
        	 	      { field: 'rlisTitl'      , label: '실사제목',  	sortable: false,	align:'left', width:380}
                    , { field: 'fromRlisDt'    , label: '실사시작',  	sortable: false,	align:'center', width: 150}
                    , { field: 'toRlisDt'      , label: '실사종료',  	sortable: false,	align:'center', width: 150}
                    , { field: 'rlisClNm'      , label: '구분',  		sortable: false,	align:'center', width: 120}
                    , { field: 'totalCnt'      , label: '실사요청',  	sortable: false,	align:'center', width: 110}
                    , { field: 'apprCnt'       , label: '실사완료',  	sortable: false,	align:'center', width: 110}
                    , { field: 'rlisMgrNm'     , label: '실사관리자',  	sortable: false,	align:'center', width: 130}
            	    , { field: 'rlisMgrId' , hidden : true}
            	    , { field: 'rlisClCd'  , hidden : true}
            	    , { field: 'rlisTrmId' , hidden : true}
            ]
        });

        var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width : 1150,
	        height: 640
	    });

		grid.render('defaultGrid');

		grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());
			if(dataSet.getRow() > -1) {
				//document.aform.rlisTrmId.value = record.get("rlisTrmId");
				var param = "?rlisTrmId="+record.get("rlisTrmId");
				
				fxaRlisAnlDialog.setUrl('<c:url value="/fxa/rlisAnl/retrieveFxaRlisAnlPop.do"/>'+param);
				fxaRlisAnlDialog.show(true);
			}
	 	});

        fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/rlisAnl/retrieveFxaRlisAnlSearchList.do"/>'
            });
        }

        // 화면로드시 조회
	    fnSearch();

	    /* [ 실사기간관리 Dialog] */
		fxaRlisAnlDialog = new Rui.ui.LFrameDialog({
	        id: 'fxaRlisAnlDialog',
	        title: '실사기간관리',
	        width:  900,
	        height: 390,
	        modal: true,
	        visible: false,
	    });

		fxaRlisAnlDialog.render(document.body);


        /* 신규등록  */
		var butReg = new Rui.ui.LButton('butReg');
		butReg.on('click', function(){
			fxaRlisAnlDialog.setUrl('<c:url value="/fxa/rlisAnl/retrieveFxaRlisAnlPop.do"/>');
			fxaRlisAnlDialog.show(true);
        });

		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butReg").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butReg").hide();
		}

	});		//end ready

</script>
 </head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
 		<div class="contents">
 			<div class="titleArea">
 				<h2>자산실사기간 관리</h2>
 		    </div>
 			<div class="sub-content">

		<form name="aform" id="aform" method="post">
			<input type="hidden" id="menuType"  name="menuType" />
			<input type="hidden" id="fxaInfoId"  name="fxaInfoId" />
			<input type="hidden" id="rtnUrl"  name="rtnUrl" />

			<span class="table_summay_number" id="cnt_text"></span>
			<div class="LblockButton">
				<button type="button" id="butReg">신규실사</button>
			</div>
			<table class="table table_txt_right">
    		</table>
			<div id="defaultGrid"></div>
	</form>

 			</div><!-- //sub-content -->

  		</div><!-- //contents -->
 </body>
 </html>