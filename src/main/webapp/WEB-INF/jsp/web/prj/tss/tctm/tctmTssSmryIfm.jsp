<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      :  tctmTssSmryIfm.jsp
 * @desc    : 기술팀 과제 개요 Frame
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
<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode; // text
    var lvTssStrtDd = window.parent.tssStrtDd.getValue();
    var isEditable = window.parent.isEditable;

    var dataSet;
    var lvAttcFilId;

    var strDt =window.parent.tssStrtDd.getValue();
    var endDt =window.parent.tssFnhDd.getValue();

    Rui.onReady/**
*
*/
(function() {

        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        /**
         * Summary 개요
         */
        smrSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrSmryTxt',
            height: 200,
            width: 940
        });

    /**
     * 요약목표
     * @type {Rui.ui.form.LTextArea}
     */
    smrGoalTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrGoalTxt',
            height: 200,
            width: 940
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

        //신제품 매출계획
        nprodSalsPlnY = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY',
            defaultValue: 0,
            decimalPrecision: 2,
            maxValue: 999999999.999999,
            width: 120
        });

        // nprodSalsPlnY.on('changed', function() {
        //     fnGetYAvg("nprod");
        // });

        //Form 비활성화
        disableFields = function() {
            // document.getElementById('nprodSalsPlnYAvg').style.border = 0;
            // document.getElementById('ptcCpsnYAvg').style.border = 0;
            // document.getElementById('bizPrftProYAvg').style.border = 0;

            // if(lvTssSt == "") btnReport.hide();

            if(isEditable) {
                document.getElementById('attchFileMngBtn').style.display = "block";
                btnSave.show();
            }else{
                setViewform();
                document.getElementById('attchFileMngBtn').style.display = "none";
                btnSave.hide();
            }

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
                {id: 'tssCd'}            //과제코드
                , {id: 'smrSmryTxt'}       //Summary 개요
                , {id: 'smrGoalTxt'}       //Summary 목표
                , {id: 'ctyOtPlnM'}        //상품출시(계획)
                , {id: 'nprodSalsPlnY', type: 'number', defaultValue: 0}    //신제품매출계획Y
                , {id: 'attcFilId'}        //첨부파일ID
                , {id: 'userId'}           //로그인ID
            ]
        });
        dataSet.on('load', function(e) {

            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

            
            console.log("???????????????????????",dataSet.getNameValue(0, "nprodSalsPlnY") / 100000000);
            var dsNprodSalsPlnY  = (dataSet.getNameValue(0, "nprodSalsPlnY")  / 100000000).toFixed(2);
            console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",dsNprodSalsPlnY);
            nprodSalsPlnY.setValue(dsNprodSalsPlnY);
            console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",nprodSalsPlnY.getValue());

	        // fncPtcCpsnYDisable(strDt, endDt);
            // setTimeout(function () {
	        //     fnGetYAvg("ptc");
	        //     fnGetYAvg("biz");
            // }, 1000);
        });

        //Form 바인드
        var bind = new Rui.data.LBind({
            groupId: 'smryFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                , { id: 'smrSmryTxt',       ctrlId: 'smrSmryTxt',       value: 'value' }
                , { id: 'smrGoalTxt',       ctrlId: 'smrGoalTxt',       value: 'value' }
                , { id: 'ctyOtPlnM',    ctrlId: 'ctyOtPlnM',    value: 'value' }
                // , { id: 'nprodSalsPlnY',    ctrlId: 'nprodSalsPlnY',    value: 'value' }
//                 , { id: 'pmisTxt',       	ctrlId: 'pmisTxt',       	value: 'value' }
                , { id: 'userId',           ctrlId: 'userId',           value: 'value' }
                , { id: 'attcFilId',        ctrlId: 'attcFilId',        value: 'value' }
            ]
        });


        //유효성
        vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'tssCd',             validExp: '과제코드:false' }
                , { id: 'smrSmryTxt',        validExp: 'Summary 개요:true' }
                , { id: 'smrGoalTxt',        validExp: 'Summary 목표:true' }
                , { id: 'ctyOtPlnM',         validExp: '상품출시(계획):true' }
                , { id: 'nprodSalsPlnY',     validExp: '신제품매출계획:true:minNumber=1' }
                , { id: 'attcFilId',         validExp: 'GRS심의파일:true' }
                , { id: 'userId',            validExp: '로그인ID:false' }
            ]
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //Report
/*        var btnReport = new Rui.ui.LButton('btnReport');
        btnReport.on('click', function () {
            var tssStrtDd = lvTssStrtDd.substring(0, 4);
            var url = "<%=lghausysReportPath%>/genSmryReportPopup.jsp?reportMode=HTML&clientURIEncoding=UTF-8"
                + "&reportParams=skip_decimal_point:true&menu=old&tss_cd=" + lvTssCd + "&year=" + tssStrtDd;

            var w = window.open(url, 'reportPopup', 'width=1180 height=900');
        });*/

        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            var frm = document.smryForm;
            dataSet.setNameValue(0, "nprodSalsPlnY" , Math.round(nprodSalsPlnY.getValue()  * 100000000));


            if(fnIfmIsUpdate())window.parent.smrySave();
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



        /** ============================================= Editor ================================================================================= **/

        //최초 데이터 셋팅
        if(${resultCnt} > 0) {
            dataSet.loadData(${result});

        } else {
            dataSet.newRecord();
            // tabViewS.selectTab(0);
        }

        //버튼 비활성화 셋팅

        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
		}
    });


    //validation
    function fnIfmIsUpdate() {
        if (!vm.validateGroup("smryForm")) {
            alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
            return false;
        }

        // if (gbn != "SAVE" && dataSet.isUpdated()) {
        //     alert("개요탭 저장을 먼저 해주시기 바랍니다.");
        //     return false;
        // }

        var y = nprodSalsPlnY.getValue();
        if (y <= 0) {
            alert("신제품 매출계획은 필수입력입니다.");
            return false;
        }

        // var y  = ptcCpsnY.getValue();

        return true;
    }


    function setViewform(){
        setReadonly("smrSmryTxt");
        setReadonly("smrGoalTxt");
        setReadonly("ctyOtPlnM");
        setReadonly("nprodSalsPlnY");
    }

</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("smryFormDiv");
});
</script>
</head>
<body style="overflow-y : hidden">
<div id="smryFormDiv">
    <form name="smryForm" id="smryForm" method="post" style="padding: 20px 1px 0 0;">
        <input type="hidden" id="tssCd" name="tssCd" value=""/> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""/> <!-- 사용자ID -->
        <input type="hidden" id="attcFilId" name="attcFilId" value=""/>

        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 18%;"/>
                <col style="width: 32%;"/>
                <col style="width: 18%;"/>
                <col style="width: 32%;"/>
            </colgroup>
            <tbody>
            <tr>
                <th align="right" onclick="setTestVal()">Summary 개요</th>
                <td colspan="3"><input type="text" id="smrSmryTxt" name="smrSmryTxt" style="width: 100%"></td>
            </tr>
            <tr>
                <th align="right">Summary 목표</th>
                <td colspan="3"><input type="text" id="smrGoalTxt" name="smrGoalTxt" style="width: 100%"></td>
            </tr>
            <tr>
                <th align="right">상품출시(계획)</th>
                <td><input type="text" id="ctyOtPlnM"/></td>
                <th>신제품 매출계획(단위:억원)</th>
                <td><input type="text" id="nprodSalsPlnY" name="nprodSalsPlnY"></td>
            </tr>
            <tr>
                <th align="right">GRS심의파일<br/>(심의파일, 회의록 필수 첨부)</th>
                <td colspan="2" id="attchFileView">&nbsp;</td>
                <td colspan="1">
                    <button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">
                        첨부파일등록
                    </button>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
    <div class="titArea btn_btm">
        <div class="LblockButton">
<%--
            <button type="button" id="btnReport" name="btnReport">Report</button>
--%>
            <button type="button" id="btnSave" name="btnSave">저장</button>
            <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
        </div>
    </div>
</div>
</body>
<script>
    function setTestVal(){
        smrSmryTxt.setValue("서머리개요");
        smrGoalTxt.setValue("서머리 목ㄹ표");
        ctyOtPlnM.setValue("2018-10");
        nprodSalsPlnY.setValue("100");
        smryForm.attcFilId.value="201806107"
        // $("#attcFilId").val("201806107");
        $('#attchFileView').html('<a href=\'javascript:downloadAttachFile("201806107", "1")\'>approveForm.jpg(328747byte)</a>');
    }
</script>
</html>