<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: rlabTeamGateReg.jsp
 * @desc    : Technical Service >  신뢰성시험 > Team Gate 등록
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
            		 ,{ id: 'titl'}
		           	 ,{ id: 'sbc'}
		           	 ,{ id: 'attcFilId'}
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

		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		         { id: 'titl', 		ctrlId: 'titl', 		value: 'value' },
		         { id: 'sbc', 			ctrlId: 'sbc', 		value: 'value' },
		         { id: 'teamGateId', 			ctrlId: 'teamGateId', 			value: 'value' },
		         { id: 'attcFilId', 		ctrlId: 'attcFilId', 		value: 'value' }
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

    	/* [버튼] : 등록 정보 저장 */
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

    		if(fncVaild()) {
    			if(confirm("저장 하시겠습니까?")) {
    				dm.updateForm({
    	        	    url: "<c:url value='/rlab/tmgt/saveRlabTeamGate.do'/>",
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

     		if( Rui.isEmpty(titl.getValue())){
    			Rui.alert("제목은 필수항목입니다.");
    			titl.focus();
    			return false;
    		}

     		if(CrossEditor.GetTextValue()==''){ // 크로스에디터 안의 컨텐츠 입력 확인
     		    alert("내용은 필수항목입니다.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}

    		frm.sbc.value = CrossEditor.GetBodyValue();

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

				<div class="LblockButton top mt10">
					<button type="button" id="butSave">저장</button>
					<button type="button" id="butList">목록</button>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>제목</th>
							<td colspan="4">
								<input type="text" id="titl" />
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
							<td colspan="3" id="atthcFilVw"></td>
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
