<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: rlabTermStat.jsp
 * @desc    : 통계 > 신뢰성시험 > 연도별통계
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.04    		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
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
      	//날짜셋팅
		toRqprDt.setValue(new Date());
		fromRqprDt.setValue(new Date().add('M', -1));

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

        //시험구분별
        rlabTermStatDataSet = new Rui.data.LJsonDataSet({
            id: 'rlabTermStatDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'statGbn' }
            	, { id: 'cdNm' }
				, { id: 'cnt' }
				, { id: 'sum' }
            ]
        });


        //기간별
        var rlabTermStatColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
        	//,groupMerge:true
            ,columns: [
            	  { field: 'statGbn',	label: '구분',		vMerge: true,sortable: false,	align:'center',	width: 100 }
                , { field: 'cdNm',		label: '소구분',		vMerge: false,sortable: false,	align:'center',	width: 50 }
                , { field: 'cnt',		label: '실적',		vMerge: false,sortable: false,	align:'center',	width: 50 }
                , { field: 'sum',		label: '합계',		vMerge: true,sortable: false,	align:'center',	width: 100
                	, renderer: function(value, p, record, row, col){
               			return value.replace('a','').replace('b','').replace('c','').replace('d','').replace('e','');
                	}
                }
            ]
        });

        var rlabTermStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: rlabTermStatColumnModel,
            dataSet: rlabTermStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        rlabTermStatGrid.render('rlabTermStatGrid');

        /* 기간별통계 리스트 조회 */
        getRlabTermStatList = function(msg) {
        	rlabTermStatDataSet.load({
                url: '<c:url value="/stat/rlab/retrieveRlabTermStatList.do"/>',
                params :{
                	//yyyy : $("#yyyy option:selected").val()
                	frDt :  fromRqprDt.getValue()
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
        	getRlabTermStatList();
        };
	});	//end ready

</script>
</head>


<body>
<form name="aform" id="aform" method="post">
 <!-- contents -->
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
       		<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
       		<span class="hidden">Toggle 버튼</span>
       	</a>
		<h2>기간별 통계</h2>
	</div>
		<div class="sub-content">
			<form name="aform" id="aform" method="post">
	    	<div class="search">
			<div class="search-content">
    <table>
   					<colgroup>
						<col style="width: 120px;" />
                        <col style="width: 300px;" />
                        <col style="width: 120px;" />
                        <col style="width: 300px;" />
                        <col style="" />
					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">기간</th>
    						<td class="form_bd">
    							<input type="text" id="fromRqprDt"/><em class="gab"> ~ </em>
   								<input type="text" id="toRqprDt"/>
   							</td>
   								<td></td>
   							<td></td>
   							<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
   				</div>
	<div class="titArea">
					<!-- <span class="table_summay_number" id="cnt_text"></span>
					<div class="LblockButton">
						<button type="button" id="butRgst" name="butRgst">기기등록</button>
						<button type="button" id="butExcl" name="butExcl">EXCEL</button>
					</div> -->
				</div>

		<!-- 시험구분별통계 -->
   			<div id="rlabTermStatGrid"></div>
   				</form>
	</div>
	<!-- //sub-content -->
</div>
<!-- //contents -->
</form>
</body>
</html>