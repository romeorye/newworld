<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPgsWBSIfm.jsp
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
 ** 산출물내용 or 첨부파일 등록  주석제거




--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTreeGridSelectionModel.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTreeGridView-debug.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTreeGridView.css"/>
<style>
.font-color-red div {
    color: red;
}

.font-bold div{
    font-weight: bold;
}
</style>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd    = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt    = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    var lvPrateReal = window.parent.progressrateReal;
    var lvPrate     = window.parent.progressrate;
    var pageMode = lvPgsCd == "PG" || lvPgsCd == "CM" || lvPgsCd == "DC" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";

    var dataSet;
    var popupRow;
    var popupRecord;
    var lvSabun = "${inputData._userSabun}";
    var lvArslCdRow;
    var lvMbrRow;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //담당연구원
        chargeMbr = new Rui.ui.form.LCombo({
            name: 'chargeMbr',
            url: '<c:url value="/prj/tss/gen/retrieveChargeMbr.do?tssCd=' + lvTssCd + '"/>',
            displayField: 'mbrUserNm',
            valueField: 'mbrUserId',
            rendererField: 'value',
            autoMapping: true
        });

        //실적코드
        arslCd = new Rui.ui.form.LCombo({
            name: 'arslCd',
            autoMapping: true,
            useEmptyText: true,
            rendererField: 'value',
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ARSL_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD'
        });
        arslCd.on('changed', function(e) {
            var record = dataSet.getAt(lvArslCdRow);
            var pDepth = record.get("depth"); //뎁스
            var pPidSn = record.get("pidSn"); //부모의 ID

            var parentRow    = 0;
            var parentPid    = 0;
            var pChildWgvl   = 0;
            var pChildArslCd = 0;
            var pSumArsl     = 0;

            for(var j = pDepth; j > 0; j--) {
                for(var i = 0; i < dataSet.getCount(); i++) {
                    //부모row
                    if(dataSet.getNameValue(i, "wbsSn") == pPidSn) {
                        parentRow = i;
                        parentPid = dataSet.getNameValue(i, "pidSn");
                    }
                    //동일한 부모를 갖는 자식row
                    if(dataSet.getNameValue(i, "pidSn") == pPidSn) {
                        pChildWgvl = stringNullChk(dataSet.getNameValue(i, "wgvl"));
                        pChildWgvl = pChildWgvl == "" ? 0 : pChildWgvl;

                        if(lvArslCdRow == i) {
                            pChildArslCd = stringNullChk(e.value) == "" ? 0 : parseInt(e.value);
                        } else {
                            pChildArslCd = stringNullChk(dataSet.getNameValue(i, "arslCd"));
                            pChildArslCd = pChildArslCd == "" ? 0 : pChildArslCd;
                        }

                        pSumArsl += pChildWgvl * pChildArslCd / 100;
                    }
                }

                dataSet.setNameValue(parentRow, "arslCd", Math.round(pSumArsl * 100) / 100);

                pPidSn = parentPid;
                pSumArsl = 0;
            }
        });

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "R") {
                $("#btnSave").hide();

                grid.setEditable(false);
            }

            var pRate = "";
            if(lvPrate == "N") pRate = "정상";
            else if(lvPrate == "S") pRate = "단축";
            else if(lvPrate == "D") pRate = "지연";

            document.getElementById('progressRate').innerHTML = "<B>진척율(실적/계획) : " + lvPrateReal + ",   상태: " + pRate+"</B>";
        };



        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'wbsDataSet',
            remainRemoved: false,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id:'tssCd' }      //과제코드
                , { id:'userId' }     //사용자ID
                , { id:'wbsSn' }      //WBS일련번호
                , { id:'tssNm' }      //WBS명
                , { id:'pidSn' }      //PID
                , { id:'depth', type: 'number', defaultValue: 0 }      //DEPTH
                , { id:'depthSeq', type: 'number' }    //순서
                , { id:'strtDt'}     //시작일
                , { id:'fnhDt' }      //종료일
                , { id:'oldStrtDt' }     //시작일
                , { id:'oldFnhDt' }      //종료일
                , { id:'wgvl', type: 'number' }       //가중치
                , { id:'saSabunNew' } //담당자
                , { id:'vrfYn' }      //검증
                , { id:'arslCd' }     //실적코드
                , { id:'yldItmNm' }   //산출물명
                , { id:'yldItmTxt' }  //산출물내용
                , { id:'kwdTxt' }     //키워드
                , { id:'period' }     //기간
                , { id:'delay' }     //기간
                , { id:'attcFilId' }  //파일ID
                , { id:'attcFilNm' }  //파일이름
                , { id:'yldItmTxtLen' }
                , { id:'orgArslCd' }
                , { id:'orgAttcFilCnt' }
                , { id:'attcFilCnt' }
                , { id:'saSabunNewNm' }
            ]
        });
        dataSet.on('update', function(e) {
        });
        dataSet.on('load', function(e) {
            console.log("wbs load DataSet Success");
        });


        function gridFontRenderer(val, p, record, row, col) {
            if(record.data.saSabunNew == lvSabun) {
                p.css.push('font-color-red');
            } else {
                p.css.pop('font-color-red');
            }

            if(record.get("depth")==0 || record.get("depth")==1){
                p.css.push('font-bold');
            }
            return val;
        }


        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LStateColumn()
                , { field: 'tssNm', label: '일정명', sortable: false, renderRow: true, align:'left', width: 300, renderer: gridFontRenderer }
                , { field: 'period', label: '기간', sortable: false, renderRow: true, align:'center', width: 50, renderer: gridFontRenderer }
                , { id: 'G1', label: '과제기간' }
                , { field: 'strtDt', label: '시작일', groupId: 'G1', sortable: false, renderRow: true, align:'center', width: 120, renderer: gridFontRenderer }
                , { field: 'fnhDt', label: '종료일', groupId: 'G1', sortable: false, renderRow: true, align:'center', width: 120, renderer: gridFontRenderer }
                , { field: 'wgvl', label: '가중치', sortable: false, renderRow: true, align:'center', width: 60, editor: new Rui.ui.form.LNumberBox({maxValue:100}), renderer: gridFontRenderer }
                , { field: 'saSabunNewNm', label: '담당연구원', sortable: false, renderRow: true, align:'center', width: 100
                    , renderer: function(value, p, record, row, col) {
                        p.editable = false;

                        if(record.data.saSabunNew == lvSabun) p.css.push('font-color-red');
                        else p.css.pop('font-color-red');

                        if(record.get("depth") == 0 || record.get("depth") == 1) p.css.push('font-bold');

                        return value;
                  } }
                , { field: 'arslCd', label: '실적', sortable: false, renderRow: true, align:'center', width: 70, editor: arslCd
                    , renderer: function(value, p, record, row, col) {
                        p.editable = false;

                        if(record.data.saSabunNew == lvSabun) p.css.push('font-color-red');
                        else p.css.pop('font-color-red');

                        return record.data.arslCd;
                  } }
                , { field: 'delay', label: '지연', sortable: false, renderRow: true, align:'center', editable : false, width: 60
                     , renderer: function(value, p, record, row, col) {
                         if ( record.get("depth") == 2 ||  record.get("depth") == 3){
                             if( value < 0 ){
                                 value =0;
                             }
                         }else{
                                 value =0;
                         }

                         return value;
                }}
                , { field: 'yldItmNm', label: '산출물명', sortable: false, renderRow: true, align:'left', width: 200, renderer: Rui.util.LRenderer.popupRenderer() }
            ]
        });

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

        var rowModel = new Rui.ui.grid.LRowModel({
        });


        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            view: treeGridView,
            selectionModel: treeGridSelectionModel,
            rowModel: rowModel,
            width: 600,
            height: 400,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });
        grid.on('popup', function(e) {
            popupRow = e.row;
            popupRecord = dataSet.getAt(popupRow).data;

//             if(treeGridView.getAllChildRows(popupRow).length > 0) {
//                 return;
//             }

            openYldItmDialog();
        });
        grid.on('cellClick', function(e) {
            if(e.colId == "arslCd") {
                var childRows = treeGridView.getAllChildRows(e.row); //체크된 row의 child row

                //자식노드가 없으면 에디터 가능
                if(childRows.length <= 0) {
                    lvArslCdRow = e.row;
                    e.target.columnModel.setCellConfig(e.row, e.col, 'editable', true);
                }
                else if(e.colId == "saSabunNew") {
                    lvMbrRow = e.row;
                }
            }
        });
        grid.render('defaultGrid');


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


        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id:'tssCd',       validExp: '과제코드:false' }
                , { id:'userId',      validExp: '사용자ID:false' }
                , { id:'wbsSn',       validExp: 'WBS일련번호:false' }
                , { id:'tssNm',       validExp: '일정명:true:maxLength=1000' }
                , { id:'pidSn',       validExp: 'PID:false' }
                , { id:'depth',       validExp: 'DEPTH:false' }
                , { id:'depthSeq',    validExp: '순서:false' }
                , { id:'strtDt',      validExp: '시작일:true' }
                , { id:'fnhDt',       validExp: '종료일:true' }
                , { id:'wgvl',        validExp: '가중치:false' }
                , { id:'saSabunNew',  validExp: '담당자:false' }
                , { id:'vrfYn',       validExp: '검증:false' }
                , { id:'arslCd',      validExp: '실적코드:false' }
                , { id:'yldItmNm',    validExp: '산출물명:false:maxLength=1000' }
                , { id:'yldItmTxt',   validExp: '산출물내용:false' }
                , { id:'kwdTxt',      validExp: '키워드:false' }
                , { id:'period',      validExp: '기간:false' }
                , { id:'attcFilId',   validExp: '파일ID:false' }
                , { id:'attcFilNm',   validExp: '파일이름:false' }
            ]
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //팝업: 산출물
        var handleSubmit = function() {
            this.submit(true);
        };

        yldItmDialog = new Rui.ui.LFrameDialog({
            id: 'yldItmDialog',
            title: '산출물등록',
            width: 700,
            height: 430,
            modal: true,
            visible: false,
            buttons: [
                { text: '적용', handler: handleSubmit, isDefault: true },
                { text: '닫기', handler: function() {
                    this.cancel();
                } }
            ]
        });

        yldItmDialog.on('submit', function(e) {
            var yldPop = yldItmDialog.getFrameWindow();

            dataSet.setNameValue(popupRow, "yldItmNm",  yldPop.yldItmNm.getValue());  //산출물명
            dataSet.setNameValue(popupRow, "yldItmTxt", yldPop.yldItmTxt.getValue()); //산출물내용
            dataSet.setNameValue(popupRow, "kwdTxt",    yldPop.kwdTxt.getValue());    //키워드
            dataSet.setNameValue(popupRow, "attcFilId", yldPop.attcFilId.getValue()); //첨부파일
            dataSet.setNameValue(popupRow, "attcFilCnt", yldPop.lvAttcFilCnt);
        });

        yldItmDialog.render(document.body);

        openYldItmDialog = function() {
            if(pageMode == "R") {
                yldItmDialog.setButtons([
                    { text: '닫기', handler: function() {
                        this.cancel();
                    }}
                ]);
            }

            yldItmDialog.setUrl('<c:url value="/prj/tss/gen/genTssPgsWBSYldPop.do?tssCd="/>' + lvTssCd);
            yldItmDialog.show();
        };


        //첨부파일 등록 팝업
        openYldAttcDialog = function() {
            openAttachFileDialog(setAttachFileInfo, yldItmDialog.getFrameWindow().getAttachFileId(), 'prjPolicy', '*');
        }

        setAttachFileInfo = function(attachFileList) {
            yldItmDialog.getFrameWindow().setAttachFileInfo(attachFileList);
        };


        //조회
        fnSearch = function() {
            dataSet.load({
                url: "<c:url value='/prj/tss/gen/retrieveGenTssPgsWBS.do'/>"
              , params : {
                    tssCd : lvTssCd
                }
            });
        };


        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            if(!vm.validateDataSet(dataSet, dataSet.getRow())) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return false;
            }

            if( dataSet.getCount() <  2  ) {
                Rui.alert("WBS 항목을 등록하셔야 합니다.");
                return;
            }

            for(var i = 0; i < dataSet.getCount(); i++) {
                //실적에 값이 있을 경우
                if(stringNullChk(dataSet.getNameValue(i, "arslCd")) != "") {
                    //마지막 노드일 경우
                    if(treeGridView.getAllChildRows(i).length <= 0) {
//                         //산출물 또는 첨부파일 공백
//                         if(stringNullChk(dataSet.getNameValue(i, "yldItmTxt")) == "" && stringNullChk(dataSet.getNameValue(i, "attcFilId")) == "") {
//                             Rui.alert((i+1)+" row => 산출물내용 또는 첨부파일을 등록하시기 바랍니다.");
//                             return false;
//                         }

                        //변경 데이터시 validate
                        if(parseInt(dataSet.getNameValue(i, "arslCd")) > parseInt(dataSet.getNameValue(i, "orgArslCd"))) {
                            var bfLen = parseInt(dataSet.getNameValue(i, "yldItmTxtLen"));
                            var afLen = stringNullChk(dataSet.getNameValue(i, "yldItmTxt")) == "" ? 0 : dataSet.getNameValue(i, "yldItmTxt").length;
                            var bfCnt = dataSet.getNameValue(i, "orgAttcFilCnt");
                            var afCnt = dataSet.getNameValue(i, "attcFilCnt");

                            if(bfLen + 100 >= afLen && bfCnt >= afCnt) {
                                Rui.alert((i+1)+" row => 산출물내용을 이전내용보다 100자 이상 입력하거나 첨부파일을 추가해 주시기 바랍니다.");
                                return false;
                            }
                        }
                    }
                }
            }


            if(!dataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }

            if(!checkValidation("wgvl")) return; //가중치확인
//             if(!checkValidation("wgvl")) {}

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                dm.updateDataSet({
                    url:'<c:url value="/prj/tss/gen/updateGenTssPgsWBS.do"/>',
                    dataSets:[dataSet]
                });
                },
                handlerNo: Rui.emptyFn
            });
        });


        //간트차트
        if($("#butChart").length > 0){ //[20240411.siseo]id 존재여부 체크 추가
            var butChart = new Rui.ui.LButton('butChart');
            butChart.on('click', function() {
                 var args = new Object();
                 var url =  contextPath + "/prj/tss/gen/genWbsGanttChartPopup.do?"
                         + "&tssCd="    +  lvTssCd ;
                      if(dataSet.getCount() > 0) {
                     nwinsOpenModal(url, args, 1200, 600);

                     }else{
                          Rui.alert('조회된 데이타가 없습니다.');
                     }
            });
        }


        //목록
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
         */

        //엑셀다운
        if($("#butExcel").length > 0){
            var butExcel = new Rui.ui.LButton('butExcel');
            butExcel.on('click', function() {
                if(dataSet.getCount() > 0) {
                    grid.saveExcel(toUTF8('과제관리_연구팀과제_WBS_') + new Date().format('%Y%m%d') + '.xlsx');
                } else {
                    Rui.alert('조회된 데이타가 없습니다.');
                }
            });
        }


        //최초 데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("wbs searchData1");
            dataSet.loadData(${result});
        } else {
            console.log("wbs searchData2");
        }


        disableFields();

        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
            $("#btnSave").hide();
        }else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
            $("#btnSave").hide();
        }
    });
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

// 빈값 확인 * str : 검증을 위한 문자 * gbn : str리턴 또는 boolean리턴 (생략가능)
function isStringEmpty(str, gbn) {
    var rt;

    if(str == null || str == "" || str == "undefined") {
        rt = true;
    } else {
        rt = false;
    }

    if(gbn == "data") {
        if(rt) rt = "";
        else rt = str;
    }

    return rt;
}


function tssCallBack() {}

$(window).load(function() {
    initFrameSetHeight();
});
</script>
</head>
<body>
<div class="titArea">
    <div class="LblockButton">
        <table>
            <colgroup>
                <col width="*">
                <col width="120px">
            </colgroup>
            <tbody>
                <tr>
                    <td><span id="progressRate" />&nbsp;</td>
                    <td align="right">
                        <!-- <button type="button" id="butChart" name="">간트차트보기</button> -->
                        <button type="button" id="butExcel" name="">Excel다운로드</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<div id="wbsFormDiv">
    <form name="wbsForm" id="wbsForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
    </form>
    <div id="defaultGrid"></div>
</div>
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
       <!--  <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>