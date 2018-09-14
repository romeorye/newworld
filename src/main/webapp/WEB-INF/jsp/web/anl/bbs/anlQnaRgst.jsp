<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlQnaRgst.jsp
 * @desc    : 분석Q&A 등록
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
	var anlQnaRgstDataSet;
	var vm;			//  Validator
	var userId = '${inputData._userId}';
	var bbsCd = '${inputData.bbsCd}';
	var target = '${inputData.target}';
	var pageMode = '${inputData.pageMode}';
	var attcFilId;
	var lvAttcFilId;
	var gvSbcNm = "";

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var aform = new Rui.ui.form.LForm('aform');

            var bbsTitl = new Rui.ui.form.LTextBox({
            	applyTo: 'bbsTitl',
                width: 500
            });

            var bbsKwd = new Rui.ui.form.LTextBox({
            	applyTo: 'bbsKwd',
                width: 500
            });
            
            var bbsSbc = new Rui.ui.form.LTextArea({
                applyTo: 'bbsSbc'
            });
            
            if(target == 'tabContentIfrm0' && pageMode == 'C'){
	            var anlBbsCd = new Rui.ui.form.LCombo({
	                applyTo: 'anlBbsCd',
	                name: 'anlBbsCd',
	                useEmptyText: true,
	                emptyText: '선택',
	                defaultValue: '',
	                emptyValue: '',
	                listPosition: 'up',
	                expandCount: 5,
	                url: '<c:url value="/anl/bbs/anlBbsCodeList.do?comCd=ANL_BBS_CD&gubun=QNA"/>',
	                displayField: 'COM_DTL_NM',
	                valueField: 'COM_DTL_CD'
	            });
            }

            <%-- DATASET --%>
            anlQnaRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'anlQnaRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
				fields: [
					       { id: 'bbsId'}                     /*게시판ID*/
						 , { id: 'bbsCd' }                    /*분석게시판코드*/
						 , { id: 'bbsNm' }                    /*게시판명*/
						 , { id: 'rltdBulPath' }              /*댓글ID*/
						 , { id: 'bbsTitl' }                  /*제목*/
						 , { id: 'bbsSbc' }                   /*내용*/
						 , { id: 'docNo' }                    /*문서번호*/
						 , { id: 'anlBbsCd' }                 /*SOP번호*/
						 , { id: 'anlTlcgClCd' }              /*분석기술정보분류코드*/
						 , { id: 'anlTlcgClNm' }              /*분석기술정보분류코드이름*/
						 , { id: 'qnaClCd' }                  /*질문답변구분코드*/
						 , { id: 'qnaClNm' }                  /*질문답변구분코드이름*/
						 , { id: 'rtrvCt' }                   /*조회수*/
						 , { id: 'bbsKwd' }                   /*키워드*/
						 , { id: 'attcFilId' }                /*첨부파일*/
						 , { id: 'rgstId' }                   /*등록자ID*/
						 , { id: 'rgstNm' }                   /*등록자이름*/
						 , { id: 'delYn' }                    /*삭제여부*/
						 , { id: 'frstRgstDt' }               /*등록일*/
						 , { id: 'depth', type:'number' }
					]
            });

            anlQnaRgstDataSet.on('load', function(e) {

            	lvAttcFilId = anlQnaRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                if(anlQnaRgstDataSet.getNameValue(0, "bbsId")  != "" ||  anlQnaRgstDataSet.getNameValue(0, "bbsId")  !=  undefined ){
    				CrossEditor.SetBodyValue( anlQnaRgstDataSet.getNameValue(0, "bbsSbc") );
    			}
            });

            /* [DataSet] bind */
            var anlQnaRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: anlQnaRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'bbsId',      ctrlId: 'bbsId',      value: 'value'}
                    , { id: 'bbsCd',      ctrlId: 'bbsCd',      value: 'value'}
                    , { id: 'anlBbsCd',   ctrlId: 'anlBbsCd',   value: 'value'}
                    , { id: 'bbsNm',      ctrlId: 'bbsNm',      value: 'value'}
                    , { id: 'bbsTitl',    ctrlId: 'bbsTitl',    value: 'value'}
                    , { id: 'bbsSbc',     ctrlId: 'bbsSbc',     value: 'value'}
                    , { id: 'attcFilId',  ctrlId: 'attcFilId',  value: 'value'}
                    , { id: 'bbsKwd',     ctrlId: 'bbsKwd',     value: 'value'}
                    , { id: 'qnaClCd',    ctrlId: 'qnaClCd',    value: 'value'}
                    , { id: 'qnaClNm',    ctrlId: 'qnaClNm',    value: 'html' }
                    , { id: 'rgstNm',     ctrlId: 'rgstNm',     value: 'html' }     //등록자
                    , { id: 'frstRgstDt', ctrlId: 'frstRgstDt', value: 'html' }     //등록일

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
            	console.log(attcFilId);
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

                if(attachFileList.length > 0) {
	                for(var i = 0; i < attachFileList.length; i++) {
	                    $('#attchFileView').append($('<a/>', {
	                        href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
	                        text: attachFileList[i].data.filNm
	                    })).append('<br/>');
	                }
	
	                if(Rui.isEmpty(lvAttcFilId)) {
	                	lvAttcFilId =  attachFileList[0].data.attcFilId;
	                	anlQnaRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
	                }
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
            anlQnaRgstSave = function() {
                fncInsertAnlQnaInfo();
            };

    		/* [버튼] 목록 */
            goAnlQnaList = function() {
            	$(location).attr('href', '<c:url value="/anl/bbs/retrieveAnlQnaList.do"/>');
            };
            
            /* [버튼] 목록 */
            goPage = function(target, bbsCd) {
            	$('#bbsCd').val(bbsCd);
            	$('#target').val(target);
            	tabUrl = "<c:url value='/anl/bbs/anlQnaTab.do'/>";
                nwinsActSubmit(document.aform, tabUrl, target);
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            //butGoList = new Rui.ui.LButton('butGoList');
            goPageBtn = new Rui.ui.LButton('goPageBtn');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		anlQnaRgstSave();
// 		    	}
		     });
		    /*
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goAnlQnaList();
		    	}
		     });
		    */
		    goPageBtn.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goPage(target, bbsCd);
		    	}
		     });

		    //createNamoEdit('Wec', '100%', 400, 'namoHtml_DIV');

        });//onReady 끝

		<%--/*******************************************************************************
		 * FUNCTION 명 : validation
		 * FUNCTION 기능설명 : 입력 데이터셋 점검
		 *******************************************************************************/--%>

		  /*유효성 검사 validation*/
        vm = new Rui.validate.LValidatorManager({
            validators:[
           		{ id: 'bbsTitl',    validExp: '제목:true:maxByteLength=400' },
           		{ id: 'anlBbsCd',   validExp: '구분:true:maxByteLength=400' },
            	{ id: 'bbsKwd',   	validExp: '키워드:false:maxByteLength=100' }
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
			var bbsId = '${inputData.bbsId}';
			var bbsCd = '${inputData.bbsCd}';

	    	if(pageMode == 'V'){

	             /* 상세내역 가져오기 */
	             getAnlQnaInfo = function() {
	            	 anlQnaRgstDataSet.load({
	                     url: '<c:url value="/anl/bbs/getAnlQnaInfo.do"/>',
	                     params :{
	                    	 bbsId : bbsId
	                     }
	                 });
	             };

	             getAnlQnaInfo();

	    	}else if(pageMode == 'C')	{
	    		anlQnaRgstDataSet.newRecord();
	    		anlQnaRgstDataSet.setNameValue(0, 'bbsCd', bbsCd);
	    		anlQnaRgstDataSet.setNameValue(0, 'bbsNm', 'Q&A');
	    		anlQnaRgstDataSet.setNameValue(0, 'qnaClCd', 'Q');
	    		anlQnaRgstDataSet.setNameValue(0, 'qnaClNm', '질문');
	    	}else if(pageMode == 'A') {
	    		anlQnaRgstDataSet.newRecord();

	    		anlQnaRgstDataSet.setNameValue(0, 'rltdBulPath', '${inputData.bbsId}');
	    		anlQnaRgstDataSet.setNameValue(0, 'bbsCd', bbsCd);
	    		anlQnaRgstDataSet.setNameValue(0, 'bbsNm', 'Q&A');
	    		anlQnaRgstDataSet.setNameValue(0, 'qnaClCd', 'A');
	    		anlQnaRgstDataSet.setNameValue(0, 'qnaClNm', '답변');
	    	}

		 }//function 끝

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertAnlQnaInfo (분석QnA 저장)
	     * FUNCTION 기능설명 : 분석QnA 저장
	     *******************************************************************************/--%>
	    fncInsertAnlQnaInfo = function(){
	    	var pageMode = '${inputData.pageMode}';
	    	console.log('fncInsertAnlQnaInfo pageMode='+pageMode);

	    	anlQnaRgstDataSet.setNameValue(0, 'bbsSbc', CrossEditor.GetBodyValue());

			document.aform.bbsSbc.value = CrossEditor.GetBodyValue();
			
            gvSbcNm = CrossEditor.GetBodyValue();

	    	// 데이터셋 valid
			if(!validation('aform')){
	   			return false;
	   		}

			// 에디터 valid
     		if(CrossEditor.GetBodyValue()=="" || CrossEditor.GetBodyValue()=="<p><br></p>"){
     		    alert("개요내용을 입력해 주세요!!");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/anl/bbs/insertAnlQnaInfo.do'/>",
		    	        dataSets:[anlQnaRgstDataSet],
		    	        params: {
		    	        	bbsId : document.aform.bbsId.value
		    	        	,bbsSbc :document.aform.bbsSbc.value
		    	        }
		    	    });
		    	}else if(pageMode == 'C' || pageMode == 'A'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/anl/bbs/insertAnlQnaInfo.do'/>",
		    	        dataSets:[anlQnaRgstDataSet],
		    	        params: {
		    	        	bbsSbc : document.aform.bbsSbc.value
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = anlQnaRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	//nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/retrieveAnlQnaList.do'/>");
	  	    	goPage(target, bbsCd);

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
		<input type="hidden" id="bbsId" name="bbsId" value=""/>
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="target" name="target" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>

  				<div class="titArea">
					<div class="LblockButton">
						<button type="button" id="saveBtn"   name="saveBtn"   >저장</button>
						<button type="button" id="goPageBtn" name="goPageBtn">목록</button>
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
   							<th align="right"><span style="color:red;">* </span>제목</th>
   							<td colspan="3">
   								<input type="text" id="bbsTitl" />
   							</td>
   						</tr>

   						<tr>
   							<th align="right"><span style="color:red;">* </span>구분</th>
   							
   							<c:if test="${inputData.target == 'tabContentIfrm0' && inputData.pageMode == 'C'}">
	   							<td>
	   								<div id="anlBbsCd"></div>
	   							</td>
   							</c:if>
   							<c:if test="${(inputData.bbsCd == '11' && inputData.target == 'tabContentIfrm0' && inputData.pageMode != 'C') || 
   							               inputData.target == 'tabContentIfrm1'}">
	   							<td>
	   								<label>기기분석 </label>
	   							</td>
   							</c:if>
   							<c:if test="${(inputData.bbsCd == '12' && inputData.target == 'tabContentIfrm0' && inputData.pageMode != 'C') || 
   							               inputData.target == 'tabContentIfrm2'}">
	   							<td>
	   								<label>신뢰성시험</label>
	   							</td>
   							</c:if>
   							<c:if test="${(inputData.bbsCd == '13' && inputData.target == 'tabContentIfrm0' && inputData.pageMode != 'C') || 
   							               inputData.target == 'tabContentIfrm3'}">
	   							<td>
	   								<label>공간평가</label>
	   							</td>
   							</c:if>
   							</td>
   						    <th align="right">조회수</th>
   							<td>

   							</td>
   						</tr>
   						   												
						<tr>
							<th  align="right"><span style="color:red;">* </span>개요</th>
							<td colspan="3">
								<textarea id="bbsSbc" name="bbsSbc"></textarea>
									<script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('bbsSbc');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										CrossEditor.params.ImageSavePath = "/iris/resource/fileupload/mchn";
										CrossEditor.params.FullScreen = false;
										CrossEditor.params.Height = 400;
										CrossEditor.EditorStart();
										
										function OnInitCompleted(e){
											e.editorTarget.SetBodyValue(document.getElementById("bbsSbc").value);
										}
									</script>
							</td>
						</tr>
    					<tr>
   							<th align="right">키워드</th>
   							<td colspan="3">
   								<input type="text" id="bbsKwd" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">첨부파일</th>
   							<td colspan="2" id="attchFileView" >
   							</td>
   							<td>
   							<button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'anlPolicy', '*')">첨부파일등록</button></td>
   						</tr>
   					</tbody>
   				</table>


		</form>
    </body>
</html>