<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: ConferenceRgst.jsp
 * @desc    : 학회/컨퍼런스 등록
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
<style>
	div.L-combo-list-wrapper {max-height: 100px;}
</style>

	<script type="text/javascript">
	var conferenceRgstDataSet;
	var vm;			//  Validator
	var setConferenceInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var titlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'titlNm',
                width: 400
            });


            var cfrnLocScnCd = new Rui.ui.form.LCombo({
                applyTo: 'cfrnLocScnCd',
                name: 'cfrnLocScnCd',
                useEmptyText: true,
                emptyText: '(선택)',
                defaultValue: '',
                emptyValue: '',
                listPosition: 'up',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=CFRN_LOC_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            var keywordNm = new Rui.ui.form.LTextBox({
            	applyTo: 'keywordNm',
                width: 700
            });

        	/** dateBox **/
			var cfrnStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'cfrnStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: new Date(),
// 				defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
				width: 100,
				dateType: 'string'
			});

			cfrnStrtDt.on('blur', function(){
				if(Rui.isEmpty(cfrnStrtDt.getValue())) return;

				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(cfrnStrtDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					cfrnStrtDt.setValue(new Date());
				}

            	if(!Rui.isEmpty(cfrnFnhDt.getValue())) {
                	var startDt = cfrnStrtDt.getValue().replace(/\-/g, "").toDate();
                	var fnhDt   = cfrnFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    cfrnStrtDt.setValue("");
	                    return;
	                }
            	}
			});

			var cfrnFnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'cfrnFnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			cfrnFnhDt.on('blur', function(){
				if(Rui.isEmpty(cfrnFnhDt.getValue())) return;

				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(cfrnFnhDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					cfrnFnhDt.setValue(new Date());
				}

	            if(!Rui.isEmpty(cfrnStrtDt.getValue())) {
	                var startDt = cfrnStrtDt.getValue().replace(/\-/g, "").toDate();
	                var fnhDt   = cfrnFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    cfrnFnhDt.setValue("");
	                    return;
	                }
	            }
			});


            <%-- DATASET --%>
            conferenceRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'conferenceRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'conferenceId' }     /*학회컨퍼런스ID*/
					, { id: 'titlNm' }           /*제목*/
					, { id: 'cfrnLocScnCd' }     /*장소코드*/
					, { id: 'cfrnLocScnNm' }     /*장소이름*/
					, { id: 'cfrnStrtDt' }       /*시작일*/
					, { id: 'cfrnFnhDt' }        /*종료일*/
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

            conferenceRgstDataSet.on('load', function(e) {
            	lvAttcFilId = conferenceRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                if(conferenceRgstDataSet.getNameValue(0, "conferenceId")  != "" ||  conferenceRgstDataSet.getNameValue(0, "conferenceId")  !=  undefined ){
                	CrossEditor.SetBodyValue( conferenceRgstDataSet.getNameValue(0, "sbcNm") );
    			}
            });

            /* [DataSet] bind */
            var conferenceRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: conferenceRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'conferenceId',   ctrlId: 'conferenceId',    value: 'value' }
                    , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'value' }
                    , { id: 'cfrnLocScnCd',   ctrlId: 'cfrnLocScnCd',    value: 'value' }
                    , { id: 'cfrnStrtDt',     ctrlId: 'cfrnStrtDt',      value: 'value' }
                    , { id: 'cfrnFnhDt',      ctrlId: 'cfrnFnhDt',       value: 'value' }
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
                	conferenceRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            conferenceRgstSave = function() {
                fncInsertConferenceInfo();
            };

    		/* [버튼] 목록 */
            goConferenceList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveConferenceList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		conferenceRgstSave();
// 		    	}
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goConferenceList();
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
            	{ id: 'titlNm',       validExp: '학회/컨퍼런스명:true:maxByteLength=400'},
            	{ id: 'cfrnLocScnCd', validExp: '장소:true' },
            	{ id: 'cfrnStrtDt',   validExp: '시작일:true' },
            	{ id: 'cfrnFnhDt',    validExp: '종료일:true' },
        		{ id: 'keywordNm',    validExp: '키워드:false:maxByteLength=100' }
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
			var conferenceId = '${inputData.conferenceId}';

	    	if(pageMode == 'V'){

	             /* 상세내역 가져오기 */
	             getConferenceInfo = function() {
	            	 conferenceRgstDataSet.load({
	                     url: '<c:url value="/knld/pub/getConferenceInfo.do"/>',
	                     params :{
	                    	 conferenceId : conferenceId
	                     }
	                 });
	             };

	             getConferenceInfo();


	    	}else if(pageMode == 'C')	{
	    		conferenceRgstDataSet.newRecord();
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertConferenceInfo (학회/컨퍼런스 저장)
	     * FUNCTION 기능설명 : 학회/컨퍼런스 저장
	     *******************************************************************************/--%>
	    fncInsertConferenceInfo = function(){
	    	var pageMode = '${inputData.pageMode}';

            conferenceRgstDataSet.setNameValue(0, 'sbcNm', CrossEditor.GetBodyValue());

	    	// 데이터셋 valid
			if(!validation('aform')){
	   		return false;
	   		}

			// 에디터 valid
			if( conferenceRgstDataSet.getNameValue(0, "sbcNm") == "<p><br></p>" || conferenceRgstDataSet.getNameValue(0, "sbcNm") == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert("내용 : 필수 입력 항목 입니다.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}
			
	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
	    		if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertConferenceInfo.do'/>",
		    	        dataSets:[conferenceRgstDataSet],
		    	        params: {
		    	        	conferenceId : document.aform.conferenceId.value
		    	        	,sbcNm : conferenceRgstDataSet.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertConferenceInfo.do'/>",
	 	    	        dataSets:[conferenceRgstDataSet],
	 	    	       	params: {
		    	        	sbcNm : conferenceRgstDataSet.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = conferenceRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveConferenceList.do'/>");

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
		<input type="hidden" id="conferenceId" name="conferenceId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">   			
	   			<div class="titleArea">
	   				<a class="leftCon" href="#">
				        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				        <span class="hidden">Toggle 버튼</span>
					</a>
	 				<h2>학회/컨퍼런스 등록</h2>
	 			</div>
	 			
	 			<div class="sub-content">
   					<div class="titArea btn_top">
						<div class="LblockButton"> 
		   					<button type="button" id="saveBtn"   name="saveBtn" >저장</button>
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
   							<th align="right"><span style="color:red;">* </span>학회/컨퍼런스명</th>
   							<td>
   								<input type="text" id="titlNm" value="">
   							</td>
   						    <th align="right"><span style="color:red;">* </span>장소</th>
   							<td>
   								<div id="cfrnLocScnCd"></div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>시작일</th>
   							<td>
   								<input type="text" id="cfrnStrtDt" />
   							</td>
   							<th align="right"><span style="color:red;">* </span>종료일</th>
   							<td>
   								<input type="text" id="cfrnFnhDt" />
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
										CrossEditor.params.Font = fontParam;
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