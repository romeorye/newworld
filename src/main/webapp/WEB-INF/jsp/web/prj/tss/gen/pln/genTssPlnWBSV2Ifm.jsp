<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPlnWBSV2Ifm.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2024.11.18  siseo       WBS 입력 운영 방식 전환 (정근책임 요청)
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTreeGridSelectionModel.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTreeGridView-debug.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTreeGridView.css"/>
<style>
.font-bold div{
    font-weight: bold;
}
</style>

<script type="text/javascript">
    var lvWbsCd    = window.parent.gvWbsCd;
    var lvTssCd    = window.parent.gvTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;
    var wbsClsRsltCd;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "" || lvTssSt == "302" ) && lvPageMode == "W" ? "W" : "R";

    var dataSet;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/

        //WBS마감결과코드
        var wbsClsRsltCdCombo = new Rui.ui.form.LCombo({
            name: 'wbsClsRsltCd',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=WBS_CLS_RSLT_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            emptyText: '(선택)',
            rendererField: 'value',
            autoMapping: true
        });
        wbsClsRsltCdCombo.getDataSet().on('load', function(e) {
            console.log('wbsClsRsltCd :: load');
        });
        
        //Form 비활성화
        disableFields = function() {
            
            if(pageMode == "W") return;

            btnSave.hide();
            butRecordNew.hide();
            butRecordDel.hide();

            grid.setEditable(false);
        };
       
        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'wbsDataSet',
            remainRemoved: true, //삭제시 삭제건으로 처리하지 않고 state만 바꾼다.
            lazyLoad: true, //대량건의 데이터를 로딩할 경우 timer로 처리하여 ie에서 스크립트 로딩 메시지가 출력하지 않게 한다.
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id:'tssCd' }      //과제코드
                , { id:'wbsSn' }      //WBS일련번호
                , { id:'wbsCd' }      //WBS코드
                , { id:'tssNm' }      //과제명
                , { id:'pidSn' }      //PID
                , { id:'depth', type: 'number', defaultValue: 0 }      //DEPTH
                , { id:'depthSeq', type: 'number' } //순서
                , { id:'strtDt', type: 'date' }     //시작일
                , { id:'fnhDt', type: 'date' }      //종료일
                , { id:'oldStrtDt' }     //시작일
                , { id:'oldFnhDt' }      //종료일
                , { id:'wgvl', type: 'number' }       //가중치
                , { id:'saSabunNew' } //담당자
                , { id:'vrfYn' }      //검증
                , { id:'arslCd' }     //실적코드
                , { id:'yldItmNm' }   //산출물명
                , { id:'yldItmTxt' }  //산출물내용
                , { id:'kwdTxt' }     //키워드
                , { id:'userId' }     //사용자ID
                , { id:'period' }     //기간

                , { id:'qrtMlstGoalTxt' }   //분기마일스톤
                , { id:'monthGoalTxt' }     //월별목표
                , { id:'wbsGoalDd', type: 'date' }        //WBS목표일자
                , { id:'wbsClsRsltCd' }     //WBS마감결과코드
            ]
        });
        dataSet.on('load', function(e) {
            console.log("mbr load DataSet Success");
        });
        
        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'wbsCd', label: '과제코드', sortable: false, align:'center', width: 100
                    , renderer: function(value, p, record) {
                        return window.parent.gvWbsCd;
                    } }
                , { field: 'tssNm', label: '과제명', sortable: false, align:'left', width: 200
                    , renderer: function(value, p, record) {
                        return window.parent.tssNm;
                    } }
                , { field: 'qrtMlstGoalTxt', label: '분기마일스톤', sortable: false, align:'left', width: 200, editor: new Rui.ui.form.LTextBox() }
                , { field: 'monthGoalTxt', label: '중간목표', sortable: false, align:'left', width: 200, editor: new Rui.ui.form.LTextBox() }
                , { field: 'wbsGoalDd', label: '목표일정', sortable: false, align:'center', width: 120, editor: new Rui.ui.form.LDateBox()
                    , renderer: function(value, p, record) {
                        if(record.data.wbsGoalDd != null) {
                            var valDate = Rui.util.LFormat.stringToDate(record.data.wbsGoalDd, {format: '%x'});
                            return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
                        }
                        if(value!="") {
                            return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
                        }
                  } }
                , { field: 'wbsClsRsltCd', label: '마감결과', sortable: false, align:'left', width: 120, editor: wbsClsRsltCdCombo
                    , renderer: function(val, p, record, row, col){
                        //console.log("[val]",val, "[p]",p, "[record]",record, "[row]",row, "[col]",col, record.data.wbsClsRsltCd);
                        /////record.data.wbsClsRsltCd == '30' ? butRecordInsert.click() : '';
                        return val; }
                }
            ]
        });
        
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 400,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            usePaste: false,
            useRightActionMenu: false
        });
        grid.on('popup', function(e) {
            if((lvTssSt == "100" || lvTssSt == "" || lvTssSt == "302" || lvTssSt == "102") && pageMode == "W") {
                popupRow = e.row;
                openUserSearchDialog(setGridUserInfo, 1, '');
            }
        });
        grid.render('defaultGrid');
        
        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            Rui.alert(data.records[0].rtVal);
            
            if(data.records[0].rtCd == "SUCCESS") {
                fnSearch();
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });
        
        //유효성 설정
        vm = new Rui.validate.LValidatorManager({
            validators: [  
                    { id: 'tssCd',            validExp: '과제코드:true' }
                  , { id: 'wbsSn',            validExp: 'WBS일련번호:true' }
                  , { id: 'pidSn',            validExp: 'PID:false' }
                  , { id: 'depth',            validExp: 'DEPTH:false' }
                  , { id: 'depthSeq',         validExp: '순서:false' }
                  , { id: 'wbsGoalDd',        validExp: '목표일정:true' }
            ]
        });
        
        
        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //조회
        fnSearch = function() {
            dataSet.load({ 
                url: "<c:url value='/prj/tss/gen/retrieveGenTssPlnWBS.do'/>"
              , params : {
                    tssCd : lvTssCd,
                    wbsCd : lvWbsCd
                }
            });
        };
        
        //추가
        if($("#butRecordNew").length > 0){
            var butRecordNew = new Rui.ui.LButton('butRecordNew');
            butRecordNew.on('click', function() {
                var row = dataSet.newRecord();
                var record = dataSet.getAt(row);
                
                record.set("tssCd",    lvTssCd);   //과제코드
                record.set("userId",   lvUserId);  //사용자
                record.set("wbsSn",    record.id); //임시 wbsSn
                record.set("depthSeq", 1); //순서
            });
        }
        
        //삽입
        if($("#butRecordInsert").length > 0){
            var butRecordInsert = new Rui.ui.LButton('butRecordInsert');
            butRecordInsert.on('click', function(){
                if(dataSet.getRow() < 0) return;
                var rowBef = dataSet.getAt(dataSet.getRow());
                console.log("[rowBef]", rowBef)
                var lvWbsGoalDd = rowBef.get("wbsGoalDd");
                var row = dataSet.newRecord(dataSet.getRow()+1);
                if (rowBef !== false && row !== false) {
                    var record = dataSet.getAt(row);
                    record.set("tssCd",    lvTssCd);   //과제코드
                    record.set("userId",   lvUserId);  //사용자
                    record.set("wbsSn",    record.id); //임시 wbsSn
                    record.set("depthSeq", rowBef.get("depthSeq")+1); //순서
                    record.set('qrtMlstGoalTxt', rowBef.get("qrtMlstGoalTxt"));
                    record.set('monthGoalTxt', rowBef.get("monthGoalTxt"));
                    (!Rui.isEmpty(lvWbsGoalDd))?record.set('wbsGoalDd', lvWbsGoalDd.replace(/\-/g, "").toDate()):"";
                }
            });
        }
        
        //삭제
        if($("#butRecordDel").length > 0){
            var butRecordDel = new Rui.ui.LButton('butRecordDel');
            butRecordDel.on('click', function() {
                var chkObj = dataSet.getMarkedRange(); //체크된 객체
                if(chkObj.length <= 0) {
                    Rui.alert("체크된 데이터가 없습니다.");
                    return;
                }

                for(var i = 0; i < dataSet.getCount(); i++) {
                     dataSet.setNameValue(i, 'tssCd', lvTssCd );
                }
                Rui.confirm({
                    text: Rui.getMessageManager().get('$.base.msg107'),
                    handlerYes: function() {
                        //실제 DB삭제건이 있는지 확인
                        var dbCallYN = false;
                        var chkRows = dataSet.getMarkedRange().items;
                        for(var i = 0; i < chkRows.length; i++) {
                            if(stringNullChk(chkRows[i].data.ptcRsstMbrSn) != "") {
                                //dbCallYN = true;
                                break;
                            }
                        }
                        
                        if(dataSet.getMarkedCount() > 0) {
                            dataSet.removeMarkedRows();
                        } else {
                            var row = dataSet.getRow();
                            if(row < 0) return;
                            dataSet.removeAt(row);
                        }
                        /* if(dbCallYN) {
                            //삭제된 레코드 외 상태 정상처리
                            for(var i = 0; i < dataSet.getCount(); i++) {
                                if(dataSet.getState(i) != 3) dataSet.setState(i, Rui.data.LRecord.STATE_NORMAL);
                            }
                        
                            dm.updateDataSet({
                                url:'<c:url value="/prj/tss/gen/deleteGenTssPlnPtcRsstMbr.do"/>',
                                dataSets:[dataSet]
                            });
                        } */
                    },
                    handlerNo: Rui.emptyFn
                });
            });
        }
        
        //저장
        if($("#btnSave").length > 0){
            var btnSave = new Rui.ui.LButton('btnSave');
            btnSave.on('click', function() {
                if( dataSet.getCount() <  2  ) {
                    Rui.alert("WBS 항목을 등록하셔야 합니다.");
                    return;
                }

                if(!dataSet.isUpdated()) {
                    Rui.alert("변경된 데이터가 없습니다.");
                    return;
                }

                if(!vm.validateDataSet(dataSet)) {
                    Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                    return false;
                }

                var wbsSort = 1;
                for(var i = 0; i < dataSet.getCount(); i++) {
                	if(dataSet.getState(i) != 3) {
                        dataSet.setNameValue(i, "depthSeq", wbsSort++);
                    }
                }

                //if(!fnTssDateChk()) return; //날짜체크

                //if(!checkValidation("wgvl")) return; //가중치확인

                Rui.confirm({
                    text: '저장하시겠습니까?',
                    handlerYes: function() {

                        //depthSeq셋팅
                        var wbsSort = 1;
                        for(var i = 0; i < dataSet.getCount(); i++) {
                            if(dataSet.getState(i) != 3) {
                                dataSet.setNameValue(i, "depthSeq", wbsSort++);
                            }
                        }

                        dm.updateDataSet({
                            url:'<c:url value="/prj/tss/gen/updateGenTssPlnWBS.do"/>',
                            dataSets:[dataSet]
                        });
                    },
                    handlerNo: Rui.emptyFn
                });
            });
        }
        
        /*
        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
 */

        //엑셀다운
        if($("#butExcel").length > 0){
            var butExcel = new Rui.ui.LButton('butExcel');
            butExcel.on('click', function() {
                if(dataSet.getCount() > 0) {
                    grid.saveExcel(toUTF8('과제관리_연구팀과제_WBS_') + new Date().format('%Y%m%d') + '.xls');
                } else {
                    Rui.alert('조회된 데이타가 없습니다.');
                }
            });
        }
        
        //데이터 셋팅
        if(${resultCnt} > 0) { 
            console.log("mbr searchData1");
            dataSet.loadData(${result}); 
        } else {
            console.log("mbr searchData2");
        }

        if(!window.parent.isEditable) {
            //버튼 비활성화 셋팅
            disableFields();
        }
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1 || "<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
            $("#butRecordNew").hide();
            $("#butRecordDel").hide();
            $("#btnSave").hide();
        }
    });
    
    //validation
    function fnIfmIsUpdate(gbn) {
        if(!vm.validateDataSet(dataSet)) { 
            Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
            return false;
        }
        
        if(dataSet.isUpdated()) {
            Rui.alert("참여연구원 탭 저장을 먼저 해주시기 바랍니다.");
            return false;
        }
        
        return true;
    }
</script>
<script>
//연구원팝업 셋팅
function setGridUserInfo(userInfo) {
    dataSet.setNameValue(popupRow, "saSabunNew", userInfo.saSabun);
    dataSet.setNameValue(popupRow, "saUserName", userInfo.saName);
    dataSet.setNameValue(popupRow, "deptCode", userInfo.deptCd);
    dataSet.setNameValue(popupRow, "deptName", userInfo.deptName);
}
$(window).load(function() {
    initFrameSetHeight("formDiv");
}); 
</script>
</head>
<body style="overflow: hidden">
<div id="formDiv">
    <div class="titArea">
        <div class="LblockButton">
            <button type="button" id="butRecordNew">추가</button>
            <button type="button" id="butRecordInsert">삽입</button>
            <button type="button" id="btnSave" name="btnSave">저장</button>
            <button type="button" id="butRecordDel">삭제</button>
            <button type="button" id="butExcel" name="">Excel다운로드</button>
        </div>
    </div>
    <div id="wbsFormDiv">
        <form name="wbsForm" id="wbsForm" method="post">
            <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
            <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        </form>
        <div id="defaultGrid"></div>
    </div>
    <br/>
</div>
</body>
</html>
