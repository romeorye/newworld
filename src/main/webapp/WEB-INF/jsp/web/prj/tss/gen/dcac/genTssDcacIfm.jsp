<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssDcacIfm.jsp
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
    var lvTssCd    = window.parent.dcacTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;

    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";

    var dataSet;
    var vm;
    var lvAttcFilId;

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

        //연구개발성과_CTQ
        rsstDvlpOucmCtqTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rsstDvlpOucmCtqTxt',
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

        //연구개발성과_파급효과
        rsstDvlpOucmEffTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rsstDvlpOucmEffTxt',
            height: 80,
            width: 600
        });

        //향후 계획
        fnoPlnTxt = new Rui.ui.form.LTextArea({
            applyTo: 'fnoPlnTxt',
            height: 80,
            width: 600
        });

        //중단사유
        dcacRsonTxt = new Rui.ui.form.LTextArea({
            applyTo: 'dcacRsonTxt',
            height: 80,
            width: 600
        });

        //Form 비활성화
        disableFields = function() {
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');

            if(pageMode == "W") return;

            btnSave.hide();

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
                  { id: 'tssCd' }              //과제코드
                , { id: 'userId' }             //로그인ID
                , { id: 'tssSmryTxt' }         //과제 필요성 및 사업기회
                , { id: 'rsstDvlpOucmCtqTxt' } //핵심 CTQ/품질 수준
                , { id: 'tssSmryDvlpTxt' }     //주요개발 내용
                , { id: 'rsstDvlpOucmTxt' }    //지재권 출원현황
                , { id: 'rsstDvlpOucmEffTxt' } //파급효과 및 응용분야
                , { id: 'fnoPlnTxt' }          //향후계획
                , { id: 'dcacRsonTxt' }        //중단사유
                , { id: 'attcFilId' }          //첨부파일
                , { id: 'dcacAttcFilId' }      //첨부파일
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");

            lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "dcacAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();
        });


        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',              ctrlId: 'tssCd',              value: 'value' }
                , { id: 'userId',             ctrlId: 'userId',             value: 'value' }
                , { id: 'tssSmryTxt',         ctrlId: 'tssSmryTxt',         value: 'value' }
                , { id: 'rsstDvlpOucmCtqTxt', ctrlId: 'rsstDvlpOucmCtqTxt', value: 'value' }
                , { id: 'tssSmryDvlpTxt',     ctrlId: 'tssSmryDvlpTxt',     value: 'value' }
                , { id: 'rsstDvlpOucmTxt',    ctrlId: 'rsstDvlpOucmTxt',    value: 'value' }
                , { id: 'rsstDvlpOucmEffTxt', ctrlId: 'rsstDvlpOucmEffTxt', value: 'value' }
                , { id: 'fnoPlnTxt',          ctrlId: 'fnoPlnTxt',          value: 'value' }
                , { id: 'dcacRsonTxt',        ctrlId: 'dcacRsonTxt',        value: 'value' }
            ]
        });

        //유효성 설정
        vm = new Rui.validate.LValidatorManager({
            validators: [
                { id: 'tssCd',                validExp: '과제코드:false' }
                , { id: 'userId',             validExp: '로그인ID:false' }
                , { id: 'tssSmryTxt',         validExp: '과제 필요성 및 사업기회:false' }
                , { id: 'rsstDvlpOucmCtqTxt', validExp: '핵심 CTQ/품질 수준:false' }
                , { id: 'tssSmryDvlpTxt',     validExp: '주요개발 내용:false' }
                , { id: 'rsstDvlpOucmTxt',    validExp: '지재권 출원현황:false' }
                , { id: 'rsstDvlpOucmEffTxt', validExp: '파급효과 및 응용분야:false' }
                , { id: 'fnoPlnTxt',          validExp: '향후계획:false' }
                , { id: 'dcacRsonTxt',        validExp: '중단사유:false' }
                , { id: 'attcFilId',          validExp: '첨부파일:false' }
                , { id: 'dcacAttcFilId',      validExp: '첨부파일:false' }
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
        	window.parent.fnSave();
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
    });

    //validation
    function fnIfmIsUpdate(gbn) {
        if(!vm.validateGroup("aForm")) {
            Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
            return false;
        }

        if(gbn != "SAVE" && dataSet.isUpdated()) {
           Rui.alert("중단탭 저장을 먼저 해주시기 바랍니다.");
           return false;
        }

        
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
                <tr>
                    <th align="right">과재개요</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">개발목적 및 배경</th>
                                    <th align="right">과제 필요성 및 사업기회</th>
                                    <td><input type="text" id="tssSmryTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right">개발목표</th>
                                    <th align="right">핵심 CTQ/품질 수준 (경쟁사 비교)</th>
                                    <td><input type="text" id="rsstDvlpOucmCtqTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">주요개발 내용</th>
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
                                    <th align="right" colspan="2">파급효과 및 응용분야</th>
                                    <td><input type="text" id="rsstDvlpOucmEffTxt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">향후 계획</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">사업화(출시) 및 양산이관계획</th>
                                    <td><input type="text" id="fnoPlnTxt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">중단 사유</th>
                    <td colspan="2"><input type="text" id="dcacRsonTxt" /></td>
                </tr>
                <tr>
                    <th align="right">과제완료보고서 및 기타</th>
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