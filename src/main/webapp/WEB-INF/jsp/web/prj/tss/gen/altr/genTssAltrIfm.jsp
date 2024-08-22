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
<style>
 .L-tssLable {
 border: 0px
 }
</style>

<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPgTssSt  = window.parent.gvPgTssSt; //"${param.pgTssSt}";
    var lvPageMode = window.parent.gvPageMode;
    var gbnCd      = window.parent.gbnCd;
    var pageMode = (lvTssSt == "100" || lvTssSt == "" || lvTssSt == "302" ) && lvPageMode == "W" ? "W" : "R";

    var dataSet1;
    var dataSet2;
    var vm1;
    var vm2;

    var lvAttcFilId;

    var lvTssAttrCd = window.parent.tssAttrCd;
    var lvBizDptCd = window.parent.bizDptCd;

console.log("[lvPgTssSt]", lvPgTssSt);

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //변경사유
        altrRsonTxt = new Rui.ui.form.LTextArea({
            applyTo: 'altrRsonTxt',
            height: 80,
            width: 600
        });

        //추가사유
        addRsonTxt = new Rui.ui.form.LTextArea({
            applyTo: 'addRsonTxt',
            height: 80,
            width: 600
        });

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
            /*
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');


            butRecordNew.hide();
            butRecordDel.hide();
            btnSave.hide();

            */
            grid.setEditable(false);
        };

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 설정
        dataSet1 = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                 { id: 'ancpOtPlnDt'}
                ,{ id: 'bizPrftProY'}
                ,{ id: 'bizPrftProY1'}
                ,{ id: 'bizPrftProY2'}
                ,{ id: 'bizPrftProY3'}
                ,{ id: 'bizPrftProY4'}
                ,{ id: 'bizPrftPlnY'}
                ,{ id: 'bizPrftPlnY1'}
                ,{ id: 'bizPrftPlnY2'}
                ,{ id: 'nprodSalsPlnY'}
                ,{ id: 'nprodSalsPlnY1'}
                ,{ id: 'nprodSalsPlnY2'}
                ,{ id: 'nprodSalsPlnY3'}
                ,{ id: 'nprodSalsPlnY4'}
                ,{ id: 'ptcCpsnY'}
                ,{ id: 'ptcCpsnY1'}
                ,{ id: 'ptcCpsnY2'}
                ,{ id: 'ptcCpsnY3'}
                ,{ id: 'ptcCpsnY4'}
                ,{ id: 'expArslY'}
                ,{ id: 'expArslY1'}
                ,{ id: 'expArslY2'}
                ,{ id: 'expArslY3'}
                ,{ id: 'expArslY4'}
                ,{ id: 'bizPrftProYBefore'}
                ,{ id: 'bizPrftProY1Before'}
                ,{ id: 'bizPrftProY2Before'}
                ,{ id: 'bizPrftProY3Before'}
                ,{ id: 'bizPrftProY4Before'}
                ,{ id: 'bizPrftPlnYBefore'}
                ,{ id: 'bizPrftPlnY1Before'}
                ,{ id: 'bizPrftPlnY2Before'}
                ,{ id: 'nprodSalsPlnYBefore'}
                ,{ id: 'nprodSalsPlnY1Before'}
                ,{ id: 'nprodSalsPlnY2Before'}
                ,{ id: 'ptcCpsnYBefore'}
                ,{ id: 'ptcCpsnY1Before'}
                ,{ id: 'ptcCpsnY2Before'}
                ,{ id: 'ptcCpsnY3Before'}
                ,{ id: 'ptcCpsnY4Before'}
                ,{ id: 'expArslYBefore'}
                ,{ id: 'expArslY1Before'}
                ,{ id: 'expArslY2Before'}
                ,{ id: 'expArslY3Before'}
                ,{ id: 'expArslY4Before'}
                ,{ id: 'altrRsonTxt'}
                ,{ id: 'addRsonTxt'}
                ,{ id: 'altrAttcFilId'}
                ,{ id: 'tssCd'}
                ,{ id: 'userId'}
            ]
        });
        dataSet1.on('load', function(e) {
            console.log("smry load DataSet Success");

            dataSet2.load({
                url: '<c:url value="/prj/tss/gen/retrieveGenTssAltrSmryList.do"/>',
                params :{
                    tssCd : lvTssCd
                }
            });

            lvAttcFilId = stringNullChk(dataSet1.getNameValue(0, "altrAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();
        });

        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet1,
            bind: true,
            bindInfo: [
                 { id: 'ancpOtPlnDt',         ctrlId: 'ancpOtPlnDt',        value: 'html'}
                ,{ id: 'bizPrftProY',      ctrlId: 'bizPrftProY',      value: 'html'}
                ,{ id: 'bizPrftProYBefore',      ctrlId: 'bizPrftProYBefore',      value: 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY1',     ctrlId: 'bizPrftProY1',     value: 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY1Before',     ctrlId: 'bizPrftProY1Before',     value: 'html' , renderer: function(value) {
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                }
            }
                ,{ id: 'bizPrftProY2',     ctrlId: 'bizPrftProY2',     value: 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY2Before',     ctrlId: 'bizPrftProY2Before',     value: 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY3',     ctrlId: 'bizPrftProY3',     value: 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY3Before',     ctrlId: 'bizPrftProY3Before',     value: 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY4',     ctrlId: 'bizPrftProY4',     value: 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftProY4Before',     ctrlId: 'bizPrftProY4Before',     value: 'html' , renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftPlnY',         ctrlId: 'bizPrftPlnY',         value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftPlnYBefore',         ctrlId: 'bizPrftPlnYBefore',         value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftPlnY1',         ctrlId: 'bizPrftPlnY1',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftPlnY1Before',         ctrlId: 'bizPrftPlnY1Before',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftPlnY2',         ctrlId: 'bizPrftPlnY2',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'bizPrftPlnY2Before',         ctrlId: 'bizPrftPlnY2Before',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY',     ctrlId: 'nprodSalsPlnY',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnYBefore',     ctrlId: 'nprodSalsPlnYBefore',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY1',    ctrlId: 'nprodSalsPlnY1',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY1Before',    ctrlId: 'nprodSalsPlnY1Before',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY2',     ctrlId: 'nprodSalsPlnY2',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'nprodSalsPlnY2Before',     ctrlId: 'nprodSalsPlnY2Before',     value: 'html', renderer: function(value) {
                    return Rui.util.LFormat.numberFormat(value);
                }
            }
                ,{ id: 'ptcCpsnY',             ctrlId: 'ptcCpsnY',         value: 'html'}
                ,{ id: 'ptcCpsnYBefore',             ctrlId: 'ptcCpsnYBefore',         value: 'html'}
                ,{ id: 'ptcCpsnY1',         ctrlId: 'ptcCpsnY1',         value: 'html'}
                ,{ id: 'ptcCpsnY1Before',         ctrlId: 'ptcCpsnY1Before',         value: 'html'}
                ,{ id: 'ptcCpsnY2',         ctrlId: 'ptcCpsnY2',         value: 'html'}
                ,{ id: 'ptcCpsnY2Before',         ctrlId: 'ptcCpsnY2Before',         value: 'html'}
                ,{ id: 'ptcCpsnY3',         ctrlId: 'ptcCpsnY3',         value: 'html'}
                ,{ id: 'ptcCpsnY3Before',         ctrlId: 'ptcCpsnY3Before',         value: 'html'}
                ,{ id: 'ptcCpsnY4',         ctrlId: 'ptcCpsnY4',         value: 'html'}
                ,{ id: 'ptcCpsnY4Before',         ctrlId: 'ptcCpsnY4Before',         value: 'html'}
                ,{ id: 'expArslY',             ctrlId: 'expArslY',         value: 'html'}
                ,{ id: 'expArslYBefore',             ctrlId: 'expArslYBefore',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY1',         ctrlId: 'expArslY1',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY1Before',         ctrlId: 'expArslY1Before',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY2',         ctrlId: 'expArslY2',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY2Before',         ctrlId: 'expArslY2Before',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY3',         ctrlId: 'expArslY3',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY3Before',         ctrlId: 'expArslY3Before',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY4',         ctrlId: 'expArslY4',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'expArslY4Before',         ctrlId: 'expArslY4Before',         value: 'html', renderer: function(value) {
                    if ( parseFloat(value) > 0 ){
                        return Rui.util.LFormat.numberFormat(parseFloat(value));
                    }else{
                        return "";
                    }
                }
            }
                ,{ id: 'altrRsonTxt',         ctrlId: 'altrRsonTxt',         value: 'value'}
                ,{ id: 'addRsonTxt',         ctrlId: 'addRsonTxt',         value: 'value'}
            ]
        });

        //유효성 설정
        vm1 = new Rui.validate.LValidatorManager({
            validators: [
                { id: 'altrRsonTxt', validExp: '변경사유:true' }
            ]
        });

        //DataSet 설정
        dataSet2 = new Rui.data.LJsonDataSet({
            id: 'altrDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }   //과제코드
                , { id: 'userId' }  //로그인ID
                , { id: 'altrSn' }  //변경일련번호
                , { id: 'prvs' }    //항목
                , { id: 'altrPre' } //변경전
                , { id: 'altrAft' } //변경후
            ]
        });
        dataSet2.on('load', function(e) {
            console.log("altr load DataSet Success");
            //lvAttcFilId = stringNullChk(dataSet1.getNameValue(0, "altrAttcFilId"));
            //if(lvAttcFilId != "") getAttachFileList();
        });


        //유효성 설정
        vm2 = new Rui.validate.LValidatorManager({
            validators: [
                { id: 'prvs',    validExp: '항목:true' }
                , { id: 'altrPre', validExp: '변경전:true' }
                , { id: 'altrAft', validExp: '변경후:true' }
            ]
        });

        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'prvs', label: '항목', sortable: false, align:'left', width: 150, editor: new Rui.ui.form.LTextBox() }
                , { field: 'altrPre', label: '변경전', sortable: false, align:'left', width: 300, editor: new Rui.ui.form.LTextBox() }
                , { field: 'altrAft', label: '변경후', sortable: false, align:'left', width: 300, editor: new Rui.ui.form.LTextBox() }
            ]
        });

        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet2,
            width: 600,
            height: 250,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });
        grid.render('defaultGrid');

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
                dataSet1.setNameValue(0, "altrAttcFilId", lvAttcFilId)
            }
        };

        downloadAttachFile = function(attcFilId, seq) {
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };


        //추가
        var butRecordNew = new Rui.ui.LButton('butRecordNew');
        butRecordNew.on('click', function() {
            var record = dataSet2.createRecord({tssCd: lvTssCd, userId: lvUserId});
            dataSet2.add(record);
        });

        if(lvAttcFilId != "") getAttachFileList();

        //삭제
        var butRecordDel = new Rui.ui.LButton('butRecordDel');
        butRecordDel.on('click', function() {
            if(dataSet2.getMarkedCount() > 0) {
                dataSet2.removeMarkedRows();
            } else {
                var row = dataSet2.getRow();
                if(row < 0) return;

                dataSet2.removeAt(row);
            }
        });


        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            //dataSet1.setNameValue(0, 'altrAttcFilId', lvAttcFilId)
            window.parent.fnSave();
        });


        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });


        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet1.loadData(${result});
        } else {
            console.log("smry searchData2");
            dataSet1.newRecord();
        }

        disableFields();
    });


    function fnIfmIsUpdate(gbn) {
        if(!vm1.validateGroup("aForm")) {
             Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm1.getMessageList().join('<br>'));
             return false;
        }

        if(!vm2.validateDataSet(dataSet2, dataSet2.getRow())) {
             Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm2.getMessageList().join('<br>'));
             return false;
        }

        if(gbn == "SAVE") {
            var rCnt = dataSet2.getCount();
            for(var i = 0; i < dataSet2.getCount(); i++) {
                if(dataSet2.getState(i) == 3) {
                    rCnt--;
                }
            }
            if(rCnt <= 0) {
                Rui.alert("변경 개요 항목을 추가해주시기 바랍니다.");
                return false;
            }
        } else {
            if(dataSet1.isUpdated() || dataSet2.isUpdated()) {
                Rui.alert("개요 저장을 먼저 해주시기 바랍니다.");
                return false;
            }
        }

        return true;
    }

    $(window).load(function() {
        setTimeout(() => {
            initFrameSetHeight();
        }, 600);
    });
</script>

</head>
<body style="overflow: hidden">
<div id="aFormDiv">
    <form name="aForm" id="aForm" method="post" style="padding: 10px 1px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->

        <div class="titArea">
            <div class="LblockButton">
                <button type="button" id="butRecordNew">+</button>
                <button type="button" id="butRecordDel">-</button>
            </div>
        </div>
        <div id="defaultGrid"></div>
        <table class="table table_txt_right" id="tbDlView">
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
                    <th align="right">상품출시(계획)</th>
                    <td colspan="10"><span id="ancpOtPlnDt" /></td>
                </tr>
                <tr  id="trNprodSalHead">
                      <th rowspan="2"></th>
                      <th class="alignC"  colspan="2">출시년도</th>
                      <th class="alignC"  colspan="2">출시년도+1</th>
                      <th class="alignC"  colspan="2">출시년도+2</th>
                      <th class="alignC"  colspan="2">출시년도+3</th>
                      <th class="alignC"  colspan="2">출시년도+4</th>
                  </tr>
                  <tr>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                  </tr>
                  <tr id="trNprodSal">
                      <th>영업이익율(%)</th>
                      <td class="alignR"><span id="bizPrftProYBefore" /></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="bizPrftProY"  /></td>
                      <td class="alignR"><span id="bizPrftProY1Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="bizPrftProY1" /></td>
                      <td class="alignR"><span id="bizPrftProY2Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="bizPrftProY2" /></td>
                      <td class="alignR"></td>
                      <td class="alignR" bgcolor='#E6E6E6'></td>
                      <td class="alignR"></td>
                      <td class="alignR" bgcolor='#E6E6E6'></td>
                  </tr>
                  <tr id="trbizPrftPln" >
                      <th>영업이익(억원)</th>
                      <td class="alignR"><span id="bizPrftPlnYBefore"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="bizPrftPlnY" /></td>
                      <td class="alignR"><span id="bizPrftPlnY1Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="bizPrftPlnY1" /></td>
                      <td class="alignR"><span id="bizPrftPlnY2Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="bizPrftPlnY2" /></td>
                      <td class="alignR"></td>
                      <td class="alignR" bgcolor='#E6E6E6'></td>
                      <td class="alignR"></td>
                      <td class="alignR" bgcolor='#E6E6E6'></td>
                  </tr>
                  <tr id="trNprodSal"  >
                      <th>매출액(억원)</th>
                      <td class="alignR"><span id="nprodSalsPlnYBefore" /></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="nprodSalsPlnY"  /></td>
                      <td class="alignR"><span id="nprodSalsPlnY1Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="nprodSalsPlnY1" /></td>
                      <td class="alignR"><span id="nprodSalsPlnY2Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="nprodSalsPlnY2" /></td>
                      <td class="alignR"></td>
                      <td class="alignR" bgcolor='#E6E6E6'></td>
                      <td class="alignR"></td>
                      <td class="alignR" bgcolor='#E6E6E6'></td>
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
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                      <th class="alignC">변경 前</th>
                      <th class="alignC">변경 後</th>
                  </tr>
                  <tr id="trPtcCpsn" >
                      <th>투입인원(M/M)</th>
                      <td class="alignR"><span id="ptcCpsnYBefore"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="ptcCpsnY" /></td>
                      <td class="alignR"><span id="ptcCpsnY1Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="ptcCpsnY1" /></td>
                      <td class="alignR"><span id="ptcCpsnY2Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="ptcCpsnY2" /></td>
                      <td class="alignR"><span id="ptcCpsnY3Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="ptcCpsnY3" /></td>
                      <td class="alignR"><span id="ptcCpsnY4Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="ptcCpsnY4" /></td>
                  </tr>
                  <tr id="trExpArsl" >
                      <th>투입비용(억원)</th>
                      <td class="alignR"><span id="expArslYBefore" /></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="expArslY" /></td>
                      <td class="alignR"><span id="expArslY1Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="expArslY1" /></td>
                      <td class="alignR"><span id="expArslY2Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="expArslY2" /></td>
                      <td class="alignR"><span id="expArslY3Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="expArslY3" /></td>
                      <td class="alignR"><span id="expArslY4Before"/></td>
                      <td class="alignR" bgcolor='#E6E6E6'><span id="expArslY4" /></td>
                  </tr>
              </table>

              <table class="table table_txt_right">
                  <colgroup>
                    <col style="width: 20%;" />
                    <col style="width: 80%;" />
                </colgroup>
                <tr>
                    <th align="right">변경사유</th>
                    <td colspan="2">
                        <input type="text" id="altrRsonTxt" />
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="3">* 기타 변경사항은 아래 추가내용란에 입력하시기 바랍니다.</td>
                </tr>
                <tr>
                    <th align="right">추가사유</th>
                    <td colspan="2">
                        <input type="text" id="addRsonTxt" />
                    </td>
                </tr>
                <tr id="trALView" >
                    <th align="right">첨부파일</th>
                    <td  colspan="2" id="attchFileView"></td>
                </tr>


            </tbody>
        </table>
<div class="titArea btn_btm">
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <button type="button" id="btnList" name="btnList">목록</button>
    </div>
</div>
    </form>
</div>
</body>
</html>