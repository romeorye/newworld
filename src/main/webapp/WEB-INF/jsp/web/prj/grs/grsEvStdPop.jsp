<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
                 java.util.*,
                 devonframe.util.NullUtil,
                 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id      : grsEvStdPop.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.08
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

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

<script type="text/javascript">
    Rui.onReady(function() {
        //년도
        /*
        grsY = new Rui.ui.form.LCombo({
            applyTo: 'grsY',
            name: 'grsY',
            useEmptyText: true,
            emptyText: '선택',
            items: [
                <c:forEach var="grsYList" items="${grsYList}">
                { code: '${grsYList.grsY}', value: '${grsYList.grsY}' },
                </c:forEach>
            ]
        }); */

        //유형
        grsType = new Rui.ui.form.LCombo({
            applyTo: 'grsType',
            name: 'grsType',
            autoMapping: true,
            useEmptyText: true,
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=GRS_TYPE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 200
        });
        grsType.getDataSet().on('load', function(e) {
        });

        //상태
       /*  useYn = new Rui.ui.form.LCombo({
            applyTo: 'useYn',
            name: 'useYn',
            autoMapping: true,
            useEmptyText: true,
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=COMM_YN"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
        });
        useYn.getDataSet().on('load', function(e) {
        }); */


        //평가명
        evSbcNm = new Rui.ui.form.LTextBox({
            applyTo: 'evSbcNm',
            width: 200
        });


        /* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'grsY' }     //년도
                , { id: 'grsType' }  //유형
                , { id: 'evSbcNm' }  //평가명
                , { id: 'useYn' }    //상태
                , { id: 'grsEvSn' }  //평가표일련번호
                , { id: 'grsEvSeq' } //평가SEQ
            ]
        });

        /* 최초 데이터 셋팅 */
        if(${resultCnt} > 0) {
            console.log("mst searchData1");
            dataSet.loadData(${result});
        } else {
            console.log("mst searchData2");
            dataSet.newRecord();
        }


        /* [Grid] 컬럼설정 */
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                  new Rui.ui.grid.LSelectionColumn({selectionType: 'radio', syncRow: true })
                , new Rui.ui.grid.LNumberColumn()
                //, { field: 'grsY',    label: '년도', sortable: false, align:'center', width: 50 }
                , { field: 'grsType', label: '유형', sortable: false, align:'center', width: 250, editor: grsType, renderer: function(value, p, record, row, col) {
                    p.editable = false;
                    return value;
                } }
                , { field: 'evSbcNm', label: '평가명', sortable: false, align:'left', width: 410 }
                //, { field: 'useYn',   label: '상태', sortable: false, align:'center', width: 50, editor: useYn, renderer: function(value, p, record, row, col) {
                 //   p.editable = false;
                 //   return value;
                //} }
            ]
        });


        /* [Grid] 패널설정 */
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 280,
            autoToEdit: false,
            autoWidth: true,
        });
        grid.on('cellClick', function(e) {
            if(e.colId == "evSbcNm") {
                var grsEvSn = dataSet.getNameValue(e.row, "grsEvSn");
                window.parent.openGrsEvDtlDialog(grsEvSn);
            }
        });
        grid.render('defaultGrid');


        /* [버튼] 조회 */
        fnSearch = function() {
            dataSet.load({
                url: '<c:url value="/prj/grs/retrieveGrsEvStd.do"/>'
              , params : {
                    //grsY : stringNullChk(grsY.getValue())
                    grsType : stringNullChk(grsType.getValue())
                  //, useYn : stringNullChk(useYn.getValue())
                  , evSbcNm : encodeURIComponent(stringNullChk(evSbcNm.getValue()))
                }
            });
        };


        /* [버튼] 선택 */
        var btnSel = new Rui.ui.LButton('btnSel');
        btnSel.on('click', function() {
            var chkRow = dataSet.indexOfKey(dataSet.getMarkedRange().keys[0]);   //체크된 row
            var record = dataSet.getAt(chkRow);

            if(record.data.useYn == "N") {
                Rui.alert("상태가 N인건 선택할 수 없습니다.");
                return;
            }

            window.parent.setGrsEvSnInfo(record.data);
            parent.grsEvSnDialog.submit(true);
        });
    });
</script>
</script>
</head>
<body>
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="LblockMainBody">
        <div class="sub-content">
            <div id="aFormDiv">
                <form name="aForm" id="aForm" method="post">
                    <fieldset>
                        <table class="searchBox">
                            <colgroup>
                                <col style="width: 15%;" />
                                <col style="width: 25%;" />
                                <col style="width: 15%;" />
                                <col style="width: 30%;" />
                                <col style="width: 15%;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <!-- <th align="right">년도</th>
                                    <td>
                                        <div id="grsY"></div>
                                    </td> -->
                                    <th align="right">유형</th>
                                    <td>
                                        <div id="grsType"></div>
                                    </td>
                                     <th align="right">평가명</th>
                                    <td>
                                        <input type="text" id="evSbcNm" value="">
                                    </td>
                                    <td rowspan="2" class="t_center"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
                                </tr>
                                <!--
                                <tr>
                                    <th align="right">상태</th>
                                    <td>
                                        <div id="useYn"></div>
                                    </td>
                                    <th align="right">평가명</th>
                                    <td>
                                        <input type="text" id="evSbcNm" value="">
                                    </td>
                                </tr> -->
                            </tbody>
                        </table>
                    </fieldset>
                </form>
            </div>
            <br/>
            <div id="defaultGrid"></div>

            <div class="titArea">
                <div class="LblockButton">
                    <button type="button" id="btnSel" name="btnSel">선택</button>
                </div>
            </div>

        </div>
    </div>
</body>
</html>