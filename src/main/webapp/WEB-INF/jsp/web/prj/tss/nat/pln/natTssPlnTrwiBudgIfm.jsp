<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPgsTrwiBudgIfm.jsp
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
    var lvTssCd     = window.parent.gvTssCd;     //과제코드
    var lvUserId    = window.parent.gvUserId;    //로그인ID
    var lvTssSt     = window.parent.gvTssSt;     //과제상태
    var lvPgsStepCd = window.parent.gvPgsStepCd;
    var lvPageMode  = window.parent.gvPageMode;

    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";


    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        var textBox = new Rui.ui.form.LTextBox({
            emptyValue: ''
        });

        var numberBox = new Rui.ui.form.LNumberBox({
            thousandsSeparator: ',',
            minValue: 0,
            maxValue: 99999999
        });

        var numberBox2 = new Rui.ui.form.LNumberBox({
            thousandsSeparator: ',',
            minValue: 0,
            maxValue: 99999999
        });

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;

            btnSave.hide();

            grid1.setEditable(false);
        };

        /*============================================================================
        =================================    dataSet1     =============================
        ============================================================================*/
        //dataSet1 월별
        dataSet1 = new Rui.data.LJsonDataSet({
            id: 'dataSet1',
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
            console.log("tb load dataSet1 Success");
        });
        dataSet1.load({
            url: '<c:url value="/prj/tss/nat/retrieveNatTssPlnTrwiBudg.do"/>',
            params :{
                tssCd :lvTssCd
                ,gridFlg : 1
            }
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
        dataSet2.load({
            url: '<c:url value="/prj/tss/nat/retrieveNatTssPlnTrwiBudg.do"/>',
            params :{
                tssCd :lvTssCd
                ,gridFlg : 2
            }
        });

        var col1EditableRenderer = function(value, p, record, row, i) {
            if(record.get("comDtlCd1") == "c") {
                if(row == 4) {
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosAthg1'), dataSet1.getAt(0).get("yyNosAthg1") - dataSet1.getAt(2).get("yyNosAthg1"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosAthg2'), dataSet1.getAt(0).get("yyNosAthg2") - dataSet1.getAt(2).get("yyNosAthg2"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosAthg3'), dataSet1.getAt(0).get("yyNosAthg3") - dataSet1.getAt(2).get("yyNosAthg3"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosAthg4'), dataSet1.getAt(0).get("yyNosAthg4") - dataSet1.getAt(2).get("yyNosAthg4"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosAthg5'), dataSet1.getAt(0).get("yyNosAthg5") - dataSet1.getAt(2).get("yyNosAthg5"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosCash1'), dataSet1.getAt(0).get("yyNosCash1") - dataSet1.getAt(2).get("yyNosCash1"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosCash2'), dataSet1.getAt(0).get("yyNosCash2") - dataSet1.getAt(2).get("yyNosCash2"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosCash3'), dataSet1.getAt(0).get("yyNosCash3") - dataSet1.getAt(2).get("yyNosCash3"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosCash4'), dataSet1.getAt(0).get("yyNosCash4") - dataSet1.getAt(2).get("yyNosCash4"));
                    dataSet1.setValue(4, dataSet1.getFieldIndex('yyNosCash5'), dataSet1.getAt(0).get("yyNosCash5") - dataSet1.getAt(2).get("yyNosCash5"));
                }
                if(row == 5) {
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosAthg1'), dataSet1.getAt(1).get("yyNosAthg1") - dataSet1.getAt(3).get("yyNosAthg1"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosAthg2'), dataSet1.getAt(1).get("yyNosAthg2") - dataSet1.getAt(3).get("yyNosAthg2"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosAthg3'), dataSet1.getAt(1).get("yyNosAthg3") - dataSet1.getAt(3).get("yyNosAthg3"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosAthg4'), dataSet1.getAt(1).get("yyNosAthg4") - dataSet1.getAt(3).get("yyNosAthg4"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosAthg5'), dataSet1.getAt(1).get("yyNosAthg5") - dataSet1.getAt(3).get("yyNosAthg5"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosCash1'), dataSet1.getAt(1).get("yyNosCash1") - dataSet1.getAt(3).get("yyNosCash1"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosCash2'), dataSet1.getAt(1).get("yyNosCash2") - dataSet1.getAt(3).get("yyNosCash2"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosCash3'), dataSet1.getAt(1).get("yyNosCash3") - dataSet1.getAt(3).get("yyNosCash3"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosCash4'), dataSet1.getAt(1).get("yyNosCash4") - dataSet1.getAt(3).get("yyNosCash4"));
                    dataSet1.setValue(5, dataSet1.getFieldIndex('yyNosCash5'), dataSet1.getAt(1).get("yyNosCash5") - dataSet1.getAt(3).get("yyNosCash5"));
                }

                p.editable = false;
            }
            return Rui.util.LFormat.numberFormat(value);
            //return value;
        }

        var columnModel1 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { id: 'G1', label: '내역' }
                , { field: 'comDtlNm1', label: '구분1', groupId: 'G1', sortable: false, align:'center', width: 100, vMerge: true }
                , { field: 'comDtlNm2', label: '구분2', groupId: 'G1', sortable: false, align:'center', width: 100, vMerge: true, hMerge: true }

                , { id: 'G2', label: '1차년도' }
                , { field: 'yyNosCash1', label: '현금', groupId: 'G2', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}
                , { field: 'yyNosAthg1', label: '현물', groupId: 'G2', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}

                , { id: 'G3', label: '2차년도' }
                , { field: 'yyNosCash2', label: '현금', groupId: 'G3', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}
                , { field: 'yyNosAthg2', label: '현물', groupId: 'G3', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}

                , { id: 'G4', label: '3차년도' }
                , { field: 'yyNosCash3', label: '현금', groupId: 'G4', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}
                , { field: 'yyNosAthg3', label: '현물', groupId: 'G4', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}

                , { id: 'G5', label: '4차년도' }
                , { field: 'yyNosCash4', label: '현금', groupId: 'G5', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}
                , { field: 'yyNosAthg4', label: '현물', groupId: 'G5', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}

                , { id: 'G6', label: '5차년도' }
                , { field: 'yyNosCash5', label: '현금', groupId: 'G6', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}
                , { field: 'yyNosAthg5', label: '현물', groupId: 'G6', sortable: false, renderer: col1EditableRenderer,  summary: { ids: [ 'comDtlNm1' ] } , align:'right', width: 70 ,editor: numberBox, editable: true}

                , { id: 'G7', label: '년도별합계' }
                , { id: 'yyNosCashSum', label: '현금', groupId: 'G7',align:'right', sortable: false, renderer : function(val, p, record, row, i){
                    p.css.push('grid-bg-color-sum');
                    return Rui.util.LNumber.toMoney(record.get('yyNosCash1') + record.get('yyNosCash2')+ record.get('yyNosCash3')+ record.get('yyNosCash4')+ record.get('yyNosCash5'));
                    },sumType: 'sum'},

                , { id: 'yyNosAthgSum', label: '현물', groupId: 'G7',align:'right', sortable: false, renderer: function(val, p, record, row, i){
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
                , { field: 'comDtlNm2', label: '구분2',  groupId: 'G1', sortable: false, align:'center', width: 100, vMerge: true, hMerge: true , editor : textBox
                    , renderer: function(value, p, record) {
                        p.editable = false;
                                return value;
                	
                }}
                , { field: 'comDtlNm3', label: '구분3',  groupId: 'G1', sortable: false, align:'center', width: 100,  hMerge: true, editor : textBox
                    , renderer: function(value, p, record) {
                            p.editable = false;
                                    return value;
                }}

                , { id: 'G2', label: '1차년도' }
                , { field: 'yyNosCash1', label: '현금', groupId: 'G2', renderer: 'number', sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}
                , { field: 'yyNosAthg1', label: '현물', groupId: 'G2', renderer: 'number', sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}

                , { id: 'G3', label: '2차년도' }
                , { field: 'yyNosCash2', label: '현금', groupId: 'G3', renderer: 'number',sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}
                , { field: 'yyNosAthg2', label: '현물', groupId: 'G3', renderer: 'number',sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}

                , { id: 'G4', label: '3차년도' }
                , { field: 'yyNosCash3', label: '현금', groupId: 'G4', renderer: 'number',sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}
                , { field: 'yyNosAthg3', label: '현물', groupId: 'G4', renderer: 'number',sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}

                , { id: 'G5', label: '4차년도' }
                , { field: 'yyNosCash4', label: '현금', groupId: 'G5', renderer: 'number',sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}
                , { field: 'yyNosAthg4', label: '현물', groupId: 'G5', renderer: 'number',sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}

                , { id: 'G6', label: '5차년도' }
                , { field: 'yyNosCash5', label: '현금', groupId: 'G6', renderer: 'number',sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}
                , { field: 'yyNosAthg5', label: '현물', groupId: 'G6', renderer: 'number',sortable: false, summary: { ids: [ 'comDtlNm1']  } , align:'right', width: 70 ,editor: numberBox2, editable: true}

                , { id: 'G7', label: '년도별합계' }
                , { id: 'yyNosCashSum', label: '현금', groupId: 'G7' , align:'right',sortable: false, renderer : function(val, p, record, row, i){
                    p.css.push('grid-bg-color-sum');
                    return Rui.util.LNumber.toMoney(record.get('yyNosCash1') + record.get('yyNosCash2')+ record.get('yyNosCash3')+ record.get('yyNosCash4')+ record.get('yyNosCash5'));
                    } ,sumType: 'sum'},

                , { id: 'yyNosAthgSum', label: '현물', groupId: 'G7',align:'right', sortable: false, renderer: function(val, p, record, row, i){
                    p.css.push('grid-bg-color-sum');
                    return Rui.util.LNumber.toMoney(record.get('yyNosAthg1') + record.get('yyNosAthg2')+ record.get('yyNosAthg3')+ record.get('yyNosAthg4')+ record.get('yyNosAthg5'));
                    },sumType: 'sum'}
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
        grid2.on('cellClick', function(e) {
            
            if(pageMode == "R") return;
            
            if(e.colId == "comDtlNm3") {
                var inputType = dataSet2.getNameValue(e.row, "inputType");
                if(inputType == 'Y') {
                    e.target.columnModel.setCellConfig(e.row, e.col, 'editable', true);
                } else {
                    e.target.columnModel.setCellConfig(e.row, e.col, 'editable', false);
                }
            
            }else if(e.colId == "comDtlNm2") {
            	var comDtlCd1 = dataSet2.getNameValue(e.row, "comDtlCd1");
            	if(comDtlCd1=='h'){
            		 e.target.columnModel.setCellConfig(e.row, e.col, 'editable', true);
            	}else{
            		 e.target.columnModel.setCellConfig(e.row, e.col, 'editable', false);
            	}
            	
            }else if(e.colId == "yyNosAthg1") {
                e.target.columnModel.setCellConfig(e.row, e.col, 'editable', true);
            }
        });
        grid2.render('tbMmGrid2');


        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet1.getReadData(e);

            Rui.alert(data.records[0].rtVal);

            if(data.records[0].rtCd == "SUCCESS") {
                fn_search();
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet1.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });


        <%--/*******************************************************************************
         * FUNCTION 명 : btnSave
         * FUNCTION 기능설명 :저장
         *******************************************************************************/--%>
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            if(!(dataSet1.isUpdated() || dataSet2.isUpdated())) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }


            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/nat/updateNatTssPlnTrwiBudg.do"/>',
                        dataSets:[dataSet1 ,dataSet2],
                        params : {
                            tssCd: lvTssCd
                        }
                    });
                },
                handlerNo: Rui.emptyFn
            });
        });


        <%--/*******************************************************************************
         * FUNCTION 명 : fn_search
         * FUNCTION 기능설명 :조회
         *******************************************************************************/--%>
        fn_search = function() {
            dataSet1.load({
                url: "<c:url value='/prj/tss/nat/retrieveNatTssPlnTrwiBudg.do'/>"
              , params : {
                     tssCd: lvTssCd
                     ,gridFlg : 1
                }
            });
            dataSet2.load({
                url: "<c:url value='/prj/tss/nat/retrieveNatTssPlnTrwiBudg.do'/>"
              , params : {
                     tssCd: lvTssCd
                     ,gridFlg : 2
                }
            });
        };


        <%--/*******************************************************************************
         * FUNCTION 명 : btnList
         * FUNCTION 기능설명 :목록
         *******************************************************************************/--%>
       /*  var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
 */

        if(!window.parent.isEditable) {
            //버튼 비활성화 셋팅
            disableFields();
        }
 
	 	if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
			$("#btnSave").hide();
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
			$("#btnSave").hide();
		}
    });
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("tbForm");
});
</script>
</head>
<body>
<form name="tbForm" id="tbForm" method="post">
    <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
    <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->

    <div class="titArea">
        <div class="LblockButton">


            <label>단위:천원</label>
        </div>
    </div>

    <div id="tbMmGrid1"></div>

    <div id="tbMmGrid2"></div>

    <div class="titArea mt10">
        <div class="LblockButton">
            <button type="button" id="btnSave" name="btnSave">저장</button>
            <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
        </div>
    </div>
</form>
</body>
</html>