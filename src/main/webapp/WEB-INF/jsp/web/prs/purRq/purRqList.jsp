<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purRqList.jsp
 * @desc    : 구매요청시스템 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.11.21   김연태		최초생성
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
var linkUrl;
	
	Rui.onReady(function() {
		var frm = document.aform;
		
		/** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'sCode'}
				, { id: 'sample'}
				, { id: 'mCode'}
				, { id: 'knttp'}
				, { id: 'usedCode'}
				, { id: 'pstyp'}
				, { id: 'bizCd'}
				, { id: 'sakto'}
				, { id: 'izwek'}
				, { id: 'ekgrp'}
				, { id: 'ekgrpnm'}
				, { id: 'saktonm'}
				, { id: 'werks'}
				, { id: 'anlkl'}
				, { id: 'sCodeSeq'}
				, { id: 'ekgrp'}
				, { id: 'isMro'}
			]
        });

        dataSet.on('load', function(e){
	    });

        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
					   { field: 'sCode'      , label: '구매요청',  		sortable: false,	align:'left', width: 240, renderer: function(value, p, record, row, col){
		                    return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
		                }}
                     , { field: 'sample'    , label: '품목  Example', 	sortable: false,	align:'left', 	width: 350}
                     , { field: 'ekgrpnm'   , label: '구매담당자',  	sortable: false,	align:'center', width: 230}
                     , { field: 'mCode'     , label: '구분',  			sortable: false,	align:'center', 	width:115}
                     , { field: 'saktonm'   , label: 'G/L계정명',  		sortable: false,	align:'center', 	width:250}
            	     , { field: 'sakto' 	, label: 'G/L계정', 	 	sortable: false,	align:'center', 	width:140}
                     , { field: 'usedCode' 	, hidden : true}
            	     , { field: 'anlkl' 	, hidden : true}
            	     , { field: 'bizCd' 	, hidden : true}
            	     , { field: 'knttp' 	, hidden : true}
            	     , { field: 'ekgrp' 	, hidden : true}
            	     , { field: 'sCodeSeq'	, hidden : true}
            	     , { field: 'pstyp' 	, hidden : true}
            	     , { field: 'izwek' 	, hidden : true}
            	     , { field: 'ekgrp' 	, hidden : true}
            	     , { field: 'isMro' 	, hidden : true}
            ]
        });
        
        /** default grid **/
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 1200,
            height: 500,
            autoWidth: true
        });

        grid.render('defaultGrid');
		
        var moveServeonPage = function(){
        	var url = "http://mall.serveone.co.kr/M3/index.jsp"
           	window.open(url,'serveonemall','');
        }
        
        grid.on('cellClick', function(e) {
        	var record = dataSet.getAt(dataSet.getRow());

        	if(e.colId == "sCode") {
           		if( record.get("isMro") == "Y" ){
           			moveServeonPage();
             	}else{
                 	frm.sCodeSeq.value = record.get("sCodeSeq");
         			
                 	if( frm.tabId.value == "EM"){
                 	   linkUrl = "<c:url value='/prs/purRq/purRqDetail.do'/>";
                    }else if(frm.tabId.value == "EF"){
                 	   linkUrl = "<c:url value='/prs/purRq/purRqLabEquipDetail.do'/>";
                    }else if(frm.tabId.value == "CR"){
                 	   linkUrl = "<c:url value='/prs/purRq/purRqWorkDetail.do'/>";
                    }else if(frm.tabId.value == "OM"){
                 	   linkUrl = "<c:url value='/prs/purRq/purRqOfficeDetail.do'/>";
                    }
                 	
                 	nwinsActSubmit(document.aform, linkUrl);	
             	}
            }	
        });
        
		var tabView = new Rui.ui.tab.LTabView({
			tabs: [
				{ label: '실험용 자재(비용)', 	content: '<div id="purExprMtrlDiv"></div>' },
        		{ label: '실험용 설비(투자)',    content: '<div id="purExprFaclDiv"></div>' },
                { label: '공사요청(투자)',       content: '<div id="purCsnwRqDiv"></div>' },
                { label: '사무용 자재(비용)',    content: '<div id="purOwkMtrlDiv"></div>' }
		    ]  
		});
		
		tabView.on('activeTabChange', function(e){
           var tabUrl = "";
           
           var tabCd  = e.activeIndex
           
           if( tabCd == '0'){
        	   frm.tabId.value = "EM";
           }else if(tabCd == '1' ){
        	   frm.tabId.value = "EF";
           }else if(tabCd == '2' ){
        	   frm.tabId.value = "CR";
           }else if(tabCd == '3' ){
        	   frm.tabId.value = "OM";
           }
           
           fnSearch();
       });

       tabView.render('tabView');

       fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/prs/pur/retrievePurRqList.do"/>' ,
	            params :{
	            	tabId : frm.tabId.value
                }
           });
       }
       
       if( Rui.isEmpty(frm.tabId.value) ){
    	   tabView.selectTab(0);
       } 
       
   
   });

</script>


</head>
<body>
<form id="aform" name ="aform">
<input type="hidden" id="tabId" name="tabId" value="<c:out value='${inputData.tabId}'/>">  
<input type="hidden" id="sCodeSeq" name="sCodeSeq" />
<input type="hidden" id="werks"  name="werks" value="1010"/>

<div class="contents">
	<div class="sub-content">
   		<div id="tabView"></div>
   		<div>
	   		<table>
				<tr><td>☞ 비용 : 1~2회 사용으로 소모되어 없어지는 disposable Items    (회계상 구매 즉시 비용 처리)</td></tr>
				<tr><td>☞ 투자 : 장기간 사용 가능 Item   (회계상 공구기구 등록 후 일정기간 동안 균분하여 감가상각비 처리)</td></tr>
			</table>
   		</div>
   		<br/>
   		 <div id="defaultGrid">
	</div>
</div>
</form>
</body>
</html>