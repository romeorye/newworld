<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: leasHousDtl.jsp
 * @desc    : 임차주택 신청화면(개인용)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.10.22  IRIS005  	최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript">

var leasId;
var chkDownMuag = "N";     
var chkDownDpl  = "N";     
var chkDownNrm  = "N";   

	Rui.onReady(function() {
		
		leasId = '${inputData.leasId}';
		
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
                , { id: 'leasId' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
		
        /*******************
         * 변수 및 객체 선언
         *******************/   
         var dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
            	  { id : 'leasId'}    
            	 ,{ id : 'empNo'}  //   
            	 ,{ id : 'deptCd'}  // 		부서                              
            	 ,{ id : 'supDt'}  // 		지원기간 시작일                  
            	 ,{ id : 'leasGrnAmt'}  //  임차보증금                 
            	 ,{ id : 'pslfAmt'}  //		본인부담금                 
            	 ,{ id : 'supAmt'}  //  	회사지원금액                     
            	 ,{ id : 'reqStCd'}  // 	요청 상태(승인/반려/완료)        
            	 ,{ id : 'pgsStCd'}  // 	진행상태(사전검토/ 계약검토/ )   
            	 ,{ id : 'tod'}  //			회차                             
            	 ,{ id : 'etcpDt'}  //		입사일                           
            	 ,{ id : 'jdNo'}  //  		법무시스템 No                    
            	 ,{ id : 'reNm'}  //		부동산명                   
            	 ,{ id : 'reCcpcHpF'}  //  부동산 연락처              
            	 ,{ id : 'reCcpcHpS'}  //  부동산 연락처              
            	 ,{ id : 'reCcpcHpE'}  //  부동산 연락처              
            	 ,{ id : 'leasAddr'}  //	전세지역 주소              
            	 ,{ id : 'lesrNm'}  // 	임대인명              
            	 ,{ id : 'lviDt'}  //   입주일자                   
            	 ,{ id : 'lesrCcpcHpF'}  // 	--임대인 휴대폰              
            	 ,{ id : 'lesrCcpcHpS'}  // 	--임대인 휴대폰              
            	 ,{ id : 'lesrCcpcHpE'}  // 	--임대인 휴대폰              
            	 ,{ id : 'cnttStrDt'}  //	--계약기간 시작일            
            	 ,{ id : 'cnttEndDt'}  //	--계약기간 종료일            
            	 ,{ id : 'blnDt'}  //    --잔금일자                   
            	 ,{ id : 'etc'}  //--전세지역 주소--기타사항    
            	 ,{ id : 'rolYn'}  //	--전세권 설정 여부           
            	 ,{ id : 'leasMuagYn'}  //  --임차주택관리합의서 여부    
            	 ,{ id : 'riskYn'}  //	--법적인 risk 여부           
            	 ,{ id : 'lbltYn'}  //	--채무관계 여부              
            	 ,{ id : 'dplYn'}  //	--확약서 여부                
            	 ,{ id : 'nrmYn'}  //	--규정 여부                
            	 ,{ id : 'rgsPfdcAttcFilId'}  //    --등기사항전부증명서(을구사항 포함) 
            	 ,{ id : 'rlySubjAttcFilId'}  //    --중개대상물확인설명서              
            	 ,{ id : 'asmyAchtAttcFilId'}  //    --집합건축물대장(전유무.갑)         
            	 ,{ id : 'lesrPfdcAttcFilId'}  //    --임대인 신분증 사본                
            	 ,{ id : 'muagAttcFilId'}  //    --임차주택관리합의서 첨부파일 id  
            	 ,{ id : 'dplAttcFilId'}  //    --확약서 첨부파일 id   
            	 ,{ id : 'nrmAttcFilId'}  //    --규격 첨부파일 id   
            	 ,{ id : 'muagScanAttcFilId'}  //    --합의서 스캔 첨부파일 id   
            	 ,{ id : 'dplScanAttcFilId'}  //    --협약서 스캔 첨부파일 id   
            	 ,{ id : 'rvwCmmt'}  			//
            	 ,{ id : 'crnCmmt'}  			//
            	 ,{ id : 'empNm'}  			//
            	 ,{ id : 'deptNm'}  //
            	 ,{ id : 'pgsStNm'}  //
            	 ,{ id : 'reqStNm'}  //
             ]
        });
		
         dataSet.on('load', function(e) {
        	 
        	 if( Rui.isEmpty( leasId ) ){
         		dataSet.setNameValue(0, 'empNm', '${inputData._userNm}');
         		dataSet.setNameValue(0, 'deptNm', '${inputData._userDeptName}');
         		dataSet.setNameValue(0, 'tod', 1);
         		dataSet.setNameValue(0, 'empNo', '${inputData._userSabun}');
         		dataSet.setNameValue(0, 'deptCd', '${inputData._teamDept}');
         		dataSet.setNameValue(0, 'reqStCd', "RQ");
         		dataSet.setNameValue(0, 'pgsStCd', "RQ");
         	}else{
         		rolYn.setValue( dataSet.getNameValue(0, 'rolYn'));
         		leasMuagYn.setValue( dataSet.getNameValue(0, 'leasMuagYn'));
         		riskYn.setValue( dataSet.getNameValue(0, 'riskYn'));
         		lbltYn.setValue( dataSet.getNameValue(0, 'lbltYn'));
         		dplYn.setValue( dataSet.getNameValue(0, 'dplYn'));
         		nrmYn.setValue( dataSet.getNameValue(0, 'nrmYn'));
         	}
         	
         	if( dataSet.getNameValue(0, 'pgsStCd') != "RQ"  ){
         		$("#btnSave").hide();
 				$("#btnReq").hide();
 				$("#rgsPfdcAttchFileMngBtn").hide();
 				$("#rlySubjAttchFileMngBtn").hide();
 				$("#asmyAchtAttchFileMngBtn").hide();
 				$("#lesrPfdcAttchFileMngBtn").hide();
 				$("#muagScanAttchFileMngBtn").hide();
 				$("#dplScanAttchFileMngBtn").hide();
         	}
     			
         	if( !Rui.isEmpty( dataSet.getNameValue(0, 'rgsPfdcAttcFilId') )  ){
				getAttachFileList(dataSet.getNameValue(0, 'rgsPfdcAttcFilId'), 'RG');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'rlySubjAttcFilId') )  ){
				getAttachFileList1(dataSet.getNameValue(0, 'rlySubjAttcFilId'), 'RL');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'asmyAchtAttcFilId') )  ){
				getAttachFileList2(dataSet.getNameValue(0, 'asmyAchtAttcFilId'), 'AS');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'lesrPfdcAttcFilId') )  ){
				getAttachFileList3(dataSet.getNameValue(0, 'lesrPfdcAttcFilId'), 'LE');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'muagAttcFilId') )  ){
				getAttachFileList4(dataSet.getNameValue(0, 'muagAttcFilId'), 'MU');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'dplAttcFilId') )  ){
				getAttachFileList5(dataSet.getNameValue(0, 'dplAttcFilId'), 'DP');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'nrmAttcFilId') )  ){
				getAttachFileList6(dataSet.getNameValue(0, 'nrmAttcFilId'), 'NR');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'muagScanAttcFilId') )  ){
				getAttachFileList7(dataSet.getNameValue(0, 'muagScanAttcFilId'), 'MS');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'dplScanAttcFilId') )  ){
				getAttachFileList8(dataSet.getNameValue(0, 'dplScanAttcFilId'), 'DS');
			}
         });
        
       	//지원기간
         var supDt = new Rui.ui.form.LNumberBox({
         	applyTo: 'supDt',
             width: 80
 		});
       	
       	//지원종료일
         var etcpDt = new Rui.ui.form.LDateBox({
 			applyTo: 'etcpDt',
 			mask: '9999-99-99',
 			displayValue: '%Y-%m-%d',
 			editable: false,
 			width: 200,
 			dateType: 'string'
 		});
       	
       	//회사지원금액
         supAmt = new Rui.ui.form.LNumberBox({
             applyTo: 'supAmt',
             defaultValue: 0,
             width: 200
         });
       	
         supAmt.on('blur', function(e) {
         	fncAmtSum();
 	    });
         
       	/* 	
       	//회차
         tod = new Rui.ui.form.LNumber({
             applyTo: 'tod',
             defaultValue: 0,
             width: 200
         });
       	 */
 		//부동산명
         reNm = new Rui.ui.form.LTextBox({
             applyTo: 'reNm',
             width: 200
         });
       	
       	//부동산 연락처(처음)
         var reCcpcHpF = new Rui.ui.form.LCombo({
             applyTo: 'reCcpcHpF',
             defaultValue: '010',
             width: 60,
             items: [
                 { value: '010', text: '010'} // text는 생략 가능하며, 생략시 value값을 그대로 사용한다. 
                ,{ value: '02', text: '02' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                ,{ value: '031', text: '031' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                ,{ value: '032', text: '032' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                ,{ value: '042', text: '042' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                ,{ value: '070', text: '070' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
             ]
         });

       	//부동산 연락처(중간)
         reCcpcHpS = new Rui.ui.form.LTextBox({
             applyTo: 'reCcpcHpS',
             width: 60
         });
       	//부동산 연락처(마지막)
         reCcpcHpE = new Rui.ui.form.LTextBox({
             applyTo: 'reCcpcHpE',
             width: 60
         });
       	
       	//전세지역 주소
         leasAddr = new Rui.ui.form.LTextBox({
             applyTo: 'leasAddr',
             width: 830
         });
       	
       	//임대인명
         lesrNm = new Rui.ui.form.LTextBox({
             applyTo: 'lesrNm',
             width: 200
         });
         
       	//임대인 연락처(처음)
         var lesrCcpcHpF = new Rui.ui.form.LCombo({
             applyTo: 'lesrCcpcHpF',
             defaultValue: '010',
             width: 60,
             items: [
                { value: '010', text: '010'} // text는 생략 가능하며, 생략시 value값을 그대로 사용한다. 
                ,{ value: '02', text: '02' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                ,{ value: '031', text: '031' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                ,{ value: '032', text: '032' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                ,{ value: '042', text: '042' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                ,{ value: '070', text: '070' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
             ]
         });

       	//임대인 연락처(중간)
         lesrCcpcHpS = new Rui.ui.form.LTextBox({
             applyTo: 'lesrCcpcHpS',
             width: 60
         });
       	
       	//임대인 연락처(마지막)
         lesrCcpcHpE = new Rui.ui.form.LTextBox({
             applyTo: 'lesrCcpcHpE',
             width: 60
         });
       	
       	//임차보증금
         leasGrnAmt = new Rui.ui.form.LNumberBox({
             applyTo: 'leasGrnAmt',
             defaultValue: 0,
             width: 200
         });
       	
         leasGrnAmt.on('blur', function(e) {
         	fncAmtSum();
 	    });
       	/* 
       	//본인부담금
         pslfAmt = new Rui.ui.form.LNumberBox({
             applyTo: 'pslfAmt',
             defaultValue: 0,
             width: 200
         });
       	 */
       	//입주일자
         var lviDt = new Rui.ui.form.LDateBox({
 			applyTo: 'lviDt',
 			mask: '9999-99-99',
 			displayValue: '%Y-%m-%d',
 			editable: false,
 			width: 100,
 			dateType: 'string'
 		});
         
       	//잔금일자
         var blnDt = new Rui.ui.form.LDateBox({
 			applyTo: 'blnDt',
 			mask: '9999-99-99',
 			displayValue: '%Y-%m-%d',
 			editable: false,
 			width: 100,
 			dateType: 'string'
 		});
         
       	//기타사항
         etc = new Rui.ui.form.LTextArea({
             applyTo: 'etc',
             height: 100,
             width: 850
         });
       
       	//전세권 설정 여부
         var rolYn = new Rui.ui.form.LRadioGroup({
             applyTo : 'rolYn',
             name : 'rolYn',
             items : [
                 {
                     label : '동의',
                     value : 'Y'
                 }
             ]
         });
       	
       	//법적인 risk 여부 
         var riskYn = new Rui.ui.form.LRadioGroup({
             applyTo : 'riskYn',
             items : [
                 {
                     label : '없음',
                     value : 'Y'
                 }
             ]
         });
       	//채무관계 여부
         var lbltYn = new Rui.ui.form.LRadioGroup({
             applyTo : 'lbltYn',
             items : [
                 {
                     label : '없음',
                     value : 'Y'
                 }
             ]
         });
       
       	//임차주택관리합의서 여부
         var leasMuagYn = new Rui.ui.form.LRadioGroup({
             applyTo : 'leasMuagYn',
             //disabled: true,
             items : [
                 {
                     label : '동의',
                     value : 'Y'
                 }
             ]
         });
         
       	//확약서 여부 
         var dplYn = new Rui.ui.form.LRadioGroup({
             applyTo : 'dplYn',
             //disabled: true,
             items : [
                 {
                     label : '동의',
                     value : 'Y'
                 }
             ]
         });
       	
       	//규격 여부 
         var nrmYn = new Rui.ui.form.LRadioGroup({
             applyTo : 'nrmYn',
             //disabled: true,
             items : [
                 {
                     label : '동의',
                     value : 'Y'
                 }
             ]
         });
         
         //계약기간 시작일 
         var cnttStrDt = new Rui.ui.form.LDateBox({
 			applyTo: 'cnttStrDt',
 			mask: '9999-99-99',
 			defaultValue: '<c:out value="${inputData.cnttStrDt}"/>',
 			displayValue: '%Y-%m-%d',
 			editable: false,
 			width: 100,
 			dateType: 'string'
 		});
         
       	//계약기간 종료일 
         var cnttEndDt = new Rui.ui.form.LDateBox({
 			applyTo: 'cnttEndDt',
 			mask: '9999-99-99',
 			defaultValue: '<c:out value="${inputData.cnttEndDt}"/>',
 			displayValue: '%Y-%m-%d',
 			editable: false,
 			width: 100,
 			dateType: 'string'
 		});
       	
         fnSearch = function() {
         	dataSet.load({
             	url: '<c:url value="/knld/leasHous/retrieveLeasHousDtlInfo.do"/>',
                 params : {
                 	leasId :  leasId
                 }
             });
         }
       	
         fnSearch();
         
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet1 = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet2 = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet3 = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet4 = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet5 = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet6 = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet7 = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         /* [기능] 첨부파일 조회*/
         var attachFileDataSet8 = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         
         attachFileDataSet.on('load', function(e) {
    		 getAttachFileInfoList();
         });
         attachFileDataSet1.on('load', function(e) {
    		 getAttachFileInfoList1();
         });
         attachFileDataSet2.on('load', function(e) {
    		 getAttachFileInfoList2();
         });
         attachFileDataSet3.on('load', function(e) {
    		 getAttachFileInfoList3();
         });
         attachFileDataSet4.on('load', function(e) {
    		 getAttachFileInfoList4();
         });
         attachFileDataSet5.on('load', function(e) {
    		 getAttachFileInfoList5();
         });
         attachFileDataSet6.on('load', function(e) {
    		 getAttachFileInfoList6();
         });
         attachFileDataSet7.on('load', function(e) {
    		 getAttachFileInfoList7();
         });
         attachFileDataSet8.on('load', function(e) {
    		 getAttachFileInfoList8();
         });
         
         getAttachFileList = function(id) {
             attachFileDataSet.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
             });
         };
         getAttachFileList1 = function(id) {
             attachFileDataSet1.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
             });
         };
         getAttachFileList2 = function(id) {
             attachFileDataSet2.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
             });
         };
         getAttachFileList3 = function(id) {
             attachFileDataSet3.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
             });
         };
         getAttachFileList4 = function(id) {
             attachFileDataSet4.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
             });
         };
         getAttachFileList5 = function(id) {
             attachFileDataSet5.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
             });
         };
         getAttachFileList6 = function(id) {
             attachFileDataSet6.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
             });
         };
         getAttachFileList7 = function(id) {
             attachFileDataSet7.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
	         });
         };
         getAttachFileList8 = function(id) {
             attachFileDataSet8.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                 	attcFilId : id
                 }
             });
         };
        
        
         getAttachFileInfoList = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
             }

           	 setAttachFileInfo(attachFileInfoList);
         };
         getAttachFileInfoList1 = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet1.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet1.getAt(i).clone());
             }

           	 setAttachFileInfo1(attachFileInfoList);
         };
         getAttachFileInfoList2 = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet2.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet2.getAt(i).clone());
             }

           	 setAttachFileInfo2(attachFileInfoList);
         };
         getAttachFileInfoList3 = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet3.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet3.getAt(i).clone());
             }

           	 setAttachFileInfo3(attachFileInfoList);
         };
         getAttachFileInfoList4 = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet4.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet4.getAt(i).clone());
             }

           	 setAttachFileInfo4(attachFileInfoList);
         };
         getAttachFileInfoList5 = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet5.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet5.getAt(i).clone());
             }

           	 setAttachFileInfo5(attachFileInfoList);
         };
         getAttachFileInfoList6 = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet6.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet6.getAt(i).clone());
             }

           	 setAttachFileInfo6(attachFileInfoList);
         };
         getAttachFileInfoList7 = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet7.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet7.getAt(i).clone());
             }

           	 setAttachFileInfo7(attachFileInfoList);
         };
         getAttachFileInfoList8 = function(gbn) {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet8.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet8.getAt(i).clone());
             }

           	 setAttachFileInfo8(attachFileInfoList);
         };
         
         
         setAttachFileInfo = function(attachFileList) {
         	$('#rgsPfdcAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#rgsPfdcAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "rgsPfdcAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         setAttachFileInfo1 = function(attachFileList) {
         	$('#rlySubjAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#rlySubjAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "rlySubjAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         setAttachFileInfo2 = function(attachFileList) {
         	$('#asmyAchtAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#asmyAchtAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "asmyAchtAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         setAttachFileInfo3 = function(attachFileList) {
         	$('#lesrPfdcAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#lesrPfdcAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "lesrPfdcAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         setAttachFileInfo4 = function(attachFileList) {
         	$('#muagAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#muagAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "muagAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         setAttachFileInfo5 = function(attachFileList) {
         	$('#dplAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#dplAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "dplAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         setAttachFileInfo6 = function(attachFileList) {
         	$('#nrmAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#nrmAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "nrmAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         setAttachFileInfo7 = function(attachFileList) {
         	$('#muagScanAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#muagScanAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "muagScanAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         setAttachFileInfo8 = function(attachFileList) {
         	$('#dplScanAttchFileView').html('');
         	
         	if(attachFileList.length > 0) {
             	for(var i = 0; i < attachFileList.length; i++) {
                     $('#dplScanAttchFileView').append($('<a/>', {
                     	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }
               
             	dataSet.setNameValue(0, "dplScanAttcFilId", attachFileList[0].data.attcFilId);
             }
         }
         
         getAttachFileId = function(gbn) {
             var lvAttcFilId;
 			
             if ( gbn =="RG" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'rgsPfdcAttcFilId');
             }else if( gbn =="RL" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'rlySubjAttcFilId');
             }else if( gbn =="AS" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'asmyAchtAttcFilId');
             }else if( gbn =="LE" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'lesrPfdcAttcFilId');
             }else if( gbn =="MU" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'muagAttcFilId');
             }else if( gbn =="DP" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'dplAttcFilId');
             }else if( gbn =="NR" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'nrmAttcFilId');
             }else if( gbn =="MS" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'muagScanAttcFilId');
             }else if( gbn =="DS" ){
             	lvAttcFilId = dataSet.getNameValue(0, 'dplScanAttcFilId');
             }
             
             
             if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";
             
             return lvAttcFilId;
         }; 
         
         
         
         var bind =  new Rui.data.LBind({
 	        groupId: 'aform',
 	        dataSet: dataSet,
 	        bind: true,
 	        bindInfo: [
 	        	  { id : 'supDt'		,ctrlId:	'supDt'			,value: 'value'}  // 	--지원기간 시작일                  
 	        	 ,{ id : 'supAmt'		,ctrlId:	'supAmt'		,value: 'value'}  //  	--회사지원금액                     
 	        	 ,{ id : 'etcpDt'		,ctrlId:	'etcpDt'		,value: 'value'}  //--입사일                           
 	        	 ,{ id : 'reNm'			,ctrlId:	'reNm'			,value: 'value'}  //--부동산명                   
 	        	 ,{ id : 'reCcpcHpF'	,ctrlId:	'reCcpcHpF'		,value: 'value'}  //  --부동산 연락처              
 	        	 ,{ id : 'reCcpcHpS'	,ctrlId:	'reCcpcHpS'		,value: 'value'}  //  --부동산 연락처              
 	        	 ,{ id : 'reCcpcHpE'	,ctrlId:	'reCcpcHpE'		,value: 'value'}  //  --부동산 연락처              
 	        	 ,{ id : 'leasAddr'		,ctrlId:	'leasAddr'		,value: 'value'}  //	--전세지역 주소              
 	        	 ,{ id : 'lesrNm'		,ctrlId:	'lesrNm'		,value: 'value'}  // 	--임대인명              
 	        	 ,{ id : 'lesrCcpcHpF'	,ctrlId:	'lesrCcpcHpF'	,value: 'value'}  // 	--임대인 휴대폰              
 	        	 ,{ id : 'lesrCcpcHpS'	,ctrlId:	'lesrCcpcHpS'	,value: 'value'}  // 	--임대인 휴대폰              
 	        	 ,{ id : 'lesrCcpcHpE'	,ctrlId:	'lesrCcpcHpE'	,value: 'value'}  // 	--임대인 휴대폰              
 	        	 ,{ id : 'cnttStrDt'	,ctrlId:	'cnttStrDt'		,value: 'value'}  //	--계약기간 시작일            
 	        	 ,{ id : 'cnttEndDt'	,ctrlId:	'cnttEndDt'		,value: 'value'}  //	--계약기간 종료일            
 	        	 ,{ id : 'leasGrnAmt'	,ctrlId:	'leasGrnAmt'	,value: 'value'}  //  --임차보증금                 
 	        	 ,{ id : 'pslfAmt'		,ctrlId:	'pslfAmt'		,value: 'value'}  //	--본인부담금                 
 	        	 ,{ id : 'lviDt'		,ctrlId:	'lviDt'			,value: 'value'}  //    --입주일자                   
 	        	 ,{ id : 'blnDt'		,ctrlId:	'blnDt'			,value: 'value'}  //    --잔금일자                   
 	        	 ,{ id : 'etc'			,ctrlId:	'etc'			,value: 'value'}  //	--기타사항    
 	        	 ,{ id : 'rolYn'		,ctrlId:	'rolYn'			,value: 'value'}  //	--전세권 설정 여부           
 	        	 ,{ id : 'leasMuagYn'	,ctrlId:	'leasMuagYn'	,value: 'value'}  //  --임차주택관리합의서 여부    
 	        	 ,{ id : 'riskYn'		,ctrlId:	'riskYn'		,value: 'value'}  //	--법적인 risk 여부           
 	        	 ,{ id : 'lbltYn'		,ctrlId:	'lbltYn'		,value: 'value'}  //	--채무관계 여부              
 	        	 ,{ id : 'dplYn'			,ctrlId:	'dplYn'			,value: 'value'}  //	--확약서 여부                
 	        	 ,{ id : 'nrmYn'			,ctrlId:	'nrmYn'			,value: 'value'}  //	--확약서 여부                
 	        	 ,{ id : 'muagAttcFilId'	,ctrlId:	'muagAttcFilId'	,value: 'value'}  //	--확약서 여부                
 	        	 ,{ id : 'dplAttcFilId'		,ctrlId:	'dplAttcFilId'	,value: 'value'}  //	--확약서 여부                
 	        	 ,{ id : 'nrmAttcFilId'		,ctrlId:	'nrmAttcFilId'	,value: 'value'}  //	--확약서 여부                
 	        	 ,{ id : 'empNm'			,ctrlId:	'empNm'			,value: 'html'}  			//
 	        	 ,{ id : 'deptNm'			,ctrlId:	'deptNm'		,value: 'html'}  //
 	        ]
 	    });

         fncAmtSum = function(){
         	var l = leasGrnAmt.getValue();   //임차보증금  
         	var s = supAmt.getValue();           //회사지원금액   
         	
         	var totAmt = l-s;
         	
         	document.getElementById("pslfAmt").innerHTML = Rui.util.LNumber.toMoney(totAmt);
         	dataSet.setNameValue(0, 'pslfAmt', totAmt);
         } 
	
         fnSave = function(){
         	//서버전송용
             var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
            	dm.on('success', function(e) {
        			var resultData = resultDataSet.getReadData(e);
        		 	
        			if( resultData.records[0].rtnSt == "S"){
        				leasId = resultData.records[0].leasId;
        				
        				if(confirm('저장 하였습니다. 검토요청을 하시겠습니까?')) {
     	   				fnRvwReq(leasId);
     	   			}else{
     	   				fncLeasHousList();
     	   			}	
        			}else{
        				Rui.alert(resultData.records[0].rtnMsg);
        			}
        	    });

         	dm.on('failure', function(e) {      // 업데이트 실패시
         		var resultData = resultDataSet.getReadData(e);
     	   			Rui.alert(resultData.records[0].rtnMsg);
         	});
 	 
         	if(!vm.validateGroup("aform")) {
             	alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                 return false;
            }
         	
         	if( Rui.isEmpty(dataSet.getNameValue(0, 'rgsPfdcAttcFilId')) ){
         		Rui.alert("등기사항전부증명서를 첨부하세요.");
         		return;
         	}else if ( Rui.isEmpty(dataSet.getNameValue(0, 'rlySubjAttcFilId')) ){
         		Rui.alert("중개대상물확인설명서를 첨부하세요.");
         		return;
         	}else if ( Rui.isEmpty(dataSet.getNameValue(0, 'asmyAchtAttcFilId')) ){
         		Rui.alert("집합건축물대장을 첨부하세요.");
         		return;
         	}else if ( Rui.isEmpty(dataSet.getNameValue(0, 'lesrPfdcAttcFilId')) ){
         		Rui.alert("임대인 신분증 사본을 첨부하세요.");
         		return;
         	}else if ( Rui.isEmpty(dataSet.getNameValue(0, 'muagScanAttcFilId')) ){
         		Rui.alert("임차죽택합의서 스캔파일을  첨부하세요.");
         		return;
         	}else if ( Rui.isEmpty(dataSet.getNameValue(0, 'dplScanAttcFilId')) ){
         		Rui.alert("임차주택협약서 스캔파일을 첨부하세요.");
         		return;
         	}
         	
         /* 	
         	if( chkDownMuag !="Y" ){
         		alert("임차주택관리협의서 내용을 확인하십시오");
         		return;
         	} 
         	if( chkDownDpl !="Y" ){
         		alert("임차주택협약서 내용을 확인하십시오");
         		return;
         	} 
         	if( chkDownNrm !="Y" ){
         		alert("임차주택규정 내용을 확인하십시오");
         		return;
         	} 
         	 */
         	if(confirm('저장 하시겠습니까?')) {
         		dataSet.setNameValue(0, 'rolYn', rolYn.getValue());
         		dataSet.setNameValue(0, 'leasMuagYn', leasMuagYn.getValue());
         		dataSet.setNameValue(0, 'riskYn', riskYn.getValue());
         		dataSet.setNameValue(0, 'lbltYn', lbltYn.getValue());
         		dataSet.setNameValue(0, 'dplYn', dplYn.getValue());
         		dataSet.setNameValue(0, 'nrmYn', nrmYn.getValue());
         		
         		dm.updateDataSet({
                     dataSets:[dataSet],
                     url:'<c:url value="/knld/leasHous/saveLeasHousInfo.do"/>',
                     modifiedOnly: false
                 });
         	}
         }
         
         
         fnRvwReq = function(){
         	//서버전송용
            var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
            	
         	dm.on('success', function(e) {
        			var resultData = resultDataSet.getReadData(e);
        		 	
        			if( resultData.records[0].rtnSt == "S"){
        				Rui.alert(resultData.records[0].rtnMsg);

        				fncLeasHousList();
        			}else{
        				Rui.alert(resultData.records[0].rtnMsg);
        			}
        	    });

         	dm.on('failure', function(e) {      // 업데이트 실패시
         		var resultData = resultDataSet.getReadData(e);
         		Rui.alert(resultData.records[0].rtnMsg);
             });
         	
         	if( Rui.isEmpty( leasId )) {
         		Rui.alert("저장을 먼저하셔야 합니다.");
         		return;
         	}
             
         	dm.updateDataSet({
                 dataSets:[dataSet],
                 url:'<c:url value="/knld/leasHous/updateLeasHousSt.do"/>',
                 params: {
                 	leasId : leasId
                 }
             });
         }
         
       //목록화면으로 이동
         fncLeasHousList = function(){
         	nwinsActSubmit(aform, "<c:url value='/knld/leasHous/retrieveLeasHousList.do'/>");
         }
         
         vm = new Rui.validate.LValidatorManager({
             validators: [
             	 	 { id : 'supDt'			, validExp : '지원기간 :true'}           
             		,{ id : 'supAmt'		, validExp : '회사지원금액:true'}           
             		,{ id : 'etcpDt'		, validExp : '입사일:true'}        
             		,{ id : 'reNm'			, validExp : '부동산명:true'}  
             		,{ id : 'reCcpcHpF'		, validExp : '부동산 연락처:true'}    
             		,{ id : 'reCcpcHpS'		, validExp : '부동산 연락처:true'}    
             		,{ id : 'reCcpcHpE'		, validExp : '부동산 연락처:true'}    
             		,{ id : 'leasAddr'		, validExp : '전세지역 주소:true'}   
             		,{ id : 'lesrNm'		, validExp : '임대인명:true'}
             		,{ id : 'lesrCcpcHpF'	, validExp : '임대인 휴대폰:true'}     
             		,{ id : 'lesrCcpcHpS'	, validExp : '임대인 휴대폰:true'}     
             		,{ id : 'lesrCcpcHpE'	, validExp : '임대인 휴대폰:true'}     
             		,{ id : 'cnttStrDt'		, validExp : '계약기간 시작일:true'}   
             		,{ id : 'cnttEndDt'		, validExp : '계약기간 종료일:true'}   
             		,{ id : 'leasGrnAmt'	, validExp : '임차보증금:true'}    
             		,{ id : 'lviDt'			, validExp : '입주희망일자:true'}      
             		,{ id : 'blnDt'			, validExp : '잔금일자 :true'}      
             		,{ id : 'rolYn'			, validExp : '전세권 설정 여부:true'}   
             		,{ id : 'leasMuagYn'	, validExp : '임차주택관리합의서 여부:true'}    
             		,{ id : 'riskYn'		, validExp : '법적인 risk 여부:true'}   
             		,{ id : 'lbltYn'		, validExp : '채무관계 여부:true'}   
             		,{ id : 'dplYn'			, validExp : '확약서 여부 :true'}   
             		,{ id : 'nrmYn'			, validExp : '규정확인 여부 :true'}   
             ]
         });
         
         /*첨부파일 다운로드*/
         downloadAttachFile = function(attcFilId, seq) {
         	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
         	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
         	aform.submit();
         };
         
	});//onReady 끝

</script>


</head>
<body>
<div class="contents">
	<div class="titleArea">
 		<a class="leftCon" href="#">
       	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
       	<span class="hidden">Toggle 버튼</span>
       	</a>
 		<h2>임차주택 신청</h2>
 	</div>
	<div class="sub-content">
<form name="aform" id="aform"  method="post" >
  <input type="hidden" id ="chkCmpl" name="chkCmpl" />
   				
   				<h4>- 신청자 정보</h4>		
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">성명</th>
    						<td>
   								<span id="empNm"></span>
    						</td>
   							<th align="right">소속</th>
   							<td>
   								<span id="deptNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">계약기간</th>
   							<td>
   								<input type="text" id="cnttStrDt"><em class="gab"> ~ </em> <input type="text" id="cnttEndDt"/>
   							</td>
   							<th align="right">입사일</th>
   							<td>
   								<input type="text" id="etcpDt">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">지원기간</th>
   							<td>
   								<input type="text" id="supDt"> (년)
   							</td>
   							<th align="right">회사지원금</th>
   							<td>
   								<input type="text" id="supAmt"> (원)
   							</td>
   						</tr>	
   						<tr>
   							<th align="right">임차보증금</th>
   							<td>
   								<input type="text" id="leasGrnAmt" /> (원)
   							</td>
   							<th align="right">본인부담금</th>
   							<td>
   								<span id="pslfAmt"></span> (원)
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				<h4>- 부동산 정보</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:16.2%;"/>
   						<col style="width:20%;"/>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">전세희망지역</th>
   							<td colspan="3">
   								<input type="text" id="leasAddr" />
   							</td>
   						</tr>
   						<tr>
   							<th align="right">공인중계사명</th>
   							<td>
   								<input type="text" id="reNm" />
   							</td>
   						    <th align="right">공인중계사 연락처</th>
    						<td>
   								<select id="reCcpcHpF"/>&nbsp;-</em><input type="text" id="reCcpcHpS"/> - <input type="text" id="reCcpcHpE"/>
    						</td>
   						</tr>
   						<tr>
   							<th align="right">임대인명</th>
   							<td>
   								<input type="text" id="lesrNm" />
   							</td>
   							<th align="right">임대인 연락처</th>
   							<td>
   								<select id="lesrCcpcHpF"/>&nbsp;-</em><input type="text" id="lesrCcpcHpS"/> - <input type="text" id="lesrCcpcHpE"/>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">입주희망일자</th>
   							<td>
   								<input type="text" id="lviDt" />
   							</td>
   							<th align="right">잔금일자</th>
   							<td>
   								<input type="text" id="blnDt" />
   							</td>
   						</tr>
   						<tr>
   							<th>기타요청사항</th>
   							<td colspan="3">
   								<input type="text" id="etc"  />
   							</td>	
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				<h4>- 법적사항</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">전세권설정 여부</th>
   							<td>
   								<div id="rolYn"></div>
   							</td>
   							<th align="right">법적인 risk 여부</th>
   							<td>
   								<div id="riskYn" ></div>
   							</td>
   							<th align="right">채무관계 여부</th>
   							<td>
   								<div id="lbltYn" ></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</br>
   				<h4>- 필수확인 사항</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">임차주택관리합의서 동의여부</th>
							<td>
								<div id="leasMuagYn"></div>
							</td>
   							<th align="right">원본서명</th>
							<td  id="muagAttchFileView">&nbsp;</td>
   						</tr>
   						<tr>
   							<th align="right">임차주택확약서 동의여부</th>
   							<td>
   								<div id="dplYn"></div>
   							</td>
   							<th align="right">원본서명</th>
   							<td id="dplAttchFileView">&nbsp;</td>
   						</tr>
   						<tr>	
   							<th align="right">임차주택관리 규정</th>
   							<td>
   								<div id="nrmYn"></div>
   							</td>
   							<th align="right">확인서류</th>
   							<td id="nrmAttchFileView">&nbsp;</td>
   						</tr>
   					</tbody>
   				</table>
   				<div class="titArea" style="color:red;font-weight:bold">
				   <div id="txt1" >※필독: 임차주택관리합의서 및 확약서는 원본을 출력하여 반드시 자필서명 후에 주택관리합의서는 운영팀 담당자,확약서는 H.R담당자에게 제출하여주시기바랍니다.</br>
				   		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(합의서,확약서 스켄본은 유첨 파일에 저장하여주시기바랍니다)
				   </div>
				</div>
   				<br/>
   				<h4>- 준비서류</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
		         			<th>등기사항전부증명서</br>(을구사항 포함)</th>
		         			<td  colspan="2" id="rgsPfdcAttchFileView">&nbsp;</td>
		         			<td><button type="button" class="btn" id="rgsPfdcAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId('RG'), 'knldPolicy', '*')">첨부파일등록</button></td>
		         		</tr>
   						<tr>
		         			<th>중개대상물확인설명서</th>
		         			<td colspan="2" id="rlySubjAttchFileView">&nbsp;</td>
		         			<td><button type="button" class="btn" id="rlySubjAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo1, getAttachFileId('RL'), 'knldPolicy', '*')">첨부파일등록</button></td>
		         		</tr>
   						<tr>
		         			<th>집합건축물대장(전유무.갑)</th>
		         			<td colspan="2" id="asmyAchtAttchFileView">&nbsp;</td>
	                    	<td><button type="button" class="btn" id="asmyAchtAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo2, getAttachFileId('AS'), 'knldPolicy', '*')">첨부파일등록</button></td>
		         		</tr>
   						<tr>
		         			<th>임대인 신분증 사본 </th>
		         			<td colspan="2" id="lesrPfdcAttchFileView">&nbsp;</td>
		         			<td><button type="button" class="btn" id="lesrPfdcAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo3, getAttachFileId('LE'), 'knldPolicy', '*')">첨부파일등록</button></td>
		         		</tr>
   						<tr>
		         			<th>임차주택관리합의서 서명(스캔본등록)</th>
		         			<td colspan="2" id="muagScanAttchFileView">&nbsp;</td>
		         			<td><button type="button" class="btn" id="muagScanAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo7, getAttachFileId('MS'), 'knldPolicy', '*')">첨부파일등록</button></td>
		         		</tr>
   						<tr>
		         			<th>임차주택확약서 서명(스캔본등록)</th>
		         			<td colspan="2" id="dplScanAttchFileView">&nbsp;</td>
		         			<td><button type="button" class="btn" id="dplScanAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo8, getAttachFileId('DS'), 'knldPolicy', '*')">첨부파일등록</button></td>
		         		</tr>
   					</tbody>
   				</table>
   				
</form>
   				
   				<div class="titArea">
				    <div class="LblockButton">
				        <button type="button" id="btnSave" onclick="fnSave()">저장</button>
				        <button type="button" id="btnReq" onclick="fnRvwReq()">검토요청</button>
				        <button type="button" id="butList" onclick="fncLeasHousList();" >목록</button>
				    </div>
				</div>
 			</div><!-- //sub-content -->
 		</div><!-- //contents -->
    </body>
</html>
	