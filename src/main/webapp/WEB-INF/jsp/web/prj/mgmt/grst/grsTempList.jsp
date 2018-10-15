<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: grsTempList.jsp
 * @desc    :  심의 요청내역
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.28  jih		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>

<style>
    .grid-bg-color-sum {
        background-color: rgb(255,204,204);
    }
</style>
    <!-- 그리드 소스 -->
<script type="text/javascript">
    Rui.onReady(function() {


        /*******************
          * 변수 및 객체 선언 START
        *******************/


        var evSbcNmSch = new Rui.ui.form.LTextBox({
            applyTo: 'evSbcNmSch',
            placeholder: '검색할 템플릿명을 입력해주세요.',
            defaultValue: '${inputData.evSbcNmSch}',
            emptyValue: '',
            width: 500
       });



  		var grsYSch = new Rui.ui.form.LCombo({
        	applyTo: 'grsYSch',
            url: '<c:url value="/prj/tss/gen/retrieveGenTssGoalYy.do"/>',
            displayField: 'goalYy',
            valueField: 'goalYy',
            rendererField: 'value',
            autoMapping: true
        });

        var grsTypeSch = new Rui.ui.form.LCombo({ // 검색용 유형
			applyTo: 'grsTypeSch',
       		emptyText: '전체',
       		emptyValue: '',
       	  	defaultValue: '${inputData.grsTypeSch}',
       		useEmptyText: true,
       		width: 250,
			url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=GRS_TYPE"/>',
			displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD'
        });

	   	var useYnSch = new Rui.ui.form.LCombo({ // 검색용 성태
			applyTo : 'useYnSch',
			emptyText: '전체',
			emptyValue: '',
			defaultValue: '${inputData.useYnSch}',
			useEmptyText: true,
			url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=comm_YN"/>',
			displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD'
	   	});


        /*******************
          * 변수 및 객체 선언 END
        *******************/
        /*******************
         * 그리드 셋팅 START
         *******************/



         var mGridDataSet = new Rui.data.LJsonDataSet({ //masterGrid dataSet
 			id: 'mGridDataSet',
 			focusFirstRow: 0,
 	        lazyLoad: true,
 	        fields: [
 	                { id: 'grsEvSn'}, 			//GRS 일련번호
 	                { id: 'evStep_1'},          //평가STEP1
 	                { id: 'evStep_2'},          //평가STEP2
 	                { id: 'evStep_3'},          //평가STEP3
 	                { id: 'evPrvsNm_1'},        //평가항목명1
 	                { id: 'evPrvsNm_2'},        //평가항목명2
 	                { id: 'evCrtnNm'},          //평가기준명
 	                { id: 'evSbcTxt'},          //평가내용
 	                { id: 'dtlSbcTitl_1'},      //상세내용1
 	                { id: 'dtlSbcTitl_2'},      //상세내용2
 	                { id: 'dtlSbcTitl_3'},      //상세내용3
 	                { id: 'dtlSbcTitl_4'},      //상세내용4
 	                { id: 'dtlSbcTitl_5'},      //상세내용5
 	                { id: 'wgvl'},              //가중치
 	               	{ id: 'grsY'},              //년도
 	              	{ id: 'grsType'},           //유형
 	              	{ id: 'grsTypeNm'},           //유형
 	             	{ id: 'evSbcNm'},           //템플릿명
 	            	{ id: 'useYn'}              //사용여부
 	                ]
		});


        var mGridColumnModel = new Rui.ui.grid.LColumnModel({  //masterGrid column
            columns: [
                    { field: 'grsY',     	label: '년도',   sortable: false, align:'center', width: 120  },
          			{ field: 'grsTypeNm',   label: '유형',   sortable: false, align:'left', width: 430  },
          			{ field: 'evSbcNm',     label: '템플릿명',   sortable: false, align:'left', width: 650  , renderer: function(value){
                		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                	}},
          			{ field: 'useYn',    	label: '사용여부',   sortable: false, align:'center', width: 125  }



            ]
        });

        var masterGrid = new Rui.ui.grid.LGridPanel({ //masterGrid
            columnModel: mGridColumnModel,
            dataSet: mGridDataSet,
            height: 400,
            width: 600,
            autoToEdit: false,
            autoWidth: true
        });

        masterGrid.render('masterGrid'); //masterGrid render

        /*******************
         * 그리드 셋팅 END
        *******************/

        /*******************
          * Function 및 데이터 처리 START
        *******************/

        /**
        	총 건수 표시
        **/
        mGridDataSet.on('load', function(e){
        	var seatCnt = 0;
            var sumOrd = 0;
            var sumMoOrd = 0;
            var tmp;
            var tmpArray;
			var str = "";

        	document.getElementById("cnt_text").innerHTML = '총: '+mGridDataSet.getCount();
        	// 목록 페이징
	    	paging(mGridDataSet,"masterGrid");
        });

        masterGrid.on('cellClick', function(e){
        	var record = mGridDataSet.getAt(e.row);

        	document.getElementById('grsEvSn').value =  nullToString(record.get("grsEvSn"));
            nwinsActSubmit(document.xform, "<c:url value='/prj/mgmt/grst/grsTempDtl.do'/>");
        });


        /* [버튼] 과제등록 */
        var butNew = new Rui.ui.LButton('butNew');
        butNew.on('click', function() {
            nwinsActSubmit(document.xform, "<c:url value='/prj/mgmt/grst/grsTempDtl.do'/>");
        });


        /* GRS템플릿 리스트 검색 */
        fncSearch = function() {
       		mGridDataSet.load({
                url: '<c:url value="/prj/mgmt/grst/retrieveGrsTempList.do"/>',
                params: {
                	evSbcNm: escape(encodeURIComponent(document.xform.evSbcNmSch.value)) //과제명
                	,grsY: grsYSch.getValue()
                	,grsType: grsTypeSch.getValue()
                	,useYn: useYnSch.getValue()
                }
            });

        };


        fncSearch();
   });

</script>
</head>

<body onkeypress="if(event.keyCode==13) {fncSearch();}">
<Tag:saymessage/><!--  sayMessage 사용시 필요 -->
	<div class="contents" >
			<div class="titleArea">
				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>GRS 템플릿 관리</h2>
   		    </div>

   		    <div class="sub-content">
			<form name="xform" id="xform" method="post">
				<input type='hidden' id='grsEvSn' name='grsEvSn'>
				<div class="search">
					<div class="search-content">
		   				<table>
	   					<colgroup>
	   						<col style="width:120px" />
							<col style="width:400px" />
							<col style="width:120px" />
							<col style="width:200px" />
							<col style="" />
	   					</colgroup>
	   					<tbody>
	   						<tr>
	   							<th align="right">년도</th>
	   							<td>
	                                <div id="grsYSch" name='grsYSch'></div>
	   							</td>
	   							<th align="right">유형</th>
	   							<td>
	                                <div id="grsTypeSch"></div>
	   							</td>
	   							<td></td>
	   						</tr>
	   						<tr>
	   							<th align="right">템플릿명</th>
	   							<td>
	   								<input type="text" id="evSbcNmSch" value="">
	   							</td>
	   							<th align="right">상태</th>
	   							<td>
	                                <div id="useYnSch"></div>
	   							</td>
	   							<td class="txt-right">
		    						<a href="javascript:fncSearch()" class="btnL">검색</a>
		    					</td>
	   						</tr>

	   					</tbody>
	   				</table>
   				</div>
   			</div>

			</form>
    		<div class="titArea">
	    		<span class="Ltotal" id="cnt_text">총 : 0 </span>
    			<div class="LblockButton">
    				<button type="button" id="butNew" name="itemCreate" class="redBtn">GRS템플릿등록</button>
    			</div>
    		</div>
			<div id="masterGrid"></div>


		</div>
	</div>
</body>
</html>