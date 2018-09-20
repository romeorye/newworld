<%@ page language="java" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
<%@ page
	import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: spaceEvAffrStts.jsp
 * @desc    : 통계 > 공간성능평가 > 평가업무현황
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.14    		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
<link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css"
	href="<%=ruiPathPlugins%>/tab/rui_tab.css" />
<style>
.bgcolor-gray {
	background-color: #999999
}

.bgcolor-white {
	background-color: #FFFFFF
}

.L-navset {
	overflow: hidden;
}
</style>
<script type="text/javascript">
var mchnPrctInfoDialog;
var mchnPrctId;

var frtTab;
var rtnUrl;
var mchnInfoId;

	Rui.onReady(function() {


		/********************
         * 버튼 및 이벤트 처리와 랜더링
         ********************/



        var yy = new Rui.ui.form.LCombo({
            applyTo: 'yy',
            name: 'yy',
            emptyText: '선택',
            defaultValue: '',
            emptyValue: '',
            width: 110,
            selectedIndex:0,
            useEmptyText: false,
            url: '<c:url value="/stat/rlab/retrieveRlabYyList.do"/>',
            displayField: 'yy',
            valueField: 'yy'
        });

        //전체
        spaceEvAffrSttsDataSet = new Rui.data.LJsonDataSet({
            id: 'spaceEvAffrSttsDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'SPACE_UGY_YN' }
            	, { id: 'SPACE_UGY_NM' }
            	, { id: 'SPACE_SCN_CD' }
            	, { id: 'SPACE_SCN_NM' }
            	, { id: 'SPACE_SCN_ORD' }
            	, { id: 'CNT' }
            	, { id: 'AVG_CNT' }
            	, { id: 'DD_CNT' }
            	, { id: 'AVG_DD' }
            	, { id: 'M1' }
				, { id: 'M2' }
				, { id: 'M3' }
				, { id: 'M4' }
				, { id: 'M5' }
				, { id: 'M6' }
				, { id: 'M7' }
				, { id: 'M8' }
				, { id: 'M9' }
				, { id: 'M10' }
				, { id: 'M11' }
				, { id: 'M12' }
            ]
        });



        //
        var spaceEvAffrSttsColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
            ,columns: [
            	  { field: 'SPACE_UGY_NM',		label: '구분',		sortable: false,	align:'center',	width: 100, vMerge:true}
                , { field: 'SPACE_SCN_NM',		label: '상세구분',		sortable: false,	align:'center',	width: 50}
                , { field: 'CNT',				label: '합계',		sortable: false,	align:'center',	width: 50 }
                , { field: 'AVG_CNT',			label: '월평균',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M1',				label: '1월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M2',				label: '2월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M3',				label: '3월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M4',				label: '4월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M5',				label: '5월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M6',				label: '6월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M7',				label: '7월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M8',				label: '8월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M9',				label: '9월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M10',				label: '10월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M11',				label: '11월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'M12',				label: '12월',		sortable: false,	align:'center',	width: 50 }
            ]
        });

        var spaceEvAffrSttsGrid = new Rui.ui.grid.LGridPanel({
            columnModel: spaceEvAffrSttsColumnModel,
            dataSet: spaceEvAffrSttsDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        spaceEvAffrSttsGrid.render('spaceEvAffrSttsGrid');




        /* 시험구분별통계 리스트 조회 */
        getSpaceEvAffrSttsList = function(msg) {

        	spaceEvAffrSttsDataSet.load({
                url: '<c:url value="/stat/space/getSpaceEvAffrSttsList.do"/>',
                params :{
                	//yyyy :  yy.getValue()
                	yyyy : '2018'
                }
            });
        };




        /* 조회 */
        fnSearch = function() {
        	getSpaceEvAffrSttsList();
        };
	});	//end ready

</script>
</head>


<body>
	<!-- contents -->
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a> 
			<h2>연도별 통계</h2>
		</div>
		
		<div class="sub-content">
			<div class="search mb20">
				<div class="search-content">	
					<table>
						<colgroup>
							<col style="width:120px" />
							<col style="width:400px" />
							<col style="" />
						</colgroup>
						<tbody>
							<tr>
								<th align="right">연도</th>
								<td class="tain_bo">
									<div id="yy"></div>
								</td>
								<td class="txt-right"><a style="cursor: pointer;"
									onclick="fnSearch();" class="btnL">검색</a></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		
			<!-- 
			<div class="titArea">
				<div class="LblockButton"></div>
			</div> -->
			<div id="spaceEvAffrSttsGrid"></div>
		</div>	
			<!-- //sub-content -->

	</div>
		<!-- //contents -->
</body>
</html>