<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoDtl.jsp
 * @desc    : 자산기간관리 신규등록 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.09.18  IRIS05		최초생성
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMultiCombo.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMultiCombo.css"/>

<script type="text/javascript">
var resultDataSet;

	Rui.onReady(function() {
		var id = document.aform.rlisTrmId.value;
		
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
		
		/** dataSet **/
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'rlisTitl' }
				, { id: 'fromRlisDt' }
				, { id: 'toRlisDt' }
				, { id: 'rlisClCd' }
				, { id: 'rlisSbc'}
				, { id: 'rlisFxaClss'}
				, { id: 'rlisTrmId'}			/* 이관사유 */
			]
        });

        //실사제목
        var rlisTitl = new Rui.ui.form.LTextBox({
            applyTo: 'rlisTitl',
            placeholder: '',
            width: 200
        });

        //실사시작일
        var fromRlisDt = new Rui.ui.form.LDateBox({
            applyTo: 'fromRlisDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue: new Date(),
            listPosition : 'down',
            dateType: 'string'
        });

        //실사종료일
        var toRlisDt = new Rui.ui.form.LDateBox({
            applyTo: 'toRlisDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue: new Date(),
            listPosition : 'down',
            dateType: 'string'
        });

		//실사구분 radio
		var rdRlisClCd = new Rui.ui.form.LRadioGroup({
            applyTo : 'rlisClCd',
            name : 'rlisClCd',
            items : [
                {
                    label : '전체',
                    value : 'AL'
                }, {
                    label : '자산클래스',
                    value : 'CLSS'
                }
            ]
        });
		
		//전체나 자산클래스일경우 자산클래스 콤보 선택 이벤트
	   rdRlisClCd.on('changed', function(){
			if(rdRlisClCd.getValue() == "AL"){
				cbRlisFxaClss.disable();
			}else{
				cbRlisFxaClss.enable();
			}
	   });

		//자산클래스 멀티combo
		 var cbRlisFxaClss = new Rui.ui.form.LMultiCombo({
            applyTo: 'rlisFxaClss',
            name: 'rlisFxaClss',
            width : 200,
            useEmptyText: false,
	        url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=RLIS_FXA_CLSS"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD'
        });

		 cbRlisFxaClss.on('load', function(e) {

	     });

	 	//실사사유 textarea
	   var rlisSbc = new Rui.ui.form.LTextArea({
            applyTo: 'rlisSbc',
            placeholder: '',
            width: 800,
            height: 150
       });

	   fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/rlisAnl/retrieveFxaRlisAnlInfo.do"/>' ,
	            params :{
	            	rlisTrmId : document.aform.rlisTrmId.value
               }
           });

       }
       // 화면로드시 조회
	    fnSearch();
       
        /* [DataSet] bind */
	    var dataSet = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: dataSet,
	        bind: true,
	        bindInfo: [
		    	  {id: 'rlisTitl', 		ctrlId: 'rlisTitl',  	value: 'value' }
		    	, {id: 'fromRlisDt',  	ctrlId: 'fromRlisDt',   value: 'value' }
		    	, {id: 'toRlisDt',      ctrlId: 'toRlisDt',     value: 'value' }
		    	, {id: 'rlisClCd',    	ctrlId: 'rlisClCd',   value: 'value' }
		    	, {id: 'rlisSbc',       ctrlId: 'rlisSbc',      value: 'value' }
		    	, {id: 'rlisFxaClss',   ctrlId: 'rlisFxaClss',  value: 'value' }
		    	, {id: 'rlisTrmId',     ctrlId: 'rlisTrmId',    value: 'value' }
	        ]
	    });

	   /* [버튼] : 저장  */
	   	var butSave = new Rui.ui.LButton('butSave');
	   	butSave.on('click', function(){
	   		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
	   		dm.on('success', function(e) {      // 업데이트 성공시
	   			var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    		 	
    			if( resultData.records[0].rtnSt == "S"){
		   			parent.fnSearch();
		   			parent.fxaRlisAnlDialog.submit(true);
    			}
	   	    });

	   	    dm.on('failure', function(e) {      // 업데이트 실패시
	   	    	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
	   	    });

			if(fncVaild()){
				Rui.confirm({
		   			text: '실사요청하시겠습니까?',
		   	        handlerYes: function() {
		   	        	 dm.updateForm({
		   	        	    url: "<c:url value='/fxa/rlisAnl/saveFxaRlisAnlInfo.do'/>",
		   	        	    form : 'aform'
		   	        	    });
		  	     	}
	    	    });
			}
	   	});
	   	
	    /* [버튼] : 닫기  */
	   	var butCls = new Rui.ui.LButton('butCls');
	   	butCls.on('click', function(){
	   		parent.fxaRlisAnlDialog.submit(true);
	   	});
	   	
	   	
	   	//저장 vaild
	   	var fncVaild = function(){
			var frm = document.aform;

			if( Rui.isEmpty(rlisTitl.getValue())){
				Rui.alert("실사제목을 입력해주십시오");
				frm.rlisTitl.focus();
				return false;
			}
			if(Rui.isEmpty(fromRlisDt.getValue())){
				Rui.alert("실사시작일을 입력해주십시오");
				frm.fromRlisDt.focus();
				return false;
			}
			if(Rui.isEmpty(toRlisDt.getValue())){
				Rui.alert("실사종료일을 입력해주십시오");
				frm.toRlisDt.focus();
				return false;
			}
			if(rdRlisClCd.getValue() == "CLSS"){
				if( cbRlisFxaClss == "" ){
					Rui.alert("실사구분이 자산클래스일 경우 자산클래스값을 입력하셔야합니다.");
					return false;
				}
			}
			if(Rui.isEmpty(rdRlisClCd.getValue())){
				Rui.alert("실사구분을 선택하여주십시오.");
				return false;
			}
			if(Rui.isEmpty(rlisSbc.getValue())){
				Rui.alert("실사사유를 입력해주십시오");
				frm.rlisSbc.focus();
				return false;
			}

			return true;
	   	}
	   	
	   	if(id != ""){
			butSave.disable();
		}
		

	}); // end RUI Lodd



</script>
</head>

<body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="menuType" name="menuType" />
	<%-- 	<input type="hidden" id="fxaInfoId" name="fxaInfoId" value="<c:out value='${inputData.fxaInfoId}'/>"> --%>
			<input type="hidden" id="rlisTrmId" name="rlisTrmId" value="<c:out value='${inputData.rlisTrmId}'/>">

		<table id="txa_p" class="table table_txt_right">
			<div class="titArea">
					<h3></h3>
					<div class="LblockButton">
						<button type="button" id="butSave">실사요청</button>
						<button type="button" id="butCls">닫기</button>
					</div>
				</div>
			<colgroup>
				<col style="width:120px;"/>
				<col style=""/>
				<col style="width:120px"/>
				<col style=""/>
			</colgroup>
			<tbody>
				<tr>
					<th align="right"><span style="color:red;">*  </span>실사제목</th>
					<td>
						<input type="text" id="rlisTitl" />
					</td>
					<th align="right"><span style="color:red;">*  </span>실사기간</th>
					<td>
						<input type="text" id="fromRlisDt" /> &nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;&nbsp; <input type="text" id="toRlisDt"/>
					</td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">*  </span>실사구분</th>
					<td>
						<div id="rlisClCd"></div>
					</td>
					<th align="right">자산클래스</th>
					<td>
						<div id="rlisFxaClss"></div>
					</td>
				</tr>
				<tr>
					<th align="right">실사사유</th>
					<td colspan="3">
						<textarea id="rlisSbc"></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</form>

</body>
</html>