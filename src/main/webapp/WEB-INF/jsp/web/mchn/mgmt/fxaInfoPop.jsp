<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMachineLis.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 등록 > 고정자산 조회 팝업
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

<%-- staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<%-- rui Validator --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/validate/LCustomValidator.js"></script>

<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
%>


<script type="text/javascript">

	Rui.onReady(function(){
		/*******************
	     * 변수 및 객체 선언
	     *******************/
		var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                { id: 'fxaNm' },
                { id: 'fxaNo' },
                { id: 'crgrNm' },
                { id: 'fxaLoc' },
                { id: 'obtDt' },
                { id: 'obtPce' },
                { id: 'bkpPce' }
            ]
        });

        var columnModel = new Rui.ui.grid.LColumnModel({
            groupMerge: true,
            columns: [
            	{ field: 'fxaNm', 	label:'자산명' , 	sortable: false, align: 'left', width: 280},
                { field: 'fxaNo',  	label:'자산번호', 	sortable: false, align: 'center', width: 110},
                { field: 'crgrNm',  label:'담당자', 	sortable: false, align: 'center', width: 80},
                { field: 'fxaLoc',  label:'위치', 		sortable: false, align: 'center', width: 130},
                { field: 'obtDt', 	label: '취득일', 	sortable: false, align: 'center', width: 90},
                { field: 'obtPce', 	label: '취득가',   	sortable: false, align: 'center', width: 100, renderer: function(value, p, record){
 	        		return Rui.util.LFormat.numberFormat(parseInt(value));
 		        	}
             	},
                { field: 'bkpPce',  label:'장부가' , 	sortable: false, align: 'center', width: 100, renderer: function(value, p, record){
 	        		return Rui.util.LFormat.numberFormat(parseInt(value));
 		        	}
             	}
            ]
        });

        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 910,
            height: 280,
            autoWidth: true,
        });

        grid.render('fxaGrid');

        grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());

			if(dataSet.getRow() > -1) {
				parent.fncRecall(record);
				parent.faxInfoDialog.submit(true);
			}
     	});


        fnSearch = function() {
	    	dataSet.load({
	        url: '<c:url value="/mchn/mgmt/retrieveFxaInfoSearchList.do"/>' ,
           	params :{
           		    fxaNm :  encodeURIComponent(document.aform.fxaNm.value)		//자산명
           	       ,fxaNo  : document.aform.fxaNo.value		//자산번호
           	       ,crgrNm : encodeURIComponent(document.aform.crgrNm.value)		//담당자
           	       ,fxaLoc : encodeURIComponent(document.aform.fxaLoc.value)		//위치
	                }
            });
        }

       	fnSearch();

	});

</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="bd">
		<div class="sub-content" style="padding:0;">

			<form name="aform" id="aform" method="post">
				<div class="search">
					<div class="search-content">
						<table>
							<colgroup>
								<col style="width:100px" />
								<col style="width:200px" />
								<col style="width:100px" />
								<col style="width:200px" />
								<col style="width:" />
							</colgroup>
							<tbody>
								<tr>
									<th align="right">자산명</th>
									<td><span> <input type="text" class="" id="fxaNm"	name="fxaNm" ></span></td>
									<th align="right">자산번호</th>
									<td>
										<span> <input type="text" class="" id=fxaNo name="fxaNo" >
									</td>
									<td></td>
								</tr>
								<tr>
									<th align="right">담당자</th>
									<td>
										<span> <input type="text" class="" id=crgrNm name="crgrNm" >
									</td>
									<th align="right">위치</th>
									<td>
										<span> <input type="text" class="" id=fxaLoc name="fxaLoc" >
									</td>
									<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<br/>
				<div id="fxaGrid"></div>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>