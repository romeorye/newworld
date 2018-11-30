<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: generalQnaRgst.jsp
 * @desc    : 일반Q&A 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.12  			최초생성
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

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

	<script type="text/javascript">
	var qnaRgstDataSet;
	var resultDataSet; // 처리결과 호출용 데이터셋
	var vm;			//  Validator
	var setQnaInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var titlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'titlNm',
                width: 600
            });

            if('${inputData.pageMode}'=="C" || '${inputData.pageMode}'=="V"){
	            var qustClCd = new Rui.ui.form.LCombo({
	                applyTo: 'qustClCd',
	                name: 'qustClCd',
	                useEmptyText: true,
	                emptyText: '선택',
	                defaultValue: '',
	                emptyValue: '',
	                listPosition: 'up',
	                width: 200,
	                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=QUST_CL_CD"/>',
	                displayField: 'COM_DTL_NM',
	                valueField: 'COM_DTL_CD'
	            });
            }

            var keywordNm = new Rui.ui.form.LTextBox({
            	applyTo: 'keywordNm',
                width: 600
            });


            <%-- DATASET --%>
            qnaRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'qnaRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'qnaId' }            /*일반Q&AID*/
					, { id: 'titlNm' }           /*제목*/
					, { id: 'qnaClCd' }          /*구분코드*/
					, { id: 'qnaClNm' }          /*구분이름*/
					, { id: 'qustClCd' }         /*질문유형코드*/
					, { id: 'qustClNm' }         /*질문유형이름*/
					, { id: 'rltdWrtgId' }       /*댓글ID*/
					, { id: 'sbcNm' }            /*본문내용*/
					, { id: 'rtrvCnt' }          /*조회수*/
					, { id: 'keywordNm' }        /*키워드*/
					, { id: 'attcFilId' }        /*첨부파일ID*/
					, { id: 'rgstId' }           /*등록자ID*/
					, { id: 'rgstNm' }           /*등록자이름*/
					, { id: 'rgstOpsId' }        /*부서ID*/
					, { id: 'delYn' }            /*삭제여부*/
					, { id: 'frstRgstDt' }       /*등록일*/
					, { id: 'depth', type:'number' }
  				 ]
            });

            <%-- RESULT DATASET --%>
            resultDataSet = new Rui.data.LJsonDataSet({
                id: 'resultDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                      { id: 'qnaId' }   //일반Q&AID
                    , { id: 'rtnSt' }   //결과코드
                    , { id: 'rtnMsg' }  //결과메시지
                ]
            });

            qnaRgstDataSet.on('load', function(e) {
            	lvAttcFilId = qnaRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                if(qnaRgstDataSet.getNameValue(0, "qnaId")  != "" ||  qnaRgstDataSet.getNameValue(0, "qnaId")  !=  undefined ){
                	CrossEditor.SetBodyValue( qnaRgstDataSet.getNameValue(0, "sbcNm") );
    			}
            });

            /* [DataSet] bind */
            var qnaRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: qnaRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'qnaId',          ctrlId: 'qnaId',      value: 'value'}
                    , { id: 'titlNm',         ctrlId: 'titlNm',     value: 'value'}
                    , { id: 'qnaClCd',        ctrlId: 'qnaClCd',    value: 'value'}
                    , { id: 'qnaClNm',        ctrlId: 'qnaClNm',    value: 'html' }
                    , { id: 'qustClCd',       ctrlId: 'qustClCd',   value: 'value'}
                    , { id: 'qustClNm',       ctrlId: 'qustClNm',   value: 'html' }
                    , { id: 'sbcNm',          ctrlId: 'sbcNm',      value: 'value'}
                    , { id: 'keywordNm',      ctrlId: 'keywordNm',  value: 'value'}
                    , { id: 'attcFilId',      ctrlId: 'attcFilId',  value: 'value'}
                    , { id: 'rgstOpsNm',      ctrlId: 'rgstOpsNm',  value: 'html' }     //등록자 부서
                    , { id: 'rgstNm',         ctrlId: 'rgstNm',     value: 'html' }     //등록자
                    , { id: 'frstRgstDt',     ctrlId: 'frstRgstDt', value: 'html' }     //등록일

                ]
            });

    		//첨부파일 시작
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

            getAttachFileList = function() {
                attachFileDataSet.load({
                    url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                    params :{
                    	attcFilId : lvAttcFilId
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


            /* [기능] 첨부파일 등록 팝업*/
            getAttachFileId = function() {
                if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

                return lvAttcFilId;
            };

            setAttachFileInfo = function(attachFileList) {
                $('#attchFileView').html('');

                for(var i = 0; i < attachFileList.length; i++) {
                    $('#attchFileView').append($('<a/>', {
                        href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

                if(Rui.isEmpty(lvAttcFilId)) {
                	lvAttcFilId =  attachFileList[0].data.attcFilId;
                	qnaRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                }
            };

            /*첨부파일 다운로드*/
            downloadAttachFile = function(attcFilId, seq) {
                downloadForm.action = '<c:url value="/system/attach/downloadAttachFile.do"/>';
                $('#attcFilId').val(attcFilId);
                $('#seq').val(seq);
                downloadForm.submit();
            };

           	//첨부파일 끝
            fn_init();

            /* [버튼] 저장 */
            qnaRgstSave = function() {
                fncInsertQnaInfo();
            };

    		/* [버튼] 목록 */
            goQnaList = function() {
            	$(location).attr('href', '<c:url value="/knld/qna/retrieveGeneralQnaList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		qnaRgstSave();
// 		    	}
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goQnaList();
		    	}
		     });

        });//onReady 끝

		<%--/*******************************************************************************
		 * FUNCTION 명 : validation
		 * FUNCTION 기능설명 : 입력 데이터셋 점검
		 *******************************************************************************/--%>
		  /*유효성 검사 validation*/
        vm = new Rui.validate.LValidatorManager({
            validators:[
            	 { id: 'titlNm',      validExp: '제목:true:maxByteLength=400'}
            	,{ id: 'qnaClCd',     validExp: '구분:true' }
            	,{ id: 'qustClCd',    validExp: '질문유형:true' }
            	,{ id: 'keywordNm',   validExp: '키워드:false:maxByteLength=100' }
            ]
        });


	   function validation(vForm){
		 	var vTestForm = vForm;
		 	if(vm.validateGroup(vTestForm) == false) {
		 		alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('') );
		 		return false;
		 	}

		 	return true;
		 }

		<%--/*******************************************************************************
		 * FUNCTION 명 : initialize
		 * FUNCTION 기능설명 : 초기 setting
		 *******************************************************************************/--%>
		fn_init = function(){
			var pageMode = '${inputData.pageMode}';
			var qnaId = '${inputData.qnaId}';

	    	if(pageMode == 'V'){
	             /* 상세내역 가져오기 */
	             getQnaInfo = function() {
	            	 qnaRgstDataSet.load({
	                     url: '<c:url value="/knld/qna/getGeneralQnaInfo.do"/>',
	                     params :{
	                    	 qnaId : qnaId
	                     }
	                 });
	             };
	             getQnaInfo();

	    	}else if(pageMode == 'C')	{
	    		qnaRgstDataSet.newRecord();

	    		qnaRgstDataSet.setNameValue(0, 'qnaClCd', 'Q');
	    		qnaRgstDataSet.setNameValue(0, 'qnaClNm', '질문');
	    	}else if(pageMode == 'A') {
	    		qnaRgstDataSet.newRecord();

	    		qnaRgstDataSet.setNameValue(0, 'rltdWrtgId', '${inputData.qnaId}');
	    		qnaRgstDataSet.setNameValue(0, 'qustClCd', '${inputData.qustClCd}');
	    		qnaRgstDataSet.setNameValue(0, 'qustClNm', '${inputData.qustClNm}');
	    		qnaRgstDataSet.setNameValue(0, 'qnaClCd', 'A');
	    		qnaRgstDataSet.setNameValue(0, 'qnaClNm', '답변');
	    	}

		 }//function 끝

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertQnaInfo (일반QnA 저장)
	     * FUNCTION 기능설명 : 일반QnA 저장
	     *******************************************************************************/--%>
	    fncInsertQnaInfo = function(){
	    	var pageMode = '${inputData.pageMode}';

	    	qnaRgstDataSet.setNameValue(0, 'sbcNm', CrossEditor.GetBodyValue());

	    	// 데이터셋 valid
			if(!validation('aform')){
	   		return false;
	   		}

			// 에디터 valid
			if( qnaRgstDataSet.getNameValue(0, "sbcNm") == "<p><br></p>" || qnaRgstDataSet.getNameValue(0, "sbcNm") == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert("내용 : 필수 입력 항목 입니다.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/knld/qna/insertGeneralQnaInfo.do'/>",
		    	        dataSets:[qnaRgstDataSet],
		    	        params: {
		    	        	qnaId : document.aform.qnaId.value
		    	        	,sbcNm : qnaRgstDataSet.getNameValue(0, "sbcNm") 
		    	        }
		    	    });
		    	}else if(pageMode == 'C' || pageMode == 'A'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/qna/insertGeneralQnaInfo.do'/>",
		    	        dataSets:[qnaRgstDataSet],
		    	        params: {
		    	        	sbcNm : qnaRgstDataSet.getNameValue(0, "sbcNm") 
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = resultDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/qna/retrieveGeneralQnaList.do'/>");

			});

			dm1.on('failure', function(e) {
				ruiSessionFail(e);
			});
	    }

	</script>
    </head>
    <body>
	<form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="qnaId" name="qnaId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">   			
   			<div class="titleArea">
   				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a> 
 				<h2>일반Q&A 등록</h2>
 			</div>
 			
	 		<div class="sub-content">
				<div class="titArea btn_top">
					<div class="LblockButton"> 
						<button type="button" id="saveBtn"   name="saveBtn"   >저장</button>
						<button type="button" id="butGoList" name="butGoList" >목록</button>
					</div>
				</div>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%"/>
						<col style="width:30%"/>
						<col style="width:15%"/>
						<col style="width:*"/>
   					</colgroup>

   					<tbody>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>구분</th>
   							<td>
   								<span id="qnaClNm"></span>
   							</td>
   						    <th align="right"><span style="color:red;">* </span>질문유형</th>
   							<td>
   								<c:if test="${inputData.pageMode=='C'  || inputData.pageMode == 'V'}">
   									<div id="qustClCd"></div>
   								</c:if>
   								<c:if test="${inputData.pageMode == 'A'}">
   									<span id="qustClNm"></span>
   								</c:if>
   							</td>
   						</tr>
   						<tr>
<!-- 							<th align="right">부서</th> -->
<!--    							<td> -->
<!--    								<span id="rgstOpsNm" /> -->
<!--    							</td> -->
   							<th align="right"><span style="color:red;">* </span>제목</th>
   							<td colspan="3">
   								<input type="text" id="titlNm" />
   							</td>
   						</tr>
   						<c:if test="${inputData.pageMode == 'V'}">
   						<tr>
   							<th align="right">등록자</th>
   							<td>
   								<span id="rgstNm"></span>
   							</td>
   						    <th align="right">등록일</th>
   							<td>
   								<span id="frstRgstDt"></span>
   							</td>
   						</tr>
   						</c:if>
   						<tr>
    						<!--<th align="right">내용</th> -->
   							<td colspan="4">
								<textarea id="sbcNm"></textarea>
   								<script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('sbcNm');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										CrossEditor.params.Font = fontParam;
										var uploadPath = "<%=uploadPath%>"; 
										
										CrossEditor.params.ImageSavePath = uploadPath+"/knld";
										CrossEditor.params.FullScreen = false;
										
										CrossEditor.EditorStart();
										
										function OnInitCompleted(e){
											//CrossEditor.ShowToolbar(0,0); 
											//CrossEditor.ShowToolbar(1,0);
											//CrossEditor.ShowToolbar(2,0);
											
											e.editorTarget.SetBodyValue(document.getElementById("sbcNm").value);
										}
									</script>
   							</td>
   						</tr>
    					<tr>
   							<th align="right">키워드</th>
   							<td colspan="3">
   								<input type="text" id="keywordNm" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">첨부파일</th>
   							<td colspan="2" id="attchFileView" >
   							</td>
   							<td>
   							<button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'knldPolicy', '*')">첨부파일등록</button></td>
   						</tr>
   					</tbody>
   				</table>



   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>