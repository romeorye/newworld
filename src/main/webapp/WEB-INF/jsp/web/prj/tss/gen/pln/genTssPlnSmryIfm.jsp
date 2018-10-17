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
    var pageMode = (lvTssSt == "100" || lvTssSt == "" || lvTssSt == "302") && (lvPageMode == "W" || lvPageMode == "") ? "W" : "R";

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
            width: 1100
        });

        //요약개요
        smrSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrSmryTxt',
            height: 100,
            width: 1100
        });

        //요약목표
        smrGoalTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrGoalTxt',
            height: 100,
            width: 1100
        });
       
        //지적재산권 통보
        pmisTxt = new Rui.ui.form.LTextArea({
            applyTo: 'pmisTxt',
            height: 100,
            width: 1100
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

            //NaN인경우
            dsNprodSalsPlnY  = $.isNumeric( dsNprodSalsPlnY1 )?dsNprodSalsPlnY:0;
            dsNprodSalsPlnY1 = $.isNumeric( dsNprodSalsPlnY1 )?dsNprodSalsPlnY1:0;
            dsNprodSalsPlnY2 = $.isNumeric( dsNprodSalsPlnY1 )?dsNprodSalsPlnY2:0;
            dsNprodSalsPlnY3 = $.isNumeric( dsNprodSalsPlnY1 )?dsNprodSalsPlnY3:0;
            dsNprodSalsPlnY4 = $.isNumeric( dsNprodSalsPlnY1 )?dsNprodSalsPlnY4:0;

            nprodSalsPlnY.setValue(dsNprodSalsPlnY);
            nprodSalsPlnY1.setValue(dsNprodSalsPlnY1);
            nprodSalsPlnY2.setValue(dsNprodSalsPlnY2);
            nprodSalsPlnY3.setValue(dsNprodSalsPlnY3);
            nprodSalsPlnY4.setValue(dsNprodSalsPlnY4);

            Wec0.SetBodyValue( dataSet.getNameValue(0, "smryNTxt") );
            Wec1.SetBodyValue( dataSet.getNameValue(0, "smryATxt") );
            Wec2.SetBodyValue( dataSet.getNameValue(0, "smryBTxt") );
            Wec3.SetBodyValue( dataSet.getNameValue(0, "smryCTxt") );
            Wec4.SetBodyValue( dataSet.getNameValue(0, "smryDTxt") );

	        fncPtcCpsnYDisable(strDt, endDt);
            fnGetYAvg("ptc");
            fnGetYAvg("biz");
            tabViewS.selectTab(0);

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

            dataSet.setNameValue(0, "smryNTxt", Wec0.GetBodyValue());
            dataSet.setNameValue(0, "smryATxt", Wec1.GetBodyValue());
            dataSet.setNameValue(0, "smryBTxt", Wec2.GetBodyValue());
            dataSet.setNameValue(0, "smryCTxt", Wec3.GetBodyValue());
            dataSet.setNameValue(0, "smryDTxt", Wec4.GetBodyValue());
            
            if(  dataSet.getNameValue(0, "smryNTxt") == "<p><br></p>" ||  dataSet.getNameValue(0, "smryNTxt")  == "") {
            	alert("Needs를 입력하세요");
            	return;
            }
            if(  dataSet.getNameValue(0, "smryATxt") == "<p><br></p>"  ||  dataSet.getNameValue(0, "smryATxt") == "" ) {
            	alert("Approach를 입력하세요");
            	return;
            }
            if(  dataSet.getNameValue(0, "smryBTxt")  == "<p><br></p>" ||  dataSet.getNameValue(0, "smryBTxt") == "") {
            	alert("Benefit를 입력하세요");
            	return;
            }
            if(  dataSet.getNameValue(0, "smryCTxt") == "<p><br></p>" ||  dataSet.getNameValue(0, "smryCTxt") == "") {
            	alert("Competition를 입력하세요");
            	return;
            }
            if(  dataSet.getNameValue(0, "smryDTxt") == "<p><br></p>" ||  dataSet.getNameValue(0, "smryDTxt") == "" ) {
            	alert("Deliverables를 입력하세요");
            	return;
            }
            
            dataSet.setNameValue(0, "nprodSalsPlnY" , Math.round(nprodSalsPlnY.getValue()  * 100000000));
            dataSet.setNameValue(0, "nprodSalsPlnY1", Math.round(nprodSalsPlnY1.getValue() * 100000000));
            dataSet.setNameValue(0, "nprodSalsPlnY2", Math.round(nprodSalsPlnY2.getValue() * 100000000));
            dataSet.setNameValue(0, "nprodSalsPlnY3", Math.round(nprodSalsPlnY3.getValue() * 100000000));
            dataSet.setNameValue(0, "nprodSalsPlnY4", Math.round(nprodSalsPlnY4.getValue() * 100000000));

            window.parent.fnSave();
        });
        
        

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
            
        	if( index == 0 ){
	    		document.getElementById("divWec0").style.display = "block";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "none";	
	    		document.getElementById("divWec3").style.display = "none";	
	    		document.getElementById("divWec4").style.display = "none";	
	    	
	    	}else if( index == 1 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "block";	
	    		document.getElementById("divWec2").style.display = "none";
	    		document.getElementById("divWec3").style.display = "none";	
	    		document.getElementById("divWec4").style.display = "none";
	    	}else if( index == 2 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "block";	
	    		document.getElementById("divWec3").style.display = "none";	
	    		document.getElementById("divWec4").style.display = "none";
	    	}else if( index == 3 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "none";	
	    		document.getElementById("divWec3").style.display = "block";	
	    		document.getElementById("divWec4").style.display = "none";
	    	}else if( index == 4 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "none";	
	    		document.getElementById("divWec3").style.display = "none";	
	    		document.getElementById("divWec4").style.display = "block";
	    	}
        });
	
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


        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
		}

		
		console.log(">>>>>>>>>>>>>>>>>>>>>>>>isE",window.parent.isEditable);
        if(window.parent.isEditable){
            btnSave.show();
            $("#btnSave").show();
        }else{
            disableFields();
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
        var defaultValue = 0;
        
        	ptcCpsnY.setValue(defaultValue);		
        if( diffCnt == 1 ){
        	ptcCpsnY1.setValue(defaultValue);		
        	ptcCpsnY2.setValue(defaultValue);		
        	ptcCpsnY3.setValue(defaultValue);		
        	ptcCpsnY4.setValue(defaultValue);		

        	ptcCpsnY1.disable();		
        	ptcCpsnY2.disable();		
        	ptcCpsnY3.disable();		
        	ptcCpsnY4.disable();		
        }else if( diffCnt == 2 ){
        	ptcCpsnY2.setValue(defaultValue);		
        	ptcCpsnY3.setValue(defaultValue);		
        	ptcCpsnY4.setValue(defaultValue);		

        	ptcCpsnY1.enable();	
        	
        	ptcCpsnY2.disable();		
        	ptcCpsnY3.disable();		
        	ptcCpsnY4.disable();		
        }else if( diffCnt == 3 ){
        	ptcCpsnY3.setValue(defaultValue);		
        	ptcCpsnY4.setValue(defaultValue);		

        	ptcCpsnY1.enable();		
        	ptcCpsnY2.enable();		
        	
        	ptcCpsnY3.disable();		
        	ptcCpsnY4.disable();		
        }else if( diffCnt == 4 ){
        	ptcCpsnY4.setValue(defaultValue);
        	
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
<body style="overflow: hidden">
<div id="smryFormDiv">
    <form name="smryForm" id="smryForm" method="post" style="padding: 10px 1px 0 0;">
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
                        <div id="divWec0">
                            <textarea id="smryNTxt" name="smryNTxt"></textarea>
                            <script>
                                Wec0 = new NamoSE('smryNTxt');
                                Wec0.params.Width = "100%";
                                Wec0.params.UserLang = "auto";
                                uploadPath = "<%=uploadPath%>";
                                Wec0.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec0.params.FullScreen = false;
                                Wec0.EditorStart();
                            </script>
                        </div>
                        <div id="divWec1"  style="display:none">
                            <textarea id="smryATxt" name="smryATxt"></textarea>
                            <script>
                                Wec1 = new NamoSE('smryATxt');
                                Wec1.params.Width = "100%";
                                Wec1.params.UserLang = "auto";
                                uploadPath = "<%=uploadPath%>";
                                Wec1.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec1.params.FullScreen = false;
                                Wec1.EditorStart();

                            </script>
                        </div>
                        <div id="divWec2"  style="display:none">
                            <textarea id="smryBTxt" name="smryBTxt"></textarea>
                            <script>
                                Wec2 = new NamoSE('smryBTxt');
                                Wec2.params.Width = "100%";
                                Wec2.params.UserLang = "auto";
                                uploadPath = "<%=uploadPath%>";
                                Wec2.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec2.params.FullScreen = false;
                                Wec2.EditorStart();
                            </script>
                        </div>
                        <div id="divWec3"  style="display:none">
                            <textarea id="smryCTxt" name="smryCTxt"></textarea>
                            <script>
                                Wec3 = new NamoSE('smryCTxt');
                                Wec3.params.Width = "100%";
                                Wec3.params.UserLang = "auto";
                                uploadPath = "<%=uploadPath%>";
                                Wec3.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec3.params.FullScreen = false;
                                Wec3.EditorStart();
                            </script>
                        </div>
                        <div id="divWec4"  style="display:none">
                            <textarea id="smryDTxt" name="smryDTxt"></textarea>
                            <script>
                                Wec4 = new NamoSE('smryDTxt');
                                Wec4.params.Width = "100%";
                                Wec4.params.UserLang = "auto";
                                uploadPath = "<%=uploadPath%>";
                                Wec4.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec4.params.FullScreen = false;
                                Wec4.EditorStart();

                            </script>
                        </div>
                        <script type="text/javascript" language="javascript">
                            function OnInitCompleted(e){
                                e.editorTarget.SetBodyValue(document.getElementById("divWec0").value);
                                e.editorTarget.SetBodyValue(document.getElementById("divWec1").value);
                                e.editorTarget.SetBodyValue(document.getElementById("divWec2").value);
                                e.editorTarget.SetBodyValue(document.getElementById("divWec3").value);
                                e.editorTarget.SetBodyValue(document.getElementById("divWec4").value);
                            }
                        </script>                        
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
                    <th align="right">지적재산팀 검토의견</th>
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
    <div class="titArea btn_btm">
        <div class="LblockButton">
            <button type="button" id="btnReport" name="btnReport">Report</button>
            <button type="button" id="btnSave" name="btnSave">저장</button>
            <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
        </div>
    </div>
</div>
</body>
</html>