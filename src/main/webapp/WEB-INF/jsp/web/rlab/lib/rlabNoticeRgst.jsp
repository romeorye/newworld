<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: AnlNoticeRgst.jsp
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
	var anlNoticeRgstDataSet;
	var vm;			//  Validator
	var userId = '${inputData._userId}';
	var lvAttcFilId;
	var attcFilId;
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

//             var bbsSbc = new Rui.ui.form.LTextArea({
//                 applyTo: 'bbsSbc',
//                 width: 1000,
//                 height: 200
//             });

            var bbsKwd = new Rui.ui.form.LTextBox({
            	applyTo: 'bbsKwd',
                width: 700
            });

            <%-- DATASET --%>
            anlNoticeRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'anlNoticeRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'bbsId' }     /*게시판ID*/
					, { id: 'bbsCd' }     /*분석게시판코드*/
					, { id: 'bbsNm' }     /*게시판명*/
					, { id: 'bbsTitl'}    /*게시판제목*/
					, { id: 'bbsSbc' }    /*게시판내용*/
					, { id: 'rgstId' }    /*등록자ID*/
					, { id: 'rgstNm' }    /*등록자이름*/
					, { id: 'rtrvCt' }    /*조회건수*/
					, { id: 'bbsKwd' }    /*키워드*/
					, { id: 'attcFilId' } /*첨부파일ID*/
					, { id: 'frstRgstDt'} /*등록일*/
					, { id: 'delYn' }     /*삭제여부*/
  		]
            });

            anlNoticeRgstDataSet.on('load', function(e) {

            	lvAttcFilId = anlNoticeRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

//                 var sbcNm = anlNoticeRgstDataSet.getNameValue(0, "bbsSbc").replaceAll('\n', '<br/>');
//                 anlNoticeRgstDataSet.setNameValue(0, 'bbsSbc', sbcNm);

                if(anlNoticeRgstDataSet.getNameValue(0, "bbsId")  != "" ||  anlNoticeRgstDataSet.getNameValue(0, "bbsId")  !=  undefined ){
    				document.aform.Wec.value=anlNoticeRgstDataSet.getNameValue(0, "bbsSbc");
    			}
            });

            /* [DataSet] bind */
            var anlNoticeRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: anlNoticeRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'bbsTitl',    ctrlId: 'bbsTitl',    value: 'value' }
                    , { id: 'bbsSbc',     ctrlId: 'bbsSbc',     value: 'value' }
                    , { id: 'bbsKwd',     ctrlId: 'bbsKwd',     value: 'value' }
                    , { id: 'attcFilId',  ctrlId: 'attcFilId',  value: 'value' }
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
                	anlNoticeRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            anlNoticeRgstSave = function() {
                fncInsertAnlNoticeInfo();
            };

    		/* [버튼] 목록 */
            goAnlNoticeList = function() {
            	$(location).attr('href', '<c:url value="/anl/lib/retrievePubNoticeList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		anlNoticeRgstSave();
// 		    	}
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goAnlNoticeList();
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
		 		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('') );
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
	             getAnlNoticeInfo = function() {
	            	 anlNoticeRgstDataSet.load({
	                     url: '<c:url value="/anl/lib/getAnlNoticeInfo.do"/>',
	                     params :{
	                    	 bbsId : bbsId
	                     }
	                 });
	             };

	             getAnlNoticeInfo();


	    	}else if(pageMode == 'C')	{
	    		anlNoticeRgstDataSet.newRecord();

	    		anlNoticeRgstDataSet.setNameValue(0, 'bbsCd', '00');
	    		anlNoticeRgstDataSet.setNameValue(0, 'bbsNm', '공지사항');
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertAnlNoticeInfo (특허 저장)
	     * FUNCTION 기능설명 : 특허 저장
	     *******************************************************************************/--%>
	    fncInsertAnlNoticeInfo = function(){
	    	var pageMode = '${inputData.pageMode}';
	    	console.log('fncInsertAnlNoticeInfo pageMode='+pageMode);

	    	document.aform.Wec.CleanupOptions = "msoffice | empty | comment";
	    	document.aform.Wec.value =document.aform.Wec.CleanupHtml(document.aform.Wec.value);

	    	anlNoticeRgstDataSet.setNameValue(0, 'bbsSbc', document.aform.Wec.bodyValue);
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
		    	        url: "<c:url value='/anl/lib/insertAnlNoticeInfo.do'/>",
		    	        dataSets:[anlNoticeRgstDataSet],
		    	        params: {
		    	        	bbsId : document.aform.bbsId.value
		    	        	,bbsSbc : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/anl/lib/insertAnlNoticeInfo.do'/>",
		    	        dataSets:[anlNoticeRgstDataSet],
		    	        params: {
		    	        	bbsSbc : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = anlNoticeRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/anl/lib/retrievePubNoticeList.do'/>");

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
	 				<h2>공지사항 등록</h2>
	 			</div>

				<div class="LblockButton top">
					<button type="button" id="saveBtn" name="saveBtn" >저장</button>
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
   								<input type="text" id="bbsTitl" value="">
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
   							<td  id="attchFileView" >
   							</td>
   							<td colspan="2"><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'rlabPolicy', '*')">첨부파일등록</button></td>
   						</tr>
   					</tbody>
   				</table>



   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>