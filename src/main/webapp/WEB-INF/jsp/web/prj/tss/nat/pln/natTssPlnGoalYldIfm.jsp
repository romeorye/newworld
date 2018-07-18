<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssPlnGoalYldIfm.jsp
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
    var lvTssCd     = window.parent.gvTssCd;
    var lvUserId    = window.parent.gvUserId;
    var lvTssSt     = window.parent.gvTssSt;
    var lvPgsStepCd = window.parent.gvPgsStepCd;
    var lvPageMode  = window.parent.gvPageMode;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    
    var dataSet1;
    var dataSet2;
    var dataSet3;
    var dsmActionGrid = "";
    
    
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
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=YLD_ITM_TYPE_N"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            rendererField: 'value',
            autoMapping: true
        });
        cbYldItmType.getDataSet().on('load', function(e) {
            console.log('cbYldItmType :: load');
        });
        
        //그리드 텍스트
        var textArea = new Rui.ui.form.LTextArea();
        
        
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
            
            butGoalAdd.hide();
            butGoalDel.hide();
            btnGoalSave.hide();
            butYldAdd.hide();
            butYldDel.hide();
            btnYldSave.hide();
            
            grid1.setEditable(false);
            grid2.setEditable(false);
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
                , { id:'achvL' }      //달성수준
                , { id:'userId' }     //사용자ID
            ]
        });
        dataSet1.on('load', function(e) {
            console.log("load goalDataSet Success");
        });
        
        var columnModel1 = new Rui.ui.grid.LColumnModel({
//             autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'prvs', 	label: '평가항목', sortable: false, align:'left', width: 200, editor: textArea }
                , { field: 'evWay', label: '평가방법', sortable: false, align:'left', width: 180, editor: textArea }
                , { field: 'utm', label: '단위', sortable: false, align:'left', width: 80, editor: textArea }
                , { field: 'cur', label: '현재수준', sortable: false, align:'left', width: 150, editor: textArea }
                , { field: 'goal', 	label: '목표수준', sortable: false, align:'left', width: 150, editor: textArea }
                , { field: 'achvL', label: '달성수준', sortable: false, align:'left', width: 150, editor: textArea }
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
            ]
        });
        dataSet2.on('load', function(e) {
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
        
        //평가항목이력 DS
        dataSet3 = new Rui.data.LJsonDataSet({
            id: 'dataSet3',
            remainRemoved: true,
            fields: [
                  { id:'tssNosSt' } //차년도            
                , { id:'pgsStepNm' }     //진행단계  
                , { id:'prvs' }     //항목       
                
            ]
        });
        
        var columnModel3 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
               		{ field: 'tssNosSt', label: '차수', sortable: false, align:'center', width: 50 }
               	   ,{ field: 'pgsStepNm', label: '진행단계', sortable: false, align:'center', width: 50 }
               	  , { field: 'prvs',  label: '평가항목', sortable: false, align:'center', width: 80 }
            ]
        });
        
        var grid3 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel3,
            dataSet: dataSet3,
            width: 470,
            height: 200,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        grid3.render('evHisPopupGrid');
        
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
        var vm1 = new Rui.validate.LValidatorManager({
            validators: [  
                  { id:'tssCd',      validExp: '과제코드:false' }
                , { id:'goalArslSn', validExp: '과제목표일련번호:false' }       
                , { id:'prvs',       validExp: '평가항목:true' } 
                , { id:'evWay',      validExp: '평가방법:true' }
                , { id:'utm',        validExp: '단위:true' } 
                , { id:'cur',        validExp: '현재수준:true' } 
                , { id:'goal',       validExp: '목표수준:true' } 
                , { id:'achvL',      validExp: '달성수준:true' }
                , { id:'arsl',       validExp: '실적:false' } 
                , { id:'step',       validExp: '단계:false' } 
                , { id:'userId',     validExp: '사용자ID:false' }
            ]
        });
        
        var vm2 = new Rui.validate.LValidatorManager({
            validators: [  
                  { id:'tssCd',      validExp: '과제코드:false' } 
                , { id:'yldItmSn',   validExp: '과제산출물일련번호:false' }      
                , { id:'goalY',      validExp: '목표년도:true' } 
                , { id:'yldItmType', validExp: '산출물유형:true' }  
                , { id:'goalCt',     validExp: '목표개수:false' } 
                , { id:'arslYymm',   validExp: '실적년월:false' } 
                , { id:'yldItmNm',   validExp: '산출물명:false' } 
                , { id:'yldItmTxt',  validExp: '산출물내용:false' }  
                , { id:'userId',     validExp: '사용자ID:false' }
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
	                        url:'<c:url value="/prj/tss/nat/deleteNatTssPlnGoal.do"/>',
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
            
            if(!vm1.validateDataSet(dataSet1, dataSet1.getRow())) { 
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm1.getMessageList().join('<br>'));
                return false;
            }
            
            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    dm.updateDataSet({
                        url:'<c:url value="/prj/tss/nat/updateNatTssPlnGoal.do"/>',
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
            
            record.set("tssCd",  lvTssCd);
            record.set("userId", lvUserId);
        });
        
        //산출물삭제
        var butYldDel = new Rui.ui.LButton('butYldDel');
        butYldDel.on('click', function() {    
            var chkRows = dataSet2.getMarkedRange().items;
            for(var i = 0; i < chkRows.length; i++) {
                if(chkRows[i].data.yldItmSn == 1) {
                    Rui.alert("GRS심의파일은 삭제가 불가합니다.");
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
	                        url:'<c:url value="/prj/tss/nat/deleteNatTssPlnYld.do"/>',
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
            
            if(!vm2.validateDataSet(dataSet2, dataSet2.getRow())) { 
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm2.getMessageList().join('<br>'));
                return false;
            }
            
            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    dm.updateDataSet({
                        url:'<c:url value="/prj/tss/nat/updateNatTssPlnYld.do"/>',
                        dataSets:[dataSet2]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        //[다이얼로그] 평가 이력 
    	var popupDialog = new Rui.ui.LDialog({ 
            applyTo: 'evHisPopupLst', 
            width: 500,
            visible: false,
            postmethod: 'none',
            buttons: [ 
                { text:'닫기', isDefault: true, handler: function() {
                    this.cancel(false);
                } } 
            ]
        });
           
        //평가항목이력
    	var butEvHis = new Rui.ui.LButton('butEvHis');
    	butEvHis.on('click', function() {
    		popupDialog.show(true);
    	});
        
        
        //목록
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
         */
        //조회
        fnSearch = function(targetDs) {
        	if(targetDs == "GOAL") {
	            dataSet1.load({ 
	                url: "<c:url value='/prj/tss/nat/retrieveNatTssPlnGoal.do'/>"
	              , params : {
	                    tssCd : lvTssCd
	                }
	            });
        	}
        	else if(targetDs == "YLD") {
	            dataSet2.load({ 
	                url: "<c:url value='/prj/tss/nat/retrieveNatTssPlnYld.do'/>"
	              , params : {
	                    tssCd : lvTssCd
	                }
	            });
        	}
        	else {
	            dataSet3.load({ 
	                url: "<c:url value='/prj/tss/nat/retrieveGoalEvHis.do'/>"
	              , params : {
	                    tssCd : lvTssCd
	                }
	            });
        	}
        };
        
        fnSearch("GOAL");
        fnSearch("YLD");
        fnSearch("EV");
        
		popupDialog.hide();  
		
		disableFields();
		
		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butGoalAdd").hide();
        	$("#butGoalDel").hide();
        	$("#butYldAdd").hide();
        	$("#butYldDel").hide();
        	$("#btnGoalSave").hide();
        	$("#btnYldSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butGoalAdd").hide();
        	$("#butGoalDel").hide();
        	$("#butYldAdd").hide();
        	$("#butYldDel").hide();
        	$("#btnGoalSave").hide();
        	$("#btnYldSave").hide();
		}
    });
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("LblockBody");
}); 
</script>
</head>
<body id="LblockBody">
<div id="formDiv">
    <form name="form" id="goalForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
    </form>
</div>
<div id="LblockMainBody">
    <!-- 컨텐츠 영역 -->
     <div class="titArea">
    	<span class="sub-tit"><h4>&gt; 목표기술성과 등록</h4></span>
        <div class="LblockButton">
          		<button type="button" id="butEvHis"   name="">평가항목이력</button>
                <button type="button" id="butGoalAdd" name="">추가</button>
       			<button type="button" id="butGoalDel" name="">삭제</button>
        </div>
    </div>
    
    <div id="goalGrid" ></div>

    <div class="titArea">
		<div class="LblockButton">
			  <button type="button" id="btnGoalSave">저장</button>
		</div>
	</div>

	<br>

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
			<!-- <button type="button" id="btnList" name="btnList">목록</button> -->
		</div>
	</div>
	
	
			<div id="evHisPopupLst">
			<div class="hd">평가항목이력</div>
                <div class="bd">
					<div id="evHisPopupGrid"></div>
				</div>
			</div>
	
	</div>
	

</body>
</html>