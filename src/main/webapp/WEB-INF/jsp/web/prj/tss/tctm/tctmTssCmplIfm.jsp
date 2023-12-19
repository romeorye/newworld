<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
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
<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
<style>
 .L-tssLable {
 border: 0px
 }
</style>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.cmplTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;

    // var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    var pageMode =
        (
        (window.parent.pgsStepCd=="PG" && (window.parent.gvTssSt=="102" || window.parent.gvTssSt=="302" ))
        || (window.parent.pgsStepCd=="CM" && window.parent.gvTssSt=="100")
        )
            ? "W" : "R";
    var dataSet;
    var lvAttcFilId;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //과제개요_연구과제배경
        // tssSmryTxt = new Rui.ui.form.LTextArea({
        //     applyTo: 'tssSmryTxt',
        //     height: 80,
        //     width: 600
        // });

        //과제개요_주요연구개발내용
        // tssSmryDvlpTxt = new Rui.ui.form.LTextArea({
        //     applyTo: 'tssSmryDvlpTxt',
        //     height: 80,
        //     width: 600
        // });

        //연구개발성과_지재권
        // rsstDvlpOucmTxt = new Rui.ui.form.LTextArea({
        //     applyTo: 'rsstDvlpOucmTxt',
        //     height: 80,
        //     width: 600
        // });

        //연구개발성과_CTQ
        // rsstDvlpOucmCtqTxt = new Rui.ui.form.LTextArea({
        //     applyTo: 'rsstDvlpOucmCtqTxt',
        //     height: 80,
        //     width: 600
        // });

        //연구개발성과_파급효과
        // rsstDvlpOucmEffTxt = new Rui.ui.form.LTextArea({
        //     applyTo: 'rsstDvlpOucmEffTxt',
        //     height: 80,
        //     width: 600
        // });

        //신제품명
        nprodNm = new Rui.ui.form.LTextBox({
            applyTo: 'nprodNm',
            width: 800
        });

        //예상출시일(계획)
        ancpOtPlnDt = new Rui.ui.form.LDateBox({
            applyTo: 'ancpOtPlnDt',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
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
            height: 200,
            width: 1150
        });

        //향후 계획
        fnoPlnTxt = new Rui.ui.form.LTextArea({
            applyTo: 'fnoPlnTxt',
            height: 200,
            width: 1150
        });

        //Form 비활성화
        disableFields = function() {
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');

            if(pageMode == "W") return;

            if(pageMode=="R"){
                btnSave.hide();
                document.getElementById('attchFileMngBtn').style.display = "none";
                setReadonly("nprodNm");
                setReadonly("ancpOtPlnDt");
                setReadonly("qgate3Dt");
                setReadonly("fwdPlnTxt");
                setReadonly("fnoPlnTxt");
            }
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
                  { id: 'tssCd' }               //과제코드
                , { id: 'userId' }              //로그인ID
                // , { id: 'tssSmryTxt' }          //과제개요_연구과제배경
                // , { id: 'tssSmryDvlpTxt' }      //과제개요_주요연구개발내용
                // , { id: 'rsstDvlpOucmTxt' }     //연구개발성과_지재권
                // , { id: 'rsstDvlpOucmCtqTxt' }  //연구개발성과_CTQ
                // , { id: 'rsstDvlpOucmEffTxt' }  //연구개발성과_파급효과
                , { id: 'nprodNm' }             //신제품명
                , { id: 'ancpOtPlnDt' }         //예상출시일(계획)
                , { id: 'qgate3Dt' }            //Qgate3(품질평가단계) 패스일자
                , { id: 'fwdPlnTxt' }           //사업화출시계획
                , { id: 'fnoPlnTxt' }           //향후 계획
                , { id: 'attcFilId' }           //첨부파일
                , { id: 'cmplAttcFilId' }       //첨부파일
            ]
        });
        dataSet.on('load', function(e) {
            lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "cmplAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();

            disableFields();

        });


        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',              ctrlId: 'tssCd',              value: 'value' }
                , { id: 'userId',             ctrlId: 'userId',             value: 'value' }
                // , { id: 'tssSmryTxt',         ctrlId: 'tssSmryTxt',         value: 'value' }
                // , { id: 'tssSmryDvlpTxt',     ctrlId: 'tssSmryDvlpTxt',     value: 'value' }
                // , { id: 'rsstDvlpOucmTxt',    ctrlId: 'rsstDvlpOucmTxt',    value: 'value' }
                // , { id: 'rsstDvlpOucmCtqTxt', ctrlId: 'rsstDvlpOucmCtqTxt', value: 'value' }
                // , { id: 'rsstDvlpOucmEffTxt', ctrlId: 'rsstDvlpOucmEffTxt', value: 'value' }
                , { id: 'nprodNm',            ctrlId: 'nprodNm',            value: 'value' }
                , { id: 'ancpOtPlnDt',        ctrlId: 'ancpOtPlnDt',        value: 'value' }
                , { id: 'qgate3Dt',           ctrlId: 'qgate3Dt',           value: 'value' }
                , { id: 'fwdPlnTxt',          ctrlId: 'fwdPlnTxt',          value: 'value' }
                , { id: 'fnoPlnTxt',          ctrlId: 'fnoPlnTxt',          value: 'value' }
            ]
        });

        //유효성 설정
        vm = new Rui.validate.LValidatorManager({
            validators: [
                { id: 'tssCd',              validExp: '과제코드:false' }
                , { id: 'userId',             validExp: '로그인ID:false' }
                // , { id: 'tssSmryTxt',         validExp: '연구과제 배경 및 필요성:false' }
                // , { id: 'tssSmryDvlpTxt',     validExp: '주요 연구 개발 내용:false' }
                // , { id: 'rsstDvlpOucmTxt',    validExp: '지재권 출원현황:false' }
                // , { id: 'rsstDvlpOucmCtqTxt', validExp: '핵심 CTQ 품질 수준:false' }
                // , { id: 'rsstDvlpOucmEffTxt', validExp: '파급효과 및 응용분야:false' }
                , { id: 'nprodNm',            validExp: '신제품명:false:maxLength=500' }
                , { id: 'ancpOtPlnDt',        validExp: '예상출시일(계획):false' }
                , { id: 'qgate3Dt',           validExp: 'Qgate3(품질평가단계) 패스일자:false' }
                , { id: 'fwdPlnTxt',          validExp: '사업화출시계획:false' }
                , { id: 'fnoPlnTxt',          validExp: '향후 계획:false' }
                , { id: 'attcFilId',          validExp: '첨부파일:false' }
                , { id: 'cmplAttcFilId',      validExp: '첨부파일:false' }
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
            }
        };

        downloadAttachFile = function(attcFilId, seq) {
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };


        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            window.parent.cmSave();
        });


        //목록
       /*  var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
 */

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
    function fnIfmIsUpdate() {
        if(!vm.validateGroup("aForm")) {
            Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
            return false;
        }

        // if(gbn != "SAVE" && dataSet.isUpdated()) {
        //    Rui.alert("완료탭 저장을 먼저 해주시기 바랍니다.");
        //    return false;
        // }

        return true;
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

        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: *;" />
                <col style="width: 150px;" />
            </colgroup>
            <tbody>
<%--
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
                                    <th align="right">연구과제 배경<br/>및 필요성</th>
                                    <td><input type="text" id="tssSmryTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right">주요 연구 개발 내용</th>
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
                                    <th align="right">지적재산권</th>
                                    <th align="right">지재권 출원현황<br/>(국내/해외)</th>
                                    <td><input type="text" id="rsstDvlpOucmTxt" /></td>
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
 --%>
                <tr>
                    <th align="right" rowspan="2"><span style="color:red;">* </span>사업화 출시 계획</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 220px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right"><span style="color:red;">* </span>신제품명</th>
                                    <td><input type="text" id="nprodNm" /></td>
                                </tr>
                                <tr>
                                    <th align="right"><span style="color:red;">* </span>예상출시일(계획)</th>
                                    <td><input type="text" id="ancpOtPlnDt" /></td>
                                </tr>
                                <tr>
                                    <th align="right"><span style="color:red;">* </span>Qgate3(품질평가단계) 패스일자</th>
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
                    <th align="right"><span style="color:red;">* </span>과제완료보고서 및 기타</th>
                    <td id="attchFileView">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>