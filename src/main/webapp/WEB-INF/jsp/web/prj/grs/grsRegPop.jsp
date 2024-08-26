<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id      : grsRegPop.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2020.03.04
 * 2.0  2024.05.16  siseo      투입인원, 투입비용: 3차년도 부터는 0 입력 허용되도록 수정.
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">

var lvAttcFilId;
var grsEvSnDialog;
var userIds;
var strDt;
var endDt;
var chkVaild;
var tmpAttchFileList;
var roleCheck = '${inputData.roleCheck}';
var exSabun = '${inputData._userSabun}';

    Rui.onReady(function() {
        <%-- RESULT DATASET --%>
        resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });

        /* 평가표 */
        grsEvSnNm = new Rui.ui.form.LPopupTextBox({
            applyTo : 'grsEvSnNm',
            width : 300,
            editable : false,
            placeholder : '',
            emptyValue : '',
            enterToPopup : true
        });
        grsEvSnNm.on('popup', function(e) {
            openGrsEvSnDialog();
        });

        openGrsEvSnDialog = function() {
            grsEvSnDialog.setUrl('/iris/prj/grs/grsEvStdPop.do?tssCd=' + dataSet.getNameValue(0, "tssCd") + '&userId=' + dataSet.getNameValue(0, "saSabunNew"));
            grsEvSnDialog.show();
        };

        // 팝업: 평가표
        grsEvSnDialog = new Rui.ui.LFrameDialog({
            id : 'grsEvSnDialog',
            title : 'GRS 평가항목선택',
            width : 700,
            height : 500,
            modal : true,
            visible : false
        });

        grsEvSnDialog.render(document.body);

        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            focusFirstRow: 0,
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                     { id: 'prjNm'}
                    ,{ id: 'bizDptNm'}
                    ,{ id: 'tssNm'}
                    ,{ id: 'grsEvSt'}
                    ,{ id: 'tssAttrNm'}
                    ,{ id: 'tssDd'}
                    ,{ id: 'dlbrCrgrNm'}
                    ,{ id: 'evTitl'}
                    ,{ id: 'cfrnAtdtCdTxtNm'}
                    ,{ id: 'commTxt'}
                    ,{ id: 'grsEvSn'}
                    ,{ id: 'ctyOtPlnM'}
                    ,{ id: 'ancpOtPlnDt'}
                    ,{ id: 'nprodNm'}
                    ,{ id: 'nprodSalsPlnY'}
                    ,{ id: 'nprodSalsPlnY1'}
                    ,{ id: 'nprodSalsPlnY2'}
                    ,{ id: 'nprodSalsPlnY3'}
                    ,{ id: 'nprodSalsPlnY4'}
                    ,{ id: 'nprodSalsCurY'}
                    ,{ id: 'nprodSalsCurY1'}
                    ,{ id: 'nprodSalsCurY2'}
                    ,{ id: 'bizPrftProY'}
                    ,{ id: 'bizPrftProY1'}
                    ,{ id: 'bizPrftProY2'}
                    ,{ id: 'bizPrftProY3'}
                    ,{ id: 'bizPrftProY4'}
                    ,{ id: 'bizPrftProCurY'}
                    ,{ id: 'bizPrftProCurY1'}
                    ,{ id: 'bizPrftProCurY2'}
                    ,{ id: 'bizPrftPlnY'}
                    ,{ id: 'bizPrftPlnY1'}
                    ,{ id: 'bizPrftPlnY2'}
                    ,{ id: 'bizPrftCurY'}
                    ,{ id: 'bizPrftCurY1'}
                    ,{ id: 'bizPrftCurY2'}
                    ,{ id: 'ptcCpsnY'}
                    ,{ id: 'ptcCpsnY1'}
                    ,{ id: 'ptcCpsnY2'}
                    ,{ id: 'ptcCpsnY3'}
                    ,{ id: 'ptcCpsnY4'}
                    ,{ id: 'ptcCpsnCurY'}
                    ,{ id: 'ptcCpsnCurY1'}
                    ,{ id: 'ptcCpsnCurY2'}
                    ,{ id: 'ptcCpsnCurY3'}
                    ,{ id: 'ptcCpsnCurY4'}
                    ,{ id: 'expArslY'}
                    ,{ id: 'expArslY1'}
                    ,{ id: 'expArslY2'}
                    ,{ id: 'expArslY3'}
                    ,{ id: 'expArslY4'}
                    ,{ id: 'expArslCurY'}
                    ,{ id: 'expArslCurY1'}
                    ,{ id: 'expArslCurY2'}
                    ,{ id: 'expArslCurY3'}
                    ,{ id: 'expArslCurY4'}
                    ,{ id: 'tssScnCd'}
                    ,{ id: 'prjCd'}
                    ,{ id: 'bizDptCd'}
                    ,{ id: 'tssAttrCd'}
                    ,{ id: 'tssStrtDd'}
                    ,{ id: 'tssFnhDd'}
                    ,{ id: 'cfrnAtdtCdTxt'}
                    ,{ id: 'attcFilId'}
                    ,{ id: 'tssCd'}
                    ,{ id: 'wbsCd'}
                    ,{ id: 'grsStCd'}
                    ,{ id: 'tssCdSn'}
                    ,{ id: 'pgsStepCd'}
                    ,{ id: 'deptCode'}
                    ,{ id: 'saSabunNew'}
                    ,{ id: 'userId'}
                    ,{ id: 'evSbcNm'}
                    ,{ id: 'dropYn'}
                    ,{ id: 'evResult'}
                    ,{ id: 'grsEvMType'}
                    ,{ id: 'grsEvMTypeNm'}
                    ,{ id: 'evDt'}
                    ,{ id: 'tssTypeNm'}
                    ,{ id: 'grsEvStNm'}
                 ]
        });


        dataSet.on('load', function(e){
            if (roleCheck == "Y" ){
                $("#butImSave").show();
                $("#btnGrsSave").show();
            }else{
                if( dataSet.getNameValue(0, 'bizDptCd') == "07" &&  ( exSabun == "00207887" ||  exSabun == "00207772")){
                    $("#butImSave").show();
                    $("#btnGrsSave").show();
                }else{
                    $("#butImSave").hide();
                    $("#btnGrsSave").hide();
                }
            }

            //일반과제일 경우
            if( dataSet.getNameValue(0, 'tssScnCd') == "G"){
                $("#grsDev").show();

                if ( dataSet.getNameValue(0, 'grsEvSt') == "G1" ){
                    $("#trCtyOtPlnM").show();
                }else{
                    $("#trAncpOtPlnDt").show();
                }

                strDt = dataSet.getNameValue(0, 'tssStrtDd');
                endDt = dataSet.getNameValue(0, 'tssFnhDd');

                fncPtcCpsnYDisable();

                //중간 평가
                if( dataSet.getNameValue(0, 'grsEvSt') == "M" &&  grsEvMType.getValue() == "IN"  ){
                    $("table#grsDev").each(function() {
                        ctyOtPlnM.disable();
                        ancpOtPlnDt.disable();
                        $("table#grsDev input").attr("disabled", "true");
                    });
                }

            }else{
                if ( dataSet.getNameValue(0, 'tssScnCd') == "D" ){
                    if ( dataSet.getNameValue(0, 'bizDptCd') == "05" && dataSet.getNameValue(0, 'custSqlt') == "05"    ){
                        $("#grsDev").hide();
                    }else{
                        strDt = dataSet.getNameValue(0, 'tssStrtDd');
                        endDt = dataSet.getNameValue(0, 'tssFnhDd');

                        fncPtcCpsnYDisable();

                        $("#grsDev").show();
                    }
                }else{
                    $("#grsDev").hide();
                }
            }

            //평가요청일 경우
            if ( dataSet.getNameValue(0, 'grsStCd') == '101'){
                $("#trEv").show();
            }else{
                $("#trEv").hide();
                $("#trEvResult").show();
            }

            if( dataSet.getNameValue(0, 'grsEvSt') == "M" ){
                $("#trGrsEvMType").show();            //중간평가
            }

            lvAttcFilId = dataSet.getNameValue(0, 'attcFilId');
            dataSet.setNameValue(0, 'userId', '${inputData._userId}');
            getAttachFileList();

        });

        gridDataSet = new Rui.data.LJsonDataSet({ //listGrid dataSet
            id: 'gridDataSet',
            lazyLoad: true,
            fields: [
                     { id: 'grsEvSn'}                               //GRS 일련번호
                    ,{ id: 'grsEvSeq'}                              //평가STEP1
                    ,{ id: 'evPrvsNm_1'}                            //평가항목명1
                    ,{ id: 'evPrvsNm_2'}                            //평가항목명2
                    ,{ id: 'evCrtnNm'}                              //평가기준명
                    ,{ id: 'evSbcTxt'}                              //평가내용
                    ,{ id: 'dtlSbcTitl_1'}                            //상세내용1
                    ,{ id: 'dtlSbcTitl_2'}                              //상세내용2
                    ,{ id: 'dtlSbcTitl_3'}                             //상세내용3
                    ,{ id: 'dtlSbcTitl_4'}                              //상세내용4
                    ,{ id: 'dtlSbcTitl_5'}                              //상세내용5
                    ,{ id: 'evScr'}              //평가점수 , defaultValue: 0
                    ,{ id: 'wgvl'}              //가중치
                    ,{ id: 'calScr'}                                  //환산점수
                    ,{ id: 'grsY'}                                      //년도
                    ,{ id: 'grsType'}                               //유형
                    ,{ id: 'evSbcNm'}                               //템플릿명
                    ,{ id: 'useYn'}                                //
                    ]
        });

        gridDataSet.on('load', function(e) {
            //환산점수 - 화면 로드 시
            for (var i = 0; i < gridDataSet.getCount(); i++) {
                var evScr = gridDataSet.getNameValue(i, "evScr");
                var wgvl = gridDataSet.getNameValue(i, "wgvl");
                var val = evScr / 5 * wgvl;
                var cal = Rui.util.LNumber.round(val, 1);

                if (evScr == null || evScr == "") {
                    gridDataSet.setNameValue(i, "calScr", "");
                    continue;
                }
                if (!isNaN(cal)) {
                    gridDataSet.setNameValue(i, "calScr", cal);
                    continue;
                }
            }
        });

        gridDataSet.on('update', function(e) {
            if (e.colId == "evScr") {
                if (e.value > 5) {
                    Rui.alert("평가점수는 5점이상을 입력할수 없습니다.");
                    gridDataSet.setNameValue(e.row, e.colId, "");
                    return;
                }
                if (e.value == '') {
                    gridDataSet.setNameValue(e.row, e.colId, "");
                    gridDataSet.setNameValue(e.row, "calScr", "");
                    return;
                }

                //환산점수 - 평가점수 입력 시
                for (var i = 0; i < gridDataSet.getCount(); i++) {
                    var evScr = gridDataSet.getNameValue(i, "evScr");
                    var wgvl = gridDataSet.getNameValue(i, "wgvl");
                    var val = evScr / 5 * wgvl;
                    var cal = Rui.util.LNumber.round(val, 1);

                    if (evScr == null || evScr == "") {
                        gridDataSet.setNameValue(i, "calScr", "");
                        continue;
                    }
                    if (!isNaN(cal)) {
                        gridDataSet.setNameValue(i, "calScr", cal);
                        continue;
                    }
                }
            }
        });

        var numberBox = new Rui.ui.form.LNumberBox({
            emptyValue : '',
            minValue : 0,
            maxValue : 99999
        });


        mGridColumnModel = new Rui.ui.grid.LColumnModel({ //listGrid column
            columns : [ {field : 'evPrvsNm_1',    label : '평가항목',    sortable : false,    align : 'center',    width : 120,    editable : false,    vMerge : true    }
                      , {field : 'evPrvsNm_2',    label : '평가항목',    sortable : false,    align : 'center',    width : 100,    editable : false,    vMerge : true    }
                      , {field : 'evCrtnNm',    label : '평가기준',    sortable : false,    align : 'center',    width : 130,    editable : false,    vMerge : true    }
                      , {field : 'evSbcTxt',    label : '평가내용',    sortable : false,    align : 'left',        width : 220,    editable : false}
                      , {id : 'G1',    label : '평가 기준및 배점'}
                      , {field : 'dtlSbcTitl_1',    groupId : 'G1',    label : '5점',    sortable : false,    align : 'left',        width : 82,        editable : false}
                      , {field : 'dtlSbcTitl_2',    groupId : 'G1',    label : '4점',    sortable : false,    align : 'left',        width : 82,        editable : false}
                      , {field : 'dtlSbcTitl_3',    groupId : 'G1',    label : '3점',    sortable : false,    align : 'left',        width : 82,        editable : false}
                      , {field : 'dtlSbcTitl_4',    groupId : 'G1',    label : '2점',    sortable : false,    align : 'left',        width : 82,        editable : false}
                      , {field : 'dtlSbcTitl_5',    groupId : 'G1',    label : '1점',    sortable : false,    align : 'left',        width : 82,        editable : false}
                      , {field : 'evScr',    label : '평가점수',    sortable : false,    align : 'center',    width : 60,    editor : numberBox,        editable : true}
                      , {field : 'wgvl',    label : '가중치',        sortable : false,    align : 'center',    width : 45,    editable : false}
                      , {field : 'calScr',    label : '환산점수',    sortable : false,    align : 'center',    width : 55,    editable : false}
                      ]
        });

        /* 합계 */
        var sumColumns = [ 'evScr', 'wgvl', 'calScr' ];
        summary = new Rui.ui.grid.LTotalSummary();
        summary.on('renderTotalCell', summary.renderer({
            label : {
                id : 'evPrvsNm_1',
                text : '합 계'
            },
            columns : {
                //evScr: { type: 'avg', renderer: function(val) { return Rui.util.LNumber.round(val, 2); } }
                //evScr: { type: 'sum', renderer: 'number' }  //평가점수 합계 삭제 요청 : 20171219
                wgvl : {
                    type : 'sum',
                    renderer : 'number'
                },
                calScr : {
                    type : 'sum',
                    renderer : function(val) {
                        return Rui.util.LNumber.round(val, 1);
                    }
                }
            }
        }));

        evTableGrid = new Rui.ui.grid.LGridPanel({ //listGrid
            columnModel : mGridColumnModel,
            dataSet : gridDataSet,
            height : 280,
            width : 600,
            autoToEdit : true,
            clickToEdit : true,
            enterToEdit : true,
            autoWidth : true,
            autoHeight : true,
            multiLineEditor : true,
            useRightActionMenu : false,
            viewConfig : {
                plugins : [ summary ]
            }
        });

        evTableGrid.render('evTableGrid'); //listGrid render


        //회의일자
        var evDt = new Rui.ui.form.LDateBox({
            applyTo: 'evDt',
            mask: '9999-99-99',
            width: 150,
            listPosition : 'down',
            dateType: 'string'
        });

        var commTxt = new Rui.ui.form.LTextArea({
            applyTo: 'commTxt',
            placeholder: 'Comment를 입력해주세요.',
            width: 600,
            height: 122
        });

        var grsEvMType = new Rui.ui.form.LCombo({
            applyTo : 'grsEvMType',
            emptyText : '선택하세요',
            width : 120,
            items : [ {
                text : '변경',
                value : 'AL'
            }, {
                text : '진척도 점검',
                value : 'IN'
            }, {
                text : '보류',
                value : 'HD'
            }, ]
        });

        grsEvMType.on('changed', function(e) {
            if( grsEvMType.getValue() =="IN" ||  grsEvMType.getValue() =="HD" ){
                $("table#grsDev").each(function() {
                    ctyOtPlnM.disable();
                    ancpOtPlnDt.disable();
                    $("table#grsDev input").attr("disabled", true);
                });
            }else if ( grsEvMType.getValue() =="AL" ){
                $("table#grsDev").each(function() {
                     $("table#grsDev input").removeAttr("disabled");
                    ctyOtPlnM.enable();
                    ancpOtPlnDt.enable();
                    if( dataSet.getNameValue(0, 'tssScnCd') == "G"  ){
                        fncPtcCpsnYDisable();
                    }
                });
            }else{
                $("table#grsDev").each(function() {
                    ctyOtPlnM.disable();
                    ancpOtPlnDt.disable();
                     $("table#grsDev input").attr("disabled", true);
                });
            }
            dataSet.setNameValue(0, 'grsEvMType', grsEvMType.getValue());
        });

        var evTitl = new Rui.ui.form.LTextBox({
            applyTo: 'evTitl',
            width: 200,
            dateType: 'string'
        });

        var ctyOtPlnM = new Rui.ui.form.LDateBox({
            applyTo: 'ctyOtPlnM',
            width: 250,
            dateType: 'string'
        });

        var ancpOtPlnDt = new Rui.ui.form.LDateBox({
            applyTo: 'ancpOtPlnDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            width: 250,
            dateType: 'string'
        });

        nprodSalsPlnY = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        nprodSalsPlnY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY1',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        nprodSalsPlnY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY2',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        bizPrftProY = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        bizPrftProY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY1',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        bizPrftProY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY2',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        bizPrftPlnY = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftPlnY',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        bizPrftPlnY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftPlnY1',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        bizPrftPlnY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftPlnY2',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        ptcCpsnY = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY',
            decimalPrecision: 1,
            maxValue: 9999,
            width: 110
        });

        ptcCpsnY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY1',
            decimalPrecision: 1,
            maxValue: 9999,
            width: 110
        });

        ptcCpsnY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY2',
            decimalPrecision: 1,
            maxValue: 9999,
            width: 110
        });

        ptcCpsnY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY3',
            decimalPrecision: 1,
            maxValue: 9999,
            width: 110
        });

        ptcCpsnY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY4',
            decimalPrecision: 1,
            maxValue: 9999,
            width: 110
        });

        expArslY = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslY',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        expArslY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslY1',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        expArslY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslY2',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        expArslY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslY3',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        expArslY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslY4',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 110
        });

        var cfrnAtdtCdTxtNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'cfrnAtdtCdTxtNm',
            width: 600,
            editable: false,
            placeholder: '회의참석자를 입력해주세요.',
            emptyValue: '',
            enterToPopup: true
        });

        cfrnAtdtCdTxtNm.on('popup', function(e){
               openUserSearchDialog(setUsersInfo, 10, userIds, null, 700, 500);
        });

        setUsersInfo = function(userList) {
            var idList = [];
            var nameList = [];
            var saSabunList = [];

            for(var i=0, size=userList.length; i<size; i++) {
                idList.push(userList[i].saUser);
                nameList.push(userList[i].saName);
                saSabunList.push(userList[i].saSabun);
            }
            cfrnAtdtCdTxtNm.setValue(nameList.join(', '));
            dataSet.setNameValue(0, 'cfrnAtdtCdTxt', saSabunList);
               userIds = idList;
        };

        fnSearch = function() {
            var dm = new Rui.data.LDataSetManager();

            dm.loadDataSet({
                dataSets: [dataSet, gridDataSet],
                url: '<c:url value="/prj/grs/retrievveGrsInfo.do"/>',
                params : {
                    tssCd : '${inputData.tssCd}'                        //과제코드
                   ,tssCdSn :'${inputData.tssCdSn}'
                   ,grsEvSn :'${inputData.grsEvSn}'
                   ,grsEvSt :'${inputData.grsEvSt}'
                   ,grsStCd :'${inputData.grsStCd}'
                   ,roleCheck :'${inputData.roleCheck}'
                }
            });
        };

        fnSearch();

        bind = new Rui.data.LBind({
            groupId: 'aform',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                 { id: 'prjNm'             , ctrlId : 'prjNm'            ,value : 'html' }
                ,{ id: 'bizDptNm'          , ctrlId : 'bizDptNm'         ,value : 'html' }
                ,{ id: 'tssNm'             , ctrlId : 'tssNm'            ,value : 'html' }
                ,{ id: 'grsEvSt'           , ctrlId : 'grsEvSt'          ,value : 'html' }
                ,{ id: 'tssTypeNm'         , ctrlId : 'tssTypeNm'        ,value : 'html' }
                ,{ id: 'tssDd'             , ctrlId : 'tssDd'            ,value : 'html' }
                ,{ id: 'dlbrCrgrNm'        , ctrlId : 'dlbrCrgrNm'       ,value : 'html' }
                ,{ id: 'commTxt'           , ctrlId : 'commTxt'          ,value : 'value' }
                ,{ id: 'evTitl'            , ctrlId : 'evTitl'           ,value : 'value' }
                ,{ id: 'grsEvMType'        , ctrlId : 'grsEvMType'       ,value : 'value' }
                ,{ id: 'evDt'              , ctrlId : 'evDt'             ,value : 'value' }
                ,{ id: 'cfrnAtdtCdTxtNm'   , ctrlId : 'cfrnAtdtCdTxtNm'  ,value : 'value' }
                ,{ id: 'grsEvSn'           , ctrlId : 'grsEvSn'          ,value : 'value' }
                ,{ id: 'nprodNm'           , ctrlId : 'nprodNm'          ,value : 'value' }
                ,{ id: 'ctyOtPlnM'         , ctrlId : 'ctyOtPlnM'        ,value : 'value' }
                ,{ id: 'ancpOtPlnDt'       , ctrlId : 'ancpOtPlnDt'      ,value : 'value' }
                ,{ id: 'nprodSalsPlnY'     , ctrlId : 'nprodSalsPlnY'    ,value : 'value' }
                ,{ id: 'nprodSalsPlnY1'    , ctrlId : 'nprodSalsPlnY1'   ,value : 'value' }
                ,{ id: 'nprodSalsPlnY2'    , ctrlId : 'nprodSalsPlnY2'   ,value : 'value' }
                ,{ id: 'nprodSalsPlnY3'    , ctrlId : 'nprodSalsPlnY3'   ,value : 'html' }
                ,{ id: 'nprodSalsPlnY4'    , ctrlId : 'nprodSalsPlnY4'   ,value : 'html' }
                ,{ id: 'nprodSalsCurY'     , ctrlId : 'nprodSalsCurY'    ,value : 'value' }
                ,{ id: 'nprodSalsCurY1'    , ctrlId : 'nprodSalsCurY1'   ,value : 'value' }
                ,{ id: 'nprodSalsCurY2'    , ctrlId : 'nprodSalsCurY2'   ,value : 'value' }
                ,{ id: 'bizPrftPlnY'       , ctrlId : 'bizPrftPlnY'      ,value : 'value' }
                ,{ id: 'bizPrftPlnY1'      , ctrlId : 'bizPrftPlnY1'     ,value : 'value' }
                ,{ id: 'bizPrftPlnY2'      , ctrlId : 'bizPrftPlnY2'     ,value : 'value' }
                ,{ id: 'bizPrftCurY'       , ctrlId : 'bizPrftCurY'      ,value : 'value' }
                ,{ id: 'bizPrftCurY1'      , ctrlId : 'bizPrftCurY1'     ,value : 'value' }
                ,{ id: 'bizPrftCurY2'      , ctrlId : 'bizPrftCurY2'     ,value : 'value' }
                ,{ id: 'bizPrftProY'       , ctrlId : 'bizPrftProY'      ,value : 'value' }
                ,{ id: 'bizPrftProY1'      , ctrlId : 'bizPrftProY1'     ,value : 'value' }
                ,{ id: 'bizPrftProY2'      , ctrlId : 'bizPrftProY2'     ,value : 'value' }
                ,{ id: 'bizPrftProY3'      , ctrlId : 'bizPrftProY3'     ,value : 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY4'      , ctrlId : 'bizPrftProY4'     ,value : 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProCurY'    , ctrlId : 'bizPrftProCurY'   ,value : 'value' }
                ,{ id: 'bizPrftProCurY1'   , ctrlId : 'bizPrftProCurY1'  ,value : 'value' }
                ,{ id: 'bizPrftProCurY2'   , ctrlId : 'bizPrftProCurY2'  ,value : 'value' }
                ,{ id: 'ptcCpsnY'          , ctrlId : 'ptcCpsnY'         ,value : 'value' }
                ,{ id: 'ptcCpsnY1'         , ctrlId : 'ptcCpsnY1'        ,value : 'value' }
                ,{ id: 'ptcCpsnY2'         , ctrlId : 'ptcCpsnY2'        ,value : 'value' }
                ,{ id: 'ptcCpsnY3'         , ctrlId : 'ptcCpsnY3'        ,value : 'value' }
                ,{ id: 'ptcCpsnY4'         , ctrlId : 'ptcCpsnY4'        ,value : 'value' }
                ,{ id: 'ptcCpsnCurY'       , ctrlId : 'ptcCpsnCurY'      ,value : 'value' }
                ,{ id: 'ptcCpsnCurY1'      , ctrlId : 'ptcCpsnCurY1'     ,value : 'value' }
                ,{ id: 'ptcCpsnCurY2'      , ctrlId : 'ptcCpsnCurY2'     ,value : 'value' }
                ,{ id: 'ptcCpsnCurY3'      , ctrlId : 'ptcCpsnCurY3'     ,value : 'value' }
                ,{ id: 'ptcCpsnCurY4'      , ctrlId : 'ptcCpsnCurY4'     ,value : 'value' }
                ,{ id: 'expArslY'          , ctrlId : 'expArslY'         ,value : 'value' }
                ,{ id: 'expArslY1'         , ctrlId : 'expArslY1'        ,value : 'value' }
                ,{ id: 'expArslY2'         , ctrlId : 'expArslY2'        ,value : 'value' }
                ,{ id: 'expArslY3'         , ctrlId : 'expArslY3'        ,value : 'value' }
                ,{ id: 'expArslY4'         , ctrlId : 'expArslY4'        ,value : 'value' }
                ,{ id: 'expArslCurY'       , ctrlId : 'expArslCurY'      ,value : 'value' }
                ,{ id: 'expArslCurY1'      , ctrlId : 'expArslCurY1'     ,value : 'value' }
                ,{ id: 'expArslCurY2'      , ctrlId : 'expArslCurY2'     ,value : 'value' }
                ,{ id: 'expArslCurY3'      , ctrlId : 'expArslCurY3'     ,value : 'value' }
                ,{ id: 'expArslCurY4'      , ctrlId : 'expArslCurY4'     ,value : 'value' }
                ,{ id: 'prjCd'             , ctrlId : 'prjCd'            ,value : 'value' }
                ,{ id: 'bizDptCd'          , ctrlId : 'bizDptCd'         ,value : 'value' }
                ,{ id: 'tssAttrCd'         , ctrlId : 'tssAttrCd'        ,value : 'html' }
                ,{ id: 'tssAttrNm'         , ctrlId : 'tssAttrNm'        ,value : 'html' }
                ,{ id: 'cfrnAtdtCdTxt'     , ctrlId : 'cfrnAtdtCdTxt'    ,value : 'value' }
                ,{ id: 'attcFilId'         , ctrlId : 'attcFilId'        ,value : 'value' }
                ,{ id: 'tssCd'             , ctrlId : 'tssCd'            ,value : 'value' }
                ,{ id: 'wbsCd'             , ctrlId : 'wbsCd'            ,value : 'value' }
                ,{ id: 'tssCdSn'           , ctrlId : 'tssCdSn'          ,value : 'value' }
                ,{ id: 'evSbcNm'           , ctrlId : 'grsEvSnNm'        ,value : 'value' }
                ,{ id: 'grsEvMTypeNm'      , ctrlId : 'grsEvMTypeNm'     ,value : 'html' }
                ,{ id: 'tssType'           , ctrlId : 'tssType'          ,value : 'html' }
                ,{ id: 'grsEvStNm'         , ctrlId : 'grsEvStNm'        ,value : 'html' }
            ]
        });


        <%--/*******************************************************************************
         * 첨부파일
         *******************************************************************************/--%>

         /* [기능] 첨부파일 조회 */
         var attachFileDataSet = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         attachFileDataSet.on('load', function(e) {
             getAttachFileInfoList();
         });

         getAttachFileList = function() {
             attachFileDataSet.clearData();
             attachFileDataSet.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                     attcFilId : lvAttcFilId
                 }
             });
         };

         getAttachFileInfoList = function() {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
             }

             setAttachFileInfo(attachFileInfoList);
         };

         getAttachFileId = function() {
             if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

             return lvAttcFilId;
         };
         setAttachFileInfo = function(attachFileList) {
             $('#attchFileView').html('');

             for(var i = 0; i < attachFileList.length; i++) {
                 $('#attchFileView').append($('<a/>', {
                     href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                     text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                 })).append('<br/>');
             }

             if(attachFileList.length > 0) {
                 lvAttcFilId = attachFileList[0].data.attcFilId;
                 dataSet.setNameValue(0, "attcFilId", lvAttcFilId)
                 tmpAttchFileList = attachFileList;
             }
         };

         downloadAttachFile = function(attcFilId, seq) {
            document.pform.attcFilId.value = attcFilId;
               document.pform.seq.value = seq;
               pform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>";
               pform.submit();
         };

         //임시저장
         fncImSave = function(){
             var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
             dm.on('success', function (e) {      // 업데이트 성공시
                 var resultData = resultDataSet.getReadData(e);

                 alert(resultData.records[0].rtnMsg);

                 if( resultData.records[0].rtnSt == "S"  ){
                     parent.grsPopupDialog.submit(true);
                     parent.fnSearch();
                 }
             });

             dm.on('failure', function (e) {      // 업데이트 실패시
                 var resultData = resultDataSet.getReadData(e);
                 alert(resultData.records[0].rtnMsg);
             });

             if(confirm('임시저장 하시겠습니까?')) {
                 dm.updateDataSet({
                     modifiedOnly: false,
                     url: '<c:url value="/prj/grs/saveTmpGrsEvRsltInfo.do"/>',
                     dataSets: [gridDataSet, dataSet]
                 });
             }
         }

         var valid = new Rui.validate.LValidatorManager({
             validators:[
                  { id: 'evTitl'            , validExp:'회의 장소:true' }
                 ,{ id: 'evDt'              , validExp:'회의일정:true' }
                 ,{ id: 'cfrnAtdtCdTxtNm'   , validExp:'회의 참석자:true' }
                 ,{ id: 'attcFilId'         , validExp:'첨부파일:true' }
                 ,{ id: 'commTxt'           , validExp:'Comment:true' }
                 //,{ id: 'ctyOtPlnM'         , validExp:'상품출시계획:true' }
                 ,{ id: 'grsEvSn'           , validExp:'평가표:true' }
             ]
         });

         var valid1 = new Rui.validate.LValidatorManager({
             validators:[
                  { id: 'evTitl'            , validExp:'회의일정/장소:true'}
                 ,{ id: 'evDt'              , validExp:'회의일정/장소:true'}
                 ,{ id: 'cfrnAtdtCdTxtNm'   , validExp:'회의 참석자:true'}
                 ,{ id: 'attcFilId'         , validExp:'첨부파일:true'}
                 ,{ id: 'commTxt'           , validExp:'Comment:true'}
                 //,{ id: 'ctyOtPlnM'         , validExp:'상품출시계획:true' }
                 ,{ id: 'grsEvSn'           , validExp:'평가표:true'}
                 ,{ id: 'bizPrftProY'       , validExp:'영업이익률:true:minNumber=0.01'}
                 ,{ id: 'bizPrftProY1'      , validExp:'영업이익률:true:minNumber=0.01'}
                 ,{ id: 'bizPrftProY2'      , validExp:'영업이익률:true:minNumber=0.01'}
                 ,{ id: 'bizPrftPlnY'       , validExp:'영업이익:true:minNumber=0.01'}
                 ,{ id: 'bizPrftPlnY1'      , validExp:'영업이익:true:minNumber=0.01'}
                 ,{ id: 'bizPrftPlnY2'      , validExp:'영업이익:true:minNumber=0.01'}
                 ,{ id: 'nprodSalsPlnY'     , validExp:'매출액:true:minNumber=0.01'}
                 ,{ id: 'nprodSalsPlnY1'    , validExp:'매출액:true:minNumber=0.01'}
                 ,{ id: 'nprodSalsPlnY2'    , validExp:'매출액:true:minNumber=0.01'}
                 ,{ id: 'ptcCpsnY'          , validExp:'투입인원:true:minNumber=0.1'}
                 ,{ id: 'expArslY'          , validExp:'투입비용:true:minNumber=0.1'}
             ]
         });

         var valid2 = new Rui.validate.LValidatorManager({
             validators:[
                  { id: 'evTitl'            , validExp:'회의일정/장소:true'}
                 ,{ id: 'evDt'              , validExp:'회의일정/장소:true'}
                 ,{ id: 'cfrnAtdtCdTxtNm'   , validExp:'회의 참석자:true'}
                 ,{ id: 'attcFilId'         , validExp:'첨부파일:true'}
                 ,{ id: 'commTxt'           , validExp:'Comment:true'}
                 //,{ id: 'ctyOtPlnM'         , validExp:'상품출시계획:true' }
                 ,{ id: 'grsEvSn'           , validExp:'평가표:true'}
                 ,{ id: 'nprodSalsPlnY'     , validExp:'매출액:true:minNumber=0.01'}
                 ,{ id: 'nprodSalsPlnY1'    , validExp:'매출액:true:minNumber=0.01'}
                 ,{ id: 'nprodSalsPlnY2'    , validExp:'매출액:true:minNumber=0.01'}
                 ,{ id: 'ptcCpsnY'          , validExp:'투입인원:true:minNumber=0.1'}
                 ,{ id: 'expArslY'          , validExp:'투입비용:true:minNumber=0.1'}
             ]
         });

         var valid3 = new Rui.validate.LValidatorManager({
             validators:[
                  { id: 'evTitl'            , validExp:'회의 장소:true'}
                 ,{ id: 'evDt'              , validExp:'회의일정:true'}
                 ,{ id: 'cfrnAtdtCdTxtNm'   , validExp:'회의 참석자:true'}
                 ,{ id: 'attcFilId'         , validExp:'첨부파일:true'}
                 ,{ id: 'commTxt'           , validExp:'Comment:true'}
                 //,{ id: 'ctyOtPlnM'         , validExp:'상품출시계획:true' }
                 ,{ id: 'nprodNm'           , validExp:'신제품명:true'}
                 ,{ id: 'grsEvSn'           , validExp:'평가표:true'}
             ]
         });

         var valid4 = new Rui.validate.LValidatorManager({
             validators:[
                  { id: 'evTitl'            , validExp:'회의 장소:true'}
                 ,{ id: 'evDt'              , validExp:'회의일정:true'}
                 ,{ id: 'cfrnAtdtCdTxtNm'   , validExp:'회의 참석자:true'}
                 ,{ id: 'attcFilId'         , validExp:'첨부파일:true'}
                 //,{ id: 'ctyOtPlnM'         , validExp:'상품출시계획:true' }
                 ,{ id: 'commTxt'           , validExp:'Comment:true'}
             ]
         });

         //T형
         var valid5 = new Rui.validate.LValidatorManager({
             validators:[
                  { id: 'evTitl'            , validExp:'회의일정/장소:true'}
                 ,{ id: 'evDt'              , validExp:'회의일정/장소:true'}
                 ,{ id: 'cfrnAtdtCdTxtNm'   , validExp:'회의 참석자:true'}
                 ,{ id: 'attcFilId'         , validExp:'첨부파일:true'}
                 ,{ id: 'commTxt'           , validExp:'Comment:true'}
                 //,{ id: 'ctyOtPlnM'         , validExp:'상품출시계획:true' }
                 ,{ id: 'grsEvSn'           , validExp:'평가표:true'}
                 ,{ id: 'ptcCpsnY'          , validExp:'투입인원:true:minNumber=0.1'}
                 ,{ id: 'expArslY'          , validExp:'투입비용:true:minNumber=0.1'}
             ]
         });

         fncInputChk = function(){
             if (chkVaild ==2 ){
                //인원체크
                if(  ptcCpsnY1.getValue() < 0 || Rui.isEmpty( ptcCpsnY1.getValue() )   ){
                    alert("2차년도 투입인원을 입력하세요");
                    return true;
                }

                // 투입비용
                if(  expArslY1.getValue() < 0 || Rui.isEmpty( expArslY1.getValue() )   ){
                    alert("2차년도 투입비용을 입력하세요");
                    return true;
                }
             }else if (  chkVaild ==3 ){
                //인원체크
                if(  ptcCpsnY1.getValue() < 0 || Rui.isEmpty( ptcCpsnY1.getValue() )   ){
                    alert("2차년도 투입인원을 입력하세요");
                    return true;
                }
                if(  ptcCpsnY2.getValue() < 0 || Rui.isEmpty( ptcCpsnY2.getValue() )   ){
                    alert("3차년도 투입인원을 입력하세요");
                    return true;
                }

                // 투입비용
                if(  expArslY1.getValue() < 0 || Rui.isEmpty( expArslY1.getValue() )   ){
                    alert("2차년도 투입비용을 입력하세요");
                    return true;
                }
                if(  expArslY2.getValue() < 0 || Rui.isEmpty( expArslY2.getValue() )   ){
                    alert("3차년도 투입비용을 입력하세요");
                    return true;
                }

             }else if (  chkVaild == 4 ){
                //인원체크
                if(  ptcCpsnY1.getValue() < 0 || Rui.isEmpty( ptcCpsnY1.getValue() )   ){
                    alert("2차년도 투입인원을 입력하세요");
                    return true;
                }
                if(  ptcCpsnY2.getValue() < 0 || Rui.isEmpty( ptcCpsnY2.getValue() )   ){
                    alert("3차년도 투입인원을 입력하세요");
                    return true;
                }
                if(  ptcCpsnY3.getValue() < 0 || Rui.isEmpty( ptcCpsnY3.getValue() )   ){
                    alert("4차년도 투입인원을 입력하세요");
                    return true;
                }

                // 투입비용
                if(  expArslY1.getValue() < 0 || Rui.isEmpty( expArslY1.getValue() )   ){
                    alert("2차년도 투입비용을 입력하세요");
                    return true;
                }
                if(  expArslY2.getValue() < 0 || Rui.isEmpty( expArslY2.getValue() )   ){
                    alert("3차년도 투입비용을 입력하세요");
                    return true;
                }
                if(  expArslY3.getValue() < 0 || Rui.isEmpty( expArslY3.getValue() )   ){
                    alert("4차년도 투입비용을 입력하세요");
                    return true;
                }

             }else if (  chkVaild > 4 ){
                //인원체크
                if(  ptcCpsnY1.getValue() < 0 || Rui.isEmpty( ptcCpsnY1.getValue() )   ){
                    alert("2차년도 투입인원을 입력하세요");
                    return true;
                }
                if(  ptcCpsnY2.getValue() < 0 || Rui.isEmpty( ptcCpsnY2.getValue() )   ){
                    alert("3차년도 투입인원을 입력하세요");
                    return true;
                }
                if(  ptcCpsnY3.getValue() < 0 || Rui.isEmpty( ptcCpsnY3.getValue() )   ){
                    alert("4차년도 투입인원을 입력하세요");
                    return true;
                }
                if(  ptcCpsnY4.getValue() < 0 || Rui.isEmpty( ptcCpsnY4.getValue() )   ){
                    alert("5차년도 투입인원을 입력하세요");
                    return true;
                }

                // 투입비용
                if(  expArslY1.getValue() < 0 || Rui.isEmpty( expArslY1.getValue() )   ){
                    alert("2차년도 투입비용을 입력하세요");
                    return true;
                }
                if(  expArslY2.getValue() < 0 || Rui.isEmpty( expArslY2.getValue() )   ){
                    alert("3차년도 투입비용을 입력하세요");
                    return true;
                }
                if(  expArslY3.getValue() < 0 || Rui.isEmpty( expArslY3.getValue() )   ){
                    alert("4차년도 투입비용을 입력하세요");
                    return true;
                }
                if(  expArslY4.getValue() < 0 || Rui.isEmpty( expArslY4.getValue() )   ){
                    alert("5차년도 투입비용을 입력하세요");
                    return true;
                }
             }

             return false;

         }


         //GRS 평가등록
         fncGrsSave= function(){
             var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
             dm.on('success', function (e) {      // 업데이트 성공시
                 var resultData = resultDataSet.getReadData(e);

                 alert(resultData.records[0].rtnMsg);

                 if( resultData.records[0].rtnSt == "S"  ){
                     parent.grsPopupDialog.submit(true);
                     parent.fnSearch();
                 }
             });

             dm.on('failure', function (e) {      // 업데이트 실패시
                 var resultData = resultDataSet.getReadData(e);
                 alert(resultData.records[0].rtnMsg);
             });

             var grsEvSt = dataSet.getNameValue(0, 'grsEvSt');
             var evPoint = $(".L-grid-cell-inner.L-grid-col-calScr:last").html();
             var grsMsg = "";

             if( dataSet.getNameValue(0, 'tssScnCd') == "G" ){
                 if( dataSet.getNameValue(0, 'grsEvSt').trim() == 'M'  &&  (grsEvMType.getValue() == "IN" || grsEvMType.getValue() == "HD" ) ){
                     if(valid.validateGroup('aform') == false) {
                            alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid.getMessageList().join(''));
                         return;
                     }
                 }else{
                     if ( dataSet.getNameValue(0, 'tssType') == "TT"){
                         if(valid5.validateGroup('aform') == false) {
                                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid5.getMessageList().join(''));
                             return;
                         }
                     }else if (  dataSet.getNameValue(0, 'bizDptCd') == "01" || dataSet.getNameValue(0, 'bizDptCd') == "03" || dataSet.getNameValue(0, 'bizDptCd') == "06"){
                         if(valid1.validateGroup('aform') == false) {
                                   alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid1.getMessageList().join(''));
                                return;
                         }
                     }else if ( dataSet.getNameValue(0, 'bizDptCd') == "05") {
                           if(valid4.validateGroup('aform') == false) {
                                  alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid4.getMessageList().join(''));
                               return;
                          }

                     }else if ( dataSet.getNameValue(0, 'bizDptCd') == "11" ) {
                           if(valid3.validateGroup('aform') == false) {
                                  alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid3.getMessageList().join(''));
                               return;
                          }
                     }else if (  dataSet.getNameValue(0, 'bizDptCd') == "05" &&  dataSet.getNameValue(0, 'custSqlt') == "05" ) {
                           if(valid4.validateGroup('aform') == false) {
                                  alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid4.getMessageList().join(''));
                               return;
                          }
                     }else{
                         if(valid2.validateGroup('aform') == false) {
                                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid2.getMessageList().join(''));
                             return;
                         }
                     }
                 }

                 if ( dataSet.getNameValue(0, 'grsEvSt') == "G1" ){
                     if (  dataSet.getNameValue(0, 'tssType') !=  "TT"  ){ //[20240417.siseo] S급~C급까지 필수체크 하도록 수정
                     //if (  dataSet.getNameValue(0, 'tssType') == "ST" || dataSet.getNameValue(0, 'tssType') == "AT" || dataSet.getNameValue(0, 'tssType') == "BT" || dataSet.getNameValue(0, 'tssType') == "CT"  ){
                         if(Rui.isEmpty( ctyOtPlnM.getValue())   ){
                             alert("상품출시일는 필수입력값입니다.");
                             return;
                          }
                     }

                 }else{
                     if ( grsEvMType.getValue() == "AL" ){
                        if (  dataSet.getNameValue(0, 'tssType') != "TT"  ){ //[20240417.siseo] S급~C급까지 필수체크 하도록 수정
                        //if (  dataSet.getNameValue(0, 'tssType') == "ST" || dataSet.getNameValue(0, 'tssType') == "AT" || dataSet.getNameValue(0, 'tssType') == "BT" || dataSet.getNameValue(0, 'tssType') == "CT"  ){
                            if(Rui.isEmpty( ancpOtPlnDt.getValue())   ){
                                  alert("상품출시일는 필수입력값입니다.");
                                  return;
                               }
                         }
                     }
                 }

                 var chkCnt = fnAttchValid();

                 //첨부파일 체크 시 pb팀 예외
                 if ( dataSet.getNameValue(0, 'tssType') =="CB" || dataSet.getNameValue(0, 'tssType') =="IA" || dataSet.getNameValue(0, 'tssType') =="IB" || dataSet.getNameValue(0, 'tssType') =="IC" ){

                 }else{
                     if ( dataSet.getNameValue(0, 'bizDptCd') == "05" && dataSet.getNameValue(0, 'custSqlt') == "05"    ){
                     }else{
                         if (chkCnt < 3  ){
                             alert("첨부파일(통합심의서, 회의록, 평가표 등)이 누락되어있습니다.");
                             return;
                         }
                     }
                 }

                 if ( dataSet.getNameValue(0, 'bizDptCd') == "05" && dataSet.getNameValue(0, 'custSqlt') == "05"    ){
                 }else{
                     if( fncInputChk()   ){
                            return true;
                     }
                 }
             }else{

                 if ( dataSet.getNameValue(0, 'tssScnCd') == "D" ){
                     var chkCnt = fnAttchValid();

                     if ( dataSet.getNameValue(0, 'tssType') =="CB" ||  dataSet.getNameValue(0, 'tssType') =="BB"
                         || dataSet.getNameValue(0, 'tssType') =="IA" || dataSet.getNameValue(0, 'tssType') =="IB" || dataSet.getNameValue(0, 'tssType') =="IC"    ){

                     }else{
                         if ( dataSet.getNameValue(0, 'bizDptCd') == "05" && dataSet.getNameValue(0, 'custSqlt') == "05" ){
                         }else{
                             if (chkCnt < 3  ){
                                 alert("첨부파일(통합심의서, 회의록, 평가표 등)이 누락되어있습니다.");
                                 return;
                             }
                         }
                     }

                     if ( dataSet.getNameValue(0, 'bizDptCd') == "05" && dataSet.getNameValue(0, 'custSqlt') == "05" ){
                     }else{
                         if( fncInputChk()   ){
                                return true;
                         }
                     }
                 }

                 if ( dataSet.getNameValue(0, 'tssType') == "TT"){
                     if(valid5.validateGroup('aform') == false) {
                            alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid5.getMessageList().join(''));
                         return;
                     }
                 }else if ( dataSet.getNameValue(0, 'bizDptCd') == "05" &&  dataSet.getNameValue(0, 'custSqlt') == "05"){
                    if(valid4.validateGroup('aform') == false) {
                        alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid4.getMessageList().join(''));
                          return;
                     }
                }else {
                    if(valid.validateGroup('aform') == false) {
                           alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid.getMessageList().join(''));
                         return;
                     }
                }
             }

             if ( dataSet.getNameValue(0, 'tssType') =="CB" ||  dataSet.getNameValue(0, 'tssType') =="BB"  ||  dataSet.getNameValue(0, 'custSqlt') =="05"
                 || dataSet.getNameValue(0, 'tssType') =="IA" || dataSet.getNameValue(0, 'tssType') =="IB" || dataSet.getNameValue(0, 'tssType') =="IC" ){
             }else{
                 if( gridDataSet.getCount() == 0  ){
                     alert("GRS평가표를 작성하세요");
                     return;
                 }
             }

             if( dataSet.getNameValue(0, 'grsEvSt') == "M" && Rui.isEmpty(grsEvMType.getValue()) ){
                Rui.alert("중간평가 방법을 입력하세요");
                return;
             }

             //[20240320.siseo] 무조건 PASS 로직을 변경함.
             /*if ( dataSet.getNameValue(0, 'tssType') == "CB" || dataSet.getNameValue(0, 'tssType') =="BB" || dataSet.getNameValue(0, 'tssType') =="TT" || dataSet.getNameValue(0, 'custSqlt') =="05"
                 || dataSet.getNameValue(0, 'tssType') =="IA" || dataSet.getNameValue(0, 'tssType') =="IB" || dataSet.getNameValue(0, 'tssType') =="IC"    ){*/
             if (dataSet.getNameValue(0, 'custSqlt') =="05") { //과제 GRS 기본 정보 마스터(추가).고객특성[05:B2B(수주형)]은 무조건 PASS되도록 함.
                 dataSet.setNameValue(0, 'dropYn', "N");
             }else{ //그외에는 평균점수에 따라 PASS/DROP이 결정됨.
                 if( evPoint < 70  ){
                        dataSet.setNameValue(0, 'grsEvSt', "D");
                        dataSet.setNameValue(0, 'dropYn', "Y");
                        grsMsg ="<font color='#DA1C5A'>※ 평가 환산점수 합계가  70점 미만 입니다.</font><br><br>";
                  }else{
                      dataSet.setNameValue(0, 'dropYn', "N");
                  }

             }

             Rui.confirm({
                 text: grsMsg+'평가완료 하시겠습니까?<br>완료후에는 수정/삭제가 불가능합니다.',
                 handlerYes: function () {
                     dm.updateDataSet({
                         modifiedOnly: false,
                         url: '<c:url value="/prj/grs/saveGrsEvRsltInfo.do"/>',
                         dataSets: [gridDataSet, dataSet]
                     });
                 }
             });
         }

         //닫기
         fncCancel = function(){
             parent.grsPopupDialog.submit(true);
         }

         fnAttchValid = function (){
              var chkNum = 0;

              if( !Rui.isEmpty(tmpAttchFileList) ){
                  for(var i = 0; i < tmpAttchFileList.length; i++) {
                      if(tmpAttchFileList[i].data.filNm.indexOf('통합심의서') > -1 || tmpAttchFileList[i].data.filNm.indexOf('통합 심의서') > -1 || tmpAttchFileList[i].data.filNm.indexOf('회의록') > -1 || tmpAttchFileList[i].data.filNm.indexOf('평가표') > -1 ){
                          chkNum++;
                      }
                  }
              }
              return chkNum;
         }

         fncPtcCpsnYDisable = function(){
             var arr1 = strDt.split("-");
             var arr2 = endDt.split("-");

             var diffCnt = (Number(arr2[0]) - Number(arr1[0])) + 1;

             if( diffCnt == 1 ){
                 ptcCpsnY1.disable();
                 ptcCpsnY2.disable();
                 ptcCpsnY3.disable();
                 ptcCpsnY4.disable();

                 expArslY1.disable();
                 expArslY2.disable();
                 expArslY3.disable();
                 expArslY4.disable();

                 chkVaild =1;
             }else if( diffCnt == 2 ){
                 ptcCpsnY1.enable();
                 ptcCpsnY2.disable();
                 ptcCpsnY3.disable();
                 ptcCpsnY4.disable();

                 expArslY1.enable();
                 expArslY2.disable();
                 expArslY3.disable();
                 expArslY4.disable();


                 chkVaild =2;
             }else if( diffCnt == 3 ){
                 ptcCpsnY1.enable();
                 ptcCpsnY2.enable();
                 ptcCpsnY3.disable();
                 ptcCpsnY4.disable();

                 expArslY1.enable();
                 expArslY2.enable();
                 expArslY3.disable();
                 expArslY4.disable();


                 chkVaild =3;
             }else if( diffCnt == 4 ){
                 ptcCpsnY1.enable();
                 ptcCpsnY2.enable();
                 ptcCpsnY3.enable();
                 ptcCpsnY4.disable();

                 expArslY1.enable();
                 expArslY2.enable();
                 expArslY3.enable();
                 expArslY4.disable();
                 chkVaild =4;
             }else if( diffCnt > 4 ){
                 ptcCpsnY1.enable();
                 ptcCpsnY2.enable();
                 ptcCpsnY3.enable();
                 ptcCpsnY4.enable();

                 expArslY1.enable();
                 expArslY2.enable();
                 expArslY3.enable();
                 expArslY4.enable();
                 chkVaild =5;
             }
             console.log("[chkVaild]", chkVaild);
         }

    });

    function setGrsEvSnInfo(grsInfo) {
        grsEvSnNm.setValue(grsInfo.evSbcNm);
        dataSet.setNameValue(0, 'grsEvSn' , grsInfo.grsEvSn);
        gridDataSet.clearData();
        gridDataSet.load({
               url: '<c:url value="/prj/grs/selectGrsEvRsltInfo.do"/>',
               params: {
                   grsEvSn: grsInfo.grsEvSn,
                   tssCd   : dataSet.getNameValue(0, 'tssCd'),
                   tssCdSn : dataSet.getNameValue(0, 'tssCdSn')
               }
           });
     }
</script>
</head>
<body>
<div class="contents">
    <div class="sub-content">

<form  id="pform" name="pform" method="post">
    <input type="hidden" id="attcFilId" name="attcFilId" />
    <input type="hidden" id="seq" name="seq" />
</form>


 <form id="aform" name="aform">
          <table class="table table_txt_right">
            <colgroup>
                <col style="width: 20%;" />
                <col style="width: 30%;" />
                <col style="width: 20%;" />
                <col style="width: 30%;" />
            </colgroup>
            <tbody>

            <tr>
                <th align="right">프로젝트명</th>
                <td><span id="prjNm"></span></td>
                <th align="right">사업부문(Funding기준)</th>
                <td><span id="bizDptNm"></span></td>
            </tr>
            <tr>
                <th align="right">과제속성</th>
                <td class="tssLableCss">
                    <span id="tssAttrNm"></<span>
                </td>
                <th align="right">과제명</th>
                <td><span id="tssNm"></span></td>
            </tr>
            <tr>
                <th align="right">심의단계</th>
                <td class="tssLableCss">
                    <span id="grsEvStNm"></<span>
                    <!-- <span id="grsEvMTypeNm"></<span> -->
                </td>

                <th align="right">개발등급</th>
                <td ><span type="text" id="tssTypeNm"></span></td>

            </tr>
            <tr>
                <th align="right">과제기간</th>
                <td><span id="tssDd"></span>  </td>
                <th align="right">심의담당자</th>
                <td><span id="dlbrCrgrNm"/></td>
            </tr>
            <tr>
                <th align="right"><span style="color:red;">* </span>회의 일정</th>
                <td><input type="text" id="evDt" /></td>
                <th align="right"><span style="color:red;">* </span>회의 장소</th>
                <td><input type="text" id="evTitl" /></td>
            </tr>
            <tr>
                <th align="right"><span style="color:red;">* </span>회의 참석자</th>
                <td colspan="3">
                    <div class="LblockMarkupCode">
                        <div id="cfrnAtdtCdTxtNm"></div>
                    </div>
                </td>
            </tr>
            <tr>
                <th align="right"><span style="color:red;">* </span>Comment</th>
                <td colspan="3"><textarea id="commTxt"></textarea></td>
            </tr>
            <tr>
                <th align="right"><span style="color:red;">* </span>첨부파일</th>
                <td  colspan="2" id="attchFileView" />
                <td ><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
            </tr>
            <tr id="trGrsEvMType" style="display:none;">
                <th align="right"><span style="color:red;">* </span>중간평가 방법 선택</th>
                <td colspan="3"><div id="grsEvMType"/> </td>
            </tr>
            </tbody>
        </table>
        <table class="table table_txt_right" id="grsDev">
            <colgroup>
                <col style="width: 20%;" />
                <col style="width: 16%;" />
                <col style="width: 16%;" />
                <col style="width: 16%;" />
                <col style="width: 16%;" />
                <col style="width: 16%;" />
            </colgroup>
            <tbody>
                <tr  id="trCtyOtPlnM" style="display:none;">
                    <th><span style="color:red;">* </span>상품출시계획</th>
                    <td  colspan="5">
                        <input type="text" id="ctyOtPlnM" />
                    </td>
                  </tr>
                <tr  id="trAncpOtPlnDt" style="display:none;">
                    <th>예상출시일(계획)</th>
                    <td  colspan="5">
                        <input type="text" id="ancpOtPlnDt" />
                    </td>
                  </tr>
                  <tr id="trbizPrftProHead">
                      <th rowspan="2">영업이익률(%)</th>
                      <th class="alignC">출시년도</th>
                      <th class="alignC">출시년도+1</th>
                      <th class="alignC">출시년도+2</th>
                      <th class="alignC">출시년도+3</th>
                      <th class="alignC">출시년도+4</th>
                  </tr>
                  <tr id="trbizPrftPro">
                      <td><input type="text" id="bizPrftProY"></td>
                      <td><input type="text" id="bizPrftProY1"></td>
                      <td><input type="text" id="bizPrftProY2"></td>
                      <td></td>
                      <td></td>
                  </tr>
                  <tr id="trbizPrftPlnHead">
                      <th rowspan="2">영업이익(억원)</th>
                      <th class="alignC">출시년도</th>
                      <th class="alignC">출시년도+1</th>
                      <th class="alignC">출시년도+2</th>
                      <th class="alignC">출시년도+3</th>
                      <th class="alignC">출시년도+4</th>
                  </tr>
                  <tr id="trbizPrftPln">
                      <td><input type="text" id="bizPrftPlnY"></td>
                      <td><input type="text" id="bizPrftPlnY1"></td>
                      <td><input type="text" id="bizPrftPlnY2"></td>
                      <td></td>
                      <td></td>
                  </tr>
                <tr  id="trNprodSalHead">
                      <th rowspan="2"><span style="color:red;">* </span>매출액(억원)</th>
                      <th class="alignC">출시년도</th>
                      <th class="alignC">출시년도+1</th>
                      <th class="alignC">출시년도+2</th>
                      <th class="alignC">출시년도+3</th>
                      <th class="alignC">출시년도+4</th>
                  </tr>
                  <tr id="trNprodSal">
                      <td><input type="text" id="nprodSalsPlnY" /></td>
                      <td><input type="text" id="nprodSalsPlnY1"/></td>
                      <td><input type="text" id="nprodSalsPlnY2"/></td>
                      <td><span id="nprodSalsPlnY3"></td>
                      <td><span id="nprodSalsPlnY4"></td>
                  </tr>
                  <tr id="trPtcCpsnHead">
                      <th rowspan="2">
                          <span style="color:red;">* </span>투입인원(M/M)
                          <br/><br/>
                          ※투입율기준 입력<br/>(개발기간을 고려하지 않음)
                      </th>
                      <th class="alignC">과제시작년도</th>
                      <th class="alignC">과제시작년도+1</th>
                      <th class="alignC">과제시작년도+2</th>
                      <th class="alignC">과제시작년도+3</th>
                      <th class="alignC">과제시작년도+4</th>
                  </tr>
                  <tr id="trPtcCpsn">
                      <td><input type="text" id="ptcCpsnY"></td>
                      <td><input type="text" id="ptcCpsnY1"></td>
                      <td><input type="text" id="ptcCpsnY2"></td>
                      <td><input type="text" id="ptcCpsnY3"></td>
                      <td><input type="text" id="ptcCpsnY4"></td>
                  </tr>
                  <tr id="trExpArslHead">
                      <th rowspan="2">투입비용(억원)</th>
                      <th class="alignC">과제시작년도</th>
                      <th class="alignC">과제시작년도+1</th>
                      <th class="alignC">과제시작년도+2</th>
                      <th class="alignC">과제시작년도+3</th>
                      <th class="alignC">과제시작년도+4</th>
                  </tr>
                  <tr id="trExpArsl">
                      <td><input type="text" id="expArslY"></td>
                      <td><input type="text" id="expArslY1"></td>
                      <td><input type="text" id="expArslY2"></td>
                      <td><input type="text" id="expArslY3"></td>
                      <td><input type="text" id="expArslY4"></td>
                  </tr>
            </tbody>
        </table>
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 20%;" />
                <col style="width: 80%;" />
            </colgroup>
            <tbody>
                <tr id="trEv" style="display:none;">
                    <th align="right"><span style="color:red;">* </span>평가표 선택</th>
                    <td><input type="text" id="grsEvSnNm"/></td>
                </tr>
                <tr id="trEvResult" style="display:none;">
                    <th align="right">평가결과</th>
                    <td><input type="text" id="evResult"/></td>
                </tr>
            </tbody>
        </table>

        <div id="evTableGrid" style="margin-top: 20px"></div>
      </form>
          </div>
          <div class="titArea" style="align:center">
            <div class="LblockButton">
                <button type="button" id="butImSave" onClick="fncImSave();">임시저장</button>
                <button type="button" id="btnGrsSave" onclick="fncGrsSave();">등록</button>
                <button type="button" id="butCancel" onClick="fncCancel();">닫기</button>
            </div>
        </div>
      </div>
</div>
</body>
</html>


