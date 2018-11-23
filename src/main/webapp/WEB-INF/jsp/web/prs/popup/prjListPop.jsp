<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: prjListPop.jsp
 * @desc    : 프로젝트 코드 리스트 팝업 화면
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

<script type="text/javascript">
	
	Rui.onReady(function() {
		
		var dataSet = new Rui.data.LJsonDataSet({
			id: 'dataSet',
		    remainRemoved: true,
		    fields: [
		    	  { id: 'posid'}	/*wbs cd*/
		    	 ,{ id: 'post1'}	/*프로젝트명*/
		    	 ,{ id: 'ename'}	/* 리더이름 이라는데 리더이름이 아닌거 같음*/
		    	 ,{ id: 'fkstl'}	/*투자코드 가 들어와야 함*/
		    	 ,{ id: 'wonjang'}	/* 책임코스트센터 가 들어와야함*/
		    	 ,{ id: 'pernr'}	/* 사번*/
		    ]
		});	
		
		dataSet.on('load', function(e){
		
		});

		var columnModel = new Rui.ui.grid.LColumnModel({
		     groupMerge: true,
		     columns: [
		        	{ field: 'posid', 		label:'Project Code' , 	sortable: false, align: 'center', width: 80},
		            { field: 'post1',  		label:'Porject Name', 	sortable: false, align: 'center', width: 200},
		            { field: 'ename',  		label:'Project Reader',	sortable: false, align: 'right',  width: 60},
		            { field: 'fkstl',  		label:'투자코드', 	sortable: false, align: 'center', width: 60},
		            { field: 'wonjang', 	label: '책임코스트세터', 		sortable: false, align: 'center', width: 60},
		            { field: 'pernr',  		hidden : true}
		        ]
		 });

		var grid = new Rui.ui.grid.LGridPanel({
		    columnModel: columnModel,
		    dataSet: dataSet,
		    width:560,
		    height: 300,
		    autoWidth : true
		});

		grid.render('prjListGrid');
		
		grid.on('cellDblClick', function(e) {
			parent.setWbsCdInfo(dataSet.getAt(e.row).data);
			parent.prjInfoListDialog.submit(true);
        });
		
		fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/prs/pur/retrieveWbsCdInfoList.do"/>' ,
	            params :{
	            	adminYn : "Y"
                }
           });
        }
		
		fnSearch();
		
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
	    <h2>Project List</h2>
    </div>

<form id="aform" name ="aform">
	<div class="sub-content">
	   <font color="red"> ※ 국책과제 참여 연구원은 반드시 국책과제 코드를 사용해 주십시오.</font> 
	   <br/>
		<div id="prjListGrid"></div>
	</div>
</form>
</body>
</html>