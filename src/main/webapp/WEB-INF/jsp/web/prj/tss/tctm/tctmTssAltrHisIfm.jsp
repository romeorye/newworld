<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPgsAltrHistIfm.jsp
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

<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvMstPgsCd = window.parent.gvPgsStepCd; //진행코드
    var lvMstTssSt = window.parent.gvTssSt;     //과제상태
    var lvMstPageMode = window.parent.gvPageMode;

    var pageMode = lvMstPgsCd == "PG" && lvMstTssSt == "100" && lvMstPageMode == "W" ? "W" : "R";

    var dataSet;
    var dataSet2;
    var popupRow;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "R") {
            }
        };



        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //dataSet 설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id: 'tssCd' }         //과제코드
                , { id: 'userId' }        //사용자ID
                , { id: 'wbsCd' }         //WBS코드
                , { id: 'pkWbsCd' }       //WBS코드
                , { id: 'prvs' }          //항목
                , { id: 'altrPre' }       //변경전
                , { id: 'altrAft' }       //변경후
                , { id: 'altrRsonTxt' }   //변경사유
                , { id: 'addRsonTxt' }    //추가사유
                , { id: 'altrApprDd' }    //변경승인일
                , { id: 'altrAttcFilId' } //첨부파일
            ]
        });


        var textarea = new Rui.ui.form.LTextArea({
            width: 300,
            height: 100,
            disabled : true
        });

        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { field: 'altrApprDd', label: '변경승인일', sortable: false, align:'center', width: 100, vMerge: true }
                , { field: 'prvs',  label: '항목', 				sortable: false, align:'center', width: 150 }
                , { field: 'altrPre', label: '변경전',  sortable: false, align:'center', width: 150 }
                , { field: 'altrAft', label: '변경후', sortable: false, align:'center', width: 150 }
                , { field: 'altrRsonTxt', label: '변경사유',   sortable: false, align:'center', width: 200, vMerge: true }
                , { field: 'addRsonTxt', label: '추가사유',  sortable: false, align:'center', width: 200, vMerge: true }
            ]
        });




        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 500,
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

            var pAttcId = dataSet.getNameValue(popupRow, "altrAttcFilId");

            openAttachFileDialog(setAttachFileInfo, stringNullChk(pAttcId), 'prjPolicy', '*', pageMode);




        });

        grid.render('defaultGrid');

        grid.on('cellClick', function(e) {
 			var record = dataSet.getAt(dataSet.getRow());
				parent.fncGenTssAltrDetail(record.get("tssCd"));
 	 	});

        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);

            Rui.alert(data.records[0].rtVal);

            if(data.records[0].rtCd == "SUCCESS") {
                fnSearch(data.records[0].targetDs);
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });


        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //첨부파일
        setAttachFileInfo = function(attachFileList) {
            if(attachFileList.length > 0) dataSet.setNameValue(popupRow, "altrAttcFilId", attachFileList[0].data.attcFilId);
        };


        //목록
        /*
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
         */

        //엑셀다운
        var butExcel = new Rui.ui.LButton('butExcel');
        butExcel.on('click', function() {
            if(dataSet.getCount() > 0) {
                grid.saveExcel(toUTF8('과제관리_일반과제_변경이력_') + new Date().format('%Y%m%d') + '.xls');
            } else {
                Rui.alert('조회된 데이타가 없습니다.');
            }
        });


        //최초 데이터 셋팅
        if(${resultCnt} > 0) {

            dataSet.loadData(${result});


        }
    });
</script>
<script>
$(window).load(function() {
    initFrameSetHeight();
});
</script>
</head>
<body>
<div id="formDiv">
    <form name="aForm" id="aForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
    </form>
</div>
<div class="titArea">

    <div class="LblockButton">
        <button type="button" id="butExcel" name="">Excel다운로드</button>
    </div>
</div>

<div id="defaultGrid"></div>

<!-- <div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnList" name="btnList">목록</button>
    </div>
</div> -->
</body>
</html>