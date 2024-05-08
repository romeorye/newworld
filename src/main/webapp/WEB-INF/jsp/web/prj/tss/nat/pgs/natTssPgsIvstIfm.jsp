<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssPgsIvstIfm.jsp
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
    var lvPgsCd    = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt    = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = lvPgsCd == "PG" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var popupRow;
    var popupIvstIgSn;
    var ivstNewDialog;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //dataSet 
        dataSet = new Rui.data.LJsonDataSet({
            id: 'ivstDataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id:'tssCd' }      //과제코드 
                , { id:'userId' }     //사용자ID
                , { id:'ivstIgSn' }   //투자품목일련번호    
                , { id:'asstNo' }     //자산번호    
                , { id:'asstNm' }     //자산명 
                , { id:'purEra' }     //구입시기(년차) 
                , { id:'obtDt' }      //취득일 
                , { id:'ivstAmt' }    //투자금액     
                , { id:'obtAmt' }     //취득가액 
                , { id:'subAmt' }     //차감금액 
                , { id:'attcFilId' }  //첨부파일 
            ]
        });
        dataSet.on('load', function(e) {
            console.log("ivst load dataSet Success");
        });
        
        
        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { field: 'asstNo',    label: '자산번호', sortable: false, align:'center', width: 70 }
                , { field: 'asstNm',    label: '자산명', sortable: false, align:'left', width: 300 }
                , { field: 'purEra',    label: '구입시기(년차)', sortable: false, align:'center', width: 110 }
                , { field: 'obtDt',     label: '취득일', sortable: false, align:'center', width: 110 }
                , { field: 'ivstAmt',   label: '투자금액', sortable: false, align:'right', width: 100 }
                , { field: 'obtAmt',    label: '취득가액', sortable: false, align:'right', width: 100 }
                , { field: 'subAmt',    label: '차감금액', sortable: false, align:'right', width: 100 }
                , { field: 'attcFilId', label: '첨부파일', sortable: false, align:'center', width: 100 }
            ]
        });
        
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 500,
//             mouseEvent: true,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });
        grid.on('cellClick', function(e) {
            popupRow = e.row;
            popupIvstIgSn = dataSet.getAt(popupRow).data.ivstIgSn;
            
            openIvstNewDialog();
        });
        grid.on('mouseover', function(e) {
            console.log('mouseover 이 호출되었습니다.');
        });

        grid.render('defaultGrid');
                
        
        
        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //조회 
        fnSearch = function(targetDs) {
    	    dataSet.load({ 
                url: "<c:url value='/prj/tss/nat/retrieveNatTssPgsIvst.do'/>"
              , params : {
                    tssCd : lvTssCd
                }
            });
        };
        
        //목록 
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
         */
        
        //투자품목등록
        callChildSave = function() {
            ivstNewDialog.getFrameWindow().fnSave();
        }
        
        callChildDel = function() {
            ivstNewDialog.getFrameWindow().fnDelete();
        }
        
        ivstNewDialog = new Rui.ui.LFrameDialog({
            id: 'ivstNewDialog', 
            title: '투자품목등록',
            width: 550,
            height: 370,
            modal: true,
            visible: false,
            buttons: []
        });
        
        ivstNewDialog.render(document.body);
    
        openIvstNewDialog = function() {
            //상태에 따른 버튼 여부
            if(popupIvstIgSn == "") {
                ivstNewDialog.setButtons([
                    { text: '저장', handler: callChildSave, isDefault: true },
                    { text: '닫기', handler: function() {
                        this.cancel();
                    }}
                ]);
            } else {
                ivstNewDialog.setButtons([
                    { text: '저장', handler: callChildSave, isDefault: true },
                    { text: '삭제', handler: callChildDel },
                    { text: '닫기', handler: function() {
                        this.cancel();
                    }}
                ]);
            }
            if(pageMode == "R") {
                ivstNewDialog.setButtons([
                    { text: '닫기', handler: function() {
                        this.cancel();
                    }}
                ]);
            }
            
            ivstNewDialog.setUrl('<c:url value="/prj/tss/nat/natTssPgsIvstDtlPop.do?tssCd="/>' + lvTssCd + '&userId=' + lvUserId + '&ivstIgSn=' + popupIvstIgSn);
            ivstNewDialog.show();
        };
        
        var butNewPop = new Rui.ui.LButton('butNewPop');
        butNewPop.on('click', function() {                
            popupRow = "";
            popupIvstIgSn = "";
            
            openIvstNewDialog();
        });
        
        //첨부파일 등록 팝업
        openIvstAttcDialog = function() {
            openAttachFileDialog(setAttachFileInfo, ivstNewDialog.getFrameWindow().getAttachFileId(), 'prjPolicy', '*');
        }
        
        setAttachFileInfo = function(attachFileList) {
            ivstNewDialog.getFrameWindow().setAttachFileInfo(attachFileList);
        };
        
        // 최초 데이터 셋팅 
        if(${resultCnt} > 0) { 
            console.log("ivst searchData1");
            dataSet.loadData(${result}); 
        }
        
        if(pageMode == "R") butNewPop.hide();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	butNewPop.hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	butNewPop.hide();
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
    <form name="form" id="goalForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
    </form>
</div>
<div class="titArea">
    <h4>투자품목목록</h4>
    <div class="LblockButton">
        <button type="button" id="butNewPop">투자품목등록</button>
    </div>
</div>

<div id="defaultGrid"></div>
<!-- 
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnList" name="btnList">목록</button>
    </div>
</div> -->
</body>
</html>