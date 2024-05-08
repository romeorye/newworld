<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPlnPtcRsstMbrIfm.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.08
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */



 ** 운영반영시
 ** 가중치 validation 주석제거



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
    var lvTssCd    = window.parent.gvTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;

    var pageMode = (lvTssSt == "100" || lvTssSt == "" || lvTssSt == "302" ) && lvPageMode == "W" ? "W" : "R";

    var dataSet;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //담당연구원
        var chargeMbr = new Rui.ui.form.LCombo({
            name: 'chargeMbr',
            url: '<c:url value="/prj/tss/gen/retrieveChargeMbr.do?tssCd=' + lvTssCd + '"/>',
            displayField: 'mbrUserNm',
            valueField: 'mbrUserId',
            rendererField: 'value',
            autoMapping: true
        });
        chargeMbr.getDataSet().on('load', function(e) {
            console.log('chargeMbr :: load');
        });

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;

            butSchedule.hide();
            butSubSchedule.hide();
            butRecordDel.hide();
            btnSave.hide();

            grid.setEditable(false);
        };



        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'wbsDataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id:'tssCd' }      //과제코드
                , { id:'wbsSn' }      //WBS일련번호
                , { id:'tssNm' }      //WBS명
                , { id:'pidSn' }      //PID
                , { id:'depth', type: 'number', defaultValue: 0 }      //DEPTH
                , { id:'depthSeq', type: 'number' }    //순서
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
                , { id:'kwdTxt' }   //키워드
                , { id:'userId' }     //사용자ID
                , { id:'period' }     //기간
            ]
        });
        dataSet.on('update', function(e) {
            //과제기간 입력시 기간 자동계산
            if(e.colId == "strtDt" || e.colId == "fnhDt") {
                if(!Rui.isEmpty(e.record.data.strtDt) && !Rui.isEmpty(e.record.data.fnhDt)) {
                    var startDt = e.record.data.strtDt;
                    var fnhDt   = e.record.data.fnhDt;

                    if(!Rui.util.LDate.isDate(startDt)) startDt = e.record.data.strtDt.replace(/\-/g, "").toDate();
                    if(!Rui.util.LDate.isDate(fnhDt)) fnhDt = e.record.data.fnhDt.replace(/\-/g, "").toDate();

                    var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                    if(rtnValue <= 0) {
                        if(e.colId == "strtDt") dataSet.setNameValue(e.row, "strtDt", null);
                        if(e.colId == "fnhDt")  dataSet.setNameValue(e.row, "fnhDt", null);
                        dataSet.setNameValue(e.row, "period", "");
                        Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                        return;
                    } else {
                        dataSet.setNameValue(e.row, "period", rtnValue);
                    }
                }
            }
        });
        dataSet.on('load', function(e) {
            console.log("wbs load DataSet Success");

            if(dataSet.getCount() == 0) butSchedule.click();
        });

        //날짜 체크
        fnTssDateChk = function() {
            //과제기간과의 범위체크
            var pTssStartDt = window.parent.tmpTssStrtDd.replace(/\-/g, "").toDate();
            var pTssFnhDd   = window.parent.tmpTssFnhDd.replace(/\-/g, "").toDate();

            if(!(pTssStartDt instanceof Date)) pTssStartDt = pTssStartDt.replace(/\-/g, "").toDate();
            if(!(pTssFnhDd instanceof Date)) pTssFnhDd = pTssFnhDd.replace(/\-/g, "").toDate();

            pTssStartDt.setDate(pTssStartDt.getDate() - 1);
            pTssFnhDd.setDate(pTssFnhDd.getDate() + 1);

            var pStartDt;
            var pFnhDt;
            var pChildRows;
            var cStartDt;
            var cFnhDt;

            for(var i = 0; i < dataSet.getCount(); i++) {
                //상위레벨 날짜
                pStartDt = dataSet.getNameValue(i, "strtDt");
                pFnhDt   = dataSet.getNameValue(i, "fnhDt");

                if(!(pStartDt instanceof Date)) pStartDt = pStartDt.replace(/\-/g, "").toDate();
                if(!(pFnhDt instanceof Date)) pFnhDt = pFnhDt.replace(/\-/g, "").toDate();

                if(i == 0) {
                    //부모와 시작일비교
                    if(!fnDateBetweenCheck(pStartDt, pTssStartDt, pTssFnhDd, i)) return false;

                    //부모와 종료일비교
                    if(!fnDateBetweenCheck(pFnhDt, pTssStartDt, pTssFnhDd, i)) return false;
                }

                pStartDt.setDate(pStartDt.getDate() - 1);
                pFnhDt.setDate(pFnhDt.getDate() + 1);

                //하위레벨 날짜
                pChildRows = treeGridView.getChildRows(i);

                for(var j = 0; j < pChildRows.length; j++) {
                    cStartDt = dataSet.getNameValue(pChildRows[j], "strtDt");
                    cFnhDt   = dataSet.getNameValue(pChildRows[j], "fnhDt");

                    if(!(cStartDt instanceof Date)) cStartDt = cStartDt.replace(/\-/g, "").toDate();
                    if(!(cFnhDt instanceof Date)) cFnhDt = cFnhDt.replace(/\-/g, "").toDate();

                    //부모와 시작일비교
                    if(!fnDateBetweenCheck(cStartDt, pStartDt, pFnhDt, pChildRows[j])) return false;

                    //부모와 종료일비교
                    if(!fnDateBetweenCheck(cFnhDt, pStartDt, pFnhDt, pChildRows[j])) return false;
                }

                pStartDt.setDate(pStartDt.getDate() + 1);
                pFnhDt.setDate(pFnhDt.getDate() - 1);
            }

            return true;
        }

        //부모날짜와 비교
        fnDateBetweenCheck = function(cDt, pStartDt, pFnhDt, cRow) {
            if(!cDt.between(pStartDt, pFnhDt)) {
                pStartDt.setDate(pStartDt.getDate() + 1);
                pFnhDt.setDate(pFnhDt.getDate() - 1);

                Rui.alert("상위 과제기간의 범위를 벗어났습니다.<br/>일정명: "+dataSet.getNameValue(cRow, "tssNm"));
                return false;
            }
            return true;
        }


        //서버전송
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


        //유효성
        vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id:'tssCd',      validExp: '과제코드:false' }
                , { id:'wbsSn',      validExp: 'WBS일련번호:false' }
                , { id:'tssNm',      validExp: '일정명:true:maxLength=1000' }
                , { id:'pidSn',      validExp: 'PID:false' }
                , { id:'depth',      validExp: 'DEPTH:false' }
                , { id:'depthSeq',   validExp: '순서:false' }
                , { id:'strtDt',     validExp: '시작일:true' }
                , { id:'fnhDt',      validExp: '종료일:true' }
                , { id:'wgvl',       validExp: '가중치:false' }
                , { id:'saSabunNew', validExp: '담당자:true' }
                , { id:'vrfYn',      validExp: '검증:false' }
                , { id:'arslCd',     validExp: '실적코드:false' }
                , { id:'yldItmNm',   validExp: '산출물명:false' }
                , { id:'yldItmTxt',  validExp: '산출물내용:false' }
                , { id:'kwdTxt',     validExp: '키워드:false' }
                , { id:'userId',     validExp: '사용자ID:false' }
                , { id:'period',     validExp: '기간:false' }
            ]
        });


        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , { field: 'tssNm', label: '일정명', sortable: false, align:'left', width: 300, editor: new Rui.ui.form.LTextBox() , renderer: gridFontRenderer }
                , { field: 'period', label: '기간', sortable: false, align:'center', width: 50 }
                , { id: 'G1', label: '과제기간' }
                , { field: 'strtDt', label: '시작일', groupId: 'G1', sortable: false, align:'center', width: 120, editor: new Rui.ui.form.LDateBox()
                    , renderer: function(value, p, record) {
                        if(record.data.strtDt != null) {
                            var valDate = Rui.util.LFormat.stringToDate(record.data.strtDt, {format: '%x'});
                            return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
                        }
                        if(value!="") {
                            return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
                        }
                  } }
                , { field: 'fnhDt', label: '종료일', groupId: 'G1', sortable: false, align:'center', width: 120, editor: new Rui.ui.form.LDateBox()
                    , renderer: function(value, p, record) {
                        if(record.data.fnhDt != null) {
                            var valDate = Rui.util.LFormat.stringToDate(record.data.fnhDt, {format: '%x'});
                            return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
                        }
                        if(value!="") {
                            return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
                        }
                  } }
                , { field: 'wgvl', label: '가중치', sortable: false, align:'center', width: 70, editor: new Rui.ui.form.LNumberBox({maxValue:100}) }
                , { field: 'saSabunNew', label: '담당연구원', sortable: false, align:'center', width: 100, editor: chargeMbr  }
            ]
        });

        //그리드 트리
        var treeGridView = new Rui.ui.grid.LTreeGridView({
            defaultOpenDepth: 100,
            columnModel: columnModel,
            dataSet: dataSet,
            disabled: true,
            fields: {
                depthId: 'depth'
            },
            treeColumnId: 'tssNm'
        });

        var treeGridSelectionModel = new Rui.ui.grid.LTreeGridSelectionModel({
        });

        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            view: treeGridView,
            selectionModel: treeGridSelectionModel,
            width: 600,
            height: 400,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            usePasteCellEvent: true,
            useRightActionMenu: false
        });

        grid.on('pasteCell', function(e) {
            if(pageMode == "W") return;
            e.value = dataSet.getNameValue(e.row, e.colId);
        });

        grid.render('defaultGrid');



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //조회
        fnSearch = function() {
            dataSet.load({
                url: "<c:url value='/prj/tss/gen/retrieveGenTssPlnWBS.do'/>"
              , params : {
                    tssCd : lvTssCd
                }
            });
        };

        function gridFontRenderer(val, p, record, row, col) {

            if(record.get("depth")==0 || record.get("depth")==1){
                p.css.push('font-bold');
            }
            return val;
        }

        //일정등록
        var butSchedule = new Rui.ui.LButton('butSchedule');
        butSchedule.on('click', function() {
            if(dataSet.getCount() > 0) return;

            var row = dataSet.getRow();
            row = dataSet.newRecord();
            var record = dataSet.getAt(row);

            record.set("tssCd",    lvTssCd);   //과제코드
            record.set("userId",   lvUserId);  //사용자
            record.set("wbsSn",    record.id); //임시 wbsSn
            record.set("depthSeq", 1); //순서
            record.set("strtDt",   window.parent.tmpTssStrtDd.replace(/\-/g, "").toDate()); //시작일
            record.set("fnhDt",    window.parent.tmpTssFnhDd.replace(/\-/g, "").toDate());  //종료일
            record.set("wgvl",     "100"); //가중치
            record.set("tssNm",    window.parent.tssNm);  //제목
            record.set("arslCd",   "0"); //실적

            defaultSubSchedule();
        });

        defaultSubSchedule = function(){
            //부모 row
            var row = dataSet.getRow();

            if(row < 0) return;
            if(dataSet.getState(row) == 3) return;

            var depth = dataSet.getNameValue(row, "depth");
            var wbsSn = dataSet.getNameValue(row, "wbsSn");

            if(depth >= 4) return;

            var childRows = []; //child row 배열
            var childLen  = 0;  //child row 배열의 위치
            var allRow = treeGridView.getAllChildRows(row); //체크된 row의 child row
            var tssNm = "";


            for(var j = 1; j < 4; j++) {
                newChildRow = row + j;
              //자식 row
                var newRow = dataSet.newRecord(newChildRow);
                var record = dataSet.getAt(newRow);

                record.set("tssCd",  lvTssCd);   //과제코드
                record.set("userId", lvUserId);  //사용자
                record.set("wbsSn",  record.id); //임시 wbsSn
                record.set("pidSn",  1);     //부모 wbsSn
                record.set("depth",  depth + 1); //depth
                record.set("arslCd", "0");       //실적

                if ( j == 1 ){
                    tssNm= "제품/공정설계";
                }else if ( j == 2 ){
                    tssNm= "제품성능검증";
                }else if ( j == 3 ){
                    tssNm= "양산성검증";
                }
                  record.set("tssNm",  tssNm);  //제목
                treeGridView.expand(newChildRow);
            }
        }


        //하위일정등록
        var butSubSchedule = new Rui.ui.LButton('butSubSchedule');
        butSubSchedule.on('click', function() {

            //부모 row
            var row = dataSet.getRow();

            if(row < 0) return;
            if(dataSet.getState(row) == 3) return;

            var depth = dataSet.getNameValue(row, "depth");
            var wbsSn = dataSet.getNameValue(row, "wbsSn");

            if(depth >= 4) return;

            var childRows = []; //child row 배열
            var childLen  = 0;  //child row 배열의 위치
            var allRow = treeGridView.getAllChildRows(row); //체크된 row의 child row

            for(var j = 0; j < allRow.length; j++) {
                childRows[childLen++] = allRow[j];
            }

            var newChildRow = row + childRows.length;

            //자식 row
            var newRow = dataSet.newRecord(newChildRow + 1);
            var record = dataSet.getAt(newRow);

            record.set("tssCd",  lvTssCd);   //과제코드
            record.set("userId", lvUserId);  //사용자
            record.set("wbsSn",  record.id); //임시 wbsSn
            record.set("depth",  depth + 1); //depth
            record.set("pidSn",  wbsSn);     //부모 wbsSn
            record.set("arslCd", "0");       //실적

            treeGridView.expand(newChildRow);
        });


        //삭제
        var butRecordDel = new Rui.ui.LButton('butRecordDel');
        butRecordDel.on('click', function() {
            var chkObj = dataSet.getMarkedRange(); //체크된 객체
            if(chkObj.length <= 0) {
                Rui.alert("체크된 데이터가 없습니다.");
                return;
            }

            var chkObj = dataSet.getMarkedRange(); //체크된 객체
            var childRows = []; //child row 배열
            var childLen  = 0;  //child row 배열의 위치

            var chkRow; //체크된 row
            var allRow; //체크된 row의 child row

            //체크된 row의 child row를 구함
            for(var i = 0; i < chkObj.length; i++) {
                chkRow = dataSet.indexOfKey(chkObj.keys[i]);   //체크된 row
                allRow = treeGridView.getAllChildRows(chkRow); //체크된 row의 child row

                for(var j = 0; j < allRow.length; j++) {
                    childRows[childLen++] = allRow[j];
                }
            }

            //child row들을 체크
            for(var i = 0; i < childRows.length; i++) {
                dataSet.setMark(childRows[i], true);
            }

            //체크된 row를 삭제
            if(dataSet.getMarkedCount() > 0) {
                dataSet.removeMarkedRows();
            }
        });


        //저장
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

            if(!vm.validateDataSet(dataSet, dataSet.getRow())) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return false;
            }

            if(!fnTssDateChk()) return; //날짜체크

            if(!checkValidation("wgvl")) return; //가중치확인


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

        //간트차트
        if($("#butChart").length > 0){ //[20240411.siseo]id 존재여부 체크 추가
            var butChart = new Rui.ui.LButton('butChart');
            butChart.on('click', function() {
                 var args = new Object();
                 var url =  contextPath + "/prj/tss/gen/genWbsGanttChartPopup.do?" + "&tssCd="  +  lvTssCd ;

                 if(dataSet.getCount() > 0) {
                     nwinsOpenModal(url, args, 1200, 520 , 0);
                 } else {
                      Rui.alert('조회된 데이타가 없습니다.');
                 }
            });
        }

        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("wbs searchData1");
            dataSet.loadData(${result});
        } else {
            console.log("wbs searchData2");
            butSchedule.click();
        }

        if(!window.parent.isEditable) {
            //버튼 비활성화 셋팅
            disableFields();
        }

        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
            $("#butSchedule").hide();
            $("#butSubSchedule").hide();
            $("#butRecordDel").hide();
            $("#btnSave").hide();
        }else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
            $("#butSchedule").hide();
            $("#butSubSchedule").hide();
            $("#butRecordDel").hide();
            $("#btnSave").hide();
        }

    });

    //validation
    function fnIfmIsUpdate(gbn) {
        if(!vm.validateDataSet(dataSet, dataSet.getRow())) {
            Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
            return false;
        }

        if(dataSet.isUpdated()) {
            Rui.alert("WBS 탭 저장을 먼저 해주시기 바랍니다.");
            return false;
        }

        return true;
    }
</script>
<script>
// 저장시 validation 체크 * gbn : switch를 위한 구분값
function checkValidation(gbn) {

    var returnCd = true;

    switch(gbn) {
    case "wgvl":
        var depthSum = [0, 0, 0, 0, 0]; //depth별 합계
        var depthUse = [false, false, false, false, false]; //depth 사용여부

        var finalDepth = 0; //최종depth

        var resultCd  = true;
        var resultMsg = "";

        var dsTotalCnt = dataSet.getCount();
        for(var i = 0; i < dsTotalCnt; i++) {

            if(dataSet.getState(i) == 3) continue;

            var depth0 = dataSet.getNameValue(i, "depth");
            var wgvl   = dataSet.getNameValue(i, "wgvl");  //현재 가중치
            wgvl = Rui.isEmpty(wgvl) == true ? 0 : wgvl;

            if(0 == depth0) {

                for(var k = 0; k < 5; k++) {
                    if(depthUse[k] && depthSum[k] != 100) {
                        resultCd  = false;
                        resultMsg = k;
                        break;
                    }
                }

                depthSum = [0, 0, 0, 0, 0];
                depthUse = [false, false, false, false, false];

                finalDepth = 0;

                depthSum[0] = wgvl;
                depthUse[0] = true;

                for(var j = i + 1; j < dsTotalCnt; j++) {

                    if(dataSet.getState(j) == 3) continue;

                    var depth = dataSet.getNameValue(j, "depth"); //현재 depth
                    var wgvl  = dataSet.getNameValue(j, "wgvl");  //현재 가중치
                    wgvl = Rui.isEmpty(wgvl) == true ? 0 : wgvl;

                    if(depth == 0) break;

                    depthSum[depth] = depthSum[depth] + wgvl;
                    depthUse[depth] = true;

                    if(depth < finalDepth) {
                        for(var k = depth + 1; k <= finalDepth; k++) {
                            if(depthSum[k] == 100) {
                                depthSum[k] = 0;
                                depthUse[k] = false;
                            } else {
                                resultCd  = false;
                                resultMsg = k;
                                break;
                            }
                        }
                    }

                    finalDepth = depth;
                }
            }

            if(!resultCd) break;
        }

        for(var k = 0; k < 5; k++) {
            if(depthUse[k] && depthSum[k] != 100) {
                resultCd  = false;
                resultMsg = k;
                break;
            }
        }

        if(resultMsg != "" || !resultCd) {
            Rui.alert(resultMsg + "레벨 가중치를 확인해 주시기 바랍니다.");
            returnCd = resultCd;
        }

        break;
    default:
        break;
    }

    return returnCd;
}
$(window).load(function() {
    initFrameSetHeight();
});
</script>
</head>
<body>
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="butSchedule" name="">일정등록</button>
        <button type="button" id="butSubSchedule" name="">하위일정등록</button>
        <button type="button" id="butRecordDel" name="">일정삭제</button>
        <!-- <button type="button" id="butChart" name="">간트차트보기</button> -->
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
<div class="titArea btn_btm">
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>