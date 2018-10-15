<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: alnMchnReg.jsp
 * @desc    : 분석기기 > open기기 > 기기교육 > 등록및수정 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.05     IRIS05		최초생성
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

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LFileBox.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFileUploadDialog.css"/>

<script type="text/javascript">
var mchnDialog;
var fncCallBack;
var openMchnSearchDialog;


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
	        
		/* dataSet */
		var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'eduNm'}
            	 ,{ id: 'eduScnCd'}
            	 ,{ id: 'mchnNm'}
            	 ,{ id: 'eduCrgrNm'}
            	 ,{ id: 'pttFromDt'}
            	 ,{ id: 'pttToDt'}
            	 ,{ id: 'ivttCpsn'}
            	 ,{ id: 'eduDt'}
            	 ,{ id: 'eduFromTim'}
            	 ,{ id: 'eduToTim'}
            	 ,{ id: 'eduPl'}
            	 ,{ id: 'dtlSbc'}
            	 ,{ id: 'eduCrgrId'}
            	 ,{ id: 'attcFilId'}
            	 ,{ id: 'mchnInfoId'}
            	 ,{ id: 'mchnEduId'}
            ]
        });

		dataSet.on('load', function(e){
			document.aform.eduCrgrId.value = dataSet.getNameValue(0, "eduCrgrId");
			rdEduScnCd.setValue(dataSet.getNameValue(0, "eduScnCd"));
			
			if(dataSet.getNameValue(0, "mchnEduId")  != "" ||  dataSet.getNameValue(0, "mchnEduId")  !=  undefined ){
				CrossEditor.SetBodyValue( dataSet.getNameValue(0, "dtlSbc") );
			}
	    });

		//교육명
		var eduNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'eduNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//분석기기명
		var mchnNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        disabled: true,
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		/* 담당자 팝업 */
	    var eduCrgrNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'eduCrgrNm',
            width: 200,
            editable: false,
            placeholder: '',
            enterToPopup: true
        });

	    eduCrgrNm.on('popup', function(e){
	    	openUserSearchDialog(setUserInfo, 1, '');
       	});

	    setUserInfo = function (user){
	   		eduCrgrNm.setValue(user.saName);
	   		document.aform.eduCrgrId.value = user.saSabun;
	    };
	    
		//모집상태
		var rdEduScnCd = new Rui.ui.form.LRadioGroup({
	            applyTo : 'eduScnCd',
	            name : 'eduScnCd',
	            items : [
	                    {label : '수시',  value : 'NRGL'},
	                    {label : '정시',  value : 'REGL'}
	            ]
	    });

		//신청 시작일
		var pttFromDt = new Rui.ui.form.LDateBox({
            applyTo: 'pttFromDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue: new Date(),
            dateType: 'string'
        });

		//신청 종료일
		var pttToDt = new Rui.ui.form.LDateBox({
            applyTo: 'pttToDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue: new Date(),
            dateType: 'string'
        });

		//모집인원 숫자입력
	    var ivttCpsn = new Rui.ui.form.LNumberBox({
	        applyTo: 'ivttCpsn',
	        placeholder: '',
	        maxValue: 9999,           // 최대값 입력제한 설정
	        minValue: -10,                  // 최소값 입력제한 설정
	        decimalPrecision: 0            // 소수점 자리수 3자리까지 허용
	    });

	  	// 교육일
		var eduDt = new Rui.ui.form.LDateBox({
            applyTo: 'eduDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue: new Date(),
            dateType: 'string'
        });

	  	//교육 시작시간
	  	var eduFromTim = new Rui.ui.form.LNumberBox({
	        applyTo: 'eduFromTim',
	        placeholder: '',
	        width  : 50,
	        maxValue: 23,           // 최대값 입력제한 설정
	        minValue: 0,                  // 최소값 입력제한 설정
	        decimalPrecision: 0            // 소수점 자리수 3자리까지 허용
	    });

	  	//교육종료시간
	  	var eduToTim = new Rui.ui.form.LNumberBox({
	        applyTo: 'eduToTim',
	        placeholder: '',
	        width  : 50,
	        maxValue: 23,           // 최대값 입력제한 설정
	        minValue: 0,                  // 최소값 입력제한 설정
	        decimalPrecision: 0            // 소수점 자리수 3자리까지 허용
	    });

		//교육장소
		var eduPl = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'eduPl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		/* [ 분산기기 Dialog] */
		mchnDialog = new Rui.ui.LFrameDialog({
	        id: 'mchnDialog',
	        title: '분석기기목록',
	        width:  900,
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

		mchnDialog.render(document.body);

		fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/mchn/open/eduAnl/retrieveEduInfo.do"/>',
				params :{
					mchnEduId  : document.aform.mchnEduId.value	//기기교육 id
	                }
			});
		}

		fnSearch();

		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		         { id: 'eduNm', 		ctrlId: 'eduNm', 		value: 'value' },
		         { id: 'eduScnCd', 		ctrlId: 'rdEduScnCd', 	value: 'value' },
		         { id: 'mchnNm', 		ctrlId: 'mchnNm', 		value: 'value' },
		         { id: 'eduCrgrNm', 	ctrlId: 'eduCrgrNm', 	value: 'value' },
		         { id: 'pttFromDt', 	ctrlId: 'pttFromDt', 	value: 'value' },
		         { id: 'pttToDt', 		ctrlId: 'pttToDt', 		value: 'value' },
		         { id: 'ivttCpsn', 		ctrlId: 'ivttCpsn', 	value: 'value' },
		         { id: 'eduDt', 		ctrlId: 'eduDt', 	    value: 'value' },
		         { id: 'eduFromTim', 	ctrlId: 'eduFromTim', 	value: 'value' },
		         { id: 'eduToTim', 		ctrlId: 'eduToTim', 	value: 'value' },
		         { id: 'eduPl', 		ctrlId: 'eduPl', 		value: 'value' },
		         { id: 'dtlSbc', 		ctrlId: 'dtlSbc', 		value: 'value' },
		         { id: 'attcFilId', 	ctrlId: 'attcFilId', 	value: 'value' },
		         { id: 'eduCrgrId', 	ctrlId: 'eduCrgrId', 	value: 'value' },
		         { id: 'mchnInfoId', 	ctrlId: 'mchnInfoId', 	value: 'value' },
		         { id: 'mchnEduId', 	ctrlId: 'mchnEduId', 	value: 'value' },
		     ]
		});


/****************************************button*****************************************************************/
		var mchnEduId = document.aform.mchnEduId.value;

		/* [버튼] : 신규기기 저장 및 수정 */
    	var butSave = new Rui.ui.LButton('butSave');

    	butSave.on('click', function(){
    		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    		
    		dm.on('success', function(e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    			
    			if( resultData.records[0].rtnSt == "S"){
	    			fncMchnEduAnlList();
    			}
    		});
    		
    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    	    	alert(resultData.records[0].rtnMsg);
    	    });

			if(fncVaild()){
				if(confirm("저장 하시겠습니까?")) {
   	        	 dm.updateForm({
   	        	    url: "<c:url value='/mchn/open/eduAnl/saveEduInfo.do'/>",
   	        	    form : 'aform'
   	        	    });

				}
			}
	   	});

		/* [버튼] : 기기교육 삭제 */
    	var butdel = new Rui.ui.LButton('butdel');

    	butdel.on('click', function(){
    		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    			
    			if( resultData.records[0].rtnSt == "S"){
	    			fncMchnEduAnlList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    		if(mchnEduId == "") {
				Rui.alert("삭제할 기기 교육이 없습니다.");
				return;
    		}
    		if(confirm("삭제하시겠습니까?")) {
    			dm.updateDataSet({
   	        	    url: "<c:url value='/mchn/open/eduAnl/updateEduInfo.do'/>",
   	        	    dataSets:[dataSet],
   	        	    params: {
   	        	    	mchnEduId : mchnEduId
        	        }
   	        	});
    		}
	   		/* Rui.confirm({
	   			text: '삭제하시겠습니까?',
	   	        handlerYes: function() {
	           	    dm.updateDataSet({
	   	        	    url: "<c:url value='/mchn/open/eduAnl/updateEduInfo.do'/>",
	   	        	    dataSets:[dataSet],
	   	        	    params: {
	   	        	    	mchnEduId : mchnEduId
	        	        }
	   	        	});
	   	        }
	   		}); */
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

		dataSet.on('load', function(e) {
			attId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(attId)) getAttachFileList();
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

/************************* 버튼이벤트****************************/
		/* [버튼] : 분산기기 팝업 호출 */
    	var butMchn = new Rui.ui.LButton('butMchn');
    	butMchn.on('click', function(){
    		openMchnSearchDialog(fncCallBack);
    	});

    	/* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFilBtn = new Rui.ui.LButton('butAttcFil');
    	butAttcFilBtn.on('click', function(){
    		var attcFilId = document.aform.attcFilId.value;
    		openAttachFileDialog(setAttachFileInfo, attcFilId,'mchnPolicy', '*');
    	});

    	/* [버튼] : 기기교육관리 목록으로 이동 */
    	var butList = new Rui.ui.LButton('butList');
    	butList.on('click', function(){
			$('#searchForm > input[name=eduNm]').val(encodeURIComponent($('#searchForm > input[name=eduNm]').val()));
			$('#searchForm > input[name=mchnNm]').val(encodeURIComponent($('#searchForm > input[name=mchnNm]').val()));
	    	
	    	nwinsActSubmit(searchForm, "<c:url value="/mchn/open/eduAnl/retrieveEduAdmListList.do"/>");
    	});


 /**********************function 이벤트**********************/
		var fncVaild = function(){
    	    var frm = document.aform;

    		//교육명 
    		if(Rui.isEmpty(eduNm.getValue())){
    			alert("교육명을 입력하세요");
    			eduNm.focus();
    			return false;
    		}
    		//모집구분
    		if(Rui.isEmpty(rdEduScnCd.getValue())){
    			alert("교육구분을 선택하여주십시오");
    			rdEduScnCd.focus();
    			return false;
    		}
    		//분석기기
    		if(Rui.isEmpty(mchnNm.getValue())){
    			alert("분석기기를 입력해주십시오");
    			mchnNm.focus();
    			return false;
    		}
    		//담당자
    		if(Rui.isEmpty(eduCrgrNm.getValue())){
    			alert("담당자를 입력해주십시오");
    			eduCrgrNm.focus();
    			return false;
    		}
    		//신청일
    		if(Rui.isEmpty(pttFromDt.getValue())){
    			alert("신청시작일을 입력해주십시오");
    			pttFromDt.focus();
    			return false;
    		}
    		if(Rui.isEmpty(pttToDt.getValue())){
    			alert("신청종료일을 입력해주십시오");
    			pttToDt.focus();
    			return false;
    		}
    		//모집인원
    		if(Rui.isEmpty(ivttCpsn.getValue())){
    			alert("모집인원을 입력해주십시오");
    			ivttCpsn.focus();
    			return false;
    		}
    		//교육일시
    		if(Rui.isEmpty(eduDt.getValue())){
    			alert("교육일을 입력해주십시오");
    			eduDt.focus();
    			return false;
    		}
    		if(Rui.isEmpty(eduFromTim.getValue())){
    			alert("교육시작시간을 입력해주십시오");
    			eduFromTim.focus();
    			return false;
    		}
    		if(Rui.isEmpty(eduToTim.getValue())){
    			alert("교육종료시간을 입력해주십시오");
    			eduToTim.focus();
    			return false;
    		}
    		//교육장소
    		if(Rui.isEmpty(eduPl.getValue())){
    			alert("교육장소를 입력하여주십시오");
    			eduPl.focus();
    			return false;
    		}
    		
    		frm.dtlSbc.value = CrossEditor.GetBodyValue();
    		
    		if( frm.dtlSbc.value == "<p><br></p>" || frm.dtlSbc.value == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
    			alert('내용을 입력하여 주십시요.');
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}
    		
    		return true;
 		}

		openMchnSearchDialog = function(f) {
	    	_callback = f;
	    	mchnDialog.setUrl('<c:url value="/mchn/open/eduAnl/retrieveMchnInfoPop.do"/>');
	    	mchnDialog.show();
	    };

 		//기기pop창 정보 callback
		fncCallBack = function(re){
			document.aform.mchnInfoId.value = re.get("mchnInfoId");
			mchnNm.setValue(re.get("mchnNm"));
		}

 		//첨부파일 callback
		setAttachFileInfo = function(attcFilList) {
            $('#atthcFilVw').html('');

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
        
        var fncMchnEduAnlList = function(){
        	
        	$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));
			$('#searchForm > input[name=fxaNm]').val(encodeURIComponent($('#searchForm > input[name=fxaNm]').val()));
			$('#searchForm > input[name=crgrNm]').val(encodeURIComponent($('#searchForm > input[name=crgrNm]').val()));
			
        	document.searchForm.action='<c:url value="/mchn/open/eduAnl/retrieveEduAdmListList.do"/>';
   			document.searchForm.submit();
        }

	});  //end ready

</script>
<style type="text/css">
.search-toggleBtn {display:none;}
</style>
</head>
<body>
	<div class="contents" style="position:absolute;top:0px;Z-INDEX:1;">
		<div class="titleArea">
			<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>기기교육 관리</h2>
		</div>
	<form name="searchForm" id="searchForm">
		<input type="hidden" name="eduNm" value="${inputData.eduNm}"/>
		<input type="hidden" name="mchnNm" value="${inputData.mchnNm}"/>
		<input type="hidden" name="eduScnCd" value="${inputData.eduScnCd}"/>
		<input type="hidden" name="pttYn" value="${inputData.pttYn}"/>
    </form>
    
		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" />
				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" />
				<input type="hidden" id="eduCrgrId" name="eduCrgrId"   />
				<input type="hidden" id="mchnEduId" name="mchnEduId"  value="<c:out value='${inputData.mchnEduId}'/>">

				<div class="LblockButton top mt0">
					<button type="button" id="butSave">저장</button>
					<button type="button" id="butdel">삭제</button>
					<button type="button" id="butList">목록</button>
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
							<th align="right"><span style="color:red;">*  </span>교육명</th>
							<td>
								<input type="text" id="eduNm" />
							</td>
							<th align="right"><span style="color:red;">*  </span>교육구분</th>
							<td colspan="2">
								<div id="eduScnCd"></div>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>분석기기</th>
							<td>
								<input id="mchnNm" type="text"/>  <button type="button" id="butMchn">기기조회</button>
							</td>
							<th align="right"><span style="color:red;">*  </span>담당자</th>
							<td colspan="2">
								<div id="eduCrgrNm"></div>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>신청일</th>
							<td>
								<input id="pttFromDt" type="text"/><em style="display:inline-block; padding:0 6px 0 37px;"> ~ </em><input id="pttToDt" type="text" />
							</td>
							<th align="right"><span style="color:red;">*  </span>모집인원</th>
							<td colspan="2">
								<input id="ivttCpsn" type="text" />&nbsp명
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>교육일시</th>
							<td class="mchn_data">
								<input id="eduDt" type="text" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="eduFromTim" type="text"  />&nbsp;시 ~ <input id="eduToTim" type="text" />&nbsp;시
							</td>
							<th align="right"><span style="color:red;">*  </span>교육장소</th>
							<td colspan="2">
								<input id="eduPl" type="text" />
							</td>
						</tr>
						<tr>
							<td colspan="5">
								<textarea id="dtlSbc" name="dtlSbc"></textarea>
									<script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('dtlSbc');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										
										var uploadPath = "<%=uploadPath%>"; 
										
										CrossEditor.params.ImageSavePath = uploadPath+"/mchn";
										CrossEditor.params.FullScreen = false;
										
										CrossEditor.EditorStart();
										
										function OnInitCompleted(e){
											//CrossEditor.ShowToolbar(0,0); 
											//CrossEditor.ShowToolbar(1,0);
											//CrossEditor.ShowToolbar(2,0);
											e.editorTarget.SetBodyValue(document.getElementById("dtlSbc").value);
										}
									</script>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
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
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>
