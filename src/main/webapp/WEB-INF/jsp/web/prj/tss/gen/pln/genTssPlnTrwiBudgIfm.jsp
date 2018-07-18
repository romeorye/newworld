<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPlnTrwiBudgIfm.jsp
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
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFrameDialog.css" />
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.css" />
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd; //gvPgTssCd
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;
    var lvPgsStepCd = window.parent.gvPgsStepCd;
    
    var alTssCd = lvPgsStepCd == "AL" ? lvTssCd : "";
    lvTssCd = lvPgsStepCd == "AL" ? window.parent.gvPgTssCd : lvTssCd;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var lvPurY;
    var isSearch1 = false;
    var isSearch2 = false;
    var tbNewDialog;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //구매년도
        var cboPurY = new Rui.ui.form.LCombo({
        	applyTo: 'purY',
            name: 'cboPurY',
            rendererField: 'text',
            autoMapping: true,
            useEmptyText:false,
            items:[
            	<c:forEach var="purYy" items="${purYy}">
            	{ value: '${purYy.tssYy}', text: '${purYy.tssYy}'},
                </c:forEach>
            ]
        });
        cboPurY.getDataSet().on('load', function(e) {
        	lvPurY = cboPurY.getValue();
        });
        cboPurY.on('changed', function(e) {
        	fn_search();
        });
        
        //년월
        var rdoYyMm = new Rui.ui.form.LRadioGroup({
        	applyTo: 'yyMm',
        	name: 'rdoYyMm',
            items : [
                { label: '월별  ', value: 'mm', checked: true },
                { label: '년도별   ', value: 'yy' }
            ]
        });
        rdoYyMm.on('changed', function(e) {
        	fn_search();
        });
        
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
            
            butNewPop.hide();
        };

        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //월별 DataSet
        dataSet1 = new Rui.data.LJsonDataSet({
            id: 'tbMmDataSet',
            fields: [
                  { id:'totTitle' }
                , { id:'expScnNm' }
                , { id:'01', type:'number' }
                , { id:'02', type:'number' }
                , { id:'03', type:'number' }
                , { id:'04', type:'number' }
                , { id:'05', type:'number' }
                , { id:'06', type:'number' }
                , { id:'07', type:'number' }
                , { id:'08', type:'number' }
                , { id:'09', type:'number' }
                , { id:'10', type:'number' }
                , { id:'11', type:'number' }
                , { id:'12', type:'number' }
                , { id:'totSum', type:'number' }
            ]
        });
        dataSet1.on('load', function(e) {
            console.log("tb load DataSet Success");
        });
        
        //월별 그리드
        var columnModel1 = new Rui.ui.grid.LColumnModel({
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { id: 'G1', label: '계정' }
                , { field: 'totTitle', label: '', groupId: 'G1', sortable: false, align:'center', width: 150, vMerge: true, hMerge: true }
                , { field: 'expScnNm', label: '', groupId: 'G1', sortable: false, align:'left', width: 200, hMerge: true }
                , { field: '01', label: '1월', sortable: false, align:'right', width: 50 }
                , { field: '02', label: '2월', sortable: false, align:'right', width: 50 }
                , { field: '03', label: '3월', sortable: false, align:'right', width: 50 }
                , { field: '04', label: '4월', sortable: false, align:'right', width: 50 }
                , { field: '05', label: '5월', sortable: false, align:'right', width: 50 }
                , { field: '06', label: '6월', sortable: false, align:'right', width: 50 }
                , { field: '07', label: '7월', sortable: false, align:'right', width: 50 }
                , { field: '08', label: '8월', sortable: false, align:'right', width: 50 }
                , { field: '09', label: '9월', sortable: false, align:'right', width: 50 }
                , { field: '10', label: '10월', sortable: false, align:'right', width: 50 }
                , { field: '11', label: '11월', sortable: false, align:'right', width: 50 }
                , { field: '12', label: '12월', sortable: false, align:'right', width: 50 }
                , { field: 'totSum', label: '합계', sortable: false, align:'right', width: 100 }
            ]
        });

        var grid1 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel1,
            dataSet: dataSet1,
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

        grid1.render('tbMmGrid');
        
        //년별 DS
        dataSet2 = new Rui.data.LJsonDataSet({
            id: 'tbYyDataSet',
            fields: [
                  { id:'totTitle' }
                , { id:'expScnNm' }
                <c:forEach var="purYy" items="${purYy}">
                , { id:'${purYy.tssYy}', type:'number' }
                </c:forEach>
                , { id:'totSum', type:'number' }
            ]
        });
        dataSet2.on('load', function(e) {
            console.log("tb load DataSet Success");
        });
        
        //년별 그리드
        var columnModel2 = new Rui.ui.grid.LColumnModel({
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { id: 'G1', label: '계정' }
                , { field: 'totTitle', label: '구분1', groupId: 'G1', sortable: false, align:'center', width: 150, vMerge: true, hMerge: true }
                , { field: 'expScnNm', label: '구분2', groupId: 'G1', sortable: false, align:'left', width: 150, hMerge: true }
                <c:forEach var="purYy" items="${purYy}">
                , { field: '${purYy.tssYy}', label: '${purYy.tssYy}', sortable: false, align:'right', width: 100 }
                </c:forEach>
                , { field: 'totSum', label: '합계', sortable: false, align:'right', width: 100 }
            ]
        });
        
        var grid2 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel2,
            dataSet: dataSet2,
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

        grid2.render('tbYyGrid');
        
        
        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet1.getReadData(e);
            
            Rui.alert(data.records[0].rtVal);
            
            if(data.records[0].rtCd == "SUCCESS") {
                fn_search();
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet1.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });
        
        
        
        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //조회
        fn_search = function() {
        	if(rdoYyMm.getValue() == "mm") {
        		grid1.show();
        		grid2.hide();
        		    
        		dataSet1.load({ 
                    url: "<c:url value='/prj/tss/gen/retrieveGenTssPlnTrwiBudg.do'/>"
                  , params : {
                         tssCd: lvTssCd
                       , userId: lvUserId
                       , tssYy: cboPurY.getValue()
                       , choiceYm: rdoYyMm.getValue()
                       , pgsStepCd: lvPgsStepCd
                       , alTssCd: alTssCd
                    }
                });
        	} else {
        		grid1.hide();
        		grid2.show();
        		
        		if(!isSearch2) {
        		    isSearch2 = true;
        		    
            		dataSet2.load({ 
                        url: "<c:url value='/prj/tss/gen/retrieveGenTssPlnTrwiBudg.do'/>"
                      , params : {
                             tssCd: lvTssCd
                           , userId: lvUserId
                           , tssYy: cboPurY.getValue()
                           , choiceYm: rdoYyMm.getValue()
                           , pgsStepCd: lvPgsStepCd
                           , alTssCd: alTssCd
                        }
                    });
        		}
        	}
        };
        
        //새로고침
        fn_refresh = function() {
            isSearch2 = true;
            
            cboPurY.setSelectedIndex(0);
            rdoYyMm.setCheckedIndex(0);
            
            isSearch2 = false;
            
            fn_search();
        }
      /*   
        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
         */
        //투입계산생성
	    tbNewDialog = new Rui.ui.LFrameDialog({
	        id: 'tbNewDialog', 
	        title: '투입예산 생성',
	        width: 800,
	        height: 450,
	        modal: true,
	        visible: false
	    });
	    
	    tbNewDialog.render(document.body);
	
	    openTBNewDialog = function() {
	    	_callback = '';
	    	
	    	tbNewDialog.setUrl('<c:url value="/prj/tss/gen/genTssPlnTrwiBudgMstPop.do?tssCd="/>' + lvTssCd + '&userId=' + lvUserId + '&pgsStepCd=' + lvPgsStepCd + '&alTssCd=' + alTssCd);
	    	tbNewDialog.show();
	    };
        
        var butNewPop = new Rui.ui.LButton('butNewPop');
        butNewPop.on('click', function() {                
        	openTBNewDialog();
        });
        
        fn_search(); //조회

        disableFields(); //버튼 비활성화 셋팅
    });
</script>
<script>
$(window).load(function() {
    initFrameSetHeight("tbForm");
}); 
</script>
</head>
<body>
<form name="tbForm" id="tbForm" method="post">
	<input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
	<input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
	
	<div class="titArea">
	    <div class="LblockButton">
	    	<div id="purY"></div>
	    	<div id="yyMm"></div>
	    	<label>단위:백만원</label>
	        <button type="button" id="butNewPop" name="">투입예산생성</button>
	    </div>
	</div>
	
	<div id="tbMmGrid"></div>
	<div id="tbYyGrid"></div>
	<!-- 
	<div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnList" name="btnList">목록</button>
	    </div>
	</div> -->
</form>
</body>
</html>