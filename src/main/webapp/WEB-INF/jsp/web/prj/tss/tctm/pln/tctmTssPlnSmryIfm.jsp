<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : insertGenTssSmry.jsp
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;
    var lvTssStrtDd = window.parent.tssStrtDd.getValue();
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && (lvPageMode == "W" || lvPageMode == "") ? "W" : "R";

    var dataSet;
    var lvAttcFilId;

    var strDt =window.parent.tssStrtDd.getValue();
    var endDt =window.parent.tssFnhDd.getValue();

    Rui.onReady(function() {

        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //시장규모
        mrktSclTxt = new Rui.ui.form.LTextArea({
            applyTo: 'mrktSclTxt',
            height: 100,
            width: 600
        });

        //요약개요
        smrSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrSmryTxt',
            height: 100,
            width: 600
        });

        //요약목표
        smrGoalTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrGoalTxt',
            height: 100,
            width: 600
        });
       
        //지적재산권 통보
        pmisTxt = new Rui.ui.form.LTextArea({
            applyTo: 'pmisTxt',
            height: 100,
            width: 600
        });

        //상품출시(계획)
        ctyOtPlnM = new Rui.ui.form.LMonthBox({
            applyTo: 'ctyOtPlnM',
            mask: '9999-99',
            displayValue: '%Y-%m',
            //defaultValue: new Date(),
            width: 100,
            dateType: 'string'
        });
        ctyOtPlnM.on('blur', function() {
            if(ctyOtPlnM.getValue() == "") {
                return;
            }
        });

        //신제품매출계획Y
        nprodSalsPlnY = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY',
            defaultValue: 0,
            decimalPrecision: 2,
            maxValue: 999999999.999999,
            width: 120
        });
        nprodSalsPlnY.on('changed', function() {
            fnGetYAvg("nprod");
        });

        //신제품매출계획Y+1
        nprodSalsPlnY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY1',
            defaultValue: 0,
            decimalPrecision: 2,
            maxValue: 999999999.999999,
            width: 120
        });
        nprodSalsPlnY1.on('changed', function() {
            fnGetYAvg("nprod");
        });

        //신제품매출계획Y+2
        nprodSalsPlnY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY2',
            defaultValue: 0,
            decimalPrecision: 2,
            maxValue: 999999999.999999,
            width: 120
        });
        nprodSalsPlnY2.on('changed', function() {
            fnGetYAvg("nprod");
        });

        //신제품매출계획Y+3
        nprodSalsPlnY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY3',
            defaultValue: 0,
            decimalPrecision: 2,
            maxValue: 999999999.999999,
            width: 120
        });
        nprodSalsPlnY3.on('changed', function() {
            fnGetYAvg("nprod");
        });

        //신제품매출계획Y+4
        nprodSalsPlnY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY4',
            defaultValue: 0,
            decimalPrecision: 2,
            maxValue: 999999999.999999,
            width: 120
        });
        nprodSalsPlnY4.on('changed', function() {
            fnGetYAvg("nprod");
        });

        //신제품매출계획평균
        nprodSalsPlnYAvg = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnYAvg',
            decimalPrecision: 2,
            editable: false,
            width: 120
        });

        //투입인원(M/M)Y
        ptcCpsnY = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY',
            decimalPrecision: 0,
            maxValue: 999,
            width: 120
        });
        ptcCpsnY.on('changed', function() {
            fnGetYAvg("ptc");
        });

        //투입인원(M/M)Y+1
        ptcCpsnY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY1',
            decimalPrecision: 0,
            maxValue: 999,
            width: 120
        });
        ptcCpsnY1.on('changed', function() {
            fnGetYAvg("ptc");
        });

        //투입인원(M/M)Y+2
        ptcCpsnY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY2',
            decimalPrecision: 0,
            maxValue: 999,
            width: 120
        });
        ptcCpsnY2.on('changed', function() {
            fnGetYAvg("ptc");
        });

        //투입인원(M/M)Y+3
        ptcCpsnY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY3',
            decimalPrecision: 0,
            maxValue: 999,
            width: 120
        });
        ptcCpsnY3.on('changed', function() {
            fnGetYAvg("ptc");
        });

        //투입인원(M/M)Y+4
        ptcCpsnY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY4',
            decimalPrecision: 0,
            maxValue: 999,
            width: 120
        });
        ptcCpsnY4.on('changed', function() {
            fnGetYAvg("ptc");
        });

        //투입인원(M/M)평균
        ptcCpsnYAvg = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnYAvg',
            decimalPrecision: 2,
            editable: false,
            width: 120
        });

        //영업이익율Y
        bizPrftProY = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY',
            decimalPrecision: 2,
            maxValue: 999.99,
            width: 120
        });
        bizPrftProY.on('changed', function() {
            fnGetYAvg("biz");
        });

        //영업이익율Y+1
        bizPrftProY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY1',
            decimalPrecision: 2,
            maxValue: 999.99,
            width: 120
        });
        bizPrftProY1.on('changed', function() {
            fnGetYAvg("biz");
        });

        //영업이익율Y+2
        bizPrftProY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY2',
            decimalPrecision: 2,
            maxValue: 999.99,
            width: 120
        });
        bizPrftProY2.on('changed', function() {
            fnGetYAvg("biz");
        });

        //영업이익율Y+3
        bizPrftProY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY3',
            decimalPrecision: 2,
            maxValue: 999.99,
            width: 120
        });
        bizPrftProY3.on('changed', function() {
            fnGetYAvg("biz");
        });

        //영업이익율Y+4
        bizPrftProY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY4',
            decimalPrecision: 2,
            maxValue: 999.99,
            width: 120
        });
        bizPrftProY4.on('changed', function() {
            fnGetYAvg("biz");
        });

        //영업이익율평균
        bizPrftProYAvg = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProYAvg',
            decimalPrecision: 2,
            editable: false,
            width: 120
        });

        //Form 비활성화
        disableFields = function() {
            document.getElementById('nprodSalsPlnYAvg').style.border = 0;
            document.getElementById('ptcCpsnYAvg').style.border = 0;
            document.getElementById('bizPrftProYAvg').style.border = 0;

            if(lvTssSt == "") btnReport.hide();

            if(pageMode == "W") return;

            document.getElementById('attchFileMngBtn').style.display = "none";
            btnSave.hide();
        };


        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }            //과제코드
                , { id: 'smryNTxt' }         //Needs
                , { id: 'smryATxt' }         //Approach
                , { id: 'smryBTxt' }         //Benefit
                , { id: 'smryCTxt' }         //Competition
                , { id: 'smryDTxt' }         //Deliverables
                , { id: 'mrktSclTxt' }       //시장규모
                , { id: 'ctyOtPlnM' }        //상품출시(계획)
                , { id: 'smrSmryTxt' }       //Summary 개요
                , { id: 'smrGoalTxt' }       //Summary 목표
                , { id: 'bizPrftProY',  type: 'number', defaultValue:0 }     //영업이익율Y
                , { id: 'bizPrftProY1', type: 'number', defaultValue:0 }     //영업이익율Y+1
                , { id: 'bizPrftProY2', type: 'number', defaultValue:0 }     //영업이익율Y+2
                , { id: 'bizPrftProY3', type: 'number', defaultValue:0 }     //영업이익율Y+3
                , { id: 'bizPrftProY4', type: 'number', defaultValue:0 }     //영업이익율Y+4
                , { id: 'bizPrftProYAvg', type: 'number', defaultValue:0 }   //영업이익율평균
                , { id: 'nprodSalsPlnY', type: 'number', defaultValue:0 }    //신제품매출계획Y
                , { id: 'nprodSalsPlnY1', type: 'number', defaultValue:0 }   //신제품매출계획Y+1
                , { id: 'nprodSalsPlnY2', type: 'number', defaultValue:0 }   //신제품매출계획Y+2
                , { id: 'nprodSalsPlnY3', type: 'number', defaultValue:0 }   //신제품매출계획Y+3
                , { id: 'nprodSalsPlnY4', type: 'number', defaultValue:0 }   //신제품매출계획Y+4
                , { id: 'nprodSalsPlnYAvg', type: 'number', defaultValue:0 } //신제품매출계획평균
                , { id: 'ptcCpsnY', type: 'number', defaultValue:0 }         //투입인원(M/M)Y
                , { id: 'ptcCpsnY1', type: 'number', defaultValue:0 }        //투입인원(M/M)Y+1
                , { id: 'ptcCpsnY2', type: 'number', defaultValue:0 }        //투입인원(M/M)Y+2
                , { id: 'ptcCpsnY3', type: 'number', defaultValue:0 }        //투입인원(M/M)Y+3
                , { id: 'ptcCpsnY4', type: 'number', defaultValue:0 }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnYAvg', type: 'number', defaultValue:0 }      //투입인원(M/M)평균
                , { id: 'pmisTxt' }       //지적재산권 통보
                , { id: 'attcFilId' }        //첨부파일ID
                , { id: 'userId' }           //로그인ID
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");

            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

            var dsNprodSalsPlnY  = (dataSet.getNameValue(0, "nprodSalsPlnY")  / 100000000).toFixed(2);
            var dsNprodSalsPlnY1 = (dataSet.getNameValue(0, "nprodSalsPlnY1") / 100000000).toFixed(2);
            var dsNprodSalsPlnY2 = (dataSet.getNameValue(0, "nprodSalsPlnY2") / 100000000).toFixed(2);
            var dsNprodSalsPlnY3 = (dataSet.getNameValue(0, "nprodSalsPlnY3") / 100000000).toFixed(2);
            var dsNprodSalsPlnY4 = (dataSet.getNameValue(0, "nprodSalsPlnY4") / 100000000).toFixed(2);

            nprodSalsPlnY.setValue(dsNprodSalsPlnY);
            nprodSalsPlnY1.setValue(dsNprodSalsPlnY1);
            nprodSalsPlnY2.setValue(dsNprodSalsPlnY2);
            nprodSalsPlnY3.setValue(dsNprodSalsPlnY3);
            nprodSalsPlnY4.setValue(dsNprodSalsPlnY4);

	        fncPtcCpsnYDisable(strDt, endDt);
            setTimeout(function () {
	            fnGetYAvg("ptc");
	            fnGetYAvg("biz");
                tabViewS.selectTab(0);
            }, 1000);
        });

        //Form 바인드
        var bind = new Rui.data.LBind({
            groupId: 'smryFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                , { id: 'smryNTxt',         ctrlId: 'smryNTxt',         value: 'value' }
                , { id: 'smryATxt',         ctrlId: 'smryATxt',         value: 'value' }
                , { id: 'smryBTxt',         ctrlId: 'smryBTxt',         value: 'value' }
                , { id: 'smryCTxt',         ctrlId: 'smryCTxt',         value: 'value' }
                , { id: 'smryDTxt',         ctrlId: 'smryDTxt',         value: 'value' }
                , { id: 'mrktSclTxt',       ctrlId: 'mrktSclTxt',       value: 'value' }
                , { id: 'ctyOtPlnM',        ctrlId: 'ctyOtPlnM',        value: 'value' }
                , { id: 'smrSmryTxt',       ctrlId: 'smrSmryTxt',       value: 'value' }
                , { id: 'smrGoalTxt',       ctrlId: 'smrGoalTxt',       value: 'value' }
                , { id: 'bizPrftProY',      ctrlId: 'bizPrftProY',      value: 'value' }
                , { id: 'bizPrftProY1',     ctrlId: 'bizPrftProY1',     value: 'value' }
                , { id: 'bizPrftProY2',     ctrlId: 'bizPrftProY2',     value: 'value' }
                , { id: 'bizPrftProY3',     ctrlId: 'bizPrftProY3',     value: 'value' }
                , { id: 'bizPrftProY4',     ctrlId: 'bizPrftProY4',     value: 'value' }
//                 , { id: 'bizPrftProYAvg',   ctrlId: 'bizPrftProYAvg',   value: 'value' }
//                 , { id: 'nprodSalsPlnY',    ctrlId: 'nprodSalsPlnY',    value: 'value' }
//                 , { id: 'nprodSalsPlnY1',   ctrlId: 'nprodSalsPlnY1',   value: 'value' }
//                 , { id: 'nprodSalsPlnY2',   ctrlId: 'nprodSalsPlnY2',   value: 'value' }
//                 , { id: 'nprodSalsPlnY3',   ctrlId: 'nprodSalsPlnY3',   value: 'value' }
//                 , { id: 'nprodSalsPlnY4',   ctrlId: 'nprodSalsPlnY4',   value: 'value' }
//                 , { id: 'nprodSalsPlnYAvg', ctrlId: 'nprodSalsPlnYAvg', value: 'value' }
                , { id: 'ptcCpsnY',         ctrlId: 'ptcCpsnY',         value: 'value' }
                , { id: 'ptcCpsnY1',        ctrlId: 'ptcCpsnY1',        value: 'value' }
                , { id: 'ptcCpsnY2',        ctrlId: 'ptcCpsnY2',        value: 'value' }
                , { id: 'ptcCpsnY3',        ctrlId: 'ptcCpsnY3',        value: 'value' }
                , { id: 'ptcCpsnY4',        ctrlId: 'ptcCpsnY4',        value: 'value' }
                , { id: 'pmisTxt',       	ctrlId: 'pmisTxt',       	value: 'value' }
//                 , { id: 'ptcCpsnYAvg',      ctrlId: 'ptcCpsnYAvg',      value: 'value' }
                , { id: 'userId',           ctrlId: 'userId',           value: 'value' }
                , { id: 'attcFilId',        ctrlId: 'attcFilId',        value: 'value' }
            ]
        });


        //유효성
        vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'tssCd',             validExp: '과제코드:false' }
                , { id: 'smryNTxt',          validExp: 'Needs:false' }
                , { id: 'smryATxt',          validExp: 'Approach:false' }
                , { id: 'smryBTxt',          validExp: 'Benefit:false' }
                , { id: 'smryCTxt',          validExp: 'Competition:false' }
                , { id: 'smryDTxt',          validExp: 'Deliverables:false' }
                , { id: 'mrktSclTxt',        validExp: '시장규모:true' }
                , { id: 'ctyOtPlnM',         validExp: '상품출시(계획):true' }
                , { id: 'smrSmryTxt',        validExp: 'Summary 개요:true' }
                , { id: 'smrGoalTxt',        validExp: 'Summary 목표:true' }
//                 , { id: 'bizPrftProY',       validExp: '영업이익율Y:true:minNumber=0.01' }
//                 , { id: 'bizPrftProY1',      validExp: '영업이익율Y+1:true' }
//                 , { id: 'bizPrftProY2',      validExp: '영업이익율Y+2:true' }
//                 , { id: 'bizPrftProY3',      validExp: '영업이익율Y+3:true' }
//                 , { id: 'bizPrftProY4',      validExp: '영업이익율Y+4:true' }
//                 , { id: 'bizPrftProYAvg',    validExp: '영업이익율평균:false' }
//                 , { id: 'nprodSalsPlnY',     validExp: '신제품매출계획Y:true:minNumber=1' }
//                 , { id: 'nprodSalsPlnY1',    validExp: '신제품매출계획Y+1:true' }
//                 , { id: 'nprodSalsPlnY2',    validExp: '신제품매출계획Y+2:true' }
//                 , { id: 'nprodSalsPlnY3',    validExp: '신제품매출계획Y+3:true' }
//                 , { id: 'nprodSalsPlnY4',    validExp: '신제품매출계획Y+4:true' }
//                 , { id: 'nprodSalsPlnYAvg',  validExp: '신제품매출계획평균:false' }
//                 , { id: 'ptcCpsnY',          validExp: '투입인원(M/M)Y:true:minNumber=1' }
//                 , { id: 'ptcCpsnY1',         validExp: '투입인원(M/M)Y+1:true' }
//                 , { id: 'ptcCpsnY2',         validExp: '투입인원(M/M)Y+2:true' }
//                 , { id: 'ptcCpsnY3',         validExp: '투입인원(M/M)Y+3:true' }
//                 , { id: 'ptcCpsnY4',         validExp: '투입인원(M/M)Y+4:true' }
//                 , { id: 'ptcCpsnYAvg',       validExp: '투입인원(M/M)평균:false' }
                , { id: 'attcFilId',         validExp: 'GRS심의파일:true' }
                , { id: 'userId',            validExp: '로그인ID:false' }
            ]
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //Report
        var btnReport = new Rui.ui.LButton('btnReport');
        btnReport.on('click', function() {
            var tssStrtDd  = lvTssStrtDd.substring(0, 4);
            var url= "<%=lghausysReportPath%>/genSmryReportPopup.jsp?reportMode=HTML&clientURIEncoding=UTF-8"
                     +"&reportParams=skip_decimal_point:true&menu=old&tss_cd="+lvTssCd+"&year="+tssStrtDd;

            var w = window.open(url , 'reportPopup' , 'width=1180 height=900');
        });

        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            var frm = document.smryForm;
            frm.smryNTxt.value =  fnEditorGetMimeValue(frm.Wec0.isDirty(),frm.Wec0,'');
            frm.smryATxt.value =  fnEditorGetMimeValue(frm.Wec1.isDirty(),frm.Wec1,'');
            frm.smryBTxt.value =  fnEditorGetMimeValue(frm.Wec2.isDirty(),frm.Wec2,'');
            frm.smryCTxt.value =  fnEditorGetMimeValue(frm.Wec3.isDirty(),frm.Wec3,'');
            frm.smryDTxt.value =  fnEditorGetMimeValue(frm.Wec4.isDirty(),frm.Wec4,'');
            
            fncEditor();
            dataSet.setNameValue(0, "nprodSalsPlnY" , Math.round(nprodSalsPlnY.getValue()  * 100000000));
            dataSet.setNameValue(0, "nprodSalsPlnY1", Math.round(nprodSalsPlnY1.getValue() * 100000000));
            dataSet.setNameValue(0, "nprodSalsPlnY2", Math.round(nprodSalsPlnY2.getValue() * 100000000));
            dataSet.setNameValue(0, "nprodSalsPlnY3", Math.round(nprodSalsPlnY3.getValue() * 100000000));
            dataSet.setNameValue(0, "nprodSalsPlnY4", Math.round(nprodSalsPlnY4.getValue() * 100000000));

            window.parent.fnSave();
        });
        
        fncEditor = function(){
        	var frm = document.smryForm;
        	
        	frm.Wec0.CleanupOptions = "msoffice | empty | comment";
        	frm.Wec1.CleanupOptions = "msoffice | empty | comment";
        	frm.Wec2.CleanupOptions = "msoffice | empty | comment";
        	frm.Wec3.CleanupOptions = "msoffice | empty | comment";
        	frm.Wec4.CleanupOptions = "msoffice | empty | comment";
    		
        	frm.Wec0.value =frm.Wec0.CleanupHtml(frm.Wec0.value);
        	frm.Wec1.value =frm.Wec1.CleanupHtml(frm.Wec1.value);
        	frm.Wec2.value =frm.Wec2.CleanupHtml(frm.Wec2.value);
        	frm.Wec3.value =frm.Wec3.CleanupHtml(frm.Wec3.value);
        	frm.Wec4.value =frm.Wec4.CleanupHtml(frm.Wec4.value);
        	
        	var jsonString = JSON.stringify(${result});
            var obj = jQuery.parseJSON(jsonString);

            var needs        = fnEditorGetMimeValue(document.smryForm.Wec0.isDirty(),document.smryForm.Wec0,'body');
            var approach     = fnEditorGetMimeValue(document.smryForm.Wec1.isDirty(),document.smryForm.Wec1,'body');
            var benefit      = fnEditorGetMimeValue(document.smryForm.Wec2.isDirty(),document.smryForm.Wec2,'body');
            var competition  = fnEditorGetMimeValue(document.smryForm.Wec3.isDirty(),document.smryForm.Wec3,'body');
            var deliverables = fnEditorGetMimeValue(document.smryForm.Wec4.isDirty(),document.smryForm.Wec4,'body');

            if(lvTssCd !='') {
            	if(  needs == "<P>&nbsp;</P>" || needs == "") {
            		frm.Wec0.value = obj.records[0].smryNTxt;
                }
                if( approach == "<P>&nbsp;</P>"  || approach == "" ) {
                	frm.Wec1.value = obj.records[0].smryATxt;
                }
                if( benefit == "<P>&nbsp;</P>" || benefit == "") {
                	frm.Wec2.value = obj.records[0].smryBTxt;
                }
                if( competition == "<P>&nbsp;</P>" || competition == "") {
                	frm.Wec3.value = obj.records[0].smryCTxt;
                }
                if( deliverables == "<P>&nbsp;</P>" || deliverables == "" ) {
                	frm.Wec4.value = obj.records[0].smryDTxt;
                }
            	
	        	frm.smryNTxt.value =  frm.Wec0.MIMEValue;
	            frm.smryATxt.value =  frm.Wec1.MIMEValue;
	            frm.smryBTxt.value =  frm.Wec2.MIMEValue;
	            frm.smryCTxt.value =  frm.Wec3.MIMEValue;
	            frm.smryDTxt.value =  frm.Wec4.MIMEValue;
            }
        }

        //첨부파일 조회
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
            attachFileDataSet.load({
                url: "<c:url value='/system/attach/getAttachFileList.do'/>" ,
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

        //첨부파일 등록 팝업
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
            }

            initFrameSetHeight("smryFormDiv");
        };

        downloadAttachFile = function(attcFilId, seq) {
            smryForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            smryForm.submit();
        };


        tabViewS = new Rui.ui.tab.LTabView({
            contentHeight: 200,
            tabs: [
                {
                    label: 'Needs',
                    content: ''
                }, {
                    label: 'Approach',
                    content: ''
                }, {
                    label: 'Benefit',
                    content: ''
                }, {
                    label: 'Competition',
                    content: ''
                }, {
                    label: 'Deliverables ',
                    content: ''
                }
            ]
        });

        tabViewS.on('activeTabChange', function(e){
            var index = e.activeIndex;
            fnDisplyNone();
            $("#Wec"+index).ready(function(){
                fnDisplyBlock(index);
                console.log("Loading completed.");
                if(e.isFirst) {
                    if(index == 0) {
                        initFrameSetHeight("smryFormDiv");

                        setTimeout(function () {
                            fnSetDataEditor(index);
                            }, 1000);
                    } else {
                        fnSetDataEditor(index);
                    }
                }
            });
        });

        /** ============================================= Editor ================================================================================= **/
        // 에디터 값 세팅
        fnSetDataEditor = function(val){
            var jsonString = JSON.stringify(${result});
            var obj = jQuery.parseJSON(jsonString);
            var Wec = eval("document.smryForm.Wec"+val);

            var frm = document.smryForm;
            Wec.BodyValue  =  Wec.value ;
            var txt  ="";

            if(lvTssCd !='') {
                txt = obj.records[0].smryNTxt;
                if(val==0){
                    txt  = obj.records[0].smryNTxt;
                }else if(val==1){
                    txt  = obj.records[0].smryATxt;
                }else if(val==2){
                    txt  = obj.records[0].smryBTxt;
                }else if(val==3){
                    txt  = obj.records[0].smryCTxt;
                }else if(val==4){
                    txt  = obj.records[0].smryDTxt;
                }
            }
            Wec.BodyValue = txt;
            Wec.setDirty(false);    // 변경상태 초기화처리
        }

        //editor 설정
        fnDisplyBlock= function(val){
            document.getElementById('divWec'+val).style.display = 'block';
        }
        // tab 별 editor visited
        fnDisplyNone = function(){
            document.getElementById('divWec0').style.display = 'none';
            document.getElementById('divWec1').style.display = 'none';
            document.getElementById('divWec2').style.display = 'none';
            document.getElementById('divWec3').style.display = 'none';
            document.getElementById('divWec4').style.display = 'none';
        }
        // 에디터변경여부
        fnEditorIsUpdate = function(){
            isUpdate = false;
            var Wec0 = document.smryForm.Wec0;
            var Wec1 = document.smryForm.Wec1;
            var Wec2 = document.smryForm.Wec2;
            var Wec3 = document.smryForm.Wec3;
            var Wec4 = document.smryForm.Wec4;

            if( (Wec0 != null && Wec0.IsDirty() == 1) || (Wec1 != null && Wec1.IsDirty() == 1) || (Wec2 != null && Wec2.IsDirty() == 1) ||
                (Wec3 != null && Wec3.IsDirty() == 1) || (Wec4 != null && Wec4.IsDirty() == 1) ){

                isUpdate = true;
            }
            return isUpdate;
        }
        /* 에디터값 가져오기(변경상태 유지) type(body, mime) */
        fnEditorGetMimeValue = function(beforeDirty,editor,type){

            var returnValue = editor.MIMEValue;
            if(type == 'body'){ returnValue = editor.BodyValue; }

            editor.setDirty(beforeDirty);
            return returnValue;
        }
        // 에디터 생성
        createNamoEdit('Wec0', '100%', 400, 'divWec0');
        createNamoEdit('Wec1', '100%', 400, 'divWec1');
        createNamoEdit('Wec2', '100%', 400, 'divWec2');
        createNamoEdit('Wec3', '100%', 400, 'divWec3');
        createNamoEdit('Wec4', '100%', 400, 'divWec4');
        /** ===============================================  Editor End ==================================================================================== **/

        tabViewS.render('tabViewS');

        //최초 데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet.loadData(${result});

        } else {
            console.log("smry searchData2");
            dataSet.newRecord();
            tabViewS.selectTab(0);
        }

        //버튼 비활성화 셋팅

        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
		}
//         $("#Wec0").ready(function() {
//             tabViewS.selectTab(0);
//         });
    });

    //평균구하기
    function fnGetYAvg(gbn) {
        var y  = 0;
        var y1 = 0;
        var y2 = 0;
        var y3 = 0;
        var y4 = 0;
        var cnt = 0;

        var yAvg = 0;

        if(gbn == "nprod") {
            y  = nprodSalsPlnY.getValue();
            y1 = nprodSalsPlnY1.getValue();
            y2 = nprodSalsPlnY2.getValue();
            y3 = nprodSalsPlnY3.getValue();
            y4 = nprodSalsPlnY4.getValue();

            if(y > 0) cnt++;
            if(y1 > 0) cnt++;
            if(y2 > 0) cnt++;
            if(y3 > 0) cnt++;
            if(y4 > 0) cnt++;

            if(cnt == 0) cnt++;

            yAvg = (y + y1 + y2 + y3 + y4) / cnt;

            nprodSalsPlnYAvg.setValue(yAvg);
        }
        else if(gbn == "ptc") {
            y  = ptcCpsnY.getValue();
            y1 = ptcCpsnY1.getValue();
            y2 = ptcCpsnY2.getValue();
            y3 = ptcCpsnY3.getValue();
            y4 = ptcCpsnY4.getValue();

            if(y > 0) cnt++;
            if(y1 > 0) cnt++;
            if(y2 > 0) cnt++;
            if(y3 > 0) cnt++;
            if(y4 > 0) cnt++;

            if(cnt == 0) cnt++;

            yAvg = (y + y1 + y2 + y3 + y4) / cnt;

            ptcCpsnYAvg.setValue(yAvg.toFixed(2));
        }
        else if(gbn == "biz") {
            y  = bizPrftProY.getValue();
            y1 = bizPrftProY1.getValue();
            y2 = bizPrftProY2.getValue();
            y3 = bizPrftProY3.getValue();
            y4 = bizPrftProY4.getValue();

            if(y > 0) cnt++;
            if(y1 > 0) cnt++;
            if(y2 > 0) cnt++;
            if(y3 > 0) cnt++;
            if(y4 > 0) cnt++;

            if(cnt == 0) cnt++;

            yAvg = (y + y1 + y2 + y3 + y4) / cnt;

            bizPrftProYAvg.setValue(yAvg);
        }
    }


    //validation
    function fnIfmIsUpdate(gbn) {
        if(!vm.validateGroup("smryForm")) {
            alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
            return false;
        }

        // 에디터 validation 체크
        var needs        = fnEditorGetMimeValue(document.smryForm.Wec0.isDirty(),document.smryForm.Wec0,'body');
        var approach     = fnEditorGetMimeValue(document.smryForm.Wec1.isDirty(),document.smryForm.Wec1,'body');
        var benefit      = fnEditorGetMimeValue(document.smryForm.Wec2.isDirty(),document.smryForm.Wec2,'body');
        var competition  = fnEditorGetMimeValue(document.smryForm.Wec3.isDirty(),document.smryForm.Wec3,'body');
        var deliverables = fnEditorGetMimeValue(document.smryForm.Wec4.isDirty(),document.smryForm.Wec4,'body');

        var needsEditorMod        = document.smryForm.Wec0.isDirty();
        var approachEditorMod     = document.smryForm.Wec1.isDirty();
        var benefitEditorMod      = document.smryForm.Wec2.isDirty();
        var competitionEditorMod  = document.smryForm.Wec3.isDirty();
        var deliverablesEditorMod = document.smryForm.Wec4.isDirty();

        if(  needs == "<P>&nbsp;</P>" || needs == "") {
            alert("Needs 는 필수입력입니다.");
            return false;
        }
        if( approach == "<P>&nbsp;</P>"  || approach == "" ) {
            alert("Approach 는 필수입력입니다.");
            return false;
        }
        if( benefit == "<P>&nbsp;</P>" || benefit == "") {
            alert("Benefit 은 필수입력입니다.");
            return false;
        }
        if( competition == "<P>&nbsp;</P>" || competition == "") {
            alert("Competition 은 필수입력입니다.");
            return false;
        }
        if( deliverables == "<P>&nbsp;</P>" || deliverables == "" ) {
            alert("Deliverables 는 필수입력입니다.");
            return false;
        }

        if(gbn != "SAVE" && dataSet.isUpdated()) {
            alert("개요탭 저장을 먼저 해주시기 바랍니다.");
            return false;
        }

        var y= bizPrftProY.getValue();
        var y1 = bizPrftProY1.getValue();
        var y2 = bizPrftProY2.getValue();
        var y3 = bizPrftProY3.getValue();
        var y4 = bizPrftProY4.getValue();
        if(y + y1+ y2+ y3+ y4 <= 0) {
            alert("영업이익율(%)은 필수입력입니다.");
            return false;
        }

        var y  = nprodSalsPlnY.getValue();
        var y1 = nprodSalsPlnY1.getValue();
        var y2 = nprodSalsPlnY2.getValue();
        var y3 = nprodSalsPlnY3.getValue();
        var y4 = nprodSalsPlnY4.getValue();
        if(y + y1+ y2+ y3+ y4 <= 0) {
            alert("신제품 매출계획은 필수입력입니다.");
            return false;
        }

        var y  = ptcCpsnY.getValue();
        var y1 = ptcCpsnY1.getValue();
        var y2 = ptcCpsnY2.getValue();
        var y3 = ptcCpsnY3.getValue();
        var y4 = ptcCpsnY4.getValue();
        if(y + y1+ y2+ y3+ y4 <= 0) {
            alert("투입인원(M/M)은 필수입력입니다.");
            return false;
        }

        return true;
    }
    
    function fncPtcCpsnYDisable(sDt, eDt){
    	var arr1 = sDt.split("-"); 
        var arr2 = eDt.split("-"); 
        
        var diffCnt = (Number(arr2[0]) - Number(arr1[0])) + 1;
        
        if( diffCnt == 1 ){
        	ptcCpsnY1.setValue(0);		
        	ptcCpsnY2.setValue(0);		
        	ptcCpsnY3.setValue(0);		
        	ptcCpsnY4.setValue(0);		

        	ptcCpsnY1.disable();		
        	ptcCpsnY2.disable();		
        	ptcCpsnY3.disable();		
        	ptcCpsnY4.disable();		
        }else if( diffCnt == 2 ){
        	ptcCpsnY2.setValue(0);		
        	ptcCpsnY3.setValue(0);		
        	ptcCpsnY4.setValue(0);		

        	ptcCpsnY1.enable();	
        	
        	ptcCpsnY2.disable();		
        	ptcCpsnY3.disable();		
        	ptcCpsnY4.disable();		
        }else if( diffCnt == 3 ){
        	ptcCpsnY3.setValue(0);		
        	ptcCpsnY4.setValue(0);		

        	ptcCpsnY1.enable();		
        	ptcCpsnY2.enable();		
        	
        	ptcCpsnY3.disable();		
        	ptcCpsnY4.disable();		
        }else if( diffCnt == 4 ){
        	ptcCpsnY4.setValue(0);
        	
        	ptcCpsnY1.enable();		
        	ptcCpsnY2.enable();		
        	ptcCpsnY3.enable();	
        	
        	ptcCpsnY4.disable();		
        }
    }
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("smryFormDiv");
});
</script>
</head>
<body>
<div id="smryFormDiv">
    <form name="smryForm" id="smryForm" method="post" style="padding: 20px 1px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        <input type="hidden" id="attcFilId" name="attcFilId" value=""/>

        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 16%;" />
                <col style="width: 14%;" />
                <col style="width: 14%;" />
                <col style="width: 14%;" />
                <col style="width: 14%;" />
                <col style="width: 14%;" />
                <col style="width: 14%;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">Summary 개요</th>
                    <td colspan="6"><input type="text" id="smrSmryTxt" name="smrSmryTxt"  ></td>
                </tr>
                <tr>
                    <th align="right">Summary 목표</th>
                    <td colspan="6"><input type="text" id="smrGoalTxt" name="smrGoalTxt"  ></td>
                </tr>
                <tr>
                    <th align="right" rowspan="2">개요 상세</th>
                    <td colspan="6">
                        <div id="tabViewS"></div>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">

                        <input type="hidden" id="smryNTxt" name="smryNTxt" >
                        <input type="hidden" id="smryATxt" name="smryATxt" >
                        <input type="hidden" id="smryBTxt" name="smryBTxt" >
                        <input type="hidden" id="smryCTxt" name="smryCTxt" >
                        <input type="hidden" id="smryDTxt" name="smryDTxt" >
                        <div id="divWec0"></div>
                        <div id="divWec1"></div>
                        <div id="divWec2"></div>
                        <div id="divWec3"></div>
                        <div id="divWec4"></div>
                    </td>
                </tr>
                <tr>
                    <th align="right">시장규모</th>
                    <td colspan="6"><input type="text" id="mrktSclTxt" name="mrktSclTxt"></td>
                </tr>
                <tr>
                    <th align="right">상품출시(계획)</th>
                    <td colspan="6"><input type="text" id="ctyOtPlnM" /></td>
                </tr>
                <tr>
                    <th rowspan="2">영업이익율(%)</th>
                    <th class="alignC">출시년도</th>
                    <th class="alignC">출시년도+1</th>
                    <th class="alignC">출시년도+2</th>
                    <th class="alignC">출시년도+3</th>
                    <th class="alignC">출시년도+4</th>
                    <th class="alignC">평균</th>
                </tr>
                <tr>
                    <td><input type="text" id="bizPrftProY" name="bizPrftProY"></td>
                    <td><input type="text" id="bizPrftProY1" name="bizPrftProY1"></td>
                    <td><input type="text" id="bizPrftProY2" name="bizPrftProY2"></td>
                    <td><input type="text" id="bizPrftProY3" name="bizPrftProY3"></td>
                    <td><input type="text" id="bizPrftProY4" name="bizPrftProY4"></td>
                    <td><input type="text" id="bizPrftProYAvg" name="bizPrftProYAvg"></td>
                </tr>
                <tr>
                    <th rowspan="2">신제품 매출계획(단위:억원)</th>
                    <th class="alignC">출시년도</th>
                    <th class="alignC">출시년도+1</th>
                    <th class="alignC">출시년도+2</th>
                    <th class="alignC">출시년도+3</th>
                    <th class="alignC">출시년도+4</th>
                    <th class="alignC">평균</th>
                </tr>
                <tr>
                    <td><input type="text" id="nprodSalsPlnY" name="nprodSalsPlnY"></td>
                    <td><input type="text" id="nprodSalsPlnY1" name="nprodSalsPlnY1"></td>
                    <td><input type="text" id="nprodSalsPlnY2" name="nprodSalsPlnY2"></td>
                    <td><input type="text" id="nprodSalsPlnY3" name="nprodSalsPlnY3"></td>
                    <td><input type="text" id="nprodSalsPlnY4" name="nprodSalsPlnY4"></td>
                    <td><input type="text" id="nprodSalsPlnYAvg" name="nprodSalsPlnYAvg"></td>
                </tr>
                <tr>
                    <th rowspan="2">투입인원(M/M)</th>
                    <th class="alignC">Y<br/>(과제 시작 년도)</th>
                    <th class="alignC">Y+1</th>
                    <th class="alignC">Y+2</th>
                    <th class="alignC">Y+3</th>
                    <th class="alignC">Y+4</th>
                    <th class="alignC">평균</th>
                </tr>
                <tr>
                    <td><input type="text" id="ptcCpsnY" name="ptcCpsnY"></td>
                    <td><input type="text" id="ptcCpsnY1" name="ptcCpsnY1"></td>
                    <td><input type="text" id="ptcCpsnY2" name="ptcCpsnY2"></td>
                    <td><input type="text" id="ptcCpsnY3" name="ptcCpsnY3"></td>
                    <td><input type="text" id="ptcCpsnY4" name="ptcCpsnY4"></td>
                    <td><input type="text" id="ptcCpsnYAvg" name="ptcCpsnYAvg"></td>
                </tr>
                <tr>
                    <th align="right">지적재산권<br>통보결과</th>
                    <td colspan="6"><input type="text" id="pmisTxt" name="pmisTxt"></td>
                </tr>
                <tr>
                    <th align="right">GRS심의파일<br/>(심의파일, 회의록 필수 첨부)</th>
                    <td colspan="5" id="attchFileView">&nbsp;</td>
                    <td colspan="1"><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
    <div class="titArea">
        <div class="LblockButton">
            <button type="button" id="btnReport" name="btnReport">Report</button>
            <button type="button" id="btnSave" name="btnSave">저장</button>
            <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
        </div>
    </div>
</div>
</body>
</html>