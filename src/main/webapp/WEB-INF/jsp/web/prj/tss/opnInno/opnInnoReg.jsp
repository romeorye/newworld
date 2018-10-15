<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: opnInnoReg.jsp
 * @desc    : 연구팀 > 과제 >   Open Innovation 협력과제 신규등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.01.16     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">
var attId;
var openRfpSearchDialog;
var openRfpDetailViewDialog;

	Rui.onReady(function() {
		/*******************
         * 변수 및 객체 선언
         *******************/
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

         /** dataSet **/
         var dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
            	   { id: 'opnInnoId'}
            	 , { id: 'tssNm'}
            	 , { id: 'prjNm'}
            	 , { id: 'tssEmpNm'}
            	 , { id: 'tssStrDt'}
            	 , { id: 'tssEndDt'}
            	 , { id: 'deptNm'}
            	 , { id: 'abrdInstNm'}
            	 , { id: 'abrdCrgrNm'}
            	 , { id: 'ousdInstNm'}
            	 , { id: 'oustCrgrNm'}
            	 , { id: 'pgsStepCd'}
            	 , { id: 'tssPgsTxt'}
            	 , { id: 'tssPgsKeyword'}
            	 , { id: 'tssFnoPlnTxt'}
            	 , { id: 'tssFnoPlnKeyword'}
            	 , { id: 'rem'}
            	 , { id: 'rfpId'}
            	 , { id: 'title'}
            	 , { id: 'attcFilId'}
 			]
         });

         dataSet.on('load', function(e){
        	attId = dataSet.getNameValue(0, "attcFilId");

 			if(Rui.isEmpty(attId)){
 				attId ="";
 			}
 			if(!Rui.isEmpty(attId)) getAttachFileList();

 			if(!Rui.isEmpty(dataSet.getNameValue(0, 'rfpId')) ){
 				fncRtpUrl(dataSet.getNameValue(0, 'rfpId'), dataSet.getNameValue(0, 'title'));
 			}
 	     });

       	//과제명
  	    var tssNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'tssNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 800,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

       	//프로젝트명
  	    var prjNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'prjNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

       	//과제리더
  	    var tssEmpNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'tssEmpNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

       	//조직
  	    var deptNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'deptNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

       	//해외기술센터 기관명
  	    var abrdInstNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'abrdInstNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	 	 });

  	    //해외기술센터 담당자명
  	    var abrdCrgrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'abrdCrgrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

  		//외부협력기관 기관명
  	    var ousdInstNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'ousdInstNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	 	});

  	    //외부협력기관 담당자명
  	    var oustCrgrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'oustCrgrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

       //과제기간 시작일
  	  	var tssStrDt = new Rui.ui.form.LDateBox({
          applyTo: 'tssStrDt',
          mask: '9999-99-99',
          displayValue: '%Y-%m-%d',
          defaultValue: '',
          defaultValue: new Date(),
          dateType: 'string'
      	});

       	//과제기간 종료일
  	  	var tssEndDt = new Rui.ui.form.LDateBox({
          applyTo: 'tssEndDt',
          mask: '9999-99-99',
          displayValue: '%Y-%m-%d',
          defaultValue: '',
          defaultValue: new Date(),
          dateType: 'string'
      	});

       	/* [ RFP요청서 리스트 Dialog] */
	 	rfpDialog = new Rui.ui.LFrameDialog({
	        id: 'rfpDialog',
	        title: 'RFP요청서 목록',
	        width:  800,
	        height: 600,
	        modal: true,
	        visible: false,
	        buttons : [
	            { text:'닫기', handler: function() {
	              	this.cancel(false);
	              }
	            }
	        ]
	    });

	 	rfpDialog.render(document.body);

	   	openRfpSearchDialog = function(f) {
	    	_callback = f;
	    	rfpDialog.setUrl('<c:url value="/prj/tss/rfp/openRfpList.do"/>');
	    	rfpDialog.show();
	   	};

	 	//rfp요청서 정보 callback
		fncCallBack = function(re){
			$('#titleVw').html(re.get("title"));
			dataSet.setNameValue(0, 'rfpId', re.get("rfpId"));
		}


		fncRtpUrl = function(id, title){
			$('#titleVw').html('');

            $('#titleVw').append($('<a/>', {
                href: 'javascript:openRfpDetailViewDialog("'+ id +'")',
                text: title
            })).append('<br/>');
        }

		openRfpDetailViewDialog = function(id) {
			rfpViewDialog.setUrl('<c:url value="/prj/tss/rfp/openRfpDetailViewPop.do"/>'+'?rfpId='+id);
	    	rfpViewDialog.show();
	   };

	   /* [ RFP요청서 view Dialog] */
	 	rfpViewDialog = new Rui.ui.LFrameDialog({
	        id: 'rfpViewDialog',
	        title: 'RFP요청서 View',
	        width:  1000,
	        height: 700,
	        modal: true,
	        visible: false,
	        buttons : [
	            { text:'닫기', handler: function() {
	              	this.cancel(false);
	              }
	            }
	        ]
	    });

	 	rfpViewDialog.render(document.body);

  		 //현진행상황 keyword
	    var tssPgsKeyword = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'tssPgsKeyword',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 800,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	    //현진행상황 keyword
  	    var tssFnoPlnKeyword = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'tssFnoPlnKeyword',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 800,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

  	 //현진행상황
	    var tssPgsTxt = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'tssPgsTxt',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 800,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	 	//향후계획
	    var tssFnoPlnTxt = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'tssFnoPlnTxt',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 800,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	 	//비고
	    var rem = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'rem',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 800,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });


	 	// 진행상태combo
		var pgsStepCd = new Rui.ui.form.LCombo({
			applyTo : 'pgsStepCd',
			name : 'pgsStepCd',
			defaultValue: '<c:out value="${inputData.pgsStepCd}"/>',
			useEmptyText: true,
	           emptyText: '선택하세요',
	           url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=OPEN_INNO_PGS"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD',
	     });


		pgsStepCd.getDataSet().on('load', function(e) {
	           console.log('pgsStepCd :: load');
	       	});

        fnSearch = function() {
 	    	dataSet.load({
 	            url: '<c:url value="/prj/tss/opnInno/retrieveOpnInnoInfo.do"/>',
 	            params :{
 	            	opnInnoId  : document.aform.opnInnoId.value
 	    	          }
             });
        }

        fnSearch();

	    /* [DataSet] bind */
	    var dataSetBind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: dataSet,
	        bind: true,
	        bindInfo: [
		    	  {id: 'tssNm',   			ctrlId: 'tssNm',  			value: 'value' }
		    	, {id: 'prjNm',       		ctrlId: 'prjNm',      		value: 'value' }
		    	, {id: 'tssEmpNm',       	ctrlId: 'tssEmpNm',      	value: 'value' }
		    	, {id: 'tssStrDt',     		ctrlId: 'tssStrDt',    		value: 'value' }
		    	, {id: 'tssEndDt',       	ctrlId: 'tssEndDt',      	value: 'value' }
		    	, {id: 'deptNm',       		ctrlId: 'deptNm',      		value: 'value' }
		    	, {id: 'abrdInstNm',      	ctrlId: 'abrdInstNm',     	value: 'value' }
		    	, {id: 'abrdCrgrNm',      	ctrlId: 'abrdCrgrNm',     	value: 'value' }
		    	, {id: 'ousdInstNm',     	ctrlId: 'ousdInstNm',    	value: 'value' }
		    	, {id: 'oustCrgrNm',      	ctrlId: 'oustCrgrNm',     	value: 'value' }
		    	, {id: 'pgsStepCd',    		ctrlId: 'pgsStepCd',   		value: 'value' }
		    	, {id: 'tssPgsTxt',      	ctrlId: 'tssPgsTxt',     	value: 'value' }
		    	, {id: 'tssPgsKeyword',     ctrlId: 'tssPgsKeyword',    value: 'value' }
		    	, {id: 'tssFnoPlnTxt' ,     ctrlId: 'tssFnoPlnTxt',     value: 'value' }
		    	, {id: 'tssFnoPlnKeyword',	ctrlId: 'tssFnoPlnKeyword',	value: 'value' }
		    	, {id: 'rem',				ctrlId: 'rem',	value: 'value' }
	        ]
	    });

	    dataSet.newRecord();

		dataSetBind.on('load', function(e){
		});

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

		 getAttachFileList = function(){
				attachFileDataSet.load({
	                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
	                params :{
	                    attcFilId : attId
	                }
	            });
		}

		attachFileDataSet.on('load', function(e) {
	    	getAttachFileInfoList();
	    });

		getAttachFileInfoList = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }

            setAttachFileInfo(attachFileInfoList);
        };

	  	//첨부파일 callback
		setAttachFileInfo = function(attcFilList) {
            $('#atthcFilVw').html('');

            for(var i = 0; i < attcFilList.length; i++) {
                $('#atthcFilVw').append($('<a/>', {
                    href: 'javascript:downloadAttcFil("' + attcFilList[i].data.attcFilId + '", "' + attcFilList[i].data.seq + '")',
                    text: attcFilList[i].data.filNm
                })).append('<br/>');

            }

            if(Rui.isEmpty(attId)) {
                attId = attcFilList[0].data.attcFilId;
            	dataSet.setNameValue(0, "attcFilId", attcFilList[0].data.attcFilId);
            }
        };

      	//첨부파일 다운로드
        downloadAttcFil = function(attId, seq){
        	var param = "?attcFilId=" + attId + "&seq=" + seq;
        	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
        	document.aform.submit();
        }

        /* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFilBtn = new Rui.ui.LButton('butAttcFil');
    	butAttcFilBtn.on('click', function(){
    		openAttachFileDialog(setAttachFileInfo, getAttachFileId(),'prjPolicy', '*');
    	});

    	var getAttachFileId = function() {
            if(Rui.isEmpty(attId)) attId = "";

            return attId;
        };


   		/* [버튼] : 저장  */
       	var butSave = new Rui.ui.LButton('butSave');
       	butSave.on('click', function(){
       		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
       		dm.on('success', function(e) {      // 업데이트 성공시
       			var resultData = resultDataSet.getReadData(e);
   	   			Rui.alert(resultData.records[0].rtnMsg);

       			if( resultData.records[0].rtnSt == "S"){
   	    			fncOpnInnoList();
       			}
       	    });

       	    dm.on('failure', function(e) {      // 업데이트 실패시
       	    	var resultData = resultDataSet.getReadData(e);
   	   			Rui.alert(resultData.records[0].rtnMsg);
       	    });

   			//if(fncVaild()){
   				Rui.confirm({
   		   			text: '저장하시겠습니까?',
   		   	        handlerYes: function() {
		   		   	      dm.updateDataSet({
		   		             dataSets:[dataSet],
		   		             url:"<c:url value='/prj/tss/opnInno/saveOpnInnoInfo.do'/>",
		   		             modifiedOnly: false
		   		         });
   		  	     	}
   	    	    });
   			//}
       	});

       	/* [버튼] : 삭제  */
       	var butDel = new Rui.ui.LButton('butDel');
       	butDel.on('click', function(){
       		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
       		dm.on('success', function(e) {      // 업데이트 성공시
       			var resultData = resultDataSet.getReadData(e);
   	   			Rui.alert(resultData.records[0].rtnMsg);

       			if( resultData.records[0].rtnSt == "S"){
   	    			fncOpnInnoList();
       			}
       	    });

       	    dm.on('failure', function(e) {      // 업데이트 실패시
       	    	var resultData = resultDataSet.getReadData(e);
   	   			Rui.alert(resultData.records[0].rtnMsg);
       	    });

       	    var opnInnoId = document.aform.opnInnoId.value;

       	    if (Rui.isEmpty(opnInnoId)){
       	    	Rui.alert("삭제할 데이터가 없습니다.");
       	    	return;
       	    }

   			//if(fncVaild()){
   				Rui.confirm({
   		   			text: '삭제하시겠습니까?',
   		   	        handlerYes: function() {
		   		   	      dm.updateDataSet({
		   		             dataSets:[dataSet],
		   		             url:"<c:url value='/prj/tss/opnInno/deleteOpnInnoInfo.do'/>",
		   		             params : {
		   		            	opnInnoId : opnInnoId
		 	        	     }
		   		         });
   		  	     	}
   	    	    });
   			//}
       	});


       	fncOpnInnoList = function(){
       		$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
	    	$('#searchForm > input[name=ousdInstNm]').val(encodeURIComponent($('#searchForm > input[name=ousdInstNm]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/prj/tss/opnInno/retrieveOpnInno.do"/>");
       	}

       	/* [버튼] : 분산기기 팝업 호출 */
    	var butRfp = new Rui.ui.LButton('butRfp');
    	butRfp.on('click', function(){
    		openRfpSearchDialog(fncCallBack);
    	});

       	/* [버튼] : 목록  */
       	var butList = new Rui.ui.LButton('butList');
       	butList.on('click', function(){
       		fncOpnInnoList();
       	});

       	if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butSave").hide();
        	$("#butDel").hide();
        	$("#butAttcFil").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butSave").hide();
        	$("#butDel").hide();
        	$("#butAttcFil").hide();
		}


	});

</script>
<style>
.search-toggleBtn {display:none;}
</style>
</head>

<body>
	<form name="searchForm" id="searchForm"  method="post">
		<input type="hidden" name="tssNm" value="${inputData.tssNm}"/>
		<input type="hidden" name="ousdInstNm" value="${inputData.ousdInstNm}"/>
    </form>

	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
	          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	          <span class="hidden">Toggle 버튼</span>
			</a>
  			<h2>Open Innovation 협력과제 등록</h2>
  	    </div>
  		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="opnInnoId" name="opnInnoId" value="<c:out value='${inputData.opnInnoId}'/>">
				<div class="LblockButton top mt0">
						<button type="button" id="butSave">저장</button>
						<button type="button" id="butDel">삭제</button>
						<button type="button" id="butList">목록</button>
				</div>

  				<table class="table table_txt_right">
  					<colgroup>
  						<col style="width:10%"/>
  						<col style="width:10%"/>
  						<col style="width:30%"/>
  						<col style="width:10%"/>
  						<col style="width:10%"/>
  						<col style="width:30%"/>
  					</colgroup>
  					<tbody>
  					    <tr>
  							<th align="right">과제명</th>
  							<td colspan="5">
								<input type="text"  id="tssNm" >
  							</td>
   						</tr>
   						<tr>
   							<th rowspan="3" align="right">하우시스</th>
   							<th align="right">관련 PJT</th>
   							<td>
								<input type="text"  id="prjNm" >
  							</td>
   							<th rowspan="2" align="right">해외기술센터</th>
   							<th align="right">기관명</th>
   							<td>
								<input type="text"  id="abrdInstNm" >
   							</td>
   						</tr>
   						<tr>
   							<th align="right">과제리더</th>
   							<td>
   								<input type="text"  id="tssEmpNm" >
   							</td>
   							<th align="right">담당자</th>
   							<td>
   								<input type="text"  id="abrdCrgrNm" >
   							</td>
   						</tr>
   						<tr>
   							<th align="right">조직</th>
   							<td>
   								<input type="text"  id="deptNm" >
   							</td>
   							<th colspan ="2" align="right">과제기간</th>
   							<td>
   								<input type="text" id="tssStrDt" /><em class="gab"> ~ </em>	<input type="text" id="tssEndDt" />
   							</td>
   						</tr>

   						<tr>
   							<th rowspan="2" align="right">외부협력기관</th>
   							<th align="right">기관명</th>
   							<td>
   								<input type="text"  id="ousdInstNm" >
   							</td>
   							<th  colspan ="2"  align="right">진행상태</th>
   							<td>
   								<select  id="pgsStepCd" >
   							</td>
   						</tr>

   						<tr>
   							<th align="right">담당자</th>
   							<td colspan="5">
   								<input type="text"  id="oustCrgrNm" >
   							</td>
   						</tr>

   						<tr>
   							<th rowspan="4" align="right">과제현황</th>
   							<th rowspan="2" align="right">현진행상황</th>
   							<td colspan="4">
   								<input type="text"  id="tssPgsKeyword" >
   							</td>
   						</tr>
   						<tr>
   							<td colspan="4">
   								<input type="text"  id="tssPgsTxt" >
   							</td>
   						</tr>

   						<tr>
   							<th rowspan="2" align="right">향후계획</th>
   							<td colspan="4">
   								<input type="text"  id="tssFnoPlnKeyword" >
   							</td>
   						</tr>
   						<tr>
   							<td colspan="4">
   								<input type="text"  id="tssFnoPlnTxt" >
   							</td>
   						</tr>
   						<tr>
   							<th colspan="2" align="right">비고</th>
   							<td colspan="4">
   								<input type="text"  id="rem" >
   							</td>
   						</tr>
   						<tr>
   							<th colspan="2" align="right">RFP요청서</th>
   						 	<td id="titleVw" colspan="3">&nbsp;&nbsp;
							</td>
							<td colspan="2">
								<button type="button" id="butRfp">RFP요청서조회</button>
							</td>
   						</tr>
   						<tr>
   							<th colspan="2" align="right">첨부파일</th>
   							<td id="atthcFilVw" colspan="3">&nbsp;&nbsp;
							</td>
							<td>
								<button type="button" id="butAttcFil">첨부파일등록</button>
							</td>
   						</tr>

  					</tbody>
  				</table>
			</form>
		</div>
	</div>
</body>
</html>