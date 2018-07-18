<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: SaftyRgst.jsp
 * @desc    : 안전환경보건 등록
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
	var saftyRgstDataSet;
	var vm;			//  Validator
	var setSaftyInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId;
	var gvSbcNm = "";

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var titlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'titlNm',
                width: 700
            });

            var sftEnvScnCd = new Rui.ui.form.LCombo({
                applyTo: 'sftEnvScnCd',
                name: 'sftEnvScnCd',
                useEmptyText: true,
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                listPosition: 'up',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=SFT_ENV_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

           /* 개정내역
           var rfrmSbc = new Rui.ui.form.LTextArea({
                applyTo: 'rfrmSbc',
                width: 1000,
                height: 200
            });
           */

//             var sbcNm = new Rui.ui.form.LTextArea({
//                 applyTo: 'sbcNm'
//                 //width: 1000,
//                 //height: 200
//             });

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
// 				defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
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
            saftyRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'saftyRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'saftyId' }          /*안전환경보건ID*/
					, { id: 'titlNm' }           /*제목*/
					, { id: 'sftEnvScnCd' }      /*구분코드*/
					, { id: 'sftEnvScnNm' }      /*구분이름*/
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

            saftyRgstDataSet.on('load', function(e) {
            	lvAttcFilId = saftyRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

//                 var sbcNm = saftyRgstDataSet.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//                 saftyRgstDataSet.setNameValue(0, 'sbcNm', sbcNm);

                if(saftyRgstDataSet.getNameValue(0, "saftyId")  != "" ||  saftyRgstDataSet.getNameValue(0, "saftyId")  !=  undefined ){
    				document.aform.Wec.value=saftyRgstDataSet.getNameValue(0, "sbcNm");
    			}
            });

            /* [DataSet] bind */
            var saftyRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: saftyRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'saftyId',        ctrlId: 'saftyId',         value: 'value' }
                    , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'value' }
                    , { id: 'sftEnvScnCd',    ctrlId: 'sftEnvScnCd',     value: 'value' }
                    , { id: 'enfcDt',         ctrlId: 'enfcDt',          value: 'value' }
                    //, { id: 'rfrmSbc',        ctrlId: 'rfrmSbc',         value: 'value' } //개정내역
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
                	saftyRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            saftyRgstSave = function() {
                fncInsertSaftyInfo();
            };

    		/* [버튼] 목록 */
            goSaftyList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveSaftyList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		saftyRgstSave();
// 		    	}
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goSaftyList();
		    	}
		     });

		    createNamoEdit('Wec', '100%', 400, 'namoHtml_DIV');

        });//onReady 끝

		<%--/*******************************************************************************
		 * FUNCTION 명 : validation
		 * FUNCTION 기능설명 : 입력 데이터셋 점검
		 *******************************************************************************/--%>

		 /*유효성 검사 validation*/
         vm = new Rui.validate.LValidatorManager({
             validators:[
            	 { id: 'titlNm',      validExp: '제목:true:maxByteLength=400'},
             	 { id: 'sftEnvScnCd', validExp: '구분:true' },
             	 { id: 'enfcDt',      validExp: '시행일:true' },
    	 		 { id: 'keywordNm',   validExp: '키워드:false:maxByteLength=100' }
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
			var saftyId = '${inputData.saftyId}';

	    	if(pageMode == 'V'){

	             /* 상세내역 가져오기 */
	             getSaftyInfo = function() {
	            	 saftyRgstDataSet.load({
	                     url: '<c:url value="/knld/pub/getSaftyInfo.do"/>',
	                     params :{
	                    	 saftyId : saftyId
	                     }
	                 });
	             };

	             getSaftyInfo();


	    	}else if(pageMode == 'C')	{
	    		saftyRgstDataSet.newRecord();
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertSaftyInfo (안전환경보건 저장)
	     * FUNCTION 기능설명 : 안전환경보건 저장
	     *******************************************************************************/--%>
	    fncInsertSaftyInfo = function(){
	    	var pageMode = '${inputData.pageMode}';
	    	console.log('fncInsertSaftyInfo pageMode='+pageMode);

	    	document.aform.Wec.CleanupOptions = "msoffice | empty | comment";
	    	document.aform.Wec.value =document.aform.Wec.CleanupHtml(document.aform.Wec.value);

	    	saftyRgstDataSet.setNameValue(0, 'sbcNm', document.aform.Wec.bodyValue);
            gvSbcNm = document.aform.Wec.bodyValue ;

			document.aform.sbcNm.value = document.aform.Wec.MIMEValue;

	    	// 데이터셋 valid
			if(!validation('aform')){
	   		return false;
	   		}

			// 데이터셋 valid
			if(!validation('aform')){
	   		return false;
	   		}

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertSaftyInfo.do'/>",
		    	        dataSets:[saftyRgstDataSet],
		    	        params: {
		    	        	saftyId : document.aform.saftyId.value
		    	        	,sbcNm : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertSaftyInfo.do'/>",
		    	        dataSets:[saftyRgstDataSet],
		    	        params: {
		    	        	sbcNm : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = saftyRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveSaftyList.do'/>");

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
		<input type="hidden" id="saftyId" name="saftyId" value=""/>
		<input type="hidden" id="sbcNm" name="sbcNm" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	 				<h2>안전/환경/보건 등록</h2>
	 			</div>
				<div class="LblockButton top">
					<button type="button" id="saveBtn"   name="saveBtn">저장</button>
					<button type="button" id="butGoList" name="butGoList">목록</button>
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
   								<div id="sftEnvScnCd"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>시행일</th>
   							<td>
   								<input type="text" id="enfcDt" />
   							</td>
   						</tr>
   						<!--
   						<tr>
    						<th align="right">개정내역</th>
   							<td colspan="3">
   								 <textarea id="rfrmSbc"></textarea>
   							</td>
   						</tr>
   						-->
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
<!--    								 <textarea id="sbcNm"></textarea> -->
								<div id="namoHtml_DIV"></div>
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