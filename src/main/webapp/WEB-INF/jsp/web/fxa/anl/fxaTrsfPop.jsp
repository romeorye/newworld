<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoDtl.jsp
 * @desc    : 자산 상세정보 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.09.11  IRIS05		최초생성
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

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>


<script type="text/javascript">
var prjUserSearchDialog
var body ;
var crgrNm;

	Rui.onReady(function() {
		
		crgrNm = '${inputData.crgrNm}';
		
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
                , { id: 'guId' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
        
		/** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'wbsCd' }
				, { id: 'fromPrjNm'}
				, { id: 'fromPrjId'}
				, { id: 'fxaNo'}
				, { id: 'fxaNm'}
				, { id: 'fromCrgrNm'}
				, { id: 'fromCcrgrId'}
				, { id: 'toPrjNm'}
				, { id: 'toPrjId'}
				, { id: 'toCrgrNm'}
				, { id: 'toCcrgrId'}
				, { id: 'trsfRson'}			/* 이관사유 */
			]
        });

        dataSet.on('load', function(e) {
        	//dataSet.setValue(0, 1, <c:out value='${inputData.prjNm}'/>);
        });

        //이관사유
        var trsfRson = new Rui.ui.form.LTextArea({
            applyTo: 'trsfRson',
            placeholder: '',
            width: 600,
            height: 100
        });

        //프로젝트명
        var toPrjNm = new Rui.ui.form.LTextBox({
            applyTo: 'toPrjNm',
            placeholder: '',
            width: 200
        });

        toPrjNm.disable();
        
        
        /* 담당자 팝업 */
	    var toCrgrNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'toCrgrNm',
            width: 150,
            editable: true,
            placeholder: '',
            enterToPopup: true
        });

	    toCrgrNm.on('popup', function(e){
	    	var displayValue = e.displayValue;
	    	openPrjUserSearchDialog(setPrjUserInfo , displayValue);
       	});

	    prjUserSearchDialog = new Rui.ui.LFrameDialog({
	        id: 'prjUserSearchDialog',
	        title: '사용자 조회',
	        width: 600,
	        height: 280,
	        modal: true,
	        visible: false
	    });

	    prjUserSearchDialog.render(document.body);
	    
	    openPrjUserSearchDialog = function(f ,nm) {
	    	_callback = f;
	    	var params = escape(encodeURIComponent(nm));
	    	
	    	prjUserSearchDialog.setUrl('<c:url value="/fxa/fxaInfo/retrievePrjUserInfo.do?userNm="/>'+params);
	    	prjUserSearchDialog.show();
	    };

	    setPrjUserInfo = function (user){
	    	var frm = document.aform;
	    	toCrgrNm.setValue(user.saName);
	    	toPrjNm.setValue(user.prjNm);
	    	
	    	frm.toDeptCd.value =user.deptCd;
	    	frm.toWbsCd.value =user.wbsCd;
	    	frm.toCrgrId.value =user.saSabun;
	    	frm.prjNm.value =user.prjNm;
	    };


	    /* 자산이관신청 등록 저장 */
		var butReg = new Rui.ui.LButton('butSave');
		butReg.on('click', function(){
			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
	   		dm.on('success', function(e) {      // 업데이트 성공시
	   			var resultData = resultDataSet.getReadData(e);
	   			var fxaTrsfId = "F"+resultData.records[0].guId;

	   			Rui.alert(resultData.records[0].rtnMsg);
	   			
	   			if( resultData.records[0].rtnSt == "S"){
		   		    //parent.fnSearch();
		   			parent.fxaTrsfDialog.submit(true);
		   			var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00338&from=iris&guid='+fxaTrsfId;
               		openWindow(url, 'fxaTrsfPop', 800, 500, 'yes');
	   			}
	   	    });

	   	    dm.on('failure', function(e) {      // 업데이트 실패시
	   	    	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
	   	    });

			if(fncVaild()){
				Rui.confirm({
		   			text: '이관요청하시겠습니까?',
		   	        handlerYes: function() {
		   	        	 dm.updateForm({
		   	        	    url: "<c:url value='/fxa/trsf/insertFxaTrsfInfo.do'/>",
		   	        	    form : 'aform'
		   	        	    });
		  	     	}
	    	    });
			}
			
        });

	    /* 닫기  */
		var butClose = new Rui.ui.LButton('butClose');
		butClose.on('click', function(){
			parent.fxaTrsfDialog.submit(true);
        });

		var fncVaild = function(){
			var frm =document.aform;
			
			if(Rui.isEmpty(toPrjNm.getValue())){
				Rui.alert("이관할 프로젝트를 선택하여 주십시오");
				toPrjNm.focus();
				return;
			}
			if(Rui.isEmpty(toCrgrNm.getValue())){
				Rui.alert("이관담당자를를 선택하여 주십시오");
				toCrgrNm.focus();
				return;
			}
			if(Rui.isEmpty(frm.toCrgrId.value)){
				Rui.alert("담당자 팝업에서 선택하셔야 합니다.");
				toCrgrNm.focus();
				return;
			}
			
			return true;
		}

		
	}); // end RUI Lodd

	function fncDialogClose(){
		prjUserSearchDialog.submit(true);
	}

</script>
</head>

<body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="menuType" name="menuType" />
		<input type="hidden" id="fromWbsCd" name="fromWbsCd" value="<c:out value='${inputData.wbsCd}'/>">
		<input type="hidden" id="fromDeptCd" name="fromDeptCd" value="<c:out value='${inputData.deptCd}'/>">
		
		<input type="hidden" id="toCrgrId" name="toCrgrId" />
		<input type="hidden" id="toDeptCd" name="toDeptCd" />
		<input type="hidden" id="toWbsCd" name="toWbsCd" />
		
		<input type="hidden" id="fromCrgrId" name="fromCrgrId" value="<c:out value='${inputData.crgrId}'/>">
		<input type="hidden" id="fxaInfoId" name="fxaInfoId" value="<c:out value='${inputData.fxaInfoId}'/>">

		<input type="hidden" id="fxaNo" name="fxaNo" value="<c:out value='${inputData.fxaNo}'/>">
		<input type="hidden" id="fxaNm" name="fxaNm" value="<c:out value='${inputData.fxaNm}'/>">
		<input type="hidden" id="fromPrjNm" name="fromPrjNm" value="<c:out value='${inputData.prjNm}'/>">
		<input type="hidden" id="prjNm" name="prjNm" />
		<input type="hidden" id="crgrNm" name="crgrNm" value="<c:out value='${inputData.crgrNm}'/>">
		

		<table class="table table_txt_right">
			<div class="titArea">
					<h3></h3>
					<div class="LblockButton">
						<button type="button" id="butSave">이관요청</button>
						<button type="button" id="butClose">닫기</button>
					</div>
				</div>
			<colgroup>
				<col style="width:10%;"/>
				<col style="width:40%;"/>
				<col style="width:10%;"/>
				<col style="width:40%;"/>
			</colgroup>
			<tbody>
				<tr>
					<th align="right">자산번호</th>
					<td>
						<c:out value='${inputData.fxaNo}'/>
					</td>
					<th align="right">자산명</th>
					<td>
						<c:out value='${inputData.fxaNm}'/>
					</td>
				</tr>
				<tr>
					<th align="right">이전PJT</th>
					<td>
						<c:out value='${inputData.prjNm}'/>
					</td>
					<th align="right">이전담당자</th>
					<td>
						<c:out value='${inputData.crgrNm}'/>
					</td>
				</tr>
				<tr>
					<th align="right">이관PJT</th>
					<td>
						<input type="text" id="toPrjNm">
					</td>
					<th align="right">이관담당자</th>
					<td>
						<input type="text" id="toCrgrNm">
					</td>
				</tr>
				<tr>
					<th align="right">아관사유</th>
					<td colspan="3">
						<div id="trsfRson"></div>
					</td>
				</tr>
			</tbody>
		</table>
		<br>
			<span style="color:red; align:right;">*  </span><b>이관담당자를 선택하면 이관PJT가 자동입력됩니다.</b></font>
	</form>

</body>
</html>