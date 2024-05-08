<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssPgsTrwiBudgIfm.jsp
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

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFrameDialog.css" />
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.css" />

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var lvTssCd  = window.parent.gvTssCd;     //과제코드
    var lvUserId = window.parent.gvUserId;    //로그인ID
    var lvPgsCd  = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt  = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = lvPgsCd == "PG" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";


    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        fnGridNumberFormt = function(value, p, record, row, col) {
            if(stringNullChk(value) == "") value = 0;
            return Rui.util.LFormat.numberFormat(Math.round(value * 100) / 100);
        };
       

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 월별
        dataSet1 = new Rui.data.LJsonDataSet({
            id: 'dataset1',
            fields: [
                  { id:'comDtlCd1' }
                , { id:'comDtlNm1' }
                , { id:'comDtlCd2' }
                , { id:'comDtlNm2' }
                , { id:'comDtlCd3' }
                , { id:'comDtlNm3' }
                , { id:'bizExpCd' }
                , { id:'bizExpNm' }
                , { id:'bizExpSn' }
                , { id:'yyNosAthg1', type:'number', defaultValue:0 }
                , { id:'yyNosAthg2', type:'number', defaultValue:0 }
                , { id:'yyNosAthg3', type:'number', defaultValue:0 }
                , { id:'yyNosAthg4', type:'number', defaultValue:0 }
                , { id:'yyNosAthg5', type:'number', defaultValue:0 }
                , { id:'yyNosCash1', type:'number', defaultValue:0 }
                , { id:'yyNosCash2', type:'number', defaultValue:0 }
                , { id:'yyNosCash3', type:'number', defaultValue:0 }
                , { id:'yyNosCash4', type:'number', defaultValue:0 }
                , { id:'yyNosCash5', type:'number', defaultValue:0 }
                , { id:'inputType' }
            ]
        });
        dataSet1.on('load', function(e) {
            console.log("tb load DataSet Success");
        });

        dataSet2 = new Rui.data.LJsonDataSet({
            id: 'dataSet2',
            fields: [
                  { id:'comDtlCd1' }
                , { id:'comDtlNm1' }
                , { id:'comDtlCd2' }
                , { id:'comDtlNm2' }
                , { id:'comDtlCd3' }
                , { id:'comDtlNm3' }
                , { id:'bizExpCd' }
                , { id:'bizExpNm' }
                , { id:'bizExpSn' }
                , { id:'yyNosAthg1', type:'number', defaultValue:0 }
                , { id:'yyNosAthg2', type:'number', defaultValue:0 }
                , { id:'yyNosAthg3', type:'number', defaultValue:0 }
                , { id:'yyNosAthg4', type:'number', defaultValue:0 }
                , { id:'yyNosAthg5', type:'number', defaultValue:0 }
                , { id:'yyNosCash1', type:'number', defaultValue:0 }
                , { id:'yyNosCash2', type:'number', defaultValue:0 }
                , { id:'yyNosCash3', type:'number', defaultValue:0 }
                , { id:'yyNosCash4', type:'number', defaultValue:0 }
                , { id:'yyNosCash5', type:'number', defaultValue:0 }
                , { id:'inputType' }
            ]
        });
    
        var columnModel1 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { id: 'G1', label: '내역' }
                , { field: 'comDtlNm1', label: '구분1', groupId: 'G1', sortable: false, align:'center', width: 150, vMerge: true }
                , { field: 'comDtlNm2', label: '구분2', groupId: 'G1', sortable: false, align:'center', width: 200, vMerge: true, hMerge: true }
               
                , { id: 'G2', label: '1차년도' }
                , { field: 'yyNosCash1', label: '현금', groupId: 'G2', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg1', label: '현물', groupId: 'G2', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                
                , { id: 'G3', label: '2차년도' }                                                                                                           
                , { field: 'yyNosCash2', label: '현금', groupId: 'G3', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg2', label: '현물', groupId: 'G3', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                
                , { id: 'G4', label: '3차년도' }
                , { field: 'yyNosCash3', label: '현금', groupId: 'G4', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg3', label: '현물', groupId: 'G4', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                
                , { id: 'G5', label: '4차년도' }
                , { field: 'yyNosCash4', label: '현금', groupId: 'G5', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg4', label: '현물', groupId: 'G5', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                
                , { id: 'G6', label: '5차년도' }
                , { field: 'yyNosCash5', label: '현금', groupId: 'G6', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg5', label: '현물', groupId: 'G6', sortable: false, summary: { ids: [ 'comDtlNm1' ] }, align:'right', renderer: fnGridNumberFormt, width: 70 }
                
                , { id: 'G7', label: '년도별합계' }
                , { id: 'yyNosAthgSum', label: '현금', groupId: 'G7', align:'right',sortable: false, renderer : function(val, p, record, row, i){
                    p.css.push('grid-bg-color-sum');
                    return Rui.util.LNumber.toMoney(record.get('yyNosCash1') + record.get('yyNosCash2')+ record.get('yyNosCash3')+ record.get('yyNosCash4')+ record.get('yyNosCash5'));
	                },sumType: 'sum'},

                , { id: 'yyNosCashSum', label: '현물', groupId: 'G7', align:'right',sortable: false, renderer: function(val, p, record, row, i){
                    p.css.push('grid-bg-color-sum');
                    return Rui.util.LNumber.toMoney(record.get('yyNosAthg1') + record.get('yyNosAthg2')+ record.get('yyNosAthg3')+ record.get('yyNosAthg4')+ record.get('yyNosAthg5'));
	                },sumType: 'sum'},
                
                
            ]
        });

        var columnModel2 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                  , { id: 'G1', label: '하우시스 사업비 상세' }
                , { field: 'comDtlNm1', label: '구분1',  groupId: 'G1', sortable: false, align:'center', width: 100, vMerge: true }
                , { field: 'comDtlNm2', label: '구분2',  groupId: 'G1',sortable: false, align:'center', width: 100, vMerge: true, hMerge: true }                                                                                                               
                , { field: 'comDtlNm3', label: '구분3',  groupId: 'G1',sortable: false, align:'center', width: 100, hMerge: true }
             
                , { id: 'G2', label: '1차년도' }
                , { field: 'yyNosCash1', label: '현금', groupId: 'G2', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right',renderer: function(value, p, record, row, i) {
                    return Rui.util.LFormat.numberFormat(value);
                }, width: 70 }
                , { field: 'yyNosAthg1', label: '현물', groupId: 'G2', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                                                                                                                                                                            
                , { id: 'G3', label: '2차년도' }                     
                , { field: 'yyNosCash2', label: '현금', groupId: 'G3', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg2', label: '현물', groupId: 'G3', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                                                                     
                , { id: 'G4', label: '3차년도' }                     
                , { field: 'yyNosCash3', label: '현금', groupId: 'G4', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg3', label: '현물', groupId: 'G4', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                                                                     
                , { id: 'G5', label: '4차년도' }                     
                , { field: 'yyNosCash4', label: '현금', groupId: 'G5', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg4', label: '현물', groupId: 'G5', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                                                                     
                , { id: 'G6', label: '5차년도' }                     
                , { field: 'yyNosCash5', label: '현금', groupId: 'G6', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                , { field: 'yyNosAthg5', label: '현물', groupId: 'G6', sortable: false, summary: { ids: [ 'comDtlNm1' ] } , align:'right', renderer: fnGridNumberFormt, width: 70 }
                
                , { id: 'G7', label: '년도별합계' }
                , { id: 'yyNosAthgSum', label: '현금',align:'right', groupId: 'G7', sortable: false, renderer : function(val, p, record, row, i){
                    p.css.push('grid-bg-color-sum');
                    return Rui.util.LNumber.toMoney(record.get('yyNosCash1') + record.get('yyNosCash2')+ record.get('yyNosCash3')+ record.get('yyNosCash4')+ record.get('yyNosCash5'));
	                } ,sumType: 'sum'},

                , { id: 'yyNosCashSum', label: '현물',align:'right', groupId: 'G7', sortable: false, renderer: function(val, p, record, row, i){
                    p.css.push('grid-bg-color-sum');
                    return Rui.util.LNumber.toMoney(record.get('yyNosAthg1') + record.get('yyNosAthg2')+ record.get('yyNosAthg3')+ record.get('yyNosAthg4')+ record.get('yyNosAthg5'));
	                },sumType: 'sum'},
                
            ]
        });
        
        
        
        var sumColumns = ['yyNosAthg1', 'yyNosCash1', 'yyNosAthg2', 'yyNosCash2', 'yyNosAthg3', 'yyNosCash3', 'yyNosAthg4', 'yyNosCash4', 'yyNosAthg5', 'yyNosCash5'];
        
        var summary = new Rui.ui.grid.LTotalSummary();
        summary.on('renderTotalCell', summary.renderer({
            label: {
                id: 'comDtlNm3',
                text: '합계'
            },
            columns: {
                yyNosAthg1: { type: 'sum', renderer: 'money' },
                yyNosCash1: { type: 'sum', renderer: 'money' },
                yyNosAthg2: { type: 'sum', renderer: 'money' },
                yyNosCash2: { type: 'sum', renderer: 'money' },
                yyNosAthg3: { type: 'sum', renderer: 'money' },
                yyNosCash3: { type: 'sum', renderer: 'money' },
                yyNosAthg4: { type: 'sum', renderer: 'money' },
                yyNosCash4: { type: 'sum', renderer: 'money' },
                yyNosAthg5: { type: 'sum', renderer: 'money' },
                yyNosCash5: { type: 'sum', renderer: 'money' }
            }
        }));

        var grid1 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel1,
            dataSet: dataSet1,
            width: 600,
            height: 400,
            autoToEdit: true,
            multiLineEditor: true,
            useRightActionMenu: false,
            autoWidth: true
        });

        grid1.render('tbMmGrid1');

        var grid2 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel2,
            dataSet: dataSet2,
            width: 600,
            height: 800,
            autoToEdit: true,
            multiLineEditor: true,
            useRightActionMenu: false,
            autoWidth: true,
            viewConfig: {
                plugins: [ summary ]
            }
        });

        grid2.render('tbMmGrid2');
        //목록
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
         */
        
        //최초 데이터 셋팅 
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet1.loadData(${result});
            dataSet2.loadData(${result2});
        }
    });
</script>
<script>
$(window).load(function() {
    initFrameSetHeight("tbForm");
}); 
</script>
</head>
<body>
<form name="tbForm" id="tbForm" method="post">
    <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
    <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->

    <div class="titArea" style="height:20px;">
        <div class="LblockButton">
            <label>단위:천원</label>
        </div>
    </div>

    <div id="tbMmGrid1"></div>
    
    <br/>

	<div id="tbMmGrid2"></div>
<!-- 
    <div class="titArea">
        <div class="LblockButton">
            <button type="button" id="btnList" name="btnList">목록</button>
        </div>
    </div> -->
</form>
</body>
</html>