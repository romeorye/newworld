<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: rlabTestEqipReg.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 등록 및 수정 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.07     			최초생성
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
<script type="text/javascript" src="/rui/plugins/ui/form/LComboLoader.js"></script>

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

var faxInfoDialog;	//고정자산관리 팝업

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
            		  { id: 'mchnHanNm'}
		           	 ,{ id: 'mchnEnNm'}
		           	 ,{ id: 'mkrNm'}
		           	 ,{ id: 'mdlNm'}
		           	 ,{ id: 'mchnClCd'}
		           	 ,{ id: 'mchnClDtlCd'}
		           	 ,{ id: 'mchnLaclCd'}
		           	 ,{ id: 'opnYn'}
		           	 ,{ id: 'delYn'}
		           	 ,{ id: 'fxaNo'}
		           	 ,{ id: 'fxaNm'}
		           	 ,{ id: 'mchnCrgrNm'}
		           	 ,{ id: 'mchnLoc'}
		           	 ,{ id: 'mchnExpl'}
		           	 ,{ id: 'attcFilId'}
		           	 ,{ id: 'mchnSmry'}
		           	 ,{ id: 'mchnCrgrId'}
		           	 ,{ id: 'mchnUsePsblYn'}
		           	 ,{ id: 'mnScrnDspYn'}
		           	 ,{ id: 'mchnInfoId'}
		           	 ,{ id: 'smpoQty'}
		            ]
	    });
		//대분류/소분류 dataset
	    mchnClDtlCdDataSet = new Rui.data.LJsonDataSet({
            id: 'mchnClDtlCdDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'COM_DTL_CD' }
            	, { id: 'COM_DTL_NM' }
            ]
        });

	    dataSet.on('load', function(e){
			document.aform.mchnCrgrId.value = dataSet.getNameValue(0, "mchnCrgrId");
			cbOpnYn.setValue(dataSet.getNameValue(0,"opnYn"));

			if(dataSet.getNameValue(0, "mchnInfoId")  != "" ||  dataSet.getNameValue(0, "mchnInfoId")  !=  undefined ){
				CrossEditor.SetBodyValue( dataSet.getNameValue(0, "mchnSmry") );
			}

			if(!Rui.isEmpty(dataSet.getNameValue(0, "fxaNo"))){
				document.aform.fxaNo.value = dataSet.getNameValue(0, "fxaNo");
			}

			mchnClDtlCdDataSet.load({
				url: '<c:url value="/stat/rlab/retrieveRlabMchnClDtlCd.do"/>'
	                ,params :{
	                	exatCd : dataSet.getNameValue(0, "mchnLaclCd")
	                }
            });
	    });

	    //기기명 한글
		var mchnHanNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnHanNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	        //inputType: Rui.util.LString.PATTERN_TYPE_KOREAN, // [옵션] 입력문자열로 영문자 입력만 허용
	    });

		//기기명 영문
		var mchnEnNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnEnNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
           // inputType: Rui.util.LString.PATTERN_TYPE_STRING, // [옵션] 입력문자열로 영문자 입력만 허용
	    });

		//제조사
		var mkrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mkrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false,                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//모델명
		var mdlNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mdlNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false,                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//소분류
		 var cbmchnClDtlCd = new Rui.ui.form.LCombo({
		 	applyTo : 'mchnClDtlCd',
			name : 'mchnClDtlCd',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    dataSet: mchnClDtlCdDataSet,
			displayField: 'COM_DTL_NM',
			width: 180,
			valueField: 'COM_DTL_CD'
		});

		//대분류
		var cbmchnLaclCd = new Rui.ui.form.LCombo({
		 	applyTo : 'mchnLaclCd',
			name : 'mchnLaclCd',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    url: '<c:url value="/stat/rlab/retrieveRlabMchnClCd.do"/>',
			displayField: 'COM_DTL_NM',
			valueField: 'COM_DTL_CD',
			width: 180
		});

		cbmchnLaclCd.on('changed', function(e){
			mchnClDtlCdDataSet.clearData();
			mchnClDtlCdDataSet.load({
				url: '<c:url value="/stat/rlab/retrieveRlabMchnClDtlCd.do"/>'
	                ,params :{
	                	exatCd : e.value
	                }
            });
		});

		//장비종류
		var cbmchnClCd = new Rui.ui.form.LCombo({
		 	applyTo : 'mchnClCd',
			name : 'mchnClCd',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=RLAB_CL_CD"/>',
			displayField: 'COM_DTL_NM',
			valueField: 'COM_DTL_CD'
		});

		//기기사용쳐부combo
		var cbMchnUsePsblYn = new Rui.ui.form.LCombo({
		 	applyTo : 'mchnUsePsblYn',
			name : 'mchnUsePsblYn',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MCHN_PRCT_ST"/>',
			displayField: 'COM_DTL_NM',
			valueField: 'COM_DTL_CD'
		});

		cbmchnClCd.getDataSet().on('load', function(e) {
		   console.log('cbmchnClCd :: load');
		});

		//open 기기
		var cbOpnYn = new Rui.ui.form.LCombo({
			applyTo : 'opnYn',
			name : 'opnYn',
			emptyText: '선택하세요',
				items: [
	                   { code: 'Y', value: 'Y' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: 'N', value: 'N' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                	]
		});

		//삭제여부
		var cbDelYn = new Rui.ui.form.LCombo({
			applyTo : 'delYn',
			name : 'delYn',
			emptyText: '선택하세요',
				items: [
					   { value: 'N', text: '미삭제'},
				       { value: 'Y', text: '삭제'}
	            ]
		});

        //시료수
		var smpoQty = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'smpoQty',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	        //inputType: Rui.util.LString.PATTERN_TYPE_KOREAN, // [옵션] 입력문자열로 영문자 입력만 허용
	    });

		//메인여부
		var cbMnScrnDspYn = new Rui.ui.form.LCombo({
			applyTo : 'mnScrnDspYn',
			name : 'mnScrnDspYn',
			emptyText: '선택하세요',
				items: [
					   { value: 'N', text: 'N'},
				       { value: 'Y', text: 'Y'}
	            ]
		});


	  	//고정자산명
		var fxaNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'hFxaNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        disabled: true,
	        invalidBlur: false,                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//고정자산번호
		var fxaNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'hFxaNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        disabled: true,
	        invalidBlur: false,                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	    /* 담당자 팝업 */
	    var mchnCrgrNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'mchnCrgrNm',
            width: 200,
            editable: true,
            placeholder: '',
            enterToPopup: true
        });

	    mchnCrgrNm.on('popup', function(e){
	    	openUserSearchDialog(setUserInfo, 1, '');
       	});

	    setUserInfo = function (user){
	    	mchnCrgrNm.setValue(user.saName);
	    	document.aform.mchnCrgrId.value = user.saSabun;
	    };

	    //위치
		var mchnLoc = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnLoc',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false,                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//요약설명 textarea
	    var mchnExpl = new Rui.ui.form.LTextArea({
            applyTo: 'mchnExpl',
            placeholder: '요약설명입니다. 내용을 입력해주세요.',
            width: 1000,
            height: 100
        });

		var mchnInfoId = document.aform.mchnInfoId.value;
		if( mchnInfoId != ""){
		    fnSearch = function() {
		    	dataSet.load({
		        url: '<c:url value="/mchn/mgmt/rlabTestEqipSearchDtl.do"/>' ,
	           	params :{
	           	        mchnInfoId : mchnInfoId
		                }
	            });
	        }
	       	fnSearch();
		}

	    /* [ 고정자산 Dialog] */
		faxInfoDialog = new Rui.ui.LFrameDialog({
	        id: 'faxInfoDialog',
	        title: '자산관리',
	        width:  980,
	        height: 550,
	        modal: true,
	        visible: false,
	        buttons : [
	            { text:'닫기', handler: function() {
	              	this.cancel(false);
	              }
	            }
	        ]
	    });

		faxInfoDialog.render(document.body);

		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		         { id: 'mchnHanNm', 		ctrlId: 'mchnHanNm', 		value: 'value' },
		         { id: 'mchnEnNm', 			ctrlId: 'mchnEnNm', 		value: 'value' },
		         { id: 'mkrNm', 			ctrlId: 'mkrNm', 			value: 'value' },
		         { id: 'mdlNm', 			ctrlId: 'mdlNm', 			value: 'value' },
		         { id: 'mchnClCd', 			ctrlId: 'mchnClCd', 		value: 'value' },
		         { id: 'mchnClDtlCd', 		ctrlId: 'mchnClDtlCd', 		value: 'value' },
		         { id: 'mchnLaclCd', 		ctrlId: 'mchnLaclCd', 		value: 'value' },
		         { id: 'opnYn', 			ctrlId: 'opnYn', 		    value: 'value' },
		         { id: 'delYn', 			ctrlId: 'delYn', 			value: 'value' },
		         { id: 'fxaNo', 			ctrlId: 'hFxaNo', 			value: 'value' },
		         { id: 'fxaNm', 			ctrlId: 'hFxaNm', 			value: 'value' },
		         { id: 'mchnCrgrNm', 		ctrlId: 'mchnCrgrNm', 		value: 'value' },
		         { id: 'mchnCrgrId', 		ctrlId: 'mchnCrgrId', 		value: 'value' },
		         { id: 'mchnLoc', 			ctrlId: 'mchnLoc', 			value: 'value' },
		         { id: 'mchnExpl', 			ctrlId: 'mchnExpl', 		value: 'value' },
		         { id: 'mchnSmry', 			ctrlId: 'mchnSmry', 		value: 'value' },
		         { id: 'mchnUsePsblYn', 	ctrlId: 'mchnUsePsblYn', 	value: 'value' },
		         { id: 'mnScrnDspYn', 		ctrlId: 'mnScrnDspYn', 		value: 'value' },
		         { id: 'attcFilId', 		ctrlId: 'attcFilId', 		value: 'value' },
		         { id: 'mchnInfoId', 		ctrlId: 'mchnInfoId', 		value: 'value' },
		         { id: 'smpoQty', 			ctrlId: 'smpoQty', 			value: 'value' }
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
	    /* [버튼] : 고정자산 팝업 호출 */
    	var butFxa = new Rui.ui.LButton('butFxa');

		butFxa.on('click', function(){
    		faxInfoDialog.setUrl('<c:url value="/mchn/mgmt/retrieveFxaInfoPop.do"/>');
    		faxInfoDialog.show(true);
    	});

		/* [버튼] : 분석기기 목록 이동 */
    	var butList = new Rui.ui.LButton('butList');

    	butList.on('click', function(){
    		rlabTestEqipSearchList();
    	});

		/* [버튼] : 고정자산 초기화 목록 이동 */
    	var butFxaInit = new Rui.ui.LButton('butFxaInit');

    	butFxaInit.on('click', function(){
    		document.aform.fxaNo.value = ""	;
    		document.aform.fxaNm.value = ""	;
    		document.aform.hFxaNm.value = ""	;
    		document.aform.hFxaNo.value = ""	;
    	});

    	/* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFil = new Rui.ui.LButton('butAttcFil');
    	butAttcFil.on('click', function(){
    		var attcFilId = document.aform.attcFilId.value;
    		openAttachFileDialog3(setAttachFileInfo, attcFilId,'mchnPolicy', '*');
    	});

    	/* [버튼] : 등록 정보 저장 */
    	var butSave = new Rui.ui.LButton('butSave');
   		butSave.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				rlabTestEqipSearchList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    		if(fncVaild()) {
    			if(confirm("저장 하시겠습니까?")) {
	            	    dm.updateForm({
	    	        	    url: "<c:url value='/mchn/mgmt/saveRlabTestEqip.do'/>",
	    	        	    form: 'aform'
	    	        	});
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
	       /* 	var param = "?attcFilId=" + attId + "&seq=" + seq;
	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
	       	document.aform.submit(); */
    	    var param = "?attcFilId="+ attId+"&seq="+seq;
			Rui.getDom('dialogImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
			Rui.get('imgDialTitle').html('기기이미지');
			imageDialog.clearInvalid();
			imageDialog.show(true);

       }

       /* [ 이미지 Dialog] */
    	var imageDialog = new Rui.ui.LDialog({
            applyTo: 'imageDialog',
            width: 400,
            height: 400,
            visible: false,
            postmethod: 'none',
            buttons: [
                { text:'닫기', isDefault: true, handler: function() {
                    this.cancel(false);
                } }
            ]
        });
    	imageDialog.hide(true);

     //분석기기 목록 화면으로 이동
       var rlabTestEqipSearchList = function(){
    	   	$('#searchForm > input[name=mchnNm]').val(encodeURIComponent($('#searchForm > input[name=mchnNm]').val()));
    	   	$('#searchForm > input[name=mchnCrgrNm]').val(encodeURIComponent($('#searchForm > input[name=mchnCrgrNm]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/mchn/mgmt/rlabTestEqipList.do"/>");
       }

      //vaild check
     var fncVaild = function(){
     		var frm = document.aform;
     		var regex= /[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g;


    		//기기명    vailid
     		if( Rui.isEmpty(mchnHanNm.getValue())){
    			Rui.alert("장비명(국문)은 필수항목입니다");
    			mchnHanNm.focus();
    			return false;
    		}
    		if( Rui.isEmpty(mchnEnNm.getValue())){
    			Rui.alert("장비명(영문)은 필수항목입니다");
    			mchnEnNm.focus();
    			return false;
    		}
    		if( Rui.isEmpty(mkrNm.getValue())){
    			Rui.alert("제조사는 필수항목입니다.");
    			mkrNm.focus();
    			return false;
    		}
    		if( Rui.isEmpty(mdlNm.getValue())){
    			Rui.alert("모델명 필수항목입니다.");
    			mdlNm.focus();
    			return false;
    		}
    		if( Rui.isEmpty(cbmchnLaclCd.getValue())){
    			Rui.alert("대분류는 필수항목입니다.");
    			cbmchnLaclCd.focus();
    			return false;
    		}
    		if( Rui.isEmpty(cbmchnClDtlCd.getValue())){
    			Rui.alert("소분류는 필수항목입니다.");
    			cbmchnClDtlCd.focus();
    			return false;
    		}
    		if( Rui.isEmpty(cbmchnClCd.getValue())){
    			Rui.alert("장비종류는 필수항목입니다.");
    			cbmchnClCd.focus();
    			return false;
    		}
    		if( Rui.isEmpty(cbOpnYn.getValue())){
    			Rui.alert("OPEN 장비는 필수항목입니다.");
    			cbOpnYn.focus();
    			return false;
    		}
    		if( Rui.isEmpty(cbDelYn.getValue())){
    			Rui.alert("삭제여부는 필수항목입니다.");
    			cbDelYn.focus();
    			return false;
    		}
    		if( Rui.isEmpty(smpoQty.getValue())){
    			Rui.alert("시료수는 필수항목입니다.");
    			smpoQty.focus();
    			return false;
    		}
    		if( Rui.isEmpty(mchnExpl.getValue())){
    			Rui.alert("요약설명은 필수항목입니다.");
    			mchnExpl.focus();
    			return false;
    		}
    		if( Rui.isEmpty(document.aform.attcFilId.value)){
    			Rui.alert("첨부파일은 필수항목입니다.");
    			return false;
    		}
     		if(CrossEditor.GetBodyValue()=="" || CrossEditor.GetBodyValue()=="<p><br></p>"){
     		    alert("개요내용을 입력해 주세요!!");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}

    		frm.mchnSmry.value = CrossEditor.GetBodyValue();

    		return true;
     	}

	});
	//end ready

	 //고정자산 callback
 	function fncRecall(re){
 		document.aform.fxaNo.value = re.get("fxaNo");
		document.aform.fxaNm.value = re.get("fxaNm");
 		document.aform.hFxaNo.value = re.get("fxaNo");
		document.aform.hFxaNm.value = re.get("fxaNm");
 	}


</script>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>
			<h2>신뢰성시험 장비 관리</h2>
		</div>
		<div class="sub-content">
			<form name="searchForm" id="searchForm">
				<input type="hidden" name="mchnNm" value="${inputData.mchnNm}"/>
				<input type="hidden" name="mchnClCd" value="${inputData.mchnClCd}"/>
				<input type="hidden" name="mchnClDtlCd" value="${inputData.mchnClDtlCd}"/>
				<input type="hidden" name="mchnLaclCd" value="${inputData.mchnLaclCd}"/>
				<input type="hidden" name="fxaNo" value="${inputData.fxaNo}"/>
				<input type="hidden" name="opnYn" value="${inputData.opnYn}"/>
				<input type="hidden" name="mchnCrgrNm" value="${inputData.mchnCrgrNm}"/>
				<input type="hidden" name="mchnUsePsblYn" value="${inputData.mchnUsePsblYn}"/>
				<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
		    </form>

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" />
				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="mchnCrgrId" name="mchnCrgrId" />
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" value="<c:out value='${inputData.mchnInfoId}'/>">

				<input type="hidden" id="fxaNo" name="fxaNo" />
				<input type="hidden" id="fxaNm" name="fxaNm" />

				<div class="LblockButton top mt10">
					<button type="button" id="butSave">저장</button>
					<button type="button" id="butList">목록</button>
				</div>
				<table class="table table_txt_right ta_fix">
					<colgroup>
						<col style="width: 13%" />
						<col style="width: 40%" />
						<col style="width: 12%" />
						<col style="" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>장비명(국문)</th>
							<td>
								<input type="text" id="mchnHanNm" style="ime-mode:active"/>
							</td>
							<th align="right"><span style="color:red;">*  </span>장비명(영문)</th>
							<td>
								<input type="text" id="mchnEnNm" style="ime-mode:disabled"/>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>제조사</th>
							<td>
								<input type="text" id="mkrNm" />
							</td>
							<th align="right"><span style="color:red;">*  </span>모델명</th>
							<td>
								<input type="text" id="mdlNm" />
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>대분류 / 소분류</th>
							<td colspan="3">
								<div id="mchnLaclCd"></div>
								&nbsp; / &nbsp;
								<div id="mchnClDtlCd"></div>
							</td>

						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>장비종류</th>
							<td>
								<div id="mchnClCd"></div>
							</td>
							<th align="right"><span style="color:red;">*  </span>open장비</th>
							<td>
								<div id="opnYn"></div>
							</td>
						</tr>
						<tr>
							<th align="right">장비사용상태</th>
							<td>
								<div id="mchnUsePsblYn"></div>
							</td>
							<th align="right"><span style="color:red;">*  </span>삭제여부</th>
							<td>
								<div id="delYn"></div>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>시료수</th>
							<td>
								<input type="text" id="smpoQty" />
							</td>
							<th align="right">메인여부</th>
							<td>
								<select id="mnScrnDspYn"></select>
							</td>
						</tr>
						<tr>
							<th align="right">자산명</th>
							<td>
								<input type="text" id="hFxaNm" readonly/>
							</td>
							<th align="right">자산번호</th>
							<td>
								<input type="text" id="hFxaNo" readonly/>
								<button type="button" id="butFxa">자산관리</button>
								<button type="button" id="butFxaInit">초기화</button>
							</td>
						</tr>
						<tr>
							<th align="right">담당자</th>
							<td>
								<input type="text" id="mchnCrgrNm" />
							</td>
							<th align="right" >위치</th>
							<td>
								<input type="text" id="mchnLoc" />
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>요약설명</th>
							<td colspan="3" style="padding-top:6px;">
								<textarea id="mchnExpl"></textarea>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>첨부파일</th>
							<td id="atthcFilVw" colspan="2"></td>
							<td>
								<button type="button" id="butAttcFil">첨부파일등록</button> <b>(280*200)</b>
							</td>
						</tr>
						<tr>
							<th  align="right"><span style="color:red;">*  </span>개요</th>
							<td colspan="3">
								<textarea id="mchnSmry" name="mchnSmry"></textarea>
									<script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('mchnSmry');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										var uploadPath = "<%=uploadPath%>";

										CrossEditor.params.ImageSavePath = uploadPath+"/mchn";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
										CrossEditor.params.FullScreen = false;
										CrossEditor.EditorStart();

										function OnInitCompleted(e){
											e.editorTarget.SetBodyValue(document.getElementById("mchnSmry").value);
										}
									</script>
							</td>
						</tr>
						</tbody>
				</table>
			</form>

		</div>
		<!-- //sub-content -->
		<!-- 이미지 -->
	<div id="imageDialog">
		<div class="hd" id="imgDialTitle">이미지</div>
		<div class="bd" id="imgDialContents">
			<img id="dialogImage"/>
		</div>
	</div>
	</div>
	<!-- //contents -->
</body>
</html>
