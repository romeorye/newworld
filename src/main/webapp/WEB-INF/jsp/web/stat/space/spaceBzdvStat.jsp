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
 * $Id		: spaceBzdvStat.jsp
 * @desc    : 통계 > 공간성능평가 > 담당자별통계
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
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



         var fromCmplDt = new Rui.ui.form.LMonthBox({
				applyTo: 'fromCmplDt',
				defaultValue: '<c:out value="${inputData.fromCmplDt}"/>',
				width: 100,
				dateType: 'String',
				vlaueFormat: '%Y-%m'
			});

        fromCmplDt.on('blur', function(){
				if( fromCmplDt.getValue() > toCmplDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromCmplDt.setValue(toCmplDt.getValue());
				}
			});

        var toCmplDt = new Rui.ui.form.LMonthBox({
				applyTo: 'toCmplDt',
				defaultValue: '<c:out value="${inputData.toCmplDt}"/>',
				width: 100,
				dateType: 'String',
				vlaueFormat: '%Y-%m'
			});

        toCmplDt.on('blur', function(){
				if( fromCmplDt.getValue() > toCmplDt.getValue() ) {
					//alert('시작일이 종료일보다 클 수 없습니다.!!'+toCmplDt.getValue());
					fromCmplDt.setValue(toCmplDt.getValue());
				}
			});

        //전체
        spaceBzdvStatDataSet = new Rui.data.LJsonDataSet({
            id: 'paceBzdvStatDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'sa_user' }
            	, { id: 'sa_name' }
				, { id: 'imfm_prsn_id' }
				, { id: 'last_acpc' }
				, { id: 'this_all_acpc' }
				, { id: 'this_acpc' }
				, { id: 'this_ing' }
				, { id: 'this_drop' }
				, { id: 'this_cmpl' }
				, { id: 'dd_avg' }
				, { id: 'cmpl_p' }
            ]
        });



        //
        var spaceBzdvStatColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
            ,columns: [
            	  { field: 'sa_name',		label: '담당자',		sortable: false,	align:'center',	width: 100 }
                , { field: 'last_acpc',		label: '이월건',		sortable: false,	align:'center',	width: 50 }
                , { field: 'this_all_acpc',		label: '평가접수',		sortable: false,	align:'center',	width: 50 }
                , { field: 'this_ing',		label: '평가진행',		sortable: false,	align:'center',	width: 50 }
                , { field: 'this_drop',		label: '평가중단',		sortable: false,	align:'center',	width: 50 }
                , { field: 'this_cmpl',		label: '평가완료',		sortable: false,	align:'center',	width: 50 }
                , { field: 'cmpl_p',		label: '완료율(%)',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		return value + '%';

                	}}
                , { field: 'dd_avg',		label: '평가완료기간(일)',		sortable: false,	align:'center',	width: 50 }
               // , { field: 'dd_avg',		label: '결과통보준수율(%)',		sortable: false,	align:'center',	width: 50 }
            ]
        });

        var spaceBzdvStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: spaceBzdvStatColumnModel,
            dataSet: spaceBzdvStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        spaceBzdvStatGrid.render('spaceBzdvStatGrid');






        /* 시험구분별통계 리스트 조회 */
        getSpaceBzdvStatList = function(msg) {

        	spaceBzdvStatDataSet.load({
                url: '<c:url value="/stat/space/getSpaceBzdvStatList.do"/>',
                params :{
                	fromCmplDt : fromCmplDt.getValue(),
        		    toCmplDt : toCmplDt.getValue()
                }
            });
        };





        //getRlabChrgStatList();

        /* 조회 */
        fnSearch = function() {
        	getSpaceBzdvStatList();
        };

        //getSpaceBzdvStatList();
	});	//end ready

</script>
</head>
</head>
<body onkeypress="if(event.keyCode==13) {getSpaceBzdvStatList();}">
	<!-- contents -->
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>
			<h2>담당자별 통계</h2>
		</div>
		<div class="sub-content">
			<div class="search mb20">
				<div class="search-content">
					<table>
						<colgroup>
							<col style="width:120px" />
							<col style="width: 300px;" />
                        	<col style="width: 120px;" />
                        	<col style="width: 300px;" />
							<col style="" />
						</colgroup>
						<tbody>
							<tr>
								<th align="right">기간</th>
								<td class="tain_bo">
									<input type="text" id="fromCmplDt" /><em class="gab">
										~ </em> <input type="text" id="toCmplDt" />
								</td>
								<td></td>
								<td></td>
								<td class="txt-right">
										<a style="cursor: pointer;margin-left:36px;"
									onclick="fnSearch();" class="btnL">검색</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
				<!-- 전체 -->
			<!-- <div class="titArea">
				<div class="LblockButton"></div>
			</div> -->
			<div id=spaceBzdvStatGrid></div>
		</div>
	 </div>

</body>
</html>