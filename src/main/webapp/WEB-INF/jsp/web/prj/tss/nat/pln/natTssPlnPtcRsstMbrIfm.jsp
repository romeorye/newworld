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
 * 1.0  2017.08.08              참여연구원
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var lvTssCd     = window.parent.gvTssCd;
    var lvUserId    = window.parent.gvUserId;
    var lvTssSt     = window.parent.gvTssSt;
    var lvPgsStepCd = window.parent.gvPgsStepCd;
    var lvPageMode  = window.parent.gvPageMode;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;

    var popupRow;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //참여역할
        var rtcRole = new Rui.ui.form.LRadioGroup({
            gridFixed: true,
            autoMapping: true,
            valueField: 'value',
            displayField: 'label',
            items : [
                <c:forEach var="lvTssSt" items="${codeRtcRole}">
                { label: '${lvTssSt.COM_DTL_NM}', name: '${lvTssSt.COM_DTL_NM}', value: '${lvTssSt.COM_DTL_CD}' },
                </c:forEach>
            ]
        });


        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;

            butRecordNew.hide();
            butRecordDel.hide();
            btnSave.hide();

            grid.setEditable(false);
        };


        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'mbrDataSet',
            remainRemoved: true, //삭제시 삭제건으로 처리하지 않고 state만 바꾼다.
            lazyLoad: true, //대량건의 데이터를 로딩할 경우 timer로 처리하여 ie에서 스크립트 로딩 메시지가 출력하지 않게 한다.
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id: 'tssCd' }                                             //과제코드
                , { id: 'ptcRsstMbrSn' }                                      //참여연구원일련번호
                , { id: 'saSabunNew' }                                        //연구원사번
                , { id: 'saUserName' }                                        //연구원이름
                , { id: 'deptCode' }                                          //소속
                , { id: 'deptName' }                                          //소속
                , { id: 'ptcStrtDt', type: 'date', defaultValue: new Date() } //참여시작일
                , { id: 'ptcFnhDt', type: 'date' }  //참여종료일
                //, { id: 'ptcFnhDt', type: 'date', defaultValue: new Date() }  //참여종료일
                , { id: 'oldStrtDt' } //참여시작일
                , { id: 'oldFnhDt' }  //참여종료일
                , { id: 'ptcRole', defaultValue: '02' }                       //참여역할
                , { id: 'ptcRoleDtl' }                                        //참여역할상세
                , { id: 'ptcPro' }                                            //본과제참여율(%)
                , { id: 'userId' }                                            //사용자ID
            ]
        });
        dataSet.on('load', function(e) {
            console.log("mbr load DataSet Success");
        });


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
                  { id: 'tssCd',        validExp: '과제코드:false' }
                , { id: 'ptcRsstMbrSn', validExp: '참여연구원일련번호:false' }
                , { id: 'saSabunNew',   validExp: '연구원사번:false' }
                , { id: 'saUserName',   validExp: '연구원:true' }
                , { id: 'deptCode',     validExp: '소속:false' }
                , { id: 'deptName',     validExp: '소속:false' }
                , { id: 'ptcStrtDt',    validExp: '참여시작일:false' }
                , { id: 'ptcFnhDt',     validExp: '참여종료일:false' }
                , { id: 'ptcRole',      validExp: '참여역할:false' }
                , { id: 'ptcRoleDtl',   validExp: '역할상세:false:maxLength=2000' }
                , { id: 'ptcPro',       validExp: '본과제참여율(%):true' }
                , { id: 'userId',       validExp: '사용자ID:false' }
            ]
        });


        //컬럼설정
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'saUserName', label: '연구원', sortable: false, align:'center', width: 100, renderer: Rui.util.LRenderer.popupRenderer() }
                , { field: 'deptName', label: '소속', sortable: false, align:'center', width: 150 }
                , { field: 'ptcStrtDt', label: '참여기간', sortable: false, align:'center', width: 130, editor: new Rui.ui.form.LDateBox({id:'ptcStrtDt'})
                    , renderer: function(value, p, record) {
                        if(record.data.ptcStrtDt != null) {
                            var valDate = Rui.util.LFormat.stringToDate(record.data.ptcStrtDt, {format: '%x'});
                            return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
                        }
                        if(value!="") {
                            return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
                        }
                  } }
                , { field: 'ptcFnhDt', label: '참여기간', sortable: false, align:'center', width: 130, editor: new Rui.ui.form.LDateBox({id:'ptcFnhDt'})
                    , renderer: function(value, p, record) {
                        if(record.data.ptcStrtDt != null) {
                            var valDate = Rui.util.LFormat.stringToDate(record.data.ptcFnhDt, {format: '%x'});
                            return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
                        }
                        if(value!="") {
                            return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
                        }
                  } }
                , { field: 'ptcRole', label: '참여역할', sortable: false, align:'center', width: 150, editor: rtcRole
                    , renderer: function(v) {
                        if(v == null) {
                            return rtcRole.getCheckedItem().label;
                        } else {
                            if(v == '01') return "과제리더";
                            else if(v == '02') return "연구원";
                            else if(v == '03') return "기타";
                        }
                     }
                }
                , { field: 'ptcRoleDtl', label: '역할상세', sortable: false, align:'left', width: 150, editor: new Rui.ui.form.LTextBox() }
                , { field: 'ptcPro', label: '본과제참여율(%)', sortable: false, align:'center', width: 70, editor: new Rui.ui.form.LNumberBox({decimalPrecision:2,maxValue:100}) }
            ]
        });


        //패널설정
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 308,
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
            openTssUserSearchDialog(setGridUserInfo,  '');
        });

        grid.render('defaultGrid');


        openTssUserSearchDialog = function(f,  userIds) {
            _callback = f;
            _userSearchDialog.setUrl('<c:url value="/com/tss/tssUserSearchPopup.do?cnt=1&userIds="/>');
            _userSearchDialog.show();
        };
        
        
        //조회
        fnSearch = function() {
            dataSet.load({ 
                url: "<c:url value='/prj/tss/nat/retrieveNatTssPlnPtcRsstMbr.do'/>"
              , params : {
                    tssCd : lvTssCd
                }
            });
        };


        <%--/*******************************************************************************
         * FUNCTION 명 : butRecordNew
         * FUNCTION 기능설명 :추가
         *******************************************************************************/--%>
        var butRecordNew = new Rui.ui.LButton('butRecordNew');
        butRecordNew.on('click', function() {
            var row = dataSet.newRecord();
            var record = dataSet.getAt(row);

            record.set("tssCd",  lvTssCd);
            record.set("userId", lvUserId);
            record.set("saSabunNew", "testId");
        });


        <%--/*******************************************************************************
         * FUNCTION 명 : butRecordDel
         * FUNCTION 기능설명 :삭제
         *******************************************************************************/--%>
        var butRecordDel = new Rui.ui.LButton('butRecordDel');
        butRecordDel.on('click', function() {
            Rui.confirm({
                text: Rui.getMessageManager().get('$.base.msg107'),
                handlerYes: function() {
                    //실제 DB삭제건이 있는지 확인
                    var dbCallYN = false;
                    var chkRows = dataSet.getMarkedRange().items;
                    for(var i = 0; i < chkRows.length; i++) {
                        if(stringNullChk(chkRows[i].data.ptcRsstMbrSn) != "") {
                            dbCallYN = true;
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

                    if(dbCallYN) {
                        //삭제된 레코드 외 상태 정상처리
                        for(var i = 0; i < dataSet.getCount(); i++) {
                            if(dataSet.getState(i) != 3) dataSet.setState(i, Rui.data.LRecord.STATE_NORMAL);
                        }
                        
                        dm.updateDataSet({
                            url:'<c:url value="/prj/tss/nat/deleteNatTssPlnPtcRsstMbr.do"/>',
                            dataSets:[dataSet]
                        });
                    }
                },
                handlerNo: Rui.emptyFn
            });
        });



        <%--/*******************************************************************************
         * FUNCTION 명 : btnSave
         * FUNCTION 기능설명 :저장
         *******************************************************************************/--%>
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            if(!vm.validateDataSet(dataSet, dataSet.getRow())) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return false;
            }

            if(!dataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }
            
            //과제리더 건수 확인
            var rdSnt = 0;
            for(var i = 0; i < dataSet.getCount(); i++) {
                if(dataSet.getNameValue(i, "ptcRole") == "01") rdSnt++;
            }
            if(rdSnt != 1) {
                Rui.alert("과제리더는 1명으로 지정해야 합니다.");
                return;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
		            dm.updateDataSet({
		                modifiedOnly: false,
		                url:'<c:url value="/prj/tss/nat/updateNatTssPlnPtcRsstMbr.do"/>',
		                dataSets:[dataSet]
		            });
                },
                handlerNo: Rui.emptyFn
            });
        });


        <%--/*******************************************************************************
         * FUNCTION 명 : btnList
         * FUNCTION 기능설명 :목록
         *******************************************************************************/--%>
       /*  var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
 */

        //최초 데이터 셋팅
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
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butRecordNew").hide();
        	$("#butRecordDel").hide();
        	$("#btnSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butRecordNew").hide();
        	$("#butRecordDel").hide();
        	$("#btnSave").hide();
		}
    });


    <%--/*******************************************************************************
    * FUNCTION 명 : setGridUserInfo
    * FUNCTION 기능설명 :연구원팝업 셋팅
    *******************************************************************************/--%>
    function setGridUserInfo(userInfo) {
        dataSet.setNameValue(popupRow, "saSabunNew", userInfo.saSabun);
        dataSet.setNameValue(popupRow, "saUserName", userInfo.saName);
        dataSet.setNameValue(popupRow, "deptCode", userInfo.deptCd);
        dataSet.setNameValue(popupRow, "deptName", userInfo.deptName);
    }
</script>
<script>
$(window).load(function() {
    initFrameSetHeight();
}); 
</script>
</head>
<body>
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="butRecordNew">추가</button>
        <button type="button" id="butRecordDel">삭제</button>
    </div>
</div>
<div id="mbrFormDiv">
    <form name="mbrForm" id="mbrForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
    </form>
    <div id="defaultGrid"></div>
</div>
<div class="titArea mt10">
    <div class="LblockButton">

        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>