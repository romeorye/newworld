<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMachineLis.jsp
 * @desc    : 분석기기 >  관리 > 소모품목록 > 관리 > 소모품 입출력 신규 및 수정팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.26     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
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
%>


<script type="text/javascript">

	Rui.onReady(function(){
	
		Rui.get('rgstNm').html("<c:out value='${inputData._userNm}'/>");
		
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
        
		var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'rgstDt'}
            	 ,{ id: 'whioClCd'}
            	 ,{ id: 'qty'}
            	 ,{ id: 'cgdsRem'}
            	 ,{ id: 'rgstNm'}
            	 ,{ id: 'rgstId'}
            	 ,{ id: 'cgdsId'}
            	 ,{ id: 'cgdsMgmtId'}
            ]
        });
		
		dataSet.on('load', function(e) {
			
	    });

			
		//등록일
		var rgstDt = new Rui.ui.form.LDateBox({
            applyTo: 'rgstDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue: new Date(),
            dateType: 'string'
        });
		
		//분류
 		var cbWhioClCd = new Rui.ui.form.LCombo({
	 		applyTo : 'whioClCd',
			name : 'whioClCd',
			useEmptyText: true,
	           emptyText: '',
	           url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=CDGS_WHIO_CL_CD"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD'
      	 });
		
 		cbWhioClCd.getDataSet().on('load', function(e) {
	          console.log('cbWhioClCd :: load');
	    });

 		/* 
 		fnSearch = function() {
	    	dataSet.load({
	        url: '<c:url value="/mchn/mgmt/retrieveCgdsMgmtPopInfo.do"/>' ,
        	params :{
        		cgdsMgmtId : document.aform.cgdsMgmtId.value		//소모품
	                }
         	});
     	}
 		
 		fnSearch();
 		 */
 		 
		//재고.
 		var qty = new Rui.ui.form.LNumberBox({
	        applyTo: 'qty',
	        placeholder: '',
	        maxValue: 9999999999,           // 최대값 입력제한 설정
	        minValue: -1,                  // 최소값 입력제한 설정
	        decimalPrecision: 0            // 소수점 자리수 3자리까지 허용
	    });
		
 		//비고
 		var cgdsRem = new Rui.ui.form.LTextArea({
            applyTo: 'cgdsRem',
            placeholder: '',
            width: 600,
            height: 100
        });
 	
 		
		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		          { id: 'rgstDt', 		ctrlId: 'rgstDt', 		value: 'value' }
		         ,{ id: 'qty', 			ctrlId: 'qty', 			value: 'value' }
		         ,{ id: 'rgstNm', 		ctrlId: 'rgstNm', 		value: 'html' }
		         ,{ id: 'cgdsRem', 		ctrlId: 'cgdsRem', 		value: 'value' }
		         ,{ id: 'whioClCd',		ctrlId: 'whioClCd',		value: 'value' }
		     ]
		});
		
		/* [버튼] : 소모품 목록 이동 */
    	var butCls = new Rui.ui.LButton('butCls');
    	butCls.on('click', function(){
			parent.cgdsMgmtDialog.cancel(true);
    	});
    	
    	
		/* [버튼] : 소모품입출력 저장 */
    	var butSave = new Rui.ui.LButton('butSave');
    	butSave.on('click', function(){
    		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
			
    		dm.on('success', function(e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);
   				alert(resultData.records[0].rtnMsg);
    			
   				if( resultData.records[0].rtnSt == "S"){
   					parent.fnSearch();
   					parent.cgdsMgmtDialog.cancel(true);
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
   				alert(resultData.records[0].rtnMsg);
    	    });

			if(fncVaild()){
				if(confirm("저장 하시겠습니까?")) {
   	        	 dm.updateForm({
   	        	    url: "<c:url value='/mchn/mgmt/saveCgdsMgmtPopInfo.do'/>",
   	        	    form : 'aform'
   	        	    });
				}
			}
    	});
		
    	//vaild 체크	
    	var fncVaild = function(){
    		if(Rui.isEmpty(rgstDt.getValue())){
    			Rui.alert("등록일을 입력하여 주십시오");
    			rgstDt.focus();
    			return false
    		}
    		if(Rui.isEmpty(cbWhioClCd.getValue())){
    			Rui.alert("분류코드를 선택하여주십시오");
    			whioClCd.focus();
    			return false
    			
    		}
    		if(Rui.isEmpty(qty.getValue())){
    			Rui.alert("수량을 입력하여주십시오");
    			whioClCd.focus();
    			return false
    		}
    		
    		return true;
    	}
		
		
	});			//end Ready

</script>
</head>
<body>
	<div class="bd">
		<div class="sub-content" style="padding:0; padding-left:3px;">
			<form name="aform" id="aform" method="post">
			
			<input type="hidden" id="cgdsId" name="cgdsId" value="<c:out value='${inputData.cgdsId}'/>">
			<%-- <input type="hidden" id="cgdsMgmtId" name="cgdsMgmtId" value="<c:out value='${inputData.cgdsMgmtId}'/>"> --%>
			
				<div class="titArea mt10">
					<h3></h3>
					<div class="LblockButton mt0">
						<button type="button" id="butSave">저장</button>
						<button type="button" id="butCls">닫기</button>
					</div>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>해당일</th>
							<td>
								<input type="text" id="rgstDt"/>
							</td>
							<th align="right"><span style="color:red;">*  </span>분류</th>
							<td>
								<select id="whioClCd"></select>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>수량</th>
							<td>
								<input type="text" id="qty"/>&nbsp;&nbsp; EA
								
							</td>
							<th align="right">작성자</th>
							<td>
								<span id="rgstNm"></span>
							</td>
						</tr>
						<tr>
							<th align="right">비고</th>
							<td colspan="3">
								<textarea id="cgdsRem"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>