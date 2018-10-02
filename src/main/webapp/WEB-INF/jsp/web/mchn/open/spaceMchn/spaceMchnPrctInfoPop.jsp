<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: mchnInfoSavePop.jsp
 * @desc    : Instrument >  공간성능평가 Tool > 보유 TOOL > 보유TOOL 신규및 수정팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.25     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<style>
	div.L-combo-list-wrapper-nobg {max-height: 150px;}
</style>

<script type="text/javascript">
var mchnPrctInfoDialog;
var dSabun;
var sSabun;
//var chkCcs;
var mchnClCd = '${inputData.mchnClCd}';
var mailTitl ="보유TOOL 예약신청";

	Rui.onReady(function(){
		
		var mchnPrctId = '${inputData.mchnPrctId}';

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
		
		var mailContents;
		
		/*******************
	     * 변수 및 객체 선언
	     *******************/
	    var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        fields: [
            		  { id: 'prctTitl'}
		           	 ,{ id: 'mchnHanNm'}
		           	 ,{ id: 'rgstNm'}
		           	 ,{ id: 'rgstId'}
		           	 ,{ id: 'deptNm'}
		             ,{ id: 'prctDt'}
			         ,{ id: 'prctFromDt'}
			         ,{ id: 'prctToDt'}
		           	 ,{ id: 'rgstDt'}
		           	 ,{ id: 'userSabun'}
		           	 ,{ id: 'crgrMail'}
		           	 ,{ id: 'mchnPrctId'}
		           	 ,{ id: 'mchnUfe'}
		           	 ,{ id: 'mchnUfeClCd'}
		           	 ,{ id: 'mchnInfoId'}
		           	 
		            ]
	    });
		
	    dataSet.on('load', function(e){
	    	var frm = document.aform;
	    	
	    	butSave.hide();
	    	
	    	frm.mchnHanNm.value = dataSet.getNameValue(0, "mchnHanNm");
	    	frm.toMailAddr.value = dataSet.getNameValue(0, "crgrMail");
	    	frm.crgrNm.value = dataSet.getNameValue(0, "crgrNm");
	    	frm.rgstNm.value = dataSet.getNameValue(0, "rgstNm");
	    	frm.mchnUfe.value = dataSet.getNameValue(0, "mchnUfe");
	    	
	    	dSabun = dataSet.getNameValue(0, "rgstId");
	    	sSabun = dataSet.getNameValue(0, "userSabun");

	    	//chkCcs = dataSet.getNameValue(0, "eduStCd");

	    	if( dSabun != sSabun){
	    		butdel.hide();
	    	}
	    	
	    });
	    
		//신청명 
		var prctTitl = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'prctTitl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

      	var prctFromDt = new Rui.ui.form.LDateBox({
             applyTo: 'prctFromDt',
             listPosition: 'down',
             mask: '9999-99-99',
             displayValue: '%Y-%m-%d',

             dateType: 'string'
        });
     		
        var prctToDt = new Rui.ui.form.LDateBox({
             applyTo: 'prctToDt',
             listPosition: 'down',
             mask: '9999-99-99',
             displayValue: '%Y-%m-%d',
             dateType: 'string'
        });

		
		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		         { id: 'prctTitl', 		ctrlId: 'prctTitl', 	value: 'value'},
		         { id: 'mchnHanNm', 	ctrlId: 'hMchnHanNm', 	value: 'html' },
		         { id: 'rgstNm', 		ctrlId: 'hRgstNm', 		value: 'html' },
		         { id: 'deptNm', 		ctrlId: 'deptNm', 		value: 'html' },
		         { id: 'prctDt', 		ctrlId: 'prctDt', 		value: 'value'},
		         { id: 'prctFromDt', 	ctrlId: 'prctFromDt', 	value: 'value'},
		         { id: 'prctToDt', 		ctrlId: 'prctToDt', 	value: 'value'},
		         { id: 'rgstDt', 		ctrlId: 'rgstDt', 		value: 'value'},
		         { id: 'mchnUfe', 		ctrlId: 'mchnUfe', 		value: 'value'},
		         { id: 'mchnUfeClCd', 	ctrlId: 'mchnUfeClCd', 	value: 'value'},
		    
		     ]
		});

		fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/mchn/open/spaceMchn/retrieveMchnPrctInfo.do"/>',
				params :{
					mchnPrctId  : mchnPrctId	//교육명
	                }
			});
		}

		if( Rui.isEmpty(mchnPrctId)){
			var frm = document.aform;
			
			//butdel.hide();
			
			frm.mchnHanNm.value = '${result.mchnHanNm}';
			frm.toMailAddr.value = '${result.crgrMail}';
			frm.crgrNm.value = '${result.crgrNm}';
			frm.mchnUfeClCd.value = '${result.mchnUfeClCd}';
			frm.mchnClCd.value = '${inputData.mchnClCd}';
			Rui.get("hMchnHanNm").html('${result.mchnHanNm}');

			Rui.get("hRgstNm").html('${inputData.userNm}');
			Rui.get("deptNm").html('${inputData.userDeptName}');
			
			var eduStnmHtml ="";
			var tmpDt = '${inputData.year}'+"-"+'${inputData.mm}'+"-"+'${inputData.day}';

			document.aform.rgstId.value = '${inputData.userSabun}';
			document.aform.mchnInfoId.value = '${inputData.mchnInfoId}';
			
		}else{
			fnSearch();
		}
		
		/* [버튼] : 보유TOOL 예약 저장 및 수정 */
    	var butSave = new Rui.ui.LButton('butSave');
    	butSave.on('click', function(){
    		
    		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    		dm.on('success', function(e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    			var fId = document.aform.mchnInfoId.value;
    			var mchnPId = '${inputData.mchnPrctId}';
    			var mchnId = '${inputData.mchnInfoId}';
    			if( resultData.records[0].rtnSt == "S"){
    				parent.fncMchnDtl( mchnPId , mchnId, 'PRCT');
    				parent.fncPopCls();
    			}
    		});
    		
    		dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    	    	alert(resultData.records[0].rtnMsg);
    	    });

    		if(fncVaild()){
				if(confirm("예약신청 하시겠습니까?")) {
   	        		dm.updateForm({
   	        	    url: "<c:url value='/mchn/open/spaceMchn/saveMchnPrctInfo.do'/>",
   	        	    form : 'aform',
   	        	    params : {
   	        	    	 mailTitl : mailTitl				//mail title
   	        	    	,mchnHanNm : encodeURIComponent(document.aform.mchnHanNm.value)
   	        	    	,rgstNm : encodeURIComponent(document.aform.rgstNm.value)
   	        	    }
   	        	 });
				}
			}
    		
    	});
    	
    	/* [버튼] : 보유TOOL예약 삭제 */
    	var butdel = new Rui.ui.LButton('butdel');
    	butdel.on('click', function(){
			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    		
    		dm.on('success', function(e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    			var mchnPId = '${inputData.mchnPrctId}';
    			var mchnId = '${inputData.mchnInfoId}';
    			
    			if( resultData.records[0].rtnSt == "S"){
    				parent.fncMchnDtl( mchnPId , mchnId, 'PRCT');
    				parent.fncPopCls();
    			}
    		});
    		
    		dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    	    	alert(resultData.records[0].rtnMsg);
    	    });
    		
    		
    		if(Rui.isEmpty(mchnPrctId)){
    			alert("삭제할 예약건이 없습니다.");
    			return;
    		}
    		
    		//mchnPrctId
			if(confirm("TOOL예약을 삭제하시겠습니까?")) {
  	        		dm.updateForm({
  	        	    url: "<c:url value='/mchn/open/spaceMchn/deleteMchnPrctInfo.do'/>",
  	        	    form : 'aform',
  	        	    params : {
  	        	    	mchnPrctId : dataSet.getNameValue(0, "mchnPrctId")				//mail title
  	        	    }
  	        	 });
			}
    	});
		
		//분석TOOL 예약 팝업창 닫기
		var butCls = new Rui.ui.LButton('butCls');
		butCls.on('click', function(){
			parent.fncPopCls();
        });
	
		var fncVaild = function(){
			var frm = document.aform;
			
			if(Rui.isEmpty(prctTitl.getValue())){
				alert("평가명을 입력하세요");
				prctTitl.focus();
    			return false;
			}
			
			if(Rui.isEmpty(prctFromDt.getValue())){
				alert("예약 시작일을 입력하세요");
				prctFromDt.focus();
    			return false;
			}
			
			if(Rui.isEmpty(prctToDt.getValue())){
				alert("예약 종료일을 입력하세요");
				prctToDt.focus();
    			return false;
			}
			
			if(prctFromDt.getValue() >  prctToDt.getValue() ){
				alert("예약종료일이 시작일보다 작을 수 없습니다.")
				prctToDt.focus();
				return false;
			}

			return true;
		}
		
	}); //end ready


</script>
</head>
<body>
<div class="bd">
		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="rgstId" name="rgstId" />
				<input type="hidden" id="rgstNm" name="rgstNm" />
				<input type="hidden" id="crgrNm" name="crgrNm" />
				<input type="hidden" id="toMailAddr" name="toMailAddr" />
				<input type="hidden" id="mchnHanNm" name="mchnHanNm" />
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" />

				
				<input type="hidden" id="mchnUfeClCd" name="mchnUfeClCd" />
				<input type="hidden" id="mchnUfe" name="mchnUfe" />
				<input type="hidden" id="mchnClCd" name="mchnClCd" />

			<%-- 	<input type="hidden" id="menuType" name="menuType" /> --%>
				<div class="titArea mt0">
					<div class="LblockButton">
						<button type="button" id="butSave">예약신청</button>
						<button type="button" id="butdel">삭제</button>
						<button type="button" id="butCls">닫기</button>
					</div>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 35%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">TOOL</th>
							<td>
								<span id="hMchnHanNm"></span>
							</td>
							<th align="right"><span style="color:red;">*  </span>평가명</th>
							<td>
								<input type="text" id="prctTitl" />
							</td>

						</tr>	
						<tr>
							<th align="right">신청자(팀)</th>
							<td>
								<span id="hRgstNm"></span>(<span id="deptNm"></span>)
							</td>
							<th align="right"><span style="color:red;">*  </span>예약일시</th>
							<td>
								<input id="prctFromDt" type="text" /><em class="gab"> ~ </em>
								<input id="prctToDt" type="text" />
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