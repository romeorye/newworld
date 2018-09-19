<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssPgsGoalYldIfm.jsp
 * @desc    : 대외협력과제 > 진행 목표 및 산출물 탭 화면
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    var lvCount ;

    var pageMode = lvPgsCd == "PG" || lvPgsCd == "CM" || lvPgsCd == "DC"  && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";

    var dataSet1;
    var dataSet2;
    var popupRow;
    var pageMode;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //산출물유형
        cboYldItmType = new Rui.ui.form.LCombo({
            name: 'cboYldItmType',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=YLD_ITM_TYPE_O"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            rendererField: 'value',
            autoMapping: true
        });
        cboYldItmType.getDataSet().on('load', function(e) {
            console.log('cboYldItmType :: load');
        });

        //실적년월
        arslYymm = new Rui.ui.form.LTextBox({
            mask:'9999-99',
            maskPlaceholder: '_',
            maskValue:true
        });

      	//그리드 TextArea
        gridTextArea = new Rui.ui.form.LTextArea({
            disabled: pageMode == "W" ? false : true
        });

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;

            btnGoalSave.hide();
            btnYldSave.hide();

            //grid1.setEditable(false);
            grid2.setEditable(false);

            // 체크박스, 상태 컬럼 제거
            columnModel1.getColumnAt(0).setHidden(true);
            columnModel1.getColumnAt(1).setHidden(true);

            // grid1 실적 editable false disabled true
            //columnModel1.getColumnAt(8).setEditable(false);
            //columnModel1.getColumnAt(8)._setDisabled();

            columnModel2.getColumnAt(0).setHidden(true);
        };

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //목표 dataSet
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
        });

        //목표 그리드
        var columnModel1 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                    new Rui.ui.grid.LSelectionColumn()
                  , new Rui.ui.grid.LStateColumn()
                  , new Rui.ui.grid.LNumberColumn()
                  , { field: 'step',  label: '단계',     sortable: false, align:'left', width: 100, editor: new Rui.ui.form.LTextBox({editable: false, disabled: true}) }
                  , { field: 'prvs',  label: '평가항목', sortable: false, align:'left', width: 180, editor: new Rui.ui.form.LTextArea({editable: false, disabled: true}) }
                  , { field: 'evWay', label: '평가방법', sortable: false, align:'left', width: 180, editor: new Rui.ui.form.LTextArea({editable: false, disabled: true}) }
                  , { field: 'goal',  label: '목표수준', sortable: false, align:'left', width: 180, editor: new Rui.ui.form.LTextArea({editable: false, disabled: true}) }
                  , { field: 'cur',   label: '현재수준', sortable: false, align:'left', width: 180, editor: new Rui.ui.form.LTextArea({editable: false, disabled: true}) }
                  , { field: 'arsl',  label: '실적',     sortable: false, align:'left', width: 180, editor: gridTextArea }
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

        //산출물 dataSet
        dataSet2 = new Rui.data.LJsonDataSet({
            id: 'yldDataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id:'tssCd' }      //과제코드
                , { id:'userId' }     //사용자ID
                , { id:'yldItmSn' }   //과제산출물일련번호
                , { id:'goalY' }      //목표년도
                , { id:'yldItmType' } //산출물유형
//                , { id:'goalCt' }     //목표개수
                , { id:'arslYymm' }   //실적년월
                , { id:'yldItmYn' }   //산출물유무
                , { id:'yldItmNm' }   //산출물명
                , { id:'yldItmTxt' }  //산출물내용
                , { id:'attcFilId' }  //파일ID
            ]
        });

        dataSet2.on('load', function(e) {
            console.log("goal load dataSet Success");

            for(var i=0; i<dataSet2.getCount(); i++){
            	var yldItmYn = dataSet2.getNameValue(i,"attcFilId");

	            if(Rui.isUndefined(yldItmYn)){
	            	dataSet2.setNameValue(i,"yldItmYn","N");
	            }else{
	            	dataSet2.setNameValue(i,"yldItmYn","Y");
	            }
            }
        });

        //산출물 그리드
        var columnModel2 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                new Rui.ui.grid.LStateColumn()
              , new Rui.ui.grid.LNumberColumn()
              , { field: 'goalY', label: '목표년도', sortable: false, align:'center', width: 80 }
              , { field: 'yldItmType',  label: '산출물유형', sortable: false, align:'center', width: 150, editor: cboYldItmType, renderer: function(value, p, record, row, col) {
                  p.editable = false;
                  return value;
              } }
              , { field: 'arslYymm', label: '실적년월', sortable: false, align:'center', width: 70, editor: arslYymm, renderer: function(value, p, record, row, col) {
                  if(stringNullChk(value) != "") {
                      var iVal = parseInt(value.substring(5, 7));
                      var sVal = value.substring(0, 5);

                      if(iVal < 13 && iVal > 0) {
                          sVal += iVal < 10 == 1 ? "0"+iVal : String(iVal);
                      } else {
                          sVal = null;
                      }

                      record.set("arslYymm", sVal);
                      return sVal;
                  } else {
                      return null;
                  }
               } }
              , { field: 'yldItmNm', label: '산출물명', sortable: false, align:'left', width: 300, editor: new Rui.ui.form.LTextBox() }
              , { field: 'yldItmYn', label: '첨부파일 유무', sortable: false, align:'center', width: 60 }
              , { field: 'attcFilId', label: '첨부파일', sortable: false, align:'center', width: 100, renderer: function(val, p, record, row, i) {
                  return '<button type="button" class="L-grid-button L-popup-action">첨부파일</button>';
              } }
            ]
        });

        var grid2 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel2,
            dataSet: dataSet2,
            width: 600,
            height: 200,
            autoToEdit: true,
            multiLineEditor: true,
            useRightActionMenu: false,
            autoWidth: true
        });
        grid2.on('popup', function(e) {
            popupRow = e.row;

            var filId = dataSet2.getNameValue(popupRow, "attcFilId");

            openAttachFileDialog(setAttachFileInfo, stringNullChk(filId), 'prjPolicy', '*', pageMode)	// 첨부파일오픈팝업 2로 변경
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

        //목표 유효성 설정
        var goalVm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'arsl',       validExp: '실적:true' }
            ]
        });

        //산출물 유효성 설정
        var yldVm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'yldItmNm',    validExp: '산출물명:false:maxLength=1000' }
//                 , { id: 'attcFilId',   validExp: '첨부파일:true' }
            ]
        });

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        // 목표 valid
        fnGoalValid = function(vm, dataSet){
        	var goalDataSet = dataSet;

        	// 1. 기본
		 	if(vm.validateDataSet(goalDataSet) == false) {
		 		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>') );
		 		return true;
		 	}

        	return false;
        };

        // 산출물 valid
        fnYldValid = function(vm, dataSet){
        	var yldDataSet = dataSet;

        	// 1. 기본
		 	if(vm.validateDataSet(yldDataSet) == false) {
		 		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>') );
		 		return true;
		 	}

//         	//2. 산출물명, 첨부파일 입력체크
//         	for(var i=0; i < yldDataSet.getCount(); i++){
//         		var yldItmNm  = yldDataSet.getNameValue(0 , 'yldItmNm');
//         		var attcFilId = yldDataSet.getNameValue(0 , 'attcFilId');

//         		if( (yldItmNm != "" &&  yldItmNm != null)  &&
//                     (attcFilId == "" || attcFilId == null) ){
//                 		Rui.alert( (i+1) + "번째 필수산출물의 첨부파일을 등록하세요.");
//                         return true;
//                 }

//         		if( (yldItmNm == "" &&  yldItmNm == null)  &&
//                     (attcFilId != "" || attcFilId != null) ){
//                 		Rui.alert( (i+1) + "번째 필수산출물의 산출물명을 입력하세요.");
//                         return true;
//                 }
//         	}

//         	return false;
        };

        //첨부파일
        setAttachFileInfo = function(attachFileList) {
            if(attachFileList.length > 0) {
                dataSet2.setNameValue(popupRow, "attcFilId", attachFileList[0].data.attcFilId);
            }

            lvCount = attachFileList.length ;
            if(lvCount > 0) {
				dataSet2.setNameValue(popupRow,"yldItmYn","Y");
            }else {
				dataSet2.setNameValue(popupRow,"yldItmYn","N");
            }
        };

        //조회
        fnSearch = function(targetDs) {
        	if(targetDs == "GOAL") {
	            dataSet1.load({
	                url: "<c:url value='/prj/tss/ousdcoo/retrieveOusdCooTssPgsGoal.do'/>"
	              , params : {
	                    tssCd : lvTssCd
	                }
	            });
        	}
        	else {
	            dataSet2.load({
	                url: "<c:url value='/prj/tss/ousdcoo/retrieveOusdCooTssPgsYld.do'/>"
	              , params : {
	                    tssCd : lvTssCd
	                }
	            });
        	}
        };

        //목표저장
        var btnGoalSave = new Rui.ui.LButton('btnGoalSave');
        btnGoalSave.on('click', function() {
            if(!dataSet1.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }

         	// valid check
            if( fnGoalValid(goalVm,dataSet1) ) {
	            return;
			}

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
		            dm.updateDataSet({
		                url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssPgsGoal.do"/>',
		                dataSets:[dataSet1]
		            });
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

         	// valid check
            if( fnYldValid(yldVm,dataSet2) ) {
	            return;
			}

            dm.updateDataSet({
                url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssPgsYld.do"/>',
                dataSets:[dataSet2]
            });
        });
/* 
        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
        });
 */

        // 최초 데이터 셋팅
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


        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnGoalSave").hide();
        	$("#btnYldSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnGoalSave").hide();
        	$("#btnYldSave").hide();
		}
        
    });

    // 내부 스크롤 제거
    $(window).load(function() {
        initFrameSetHeight();
    });
</script>
<script>
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
    <h4>목표기술성과 등록</h4>
</div>

<div id="goalGrid"></div>

<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnGoalSave">저장</button>
    </div>
</div>

<div class="titArea">
    <h4>필수산출물 등록</h4>
</div>

<div id="yldGrid"></div>

<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnYldSave">저장</button>
    </div>
</div>
<!-- 
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnList" name="btnList">목록</button>
    </div>
</div> -->
</body>
</html>