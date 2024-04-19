<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: nrmDetail.jsp
 * @desc    : 소장 규격 등록 및 상세 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.08.01   IRIS05			최초생성
 * ---	-----------	----------	-----------------------------------------
 * 
 *************************************************************************
 */
--%>				
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">
var nrmId;
var attId;

	Rui.onReady(function() {
		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		
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
        
        nrmId = '${inputData.nrmId}';
        
		/*******************
         * 변수 및 객체 선언
         *******************/
         var knldNrmDataSet = new Rui.data.LJsonDataSet({
             id: 'knldNrmDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
		         { id : 'nrmId' } 
				,{ id : 'nrmNo'}			//규격번호
				,{ id : 'nrmNm'}			//규격명
				,{ id : 'issAuth'}			// 발행기관
				,{ id : 'aplcNo'}			//	신청자사번 
				,{ id : 'aplcNm'}			//신청자 명   
				,{ id : 'reportingDt'}		//신청일  
				,{ id : 'getDt'}			//입수일  
				,{ id : 'enctDt'}			//제정일 
				,{ id : 'lastRfrmDt'}		//최종개정일  
				,{ id : 'subsidiaryInfo' } 	//부화합정보 
				,{ id : 'lang'}				//언어 
				,{ id : 'pce'}				//가격    
				,{ id : 'pageCnt'}			//페이지수  
				,{ id : 'abst'}				//초록  
				,{ id : 'attcFileId' }
			]
         });
		
         knldNrmDataSet.on('load', function(e){
        	 attId = knldNrmDataSet.getNameValue(0, 'attcFileId');
        	 
        	 CrossEditor.SetBodyValue( knldNrmDataSet.getNameValue(0, "abst") );
        	 if(!Rui.isEmpty(attId)) getAttachFileList();
         });


       //첨부파일 조회
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
       
         
         /* 담당자 팝업 */
 	    var aplcNm = new Rui.ui.form.LPopupTextBox({
             applyTo: 'aplcNm',
             width: 200,
             editable: false,
             placeholder: '',
             enterToPopup: true
         });

        aplcNm.on('popup', function(e){
 	    	openUserSearchDialog(setUserInfo, 1, '');
        });

        setUserInfo = function (user){
 	   		knldNrmDataSet.setNameValue(0, 'aplcNo', user.saSabun );
	 		aplcNm.setValue(user.saName);
 	    };

 	   
        //규격명  
		var nrmNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'nrmNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 900,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
         
       //규격번호
 		var nrmNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'nrmNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 300,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });
        
        //발행기관  
		var issAuth = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'issAuth',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 300,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                          // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
         
         
        //부합화정보  
		var subsidiaryInfo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'subsidiaryInfo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
         
        //언어  
		var lang = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'lang',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
         
		//가격
		var pce = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'pce',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		
		//페이지수
		var pageCnt = new Rui.ui.form.LNumberBox({            // LTextBox개체를 선언
	        applyTo: 'pageCnt',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		
		//제정일
		var enctDt = new Rui.ui.form.LDateBox({
             applyTo: 'enctDt',
             mask: '9999-99-99',
             displayValue: '%Y-%m-%d',
             dateType: 'string'
        });
		
		//최종개정일
		var lastRfrmDt = new Rui.ui.form.LDateBox({
             applyTo: 'lastRfrmDt',
             mask: '9999-99-99',
             displayValue: '%Y-%m-%d',
             dateType: 'string'
        });
		
		//신청일
		var reportingDt = new Rui.ui.form.LDateBox({
             applyTo: 'reportingDt',
             mask: '9999-99-99',
             displayValue: '%Y-%m-%d',
             dateType: 'string'
        });
         
        fnSearch = function(){
        	 knldNrmDataSet.load({
 				url: '<c:url value="/knld/nrm/retrieveNrmInfo.do"/>',
 				params :{
 					nrmId  : nrmId	//규격id
 	                }
 			});
 		 }

 		 fnSearch();
 		
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
                 
                 knldNrmDataSet.setNameValue(0, 'attcFileId' , attcFilList[i].data.attcFilId);
                 //document.aform.attcFilId.value = attcFilList[i].data.attcFilId;
             }
         };

         //첨부파일 다운로드
         downloadAttcFil = function(attId, seq){
         	var param = "?attcFilId=" + attId + "&seq=" + seq;
         	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
         	document.aform.submit();
         }
		
        /* [기능] 첨부파일 등록 팝업*/
        getAttachFileId = function() {
            if(Rui.isEmpty(attId)) attId = "";
             return attId;
        };
		
         
        /* [버튼] : 저장 */
 		var butSave = new Rui.ui.LButton('butSave');
 		
 		butSave.on('click', function(){
 			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
	
    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				fncList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    	    if(!vm.validateGroup("aform")) {
             	alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                return false;
            }
    	    
    	    knldNrmDataSet.setNameValue(0, 'abst', CrossEditor.GetBodyValue());
			/* 
    	    // 에디터 valid
			if( knldNrmDataSet.getNameValue(0, "abst") == "<p><br></p>" || knldNrmDataSet.getNameValue(0, "abst") == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert("내용 : 필수 입력 항목 입니다.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}
			 */
    	    
   			if(confirm("저장 하시겠습니까?")) {
   				dm.updateDataSet({
   		             dataSets:[knldNrmDataSet],
   		         	 url: "<c:url value='/knld/nrm/saveNrmInfo.do'/>",
   		             modifiedOnly: false
   		         });
    	    }
 		});
 		
         
		/* [DataSet] bind */
	    bind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: knldNrmDataSet,
	        bind: true,
	        bindInfo: [
	        	 {id : 'nrmNm', 			ctrlId : 'nrmNm',  			value : 'value'}
	        	,{id : 'nrmNo', 			ctrlId : 'nrmNo',  			value : 'value'}
	        	,{id : 'issAuth', 			ctrlId : 'issAuth',  		value : 'value'}
	        	,{id : 'lang', 				ctrlId : 'lang',  			value : 'value'}
	        	,{id : 'enctDt', 			ctrlId : 'enctDt',  		value : 'value'}
	        	,{id : 'lastRfrmDt', 		ctrlId : 'lastRfrmDt',  	value : 'value'}
	        	,{id : 'subsidiaryInfo', 	ctrlId : 'subsidiaryInfo',  value : 'value'}
	        	,{id : 'getDt', 			ctrlId : 'getDt',  			value : 'value'}
	        	,{id : 'pageCnt', 			ctrlId : 'pageCnt',  		value : 'value'}
	        	,{id : 'pce', 				ctrlId : 'pce',  			value : 'value'}
	        	,{id : 'aplcNm', 			ctrlId : 'aplcNm',  		value : 'value'}
	        	,{id : 'reportingDt', 			ctrlId : 'reportingDt',  		value : 'value'}
	        	//,{id : 'colaboTclg', 	ctlId : 'colaboTclg',  		value : 'value'}
	        ]
	    });
         
	    vm = new Rui.validate.LValidatorManager({
            validators: [
            	 	 { id : 'nrmNn'		, validExp : '규격명 :true'}           
            		,{ id : 'nrmNo'		, validExp : '규격번호:true'}           
            		,{ id : 'issAuth'	, validExp : '발행기관:true'}        
            		//,{ id : 'aplcNm'	, validExp : '신청자:true'}  
            ]
        });
	    
		fncList = function(){
			nwinsActSubmit(aform, "<c:url value='/knld/nrm/nrmList.do'/>");			
		}
         
	});
</script>	
</head>
<body>
<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
</form>
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>규격신청</h2>
		</div>
		<div class="sub-content">

			<form name="aform" id="aform"  method="post">
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:"" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">규격명</th>
							<td colspan="3">
								<input type="text" id='nrmNm' name='nrmNn' />
							</td>
						</tr>
						<tr>
							<th align="right">규격번호</th>
							<td>
								<input type="text" id='nrmNo' name='nrmNo' />
							</td>
							<th align="right">신청자</th>
							<td>
								<div id="aplcNm"></div>
							</td>
						</tr>
						<tr>
							<th align="right">발행기관</th>
							<td>
								<input type="text" id='issAuth' name='issAuth' />
							</td>
							<th align="right">언어</th>
							<td>
								<input type="text" id='lang' name='lang' />
							</td>
						</tr>
						<tr>
							<th align="right">제정일</th>
							<td>
								<input type="text" id='enctDt' name='enctDt' />
							</td>
							<th align="right">최종개정일</th>
							<td>
								<input type="text" id='lastRfrmDt' name='lastRfrmDt' />
							</td>
						</tr>
						<tr>
							<th align="right">부화합정보</th>
							<td>
								<input type="text" id='subsidiaryInfo' name='subsidiaryInfo' />
							</td>
							<th align="right">신청일</th>
							<td>
								<input type="text" id='reportingDt' name='reportingDt' />
							</td>
						</tr>
						<tr>
							<th align="right">페이지수</th>
							<td>
								<input type="text" id='pageCnt' name='pageCnt' />
							</td>
							<th align="right">가격</th>
							<td>
								<input type="text" id='pce' name='pce' />
							</td>
						</tr>
						<tr>
							<th align="right">초록</th>
							<td colspan="3">
								<textarea id="abst" name="abst"></textarea>
   								 <script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('abst');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										CrossEditor.params.Font = fontParam;
										
										var uploadPath = "<%=uploadPath%>"; 
										
										CrossEditor.params.ImageSavePath = uploadPath+"/knld";
										CrossEditor.params.FullScreen = false;
										
										CrossEditor.EditorStart();
										
										function OnInitCompleted(e){
											e.editorTarget.SetBodyValue(document.getElementById("abst").value);
										}
									</script>
							</td>
						</tr>
						<tr>
   							<th align="right">첨부파일</th>
   							<td  colspan="2" id="atthcFilVw" >
   							</td>
   							<td>
   							<button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'knldPolicy', '*')">첨부파일등록</button></td>
   						</tr>
						</tbody>
				</table>
			</form>
			</br>
		<div class="LblockButton top mt0">
					<button type="button" id="butSave">저장</button>
					<button type="button" id="butDel">삭제</button>
					<button type="button" id="butList" onClick="fncList();">목록</button>
				</div>
		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->




</body>
</html>
				 