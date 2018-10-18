<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: spaceEvToolReg.jsp
 * @desc    : 분석기기 >  관리 > 공간평가Tool 등록 및 수정 화면
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

var faxInfoDialog;	//고정자산관리 팝업
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
            		  { id: 'toolNm'}
		           	 ,{ id: 'ver'}
		           	 ,{ id: 'cmpnNm'}
		           	 ,{ id: 'mchnCrgrNm'}
		           	 ,{ id: 'evCtgr'}
		           	 //,{ id: 'evWay'}
		           	 ,{ id: 'mchnExpl'}
		           	 ,{ id: 'mchnSmry'}
		           	 ,{ id: 'attcFilId'}
		           	 ,{ id: 'mnalFilId'}
		           	 ,{ id: 'mchnCrgrId'}
		           	 ,{ id: 'mchnInfoId'}
		            ]
	    });

	    dataSet.on('load', function(e){
			document.aform.mchnCrgrId.value = dataSet.getNameValue(0, "mchnCrgrId");

			if(dataSet.getNameValue(0, "mchnInfoId")  != "" ||  dataSet.getNameValue(0, "mchnInfoId")  !=  undefined ){
				CrossEditor.SetBodyValue( dataSet.getNameValue(0, "mchnSmry") );
			}

			var evWayVal = dataSet.getNameValue(0, "evWay").split(",");
			for(var i=0;i<evWayVal.length;i++){
				if(evWayVal[i]=="01"){
					evWay.getItem(0).setValue(true);
				}else if(evWayVal[i]=="02"){
					evWay.getItem(1).setValue(true);
				}else if(evWayVal[i]=="03"){
					evWay.getItem(2).setValue(true);
				}else if(evWayVal[i]=="04"){
					evWay.getItem(3).setValue(true);
				}else if(evWayVal[i]=="05"){
					evWay.getItem(4).setValue(true);
				}
			}
			firstLoad = "N";
	    });

	    //기기명 한글
		var toolNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'toolNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	        //inputType: Rui.util.LString.PATTERN_TYPE_KOREAN, // [옵션] 입력문자열로 영문자 입력만 허용
	    });

		//버전
		var ver = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'ver',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
           // inputType: Rui.util.LString.PATTERN_TYPE_STRING, // [옵션] 입력문자열로 영문자 입력만 허용
	    });

		//회사명
		var cmpnNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'cmpnNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false,                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		//평가카테고리 checkBox
		//분류 combo
		var evCtgr = new Rui.ui.form.LCombo({
		 	applyTo : 'evCtgr',
			name : 'evCtgr',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=SPACE_EV_CTGR"/>',
			displayField: 'COM_DTL_NM',
			valueField: 'COM_DTL_CD'
		});

		//평가항목 checkBox
		var evWay = new Rui.ui.form.LCheckBoxGroup({
		    applyTo: 'evWay',
		    name: 'evWay',
		    items: [
				<c:forEach var="data" items="${ evWayList }" varStatus="status">
					<c:choose>
						<c:when test="${status.index == 0}">
					       { label : "${ data.COM_DTL_NM }"+" &nbsp;" , name: "evWay" , value : "${ data.COM_DTL_CD }"}
						</c:when>
						<c:otherwise>
					   	, { label: '${ data.COM_DTL_NM }'+"  &nbsp;", value: '${ data.COM_DTL_CD }'}
						</c:otherwise>
					</c:choose>
				</c:forEach>
		    ]
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
		        url: '<c:url value="/mchn/mgmt/retrieveSpaceEvToolSearchDtl.do"/>' ,
	           	params :{
	           	        mchnInfoId : mchnInfoId
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
		         { id: 'toolNm', 		ctrlId: 'toolNm', 		value: 'value' },
		         { id: 'ver', 			ctrlId: 'ver', 		value: 'value' },
		         { id: 'cmpnNm', 			ctrlId: 'cmpnNm', 			value: 'value' },
		         { id: 'mchnCrgrNm', 			ctrlId: 'mchnCrgrNm', 			value: 'value' },
		         { id: 'evCtgr', 			ctrlId: 'evCtgr', 		value: 'value' },
		         //{ id: 'evWay', 			ctrlId: 'evWay', 		    value: 'value' },
		         { id: 'mchnExpl', 		ctrlId: 'mchnExpl', 		value: 'value' },
		         { id: 'mchnSmry', 		    ctrlId: 'mchnSmry', 	        value: 'value' },
		         { id: 'mchnCrgrId', 		ctrlId: 'mchnCrgrId', 		value: 'value' },
		         { id: 'attcFilId', 		ctrlId: 'attcFilId', 		value: 'value' },
		         { id: 'mnalFilId', 		ctrlId: 'mnalFilId', 		value: 'value' },
		         { id: 'mchnInfoId', 		ctrlId: 'mchnInfoId', 		value: 'value' }
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

        /* 메뉴얼첨부파일*/
		var menualFileDataSet = new Rui.data.LJsonDataSet({
            id: 'menualFileDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
				  { id: 'attcFilId'}
				, { id: 'seq' }
				, { id: 'filNm' }
				, { id: 'filSize' }
            ]
        });

		var mnalId;

		//dataset에서 첨부파일 정보가 있을경우
		dataSet.on('load', function(e) {
			mnalId = dataSet.getNameValue(0, "mnalFilId");
            if(!Rui.isEmpty(attId)) getMenualFileList();
        });

		//첨부파일 정보 조회
   		getMenualFileList = function(){
			menualFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                    attcFilId : mnalId
                }
            });
		}

		//첨부파일 조회후 load로 정보 호출
		menualFileDataSet.on('load', function(e) {
            getMenualFileInfoList();
        });

		//첨부파일 정보
		getMenualFileInfoList = function() {
            var menualFileInfoList = [];

            for( var i = 0, size = menualFileDataSet.getCount(); i < size ; i++ ) {
                menualFileInfoList.push(menualFileDataSet.getAt(i).clone());
            }
            setMenualFileInfo(menualFileInfoList);
        };

      //평가항목 체크박스 체크
        evWay.on('changed', function(e){
	        	 var checkedVal=evWay.getValue();
	        	 var val=checkedVal.toString();
	        	 var chkVal=checkedVal.toString();;
	        	 val=val.replace(/,,/gi,",").replace(/,,/gi,",").replace(/,,/gi,",");
	        	 if(val.charAt(0)==","){
	        		 val = val.substring(1,val.length);
	        	 }
	        	 if(val.charAt(val.length-1)!=","){
	        		 val = val+",";
	        	 }
	        	 //val=val.replace(/,/gi,"|");
	        	 $('#evWayVal').val(val);
        });


//************** button *************************************************************************************************/
		/* [버튼] : 공간평가 Tool 목록 이동 */
    	var butList = new Rui.ui.LButton('butList');

    	butList.on('click', function(){
    		fncSpaceEvToolList();
    	});

    	/* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFil = new Rui.ui.LButton('butAttcFil');
    	butAttcFil.on('click', function(){
    		var attcFilId = document.aform.attcFilId.value;
    		openAttachFileDialog3(setAttachFileInfo, attcFilId,'mchnPolicy', '*');
    	});

    	/* [버튼] : 메뉴얼파일 팝업 호출 */
    	var butMnalFil = new Rui.ui.LButton('butMnalFil');
    	butMnalFil.on('click', function(){
    		var mnalFilId = document.aform.mnalFilId.value;
    		openAttachFileDialog(setMenualFileInfo, mnalFilId,'mchnPolicy', '*');
    	});

    	/* [버튼] : 등록 정보 저장 */
    	var butSave = new Rui.ui.LButton('butSave');
   		butSave.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				fncSpaceEvToolList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    		if(fncVaild()) {
    			if(confirm("저장 하시겠습니까?")) {
    				dm.updateForm({
    	        	    url: "<c:url value='/mchn/mgmt/saveSpaceEvToolInfo.do'/>",
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

       	setMenualFileInfo = function(mnalFilList) {

            if(mnalFilList.length > 1 ){
         	   alert("첨부파일은 한개만 가능합니다.");
         	   return;
            }else{
 	           $('#menualFilVw').html('');
            }

            for(var i = 0; i < mnalFilList.length; i++) {
                $('#menualFilVw').append($('<a/>', {
                    href: 'javascript:downloadMnalFil("' + mnalFilList[i].data.attcFilId + '", "' + mnalFilList[i].data.seq + '")',
                    text: mnalFilList[i].data.filNm
                })).append('<br/>');
            document.aform.mnalFilId.value = mnalFilList[i].data.attcFilId;
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

       //첨부파일 다운로드
       downloadMnalFil = function(attId, seq){
	       var param = "?attcFilId=" + attId + "&seq=" + seq;
	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
	       	document.aform.submit();
    	    /*var param = "?attcFilId="+ attId+"&seq="+seq;
			Rui.getDom('dialogImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
			Rui.get('imgDialTitle').html('기기이미지');
			imageDialog.clearInvalid();
			imageDialog.show(true);*/

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

     //공간평가 Tool 목록 화면으로 이동
       var fncSpaceEvToolList = function(){
    	   	$('#searchForm > input[name=mchnNm]').val(encodeURIComponent($('#searchForm > input[name=mchnNm]').val()));
    	   	$('#searchForm > input[name=mchnCrgrNm]').val(encodeURIComponent($('#searchForm > input[name=mchnCrgrNm]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/mchn/mgmt/retrieveSpaceEvToolList.do"/>");
       }

     //vaild check

     var fncVaild = function(){
     		var frm = document.aform;
    		//기기명    vailid
    		/*
    		if( Rui.isEmpty(mchnHanNm.getValue())){
    			Rui.alert("기기명(한글)은 필수항목입니다");
    			mchnHanNm.focus();
    			return false;
    		}
    		if( Rui.isEmpty(mchnEnNm.getValue())){
    			Rui.alert("기기명(영문)은 필수항목입니다");
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
    		if( Rui.isEmpty(cbmchnClCd.getValue())){
    			Rui.alert("분류는 필수항목입니다.");
    			cbmchnClCd.focus();
    			return false;
    		}
    		if( Rui.isEmpty(cbMchnUsePsblYn.getValue())){
    			Rui.alert("기기사용상태 필수항목입니다.");
    			cbMchnUsePsblYn.focus();
    			return false;
    		}
    		if( Rui.isEmpty(cbOpnYn.getValue())){
    			Rui.alert("OPEN 기기는 필수항목입니다.");
    			cbOpnYn.focus();
    			return false;
    		}
    		if( Rui.isEmpty(cbDelYn.getValue())){
    			Rui.alert("삭제여부는 필수항목입니다.");
    			cbDelYn.focus();
    			return false;
    		}
    		if( Rui.isEmpty(mchnCrgrNm.getValue())){
    			Rui.alert("담당자는 필수항목입니다.");
    			mchnCrgrNm.focus();
    			return false;
    		}
    		if( Rui.isEmpty(mchnLoc.getValue())){
    			Rui.alert("위치는 필수항목입니다.");
    			mchnLoc.focus();
    			return false;
    		}
    		if( Rui.isEmpty(mchnExpl.getValue())){
    			Rui.alert("요약설명은 필수항목입니다.");
    			mchnExpl.focus();
    			return false;
    		}
    		*/

     		if(CrossEditor.GetTextValue()==''){ // 크로스에디터 안의 컨텐츠 입력 확인
     		    alert("개요내용을 입력해 주세요!!");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}

    		frm.mchnSmry.value = CrossEditor.GetBodyValue();

    		return true;
     	}

     	//createNamoEdit('Wec', '100%', 300, 'namoHtml_DIV');


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
			<h2>공간평가 Tool 관리</h2>
		</div>
		<div class="sub-content">
			<form name="searchForm" id="searchForm">
				<input type="hidden" name="mchnNm" value="${inputData.mchnNm}"/>
				<input type="hidden" name="mchnClCd" value="${inputData.mchnClCd}"/>
				<input type="hidden" name="fxaNo" value="${inputData.fxaNo}"/>
				<input type="hidden" name="opnYn" value="${inputData.opnYn}"/>
				<input type="hidden" name="mchnCrgrNm" value="${inputData.mchnCrgrNm}"/>
				<input type="hidden" name="mchnUsePsblYn" value="${inputData.mchnUsePsblYn}"/>
		    </form>

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" />

				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="mnaulFilId" name="mnalFilId" />
				<input type="hidden" id="mchnCrgrId" name="mchnCrgrId" />
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" value="<c:out value='${inputData.mchnInfoId}'/>">
				<input type="hidden" id="evCtgrVal" name="evCtgrVal" />
				<input type="hidden" id="evWayVal" name="evWayVal" />

				<input type="hidden" id="fxaNo" name="fxaNo" />

				<div class="LblockButton top mt10">
					<button type="button" id="butSave">저장</button>
					<button type="button" id="butList">목록</button>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 20%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>Tool</th>
							<td>
								<input type="text" id="toolNm" />
							</td>
							<th align="right"><span style="color:red;">*  </span>버전</th>
							<td>
								<input type="text" id="ver" />
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>회사</th>
							<td>
								<div id="cmpnNm"></div>
							</td>
							<th align="right">평가 카테고리</th>
							<td>
								<div id="evCtgr"></div>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>담당자</th>
							<td>
								<input type="text" id="mchnCrgrNm" />
							</td>
							<th align="right"><span style="color:red;">*  </span>평가항목</th>
							<td>
								<div id="evWay"></div>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>요약설명</th>
							<td colspan="3">
								<textarea id="mchnExpl"></textarea>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
							<td id="atthcFilVw" colspan="2"></td>
							<td>
								<button type="button" id="butAttcFil">첨부파일등록</button> <b>(280*200)</b>
							</td>
						</tr>
						<tr>
							<th align="right">첨부메뉴얼</th>
							<td id="menualFilVw" colspan="2"></td>
							<td>
								<button type="button" id="butMnalFil">메뉴얼등록</button>
							</td>
						</tr>
						<tr>
							<th  align="right">개요</th>
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
