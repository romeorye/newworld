<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id      : grsReqList.jsp
 * @desc    :  심의 요청내역
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.28  jih     최초생성
 * ---  ----------- ----------  -----------------------------------------
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>
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

<%
    HashMap inputData = (HashMap)request.getAttribute("inputData");
%>
    <!-- 그리드 소스 -->
<script type="text/javascript">
    Rui.onReady(function() {

        /*******************
          * 변수 및 객체 선언 START
        *******************/
        var tssNmSch = new Rui.ui.form.LTextBox({
            applyTo: 'tssNmSch',
            placeholder: '검색할 과제명을 입력해주세요.',
            defaultValue: '${inputData.tssNmSch}',
            emptyValue: '',
            width: 500
        });
        var wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            placeholder: '검색할 WBS코드를 입력해주세요.',
            defaultValue: '${inputData.wbsCd}',
            emptyValue: '',
            width: 200
        });

        var bizDtpCd = new Rui.ui.form.LCombo({ // 검색용 과제유형
            applyTo: 'bizDtpCd',
            emptyText: '전체',
            emptyValue: '',
            defaultValue: '${inputData.bizDtpCd}',
            useEmptyText: true,
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=BIZ_DPT_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD'
        });

        var grsEvStSch = new Rui.ui.form.LCombo({ // 검색용 상태
            applyTo: 'grsEvStSch',
            emptyText: '전체',
            emptyValue: '',
            defaultValue: '${inputData.grsEvStSch}',
            useEmptyText: true,
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=GRS_EV_ST"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD'
        });

        var tssScnCd = new Rui.ui.form.LCombo({ // 검색용 과제유형
            applyTo : 'tssScnCd',
            emptyText: '전체',
            emptyValue: '',
            defaultValue: '${inputData.tssScnCd}',
            useEmptyText: true,
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_SCN_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD'
        });
        
        var grsSt =  new Rui.ui.form.LCombo({
            applyTo : 'grsSt',
            emptyValue: '',
            emptyText: '선택하세요',
            defaultValue: '${inputData.grsSt}',
			items: [
				{ text: 'GRS요청', value: '101'},
                { text: 'GRS완료', value: '102' }
                ]
           
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
                    { id: 'tssScnCd' }, //과제 구분
                    { id: 'tssScnNm' },
                    { id: 'wbsCd' }, //WBS코드
                    { id: 'pkWbsCd' }, //WBS코드
                    { id: 'tssNm' }, //과제명
                    { id: 'bizDptCd' } ,  //과제유형
                    { id: 'bizDptNm' } ,
                    { id: 'dlbrParrDt' }, //요청일
                    { id: 'dlbrCrgr' }, //담당자
                    { id: 'dlbrCrgrNm' }, //담당자
                    { id: 'grsEvSt' } ,  //심의단계
                    { id: 'grsEvStNm' },
                    { id: 'tssSt' }, //과제 상태
                    { id: 'tssStNm' }, //과제 상태
                    { id: 'tssCd' }, //과제 코드
                    { id: 'grsEvSn' }, //평가 코드
                    { id: 'tssCdSn' },
                    { id: 'frstRgstId'} //등록자
             ]
        });


        var mGridColumnModel = new Rui.ui.grid.LColumnModel({  //masterGrid column
            autoWidth: true,
            columns: [
                    { field: 'tssScnNm',     label: '과제 구분',    align:'center',    width: 120 },
                    { field: 'wbsCd',        label: '과제코드',     align:'center',    width: 120 },
                    { field: 'tssNm',        label: '과제명',       align:'left',      width: 200  , renderer: function(value){
                        return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                    } },
                    { field: 'bizDptNm',     label: '과제유형',     align:'center',    width: 120 },
                    { field: 'dlbrParrDt',   label: '심의예정일',   align:'center',    width: 120 },
                    { field: 'dlbrCrgrNm',   label: '심의담당자',   align:'center',    width: 100 },
                    { field: 'grsEvStNm',    label: '심의단계',     align:'center',    width: 100 },
                    { field: 'tssStNm',      label: '상태',         align:'center',    width: 100 }
            ]
        });

        var masterGrid = new Rui.ui.grid.LGridPanel({ //masterGrid
            columnModel: mGridColumnModel,
            dataSet: mGridDataSet,
            height: 550,
            width: 600,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
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

        });

        masterGrid.on('cellClick', function(e){
            var record = mGridDataSet.getAt(e.row);

			document.getElementById('grsEvSn').value =  nullToString(record.get("grsEvSn"));
			document.getElementById('tssCd').value   =  nullToString(record.get("tssCd"));
			document.getElementById('tssCdSn').value     =  nullToString(record.get("tssCdSn"));
			document.getElementById('tssSt').value   =  nullToString(record.get("tssSt"));
			document.getElementById('tssStNm').value     =  record.get("tssStNm") == "GRS요청" ? "1" : "2" ;
			document.getElementById('tssNmSch').value    =  tssNmSch.getValue();
			document.getElementById('bizDtpCd').value    =  bizDtpCd.getValue();
			document.getElementById('grsEvStSch').value  =  grsEvStSch.getValue();
			document.getElementById('tssScnCd').value    =  tssScnCd.getValue();
			nwinsActSubmit(document.xform, "<c:url value='/prj/grs/grsEvRsltDtl.do'/>");

//             document.getElementById('MW_TODO_REQ_NO').value      =  nullToString(record.get("tssCd"))+nullToString(record.get("tssCdSn"));
//             nwinsActSubmit(document.xform, "<c:url value='/prj/grs/grsReqDtlToDo.do'/>");
        });

 <%--/*******************************************************************************
  * FUNCTION 명 : init
  * FUNCTION 기능설명 :화면로딩
  *******************************************************************************/--%>
        init = function() {
            mGridDataSet.load({
                url: '<c:url value="/prj/grs/retrieveGrsReqList.do"/>',
                params: {
                    tssNm: escape(encodeURIComponent('${inputData.tssNmSch}')) //과제명
                    ,bizDtpCd: '${inputData.bizDtpCd}'
                    ,grsEvSt:'${inputData.grsEvStSch}'
                    ,tssScnCd:'${inputData.tssScnCd}'
                    ,grsSt:'${inputData.grsSt}'
                }
            });
        }



 <%--/*******************************************************************************
  * FUNCTION 명 : fncSearch
  * FUNCTION 기능설명 :검색
  *******************************************************************************/--%>
        fnSearch = function() {
            mGridDataSet.load({
            	url: '<c:url value="/prj/grs/retrieveGrsReqList.do"/>',
                params: {
                    tssNm: escape(encodeURIComponent(document.xform.tssNmSch.value)) //과제명
                    ,bizDtpCd : bizDtpCd.getValue()
                    ,grsEvSt  : grsEvStSch.getValue()
                    ,tssScnCd : tssScnCd.getValue()
                    ,grsSt    : grsSt.getValue()
                    ,wbsCd    : wbsCd.getValue()
                }
            });
        }
        
        fnSearch();

 <%--/*******************************************************************************
  * FUNCTION 명 : fnExcel
  * FUNCTION 기능설명 :excel 다운로드
  *******************************************************************************/--%>
        fnExcel = function() {
            masterGrid.saveExcel(toUTF8('GRS_심의현황_') + new Date().format('%Y%m%d') + '.xls');
        };


   }); //onReady END



</script>
</head>

<!-- <body onload="init();"> -->
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
    <div class="contents" >
        <div class="titleArea">
            <h2>과제 GRS 평가 결과 목록</h2>
        </div>
        <div class="LblockSearch">
            <form name="xform" id="xform" method="post">
                <input type=hidden name='tssCd'      id='tssCd'      />
                <input type=hidden name='tssCdSn'    id='tssCdSn'    />
                <input type=hidden name='grsEvSn'    id='grsEvSn'    />
                <input type=hidden name='tssSt'      id='tssSt'      />
                <input type=hidden name='tssStNm'    id='tssStNm'    />
                <input type=hidden name='MW_TODO_REQ_NO' id='MW_TODO_REQ_NO' />

                <table class="searchBox">
                    <colgroup>
                        <col style="width:15%;"/>
                        <col style="width:30%;"/>
                        <col style="width:15%;"/>
                        <col style="width:30%;"/>
                        <col style="width:10%;"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th align="right">과제유형</th>
                            <td>
                                <div id="bizDtpCd" name='bizDtpCd'></div>
                            </td>
                            <th align="right">심의단계</th>
                            <td>
                                <div id="grsEvStSch"></div>
                            </td>
                            <td class="t_center" rowspan="2">
                              <a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</div>
                            </td>
                        </tr>
                        <tr>
                            <th align="right">과제명</th>
                            <td>
                                <input type="text" id="tssNmSch" value="">
                            </td>
                            <th align="right">과제구분</th>
                            <td>
                                <div id="tssScnCd"></div>
                            </td>
                        </tr>
                        <tr>
                            <th align="right">WBS코드</th>
                            <td>
                            	 <input type="text" id="wbsCd" />
                            </td>
                            <th align="right">GRS상태</th>
                            <td>
                            	 <select id="grsSt"></select>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
            <div class="titArea">
                <span class="Ltotal" id="cnt_text">총 : 0 </span>
                <div class="LblockButton">
                    <button type="button" onclick="javascript:fnExcel()">Excel다운로드</button>
                </div>
            </div>

            <div id="masterGrid"></div>

        </div>
    </div>
</body>
</html>