<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: rlabMchnUseStat.jsp
 * @desc    : 통계 > 신뢰성시험 > 장비사용통계
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.10    		최초생성
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
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>
<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .L-navset {overflow:hidden;}
</style>
<script type="text/javascript">
var mchnPrctInfoDialog;
var mchnPrctId;

var frtTab;
var rtnUrl;
var mchnInfoId;

	Rui.onReady(function() {

		mchnClDtlCdDataSet = new Rui.data.LJsonDataSet({
             id: 'mchnClDtlCdDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
             	  { id: 'COM_DTL_CD' }
             	, { id: 'COM_DTL_NM' }
             ]
         });

		//소분류
		 var mchnClDtlCd = new Rui.ui.form.LCombo({
		 	applyTo : 'mchnClDtlCd',
			name : 'mchnClDtlCd',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    dataSet: mchnClDtlCdDataSet,
			displayField: 'COM_DTL_NM',
			width: 180,
			valueField: 'COM_DTL_CD'
		});

		//대분류
		var cbmchnClCd = new Rui.ui.form.LCombo({
		 	applyTo : 'mchnClCd',
			name : 'mchnClCd',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    url: '<c:url value="/stat/rlab/retrieveRlabMchnClCd.do"/>',
			displayField: 'COM_DTL_NM',
			valueField: 'COM_DTL_CD',
			width: 150
		});

		cbmchnClCd.on('changed', function(e){
			mchnClDtlCdDataSet.clearData();
			mchnClDtlCdDataSet.load({
                url: '<c:url value="/stat/rlab/retrieveRlabMchnClDtlCd.do"/>'
                ,params :{
                	exatCd : e.value
                }
            });
		});

		var fromRqprDt = new Rui.ui.form.LDateBox({
			applyTo: 'fromRqprDt',
			mask: '9999-99-99',
			displayValue: '%Y-%m-%d',
			editable: false,
			width: 100,
			dateType: 'string'
		});

        fromRqprDt.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromRqprDt.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				fromRqprDt.setValue(new Date());
			}

			if( fromRqprDt.getValue() > toRqprDt.getValue() ) {
				alert('시작일이 종료일보다 클 수 없습니다.!!');
				fromRqprDt.setValue(toRqprDt.getValue());
			}
		});

        var toRqprDt = new Rui.ui.form.LDateBox({
			applyTo: 'toRqprDt',
			mask: '9999-99-99',
			displayValue: '%Y-%m-%d',
			editable: false,
			width: 100,
			dateType: 'string'
		});

		toRqprDt.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toRqprDt.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				toRqprDt.setValue(new Date());
			}

			if( fromRqprDt.getValue() > toRqprDt.getValue() ) {
				alert('시작일이 종료일보다 클 수 없습니다.!!');
				fromRqprDt.setValue(toRqprDt.getValue());
			}
		});

        //장비사용
        rlabMchnUseStatDataSet = new Rui.data.LJsonDataSet({
            id: 'rlabMchnUseStatDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'deptName' }
            	, { id: 'exatDt' }
				, { id: 'exatTim' }
				, { id: 'exatQty' }
				, { id: 'mchnUse' }
            ]
        });


        //장비사용
        var rlabMchnUseStatColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
        	//,groupMerge:true
            ,columns: [
            	  { field: 'deptName',	label: '팀(prj)명',		sortable: false,	align:'center',	width: 100 }
                , { field: 'exatDt',		label: '기간',		sortable: false,	align:'center',	width: 50 }
                , { field: 'exatTim',		label: '시간(일)',		sortable: false,	align:'center',	width: 50 }
                , { field: 'exatQty',		label: '시료수',		sortable: false,	align:'center',	width: 50 }
                , { field: 'mchnUse',		label: '장비사용률',		sortable: false,	align:'center',	width: 50 }
            ]
        });

        var rlabMchnUseStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: rlabMchnUseStatColumnModel,
            dataSet: rlabMchnUseStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        rlabMchnUseStatGrid.render('rlabMchnUseStatGrid');

        /* 장비사용통계 리스트 조회 */
        getRlabMchnUseStatList = function(msg) {
        	rlabMchnUseStatDataSet.load({
                url: '<c:url value="/stat/rlab/retrieveRlabMchnUseStatList.do"/>',
                params :{
                	supiExatCd : cbmchnClCd.getValue()
                	,exatCd : mchnClDtlCd.getValue()
                	,frDt :  fromRqprDt.getValue()
                	,toDt : toRqprDt.getValue()

                }
            });
        };

        /* 조회 */
        fnSearch = function() {
        	if(fromRqprDt.getValue()==''||toRqprDt.getValue()==''){
        		alert("기간이 입력되지 않았습니다.");
        		return;
        	}
        	if(cbmchnClCd.getValue()==''||cbmchnClCd.getValue()==null||mchnClDtlCd.getValue()==''||mchnClDtlCd.getValue()==null){
        		alert("장비구분이 선택되지 않았습니다.");
        		return;
        	}
        	getRlabMchnUseStatList();
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
		<h2>장비사용 통계</h2>
    </div>
    <div class="sub-content">
    	<form name="aform" id="aform" method="post">
    	<div class="search">
		<div class="search-content">
    		<table>
   					<colgroup>
   						<col style="width:10%;"/>
   						<col style="width:35%;"/>
   						<col style="width:10%;"/>
   						<col style="width:35%;"/>
   						<col style="width:10%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">장비구분</th>
    						<td>
    							<div id="mchnClCd" class="form_bd"></div>
								&nbsp; / &nbsp;
								<div id="mchnClDtlCd" class="form_bd"></div>
    						</td>
   							<th align="right">기간</th>
    						<td class="form_bd">
    							<input type="text" id="fromRqprDt"/><em class="gab"> ~ </em>
   								<input type="text" id="toRqprDt"/>
    						</td>
   							<td class="txt-right">
   								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
				</div>
		<!-- 장비사용통계 -->
   			<div class="titArea">
   				<div class="LblockButton">
   				</div>
	   		</div>
   			<div id="rlabMchnUseStatGrid"></div>
   			</form>
	</div>
	<!-- //sub-content -->
</div>
<!-- //contents -->

</body>
</html>