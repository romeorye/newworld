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
<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>
<script type="text/javascript">
var today = new Date();
var dd = today.getDate();
var mm = today.getMonth()+1; //January is 0!
var yyyy = today.getFullYear();
var fromStrDt = "";

if (pad(mm) == "01"){
	yyyy = today.getFullYear()-1;
	mm = "12";
	
	fromStrDt = yyyy +""+ pad(mm);
}else{
	fromStrDt = today.getFullYear() +""+ pad(today.getMonth())+"";
}



var tssCd = '${inputData.tssCd}';    
    
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
                ,{ id: 'fcCd'}
                ,{ id: 'ppslMbdCd'}
                ,{ id: 'rsstSphe'}
                ,{ id: 'deptCode'}
             ]
        });
		
		dataSet.on('load', function(e){
			if (Rui.isEmpty(tssCd) ){
				$("#btnTssReg").show();
			}else{
				if ( dataSet.getNameValue(0, 'pgsStepCd') == "PL" &&  dataSet.getNameValue(0, 'tssSt') == "101"    ){
					$("#btnTssReg").show();
				}else{
					$("#btnTssReg").hide();
				}
				
			}
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
        /*
		grsYn = new Rui.ui.form.LCombo({
            applyTo: 'grsYn',
            name: 'grsYn',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=COMM_YN"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        */
        
		//사업부문(Funding기준)
        bizDptCd = new Rui.ui.form.LCombo({
            applyTo: 'bizDptCd',
            name: 'bizDptCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=BIZ_DPT_CD"/>',
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
            width: 150
        });
        
      	//과제기간 시작일
        tssStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssStrtDd',
            mask: '9999-99-99',
            width: 100,
            listPosition : 'down',
            dateType: 'string'
        });

        tssStrtDd.on('blur', function() {
        	var strMm = tssStrtDd.getValue().split("-") ;
        	var strDt = strMm[0]+strMm[1];
        	
        	if( fromStrDt > strDt ){
        		alert("과제등록일은 전월까지입니다.");
        		tssStrtDd.focus();
        		return;
        	}
        	
        	if(Rui.isEmpty(tssFnhDd.getValue())) return;

            if(!Rui.isEmpty(tssStrtDd.getValue())) {
                var startDt = tssStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = tssFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    tssStrtDd.setValue("");
                    return;
                }
            }
        });

        // 과제기간 종료일
        tssFnhDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssFnhDd',
            mask: '9999-99-99',
            width: 100,
            listPosition : 'down',
            dateType: 'string'
        });
        
        tssFnhDd.on('blur', function() {
        	if(Rui.isEmpty(tssStrtDd.getValue())) return;

            if(!Rui.isEmpty(tssFnhDd.getValue())) {
                var startDt = tssStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = tssFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    tssFnhDd.setValue("");
                    return;
                }
            }
        	
        });
      
      
      	//고객 특성 ->사업유형
    	var custSqlt = new Rui.ui.form.LCombo({
    		applyTo : 'custSqlt',
    		name: 'custSqlt',
    		emptyText: '전체',
    		url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=CUST_SQLT"/>',
    		displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
    	});
        
    	//과제속성
        tssAttrCd = new Rui.ui.form.LCombo({
            applyTo: 'tssAttrCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_ATTR_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
    	
    	//신제품 유형
        tssType = new Rui.ui.form.LCombo({
            applyTo: 'tssType',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_TYPE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
    	
    	//공장구분
        fcCd = new Rui.ui.form.LCombo({
            applyTo: 'fcCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FC_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
    	
        //발의주체
        ppslMbdCd = new Rui.ui.form.LCombo({
            applyTo: 'ppslMbdCd',
            name: 'ppslMbdCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PPSL_MBD_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
    	
      	//연구분야
        rsstSphe = new Rui.ui.form.LCombo({
            applyTo: 'rsstSphe',
            name: 'rsstSphe',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=RSST_SPHE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        
        fnSearch = function() {
        	dataSet.load({
                url: '<c:url value="/prj/grs/selectGrsMngInfo.do"/>'
              , params : {
                    tssCd : '${inputData.tssCd}'                       //과제코드
                }
            });
        };
        
        fnSearch();
        
      	//연구소 과제의 경우 GRS(초기(G1)) 반드시 수행
        tssScnCd.on('changed', function(e) {
        	/*
        	if($.inArray( e.value, [ "G", "O", "N"])>-1){
                grsYn.setValue('Y');
                setReadonly('grsYn');
    		}else{
                setEditable('grsYn');
    		}
			
			grsYn.setValue('Y');
			*/
            if($.inArray( e.value, [ "O", "N"])>-1){
    			$('#displayDiv1').css('display', 'none');
    			$('#displayDiv2').css('display', 'none');
    			$('#displayDiv3').css('display', 'none');
    		}else{
    			$('#displayDiv1').css('display', '');
    			$('#displayDiv2').css('display', '');
    			
    			if( e.value == "G"  ){
	    			$('#displayDiv3').css('display', '');
    			}
    		}
        });
    	
    	
      	//과제 등록
        fncTssReg = function(){
        	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
            dm.on('success', function (e) {      // 업데이트 성공시
                var resultData = resultDataSet.getReadData(e);

            	alert(resultData.records[0].rtnMsg);
            	
                if ( resultData.records[0].rtnSt == "S"  ){
	                parent.tssRegPopDialog.submit(true);
	                parent.fnSearch();
                }
            });

            dm.on('failure', function (e) {      // 업데이트 실패시
                var resultData = resultDataSet.getReadData(e);
                alert(resultData.records[0].rtnMsg);
            });
            
            if( Rui.isEmpty(dataSet.getNameValue(0, 'prjCd'))  ){
            	alert("부서 코드가 없습니다. 관리자에게 문의하세요 ");
            	return;
            }
            
            if( tssScnCd.getValue() == "G" || tssScnCd.getValue() =="D" ){
            	if(!valid.validateGroup("aform")) {
            		alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid.getMessageList().join(''));
                    return;
            	}
            	
            }else{
            	if(!valid2.validateGroup("aform")) {
            		alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid2.getMessageList().join(''));
                    return;
            	}
            }
            
            if( tssScnCd.getValue() == "G"){
            	if(Rui.isEmpty( rsstSphe.getValue())){
            		alert("연구분야를 선택하세요");
            		return;
            	}
            	if(Rui.isEmpty( ppslMbdCd.getValue())){
            		alert("발의주체를 선택하세요");
            		return;
            	}
            }
            
        	if(confirm('등록하시겠습니까?')) {
        		dataSet.setNameValue(0, 'grsYn', "Y");
        		
        		dm.updateDataSet({
                    dataSets:[dataSet],
                    url:'<c:url value="/prj/grs/saveTssInfo.do"/>',
                    modifiedOnly: false
                });
        	}	
        } 
    	
    	//과제 등록취소
        fncCancel = function(){
        	parent.tssRegPopDialog.submit(true);
        }
    	
        var valid = new Rui.validate.LValidatorManager({
            validators:[
                {id:'tssScnCd', validExp:'과제구분:true'},
                //{id:'grsYn', validExp:'GRS(G1)수행여부:true'},
                {id:'saSabunNm', validExp:'과제리더:true'},
                {id:'bizDptCd', validExp:'사업부:true'},
                {id:'prjNm', validExp:'프로젝트명:true'},
                {id:'tssNm', validExp:'과제명:true'},
                {id:'prodG', validExp:'제품군:true'},
                {id:'tssStrtDd', validExp:'과제기간시작:true'},
                {id:'tssFnhDd', validExp:'과제기간끝:true'},
                {id:'custSqlt', validExp:'사업유형:true'},
                {id:'tssAttrCd', validExp:'과제속성:true'},
                {id:'tssType', validExp:'신제품유형:true'},
                {id:'fcCd', validExp:'공장구분:true'}
            ]
        });

        var valid2 = new Rui.validate.LValidatorManager({
            validators:[
                {id:'tssScnCd', validExp:'과제구분:true'},
                //{id:'grsYn', validExp:'GRS(G1)수행여부:true'},
                {id:'saSabunNm', validExp:'과제리더:true'},
                {id:'bizDptCd', validExp:'사업부:true'},
                {id:'prjNm', validExp:'프로젝트명:true'},
                {id:'tssNm', validExp:'과제명:true'},
                {id:'prodG', validExp:'제품군:true'},
                {id:'tssStrtDd', validExp:'과제기간시작:true'},
                {id:'tssFnhDd', validExp:'과제기간끝:true'},
                {id:'custSqlt', validExp:'사업유형:false'},
                {id:'tssAttrCd', validExp:'과제속성:false'},
                {id:'tssType', validExp:'신제품유형:false'}
                
            ]
        });
    	
    	bind = new Rui.data.LBind({
    		groupId: 'aform',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                 { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                ,{ id: 'wbsCd',            ctrlId: 'wbsCd',            value: 'value' }
                ,{ id: 'pkWbsCd',          ctrlId: 'pkWbsCd',          value: 'value' }
                ,{ id: 'pgsStepCd',        ctrlId: 'pgsStepCd',        value: 'value' }
                ,{ id: 'tssSt',            ctrlId: 'tssSt',            value: 'value' }
                ,{ id: 'tssScnCd',         ctrlId: 'tssScnCd',         value: 'value' }
               // ,{ id: 'grsYn',            ctrlId: 'grsYn',            value: 'value' }
                ,{ id: 'tssNm',            ctrlId: 'tssNm',            value: 'value' }
                ,{ id: 'prjCd',            ctrlId: 'prjCd',            value: 'value' }
                ,{ id: 'prjNm',            ctrlId: 'prjNm',            value: 'html' }
                ,{ id: 'bizDptCd',         ctrlId: 'bizDptCd',         value: 'value' }
                ,{ id: 'prodG',            ctrlId: 'prodG',            value: 'value' }
                ,{ id: 'saSabunNew',        ctrlId: 'saSabunNew',        value: 'value' }
                ,{ id: 'saSabunNm',        ctrlId: 'saSabunNm',        value: 'value' }
                ,{ id: 'tssStrtDd',        ctrlId: 'tssStrtDd',        value: 'value' }
                ,{ id: 'tssFnhDd',         ctrlId: 'tssFnhDd',         value: 'value' }
                ,{ id: 'custSqlt',         ctrlId: 'custSqlt',         value: 'value' }
                ,{ id: 'tssAttrCd',        ctrlId: 'tssAttrCd',        value: 'value' }
                ,{ id: 'tssType',          ctrlId: 'tssType',          value: 'value' }
                ,{ id: 'fcCd',             ctrlId: 'fcCd',             value: 'value' }
                ,{ id: 'rsstSphe',         ctrlId: 'rsstSphe',         value: 'value' }
                ,{ id: 'ppslMbdCd',        ctrlId: 'ppslMbdCd',        value: 'value' }

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
					<td><div id="tssScnCd" /></td>
					<th align="right"><span style="color:red;">* </span>G1 수행여부</th>
					<td><div id="grsYn" />Y</td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>과제리더</th>
					<td><input type="text" id="saSabunNm" /></td>
					<th align="right"><span style="color:red;">* </span>사업부문<br/>(Funding기준)</th>
					<td><div id="bizDptCd" /></td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>프로젝트명<br />(개발부서)</th>
					<td colspan="3" ><span id="prjNm"></span>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>과제명</th>
					<td colspan="3"><input id="tssNm" type="text" style="width: 100%" /></td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">* </span>제품군</th>
					<td><div id="prodG" /></td>
					<th align="right"><span style="color:red;">* </span>과제기간</th>
					<td><input type="text" id="tssStrtDd"> <em class="gab">~ </em> <input type="text" id="tssFnhDd"></td>
				</tr>
				<tr id="displayDiv1">
					<th align="right"><span style="color:red;">* </span>사업유형</th>
					<td><div id="custSqlt" /></td>
					<th align="right"><span style="color:red;">* </span>과제속성</th>
					<td><div id="tssAttrCd" /></td>
				</tr>
				<tr id="displayDiv2">
					<th align="right"><span style="color:red;">* </span>개발등급</th>
					<td><div id="tssType" /></td>
					<th align="right"><span style="color:red;">* </span>공장구분</th>
					<td><div id="fcCd" /></td>
				</tr>
				<tr id="displayDiv3">
					<th align="right"><span style="color:red;">* </span>발의주체</th>
					<td><div id="ppslMbdCd" /></td>
					<th align="right"><span style="color:red;">* </span>연구분야</th>
					<td><div id="rsstSphe" /></td>
				</tr>
			</tbody>
		</table>	
  		
  	</form>
	</div>
  		<div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnTssReg" onclick="fncTssReg()">등록</button>
	        <button type="button" id="butCancel" onClick="fncCancel()">닫기</button>
	    </div>
	</div>  
</div>  
</body>
</html>