<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: ManualRgst.jsp
 * @desc    : 규정/업무Manual 등록
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
	var manualRgstDataSet;
	var vm;			//  Validator
	var setManualInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var titlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'titlNm',
                width: 700
            });

            var prcpMnlScnCd = new Rui.ui.form.LCombo({
                applyTo: 'prcpMnlScnCd',
                name: 'prcpMnlScnCd',
                useEmptyText: true,
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                listPosition: 'up',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PRCP_MNL_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            var keywordNm = new Rui.ui.form.LTextBox({
            	applyTo: 'keywordNm',
                width: 700
            });

        	/** dateBox **/
			var enfcDt = new Rui.ui.form.LDateBox({
				applyTo: 'enfcDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			enfcDt.on('blur', function(){
				if(Rui.isEmpty(enfcDt.getValue())) return;

				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(enfcDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					enfcDt.setValue(new Date());
				}

			});

            <%-- DATASET --%>
            manualRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'manualRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'manualId' }         /*규정/업무ManualID*/
					, { id: 'titlNm' }           /*제목*/
					, { id: 'prcpMnlScnCd' }     /*구분코드*/
					, { id: 'prcpMnlScnNm' }     /*구분이름*/
					, { id: 'enfcDt' }           /*시행일*/
					//, { id: 'rfrmSbc' }          /*개정내역내용*/
					, { id: 'sbcNm' }            /*본문내용*/
					, { id: 'rtrvCnt' }          /*조회수*/
					, { id: 'keywordNm' }        /*키워드*/
					, { id: 'attcFilId' }        /*첨부파일ID*/
					, { id: 'rgstId' }           /*등록자ID*/
					, { id: 'rgstNm' }           /*등록자이름*/
					, { id: 'rgstOpsId' }        /*부서ID*/
					, { id: 'delYn' }            /*삭제여부*/
					, { id: 'frstRgstDt' }       /*등록일*/
  				 ]
            });

            manualRgstDataSet.on('load', function(e) {
            	lvAttcFilId = manualRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                if(manualRgstDataSet.getNameValue(0, "manualId")  != "" ||  manualRgstDataSet.getNameValue(0, "manualId")  !=  undefined ){
                	CrossEditor.SetBodyValue( manualRgstDataSet.getNameValue(0, "sbcNm") );
    			}
            });

            /* [DataSet] bind */
            var manualRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: manualRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'manualyId',      ctrlId: 'manualId',        value: 'value' }
                    , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'value' }
                    , { id: 'prcpMnlScnCd',   ctrlId: 'prcpMnlScnCd',    value: 'value' }
                    , { id: 'enfcDt',         ctrlId: 'enfcDt',          value: 'value' }
                    , { id: 'sbcNm',          ctrlId: 'sbcNm',           value: 'value' }
                    , { id: 'keywordNm',      ctrlId: 'keywordNm',       value: 'value' }
                    , { id: 'attcFilId',      ctrlId: 'attcFilId',       value: 'value' }
                    , { id: 'rgstNm',         ctrlId: 'rgstNm',          value: 'html' }     //등록자
                    , { id: 'frstRgstDt',     ctrlId: 'frstRgstDt',      value: 'html' }     //등록일

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
                	manualRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            manualRgstSave = function() {
                fncInsertManualInfo();
            };

    		/* [버튼] 목록 */
            goManualList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveManualList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		manualRgstSave();
// 		    	}
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goManualList();
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
            	{ id: 'titlNm',       validExp: '제목:true:maxByteLength=400'},
            	{ id: 'prcpMnlScnCd', validExp: '구분:true' },
            	{ id: 'enfcDt',       validExp: '시행일:true' },
            	{ id: 'keywordNm',    validExp: '키워드:false:maxByteLength=300' }
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
			var manualId = '${inputData.manualId}';

	    	if(pageMode == 'V'){

	             /* 상세내역 가져오기 */
	             getManualInfo = function() {
	            	 manualRgstDataSet.load({
	                     url: '<c:url value="/knld/pub/getManualInfo.do"/>',
	                     params :{
	                    	 manualId : manualId
	                     }
	                 });
	             };

	             getManualInfo();


	    	}else if(pageMode == 'C')	{
	    		manualRgstDataSet.newRecord();
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertManualInfo (규정/업무Manual 저장)
	     * FUNCTION 기능설명 : 규정/업무Manual 저장
	     *******************************************************************************/--%>
	    fncInsertManualInfo = function(){
	    	var pageMode = '${inputData.pageMode}';

	    	manualRgstDataSet.setNameValue(0, 'sbcNm', CrossEditor.GetBodyValue());
	    	
	    	// 데이터셋 valid
			if(!validation('aform')){
	   			return false;
	   		}

			// 에디터 valid
			if( manualRgstDataSet.getNameValue(0, "sbcNm") == "<p><br></p>" || manualRgstDataSet.getNameValue(0, "sbcNm") == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert("내용 : 필수 입력 항목 입니다.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertManualInfo.do'/>",
		    	        dataSets:[manualRgstDataSet],
		    	        params: {
		    	        	manualId : document.aform.manualId.value
		    	        	,sbcNm : manualRgstDataSet.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertManualInfo.do'/>",
		    	        dataSets:[manualRgstDataSet],
		    	        params: {
		    	        	sbcNm : manualRgstDataSet.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = manualRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveManualList.do'/>");

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
		<input type="hidden" id="manualId" name="manualId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">   			
   			<div class="titleArea">
   				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a> 
 				<h2>규정/업무Manual 등록</h2>
 			</div>
 			
	 		<div class="sub-content">
				<div class="titArea btn_top">
					<div class="LblockButton"> 
						<button type="button" id="saveBtn"   name="saveBtn"  >저장</button>
						<button type="button" id="butGoList" name="butGoList">목록</button>
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
   								<input type="text" id="titlNm" value="">
   							</td>
   						</tr>
   						<tr>
   						    <th align="right"><span style="color:red;">* </span>구분</th>
   							<td>
   								<div id="prcpMnlScnCd"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>시행일</th>
   							<td>
   								<input type="text" id="enfcDt" />
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
   						<!--
   						<tr>
    						<th align="right">개정내역</th>
   							<td colspan="3">
   								 <textarea id="rfrmSbc"></textarea>
   							</td>
   						</tr>
   						-->
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
   							<td id="attchFileView" >
   							</td>
   							<td colspan="2">
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