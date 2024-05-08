<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssPgsCrdIfm.jsp
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

<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd    = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt    = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = lvPgsCd == "PG" || lvPgsCd == "CM" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var popupRow;
    var popupCdcdSn = "0";
    var popupTssCd;
    var crdNewDialog;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //dataSet 
        dataSet = new Rui.data.LJsonDataSet({
            id: 'crdDataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id: 'tssCd' }          //과제코드 
                , { id: 'userId' }         //사용자ID
                , { id: 'rsstExpCdcdSn' }  //연구비카드일련번호
                , { id: 'saSabunNew' }     //사번
                , { id: 'deptCode' }       //소속
                , { id: 'saFunc' }         //직급
                , { id: 'rtrnDt' }         //반납일
                , { id: 'cdcdNm' }         //카드사
                , { id: 'cdcdNo' }         //카드번호
                , { id: 'iYymm' }          //발급년월
                , { id: 'ivstAmt' }        //투자금액
                , { id: 'remTxt' }         //비고
                , { id: 'saUserName' }     //사용자명
                , { id: 'saJobxName' }     //직급
            ]
        });
        dataSet.on('load', function(e) {
            console.log("crd load dataSet Success");
        });
        
        
        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { field: 'saUserName', label: '성명', sortable: false, align:'center', width: 100 }
                , { field: 'saJobxName', label: '직급', sortable: false, align:'center', width: 70 }
                , { field: 'cdcdNm',     label: '카드사', sortable: false, align:'center', width: 100 }
                , { field: 'cdcdNo',     label: '카드번호', sortable: false, align:'center', width: 150 }
                , { field: 'iYymm',      label: '발급년월', sortable: false, align:'center', width: 120 }
                , { field: 'rtrnDt',     label: '반납일', sortable: false, align:'center', width: 120 }
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
        grid.on('cellClick', function(e) {
            popupRow = e.row;
            popupCdcdSn = stringNullChk(dataSet.getAt(popupRow).data.rsstExpCdcdSn) == "" ? "0" : dataSet.getAt(popupRow).data.rsstExpCdcdSn;
            popupTssCd  = dataSet.getAt(popupRow).data.tssCd;
            
            openCrdNewDialog();
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
                url: "<c:url value='/prj/tss/nat/retrieveNatTssPgsCrd.do'/>"
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
        
        //연구비카드등록
        callChildSave = function() {
            crdNewDialog.getFrameWindow().fnSave();
        }
        
        callChildDel = function() {
            crdNewDialog.getFrameWindow().fnDelete();
        }
        
        crdNewDialog = new Rui.ui.LFrameDialog({
            id: 'crdNewDialog', 
            title: '연구비카드등록',
            width: 600,
            height: 410,
            modal: true,
            visible: false,
            buttons: []
        });
        
        crdNewDialog.render(document.body);
    
        openCrdNewDialog = function() {
            //상태에 따른 버튼 여부
            if(pageMode == "R") {
                crdNewDialog.setButtons([
                    { text: '닫기', handler: function() {
                        this.cancel();
                    }}
                ]);
            }else{
            	crdNewDialog.setButtons([
                    { text: '저장', handler: callChildSave, isDefault: true },
                    { text: '삭제', handler: callChildDel },
                    { text: '닫기', handler: function() {
                        this.cancel();
                    }}
                ]);
            }
        
            
            if(popupTssCd != "") {
                if(popupCdcdSn != "0") popupTssCd = ""; //사번있고 시퀀스 있으면
                else popupCdcdSn = ""; //사번있고 시퀀스 없으면
            }
            else popupCdcdSn = "0"; //사번 없으면
            
            crdNewDialog.setUrl('<c:url value="/prj/tss/nat/natTssPgsCrdDtlPop.do?tssCd="/>' + lvTssCd + '&rsstExpCdcdSn=' + popupCdcdSn);
            crdNewDialog.show();
        };
        
        var butNewPop = new Rui.ui.LButton('butNewPop');
        butNewPop.on('click', function() {                
            popupRow    = "";
            popupCdcdSn = "0";
            popupTssCd  = "";
            
            openCrdNewDialog();
        });
        
        //자식창 사용자팝업
        openSaUser = function() {
            openUserSearchDialog(crdNewDialog.getFrameWindow().setLeaderInfo, 1, '');
        }
        
        // 최초 데이터 셋팅 
        if(${resultCnt} > 0) { 
            console.log("crd searchData1");
            dataSet.loadData(${result}); 
        }
        
        if(pageMode == "R") butNewPop.hide();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butNewPop").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butNewPop").hide();
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
    <h4>연구비카드목록</h4>
    <div class="LblockButton">
        <button type="button" id="butNewPop">연구비카드등록</button>
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