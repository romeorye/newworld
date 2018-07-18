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

            /* if('${inputData.pageMode}'=="C" || '${inputData.pageMode}'=="V"){
	            var qustClCd = new Rui.ui.form.LCombo({
	                applyTo: 'qustClCd',
	                name: 'qustClCd',
	                useEmptyText: true,
	                emptyText: '선택',
	                defaultValue: '',
	                emptyValue: '',
	                width: 200,
	                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=QUST_CL_CD"/>',
	                displayField: 'COM_DTL_NM',
	                valueField: 'COM_DTL_CD'
	            });
            } */

//             var bbsSbc = new Rui.ui.form.LTextArea({
//                 applyTo: 'bbsSbc',
//                 width: 1000,
//                 height: 200
//             });

            var bbsKwd = new Rui.ui.form.LTextBox({
            	applyTo: 'bbsKwd',
                width: 500
            });



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
						 , { id: 'sopNo' }                    /*SOP번호*/
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

//                 var sbcNm = anlQnaRgstDataSet.getNameValue(0, "bbsSbc").replaceAll('\n', '<br/>');
//                 anlQnaRgstDataSet.setNameValue(0, 'bbsSbc', sbcNm);

                if(anlQnaRgstDataSet.getNameValue(0, "bbsId")  != "" ||  anlQnaRgstDataSet.getNameValue(0, "bbsId")  !=  undefined ){
    				document.aform.Wec.value=anlQnaRgstDataSet.getNameValue(0, "bbsSbc");
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
            	$(location).attr('href', '<c:url value="/anl/lib/retrieveAnlQnaList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		anlQnaRgstSave();
// 		    	}
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goAnlQnaList();
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

	    	if(pageMode == 'V'){

	             /* 상세내역 가져오기 */
	             getAnlQnaInfo = function() {
	            	 anlQnaRgstDataSet.load({
	                     url: '<c:url value="/anl/lib/getAnlQnaInfo.do"/>',
	                     params :{
	                    	 bbsId : bbsId
	                     }
	                 });
	             };

	             getAnlQnaInfo();

	    	}else if(pageMode == 'C')	{
	    		anlQnaRgstDataSet.newRecord();
	    		anlQnaRgstDataSet.setNameValue(0, 'bbsCd', '05');
	    		anlQnaRgstDataSet.setNameValue(0, 'bbsNm', 'Q&A');
	    		anlQnaRgstDataSet.setNameValue(0, 'qnaClCd', 'Q');
	    		anlQnaRgstDataSet.setNameValue(0, 'qnaClNm', '질문');
	    	}else if(pageMode == 'A') {
	    		anlQnaRgstDataSet.newRecord();

	    		anlQnaRgstDataSet.setNameValue(0, 'rltdBulPath', '${inputData.bbsId}');
	    		anlQnaRgstDataSet.setNameValue(0, 'bbsCd', '05');
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

	    	document.aform.Wec.CleanupOptions = "msoffice | empty | comment";
	    	document.aform.Wec.value =document.aform.Wec.CleanupHtml(document.aform.Wec.value);

	    	anlQnaRgstDataSet.setNameValue(0, 'bbsSbc', document.aform.Wec.bodyValue);
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
		    	        url: "<c:url value='/anl/lib/insertAnlQnaInfo.do'/>",
		    	        dataSets:[anlQnaRgstDataSet],
		    	        params: {
		    	        	bbsId : document.aform.bbsId.value
		    	        	,bbsSbc : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}else if(pageMode == 'C' || pageMode == 'A'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/anl/lib/insertAnlQnaInfo.do'/>",
		    	        dataSets:[anlQnaRgstDataSet],
		    	        params: {
		    	        	bbsSbc : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = anlQnaRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/anl/lib/retrieveAnlQnaList.do'/>");

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
		<input type="hidden" id="bbsSbc" name="bbsSbc" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	 				<h2>분석Q&A 등록</h2>
	 			</div>
				<div class="LblockButton top">
					<button type="button" id="saveBtn"   name="saveBtn"   >저장</button>
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
   							<th align="right"><span style="color:red;">* </span>제목</th>
   							<td colspan="3">
   								<input type="text" id="bbsTitl" />
   							</td>
   						</tr>
   						<tr>
    						<!--<th align="right">내용</th> -->
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
   							<td colspan="2" id="attchFileView" >
   							</td>
   							<td>
   							<button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'anlPolicy', '*')">첨부파일등록</button></td>
   						</tr>
   					</tbody>
   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>