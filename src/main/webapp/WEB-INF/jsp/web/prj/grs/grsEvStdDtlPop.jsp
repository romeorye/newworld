<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
                 java.util.*,
                 devonframe.util.NullUtil,
                 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id      : grsEvStdDtlPop.jsp
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
        grsY = new Rui.ui.form.LTextBox({
            applyTo: 'grsY',
            width: 200
        });
        
        //유형
        grsType = new Rui.ui.form.LCombo({
            applyTo: 'grsType',
            useEmptyText: true,
            emptyText: '(선택)',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=GRS_TYPE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 250
        });
        grsType.getDataSet().on('load', function(e) {
        });
        
        //상태
        useYn = new Rui.ui.form.LCombo({
            applyTo: 'useYn',
            useEmptyText: true,
            emptyText: '(선택)',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=COMM_YN"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
        });
        useYn.getDataSet().on('load', function(e) {
        });
        
        
        //평가명
        evSbcNm = new Rui.ui.form.LTextBox({
            applyTo: 'evSbcNm',
            width: 200
        });
        
        //Form 비활성화 여부
        disableFields = function() {
            grsY.setEditable(false);
            grsType.disable();
            useYn.disable();
            evSbcNm.setEditable(false);
            
            document.getElementById('grsY').style.border = 0;
            document.getElementById('grsType').style.border = 0;
            document.getElementById('useYn').style.border = 0;
            document.getElementById('evSbcNm').style.border = 0;

            Rui.select('.tssLableCss div').removeClass('L-disabled');
        }


        /* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'grsEvSn' }      //평가표일련번호
                , { id: 'grsEvSeq' }     //평가SEQ
                , { id: 'evPrvsNm1' }    //평가항목명1
                , { id: 'evPrvsNm2' }    //평가항목명2
                , { id: 'evCrtnNm' }     //평가기준명
                , { id: 'evSbcTxt' }     //평가내용
                , { id: 'dtlSbcTitl1' }  //상세내용1
                , { id: 'dtlSbcTitl2' }  //상세내용2
                , { id: 'dtlSbcTitl3' }  //상세내용3
                , { id: 'dtlSbcTitl4' }  //상세내용4
                , { id: 'dtlSbcTitl5' }  //상세내용5
                , { id: 'wgvl' }         //가중치
                , { id: 'grsY' }         //년도
                , { id: 'grsType' }      //유형
                , { id: 'evSbcNm' }      //템플릿명
                , { id: 'useYn' }        //사용여부
            ]
        });
        dataSet.on('load', function(e) {    
            disableFields();
        });
        
        dataSet.loadData(${result});
        
        /* [DataSet] 폼에 출력 */
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'grsY',    ctrlId: 'grsY',    value: 'value' }
                , { id: 'grsType', ctrlId: 'grsType', value: 'value' }
                , { id: 'evSbcNm', ctrlId: 'evSbcNm', value: 'value' }
                , { id: 'useYn',   ctrlId: 'useYn',   value: 'value' }
            ]
        });
        
        
        /* [Grid] 컬럼설정 */
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { field: 'evPrvsNm1', label: '평가항목', sortable: false, align:'left', width: 175, vMerge: true }
                , { field: 'evPrvsNm2', label: '평가항목', sortable: false, align:'left', width: 175, vMerge: true }
                , { field: 'evCrtnNm',  label: '평가기준', sortable: false, align:'left', width: 175, vMerge: true }
                , { field: 'evSbcTxt',  label: '평가내용', sortable: false, align:'left', width: 200 }
                , { id: 'G1', label: '평가 기준및 배점' },
                , { field: 'dtlSbcTitl1', groupId: 'G1', label: '5점', sortable: false, align:'left', width: 70 }
                , { field: 'dtlSbcTitl2', groupId: 'G1', label: '4점', sortable: false, align:'left', width: 70 }
                , { field: 'dtlSbcTitl3', groupId: 'G1', label: '3점', sortable: false, align:'left', width: 70 }
                , { field: 'dtlSbcTitl4', groupId: 'G1', label: '2점', sortable: false, align:'left', width: 70 }
                , { field: 'dtlSbcTitl5', groupId: 'G1', label: '1점', sortable: false, align:'left', width: 70 }
                , { field: 'wgvl', label: '가중치', sortable: false, align:'left', width: 120 }
            ]
        });
        

        /* [Grid] 패널설정 */
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 270,
            autoToEdit: false,
            autoWidth: true,
            useRightActionMenu: false
        });
        grid.render('defaultGrid');
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
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 12%;" />
                                <col style="width: 38%;" />
                                <col style="width: 12%;" />
                                <col style="width: 38%;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">년도</th>
                                    <td>
                                        <div id="grsY"></div>
                                    </td>
                                    <th align="right">유형</th>
                                    <td class="tssLableCss">
                                        <div id="grsType"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">상태</th>
                                    <td class="tssLableCss">
                                        <div id="useYn"></div>
                                    </td>
                                    <th align="right">평가명</th>
                                    <td>
                                        <input type="text" id="evSbcNm" value="">
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </fieldset>
                </form>
            </div> 
            <br/>
            <div id="defaultGrid"></div>
               
        </div>
</body>
</html>