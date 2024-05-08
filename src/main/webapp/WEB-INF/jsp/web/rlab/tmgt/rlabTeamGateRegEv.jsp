<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: rlabTemaGateRegEv.jsp
 * @desc    : Technical Service >  신뢰성시험 > Team Gate 평가(등록자화면)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.06        		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LFileBox.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LFileUploadDialog.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LFileBox.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFileUploadDialog.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.css"/>

<%-- rui Validator --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/validate/LCustomValidator.js"></script>

<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
%>


<script type="text/javascript">

var firstLoad = "Y";	//화면오픈


	Rui.onReady(function(){

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
	        fields: [
            		  { id: 'teamGateId'}
            		 ,{ id: 'teamGateDtlId'}
            		 ,{ id: 'titl'}
		           	 ,{ id: 'sbc'}
		           	 ,{ id: 'attcFilId'}
		           	 ,{ id: 'frstRgstDt'}
		           	 ,{ id: 'frstRgstId'}
		           	 ,{ id: 'frstRgstNm'}
		           	 ,{ id: 'evCnt'}
		           	 ,{ id: 'ev1'}
		           	 ,{ id: 'ev2'}
		           	 ,{ id: 'ev3'}
		           	 ,{ id: 'ev4'}
		           	 ,{ id: 'ev5'}
		           	 ,{ id: 'ev6'}
		           	 ,{ id: 'ev7'}
		           	 ,{ id: 'ev8'}
		           	 ,{ id: 'ev9'}
		           	 ,{ id: 'ev10'}
		            ]
	    });

	    dataSet.on('load', function(e){
			document.aform.teamGateId.value = dataSet.getNameValue(0, "teamGateId");

			if(dataSet.getNameValue(0, "teamGateId")  != "" ||  dataSet.getNameValue(0, "teamGateId")  !=  undefined ){
				CrossEditor.SetBodyValue( dataSet.getNameValue(0, "sbc") );
			}
			firstLoad = "N";
	    });

	    //제목
		var titl = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'titl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 800,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	        //inputType: Rui.util.LString.PATTERN_TYPE_KOREAN, // [옵션] 입력문자열로 영문자 입력만 허용
	    });

		//평가1
		var ev1 = new Rui.ui.form.LCombo({
			applyTo : 'ev1',
			name : 'ev1',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가2
		var ev2 = new Rui.ui.form.LCombo({
			applyTo : 'ev2',
			name : 'ev2',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가3
		var ev3 = new Rui.ui.form.LCombo({
			applyTo : 'ev3',
			name : 'ev3',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가4
		var ev4 = new Rui.ui.form.LCombo({
			applyTo : 'ev4',
			name : 'ev4',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가5
		var ev5 = new Rui.ui.form.LCombo({
			applyTo : 'ev5',
			name : 'ev5',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가6
		var ev6 = new Rui.ui.form.LCombo({
			applyTo : 'ev6',
			name : 'ev6',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가7
		var ev7 = new Rui.ui.form.LCombo({
			applyTo : 'ev7',
			name : 'ev7',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가8
		var ev8 = new Rui.ui.form.LCombo({
			applyTo : 'ev8',
			name : 'ev8',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가9
		var ev9 = new Rui.ui.form.LCombo({
			applyTo : 'ev9',
			name : 'ev9',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		//평가10
		var ev10 = new Rui.ui.form.LCombo({
			applyTo : 'ev10',
			name : 'ev10',
			defaultValue: '0',
			width : 200,
				items: [
	                   { code: '0', value: '0' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: '1', value: '1' },  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                   { code: '2', value: '2' },
	                   { code: '3', value: '3' },
	                   { code: '4', value: '4' },
	                   { code: '5', value: '5' },
	                   { code: '6', value: '6' },
	                   { code: '7', value: '7' },
	                   { code: '8', value: '8' },
	                   { code: '9', value: '9' },
	                   { code: '10', value: '10' }
	                	]

		});

		var teamGateId = document.aform.teamGateId.value;
		if( teamGateId != ""){
		    fnSearch = function() {
		    	dataSet.load({
		        url: '<c:url value="/rlab/tmgt/rlabTeamGateDtl.do"/>' ,
	           	params :{
	           		teamGateId : teamGateId
		                }
	            });
	        }
	       	fnSearch();
		}

		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		         { id: 'titl', 		ctrlId: 'titl', 		value: 'value' },
		         { id: 'sbc', 			ctrlId: 'sbc', 		value: 'value' },
		         { id: 'ev1', 		ctrlId: 'ev1', 		value: 'value' },
		         { id: 'ev2', 		ctrlId: 'ev2', 		value: 'value' },
		         { id: 'ev3', 		ctrlId: 'ev3', 		value: 'value' },
		         { id: 'ev4', 		ctrlId: 'ev4', 		value: 'value' },
		         { id: 'ev5', 		ctrlId: 'ev5', 		value: 'value' },
		         { id: 'ev6', 		ctrlId: 'ev6', 		value: 'value' },
		         { id: 'ev7', 		ctrlId: 'ev7', 		value: 'value' },
		         { id: 'ev8', 		ctrlId: 'ev8', 		value: 'value' },
		         { id: 'ev9', 		ctrlId: 'ev9', 		value: 'value' },
		         { id: 'ev10', 		ctrlId: 'ev10', 		value: 'value' },
		         { id: 'attcFilId', 		ctrlId: 'attcFilId', 		value: 'value' },
		         { id: 'teamGateId', 		ctrlId: 'teamGateId', 		value: 'value' },
		         { id: 'teamGateDtlId', 		ctrlId: 'teamGateDtlId', 		value: 'value' },
		         { id: 'frstRgstDt', 		ctrlId: 'frstRgstDt', 		value: 'html' },
	           	 { id: 'frstRgstId',		ctrlId: 'frstRgstId', 		value: 'value' },
	           	 { id: 'frstRgstNm', 		ctrlId: 'frstRgstNm', 		value: 'html' },
	           	 { id: 'evCnt', 		ctrlId: 'evCnt', 		value: 'html' }
		     ]
		});

/*************************첨부파일****************************/
		/* 첨부파일*/
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

		var attId;

		//dataset에서 첨부파일 정보가 있을경우
		dataSet.on('load', function(e) {
			attId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(attId)) getAttachFileList();
        });

		//첨부파일 정보 조회
   		getAttachFileList = function(){
			attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                    attcFilId : attId
                }
            });
		}

		//첨부파일 조회후 load로 정보 호출
		attachFileDataSet.on('load', function(e) {
            getAttachFileInfoList();
        });

		//첨부파일 정보
		getAttachFileInfoList = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }
            setAttachFileInfo(attachFileInfoList);
        };



//************** button *************************************************************************************************/
		/* [버튼] : team gate 목록 이동 */
    	var butList = new Rui.ui.LButton('butList');

    	butList.on('click', function(){
    		fncRlabTeamGateList();
    	});

    	/* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFil = new Rui.ui.LButton('butAttcFil');
    	butAttcFil.on('click', function(){
    		var attcFilId = document.aform.attcFilId.value;
    		openAttachFileDialog3(setAttachFileInfo, attcFilId,'rlabPolicy', '*');
    	});

    	/* [버튼] : 투표종료 */
    	var butCmpl = new Rui.ui.LButton('butCmpl');
    	butCmpl.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
   			var frm = document.aform;
   			frm.sbc.value = CrossEditor.GetBodyValue();
    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				fncRlabTeamGateList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

   			if(confirm("투표종료 하시겠습니까?")) {
   				dm.updateForm({
   					url: "<c:url value='/rlab/tmgt/saveRlabTeamGateEvCmpl.do'/>",
   	        	    form: 'aform'
   	        	});
    	    }
   	 	});

    	/* [버튼] : 투표수정 */
    	var butRegSave = new Rui.ui.LButton('butRegSave');
    	butRegSave.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
   			var frm = document.aform;
   			frm.sbc.value = CrossEditor.GetBodyValue();
    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				fncRlabTeamGateList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

   			if(confirm("저장 하시겠습니까?")) {
   				dm.updateForm({
   					url: "<c:url value='/rlab/tmgt/saveRlabTeamGateEvReg.do'/>",
   	        	    form: 'aform'
   	        	});
    	    }
   	 	});

    	/* [버튼] : 투표삭제 */
    	var butRegDel = new Rui.ui.LButton('butRegDel');
    	butRegDel.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				fncRlabTeamGateList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

   			if(confirm("삭제 하시겠습니까?")) {
   				dm.updateForm({
   					url: "<c:url value='/rlab/tmgt/delRlabTeamGateEvReg.do'/>",
   	        	    form: 'aform'
   	        	});
    	    }
   	 	});

    	/* [버튼] : 임시 저장 */
    	var butSave = new Rui.ui.LButton('butSave');
   		butSave.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				fncRlabTeamGateList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

   			if(confirm("저장 하시겠습니까?")) {
   				dm.updateForm({
   					url: "<c:url value='/rlab/tmgt/saveTempRlabTeamGateEv.do'/>",
   	        	    form: 'aform'
   	        	});
    	    }
   	 	});

   		/* [버튼] : 투표 저장 */
    	var butEvSave = new Rui.ui.LButton('butEvSave');
    	butEvSave.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				fncRlabTeamGateList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    		if(fncVaild()) {
    			if(confirm("투표 하시겠습니까?")) {
    				dm.updateForm({
    					url: "<c:url value='/rlab/tmgt/saveRlabTeamGateEv.do'/>",
    	        	    form: 'aform'
    	        	});
            	    //alert($('#evCtgrVal').val());
    				//alert($('#evWayVal').val());
   					//evCtgr.getItem(0).setValue(true);
   					//evCtgr.getItem(1).setValue(true);
   					//evCtgr.getItem(2).setValue(true);
	    	    }
    		}
   	 	});

   		//첨부파일 callback
		setAttachFileInfo = function(attcFilList) {

           if(attcFilList.length > 1 ){
        	   alert("첨부파일은 한개만 가능합니다.");
        	   return;
           }else{
	           $('#atthcFilVw').html('');
           }

           for(var i = 0; i < attcFilList.length; i++) {
               $('#atthcFilVw').append($('<a/>', {
                   href: 'javascript:downloadAttcFil("' + attcFilList[i].data.attcFilId + '", "' + attcFilList[i].data.seq + '")',
                   text: attcFilList[i].data.filNm
               })).append('<br/>');
           document.aform.attcFilId.value = attcFilList[i].data.attcFilId;
           }
       	};

       //첨부파일 다운로드
       downloadAttcFil = function(attId, seq){
    	   var param = "?attcFilId=" + attId + "&seq=" + seq;
	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
	       	document.aform.submit();
       }

     //team gate 목록 화면으로 이동
       var fncRlabTeamGateList = function(){
    	   	$('#searchForm > input[name=titl]').val(encodeURIComponent($('#searchForm > input[name=titl]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/rlab/tmgt/rlabTeamGate.do"/>");
       }

     //vaild check

     var fncVaild = function(){
     		var frm = document.aform;
    		//평가의견    vailid
    		if( Rui.isEmpty(ev1.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev1.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev2.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev2.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev3.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev3.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev4.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev4.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev5.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev5.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev6.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev6.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev7.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev7.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev8.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev8.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev9.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev9.focus();
    			return false;
    		}
    		if( Rui.isEmpty(ev10.getValue())){
    			Rui.alert("평가의견은 필수항목입니다");
    			ev10.focus();
    			return false;
    		}

    		return true;
     	}
	});

       //end ready

</script>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
	        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	        	<span class="hidden">Toggle 버튼</span>
        	</a>
			<h2>TEAM GATE</h2>
		</div>
		<div class="sub-content">
			<form name="searchForm" id="searchForm">
				<input type="hidden" name="titl" value="${inputData.titl}"/>
				<input type="hidden" name="cmplYn" value="${inputData.cmplYn}"/>
		    </form>

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" />

				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="frstRgstId" name="frstRgstId" />

				<input type="hidden" id="teamGateId" name="teamGateId" value="<c:out value='${inputData.teamGateId}'/>">
				<div class="LblockButton top mt10">
					<button type="button" id="butCmpl">투표종료</button>
					<button type="button" id="butRegSave">저장</button>
					<button type="button" id="butRegDel">삭제</button>
					<button type="button" id="butList">목록</button>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 20%" />
						<col style="width: 15%" />
						<col style="width: 20%" />
						<col style="" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>제목</th>
							<td>
								<input type="text" id="titl" />
							</td>
							<th align="right">참여인원</th>
							<td colspan="2">
								<span id="evCnt"/>
							</td>
						</tr>
						<tr>
							<th align="right">제안자</th>
							<td>
								<span id="frstRgstNm"/>
							</td>
							<th align="right">등록일</th>
							<td colspan="2">
								<span id="frstRgstDt"/>
							</td>
						</tr>
						<tr>
							<th  align="right">개요</th>
							<td colspan="4">
								<textarea id="sbc" name="sbc"></textarea>
									<script type="text/javascript" language="javascript">
									var CrossEditor = new NamoSE('sbc');
									CrossEditor.params.Width = "100%";
									CrossEditor.params.UserLang = "auto";
									CrossEditor.params.Font = fontParam;
									var uploadPath = "<%=uploadPath%>";

									CrossEditor.params.ImageSavePath = uploadPath+"/rlab";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
									CrossEditor.params.FullScreen = false;
									CrossEditor.EditorStart();

									function OnInitCompleted(e){
										e.editorTarget.SetBodyValue(document.getElementById("sbc").value);
									}
									</script>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
							<td colspan="2" id="atthcFilVw"></td>
							<td>
								<button type="button" id="butAttcFil">첨부파일등록</button>
							</td>
						</tr>
						</tbody>
						</table>
				<div class="LblockButton top mt10">
					<button type="button" id="butSave">임시저장</button>
					<button type="button" id="butEvSave">투표완료</button>

				</div>

<table class="table table_txt_right">
					<colgroup>
						<col style="width: 20%" />
						<col style="width: 25%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="" />
					</colgroup>
					<tbody>						<tr>
							<th>평가구분</th>
							<th>평가지표</th>
							<th>영역점수</th>
							<th>개별점수</th>
							<th>평가의견</th>
						</tr>
						<tr>
							<td rowspan="3">고객가치지표</td>
							<td>고객 삶에 대한 혁신성</td>
							<td rowspan="3">30점</td>
							<td>10점</td>
							<td>
								<div id="ev1"></div>
							</td>
						</tr>
						<tr>
							<td>유사/경쟁 상품 비교우위</td>
							<td>10점</td>
							<td>
								<div id="ev2"></div>
							</td>
						</tr>
						<tr>
							<td>본질적 또는 차별화 가치</td>
							<td>10점</td>
							<td>
								<div id="ev3"></div>
							</td>
						</tr>
						<tr>
							<td rowspan="3">기술지표</td>
							<td>구현 기술 독창성</td>
							<td rowspan="3">30점</td>
							<td>10점</td>
							<td>
								<div id="ev4"></div>
							</td>
						</tr>
						<tr>
							<td>구현 기술의 경제성</td>
							<td>10점</td>
							<td>
								<div id="ev5"></div>
							</td>
						</tr>
						<tr>
							<td>내부 R&D 가능여부</td>
							<td>10점</td>
							<td>
								<div id="ev6"></div>
							</td>
						</tr>
						<tr>
							<td rowspan="3">사업지표</td>
							<td>예상 시장 규모</td>
							<td rowspan="3">30점</td>
							<td>10점</td>
							<td>
								<div id="ev7"></div>
							</td>
						</tr>
						<tr>
							<td>사업 Impact</td>
							<td>10점</td>
							<td>
								<div id="ev8"></div>
							</td>
						</tr>
						<tr>
							<td>시장 파급도</td>
							<td>10점</td>
							<td>
								<div id="ev9"></div>
							</td>
						</tr>
						<tr>
							<td>전략지표</td>
							<td>당사 전략 적합성</td>
							<td>10점</td>
							<td>10점</td>
							<td>
								<div id="ev10"></div>
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
