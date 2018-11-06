<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMachineLis.jsp
 * @desc    : 평가기기 >  관리 > 평가기기 등록 > 고정자산 조회 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.28     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>
<script type="text/javascript">
var yy = '${inputData.yy}';
var npCd = '${inputData.npCd}';
	Rui.onReady(function(){
		/* grid */
		var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        fields: [
				     { id: 'nm' }	  //신제품
				   , { id: 'm1' }		  //1월
				   , { id: 'm2' }		  //2월
				   , { id: 'm3' }		  //3월
				   , { id: 'm4' }		  //4월
				   , { id: 'm5' }		  //5월
				   , { id: 'm6' }		  //6월
				   , { id: 'm7' }		  //7월
				   , { id: 'm8' }		  //8월
				   , { id: 'm9' }		  //9월
				   , { id: 'm10' }		  //10월
				   , { id: 'm11' }		  //11월
				   , { id: 'm12' }		  //13월
				   , { id: 'npCd' }		  //13월
				   , { id: 'totSum' }		  //13월
				   ]
	    });

		var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	  { field: 'nm',	label: '신제품',		sortable: false,	align:'left',	width: 180 }
                 , { field: 'm1',			label: '1월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm2',			label: '2월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm3',			label: '3월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm4',			label: '4월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm5',			label: '5월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm6',			label: '6월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm7',			label: '7월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm8',			label: '8월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm9',			label: '9월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm10',			label: '10월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm11',			label: '11월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'm12',			label: '12월',		sortable: false,	align:'right',	width: 50 }
                 , { field: 'totSum',		label: '합계',		sortable: false,	align:'right',	width: 60 }
                 , { field:'npCd',  		hidden : true}

            ]
	    });

	    var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        height: 300,
	        autoToEdit: true,
	        autoWidth: true
	    });

	    grid.render('grid');

		fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/stat/prj/retrieveGenTssStatDtlPopList.do"/>',
				params :{
					 yy  : yy	//년도
					 ,npCd : npCd //과제코드
	                }
			});
		}
		fnSearch();

	});			//end Ready

</script>
</head>
<body>
	<div class="bd">
		<div class="sub-content">

			<form name="aform" id="aform" method="post">
<table class="searchBox">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
						</tr>
						<tr>
						</tr>
					</tbody>
				</table>
   					<div style="text-align:right;">
   						(단위:억원)
   					</div>
			<div id="grid"></div>

			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>