<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: OutSpclIdRgst.jsp
 * @desc    : 사외전문가 등록
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
	var outSpclRgstDataSet;
	var vm;			//  Validator
	var setOutSpclInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId;
	var gvSbcNm = "";

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var instNm = new Rui.ui.form.LTextBox({
            	applyTo: 'instNm',
                width: 300
            });

            var opsNm = new Rui.ui.form.LTextBox({
            	applyTo: 'opsNm',
                width: 300
            });

            var poaNm = new Rui.ui.form.LTextBox({
            	applyTo: 'poaNm',
                width: 300
            });

            var spltNm = new Rui.ui.form.LTextBox({
            	applyTo: 'spltNm',
                width: 300
            });

            var tlocNm = new Rui.ui.form.LTextBox({
            	applyTo: 'tlocNm',
                width: 300
            });

            var ccpcNo = new Rui.ui.form.LTextBox({
            	applyTo: 'ccpcNo',
                width: 300
            });

            var eml = new Rui.ui.form.LTextBox({
            	applyTo: 'eml',
                width: 300
            });

            var repnSphe = new Rui.ui.form.LTextBox({
            	applyTo: 'repnSphe',
                width: 300
            });

            var hmpg = new Rui.ui.form.LTextBox({
            	applyTo: 'hmpg',
                width: 450
            });

//             var timpCarr = new Rui.ui.form.LTextArea({
//                 applyTo: 'timpCarr'
//                 //width: 1000,
//                 //height: 200
//             });


            <%-- DATASET --%>
            outSpclRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'outSpclRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'outSpclId' }        /*사외전문가ID*/
					, { id: 'instNm'    }        /*기관명*/
					, { id: 'opsNm'     }        /*부서*/
					, { id: 'poaNm'     }        /*직위*/
					, { id: 'spltNm'    }        /*사외전문가명*/
					, { id: 'tlocNm'    }        /*소재지*/
					, { id: 'ccpcNo'    }        /*연락처*/
					, { id: 'eml'       }        /*이메일*/
					, { id: 'repnSphe'  }        /*대표분야*/
					, { id: 'hmpg'      }        /*홈페이지*/
					, { id: 'timpCarr'  }        /*주요경력*/
					, { id: 'attcFilId' }        /*정보제공동의서ID*/
					, { id: 'rgstId'    }        /*등록자ID*/
					, { id: 'rgstNm'    }        /*등록자이름*/
					, { id: 'rgstOpsId' }        /*부서ID*/
					, { id: 'delYn'     }        /*삭제여부*/
					, { id: 'frstRgstDt'}        /*등록일*/
  				 ]
            });

            outSpclRgstDataSet.on('load', function(e) {
            	lvAttcFilId = outSpclRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

//                 var timpCarr = outSpclRgstDataSet.getNameValue(0, "timpCarr").replaceAll('\n', '<br/>');
//                 outSpclRgstDataSet.setNameValue(0, 'timpCarr', timpCarr);

                if(outSpclRgstDataSet.getNameValue(0, "outSpclId")  != "" ||  outSpclRgstDataSet.getNameValue(0, "outSpclId")  !=  undefined ){
    				document.aform.Wec.value=outSpclRgstDataSet.getNameValue(0, "timpCarr");
    			}
            });

            /* [DataSet] bind */
            var outSpclRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: outSpclRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'outSpclId',      ctrlId: 'outSpclId',       value: 'value' }
                    , { id: 'instNm',         ctrlId: 'instNm',          value: 'value' }
                    , { id: 'opsNm',          ctrlId: 'opsNm',           value: 'value' }
                    , { id: 'poaNm',          ctrlId: 'poaNm',           value: 'value' }
                    , { id: 'spltNm',         ctrlId: 'spltNm',          value: 'value' }
                    , { id: 'tlocNm',         ctrlId: 'tlocNm',          value: 'value' }
                    , { id: 'ccpcNo',         ctrlId: 'ccpcNo',          value: 'value' }
                    , { id: 'eml',            ctrlId: 'eml',             value: 'value' }
                    , { id: 'repnSphe',       ctrlId: 'repnSphe',        value: 'value' }
                    , { id: 'hmpg',           ctrlId: 'hmpg',            value: 'value' }
                    , { id: 'timpCarr',       ctrlId: 'timpCarr',        value: 'value' }
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
                	outSpclRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            outSpclRgstSave = function() {
                fncInsertOutSpclInfo();
            };

    		/* [버튼] 목록 */
            goOutSpclList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveOutsideSpeciaList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		outSpclRgstSave();
// 		    	}
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goOutSpclList();
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
            	{ id: 'instNm',      validExp: '기관명:true:maxByteLength=100' },
            	{ id: 'opsNm',       validExp: '부서:true:maxByteLength=300' },
            	{ id: 'poaNm',       validExp: '직위:true:maxByteLength=50' },
            	{ id: 'spltNm',      validExp: '사외전문가명:true:maxByteLength=50' },
            	{ id: 'repnSphe',    validExp: '대표분야:true:maxByteLength=500' },
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
			var outSpclId = '${inputData.outSpclId}';

	    	if(pageMode == 'V'){

	             /* 상세내역 가져오기 */
	             getOutSpclInfo = function() {
	            	 outSpclRgstDataSet.load({
	                     url: '<c:url value="/knld/pub/getOutsideSpecialistInfo.do"/>',
	                     params :{
	                    	 outSpclId : outSpclId
	                     }
	                 });
	             };

	             getOutSpclInfo();


	    	}else if(pageMode == 'C')	{
	    		outSpclRgstDataSet.newRecord();
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertOutsideSpecialistInfo (사외전문가 저장)
	     * FUNCTION 기능설명 : 사외전문가 저장
	     *******************************************************************************/--%>
	    fncInsertOutSpclInfo = function(){
	    	var pageMode = '${inputData.pageMode}';
	    	console.log('fncInsertOutSpclInfo pageMode='+pageMode);

	    	document.aform.Wec.CleanupOptions = "msoffice | empty | comment";
	    	document.aform.Wec.value =document.aform.Wec.CleanupHtml(document.aform.Wec.value);

	    	outSpclRgstDataSet.setNameValue(0, 'timpCarr', document.aform.Wec.bodyValue);
            gvSbcNm = document.aform.Wec.bodyValue ;

			document.aform.timpCarr.value = document.aform.Wec.MIMEValue;

	    	// 데이터셋 valid
			if(!validation('aform')){
	   		return false;
	   		}

			// 에디터 valid
			if(gvSbcNm == "" || gvSbcNm == "<P>&nbsp;</P>"){
				alert("내용 : 필수 입력 항목 입니다.");
		   		return false;
		   	}
			if ( Rui.isEmpty(lvAttcFilId) ){
				alert("정보제공동의서 첨부파일은 필수입니다.");
				return;
			}

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertOutsideSpecialistInfo.do'/>",
		    	        dataSets:[outSpclRgstDataSet],
		    	        params: {
		    	        	outSpclId : document.aform.outSpclId.value
		    	        	,timpCarr : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertOutsideSpecialistInfo.do'/>",
		    	        dataSets:[outSpclRgstDataSet],
		    	        params: {
		    	        	timpCarr : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = outSpclRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveOutsideSpeciaList.do'/>");

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
		<input type="hidden" id="outSpclId" name="outSpclId" value=""/>
		<input type="hidden" id="timpCarr" name="timpCarr" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	 				<h2>사외전문가 등록</h2>
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
   							<th align="right"><span style="color:red;">* </span>기관명</th>
   							<td>
   								<input type="text" id="instNm" value="">
   							</td>
   							<th align="right"><span style="color:red;">* </span>부서</th>
   							<td>
   								<input type="text" id="opsNm" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>직위</th>
   							<td >
   								<input type="text" id="poaNm" value="">
   							</td>
   							<th align="right"><span style="color:red;">* </span>사외전문가명</th>
   							<td >
   								<input type="text" id="spltNm" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">소재지</th>
   							<td>
   								<input type="text" id="tlocNm" value="">
   							</td>
   							<th align="right">연락처</th>
   							<td>
   								<input type="text" id="ccpcNo" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">eMail</th>
   							<td>
   								<input type="text" id="eml" value="">
   							</td>
   							<th align="right"><span style="color:red;">* </span>대표분야</th>
   							<td>
   								<input type="text" id="repnSphe" value="">
   							</td>
   						</tr>
    					<tr>
   							<th align="right">홈페이지</th>
   							<td colspan="3">
   								<input type="text" id="hmpg" value="">
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
    						<!--<th align="right">주요경력</th> -->
   							<td colspan="4">
<!--    								 <textarea id="timpCarr"></textarea> -->
								<div id="namoHtml_DIV"></div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>정보제공동의서</th>
   							<td  id="attchFileView">
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