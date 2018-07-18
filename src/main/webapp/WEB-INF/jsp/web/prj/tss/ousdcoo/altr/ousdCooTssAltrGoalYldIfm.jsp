<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssAltrGoalYldIfm.jsp
 * @desc    : 대외협력과제 > 목표및산출물
              진행-GRS(변경) or 변경상태인 경우 진입
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.25  IRIS04		최초생성
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
    var lvTssCd  = window.parent.gvTssCd;
    var lvUserId = window.parent.gvUserId;
    var lvTssSt  = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    
    var dataSet1;
    var dataSet2;
    var dsmActionGrid = "";
    
    var nowDate = new Date();
    var nYear  = nowDate.getFullYear();
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //목표년도
        cboGoalY = new Rui.ui.form.LCombo({
            name: 'cboGoalY',
            url: '<c:url value="/prj/tss/gen/retrieveGenTssGoalYy.do"/>',
            displayField: 'goalYy',
            valueField: 'goalYy',
            rendererField: 'goalYy',
            autoMapping: true
        });
        cboGoalY.getDataSet().on('load', function(e) {
            console.log('cboGoalY :: load');
        });
        
        //산출물유형
        cbYldItmType = new Rui.ui.form.LCombo({
            name: 'cbYldItmType',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=YLD_ITM_TYPE_O"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            rendererField: 'value',
            autoMapping: true
        });
        cbYldItmType.getDataSet().on('load', function(e) {
            console.log('cbYldItmType :: load');
        });
        
        //그리드 TextArea
        gridTextArea = new Rui.ui.form.LTextArea({
            disabled: pageMode == "W" ? false : true
        });
        
      	//그리드 TextBox
        gridTextBox = new Rui.ui.form.LTextBox({
            disabled: pageMode == "W" ? false : true
        });
        
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
            
            butGoalAdd.hide();
            butGoalDel.hide();
            btnGoalSave.hide();
            butYldAdd.hide();
            butYldDel.hide();
            btnYldSave.hide();
            
            //grid1.setEditable(false);
            grid2.setEditable(false);
            
         	// grid1, grid2 체크박스, 상태 hidden처리
            columnModel1.getColumnAt(0).setHidden(true);
            columnModel1.getColumnAt(1).setHidden(true);
            columnModel2.getColumnAt(0).setHidden(true);
            columnModel2.getColumnAt(1).setHidden(true);
            
            // grid1 단계 editable false
            //columnModel1.getColumnAt(3).disable();
        };

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //목표DS
        dataSet1 = new Rui.data.LJsonDataSet({
            id: 'goalDataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id:'tssCd' }      //과제코드 
                , { id:'goalArslSn' } //과제목표일련번호          
                , { id:'prvs' }       //항목                
                , { id:'cur' }        //현재                
                , { id:'goal' }       //목표                
                , { id:'arsl' }       //실적                
                , { id:'step' }       //단계                
                , { id:'utm' }        //단위                
                , { id:'evWay' }      //평가방법
                , { id:'userId' }     //사용자ID
            ]
        });
        dataSet1.on('load', function(e) {
            console.log("load goalDataSet Success");
        });
        
        var columnModel1 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'step',  label: '단계',     sortable: false, align:'left', width: 200, editor: gridTextBox }
                , { field: 'prvs',  label: '평가항목', sortable: false, align:'left', width: 300, editor: gridTextArea }
                , { field: 'evWay', label: '평가방법', sortable: false, align:'left', width: 300, editor: gridTextArea }
                , { field: 'goal',  label: '목표수준', sortable: false, align:'left', width: 300, editor: gridTextArea }
                , { field: 'cur',   label: '현재수준', sortable: false, align:'left', width: 300, editor: gridTextArea }
                
            ]
        });

        var grid1 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel1,
            dataSet: dataSet1,
            width: 600,
            height: 200,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        grid1.render('goalGrid');
        
        
        //산출물DS
        dataSet2 = new Rui.data.LJsonDataSet({
            id: 'yldDataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id:'tssCd' }      //과제코드            
                , { id:'yldItmSn' }   //과제산출물일련번호       
                , { id:'goalY' }      //목표년도            
                , { id:'yldItmType' } //산출물유형           
                , { id:'goalCt' }     //목표개수            
                , { id:'arslYymm' }   //실적년월            
                , { id:'yldItmNm' }   //산출물명            
                , { id:'yldItmTxt' }  //산출물내용           
                , { id:'userId' }     //사용자ID
                , { id:'attcFilId' }  //파일ID   
            ]
        });
        dataSet1.on('load', function(e) {
            console.log("load yldDataSet Success");
        });
        
        var columnModel2 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'goalY', label: '목표년도', sortable: false, align:'center', width: 100, editor: cboGoalY }
                , { field: 'yldItmType',  label: '산출물유형', sortable: false, align:'center', width: 300, editor: cbYldItmType
                    , renderer: function(value, p, record, row, col) {
                        if(record.data.yldItmSn == 1) p.editable = false;
                        return value;
                  } }
            ]
        });
        
        var grid2 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel2,
            dataSet: dataSet2,
            width: 600,
            height: 200,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        grid2.render('yldGrid');
        
        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet1.getReadData(e);
            
            Rui.alert(data.records[0].rtVal);
            
            if(data.records[0].rtCd == "SUCCESS") {
                fnSearch(data.records[0].targetDs);
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet1.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });
        
        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [  
                  { id: 'tssNm',       validExp: '일정명:true' }
//                 , { id: 'strtDt',   validExp: '과제기간 시작일:true' }
//                 , { id: 'fnhDt',  validExp: '과제기간  종료일:true' }
//                 , { id: 'saSabunNew',   validExp: '담당연구원:true' }
            ]
        });

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //목표추가
        var butGoalAdd = new Rui.ui.LButton('butGoalAdd');
        butGoalAdd.on('click', function() {
            var row = dataSet1.newRecord();
            var record = dataSet1.getAt(row);
            
            record.set("tssCd",  lvTssCd);
            record.set("userId", lvUserId);
        });
        
        //목표삭제
        var butGoalDel = new Rui.ui.LButton('butGoalDel');
        butGoalDel.on('click', function() {                
            Rui.confirm({
                text: Rui.getMessageManager().get('$.base.msg107'),
                handlerYes: function() {
                    //실제 DB삭제건이 있는지 확인
                    var dbCallYN = false;
                    var chkRows = dataSet1.getMarkedRange().items;
                    for(var i = 0; i < chkRows.length; i++) {
                        if(stringNullChk(chkRows[i].data.goalArslSn) != "") {
                            dbCallYN = true;
                            break;
                        }
                    }
                    
                    if(dataSet1.getMarkedCount() > 0) {
                        dataSet1.removeMarkedRows();
                    } else {
                        var row = dataSet1.getRow();
                        if(row < 0) return;                        
                        dataSet1.removeAt(row);
                    }
                    
                    if(dbCallYN) {
                        //삭제된 레코드 외 상태 정상처리
                        for(var i = 0; i < dataSet1.getCount(); i++) {
                            if(dataSet1.getState(i) != 3) dataSet1.setState(i, Rui.data.LRecord.STATE_NORMAL);
                        }
                        
                        dm.updateDataSet({
                            url:'<c:url value="/prj/tss/ousdcoo/deleteOusdCooTssAltrGoal.do"/>',
                            dataSets:[dataSet1]
                        });
                    }
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        //목표저장
        var btnGoalSave = new Rui.ui.LButton('btnGoalSave');
        btnGoalSave.on('click', function() {
            if(!dataSet1.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }
            
            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    dm.updateDataSet({
                        url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssAltrGoal.do"/>',
                        dataSets:[dataSet1]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        //산출물추가
        var butYldAdd = new Rui.ui.LButton('butYldAdd');
        butYldAdd.on('click', function() {
            var row = dataSet2.newRecord();
            var record = dataSet2.getAt(row);
            
            record.set("tssCd"      , lvTssCd);
            record.set("userId"     , lvUserId);
            record.set("goalY"      , nYear);
        });
        
        //산출물삭제
        var butYldDel = new Rui.ui.LButton('butYldDel');
        butYldDel.on('click', function() {                
            var chkRows = dataSet2.getMarkedRange().items;
            for(var i = 0; i < chkRows.length; i++) {
                if(chkRows[i].data.yldItmSn == 1) {
                    Rui.alert("개요에서 등록된 항목으로 삭제가 불가합니다.");
                    return;
                }
            }
            
            Rui.confirm({
                text: Rui.getMessageManager().get('$.base.msg107'),
                handlerYes: function() {
                    //실제 DB삭제건이 있는지 확인
                    var dbCallYN = false;
                    var chkRows = dataSet2.getMarkedRange().items;
                    for(var i = 0; i < chkRows.length; i++) {
                        if(stringNullChk(chkRows[i].data.yldItmSn) != "") {
                            dbCallYN = true;
                            break;
                        }
                    }
                    
                    if(dataSet2.getMarkedCount() > 0) {
                        dataSet2.removeMarkedRows();
                    } else {
                        var row = dataSet2.getRow();
                        if(row < 0) return;                        
                        dataSet2.removeAt(row);
                    }
                    
                    if(dbCallYN) {
                        //삭제된 레코드 외 상태 정상처리
                        for(var i = 0; i < dataSet2.getCount(); i++) {
                            if(dataSet2.getState(i) != 3) dataSet2.setState(i, Rui.data.LRecord.STATE_NORMAL);
                        }
                        
                        dm.updateDataSet({
                            url:'<c:url value="/prj/tss/ousdcoo/deleteOusdCooTssAltrYld.do"/>',
                            dataSets:[dataSet2]
                        });
                    }
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        //산출물저장
        var btnYldSave = new Rui.ui.LButton('btnYldSave');
        btnYldSave.on('click', function() {
            if(!dataSet2.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }
            
            dm.updateDataSet({
                url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssAltrYld.do"/>',
                dataSets:[dataSet2]
            });
        });
       /*  
        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
        	nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdTssList.do'/>");
        });
        */ 
        //조회
        fnSearch = function(targetDs) {
        	if(targetDs == "GOAL") {
	            dataSet1.load({ 
	                url: "<c:url value='/prj/tss/ousdcoo/retrieveOusdCooTssAltrGoal.do'/>"
	              , params : {
	                    tssCd : lvTssCd
	                }
	            });
        	}
        	else {
	            dataSet2.load({ 
	                url: "<c:url value='/prj/tss/ousdcoo/retrieveOusdCooTssAltrYld.do'/>"
	              , params : {
	                    tssCd : lvTssCd
	                }
	            });
        	}
        };
        
        //데이터 셋팅
        if(${resultGoalCnt} > 0) { 
            console.log("goal searchData1");
            dataSet1.loadData(${resultGoal}); 
        } else {
            console.log("goal searchData2");
        }
        if(${resultYldCnt} > 0) { 
            console.log("yld searchData1");
            dataSet2.loadData(${resultYld}); 
        } else {
            console.log("yld searchData2");
        }
        
        
        //버튼 비활성화 셋팅
        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnYldSave").hide();
        	$("#butGoalAdd").hide();
        	$("#butGoalDel").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnYldSave").hide();
        	$("#butGoalAdd").hide();
        	$("#butGoalDel").hide();
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
    <form name="form" id="goalForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
    </form>
</div>

<div class="titArea">
    <span class="sub-tit"><h4>&gt; 목표기술성과 등록</h4></span>
    <div class="LblockButton">
        <button type="button" id="butGoalAdd" name="">추가</button>
        <button type="button" id="butGoalDel" name="">삭제</button>
    </div>
</div>

<div id="goalGrid"></div>

<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnGoalSave">저장</button>
    </div>
</div>

<div class="titArea">
    <span class="sub-tit"><h4>&gt; 필수산출물 등록</h4></span>
    <div class="LblockButton">
        <button type="button" id="butYldAdd" name="">추가</button>
        <button type="button" id="butYldDel" name="">삭제</button>
    </div>
</div>

<div id="yldGrid"></div>

<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnYldSave">저장</button>
    </div>
</div>

<div class="titArea">
    <div class="LblockButton">
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>

</body>
</html>