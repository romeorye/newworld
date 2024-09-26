<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssCmplIfm.jsp
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

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>
<style>
 .L-tssLable {
 border: 0px
 }
</style>

<script type="text/javascript">
    var lvTssCd     = window.parent.cmplTssCd;
    var lvUserId    = window.parent.gvUserId;
    var lvTssSt     = window.parent.gvTssSt;
    var lvPgsStepCd = window.parent.gvPgsStepCd;
    var lvPageMode  = window.parent.gvPageMode;
    
    var lvInitFlowYn = (window.parent.initFlowYn) ? window.parent.initFlowYn : ""; //초기유동관리여부
    var lvInitFlowStrtDt = (window.parent.initFlowStrtDt) ? window.parent.initFlowStrtDt : ""; //초기유동관리시작일
    var lvInitFlowFnhDt = (window.parent.initFlowFnhDt) ? window.parent.initFlowFnhDt : ""; //초기유동관리종료일

    var tmpInitFlowStrtDt = (window.parent.tmpInitFlowStrtDt) ? window.parent.tmpInitFlowStrtDt : "";
    var tmpInitFlowFnhDt =  (window.parent.tmpInitFlowFnhDt) ? window.parent.tmpInitFlowFnhDt : "";
    
    console.log("[lvTssCd]", lvTssCd);
    console.log("[lvUserId]", lvUserId);
    console.log("[lvTssSt]", lvTssSt);
    console.log("[lvPgsStepCd]", lvPgsStepCd);
    console.log("[lvPageMode]", lvPageMode);

    console.log("[lvInitFlowYn]", lvInitFlowYn);
    console.log("[lvInitFlowStrtDt]", lvInitFlowStrtDt);
    console.log("[lvInitFlowFnhDt]", lvInitFlowFnhDt);

    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    var dataSet;
    var lvAttcFilId;
    var tmpAttchFileList;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //과제개요_연구과제배경
        tssSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'tssSmryTxt',
            height: 80,
            width: 600
        });

        //과제개요_주요연구개발내용
        tssSmryDvlpTxt = new Rui.ui.form.LTextArea({
            applyTo: 'tssSmryDvlpTxt',
            height: 80,
            width: 600
        });

        //연구개발성과_지재권
        rsstDvlpOucmTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rsstDvlpOucmTxt',
            height: 80,
            width: 600
        });

        //연구개발성과_CTQ
        rsstDvlpOucmCtqTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rsstDvlpOucmCtqTxt',
            height: 80,
            width: 600
        });

        //연구개발성과_파급효과
        rsstDvlpOucmEffTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rsstDvlpOucmEffTxt',
            height: 80,
            width: 600
        });

        //Qgate3(품질평가단계) 패스일자
        qgate3Dt =  new Rui.ui.form.LDateBox({
            applyTo: 'qgate3Dt',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });

        //사업화출시계획
        fwdPlnTxt = new Rui.ui.form.LTextArea({
            applyTo: 'fwdPlnTxt',
            height: 80,
            width: 600
        });

        //향후 계획
        fnoPlnTxt = new Rui.ui.form.LTextArea({
            applyTo: 'fnoPlnTxt',
            height: 80,
            width: 600
        });

        // 초기유동관리 여부
        var chkInitFlowYn = new Rui.ui.form.LCheckBox({ // 체크박스를 생성
            applyTo: 'chkInitFlowYn',
            checked : true,
            value : "Y"
        });
        
        //초기유동관리시작일
        initFlowStrtDt =  new Rui.ui.form.LDateBox({
            applyTo: 'initFlowStrtDt',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        initFlowStrtDt.on('blur', function() {
            if(Rui.isEmpty(initFlowStrtDt.getValue())) return;

            if(!Rui.isEmpty(initFlowFnhDt.getValue())) {
                var startDt = initFlowStrtDt.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = initFlowFnhDt.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    initFlowStrtDt.setValue("");
                    return;
                }
            }
        });
        
        //초기유동관리종료일
        initFlowFnhDt = new Rui.ui.form.LDateBox({
            applyTo: 'initFlowFnhDt',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        initFlowFnhDt.on('blur', function() {
            if(Rui.isEmpty(initFlowFnhDt.getValue())) return;

            if(!Rui.isEmpty(initFlowStrtDt.getValue())) {
                var startDt = initFlowStrtDt.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = initFlowFnhDt.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    initFlowFnhDt.setValue("");
                    return;
                }
            }

        });

        if(lvInitFlowYn == "Y"){
            chkInitFlowYn.setValue(true);
            initFlowStrtDt.enable();
            initFlowFnhDt.enable();
        }else{
            chkInitFlowYn.setValue(false);
            initFlowStrtDt.disable();
            initFlowFnhDt.disable();
        }
        initFlowStrtDt.setValue(lvInitFlowStrtDt); 
        initFlowFnhDt.setValue(lvInitFlowFnhDt); 

        $("input[name=chkInitFlowYn]").click(function(){
        	console.log($("input[name=chkInitFlowYn]").prop("checked"));
      		if($("input[name=chkInitFlowYn]").prop("checked")){
      			initFlowStrtDt.setValue(tmpInitFlowStrtDt);
      			initFlowFnhDt.setValue(tmpInitFlowFnhDt);
                initFlowStrtDt.enable();
                initFlowFnhDt.enable();
      		}else{
      			initFlowStrtDt.setValue("");
      			initFlowFnhDt.setValue("");
                initFlowStrtDt.disable();
                initFlowFnhDt.disable();
      		}
      	});

        //과제개요_주요연구개발내용
        pmisCmplTxt = new Rui.ui.form.LTextArea({
            applyTo: 'pmisCmplTxt',
            height: 80,
            width: 600
        });

        //Form 비활성화
        disableFields = function() {
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');

            if(pageMode == "W") return;

            btnSave.hide();
            
            initFlowAttch.hide(); //초기유동관리 완료보고서 및 기타

            document.getElementById('attchFileMngBtn').style.display = "none";
        };



        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                 { id: 'tssCd'}
                ,{ id: 'tssSmryTxt'}
                ,{ id: 'tssSmryDvlpTxt'}
                ,{ id: 'rsstDvlpOucmTxt'}
                ,{ id: 'rsstDvlpOucmCtqTxt'}
                ,{ id: 'rsstDvlpOucmEffTxt'}
                ,{ id: 'pmisTxt'}
                ,{ id: 'qgate3Dt'}
                ,{ id: 'fwdPlnTxt'}
                ,{ id: 'fnoPlnTxt'}
                ,{ id: 'ancpOtPlnDt'}
                ,{ id: 'cmplAttcFilId'}
                ,{ id: 'initFlowAttcFilId'}
                ,{ id: 'pmisCmplTxt'}
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
                ,{ id: 'nprodSalsPlnY'}
                ,{ id: 'nprodSalsPlnY1', type: 'number'}
                ,{ id: 'nprodSalsPlnY2', type: 'number'}
                ,{ id: 'nprodSalsPlnY3', type: 'number'}
                ,{ id: 'nprodSalsPlnY4', type: 'number'}
                ,{ id: 'nprodSalsCurY'}
                ,{ id: 'nprodSalsCurY1'}
                ,{ id: 'nprodSalsCurY2'}
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
                ,{ id: 'nprodNm'}
                ,{ id: 'userId'}
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");

            lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "cmplAttcFilId"));
            if(lvAttcFilId != "") {
                dataSet.setNameValue(0, 'attcFilId', dataSet.getNameValue(0, "cmplAttcFilId") );
                getAttachFileList();
            }
        });


        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                 { id: 'tssCd',              ctrlId: 'tssCd',              value: 'value' }
                ,{ id: 'userId',             ctrlId: 'userId',             value: 'value' }
                ,{ id: 'tssSmryTxt'        , ctrlId: 'tssSmryTxt'        , value: 'value'}
                ,{ id: 'tssSmryDvlpTxt'    , ctrlId: 'tssSmryDvlpTxt'    , value: 'value'}
                ,{ id: 'rsstDvlpOucmTxt'   , ctrlId: 'rsstDvlpOucmTxt'   , value: 'value'}
                ,{ id: 'rsstDvlpOucmCtqTxt', ctrlId: 'rsstDvlpOucmCtqTxt', value: 'value'}
                ,{ id: 'rsstDvlpOucmEffTxt', ctrlId: 'rsstDvlpOucmEffTxt', value: 'value'}
                ,{ id: 'pmisTxt'           , ctrlId: 'pmisTxt'           , value: 'value'}
                ,{ id: 'qgate3Dt'          , ctrlId: 'qgate3Dt'          , value: 'value'}
                ,{ id: 'fwdPlnTxt'         , ctrlId: 'fwdPlnTxt'         , value: 'value'}
                ,{ id: 'fnoPlnTxt'         , ctrlId: 'fnoPlnTxt'         , value: 'value'}
                ,{ id: 'pmisCmplTxt'       , ctrlId: 'pmisCmplTxt'       , value: 'value'}
                ,{ id: 'nprodNm'           , ctrlId: 'nprodNm'           , value: 'html'}
                ,{ id: 'ancpOtPlnDt'       , ctrlId: 'ancpOtPlnDt'       , value: 'html'}
                ,{ id: 'bizPrftProY'       , ctrlId: 'bizPrftProY'       , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY1'      , ctrlId: 'bizPrftProY1'      , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY2'      , ctrlId: 'bizPrftProY2'      , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY3'      , ctrlId: 'bizPrftProY3'      , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY4'      , ctrlId: 'bizPrftProY4'      , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }

                ,{ id: 'bizPrftProCurY'    , ctrlId: 'bizPrftProCurY'    , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProCurY1'   , ctrlId: 'bizPrftProCurY1'   , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProCurY2'   , ctrlId: 'bizPrftProCurY2'   , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }

                ,{ id: 'bizPrftPlnY'       , ctrlId: 'bizPrftPlnY'       , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftPlnY1'      , ctrlId: 'bizPrftPlnY1'      , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftPlnY2'      , ctrlId: 'bizPrftPlnY2'      , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftCurY'       , ctrlId: 'bizPrftCurY'       , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftCurY1'      , ctrlId: 'bizPrftCurY1'      , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftCurY2'      , ctrlId: 'bizPrftCurY2'      , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY'     , ctrlId: 'nprodSalsPlnY'     , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY1'    , ctrlId: 'nprodSalsPlnY1'    , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY2'    , ctrlId: 'nprodSalsPlnY2'    , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY3'    , ctrlId: 'nprodSalsPlnY3'    , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY4'    , ctrlId: 'nprodSalsPlnY4'    , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsCurY'     , ctrlId: 'nprodSalsCurY'     , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsCurY1'    , ctrlId: 'nprodSalsCurY1'    , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsCurY2'    , ctrlId: 'nprodSalsCurY2'    , value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'ptcCpsnY'          , ctrlId: 'ptcCpsnY'          , value: 'html'}
                ,{ id: 'ptcCpsnY1'         , ctrlId: 'ptcCpsnY1'         , value: 'html'}
                ,{ id: 'ptcCpsnY2'         , ctrlId: 'ptcCpsnY2'         , value: 'html'}
                ,{ id: 'ptcCpsnY3'         , ctrlId: 'ptcCpsnY3'         , value: 'html'}
                ,{ id: 'ptcCpsnY4'         , ctrlId: 'ptcCpsnY4'         , value: 'html'}
                ,{ id: 'ptcCpsnCurY'       , ctrlId: 'ptcCpsnCurY'       , value: 'html'}
                ,{ id: 'ptcCpsnCurY1'      , ctrlId: 'ptcCpsnCurY1'      , value: 'html'}
                ,{ id: 'ptcCpsnCurY2'      , ctrlId: 'ptcCpsnCurY2'      , value: 'html'}
                ,{ id: 'ptcCpsnCurY3'      , ctrlId: 'ptcCpsnCurY3'      , value: 'html'}
                ,{ id: 'ptcCpsnCurY4'      , ctrlId: 'ptcCpsnCurY4'      , value: 'html'}
                ,{ id: 'expArslY'          , ctrlId: 'expArslY'          , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY1'         , ctrlId: 'expArslY1'         , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY2'         , ctrlId: 'expArslY2'         , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY3'         , ctrlId: 'expArslY3'         , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY4'         , ctrlId: 'expArslY4'         , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslCurY'       , ctrlId: 'expArslCurY'       , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslCurY1'      , ctrlId: 'expArslCurY1'      , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslCurY2'      , ctrlId: 'expArslCurY2'      , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslCurY3'      , ctrlId: 'expArslCurY3'      , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslCurY4'      , ctrlId: 'expArslCurY4'      , value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'cmplAttcFilId'     , ctrlId: 'cmplAttcFilId'     , value: 'html'}
            ]
        });

        //유효성 설정
        vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'tssCd',              validExp: '과제코드:false' }
                , { id: 'userId',             validExp: '로그인ID:false' }
                , { id: 'tssSmryTxt',         validExp: '연구과제 배경 및 필요성:true' }
                , { id: 'tssSmryDvlpTxt',     validExp: '주요 연구 개발 내용:true' }
                , { id: 'rsstDvlpOucmTxt',    validExp: '지재권 출원현황:true' }
                , { id: 'pmisCmplTxt',        validExp: '특허 Risk 검토결과 :true' }
                , { id: 'rsstDvlpOucmCtqTxt', validExp: '핵심 CTQ 품질 수준:false' }
                , { id: 'rsstDvlpOucmEffTxt', validExp: '파급효과 및 응용분야:false' }
                , { id: 'fnoPlnTxt',          validExp: '향후 계획:true' }
                , { id: 'qgate3Dt',           validExp: 'Qgate3(품질평가단계) 패스일자:false' }
                , { id: 'fwdPlnTxt',          validExp: '사업화출시계획:true' }
            ]
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
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

        //첨부파일 등록 팝업
        getAttachFileId = function() {
            return stringNullChk(lvAttcFilId);
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
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };

        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            if (fnIfmIsUpdate("SAVE") ){
            	
            	lvInitFlowYn = (stringNullChk(chkInitFlowYn.getValue())=="")?"N":"Y"; 
            	lvInitFlowStrtDt= (lvInitFlowYn=="Y")?initFlowStrtDt.getValue() : ""; 
            	lvInitFlowFnhDt = (lvInitFlowYn=="Y")?initFlowFnhDt.getValue() : "";  
            	
            	window.parent.initFlowYn = lvInitFlowYn; 
            	//window.parent.initFlowStrtDt = lvInitFlowStrtDt; 
            	//window.parent.initFlowFnhDt = lvInitFlowFnhDt;
            	
            	console.log("[lvInitFlowYn]", lvInitFlowYn, "[lvInitFlowStrtDt]", lvInitFlowStrtDt, "[lvInitFlowFnhDt]", lvInitFlowFnhDt);
            	console.log("[$(\"input[name=chkInitFlowYn]\").prop(\"checked\")]", $("input[name=chkInitFlowYn]").prop("checked"));
            	if ($("input[name=chkInitFlowYn]").prop("checked")) {
            		if(Rui.isEmpty(initFlowStrtDt.getValue())) {
            			Rui.alert("초기유동관리 시작일: 필수 입력 항목입니다.");
            			$("#initFlowStrtDt").focus();
            			return false;
            		} else if(Rui.isEmpty(initFlowFnhDt.getValue())) {
            			Rui.alert("초기유동관리 종료일: 필수 입력 항목입니다.");
            			$("#initFlowFnhDt").focus();
            			return false;
            		}
            	}
            	
                window.parent.fnInitFlow(lvInitFlowYn, lvInitFlowStrtDt, lvInitFlowFnhDt);
                window.parent.fnSave();
            }
        });

        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet.loadData(${result});
        } else {
            console.log("smry searchData2");
            dataSet.newRecord();
        }

        disableFields();

        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
            $("#btnSave").hide();
        }else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
            $("#btnSave").hide();
        }

    });


    //validation
    function fnIfmIsUpdate(gbn) {
        if(!vm.validateGroup("aForm")) {
            Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
            return false;
        }

        if(gbn != "SAVE" && dataSet.isUpdated()) {
           Rui.alert("완료탭 저장을 먼저 해주시기 바랍니다.");
           return false;
        }

        return true;
    }

    function fnAttchValid(){
        var chkNum = 0;

        if( !Rui.isEmpty(tmpAttchFileList) ){
            for(var i = 0; i < tmpAttchFileList.length; i++) {
                if( tmpAttchFileList[i].data.filNm.indexOf('완료') > -1 || tmpAttchFileList[i].data.filNm.indexOf('결과') > -1 || tmpAttchFileList[i].data.filNm.indexOf('최종') > -1 ){
                    chkNum++;
                }
            }
        }
        return chkNum;
    }

</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight();
});
</script>
</head>
<body>
<div id="aFormDiv">
    <form name="aForm" id="aForm" method="post" style="padding: 20px 1px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->

<table class="table table_txt_right" id="grsDev">
            <colgroup>
                <col style="width: 20%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
                <col style="width: 8%;" />
            </colgroup>
            <tbody>
                <tr>
                      <th rowspan="2"></th>
                      <th class="alignC"  colspan="2">출시년도</th>
                      <th class="alignC"  colspan="2">출시년도+1</th>
                      <th class="alignC"  colspan="2">출시년도+2</th>
                      <th class="alignC"  colspan="2">출시년도+3</th>
                      <th class="alignC"  colspan="2">출시년도+4</th>
                  </tr>
                  <tr>
                      <th class="alignC">前단계</th>
                      <th class="alignC">현재</th>
                      <th class="alignC">前단계</th>
                      <th class="alignC">현재</th>
                      <th class="alignC">前단계</th>
                      <th class="alignC">현재</th>
                      <th class="alignC">前단계</th>
                      <th class="alignC">현재</th>
                      <th class="alignC">前단계</th>
                      <th class="alignC">현재</th>
                  </tr>
                  <tr id="trNprodSal">
                      <th>영업이익률(%)</th>
                      <td class="alignR"><span id="bizPrftProY" /></td>
                      <td  class="alignR" bgcolor='#E6E6E6'><span id="bizPrftProCurY"  style="font-weight:bold;"/></td>
                      <td class="alignR"><span id="bizPrftProY1"/></td>
                      <td  class="alignR" bgcolor='#E6E6E6'><span id="bizPrftProCurY1" style="font-weight:bold;"/></td>
                      <td class="alignR"><span id="bizPrftProY2"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="bizPrftProCurY2" style="font-weight:bold;"/></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                  </tr>
                  <tr id="trbizPrftPln" >
                      <th>영업이익(억원)</th>
                      <td class="alignR" ><span id="bizPrftPlnY"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftCurY" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="bizPrftPlnY1"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftCurY1" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="bizPrftPlnY2"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftCurY2" style="font-weight:bold;"/></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                  </tr>
                  <tr id="trNprodSal"  >
                      <th>매출액(억원)</th>
                      <td class="alignR" ><span id="nprodSalsPlnY" /></td>
                      <td  class="alignR" bgcolor='#E6E6E6'><span id="nprodSalsCurY"  style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="nprodSalsPlnY1"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="nprodSalsCurY1" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="nprodSalsPlnY2"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="nprodSalsCurY2" style="font-weight:bold;"/></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                      <td class="alignR" ></td>
                  </tr>
                <tr id="trPtcCpsnHead" >
                      <th rowspan="2"></th>
                      <th class="alignC"  colspan="2">과제시작년도</th>
                      <th class="alignC"  colspan="2">과제시작년도+1</th>
                      <th class="alignC"  colspan="2">과제시작년도+2</th>
                      <th class="alignC"  colspan="2">과제시작년도+3</th>
                      <th class="alignC"  colspan="2">과제시작년도+4</th>
                  </tr>
                  <tr>
                      <th class="alignC">계획</th>
                      <th class="alignC">실적</th>
                      <th class="alignC">계획</th>
                      <th class="alignC">실적</th>
                      <th class="alignC">계획</th>
                      <th class="alignC">실적</th>
                      <th class="alignC">계획</th>
                      <th class="alignC">실적</th>
                      <th class="alignC">계획</th>
                      <th class="alignC">실적</th>
                  </tr>
                  <tr id="trPtcCpsn" >
                      <th>투입인원(M/M)</th>
                      <td class="alignR" ><span id="ptcCpsnY"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="ptcCpsnY1"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY1" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="ptcCpsnY2"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY2" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="ptcCpsnY3"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY3" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="ptcCpsnY4"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY4" style="font-weight:bold;"/></td>
                  </tr>
                  <tr id="trExpArsl" >
                      <th>투입비용(억원)</th>
                      <td class="alignR" ><span id="expArslY" /></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="expArslY1"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY1" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="expArslY2"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY2" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="expArslY3"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY3" style="font-weight:bold;"/></td>
                      <td class="alignR" ><span id="expArslY4"/></td>
                      <td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY4" style="font-weight:bold;"/></td>
                  </tr>
            </tbody>
        </table>
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: *;" />
                <col style="width: 150px;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">과제개요</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right"><span style="color:red;">* </span>연구과제 배경<br/>및 필요성</th>
                                    <td><input type="text" id="tssSmryTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right"><span style="color:red;">* </span>주요 연구 개발 내용</th>
                                    <td><input type="text" id="tssSmryDvlpTxt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">연구개발성과</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2" align="right">지적재산권</th>
                                    <th align="right"><span style="color:red;">* </span>지재권 출원현황<br/>(국내/해외)</th>
                                    <td><input type="text" id="rsstDvlpOucmTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right"><span style="color:red;">* </span>특허 Risk 검토결과</th>
                                    <td><input type="text"  id="pmisCmplTxt" name="pmisCmplTxt"></td>
                                </tr>
                                <tr>
                                    <th align="right">목표기술성과</th>
                                    <th align="right">핵심 CTQ/품질 수준<br/>(경쟁사 비교)</th>
                                    <td><input type="text" id="rsstDvlpOucmCtqTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">파급효과 및 응용분야</th>
                                    <td><input type="text" id="rsstDvlpOucmEffTxt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right" rowspan="2"><span style="color:red;">* </span>사업화 출시 계획</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">신제품명</th>
                                    <td><span id="nprodNm" /></td>
                                </tr>
                                <tr>
                                    <th align="right">예상출시일(계획)</th>
                                    <td><span id="ancpOtPlnDt" /></td>
                                </tr>
                                <tr>
                                    <th align="right">Qgate3(품질평가단계) 패스일자</th>
                                    <td><input type="text" id="qgate3Dt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><input type="text" id="fwdPlnTxt" /></td>
                </tr>
                <tr>
                    <th align="right"><span style="color:red;">* </span>향후 계획</th>
                    <td colspan="2"><input type="text" id="fnoPlnTxt" /></td>
                </tr>
                <tr>
                    <th align="right">초기유동관리여부</th>
                    <td colspan="2">
                    	<input type="checkbox" id="chkInitFlowYn"> Y
                    	&nbsp;&nbsp;
                        <input type="text" id="initFlowStrtDt" value="" />
                        <em class="gab"> ~ </em>
                        <input type="text" id="initFlowFnhDt" value="" />
                    </td>
                </tr>
                <tr>
                    <th align="right">과제완료보고서 및 기타</th>
                    <td id="attchFileView" colspan="2">&nbsp;</td>
                </tr>
                <tr id="initFlowAttch" style="display:none;">
                    <th align="right">초기유동관리 <br/>완료보고서 및 기타</th>
                    <td id="initFlowAttchFileView">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>

        <!-- [2024.03.12] 밑으로 스크롤이 안되어 추가함-->
        <br/><br/><br/>

    </form>
</div>
<div class="titArea">
    <!-- <div><font color="red">첨부 : 과제완료보고서(word파일), 심의보고서(ppt), 심의회의록</font></div> -->
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>