<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: leasHousCnrDtlAdmin.jsp
 * @desc    : 임차주택 계약검토신청화면(관리자용)[0,
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.10.28  IRIS005  	최초생성
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
            	  { id : 'leasId'}  //  
            	 ,{ id : 'empNo'}  //   
            	 ,{ id : 'deptCd'}  // 	--부서                              
            	 ,{ id : 'supDt'}  // 	--지원기간                   
            	 ,{ id : 'supAmt'}  //  	--회사지원금액                     
            	 ,{ id : 'reqStCd'}  // 	--요청 상태(승인/반려/완료)        
            	 ,{ id : 'pgsStCd'}  // 	--진행상태(사전검토/ 계약검토/ )   
            	 ,{ id : 'tod'}  //--회차                             
            	 ,{ id : 'etcpDt'}  //--입사일                           
            	 ,{ id : 'jdNo'}  //  --법무시스템 No                    
            	 ,{ id : 'reNm'}  //--부동산명                   
            	 ,{ id : 'reCcpcHpF'}  //  --부동산 연락처              
            	 ,{ id : 'reCcpcHpS'}  //  --부동산 연락처              
            	 ,{ id : 'reCcpcHpE'}  //  --부동산 연락처              
            	 ,{ id : 'leasAddr'}  //	--전세지역 주소              
            	 ,{ id : 'lesrNm'}  // 	--임대인명              
            	 ,{ id : 'lesrCcpcHpF'}  // 	--임대인 휴대폰              
            	 ,{ id : 'lesrCcpcHpS'}  // 	--임대인 휴대폰              
            	 ,{ id : 'lesrCcpcHpE'}  // 	--임대인 휴대폰              
            	 ,{ id : 'cnttStrDt'}  //	--계약기간 시작일            
            	 ,{ id : 'cnttEndDt'}  //	--계약기간 종료일            
            	 ,{ id : 'leasGrnAmt'}  //  --임차보증금                 
            	 ,{ id : 'pslfAmt'}  //	--본인부담금                 
            	 ,{ id : 'lviDt'}  //    --입주일자                   
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
            	 ,{ id : 'lshCntdAttcFilId'}  //    --전세계약서  
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
        	
        	if(  dataSet.getNameValue(0, 'pgsStCd') != "PRI" &&  dataSet.getNameValue(0, 'reqStCd') != "RQ"){
				$("#btnReq").hide();
			}
        	
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'rgsPfdcAttcFilId') )  ){
				getAttachFileList(dataSet.getNameValue(0, 'rgsPfdcAttcFilId'));
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'rlySubjAttcFilId') )  ){
				getAttachFileList1(dataSet.getNameValue(0, 'rlySubjAttcFilId'));
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'asmyAchtAttcFilId') )  ){
				getAttachFileList2(dataSet.getNameValue(0, 'asmyAchtAttcFilId'));
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'lesrPfdcAttcFilId') )  ){
				getAttachFileList3(dataSet.getNameValue(0, 'lesrPfdcAttcFilId'));
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'lshCntdAttcFilId') )  ){
				getAttachFileList4(dataSet.getNameValue(0, 'lshCntdAttcFilId'));
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'muagAttcFilId') )  ){
				getAttachFileList5(dataSet.getNameValue(0, 'muagAttcFilId'));
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'dplAttcFilId') )  ){
				getAttachFileList6(dataSet.getNameValue(0, 'dplAttcFilId'));
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'nrmAttcFilId') )  ){
				getAttachFileList7(dataSet.getNameValue(0, 'nrmAttcFilId'));
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'muagScanAttcFilId') )  ){
				getAttachFileList8(dataSet.getNameValue(0, 'muagScanAttcFilId'), 'MS');
			}
			if( !Rui.isEmpty( dataSet.getNameValue(0, 'dplScanAttcFilId') )  ){
				getAttachFileList9(dataSet.getNameValue(0, 'dplScanAttcFilId'), 'DS');
			}
			
			crnCmmt.setValue(dataSet.getNameValue(0, 'crnCmmt'));
 		});
        
		//계약검토의견         
        crnCmmt = new Rui.ui.form.LTextArea({
            applyTo: 'crnCmmt',
            height: 100,
            width: 1000
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
        attachFileDataSet.on('load', function(e) {
            getAttachFileInfoList();
        });
        
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet1 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet1',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet1.on('load', function(e) {
            getAttachFileInfoList1();
        });
        
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet2 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet2',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet2.on('load', function(e) {
            getAttachFileInfoList2();
        });
        
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet3 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet3',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet3.on('load', function(e) {
            getAttachFileInfoList3();
        });
        
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet4 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet4',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet4.on('load', function(e) {
            getAttachFileInfoList4();
        });
        
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet5 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet5',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet5.on('load', function(e) {
            getAttachFileInfoList5();
        });
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet6 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet6',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet6.on('load', function(e) {
            getAttachFileInfoList6();
        });
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet7 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet7',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet7.on('load', function(e) {
            getAttachFileInfoList7();
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
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet9 = new Rui.data.LJsonDataSet({
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
        attachFileDataSet8.on('load', function(e) {
   		 getAttachFileInfoList8();
        });
        attachFileDataSet9.on('load', function(e) {
   		 getAttachFileInfoList9();
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
        getAttachFileList9 = function(id) {
            attachFileDataSet9.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                	attcFilId : id
                }
            });
        };
        
        getAttachFileInfoList = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }

            setAttachFileInfo(attachFileInfoList);
        };
        getAttachFileInfoList1 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet1.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet1.getAt(i).clone());
            }

            setAttachFileInfo1(attachFileInfoList);
        };
        getAttachFileInfoList2 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet2.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet2.getAt(i).clone());
            }

            setAttachFileInfo2(attachFileInfoList);
        };
        getAttachFileInfoList3 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet3.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet3.getAt(i).clone());
            }
            setAttachFileInfo3(attachFileInfoList);
        };
        getAttachFileInfoList4 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet4.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet4.getAt(i).clone());
            }
            setAttachFileInfo4(attachFileInfoList);
        };
        getAttachFileInfoList5 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet5.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet5.getAt(i).clone());
            }

            setAttachFileInfo5(attachFileInfoList);
        };
        getAttachFileInfoList6 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet6.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet6.getAt(i).clone());
            }

            setAttachFileInfo6(attachFileInfoList);
        };
        getAttachFileInfoList7 = function() {
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
        getAttachFileInfoList9 = function(gbn) {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet9.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet9.getAt(i).clone());
            }

          	 setAttachFileInfo9(attachFileInfoList);
        };
        
      	//등기사항전부증명서(을구사항 포함)
        setAttachFileInfo = function(attachFileList) {
        	var rgsPfdcAttcFilId;
        		
        	$('#rgsPfdcAttchFileView').html('');
        	
        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#rgsPfdcAttchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

               	rgsPfdcAttcFilId =  attachFileList[0].data.attcFilId;
               	
               	dataSet.setNameValue(0, "rgsPfdcAttcFilId", rgsPfdcAttcFilId);
            }
        }
        
        //중개대상물확인설명서
        setAttachFileInfo1 = function(attachFileList) {
        	var rlySubjAttcFilId;
        	$('#rlySubjAttchFileView').html('');

        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#rlySubjAttchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

            	rlySubjAttcFilId =  attachFileList[0].data.attcFilId;
               	
            	dataSet.setNameValue(0, "rlySubjAttcFilId", rlySubjAttcFilId);
            }
        }
        
        //집합건축물대장(전유무.갑)
        setAttachFileInfo2 = function(attachFileList) {
        	var asmyAchtAttcFilId;
        	$('#asmyAchtAttchFileView').html('');

        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#asmyAchtAttchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

            	asmyAchtAttcFilId =  attachFileList[0].data.attcFilId;
               	
            	dataSet.setNameValue(0, "asmyAchtAttcFilId", asmyAchtAttcFilId);
            }
        }
        
        //임대인 신분증 사본
        setAttachFileInfo3 = function(attachFileList) {
        	var lesrPfdcAttcFilId;
        	$('#lesrPfdcAttchFileView').html('');

        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#lesrPfdcAttchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

            	lesrPfdcAttcFilId =  attachFileList[0].data.attcFilId;
               	dataSet.setNameValue(0, "lesrPfdcAttcFilId", lesrPfdcAttcFilId);
            }
        };
        
        //전세계약서
        setAttachFileInfo4 = function(attachFileList) {
        	var lesrPfdcAttcFilId;
        	$('#lshCntdAttchFileView').html('');
        	
        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#lshCntdAttchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

            	lshCntdAttcFilId =  attachFileList[0].data.attcFilId;
               	dataSet.setNameValue(0, "lshCntdAttcFilId", lshCntdAttcFilId);
            }
        };
      //협의서
        setAttachFileInfo5 = function(attachFileList) {
        	var muagAttcFilId;
        	$('#muagAttchFileView').html('');

        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#muagAttchFileView').append($('<a/>', {
                    	href: 'javascript:muagDownloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }
            }
        };
        //협약서 사본
        setAttachFileInfo6 = function(attachFileList) {
        	var dplAttcFilId;
        	$('#dplAttchFileView').html('');

        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#dplAttchFileView').append($('<a/>', {
                    	href: 'javascript:dplDownloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }
            }
        };
        //규격
        setAttachFileInfo7 = function(attachFileList) {
        	var nrmAttcFilId;
        	$('#nrmAttchFileView').html('');

        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#nrmAttchFileView').append($('<a/>', {
                    	href: 'javascript:nrmDownloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }
            }
        };
        setAttachFileInfo8 = function(attachFileList) {
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
         setAttachFileInfo9 = function(attachFileList) {
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
        
        /*첨부파일 다운로드*/
        downloadAttachFile = function(attcFilId, seq) {
        	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
        	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
        	aform.submit();
        };
        
        var bind =  new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: dataSet,
	        bind: true,
	        bindInfo: [
	        	  { id : 'supDt'		,ctrlId:	'supDt'		,value: 'html'}  // 	--지원기간 시작일                  
	        	 ,{ id : 'supAmt'		,ctrlId:	'supAmt'		,value: 'html',
	               	 renderer: function(value, p, record){
		  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
		  		        }
		              }  //  	--회사지원금액                     
	        	 ,{ id : 'etcpDt'		,ctrlId:	'etcpDt'		,value: 'html'}  //--입사일                           
	        	 ,{ id : 'reNm'			,ctrlId:	'reNm'			,value: 'html'}  //--부동산명                   
	        	 ,{ id : 'reCcpcHpF'	,ctrlId:	'reCcpcHpF'		,value: 'html'}  //  --부동산 연락처              
	        	 ,{ id : 'reCcpcHpS'	,ctrlId:	'reCcpcHpS'		,value: 'html'}  //  --부동산 연락처              
	        	 ,{ id : 'reCcpcHpE'	,ctrlId:	'reCcpcHpE'		,value: 'html'}  //  --부동산 연락처              
	        	 ,{ id : 'leasAddr'		,ctrlId:	'leasAddr'		,value: 'html'}  //	--전세지역 주소              
	        	 ,{ id : 'lesrNm'		,ctrlId:	'lesrNm'		,value: 'html'}  // 	--임대인명              
	        	 ,{ id : 'lesrCcpcHpF'	,ctrlId:	'lesrCcpcHpF'	,value: 'html'}  // 	--임대인 휴대폰              
	        	 ,{ id : 'lesrCcpcHpS'	,ctrlId:	'lesrCcpcHpS'	,value: 'html'}  // 	--임대인 휴대폰              
	        	 ,{ id : 'lesrCcpcHpE'	,ctrlId:	'lesrCcpcHpE'	,value: 'html'}  // 	--임대인 휴대폰              
	        	 ,{ id : 'cnttStrDt'	,ctrlId:	'cnttStrDt'		,value: 'html'}  //	--계약기간 시작일            
	        	 ,{ id : 'cnttEndDt'	,ctrlId:	'cnttEndDt'		,value: 'html'}  //	--계약기간 종료일            
	        	 ,{ id : 'leasGrnAmt'	,ctrlId:	'leasGrnAmt'	,value: 'html',
	               	 renderer: function(value, p, record){
		  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
		  		        }
		              }  //  --임차보증금                 
	        	 ,{ id : 'pslfAmt'		,ctrlId:	'pslfAmt'		,value: 'html',
	               	 renderer: function(value, p, record){
		  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
		  		        }
		              }  //	--본인부담금                 
	        	 ,{ id : 'lviDt'		,ctrlId:	'lviDt'			,value: 'html'}  //    --입주일자                   
	        	 ,{ id : 'blnDt'		,ctrlId:	'blnDt'			,value: 'html'}  //    --잔금일자                   
	        	 ,{ id : 'etc'			,ctrlId:	'etc'			,value: 'html'}  //	--기타사항    
	        	 ,{ id : 'empNm'		,ctrlId:	'empNm'			,value: 'html'}  			//
	        	 ,{ id : 'deptNm'		,ctrlId:	'deptNm'		,value: 'html'}  //
	        	 ,{ id : 'rvwCmmt'		,ctrlId:	'rvwCmmt'		,value: 'html'}  //
	        ]
	    });

        //목록화면으로 이동
        fncLeasHousList = function(){
        	nwinsActSubmit(aform, "<c:url value='/knld/leasHous/retrieveLeasHousList.do'/>");
        }
      
        fnRvwAppr = function(gbn){
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

        	dataSet.setNameValue(0, 'pgsStCd', "CNR");
	       	dataSet.setNameValue(0, 'reqStCd', gbn);
	       	dataSet.setNameValue(0, 'crnCmmt', crnCmmt.getValue());
			
        	dm.updateDataSet({
                dataSets:[dataSet],
                url:'<c:url value="/knld/leasHous/updateLeasHousCnrSt.do"/>',
                params: {
                	leasId : dataSet.getNameValue(0, 'leasId')
                }
            });
        }
        
        muagDownloadAttachFile = function(attcFilId, seq) {
        	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
        	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
        	aform.submit();
        };
        dplDownloadAttachFile = function(attcFilId, seq) {
        	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
        	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
        	aform.submit();
        };
        nrmDownloadAttachFile = function(attcFilId, seq) {
        	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
        	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
        	aform.submit();
        };
         
      	
	});//onReady 끝

</script>


</head>
<body>
<form name="aform" id="aform" method="post">
	<input type="hidden" id="pageMode" name="pageMode" value="" />
<div class="contents">
	<div class="titleArea">
 		<a class="leftCon" href="#">
       	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
       	<span class="hidden">Toggle 버튼</span>
       	</a>
 		<h2>임차주택 계약서 검토</h2>
 	</div>
	<div class="sub-content">
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
   								<span id="cnttStrDt"></span>~<span id="cnttEndDt"></span>
   							</td>
   							<th align="right">입사일</th>
   							<td>
   								<span id="etcpDt"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">지원기간</th>
   							<td>
   								<span id="supDt"></span> 년
   							</td>
   							<th align="right">회사지원금</th>
   							<td>
   								<span id="supAmt"></span> 원
   							</td>
   						</tr>	
   						<tr>
   							<th align="right">임차보증금</th>
   							<td>
   								<span id="leasGrnAmt"></span> 원
   							</td>
   							<th align="right">본인부담금</th>
   							<td>
   								<span id="pslfAmt"></span> 원
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				<h4>- 부동산 정보</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   						<col style="width:15%;"/>
   						<col style="width:20%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">전세희망지역</th>
   							<td colspan="3">
   								<span id="leasAddr"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">공인중계사명</th>
   							<td>
   								<span id="reNm"></span>
   							</td>
   						    <th align="right">공인중계사 연락처</th>
    						<td>
   								<span id="reCcpcHpF"></span>-<span id="reCcpcHpS"></span>-<span id="reCcpcHpE"></span>
    						</td>
   						</tr>
   						<tr>
   							<th align="right">임대인명</th>
   							<td>
   								<span id="lesrNm"></span>
   							</td>
   							<th align="right">임대인 연락처</th>
   							<td>
   								<span id="lesrCcpcHpF"></span>-<span id="lesrCcpcHpS"></span>-<span id="lesrCcpcHpE"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">입주희망일자</th>
   							<td>
   								<span id="lviDt"></span>
   							</td>
   							<th align="right">잔금일자</th>
   							<td>
   								<span id="blnDt"></span>
   							</td>
   						</tr>
   						<tr>
   							<th>기타요청사항</th>
   							<td colspan="3">
   								<span id="etc"></span>
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
   								<span id="rolYn">설정</span>
   							</td>
   							<th align="right">법적인 risk 여부</th>
   							<td>
   								<span id="riskYn">없음</span>
   							</td>
   							<th align="right">채무관계 여부</th>
   							<td>
   								<span id="lbltYn">없음</span>
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
								<span id="leasMuagYn">동의</span>
							</td>
   							<th align="right">필수제출서류</th>
							<td  id="muagAttchFileView">&nbsp;</td>
   						</tr>
   						<tr>
   							<th align="right">임차주택확약서 동의여부</th>
   							<td>
   								<span id="dplYn">동의</span>
   							</td>
   							<th align="right">필수제출서류</th>
   							<td id="dplAttchFileView">&nbsp;</td>
   						</tr>
   						<tr>	
   							<th align="right">임차주택관리 규정</th>
   							<td>
   								<span id="nrmYn">동의</span>
   							</td>
   							<th align="right">확인서류</th>
   							<td id="nrmAttchFileView">&nbsp;</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				<h4>- 준비서류</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:8.1%;"/>
   						<col style="width:30%;"/>
   						<col style="width:15%;"/>
   						<col style="width:30%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
		         			<th>등기사항전부증명서</br>(을구사항 포함)</th>
		         			<td colspan="3" id="rgsPfdcAttchFileView">&nbsp;</td>
		         		</tr>
   						<tr>
		         			<th>중개대상물확인설명서</th>
		         			<td colspan="3" id="rlySubjAttchFileView">&nbsp;</td>
		         		</tr>
   						<tr>
		         			<th>집합건축물대장(전유무.갑)</th>
		         			<td colspan="3" id="asmyAchtAttchFileView">&nbsp;</td>
		         		</tr>
   						<tr>
		         			<th>임대인 신분증 사본 </th>
		         			<td colspan="3" id="lesrPfdcAttchFileView">&nbsp;</td>
		         		</tr>
		         		<tr>
		         			<th>임차주택관리합의서 서명(스캔본)</th>
		         			<td colspan="3" id="muagScanAttchFileView">&nbsp;</td>
		         		</tr>
   						<tr>
		         			<th>임차주택확약서 서명(스캔본)</th>
		         			<td colspan="3" id="dplScanAttchFileView">&nbsp;</td>
		         		</tr>
   					</tbody>
   				</table>
   				<br/>
   				<h4>- 사전계약 담당자 검토란</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:8.1%;"/>
   						<col style="width:30%;"/>
   						<col style="width:15%;"/>
   						<col style="width:30%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
		         			<th>사전검토 의견</th>
		         			<td colspan="3">
		         				<span id="rvwCmmt"></span>
		         			</td>
		         		</tr>
   					</tbody>
   				</table>
   				<br/>
		        <h4>- 전세계약서정보</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:8.1%;"/>
   						<col style="width:30%;"/>
   						<col style="width:15%;"/>
   						<col style="width:30%;"/>
   					</colgroup>
   					<tbody>  		
   						<tr>
		         			<th>전세계약서 </th>
		         			<td colspan="3" id="lshCntdAttchFileView"></td>
		         		</tr>
   					</tbody>
   				</table>
   				<br/>
   				<h4>- 계약검토 의견란</h4>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:8.1%;"/>
   						<col style="width:30%;"/>
   						<col style="width:15%;"/>
   						<col style="width:30%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
		         			<th>계약검토 의견</th>
		         			<td>
		         				<span colspan="3" id="crnCmmt"></span>
		         			</td>
		         		</tr>
   					</tbody>
   				</table>
   				<div class="titArea">
			    <div class="LblockButton">
			        <button type="button" id="btnSave" onclick="fnRvwAppr('APPR')">승인</button>
			        <button type="button" id="btnReq" onclick="fnRvwAppr('REJ')">반려</button>
			        <button type="button" id="butList"  onclick="fncLeasHousList()" >목록</button>
			    </div>
			</div>
 			</div><!-- //sub-content -->
 		</div><!-- //contents -->
		</form>
    </body>
</html>