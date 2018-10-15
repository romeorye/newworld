<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxarlisCrgrAnlList.jsp
 * @desc    : 자산관리>  자산담당자 목록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.20    IRIS05		최초생성
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

<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">

	Rui.onReady(function() {
		//담당자
	 	var popupUserInfo = new Rui.ui.form.LPopupTextBox({
            enterToPopup: true,
            useHiddenValue: true,
            editable: false
        });

		//통보자
	 	var popupMultiUserInfo = new Rui.ui.form.LPopupTextBox({
            enterToPopup: true,
            useHiddenValue: true,
            editable: false
        });

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

		/** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
				  { id: 'deptCd'}
				, { id: 'wbsCd'}
				, { id: 'prjNm'}
            	, { id: 'crgrId' }
            	, { id: 'crgrNm'}
            	, { id: 'rfpNm'}
            	, { id: 'rfpId'}
            	, { id: 'regDt' }
            	, { id: 'rfpUserId' }
			]
        });

        dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    	// 목록 페이징
	    	aCnt = 15;		//게시물수
	    	paging(dataSet,"defaultGrid");
	    });

        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
        	 	      { field: 'prjNm'    	, label: '프로젝트명',  	sortable: false,	align:'left', width: 500}
                    , { field: 'crgrNm'     , label: '담당자',  		sortable: false,	align:'center', width: 220, editor: popupUserInfo, renderer: Rui.util.LRenderer.popupRenderer() }
                    , { field: 'rfpNm'      , label: '통보자',  		sortable: false,	align:'center', width: 420, editor: popupMultiUserInfo, renderer: Rui.util.LRenderer.popupRenderer() }
                    , { field: 'regDt'      , label: '등록일',  		sortable: false,	align:'center', width: 185}
            	    , { field: 'deptCd'		, hidden : true}
            	    , { field: 'rfpId' 		, hidden : true}
            	    , { field: 'crgrId'  	, hidden : true}
            	    , { field: 'rfpUserId'  , hidden : true}
            	    , { field: 'wbsCd'  	, hidden : true}
            ]
        });

        var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width : 1150,
	        height: 520,
	        autoWidth: true
	    });

		grid.render('defaultGrid');

	 	fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/rlisCrgrAnl/retrieveFxaRlisCrgrAnlSearchList.do"/>'
            });
        }

	 	fnSearch();

	 	grid.on('popup', function(e){
			var recode = dataSet.getAt(dataSet.getRow());
			if(e.col == 1){
		 		openUserSearchDialog(setUserInfo, 1, '', '');
			}else{
		 		openUserSearchDialog(setMultiUserInfo, 10, recode.get("rfpUserId"), 'prj');
			}
        });

	 	popupUserInfo.on('popup', function(e){
			var recode = dataSet.getAt(dataSet.getRow());
			if(e.col == 1){
		 		openUserSearchDialog(setUserInfo, 1, '', '');
			}else{
		 		openUserSearchDialog(setMultiUserInfo, 10, recode.get("rfpUserId"), 'prj');
			}
        });

	 	setUserInfo = function (user){
	 		var recode = dataSet.getAt(dataSet.getRow());
	   		recode.set("crgrNm", user.saName);
	 		recode.set("crgrId", user.saSabun);
	    };

	    setMultiUserInfo = function (userList){
	    	var recode = dataSet.getAt(dataSet.getRow());

	    	var idList = [];
	    	var sabunList = [];
	    	var nameList = [];

	    	for(var i=0, size=userList.length; i<size; i++) {
	    		idList.push(userList[i].saUser);
	    		nameList.push(userList[i].saName);
	    		sabunList.push(userList[i].saSabun);
	    	}

	   		recode.set("rfpNm", nameList.join(', '));
	 		recode.set("rfpId", sabunList.join(', '));
	 		recode.set("rfpUserId", idList.join(', '));
	    };

	    /* [버튼]저장 호출 */
    	var butSave = new Rui.ui.LButton('butSave');
    	butSave.on('click', function() {

    		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 승인 성공시
				var resultData = resultDataSet.getReadData(e);

    			Rui.alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
	    			fnSearch();
    			}

    	    });
    	    dm.on('failure', function(e) {      // 승인 실패시
                Rui.alert("신청 Fail");
    	    });

    	    Rui.confirm({
    			text: '저장하시겠습니까?',
    	        handlerYes: function() {
    	        	dm.updateDataSet({
    	        	    url: "<c:url value='/fxa/rlisCrgrAnl/saveFxaRlisCrgrAnlInfo.do'/>"
    	        	  ,	dataSets : [dataSet]
    	        	});
    	        }
    		});

    	});


	});		//end ready

</script>

 </head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
 		<div class="contents">
 			<div class="titleArea">
 				<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
	        	</a>
 				<h2>자산담당자 관리</h2>
 		    </div>
 			<div class="sub-content">
		<form name="aform" id="aform" method="post">
			<input type="hidden" id="menuType"  name="menuType" />


			<div class="titArea btn_top">
				<span class="table_summay_number" id="cnt_text"></span>
				<div class="LblockButton">
					<button type="button" id="butSave" name="butSave">저장</button>
				</div>
			</div>
			<table class="table table_txt_right">
    		</table>
			<div id="defaultGrid"></div>
		</form>

 			</div><!-- //sub-content -->
  		</div><!-- //contents -->
 </body>
 </html>