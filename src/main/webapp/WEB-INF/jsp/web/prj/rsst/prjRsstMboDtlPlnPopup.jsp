<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: prjRsstMboDtlPrvsPopup.jsp
 * @desc    : MBO 계획등록 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.08.22  IRIS04		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">
var pTopForm = parent.parent.topForm;	// 프로젝트마스터 폼
var popupDataSet0301;					// 데이터셋
var vmTab0301;							// validator

var nowDate = new Date();
var nYear  = nowDate.getFullYear();

Rui.onReady(function() {

	 /* form 세팅 */
	var lcbMboGoalYear = new Rui.ui.form.LCombo({
		applyTo: 'mboGoalYear',
    	useEmptyText: true,
        emptyText: '선택',
        defaultValue: nYear,
        items: [
        	<c:forEach var="i" begin="0" varStatus="status" end="19">
     		{ value : "${ 2030 - i }" , text : "${ 2030 - i }" } ,
     		</c:forEach>
        ]
    });

	var lnbMboGoalAltp = new Rui.ui.form.LNumberBox({
        applyTo: 'mboGoalAltp',
        minValue: 0,
        maxValue: 10000,
        width: 105
    });

	var ltbMboGoalPrvs = new Rui.ui.form.LTextBox({
	     applyTo : 'mboGoalPrvs',
	     //placeholder : '',
	     defaultValue : '',
	     emptyValue: '',
	     width : 350
	});

	var ltaMboGoalL = new Rui.ui.form.LTextArea({
	   applyTo: 'mboGoalL',
	   placeholder: '',
	   width: 350,
	   height: 100
	});

	/* DATASET : grid */
	popupDataSet0301 = new Rui.data.LJsonDataSet({
	    id: 'popupDataSet0301',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	          { id: 'prjCd' }
	        , { id: 'wbsCd' }
	        , { id: 'seq' }
	        , { id: 'mboGoalYear' }
	        , { id: 'mboGoalAltp' }
	        , { id: 'mboGoalPrvs' }
	        , { id: 'mboGoalL' }
	        , { id: 'arlsYearMon' }
	        , { id: 'arlsStts' }
	        , { id: 'filId' }
	    ]
	});
	
	popupDataSet0301.on('load', function(e){
		if( popupDataSet0301.getCount() > 0 && Rui.isEmpty(popupDataSet0301.getAt(0).get('prjCd')) ){
			popupDataSet0301.setNameValue(0, 'mboGoalYear', nYear);
		}
    });
	
	/* [DataSet] bind */
    var bind = new Rui.data.LBind({
        groupId: 'popupForm01',
        dataSet: popupDataSet0301,
        bind: true,
        bindInfo: [
        	  { id: 'mboGoalYear',  ctrlId: 'mboGoalYear',      value: 'value' }
            , { id: 'mboGoalAltp',  ctrlId: 'mboGoalAltp',      value: 'value' }
            , { id: 'mboGoalPrvs',  ctrlId: 'mboGoalPrvs',      value: 'value' }
            , { id: 'mboGoalL',     ctrlId: 'mboGoalL',         value: 'value' }
        ]
    });

	/* [버튼] 저장 */
	var butRgst = new Rui.ui.LButton('butRgst');
	butRgst.on('click', function() {
		var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		// 1. 데이터셋 valid
		if(!validation('popupForm01')){
    		return false;
    	}

		// 2. 데이터 저장&업데이트
		Rui.confirm({
	        text: '저장하시겠습니까?', //Rui.getMessageManager().get('$.base.msg105'),
	        handlerYes: function() {

	        	// 등록처리
        	    dm1.updateForm({
	        	    url: "<c:url value='/prj/rsst/mbo/insertPrjRsstMboInfo.do'/>",
	        	    form: 'popupForm01',
	        	    params: {
        	            prjCd : pTopForm.prjCd.value
        	          , wbsCd : pTopForm.wbsCd.value
        	        }
	        	});
	        },
	        handlerNo: Rui.emptyFn
	    });

    	// 성공시 메시지팝업창 후 부모창 재조회
		dm1.on('success', function(e) {
            var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);

            parent.fnSearch();
            parent.mboPlnDialog.cancel(true);

		});

		// 실패시 메시지팝업창 노출
		dm1.on('failure', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});
	});

	<%-- VALIDATOR --%>
	vmTab0301 = new Rui.validate.LValidatorManager({
        validators:[
	        { id: 'mboGoalYear' , validExp:'목표년도:true'}
	      , { id: 'mboGoalAltp' , validExp:'목표배점:true:number'}
	      , { id: 'mboGoalPrvs' , validExp:'목표항목:true'}
	      //, { id: 'mboGoalL'    , validExp:'목표수준:true'}
        ]
    });

	// 데이터 초기 조회
    fnSearch();

}); // end RUI Lodd

<%--/*******************************************************************************
 * FUNCTION 명 : fnSearch
 * FUNCTION 기능설명 : MBO 단건 조회(popupDataSet0301)
 *******************************************************************************/--%>
function fnSearch(){

	popupDataSet0301.load({
        url: '<c:url value="/prj/rsst/mbo/retrievePrjRsstMboSearchDtlInfo.do"/>' ,
        params :{
		    prjCd : popupForm01.hPrjCd.value
		  , wbsCd : popupForm01.hWbsCd.value
		  , seq   : popupForm01.hSeq.value
        }
    });

}
<%--/*******************************************************************************
 * FUNCTION 명 : validation
 * FUNCTION 기능설명 : 입력 폼 점검
 *******************************************************************************/--%>
function validation(vForm){

 	var vTestForm = vForm;
 	if(vmTab0301.validateGroup(vTestForm) == false) {
 		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vmTab0301.getMessageList().join('<br>') );
 		return false;
 	}

 	return true;
 }

</script>
</head>

<body>
	<form name="popupForm01" id="popupForm01" method="post">
	<input type="hidden" id="hPrjCd" name="hPrjCd" value="<c:out value='${inputData.prjCd}'/>"/>
	<input type="hidden" id="hWbsCd" name="hWbsCd" value="<c:out value='${inputData.wbsCd}'/>"/>
	<input type="hidden" id="hSeq" name="hSeq" value="<c:out value='${inputData.seq}'/>"/>

<!--   		<div class="contents">
  			<div class="sub-content"> -->

	   			<div class="titArea">
			    	<h3>계획 MBO(특성지표)</h3>
			        <div class="LblockButton">
			            <!-- <button type="button" id="butClear" name="butClear">초기화</button> -->
			            <button type="button" id="butRgst" name="butRgst">저장</button>
		        	</div>
		    	</div>

  				<table class="table table_txt_right">
  					<colgroup>
  						<col style="width:20%;"/>
  						<col style="width:30%;"/>
  						<col style="width:20%;"/>
  						<col style="width:30%;"/>
  					</colgroup>
  					<tbody>
  						<tr>
  							<th align="right">목표년도</th>
  							<td>
  								<!-- <input type="text" id="mboGoalYear" value=""> -->
  								<select id="mboGoalYear"></select>
  							</td>
  							<th align="right">목표배점</th>
   							<td>
  								<input type="text" id="mboGoalAltp" value="">
   							</td>
  						</tr>
  						<tr>
  							<th align="right">목표항목</th>
  							<td colspan="3">
  								<input type="text" id="mboGoalPrvs" value="">
  							</td>
  						</tr>
  						<tr>
  							<th align="right">목표수준</th>
  							<td colspan="3">
  								<!-- <input type="text" id="mboGoalL" value=""> -->
  								<textarea id="mboGoalL"></textarea>
  							</td>
  						</tr>
  					</tbody>
  				</table>

<!--   			</div>//sub-content
  		</div>//contents -->
	</form>

    </body>
</html>