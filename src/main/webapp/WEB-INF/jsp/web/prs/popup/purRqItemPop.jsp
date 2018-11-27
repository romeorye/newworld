<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purRqItemPop.jsp
 * @desc    : 구매요청 Item 등록 팝업 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.11.23   김연태		최초생성
 * ---	-----------	----------	-----------------------------------------
 * PRS 프로젝트
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
		var frm = document.aform;
		
		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		
		var dataSet = new Rui.data.LJsonDataSet({
			id: 'dataSet',
		    remainRemoved: true,
		    fields: [
		    	  { id: 'txz01'}	/*요청품명*/
		    	 ,{ id: 'maker'}	/*메이커*/
		    	 ,{ id: 'vendor'}	/* 벤더*/
		    	 ,{ id: 'catalogno'}	/*카탈로그 no*/
		    	 ,{ id: 'waers'}	/* 요청단위 콤보*/
		    	 ,{ id: 'menge'}	/* 요청 수량*/
		    	 ,{ id: 'preis'}	/* 예상단가*/
		    	 ,{ id: 'sakto'}	/* 계정코드*/
		    	 ,{ id: 'usedCode'}	/* */
		    	 ,{ id: 'werks'}	/* 플랜트*/
		    	 ,{ id: 'prsFlag'}	/* 구매진행*/
		    	 ,{ id: 'saktoNm'}	/* 계정*/
		    ]
		});	
		
		dataSet.on('load', function(e){
		
		});
		
		//요청품명
		var txz01 = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'txz01',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//메이커
		var maker = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'maker',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		
		//벤더
		var vendor = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'vendor',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		
		//catalog no
		var catalogno = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'catalogno',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		
		//요청 수량
	  	var menge = new Rui.ui.form.LNumberBox({
	        applyTo: 'menge',
	        placeholder: '',
	        maxValue: 9999999999,           // 최대값 입력제한 설정
	        minValue: 0,                  // 최소값 입력제한 설정
	        width: 200,
	        decimalPrecision: 0,            // 소수점 자리수 3자리까지 허용
	    });
		
	  	menge.on('blur', function(e) {
            setExp();
        });
	  	
      	//수량 단위
		var waers = new Rui.ui.form.LCombo({
            applyTo: 'waers',
            width: 200,
            useEmptyText: true,
            url: '<c:url value="/common/prsCode/retrieveWaersInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE',
            autoMapping: true
        });
      	
		waers.getDataSet().on('load', function(e) {
        	
        });
      
		//예상단가
	  	var preis = new Rui.ui.form.LNumberBox({
	        applyTo: 'preis',
	        placeholder: '',
	        maxValue: 9999999999,           // 최대값 입력제한 설정
	        minValue: 0,                  // 최소값 입력제한 설정
	        width: 200,
	        decimalPrecision: 0,            // 소수점 자리수 3자리까지 허용
	    });
		
	  	preis.on('blur', function(e) {
            setExp();
        });
	  	
	  	//플랜트
		var werks = new Rui.ui.form.LCombo({
            applyTo: 'werks',
            width: 200,
            useEmptyText: false,
            url: '<c:url value="/common/prsCode/retrieveWerksInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE',
            autoMapping: true
        });
      	
		werks.getDataSet().on('load', function(e) {
        });
	  
		var bind = new Rui.data.LBind({
		     groupId: 'aform',
		     dataSet: dataSet,
		     bind: true,
		     bindInfo: [
		         { id: 'txz01', ctrlId: 'txz01', value: 'value' },
		         { id: 'maker', ctrlId: 'maker', value: 'value' },
		         { id: 'vendor', ctrlId: 'vendor', value: 'value' },
		         { id: 'catalogno', ctrlId: 'catalogno', value: 'value' },
		         { id: 'waers', ctrlId: 'waers', value: 'value' },
		         { id: 'menge', ctrlId: 'menge', value: 'value' },
		         { id: 'preis', ctrlId: 'preis', value: 'value' },
		         { id: 'werks', ctrlId: 'werks', value: 'value' },
		         { id: 'preis', ctrlId: 'preis', value: 'value' },
		         { id: 'sakto', ctrlId: 'sakto', value: 'html' },
		         { id: 'saktoNm', ctrlId: 'saktoNm', value: 'html' }
		     ]
		 });
		
		var setExp = function(){
			var p = preis.getValue();
			var m = menge.getValue();
			
			var tot = p*m;
			
			document.getElementById("totPreis").innerHTML = tot;
		}; 
		
		
		/* [버튼] 추가 */
	    var btnSave = new Rui.ui.LButton('btnSave');
	    btnSave.on('click', function() {
	    	parent.fncSave(dataSet);
	    	//parent.purRqItemDialog.submit(true);
		});
	    

		fnSearch = function() {
			dataSet.load({
	 	 		url: '<c:url value="/prs/purRq/retrievePurRqInfo.do"/>', 
	 	        params :{
	 	        	banfnPrs  : '${inputData.banfnPrs}'
	 	    	         }
	        });
	    }

		fnSearch();
		
	});

</script>
</head>
<body>
<div class="contents">
	<div class="titleArea">
	    <h2>구매요청 Item 정보</h2>
    </div>

	<form id="aform" name ="aform">
	<input type="hidden" id="tabId" name="tabId" value="<c:out value='${inputData.tabId}'/>">  
	<input type="hidden" id="bednr" name="bednr" value="<c:out value='${inputData._userSabun}'/>">  
	<input type="hidden" id="PrjCd" name="PrjCd" />  
	
	<div class="sub-content">
			<table class="table table_txt_right">
            	<colgroup>
                	<col width="100px">
                    <col width="200px">
                 </colgroup>
			     <tbody>
			     	<tr>
			        	<th>요청품명</th>
			            <td>
			            	<input type="text" id="txz01" name="txz01" />
			            </td>
			        </tr>
			        <tr>
			        	<th>Maker</th>
			            <td>
			            	<input type="text" id="maker" name="maker" /> (35자 이내)
			            </td>
					</tr>
			        <tr>
			        	<th>Vendor</th>
			            <td>
			            	<input type="text" id="vendor" name="vendor" /> (35자 이내)
			            </td>
					</tr>
			        <tr>
			        	<th>Catalog No.</th>
			            <td>
			            	<input type="text" id="catalogno" name="catalogno" /> (16자 이내)
			            </td>
					</tr>
			        <tr>
			        	<th>요청 수량</th>
			            <td>
			            	<input type="text" id="menge" name="menge" /> <select id="waers" name="waers"></select>
			            </td>
			         </tr>
			         <tr>
			        	<th>예상단가</th>
			            <td>
			            	<input type="text" id="preis" name="preis" /> KRW (원화환산) 
			            </td>
					 </tr>
			         <tr>
			        	<th>예상 금액</th>
			            <td>
			            	<span id="totPreis"></span>
			            </td>
					 </tr>
			         <tr>
			        	<th>계정</th>
			            <td>
			            	${inputData.code}  / ${inputData.saktoNm}
			            </td>
					</tr>
					<tr>
			        	<th>플랜트</th>
			            <td>
			                <select id="werks" name="werks"></select>
			            </td>
			         </tr>
			         <tr>
			        	<th>사용용도</th>
			            <td>
			                	실험용
			            </td>
			         </tr>
			         
				</tbody>
			</table>
	</div>
	    <div class="titArea">
	    	<div class="LblockButton">
	    	 	<button type="button" id="btnSave" name="btnSave">저장</button>
	    	</div> 
	    </div>
</body>
</html>