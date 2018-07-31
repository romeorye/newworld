<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: AnlLibRgst.jsp
 * @desc    : 특허 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.26  			최초생성
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
	var anlLibRgstDataSet;
	var vm;			//  Validator
	var userId = '${inputData._userId}';
	var bbsCd = '${inputData.bbsCd}';
	var target = '${inputData.target}';
	var lvAttcFilId;
	var gvSbcNm = "" ;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var aform = new Rui.ui.form.LForm('aform');

            var bbsTitl = new Rui.ui.form.LTextBox({
            	applyTo: 'bbsTitl',
                width: 700
            });

//             var sopNo = new Rui.ui.form.LTextBox({
//             	applyTo: 'sopNo',
//                 width: 700
//             });

//             var docNo = new Rui.ui.form.LTextBox({
//             	applyTo: 'docNo',
//                 width: 700
//             });

//             var bbsSbc = new Rui.ui.form.LTextArea({
//                 applyTo: 'bbsSbc',
//                 width: 1000,
//                 height: 200
//             });

            var bbsKwd = new Rui.ui.form.LTextBox({
            	applyTo: 'bbsKwd',
                width: 700
            });

            if(bbsCd == '04'){
	            var anlTlcgClCd = new Rui.ui.form.LCombo({
	                applyTo: 'anlTlcgClCd',
	                name: 'anlTlcgClCd',
	                useEmptyText: true,
	                emptyText: '선택',
	                defaultValue: '',
	                emptyValue: '',
	                listPosition: 'up',
	                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ANL_TLCG_CL_CD"/>',
	                displayField: 'COM_DTL_NM',
	                valueField: 'COM_DTL_CD'
	            });
            }

            <%-- DATASET --%>
            anlLibRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'anlLibRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
		   		      { id: 'bbsId' }       /*게시판ID*/
		   			, { id: 'bbsCd' }       /*분석게시판코드*/
		   			, { id: 'bbsNm' }       /*게시판명*/
		   			, { id: 'bbsTitl'}      /*게시판제목*/
		   			, { id: 'bbsSbc' }      /*게시판내용*/
		   			, { id: 'rgstId' }      /*등록자ID*/
		   			, { id: 'rgstNm' }      /*등록자이름*/
		   			, { id: 'rtrvCt' }      /*조회건수*/
		   			, { id: 'bbsKwd' }      /*키워드*/
		   			, { id: 'attcFilId' }   /*첨부파일ID*/
		   			, { id: 'docNo' }       /*문서번호*/
		   			, { id: 'sopNo' }       /*SOP번호*/
		   			, { id: 'anlTlcgClCd' } /*분석기술정보분류코드*/
		   			, { id: 'anlTlcgClNm' } /*분석기술정보분류이름*/
		   			, { id: 'qnaClCd' }     /*질문답변구분코드*/
		   			, { id: 'qnaClNm' }     /*질문답변구분이름*/
		   			, { id: 'frstRgstDt'}   /*등록일*/
		   			, { id: 'delYn' }       /*삭제여부*/
	   	  		]
            });

            anlLibRgstDataSet.on('load', function(e) {
            	lvAttcFilId = anlLibRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

//                 var sbcNm = anlLibRgstDataSet.getNameValue(0, "bbsSbc").replaceAll('\n', '<br/>');
//                 anlLibRgstDataSet.setNameValue(0, 'bbsSbc', sbcNm);

                if(anlLibRgstDataSet.getNameValue(0, "bbsId")  != "" ||  anlLibRgstDataSet.getNameValue(0, "bbsId")  !=  undefined ){
    				document.aform.Wec.value=anlLibRgstDataSet.getNameValue(0, "bbsSbc");
    			}
            });

            /* [DataSet] bind */
            var anlLibRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: anlLibRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'bbsTitl',    ctrlId: 'bbsTitl',    value: 'value' }
                    , { id: 'bbsSbc',     ctrlId: 'bbsSbc',     value: 'value' }
                    , { id: 'docNo',      ctrlId: 'docNo',      value: 'value' }
                    , { id: 'sopNo',      ctrlId: 'sopNo',      value: 'value' }
                    , { id: 'anlTlcgClCd',ctrlId: 'anlTlcgClCd',value: 'value' }
                    , { id: 'attcFilId',  ctrlId: 'attcFilId',  value: 'value' }
                    , { id: 'bbsKwd',     ctrlId: 'bbsKwd',     value: 'value' }
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
                	anlLibRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            anlLibRgstSave = function() {
                fncInsertAnlLibInfo();
            };

//     		/* [버튼] 목록 */
//             goAnlLibList = function() {
//             	$(location).attr('href', '<c:url value="/anl/lib/retrieveAnlLibList.do"/>'+"?bbsCd="+bbsCd);
//             };

            /* [버튼] 목록 */
            goPage = function(target, bbsCd) {
            	$('#bbsCd').val(bbsCd);
            	$('#target').val(target);
            	tabUrl = "<c:url value='/anl/lib/anlLibTab.do'/>";
                nwinsActSubmit(document.aform, tabUrl, target);
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
//             butGoList = new Rui.ui.LButton('butGoList');
       	 	goPageBtn = new Rui.ui.LButton('goPageBtn');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		anlLibRgstSave();
// 		    	}
		     });

// 		    butGoList.on('click', function() {
// 		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
// 		    		goAnlLibList();
// 		    	}
// 		     });

		    goPageBtn.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goPage(target, bbsCd);
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
            	{ id: 'bbsTitl',    validExp: '제목:true:maxByteLength=400' },
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
	             getAnlLibInfo = function() {
	            	 anlLibRgstDataSet.load({
	                     url: '<c:url value="/anl/lib/getAnlLibInfo.do"/>',
	                     params :{
	                    	 bbsId : bbsId
	                     }
	                 });
	             };

	             getAnlLibInfo();


	    	}else if(pageMode == 'C')	{
	    		anlLibRgstDataSet.newRecord();

	    		anlLibRgstDataSet.setNameValue(0, 'bbsCd', bbsCd );
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertAnlLibInfo (특허 저장)
	     * FUNCTION 기능설명 : 특허 저장
	     *******************************************************************************/--%>
	    fncInsertAnlLibInfo = function(){
	    	var pageMode = '${inputData.pageMode}';
	    	console.log('fncInsertAnlNoticeInfo pageMode='+pageMode);

	    	document.aform.Wec.CleanupOptions = "msoffice | empty | comment";
	    	document.aform.Wec.value =document.aform.Wec.CleanupHtml(document.aform.Wec.value);

	    	anlLibRgstDataSet.setNameValue(0, 'bbsSbc', document.aform.Wec.bodyValue);
            gvSbcNm = document.aform.Wec.bodyValue ;

			document.aform.bbsSbc.value = document.aform.Wec.MIMEValue;

	    	// 데이터셋 valid
			if(!validation('aform')){
	   			return false;
	   		}

			// 에디터 valid
			if(gvSbcNm == "" || gvSbcNm == "<P>&nbsp;</P>"){
				alert("내용 : 필수 입력 항목 입니다.");
		   		return false;
		   	}

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/anl/lib/insertAnlLibInfo.do'/>",
		    	        dataSets:[anlLibRgstDataSet],
		    	        params: {
		    	        	bbsId : document.aform.bbsId.value
		    	        	,bbsSbc : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/anl/lib/insertAnlLibInfo.do'/>",
		    	        dataSets:[anlLibRgstDataSet],
		    	        params: {
		    	        	bbsSbc : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = anlLibRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	            //nwinsActSubmit(window.parent.document.aform, "<c:url value='/anl/lib/retrieveAnlLibList.do'/>"+"?bbsCd="+bbsCd);
	            goPage(target, bbsCd);

			});

			dm1.on('failure', function(e) {
				ruiSessionFail(e);
			});
	    }

	</script>
    </head>
    <body>
<!--    		<div class="contents" > style="padding-bottom:5px" -->
<!--    			<div class="sub-content">  style="padding-top:0" -->



	<form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>

	<form name="aform" id="aform" method="post">
		<input type="hidden" id="bbsId" name="bbsId" value=""/>
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="target" name="target" value=""/>
		<input type="hidden" id="bbsSbc" name="bbsSbc" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>

   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%"/>
						<col style="width:35%"/>
						<col style="width:15%"/>
						<col style="width:35%"/>
   					</colgroup>
					<div class="titArea">
				        <div class="LblockButton">
				            <button type="button" id="saveBtn" name="saveBtn" >저장</button>
				            <button type="button" id="goPageBtn" name="goPageBtn">목록</button>
				        </div>
				    </div>
   					<tbody>
   						<c:if test="${inputData.bbsCd=='04'}">
   						<tr>
   							<th align="right"><span style="color:red;">* </span>분류</th>
   							<td colspan="3">
   								<div id="anlTlcgClCd"></div>
   							</td>
   						</tr>
   						</c:if>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>제목</th>
   							<td colspan="3">
   								<input type="text" id="bbsTitl" value="">
   							</td>
   						</tr>
   						<c:if test="${inputData.bbsCd == '01'}">
   						<tr>
   							<th align="right"><span style="color:red;">* </span>SOP No.</th>
   							<td colspan="3">
   								<input type="text" id="sopNo" value="" style="width:300px; border:1px solid #e1e1e1;">
   							</td>
   						</tr>
   						</c:if>
   						<c:if test="${inputData.bbsCd=='02'|| inputData.bbsCd=='03'}">
   						<tr>
   							<th align="right"><span style="color:red;">* </span>문서번호</th>
   							<td colspan="3">
   								<input type="text" id="docNo" value="" style="width:300px; border:1px solid #e1e1e1;" >
   							</td>
   						</tr>
   						</c:if>
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
   							<td colspan="4">
<!--    								 <textarea id="bbsSbc"></textarea> -->
   								<div id="namoHtml_DIV"></div>
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
   							<td colspan="2" id="attchFileView">
   							</td>
   							<td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'anlPolicy', '*')">첨부파일등록</button></td>
   						</tr>
   					</tbody>
   				</table>
	   </form>
<!--    			</div>//sub-content -->
<!--    		 </div>//contents -->
    </body>
</html>