<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPgsGoalYldIfm.jsp
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
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
    var lvCount ;

    var pageMode = (lvPgsCd == "PG" || lvPgsCd == "CM" || lvPgsCd == "DC") && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";

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
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=YLD_ITM_TYPE_G"/>',
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

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "R") {
                btnGoalSave.hide();
                btnYldSave.hide();

                grid1.setEditable(true);
                grid2.setEditable(false);
            }
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
            console.log("goal load dataSet Success");
        });


        //목표 그리드
        var columnModel1 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'prvs', label: '항목', sortable: false, align:'left', width: 200, editor: new Rui.ui.form.LTextArea() }
                , { field: 'cur',  label: '현재', sortable: false, align:'left', width: 200, editor: new Rui.ui.form.LTextArea() }
                , { field: 'goal', label: '목표', sortable: false, align:'left', width: 200, editor: new Rui.ui.form.LTextArea() }
                , { field: 'arsl', label: '실적', sortable: false, align:'left', width: 300, editor: new Rui.ui.form.LTextArea() }
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
                , { id:'goalCt' }     //목표개수
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

            openAttachFileDialog(setAttachFileInfo, stringNullChk(filId), 'prjPolicy', '*', pageMode);
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
        var vm1 = new Rui.validate.LValidatorManager({
            validators: [
                  { id:'tssCd',      validExp: '과제코드:false' }
                , { id:'goalArslSn', validExp: '과제목표일련번호:false' }
                , { id:'prvs',       validExp: '항목:false' }
                , { id:'cur',        validExp: '현재:false' }
                , { id:'goal',       validExp: '목표:false' }
                , { id:'arsl',       validExp: '실적:true' }
                , { id:'step',       validExp: '단계:false' }
                , { id:'utm',        validExp: '단위:false' }
                , { id:'evWay',      validExp: '평가방법:false' }
                , { id:'userId',     validExp: '사용자ID:false' }
            ]
        });
        var vm2 = new Rui.validate.LValidatorManager({
            validators: [
                  { id:'tssCd',      validExp: '과제코드:false' }
                , { id:'yldItmSn',   validExp: '과제산출물일련번호:false' }
                , { id:'goalY',      validExp: '목표년도:false' }
                , { id:'yldItmType', validExp: '산출물유형:false' }
                , { id:'goalCt',     validExp: '목표개수:false' }
//                 , { id:'arslYymm',   validExp: '실적년월:true' }
                , { id:'yldItmNm',   validExp: '산출물명:false:maxLength=1000' }
//                 , { id:'yldItmTxt',  validExp: '산출물내용:false' }
                , { id:'userId',     validExp: '사용자ID:false' }
            ]
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
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
	                url: "<c:url value='/prj/tss/gen/retrieveGenTssPgsGoal.do'/>"
	              , params : {
	                    tssCd : lvTssCd
	                }
	            });
        	}
        	else {
	            dataSet2.load({
	                url: "<c:url value='/prj/tss/gen/retrieveGenTssPgsYld.do'/>"
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

            if(!vm1.validateDataSet(dataSet1, dataSet1.getRow())) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm1.getMessageList().join('<br>'));
                return false;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
		            dm.updateDataSet({
		                url:'<c:url value="/prj/tss/gen/updateGenTssPgsGoal.do"/>',
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

            if(!vm2.validateDataSet(dataSet2, dataSet2.getRow())) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm2.getMessageList().join('<br>'));
                return false;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
		            dm.updateDataSet({
		                url:'<c:url value="/prj/tss/gen/updateGenTssPgsYld.do"/>',
		                dataSets:[dataSet2]
		            });
                },
		        handlerNo: Rui.emptyFn
            });
        });


        //목록
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        }); */


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

<!-- <div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnList" name="btnList">목록</button>
    </div>
</div> -->
</body>
</html>