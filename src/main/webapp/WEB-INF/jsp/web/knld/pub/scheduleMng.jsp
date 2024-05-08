<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: knldScheduleMng.jsp
 * @desc    : 연구소 주요일정 관리
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
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

<link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
<link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .L-navset {overflow:hidden;}
</style>

	<script type="text/javascript">

		var callback;
		var anlRqprDataSet;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = dayDataSet.getReadData(e);

                alert(data.records[0].resultMsg);

                if(data.records[0].resultYn == 'Y') {
                	goAnlRqprList();
                }
            });

            /********************
             * 버튼 및 이벤트 처리와 랜더링
             ********************/

            var tabView = new Rui.ui.tab.LTabView({
            	//height: 690,
                tabs: [ {
                        active: true,
                        label: '월별',
                        id: 'monthDiv'
                    }, {
                    	label: '일별',
                        id: 'dayDiv'
                    }]
            });

            tabView.on('canActiveTabChange', function(e){

	            switch(e.activeIndex){
	            case 0:

	                break;

	            case 1:

	                break;

	            default:
	                break;
	            }
            });

            tabView.on('activeTabChange', function(e){

                switch(e.activeIndex){
                case 0:
                    break;

                case 1:
                    if(e.isFirst){
                    }

                    break;

                default:
                    break;
                }

            });

            tabView.render('tabView');

            var fromAdscDt = new Rui.ui.form.LDateBox({
				applyTo: 'fromAdscDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '${inputData.fromAdscDt}',
				editable: false,
				width: 100,
				dateType: 'string'
			});

            fromAdscDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromAdscDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					fromAdscDt.setValue(new Date());
				}

				if( fromAdscDt.getValue() > toAdscDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromAdscDt.setValue(toAdscDt.getValue());
				}
			});

            var toAdscDt = new Rui.ui.form.LDateBox({
				applyTo: 'toAdscDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '${inputData.toAdscDt}',
				editable: false,
				width: 100,
				dateType: 'string'
			});

			toAdscDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toAdscDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					toAdscDt.setValue(new Date());
				}

				if( fromAdscDt.getValue() > toAdscDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromAdscDt.setValue(toAdscDt.getValue());
				}
			});

            var adscKindCd = new Rui.ui.form.LCombo({
                applyTo: 'adscKindCd',
                name: 'adscKindCd',
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ADSC_KIND_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            dayDataSet = new Rui.data.LJsonDataSet({
                id: 'dayDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'labtAdscId' }
                	, { id: 'adscKindNm' }
					, { id: 'adscDt' }
					, { id: 'adscTim' }
					, { id: 'adscTitl' }
					, { id: 'rgstNm' }
					, { id: 'isToday' }
                ]
            });

            var dayColumnModel = new Rui.ui.grid.LColumnModel({
            	groupMerge: true,
                columns: [
                	  { field: 'adscDt',		label: '일자',		sortable: false,	align:'center',	width: 180, vMerge: true,
                    	renderer: function(val, p, record, row, col) {
                    		var adscDt;

                    		if(record.get('isToday') == 'Y') {
                    			adscDt = '<b><span style="color:red;">' + val + '</span></b>';
                    		} else {
                    			adscDt = val;
                    		}

                    		if('${inputData._roleId}'.indexOf('WORK_IRI_T01') > -1 || '${inputData._userDept}' == "58129833") {
                        		return adscDt + ' <button type="button" class="L-grid-button L-popup-action" style="width:40px;">등록</button>';
                    		} else {
                    			return adscDt;
                    		}
                    } }
                    , { field: 'adscTim',		label: '시간',		sortable: false,	align:'center',	width: 150,
                    	renderer: function(val, p, record, row, col) {
                    		if(record.get('isToday') == 'Y') {
                    			return '<b><span style="color:red;">' + (Rui.isEmpty(val) ? '' : val) + '</span></b>';
                    		} else {
                    			return val;
                    		}
                    } }
                    , { field: 'adscTitl',		label: '제목',		sortable: false,	align:'left',	width: 595,
                    	renderer: function(val, p, record, row, col) {
                    		if(record.get('isToday') == 'Y') {
                    			return '<b><span style="color:red;">' + (Rui.isEmpty(val) ? '' : val) + '</span></b>';
                    		} else {
                    			return val;
                    		}
                    } }
                    , { field: 'adscKindNm',	label: '구분',		sortable: false,	align:'center',	width: 300,
                    	renderer: function(val, p, record, row, col) {
                    		if(record.get('isToday') == 'Y') {
                    			return '<b><span style="color:red;">' + (Rui.isEmpty(val) ? '' : val) + '</span></b>';
                    		} else {
                    			return val;
                    		}
                    } }
                    , { field: 'rgstNm',		label: '등록자',		sortable: false,	align:'center',	width: 100,
                    	renderer: function(val, p, record, row, col) {
                    		if(record.get('isToday') == 'Y') {
                    			return '<b><span style="color:red;">' + (Rui.isEmpty(val) ? '' : val) + '</span></b>';
                    		} else {
                    			return val;
                    		}
                    } }
                ]
            });

            var dayGrid = new Rui.ui.grid.LGridPanel({
                columnModel: dayColumnModel,
                dataSet: dayDataSet,
                width: 810,
                height: 570,
                autoToEdit: false,
                autoWidth: true
            });

            dayGrid.on('cellClick', function(e) {
            	var labtAdscId = dayDataSet.getNameValue(e.row, 'labtAdscId');

            	if('adscTim|adscTitl'.indexOf(e.colId) > -1 && Rui.isEmpty(labtAdscId) == false) {
            		openScheduleDetailDialog(labtAdscId);
            	}
            });

            dayGrid.on('popup', function(e){
            	openScheduleRgstDialog(dayDataSet.getNameValue(e.row, 'adscDt'));
            });

            dayGrid.render('dayGrid');

    	    // 연구소 주요일정 팝업 시작
    	    scheduleDetailDialog = new Rui.ui.LFrameDialog({
    	        id: 'scheduleDetailDialog',
    	        title: '연구소 주요일정',
    	        width: 820,
    	        height: 460,
    	        modal: true,
    	        visible: false
    	    });

    	    scheduleDetailDialog.render(document.body);

    	    openScheduleDetailDialog = function(labtAdscId) {
    	    	scheduleDetailDialog.setUrl('<c:url value="/knld/schedule/scheduleDetailPopup.do?labtAdscId="/>' + labtAdscId);
    	    	scheduleDetailDialog.show();
    	    };

    	    openScheduleRgstDialog = function(adscDt) {
    	    	scheduleDetailDialog.setUrl('<c:url value="/knld/schedule/saveSchedulePopup.do?labtAdscId=&adscDt="/>' + adscDt);
    	    	scheduleDetailDialog.show();
    	    };
    	    // 연구소 주요일정 팝업 끝

            /* 일별 리스트 조회 */
            getDayScheduleList = function() {
            	dayDataSet.load({
                    url: '<c:url value="/knld/schedule/getDayScheduleList.do"/>',
                    params :{
                    	adscKindCd : adscKindCd.getValue(),
            		    fromAdscDt : fromAdscDt.getValue(),
            		    toAdscDt : toAdscDt.getValue()
                    }
                });
            };

            /* 월별 리스트 조회 */
            getMonthScheduleList = function(adscMonth) {
                var params = {
                	adscMonth : adscMonth
                };

            	Rui.ajax({
            		params : params,
                    url: '<c:url value="/knld/schedule/getMonthScheduleList.do"/>',
                    success: function(e) {
                    	$('#monthDiv').html(e.responseText);
                    },
                    failure: function(e) {
                        alert("작업을 실패했습니다.\n관리자에게 문의하세요.");
                    }
                }, params);
            };

            getDayScheduleList();
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
   				<h2>연구소 주요일정</h2>
   			</div>
	   		<div class="sub-content">
   				<div id="tabView"></div>
	            <div id="monthDiv">
					<jsp:include page="/WEB-INF/jsp/web/knld/pub/scheduleMonthList.jsp"/>
   				</div>

   				<div id="dayDiv">
				<form name="bform" id="bform" method="post">
				<br/>
				<div class="search">
					<div class="search-content">
		   				<table id="sch_day">
		   					<colgroup>
		   						<col style="width:10%;"/>
		   						<col style="width:35%;"/>
		   						<col style="width:10%;"/>
		   						<col style="width:35%;"/>
		   						<col style="width:10%;"/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">일정구분</th>
		   							<td>
		   								<div id="adscKindCd"></div>
		   							</td>
		   							<th align="right">선택일자</th>
		   							<td>
		   								<input type="text" id="fromAdscDt"/><em class="gab"> ~ </em>
		   								<input type="text" id="toAdscDt"/>
		   							</td>
		   							<td class="t_center">
		   								<a style="cursor: pointer;" onclick="getDayScheduleList();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>
   				<br>
   				<div id="dayGrid"></div>
				</form>
   				</div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>