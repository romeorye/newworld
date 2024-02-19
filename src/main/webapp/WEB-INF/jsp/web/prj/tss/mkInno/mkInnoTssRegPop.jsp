<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="iris.web.prj.tss.tctm.TctmUrl"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : mkInnoTssRegPop.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2019.11.06   IRIS005     제조혁신과제 등록팝업
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
	
	Rui.onReady(function() {
		
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
        
		dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            focusFirstRow: 0,
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                 { id: 'tssScnCd'}
                ,{ id: 'saUserName'}
                ,{ id: 'saSabunNew'}
                ,{ id: 'prjCd'}
                ,{ id: 'prjNm'}
                ,{ id: 'tssNm'}
                ,{ id: 'prodG'}
                ,{ id: 'bizDptCd'}
                ,{ id: 'tssStrtDd'}
                ,{ id: 'tssFnhDd'}
                ,{ id: 'grsYn'}
                ,{ id: 'deptCode'}
				,{ id: 'prjCd'}
				,{ id: 'upDeptCd'}
                ,{ id: 'fcCd'}
             ]
        });
		
		dataSet.on('load', function(e){
			  
		});
		
		var row = dataSet.newRecord();
		
		//과제리더
        saUserName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saUserName',
            width: 150,
            editable: false,
            enterToPopup: true
        });
        saUserName.on('popup', function(e){
            openUserSearchDialog(setLeaderInfo, 1, '');
        });
        
        setLeaderInfo = function(userInfo){
        	dataSet.setNameValue(row, 'saSabunNew', userInfo.saSabun);
        	dataSet.setNameValue(row, 'saUserName', userInfo.saName);
        	dataSet.setNameValue(row, 'prjCd', userInfo.prjCd);
        	dataSet.setNameValue(row, 'deptCode', userInfo.uperDeptCd);
        	dataSet.setNameValue(row, 'prjNm', userInfo.deptName);
        }
        
		//사업부문(Funding기준)
        fcCd = new Rui.ui.form.LCombo({
            applyTo: 'fcCd',
            name: 'fcCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FC_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        
		//사업부문(Funding기준)
        bizDptCd = new Rui.ui.form.LCombo({
            applyTo: 'bizDptCd',
            name: 'bizDptCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MK_BIZ_DPT_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
		
      	//과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            width: 470
        });
      
      	//제품군
        prodG = new Rui.ui.form.LCombo({
            applyTo: 'prodG',
            name: 'prodG',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PROD_G"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
        
      	//과제기간 시작일
        tssStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssStrtDd',
            mask: '9999-99-99',
            width: 100,
            listPosition : 'down',
            dateType: 'string'
        });

        // 과제기간 종료일
        tssFnhDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssFnhDd',
            mask: '9999-99-99',
            width: 100,
            listPosition : 'down',
            dateType: 'string'
        });
        
		fncMkInnoReg = function(){
			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
			
			dm.on('success', function (e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);

				alert(resultData.records[0].rtnMsg);
				parent.fnSearch();
				parent.mkInnoRegDialog.submit(true);
				
	       	});
	       	dm.on('failure', function (e) {      // 업데이트 실패시
	           var resultData = resultDataSet.getReadData(e);
	           alert(resultData.records[0].rtnMsg);
	       	});
	       
	       	dataSet.setNameValue(0, 'tssScnCd', "M");
	       	

			if(!vm.validateGroup("aform")) {
	            alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
	            return false;
	        }
			
	       	if(confirm('등록하시겠습니까?')) {
               dm.updateDataSet({
                   dataSets:[dataSet],
                   url:'<c:url value="/prj/tss/mkInno/saveMkInnoTssReg.do"/>',
                   modifiedOnly: false
               });
       		}	
		}

		fncCancel = function(){
			parent.mkInnoRegDialog.submit(true);
		}
	       
		bind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: dataSet,
	        bind: true,
	        bindInfo: [
	             { id: 'prjCd',            ctrlId: 'prjCd',            	value: 'value' }
	            ,{ id: 'prjNm',            ctrlId: 'prjNm',            	value: 'html' }
	            ,{ id: 'tssNm',            ctrlId: 'tssNm',            	value: 'html' }
	            ,{ id: 'saUserName',       ctrlId: 'saUserName',        value: 'value' }
	            ,{ id: 'tssStrtDd',        ctrlId: 'tssStrtDd',         value: 'value' }
	            ,{ id: 'prodG',            ctrlId: 'prodG',          value: 'value' }
	            ,{ id: 'bizDptCd',         ctrlId: 'bizDptCd',          value: 'value' }
	            ,{ id: 'tssFnhDd',         ctrlId: 'tssFnhDd',          value: 'value' }
	            ,{ id:  'fcCd',            ctrlId: 'fcCd',              value: 'value' }
	
	        ]
	    });
     
		//유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'prodG',    	validExp: '제품군:false' }
                , { id: 'bizDptCd',    validExp: '사업부문(Funding기준):true' }
                , { id: 'tssNm',       validExp: '과제명:true:maxLength=1000' }
                , { id: 'saSabunNew',  validExp: '과제리더사번:false' }
                , { id: 'saUserName',  validExp: '과제리더명:true' }
                , { id: 'tssAttrCd',   validExp: '과제속성:true' }
                , { id: 'tssStrtDd',   validExp: '과제기간 시작일:true' }
                , { id: 'tssFnhDd',    validExp: '과제기간 종료일:true' }
                , { id: 'prodG',     validExp: '제품군:true' }
            ]
        });
		
        
        
	});

</script>

</head>
<body>
<div class="LblockMainBody">
	<div class="sub-content">
		<form id="aform" name="aform">		
		<table class="table table_txt_right">
			<colgroup>
				<col style="width:17%;"/>
				<col style="width:33%;"/>
				<col style="width:17%;"/>
				<col style="width:33%;"/>
			</colgroup>
			<tbody>
				<tr>
					<th align="right" ><span style="color:red;">* </span>과제구분</th>
					<td>
						<div id="tssScnCd" />제조혁신과제</td>
					<th align="right">공장구분</th>
					<td><div id="fcCd" /></td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>제품군</th>
					<td><div id="prodG" /></td>
					<th align="right"><span style="color:red;">* </span>과제기간</th>
					<td><input type="text" id="tssStrtDd"> <em class="gab"> ~ </em> <input type="text" id="tssFnhDd"></td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>과제리더</th>
					<td><input type="text" id="saUserName" /></td>
					<th align="right"><span style="color:red;">* </span>사업부문<br/>(Funding기준)</th>
					<td><div id="bizDptCd" /></td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>팀명<br />(개발부서)</th>
					<td colspan="3">
						<span id="prjNm"></span>
					</td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>과제명</th>
					<td colspan="3"><input id="tssNm" type="text" style="width: 100%" /></td>
				</tr>
				
			</tbody>
		</table>	
		</form>
	</div>
	
	<div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnMkInnoReg" onclick="fncMkInnoReg()">등록</button>
	        <button type="button" id="butCancel" onClick="fncCancel()">취소</button>
	    </div>
	</div>
</div>
</body>
</html>