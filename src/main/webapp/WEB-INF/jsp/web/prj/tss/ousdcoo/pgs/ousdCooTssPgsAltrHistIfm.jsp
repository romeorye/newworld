<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssPgsAltrHistIfm.jsp
 * @desc    : 대외협력과제 > 진행 변경이력 탭 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.19  IRIS04		최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd    = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt    = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = lvPgsCd == "PG" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var dataSet2;
    var popupRow;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
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
                , { id: 'pkWbsCd' }       //WBS코드(PK)
                , { id: 'prvs' }          //항목
                , { id: 'altrPre' }       //변경전  
                , { id: 'altrAft' }       //변경후  
                , { id: 'altrRson' }      //변경사유 
                , { id: 'addRson' }       //추가사유
                , { id: 'altrApprDd' }    //변경승인일
                , { id: 'altrAttcFilId' } //변경첨부파일
            ]
        });
        
        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { field: 'altrApprDd', label: '변경승인일', sortable: false, align:'center', width: 120, vMerge: true }
//                , { field: 'prvs',  label: '항목', sortable: false, align:'center', width: 200 }
                , { field: 'altrPre', label: '변경전', sortable: false, align:'left', width: 180 }
                , { field: 'altrAft', label: '변경후', sortable: false, align:'left', width: 180 }
                , { field: 'altrRson', label: '변경사유', sortable: false, align:'left', width: 250, vMerge: true  }
                , { field: 'addRson', label: '추가사유', sortable: false, align:'left', width: 250, vMerge: true  }
            ]
        });
        
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 350,
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
				parent.fncOusdCooTssAltrDetail(record.get("tssCd")); 			
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
        
        //엑셀다운
        var butExcel = new Rui.ui.LButton('butExcel');
        butExcel.on('click', function() {                
            if(dataSet.getCount() > 0) {
                grid.saveExcel(toUTF8('변경이력_') + new Date().format('%Y%m%d') + '.xls');
            } else {
                Rui.alert('조회된 데이타가 없습니다.');
            }
        });
        
        //최초 데이터 셋팅
        if(${resultCnt} > 0) {
            dataSet.loadData(${result}); 
        }
    });
    
    // 내부 스크롤 제거
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
    <h4>변경이력</h4>
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