<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: mchnInfoSavePop.jsp
 * @desc    : Instrument > 신뢰성시험 장비 > 보유 장비 > 보유장비 신규및 수정팝업
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
var mailTitl ="보유장비 예약신청";
var dtlSbc = "";

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
		           	 ,{ id: 'mchnEnNm'}
		           	 ,{ id: 'rgstNm'}
		           	 ,{ id: 'rgstId'}
		           	 ,{ id: 'deptNm'}
		           	 ,{ id: 'smpoNm'}
		           	 ,{ id: 'smpoQty'}
		             ,{ id: 'prctDt'}
			         ,{ id: 'prctFromDt'}
			         ,{ id: 'prctToDt'}
		           	 ,{ id: 'prctFromTim'}
		           	 ,{ id: 'prctToTim'}
		           	 ,{ id: 'prctFromHH'}
		           	 ,{ id: 'prctFrommm'}
		           	 ,{ id: 'prctToHH'}
		           	 ,{ id: 'prctTomm'}
		           	 ,{ id: 'rgstDt'}
		           	 ,{ id: 'ccsDt'}
		           	 ,{ id: 'eduStNm'}
		           	 ,{ id: 'eduStCd'}
		           	 ,{ id: 'dtlSbc'}
		           	 ,{ id: 'eduStCd'}
		           	 ,{ id: 'userSabun'}
		           	 ,{ id: 'crgrMail'}
		           	 ,{ id: 'mchnPrctId'}
		           	 ,{ id: 'mchnUfe'}
		           	 ,{ id: 'prctScnNm'}
		           	 ,{ id: 'mchnUfeClCd'}
		           	 ,{ id: 'mchnInfoId'}
		             ,{ id: 'testSpceCd'}
		           	 ,{ id: 'testCnd01'}
		           	 ,{ id: 'testCnd02'}
		           	 ,{ id: 'cyclFlag'}
		           	 ,{ id: 'rsrtDivnCd'}
		           	 
		            ]
	    });
		
	    dataSet.on('load', function(e){
	    	var frm = document.aform;
	    	
	    	butSave.hide();
	    	
	    	frm.dtlSbc.value = dataSet.getNameValue(0, "dtlSbc");
	    	frm.mchnHanNm.value = dataSet.getNameValue(0, "mchnHanNm");
	    	frm.mchnEnNm.value = dataSet.getNameValue(0, "mchnEnNm");
	    	frm.toMailAddr.value = dataSet.getNameValue(0, "crgrMail");
	    	frm.crgrNm.value = dataSet.getNameValue(0, "crgrNm");
	    	frm.rgstNm.value = dataSet.getNameValue(0, "rgstNm");
	    	frm.mchnUfe.value = dataSet.getNameValue(0, "mchnUfe");
	    	
	    	dSabun = dataSet.getNameValue(0, "rgstId");
	    	sSabun = dataSet.getNameValue(0, "userSabun");
	    	
			if(dataSet.getNameValue(0, "mchnPrctId")  != "" ||  dataSet.getNameValue(0, "mchnPrctId")  !=  undefined ){
				CrossEditor.SetBodyValue( dataSet.getNameValue(0, "dtlSbc") );
			}

	    	//chkCcs = dataSet.getNameValue(0, "eduStCd");

	    	if( dSabun != sSabun){
	    		butdel.hide();
	    	}
	    	
	    	/*
	    	if(chkCcs == "RQ" ){
				eduStnmHtml =   dataSet.getNameValue(0, "eduStNm");
			}else if(chkCcs == "CCS" ){
				eduStnmHtml =  dataSet.getNameValue(0, "eduStNm")+ "(수료일 : "+dataSet.getNameValue(0, "ccsDt")+")";
			}else if(chkCcs == "NCPE" ){
				eduStnmHtml =  dataSet.getNameValue(0, "eduStNm")+ "(미수료일 : "+dataSet.getNameValue(0, "ccsDt")+")";
			}
	    	*/
	    });
	    
		//신청명 
		var prctTitl = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'prctTitl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		//시료명 
		var smpoNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'smpoNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		//시료수
		var smpoQty = new Rui.ui.form.LNumberBox({            // LTextBox개체를 선언
	        applyTo: 'smpoQty',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		
        var dtlSbc = new Rui.ui.form.LTextArea({
            applyTo: 'dtlSbc'
        });
		
		if(mchnClCd =='01'){
			//예약시작일시
			var testSpceCd = new Rui.ui.form.LCombo({
			 	applyTo : 'testSpceCd',
				name : 'testSpceCd',
				width: 200,
				useEmptyText: true,
				listPosition: 'up',
			    emptyText: ''
			});
			//시험조건01 
			var testCnd01 = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
		        applyTo: 'testCnd01',                           // 해당 DOM Id 위치에 텍스트박스를 적용
		        name : 'testCnd01',
		        width: 40,                                    // 텍스트박스 폭을 설정

		        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
		    });
			//시험조건02
			var testCnd02 = new Rui.ui.form.LNumberBox({            // LTextBox개체를 선언
		        applyTo: 'testCnd02',                           // 해당 DOM Id 위치에 텍스트박스를 적용
		        name : 'testCnd02',
		        width: 40,                                    // 텍스트박스 폭을 설정
		        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
		    });		
			
			//사이클여부
			var cyclFlag = new Rui.ui.form.LCheckBox({ // 체크박스를 생성
		        applyTo: 'cyclFlag',
			     value : "Y"
		    });
		}
		       	 
       	if(mchnClCd =='03'){
       	    //예약일
	   		var prctDt = new Rui.ui.form.LDateBox({
	              applyTo: 'prctDt',
	              mask: '9999-99-99',
	              displayValue: '%Y-%m-%d',
	              //defaultValue: new Date(),
	              dateType: 'string'
	        });
	
			//예약시작일시
			var cbPrctFromHH = new Rui.ui.form.LCombo({
			 	applyTo : 'prctFromHH',
				name : 'prctFromHH',
				width: 50,
				useEmptyText: true,
				listPosition: 'up',
			    emptyText: ''
			});
			//예약시작일시분
			var cbPrctFrommm = new Rui.ui.form.LCombo({
			 	applyTo : 'prctFrommm',
				name : 'prctFrommm',
				width: 50,
				useEmptyText: true,
				listPosition: 'up',
			    emptyText: ''
			});
			//예약시작일시
			var cbPrctToHH = new Rui.ui.form.LCombo({
			 	applyTo : 'prctToHH',
				name : 'prctToHH',
				width: 50,
				useEmptyText: true,
				listPosition: 'up',
			    emptyText: ''
			});
			//예약시작일시분
			var cbPrctTomm = new Rui.ui.form.LCombo({
			 	applyTo : 'prctTomm',
				name : 'prctTomm',
				width: 50,
				useEmptyText: true,
				listPosition: 'up',
			    emptyText: ''
			});
       	}
       	
     	if(mchnClCd == '01' || mchnClCd == '02'){
      		var prctFromDt = new Rui.ui.form.LDateBox({
                 applyTo: 'prctFromDt',
                 mask: '9999-99-99',
                 displayValue: '%Y-%m-%d',
                 //defaultValue: new Date(),
                 dateType: 'string'
            });
     		
     	   var prctToDt = new Rui.ui.form.LDateBox({
                 applyTo: 'prctToDt',
                 mask: '9999-99-99',
                 displayValue: '%Y-%m-%d',
                 //defaultValue: new Date(),
                 dateType: 'string'
            });
        }
		
		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		         { id: 'prctTitl', 		ctrlId: 'prctTitl', 	value: 'value'},
		         { id: 'mchnHanNm', 	ctrlId: 'hMchnHanNm', 	value: 'html' },
		         { id: 'mchnEnNm', 		ctrlId: 'hMchnEnNm', 	value: 'html' },
		         { id: 'rgstNm', 		ctrlId: 'hRgstNm', 		value: 'html' },
		         { id: 'deptNm', 		ctrlId: 'deptNm', 		value: 'html' },
		         { id: 'smpoNm', 		ctrlId: 'smpoNm', 		value: 'value'},
		         { id: 'smpoQty', 		ctrlId: 'smpoQty', 		value: 'value'},
		         { id: 'prctDt', 		ctrlId: 'prctDt', 		value: 'value'},
		         { id: 'prctFromDt', 	ctrlId: 'prctFromDt', 	value: 'value'},
		         { id: 'prctToDt', 		ctrlId: 'prctToDt', 	value: 'value'},
		         { id: 'prctFromTim', 	ctrlId: 'prctFromTim', 	value: 'value'},
		         { id: 'prctToTim', 	ctrlId: 'prctToTim', 	value: 'value'},
		         { id: 'prctFromHH', 	ctrlId: 'prctFromHH', 	value: 'value'},
		         { id: 'prctFrommm', 	ctrlId: 'prctFrommm', 	value: 'value'},
		         { id: 'prctToHH', 		ctrlId: 'prctToHH', 	value: 'value'},
		         { id: 'prctTomm', 		ctrlId: 'prctTomm',		value: 'value'},
		         { id: 'ccsDt', 		ctrlId: 'ccsDt', 		value: 'html' },
		         { id: 'eduStNm', 		ctrlId: 'eduStNm', 		value: 'html' },
		         { id: 'prctScnNm', 	ctrlId: 'prctScnNm', 	value: 'html' },
		         { id: 'rgstDt', 		ctrlId: 'rgstDt', 		value: 'value'},
		         { id: 'dtlSbc', 		ctrlId: 'dtlSbc', 		value: 'value'},
		         { id: 'mchnUfe', 		ctrlId: 'mchnUfe', 		value: 'value'},
		         { id: 'mchnUfeClCd', 	ctrlId: 'mchnUfeClCd', 	value: 'value'},
		         
		         { id: 'testSpceCd', 	ctrlId: 'testSpceCd', 	value: 'value'},
		         { id: 'testCnd01', 	ctrlId: 'testCnd01', 	value: 'value'},
		         { id: 'testCnd02', 	ctrlId: 'testCnd02', 	value: 'value'},
		         { id: 'cyclFlag', 	    ctrlId: 'cyclFlag', 	value: 'value'},
		         { id: 'rsrtDivnCd', 	ctrlId: 'rsrtDivnCd', 	value: 'value'} 
		     ]
		});

		fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/mchn/open/rlabMchn/retrieveMchnPrctInfo.do"/>',
				params :{
					mchnPrctId  : mchnPrctId	//교육명
	                }
			});
		}

		if( Rui.isEmpty(mchnPrctId)){
			var frm = document.aform;
			
			//butdel.hide();
			
			frm.mchnHanNm.value = '${result.mchnHanNm}';
			frm.mchnEnNm.value = '${result.mchnEnNm}';
			frm.toMailAddr.value = '${result.crgrMail}';
			frm.crgrNm.value = '${result.crgrNm}';
			frm.mchnUfeClCd.value = '${result.mchnUfeClCd}';
			frm.mchnClCd.value = '${inputData.mchnClCd}';
			frm.rsrtDivnCd.value = '${inputData.mchnClCd}';
			
			Rui.get("hMchnHanNm").html('${result.mchnHanNm}');
			Rui.get("hMchnEnNm").html('${result.mchnEnNm}');
			Rui.get("hRgstNm").html('${inputData.userNm}');
			Rui.get("deptNm").html('${inputData.userDeptName}');
			
			var eduStnmHtml ="";

			//chkCcs = '${result.eduStCd}';

			/*
			if(chkCcs == "RQ" ){
				eduStnmHtml =  '${result.eduStNm}';
			}else if(chkCcs == "CCS"   ){
				eduStnmHtml =  '${result.eduStNm}'+ "(수료일 : "+'${result.ccsDt}'+")";
			}else if(chkCcs == "NCPE"   ){
				eduStnmHtml =  '${result.eduStNm}'+ "(미수료일 : "+'${result.ccsDt}'+")";
			}
			*/
			
			//Rui.get("eduStNm").html(eduStnmHtml);
			
			var tmpDt = '${inputData.year}'+"-"+'${inputData.mm}'+"-"+'${inputData.day}';
			//prctDt.setValue(tmpDt);

			document.aform.rgstId.value = '${inputData.userSabun}';
			document.aform.mchnInfoId.value = '${inputData.mchnInfoId}';
			
		}else{
			fnSearch();
		}
		
		/* [버튼] : 보유장비 예약 저장 및 수정 */
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
   	        	    url: "<c:url value='/mchn/open/rlabMchn/saveMchnPrctInfo.do'/>",
   	        	    form : 'aform',
   	        	    params : {
   	        	    	 mailTitl : mailTitl				//mail title
   	        	    	,mchnHanNm : encodeURIComponent(document.aform.mchnHanNm.value)
   	        	    	,mchnEnNm : encodeURIComponent(document.aform.mchnEnNm.value)
   	        	    	,rgstNm : encodeURIComponent(document.aform.rgstNm.value)
   	        	    }
   	        	 });
				}
			}
    		
    	});
    	
    	/* [버튼] : 보유장비예약 삭제 */
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
			if(confirm("장비예약을 삭제하시겠습니까?")) {
  	        		dm.updateForm({
  	        	    url: "<c:url value='/mchn/open/rlabMchn/deleteMchnPrctInfo.do'/>",
  	        	    form : 'aform',
  	        	    params : {
  	        	    	mchnPrctId : dataSet.getNameValue(0, "mchnPrctId")				//mail title
  	        	    }
  	        	 });
			}
    	});
		
		//분석장비 예약 팝업창 닫기
		var butCls = new Rui.ui.LButton('butCls');
		butCls.on('click', function(){
			parent.fncPopCls();
        });
	
		var fncVaild = function(){
			var frm = document.aform;
			
			if(Rui.isEmpty(prctTitl.getValue())){
				alert("신청제목을 입력하세요");
				prctTitl.focus();
    			return false;
			}
			if(Rui.isEmpty(smpoNm.getValue())){
				alert("시료명을 입력하세요");
				smpoNm.focus();
    			return false;
			}
			if(Rui.isEmpty(smpoQty.getValue())){
				alert("시료수를 입력하세요");
				smpoQty.focus();
    			return false;
			}
			
			if(mchnClCd == '01'){
				if(Rui.isEmpty(testSpceCd.getValue())){
					alert("테스트공간을 입력하세요");
					testSpceCd.focus();
	    			return false;
				}
				if(Rui.isEmpty(testCnd01.getValue())){
					alert("시험조건을 입력하세요");
					testCnd01.focus();
	    			return false;
				}				
				if(Rui.isEmpty(testCnd02.getValue())){
					alert("시험조건을 입력하세요");
					testCnd02.focus();
	    			return false;
				}				
			}
			
			if(mchnClCd == '01' || mchnClCd == '02'){
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
				
			}
			
			if(mchnClCd =='03'){
			
				if(Rui.isEmpty(prctDt.getValue())){
					alert("예약일을 입력하세요");
					prctDt.focus();
	    			return false;
				}
				if(Rui.isEmpty(cbPrctFromHH.getValue())){
					alert("예약시작시간 입력하세요");
					cbPrctFromHH.focus();
	    			return false;
				}
				if(Rui.isEmpty(cbPrctFrommm.getValue())){
					alert("예약시작분을 입력하세요");
					cbPrctFrommm.focus();
	    			return false;
				}
				if(Rui.isEmpty(cbPrctToHH.getValue())){
					alert("예약종료시간 입력하세요");
					cbPrctToHH.focus();
	    			return false;
				}
				if(Rui.isEmpty(cbPrctTomm.getValue())){
					alert("예약종료분을 입력하세요");
					cbPrctTomm.focus();
	    			return false;
				}
				
				var frt = Number(cbPrctFromHH.getValue()+cbPrctFrommm.getValue());
				var tot = Number(cbPrctToHH.getValue()+cbPrctTomm.getValue());
				
				if(frt >  tot ){
					alert("예약종료시간이 시작시간보다 작을 수 없습니다.")
					return false;
				}
				
				frm.prctFromTim.value = cbPrctFromHH.getValue()+":"+cbPrctFrommm.getValue();
				frm.prctToTim.value = cbPrctToHH.getValue()+":"+cbPrctTomm.getValue();
			
			}
			
    	    //frm.Wec.CleanupOptions = "msoffice | empty | comment";
    		//frm.Wec.value =frm.Wec.CleanupHtml(frm.Wec.value);
    		//frm.dtlSbc.value = frm.Wec.BodyValue;
    		

    		dtlSbc = CrossEditor.GetBodyValue();
    	
     		if(CrossEditor.GetBodyValue()=="" || CrossEditor.GetBodyValue()=="<p><br></p>"){
     		    alert("개요내용을 입력해 주세요!!");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}
    		
    		//frm.dtlSbc.value = frm.Wec.MIMEValue;
    		
    		frm.dtlSbc.value = CrossEditor.GetBodyValue();
    		
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
				<input type="hidden" id="mchnEnNm" name="mchnEnNm" />
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" />
				<input type="hidden" id="prctFromTim" name="prctFromTim" />
				<input type="hidden" id="prctToTim" name="prctToTim" />
				
				<input type="hidden" id="mchnUfeClCd" name="mchnUfeClCd" />
				<input type="hidden" id="mchnUfe" name="mchnUfe" />
				<input type="hidden" id="mchnClCd" name="mchnClCd" />
				<input type="hidden" id="rsrtDivnCd" name="rsrtDivnCd" />

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
						<col style="width: 40%" />
						<col style="width: 15%" />
						<col style="width:" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>신청제목</th>
							<td colspan="3">
								<input type="text" id="prctTitl" />
							</td>
						</tr>
						<tr>
							<th align="right">기기명</th>
							<td>
								<span id="hMchnHanNm"></span>(<span id="hMchnEnNm"></span>)
							</td>
							<th align="right">신청자(팀)</th>
							<td>
								<span id="hRgstNm"></span>(<span id="deptNm"></span>)
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>시료명</th>
							<td>
								<input type="text" id="smpoNm" />
							</td>
							<th align="right"><span style="color:red;">*  </span>시료수</th>
							<td>
								<input type="text" id="smpoQty" />
							</td>

						</tr>
						<c:if test="${inputData.mchnClCd == '01'}">
							<tr>
								<th align="right"><span style="color:red;">*  </span>테스트공간</th>
								<td>
									<select id="testSpceCd">
										<option value="01">Floor</option>
	   									<option value="02">Wall</option>
	   								</select>
								</td>
								<th align="right"><span style="color:red;">*  </span>시험조건</th>
								<td>
									<input type="text" id="testCnd01"/> ~ 
									<input type="text" id="testCnd02"/>
									<label>C </label>&nbsp;
									<input type="checkbox" id="cyclFlag">
									<label>싸이클</label>
									
								</td>
							</tr>	
						</c:if>	
									
						<c:if test="${inputData.mchnClCd == '01' || inputData.mchnClCd == '02'}">
							<tr>
								<th align="right"><span style="color:red;">*  </span>예약일시</th>
								<td>
									<input id="prctFromDt" type="text" /><em class="gab"> ~ </em>
									<input id="prctToDt" type="text" />

								</td>
								<th align="right">승인상태</th>
								<td >
									<span id="prctScnNm">
								</td>							
							</tr>
						</c:if>
						
						<c:if test="${inputData.mchnClCd == '03'}">
							<tr>
								<th align="right"><span style="color:red;">*  </span>예약일시</th>
								<td>
									<input id="prctDt" type="text" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<select id="prctFromHH">
										<option value="00">00</option>
	   									<option value="01">01</option>
	   									<option value="02">02</option>
	   									<option value="03">03</option>
	   									<option value="04">04</option>
	   									<option value="05">05</option>
	   									<option value="06">06</option>
	   									<option value="07">07</option>
	   									<option value="08">08</option>
	   									<option value="09">09</option>
	   									<option value="10">10</option>
	   									<option value="11">11</option>
	   									<option value="12">12</option>
	   									<option value="13">13</option>
	   									<option value="14">14</option>
	   									<option value="15">15</option>
	   									<option value="16">16</option>
	   									<option value="17">17</option>
	   									<option value="18">18</option>
	   									<option value="19">19</option>
	   									<option value="20">20</option>
	   									<option value="21">21</option>
	   									<option value="22">22</option>
	   									<option value="23">23</option>
									</select> :
									<select id="prctFrommm">
										<option value="00">00</option>
	   									<option value="10">10</option>
	   									<option value="20">20</option>
	   									<option value="30">30</option>
	   									<option value="40">40</option>
	   									<option value="50">50</option>
									</select>
									<select id="prctToHH">
										<option value="00">00</option>
	   									<option value="01">01</option>
	   									<option value="02">02</option>
	   									<option value="03">03</option>
	   									<option value="04">04</option>
	   									<option value="05">05</option>
	   									<option value="06">06</option>
	   									<option value="07">07</option>
	   									<option value="08">08</option>
	   									<option value="09">09</option>
	   									<option value="10">10</option>
	   									<option value="11">11</option>
	   									<option value="12">12</option>
	   									<option value="13">13</option>
	   									<option value="14">14</option>
	   									<option value="15">15</option>
	   									<option value="16">16</option>
	   									<option value="17">17</option>
	   									<option value="18">18</option>
	   									<option value="19">19</option>
	   									<option value="20">20</option>
	   									<option value="21">21</option>
	   									<option value="22">22</option>
	   									<option value="23">23</option>
									</select> :
									<select id="prctTomm">
										<option value="00">00</option>
	   									<option value="10">10</option>
	   									<option value="20">20</option>
	   									<option value="30">30</option>
	   									<option value="40">40</option>
	   									<option value="50">50</option>
									</select>
								</td>
								<th align="right">승인상태</th>
								<td >
									<span id="prctScnNm">
								</td>							
							</tr>						
						</c:if>
						<!--  
						<tr>
							<th align="right">교육여부</th>
							<td >
								<span id="eduStNm">
							</td>
							<th align="right">승인상태</th>
							<td >
								<span id="prctScnNm">
							</td>
						</tr>
						-->
						<tr>
							<th  align="right">개요</th>
							<td colspan="3">
								<textarea id="dtlSbc" name="dtlSbc"></textarea>
									<script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('dtlSbc');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										CrossEditor.params.ImageSavePath = "/iris/resource/fileupload/mchn";
										CrossEditor.params.FullScreen = false;
										CrossEditor.params.Height = 320;
										CrossEditor.EditorStart();
										
										function OnInitCompleted(e){
											e.editorTarget.SetBodyValue(document.getElementById("dtlSbc").value);
										}
									</script>
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