<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id      : tssRegPop.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2020.03.02
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

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
            	{ id: 'tssCd'}
                ,{ id: 'wbsCd'}
                ,{ id: 'pkWbsCd'}
                ,{ id: 'pgsStepCd'}
                ,{ id: 'tssSt'}
                ,{ id: 'tssScnCd'}
                ,{ id: 'grsYn'}
                ,{ id: 'tssNm'}
                ,{ id: 'prjCd'}
                ,{ id: 'prjNm'}
                ,{ id: 'bizDptCd'}
                ,{ id: 'prodG'}
                ,{ id: 'saSabunNew'}
                ,{ id: 'saSabunNm'}
                ,{ id: 'tssStrtDd'}
                ,{ id: 'tssFnhDd'}
                ,{ id: 'custSqlt'}
                ,{ id: 'tssAttrCd'}
                ,{ id: 'tssType'}
                ,{ id: 'isEditable'}
                ,{ id: 'fcCd'}
             ]
        });
		
		dataSet.on('load', function(e){
			  
		});
		
		var row = dataSet.newRecord();
		
		//과제리더
        saSabunNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saSabunNm',
            width: 150,
            editable: false,
            enterToPopup: true
        });
        saSabunNm.on('popup', function(e){
            openUserSearchDialog(setLeaderInfo, 1, '');
        });
        
        setLeaderInfo = function(userInfo){
        	dataSet.setNameValue(0, 'saSabunNew', userInfo.saSabun);
        	dataSet.setNameValue(0, 'saSabunNm', userInfo.saName);
        	dataSet.setNameValue(0, 'prjCd', userInfo.prjCd);
        	dataSet.setNameValue(0, 'deptCode', userInfo.uperDeptCd);
        	dataSet.setNameValue(0, 'prjNm', userInfo.deptName);
        }
        
		//과제구분
        tssScnCd = new Rui.ui.form.LCombo({
            applyTo: 'tssScnCd',
            name: 'tssScnCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_SCN_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
		
		//GRS 수행여부
        grsYn = new Rui.ui.form.LCombo({
            applyTo: 'grsYn',
            name: 'grsYn',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=COMM_YN"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
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
        
      	//고객 특성
    	var custSqlt = new Rui.ui.form.LCombo({
    		applyTo : 'custSqlt',
    		emptyValue : '',
    		emptyText : '선택',
    		width : 120,
    		defaultValue : '${inputData.custSqlt}',
    		items : [ {
    			text : 'B2B제품군',
    			value : '01'
    		}, {
    			text : '일반제품군',
    			value : '02'
    		}, ]
    	});
        
    	//과제속성
        tssAttrCd = new Rui.ui.form.LCombo({
            applyTo: 'tssAttrCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_ATTR_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
    	
    	//신제품 유형
        tssType = new Rui.ui.form.LCombo({
            applyTo: 'tssType',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_TYPE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
    	
    	//공장구분
        fcCd = new Rui.ui.form.LCombo({
            applyTo: 'fcCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FC_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
    	
    	
    	
        fnSearch = function() {

        	dataSet.load({
                url: '<c:url value="/prj/grs/selectGrsMngInfo.do"/>'
              , params : {
                    tssCd : dataSet.getNameValue(0, 'tssCd')                        //과제코드
                }
            });
        };
    	
        
        fnSearch();
    	
    	bind = new Rui.data.LBind({
    		groupId: 'aform',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                 { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                ,{ id: 'wbsCd',            ctrlId: 'wbsCd',            value: 'value' }
                ,{ id: 'pkWbsCd',          ctrlId: 'pkWbsCd',            value: 'value' }
                ,{ id: 'pgsStepCd',        ctrlId: 'pgsStepCd',            value: 'value' }
                ,{ id: 'tssSt',            ctrlId: 'tssSt',            value: 'value' }
                ,{ id: 'tssScnCd',         ctrlId: 'tssScnCd',            value: 'value' }
                ,{ id: 'grsYn',            ctrlId: 'grsYn',            value: 'value' }
                ,{ id: 'tssNm',            ctrlId: 'tssNm',            value: 'value' }
                ,{ id: 'prjCd',            ctrlId: 'prjCd',            value: 'value' }
                ,{ id: 'prjNm',            ctrlId: 'prjNm',            value: 'html' }
                ,{ id: 'bizDptCd',         ctrlId: 'bizDptCd',            value: 'value' }
                ,{ id: 'prodG',            ctrlId: 'prodG',            value: 'value' }
                ,{ id: 'saSabunNew',        ctrlId: 'saSabunNew',            value: 'value' }
                ,{ id: 'saSabunNm',        ctrlId: 'saSabunNm',            value: 'value' }
                ,{ id: 'tssStrtDd',        ctrlId: 'tssStrtDd',            value: 'value' }
                ,{ id: 'tssFnhDd',          ctrlId: 'tssFnhDd',            value: 'value' }
                ,{ id: 'custSqlt',            ctrlId: 'custSqlt',            value: 'value' }
                ,{ id: 'tssAttrCd',            ctrlId: 'tssAttrCd',            value: 'value' }
                ,{ id: 'tssType',            ctrlId: 'tssType',            value: 'value' }
                ,{ id:  'fcCd',            ctrlId: 'fcCd',            value: 'value' }

            ]
        });
    		
    		
    		
    	//과제 등록
        fncTssReg = function(){
        	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
            dm.on('success', function (e) {      // 업데이트 성공시
                var resultData = resultDataSet.getReadData(e);
                alert(resultData.records[0].rtnMsg);
                fnSearch();
                etcTssDialog.hide();
            });

            dm.on('failure', function (e) {      // 업데이트 실패시
                var resultData = resultDataSet.getReadData(e);
                alert(resultData.records[0].rtnMsg);
            });
            
        	if(confirm('등록하시겠습니까?')) {
                dm.updateDataSet({
                    dataSets:[dataSet],
                    url:'<c:url value="/prj/grs/updateGrsMngInfo.do"/>',
                    modifiedOnly: false
                });
        	}	
        } 
    	
    	//과제 등록취소
        fncCancel = function(){
        	parent.tssRegPopDialog.submit(true);
        	parent.fnSearch();
        }
    	
    	
    	
    	
    	
    	
    	
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
					<td><div id="tssScnCd" /></td>
					<th align="right"><span style="color:red;">* </span>GRS초기(P1)<br/>수행여부</th>
					<td><div id="grsYn" /></td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>과제리더</th>
					<td><input type="text" id="saSabunNm" /></td>
					<th align="right"><span style="color:red;">* </span>사업부문<br/>(Funding기준)</th>
					<td><div id="bizDptCd" /></td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>프로젝트명<br />(개발부서)</th>
					<td colspan="3"><span id="prjNm"></span>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>과제명</th>
					<td colspan="3"><input id="tssNm" type="text" style="width: 100%" /></td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>제품군</th>
					<td><div id="prodG" /></td>
					<th align="right"><span style="color:red;">* </span>과제기간</th>
					<td><input type="text" id="tssStrtDd"> <em class="gab"> ~ </em> <input type="text" id="tssFnhDd"></td>
				</tr>
				<tr id="displayDiv1">
					<th align="right"><span style="color:red;">* </span>고객특성</th>
					<td><div id="custSqlt" /></td>
					<th align="right"><span style="color:red;">* </span>과제속성</th>
					<td><div id="tssAttrCd" /></td>
				</tr>
				<tr id="displayDiv2">
					<th align="right"><span style="color:red;">* </span>신제품 유형</th>
					<td><div id="tssType" /></td>
					<th align="right"><span style="color:red;">* </span>공장구분</th>
					<td><div id="fcCd" /></td>
				</tr>
			</tbody>
		</table>	
  		
  	</form>
	</div>
  		<div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnMkInnoReg" onclick="fncTssReg()">등록</button>
	        <button type="button" id="butCancel" onClick="fncCancel()">취소</button>
	    </div>
	</div>  
</div>  
</body>
</html>