<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: prdtListRgst.jsp
 * @desc    : 연구산출물 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.14  			최초생성
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
	var prdtListRgstDataSet;
	var vm;			//  Validator
	var userId = '${inputData._userId}';
	var lvAttcFilId;
	var attcFilId = "";
	var affrClGroup = '${inputData.affrClId}';
	var callback;
	var gvSbcNm = "";
	var gvAffrNm = "";

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var titlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'titlNm',
                width: 600
            });

//             var affrClNm = new Rui.ui.form.LTextBox({
//             	applyTo: 'affrClNm',
//                 width: 500
//             });

            var keywordNm = new Rui.ui.form.LTextBox({
            	applyTo: 'keywordNm',
                width: 600
            });

            <%-- DATASET --%>
            prdtListRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'prdtListRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'prdtId' }          /*산출물ID*/
					, { id: 'affrClId' }        /*업무분류ID*/
					, { id: 'affrClNm' }        /*업무분류이름*/
					, { id: 'affrClGroup' }     /*게시판분류이름*/
					, { id: 'titlNm' }          /*제목*/
					, { id: 'sbcNm' }           /*내용*/
					, { id: 'rtrvCnt' }         /*조회수*/
					, { id: 'keywordNm' }       /*키워드*/
					, { id: 'attcFilId' }       /*첨부파일*/
					, { id: 'rgstId' }          /*등록자ID*/
					, { id: 'rgstNm' }          /*등록자*/
					, { id: 'rgstOpsId' }       /*등록자부서ID*/
					, { id: 'delYn' }           /*삭제여부*/
					, { id: 'frstRgstDt' }      /*등록일*/
  				 ]
            });

            prdtListRgstDataSet.on('load', function(e) {
            	lvAttcFilId = prdtListRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

//                 var sbcNm = prdtListRgstDataSet.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//                 prdtListRgstDataSet.setNameValue(0, 'sbcNm', sbcNm);

                if(prdtListRgstDataSet.getNameValue(0, "prdtId")  != "" ||  prdtListRgstDataSet.getNameValue(0, "prdtId")  !=  undefined ){
                	CrossEditor.SetBodyValue( prdtListRgstDataSet.getNameValue(0, "sbcNm") );
    				//document.aform.Wec.value=prdtListRgstDataSet.getNameValue(0, "sbcNm");
    				
    			}

                gvAffrNm = prdtListRgstDataSet.getNameValue(0, "affrClNm");
            });

            /* [DataSet] bind */
            var prdtListRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: prdtListRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'prdtId',      ctrlId: 'prdtId',       value: 'value' }
                    , { id: 'affrClNm',    ctrlId: 'affrClNm',     value: 'html' }
                    , { id: 'affrClGroup', ctrlId: 'affrClGroup',  value: 'value' }
                    , { id: 'titlNm',      ctrlId: 'titlNm',       value: 'value' }
                    , { id: 'sbcNm',       ctrlId: 'sbcNm',        value: 'value' }
                    , { id: 'keywordNm',   ctrlId: 'keywordNm',    value: 'value' }
                    , { id: 'attcFilId',   ctrlId: 'attcFilId',    value: 'value' }
                    , { id: 'rgstNm',      ctrlId: 'rgstNm',       value: 'html' }      //등록자
                    , { id: 'frstRgstDt',  ctrlId: 'frstRgstDt',   value: 'html' }      //등록일

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
//             	console.log(attcFilId);
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
                	prdtListRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            prdtListRgstSave = function() {
                fncInsertPrdtListInfo();
            };

    		/* [버튼] 목록 */
            goPrdtListList = function() {
            	$(location).attr('href', '<c:url value="/knld/rsst/retrieveProductList.do?affrClId="/>'+affrClGroup);
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		prdtListRgstSave();
// 		    	}
		     });

		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goPrdtListList();
		    	}
		     });

		    // 업무분류 트리 리스트 검색 팝업 시작
    	    knldAffrTreeSrhRsltDialog = new Rui.ui.LFrameDialog({
    	        id: 'knldAffrTreeSrhRsltDialog',
    	        title: '업무분류 노드 선택',
    	        width: 550,
    	        height: 550,
    	        modal: true,
    	        visible: false
    	    });

    	    knldAffrTreeSrhRsltDialog.render(document.body);

    	    openKnldAffrTreeSrhRsltDialog = function(f) {
    	    	callback = f;
    	    	var enAffrNm = escape(encodeURIComponent(gvAffrNm));
    	    	knldAffrTreeSrhRsltDialog.setUrl('<c:url value="/knld/rsst/knldAffrTreeSrhRsltPopup.do?affrClNm="/>' + enAffrNm + '&affrClGroup=' + affrClGroup);
    	    	knldAffrTreeSrhRsltDialog.show();
    	    };

		    /* 업무분류 트리 리스트 검색 팝업 */
            affrTreeSrh = function() {
            	openKnldAffrTreeSrhRsltDialog(goPrdtListList);
            };
//     	    업무분류 트리 리스트 검색 팝업 끝

//     	    트리 윈도우 팝업 시작 affrTreeSrhBtn

//     	    affrTreeSrhBtn = new Rui.ui.LButton('affrTreeSrhBtn');

//     	    affrTreeSrhBtn.on('click', function() {
//     	    	affrTreeSrh();
// 		     });

//     	    affrTreeSrh = function() {
//     	    	var enAffrNm = escape(encodeURIComponent(gvAffrNm));
//     	    	var popupUrl = '<c:url value="/knld/rsst/knldAffrTreeSrhRsltPopup.do?affrClNm="/>' + enAffrNm + '&affrClGroup=' + affrClGroup ;
//     	    	var popupOption = "width=1500, height=450, top=300, left=400";
// 				window.open(popupUrl,"",popupOption);
//     	    }

    	    // 트리 윈도우 팝업 끝
		    fnChildCall = function(affrNmParam , affrClIdParam) {
		    	prdtListRgstDataSet.setNameValue(0, 'affrClNm', affrNmParam );
		    	prdtListRgstDataSet.setNameValue(0, 'affrClId', affrClIdParam );
		    	gvAffrNm = prdtListRgstDataSet.getNameValue(0, 'affrClNm');
		    };

        });//onReady 끝

		<%--/*******************************************************************************
		 * FUNCTION 명 : validation
		 * FUNCTION 기능설명 : 입력 데이터셋 점검
		 *******************************************************************************/--%>

		  /*유효성 검사 validation*/
        vm = new Rui.validate.LValidatorManager({
            validators:[
            	{ id: 'titlNm',    validExp: '제목:true:maxByteLength=400' },
    			{ id: 'keywordNm', validExp: '키워드:false:maxByteLength=100' }
//             	,{ id: 'affrClNm', validExp: '업무분류:true:maxByteLength=100'}
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
			var prdtId = '${inputData.prdtId}';

	    	if(pageMode == 'V'){

	             /* 상세내역 가져오기 */
	             getPrdtListInfo = function() {
	            	 prdtListRgstDataSet.load({
	                     url: '<c:url value="/knld/rsst/getProductListInfo.do"/>',
	                     params :{
	                    	 prdtId : prdtId
	                     }
	                 });
	             };

	             getPrdtListInfo();


	    	}else if(pageMode == 'C')	{
	    		prdtListRgstDataSet.newRecord();

	    		prdtListRgstDataSet.setNameValue(0, 'affrClGroup', affrClGroup);
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertproductListInfo (연구산출물 저장)
	     * FUNCTION 기능설명 : 연구산출물 저장
	     *******************************************************************************/--%>
	    fncInsertPrdtListInfo = function(){
	    	var pageMode = '${inputData.pageMode}';

	    	prdtListRgstDataSet.setNameValue(0, 'sbcNm', CrossEditor.GetBodyValue());

			// 업무분류 valid
			if(gvAffrNm == "" || gvAffrNm == "<P>&nbsp;</P>"){
				alert("업무분류 : 필수 입력 항목 입니다.");
		   		return false;
		   	}

	    	// 데이터셋 valid
			if(!validation('aform')){
	   			return false;
	   		}

			// 에디터 valid
			if( prdtListRgstDataSet.getNameValue(0, "sbcNm") == "<p><br></p>" || prdtListRgstDataSet.getNameValue(0, "sbcNm") == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert("내용 : 필수 입력 항목 입니다.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}
			
			var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/knld/rsst/insertProductListInfo.do'/>",
		    	        dataSets:[prdtListRgstDataSet],
		    	        params: {
		    	        	prdtId : document.aform.prdtId.value
		    	        	,sbcNm : prdtListRgstDataSet.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/rsst/insertProductListInfo.do'/>",
		    	        dataSets:[prdtListRgstDataSet],
		    	        params: {
		    	        	sbcNm : prdtListRgstDataSet.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = prdtListRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/rsst/retrieveProductList.do?affrClId='/>"+affrClGroup);

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
		<input type="hidden" id="prdtId" name="prdtId" value=""/>
		<input type="hidden" id="affrClId" value="<c:out value='${inputData.affrClId}'/>"/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	 				<h2>연구산출물 등록</h2>
	 			</div>
				<div class="LblockButton top">
					<button type="button" id="saveBtn"   name="saveBtn" >저장</button>
					<button type="button" id="butGoList" name="butGoList" >목록</button>
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
   							<th align="right"><span style="color:red;">* </span>업무분류</th>
   							<td colspan="2">
   								<span id="affrClNm"></span>
   							</td>
   							<td>
    							<button type="button" class="icoBtn" id="affrTreeSrhBtn" name="affrTreeSrhBtn" onclick="affrTreeSrh()"></button>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>제목</th>
   							<td colspan="3">
   								<input type="text" id="titlNm" value="">
   							</td>
   						</tr>
   						<c:if test="${inputData.pageMode=='V'}">
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
   							<td  id="attchFileView">
   							</td>
   							<td colspan="2">
   							<button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'knldPolicy2', '*')">첨부파일등록</button></td>
   						</tr>
   					</tbody>
   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>