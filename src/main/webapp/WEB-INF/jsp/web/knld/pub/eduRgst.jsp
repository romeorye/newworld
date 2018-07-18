<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: eduRgst.jsp
 * @desc    : 교육/세미나 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.11  			최초생성
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
	var eduRgstDataSet;
	var vm;			//  Validator
	var setEduInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId;
	var gvSbcNm = "";

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var titlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'titlNm',
                width: 400
            });

            var eduInstNm = new Rui.ui.form.LTextBox({
            	applyTo: 'eduInstNm',
                width: 400
            });

            var eduPlScnCd = new Rui.ui.form.LCombo({
                applyTo: 'eduPlScnCd',
                name: 'eduPlScnCd',
                useEmptyText: true,
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                listPosition: 'up',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=EDU_PL_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

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
			var eduStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'eduStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: new Date(),
// 				defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
				width: 100,
				dateType: 'string'
			});

			eduStrtDt.on('blur', function(){
				if(Rui.isEmpty(eduStrtDt.getValue())) return;

				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(eduStrtDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					eduStrtDt.setValue(new Date());
				}

            	if(!Rui.isEmpty(eduFnhDt.getValue())) {
                	var startDt = eduStrtDt.getValue().replace(/\-/g, "").toDate();
                	var fnhDt   = eduFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    eduStrtDt.setValue("");
	                    return;
	                }
            	}
			});

			var eduFnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'eduFnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
// 				defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			eduFnhDt.on('blur', function(){
				if(Rui.isEmpty(eduFnhDt.getValue())) return;

				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(eduFnhDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					eduFnhDt.setValue(new Date());
				}

	            if(!Rui.isEmpty(eduStrtDt.getValue())) {
	                var startDt = eduStrtDt.getValue().replace(/\-/g, "").toDate();
	                var fnhDt   = eduFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    eduFnhDt.setValue("");
	                    return;
	                }
	            }

			});

            <%-- DATASET --%>
            eduRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'eduRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'eduId' }            /*교육세미나ID*/
					, { id: 'titlNm' }           /*제목*/
					, { id: 'eduPlScnCd' }       /*교육장소코드*/
					, { id: 'eduPlScnNm' }       /*교육장소이름*/
					, { id: 'eduInstNm' }        /*교육기관,강사명*/
					, { id: 'eduStrtDt' }        /*교육시작일*/
					, { id: 'eduFnhDt' }         /*교육종료일*/
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

            eduRgstDataSet.on('load', function(e) {
            	lvAttcFilId = eduRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

//                 var sbcNm = eduRgstDataSet.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//                 eduRgstDataSet.setNameValue(0, 'sbcNm', sbcNm);

                if(eduRgstDataSet.getNameValue(0, "eduId")  != "" ||  eduRgstDataSet.getNameValue(0, "eduId")  !=  undefined ){
    				document.aform.Wec.value=eduRgstDataSet.getNameValue(0, "sbcNm");
    			}
            });

            /* [DataSet] bind */
            var eduRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: eduRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'eduId',          ctrlId: 'eduId',           value: 'value' }
                    , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'value' }
                    , { id: 'eduPlScnCd',     ctrlId: 'eduPlScnCd',      value: 'value' }
                    , { id: 'eduInstNm',      ctrlId: 'eduInstNm',       value: 'value' }
                    , { id: 'eduStrtDt',      ctrlId: 'eduStrtDt',       value: 'value' }
                    , { id: 'eduFnhDt',       ctrlId: 'eduFnhDt',        value: 'value' }
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
                	eduRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            eduRgstSave = function() {
                fncInsertEduInfo();
            };

    		/* [버튼] 목록 */
            goEduList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveEduList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
// 		    	if(confirm("저장하시겠습니까?")){
		    		eduRgstSave();
// 		    	}
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goEduList();
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
	            { id: 'titlNm',     validExp: '교육/세미나명:true:maxByteLength=400'},
	            { id: 'eduPlScnCd', validExp: '교육장소:true' },
	            { id: 'eduInstNm',  validExp: '교육기관/강사명:true:maxByteLength=100' },
	            { id: 'eduStrtDt',  validExp: '교육시작일:true' },
	            { id: 'eduFnhDt',   validExp: '교육종료일:true' },
        		{ id: 'keywordNm',  validExp: '키워드:false:maxByteLength=300' }
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
			var eduId = '${inputData.eduId}';

	    	if(pageMode == 'V'){

	             /* 상세내역 가져오기 */
	             getEduInfo = function() {
	            	 eduRgstDataSet.load({
	                     url: '<c:url value="/knld/pub/getEduInfo.do"/>',
	                     params :{
	                    	 eduId : eduId
	                     }
	                 });
	             };

	             getEduInfo();


	    	}else if(pageMode == 'C')	{
	    		eduRgstDataSet.newRecord();
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertEduInfo (교육/세미나 저장)
	     * FUNCTION 기능설명 : 교육/세미나 저장
	     *******************************************************************************/--%>
	    fncInsertEduInfo = function(){
	    	var pageMode = '${inputData.pageMode}';
	    	console.log('fncInsertEduInfo pageMode='+pageMode);


	    	document.aform.Wec.CleanupOptions = "msoffice | empty | comment";
	    	document.aform.Wec.value =document.aform.Wec.CleanupHtml(document.aform.Wec.value);

	    	eduRgstDataSet.setNameValue(0, 'sbcNm', document.aform.Wec.bodyValue);
            gvSbcNm = document.aform.Wec.bodyValue ;

			document.aform.sbcNm.value = document.aform.Wec.MIMEValue;

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
		    	        url: "<c:url value='/knld/pub/insertEduInfo.do'/>",
		    	        dataSets:[eduRgstDataSet],
		    	        params: {
		    	            eduId : document.aform.eduId.value
		    	        	,sbcNm : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertEduInfo.do'/>",
		    	        dataSets:[eduRgstDataSet],
		    	        params: {
		    	        	sbcNm : document.aform.Wec.MIMEValue
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = eduRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveEduList.do'/>");

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
		<input type="hidden" id="eduId" name="eduId" value=""/>
		<input type="hidden" id="sbcNm" name="sbcNm" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	 				<h2>교육/세미나 등록</h2>
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
   							<th align="right"><span style="color:red;">* </span>교육/세미나명</th>
   							<td>
   								<input type="text" id="titlNm" value="">
   							</td>
   						    <th align="right"><span style="color:red;">* </span>교육장소</th>
   							<td>
   								<div id="eduPlScnCd"></div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>교육기관/강사명</th>
   							<td>
   								<input type="text" id="eduInstNm" value="">
   							</td>
   							<th align="right"><span style="color:red;">* </span>교육기간</th>
   							<td>
   								<input type="text" id="eduStrtDt" /><em class="gab"> ~ </em>
   								<input type="text" id="eduFnhDt" />
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
   							<td  colspan="2">
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