<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: wbsStdList.jsp
 * @desc    :  표준 WBS 관리
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
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

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


        var stdTitl = new Rui.ui.form.LTextBox({
            applyTo: 'stdTitl',
            placeholder: '검색할 표준일정명을 입력해주세요.',
            defaultValue: '${inputData.stdTitl}',
            emptyValue: '',
            width: 500
       });



	   	var wbsScnCd = new Rui.ui.form.LCombo({ //WBS
			applyTo : 'wbsScnCd',
			emptyText: '전체',
			emptyValue: '',
			 defaultValue: '${inputData.wbsScnCd}',
			useEmptyText: true,
			url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=WBS_type"/>',
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
 	                { id: 'stdSn'}, 			//표준일정일련번호
 	                { id: 'stdTitl'},           //표준일정명
 	                { id: 'wbsScnCd'},          //WBS구분코드
 	                { id: 'wbsScnNm'},
 	                { id: 'lastRgstDt'},
 	                { id: 'lastRgstId'},
 	                { id: 'lastRgstNm'},
 	                ]
		});


        var mGridColumnModel = new Rui.ui.grid.LColumnModel({  //masterGrid column
            columns: [
                    { field: 'wbsScnNm',     	label: 'WBS 구분',   sortable: false, align:'center', width: 170  },
          			{ field: 'stdTitl',    		label: '표준일정명',   sortable: false, align:'left', width:790 , renderer: function(value){
                		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                	} },
          			{ field: 'lastRgstNm',    	label: '작성자',   sortable: false, align:'center', width: 170  },
          		    { field: 'lastRgstDt',     	label: '작성일',   renderer: function(value){
          		      return value.substring(0, 10);
          		      } ,sortable: false, align:'center', width: 170 }


            ]
        });

        var masterGrid = new Rui.ui.grid.LGridPanel({ //masterGrid
            columnModel: mGridColumnModel,
            dataSet: mGridDataSet,
            height: 450,
            width: 400,
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

        	console.log(record.get('stdSn'));

        	document.getElementById('stdSn').value =  nullToString(record.get("stdSn"));


        	document.getElementById('wbsScnNmRe').value =  nullToString(record.get("wbsScnNm"));
        	document.getElementById('stdTitlRe').value =  nullToString(record.get("stdTitl"));

            nwinsActSubmit(document.xform, "<c:url value='/prj/mgmt/wbsStd/wbsStdDtl.do'/>");
        });

        <%--/*******************************************************************************
         * FUNCTION 명 : fncSearch
         * FUNCTION 기능설명 : 목록조회
         *******************************************************************************/--%>
        fncSearch = function() {
 			mGridDataSet.load({
                url: '<c:url value="/prj/mgmt/wbsStd/retrieveWbsStdList.do"/>',
                params: {
                	 stdTitl: escape(encodeURIComponent(document.xform.stdTitl.value)) //과제명
                	,wbsScnCd: wbsScnCd.getValue()

                }
            });

        };

        init = function() {
        	mGridDataSet.load({
                url: '<c:url value="/prj/mgmt/wbsStd/retrieveWbsStdList.do"/>',
                params: {
                	 stdTitl: escape(encodeURIComponent('${inputData.stdTitl}')) //과제명
                	,wbsScnCd:'${inputData.wbsScnCd}'

                }
            });
        }
   });

</script>
</head>

<body onload="init();">
<Tag:saymessage/><!--  sayMessage 사용시 필요 -->
	<div class="contents" >
			<div class="titleArea">
				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>표준 WBS 관리</h2>
   		    </div>

		<div class="sub-content">
			<form name="xform" id="xform" method="post">
				<input type='hidden' id='stdSn' name='stdSn'>
				<input type='hidden' id='wbsScnNmRe' name='wbsScnNmRe'>
				<input type='hidden' id='stdTitlRe' name='stdTitlRe'>
				<div class="search">
						<div class="search-content">
			   				<table>
			   					<colgroup>
			   						<col style="width:120px;"/>
			   						<col style="width:120px;"/>
			   						<col style="width:100px;"/>
			   						<col style=""/>
			   						<col style=""/>
			   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">WBS 구분</th>
		   							<td>
		                                <div id="wbsScnCd" name='wbsScnCd'></div>
		   							</td>

		   							<th align="right">표준일정명</th>
		   							<td>
		   								<input type="text" id="stdTitl" value="">
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
    		</div>

			<div id="masterGrid"></div>
			</div>

	</div>
</body>
</html>