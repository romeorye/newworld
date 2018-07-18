<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: generalQnaInfo.jsp
 * @desc    : 일반QnA 상세조회
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.13  			최초생성
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

	var qnaInfoDataSet;
	var qnaId = ${inputData.qnaId};
	var setQnaInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId ;
	var vm;			//  Validator
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T01");

		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/

            /* 덧글 내용 */
            var textArea = new Rui.ui.form.LTextArea({
                emptyText: ''
            });

            /* 덧글 내용 */
            var rebNm = new Rui.ui.form.LTextArea({
                applyTo: 'rebNm',
                width: 800,
                // autoWidth: true,
                height: 50
            });

            <%--게시글 상세 화면 DATASET --%>
            qnaInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'qnaInfoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'qnaId' }            /*일반Q&AID*/
					, { id: 'titlNm' }           /*제목[댓글수]*/
					, { id: 'qnaClCd' }          /*구분코드*/
					, { id: 'qnaClNm' }          /*구분이름*/
					, { id: 'qustClCd' }         /*질문유형코드*/
					, { id: 'qustClNm' }         /*질문유형이름*/
					, { id: 'rltdWrtgId' }       /*댓글ID*/
					, { id: 'sbcNm' }            /*본문내용*/
					, { id: 'rtrvCnt' }          /*조회수*/
					, { id: 'keywordNm' }        /*키워드*/
					, { id: 'attcFilId' }        /*첨부파일ID*/
					, { id: 'rgstId' }           /*등록자ID*/
					, { id: 'rgstNm' }           /*등록자이름*/
					, { id: 'rgstOpsId' }        /*부서ID*/
					, { id: 'rgstOpsNm' }        /*부서ID*/
					, { id: 'delYn' }            /*삭제여부*/
					, { id: 'frstRgstDt' }       /*등록일*/
					, { id: 'depth', type:'number' }
				 ]
            });

            qnaInfoDataSet.on('load', function(e) {
//             	var sbcNm = qnaInfoDataSet.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//             	qnaInfoDataSet.setNameValue(0, 'sbcNm', sbcNm);

                lvAttcFilId = qnaInfoDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                //등록자와 사용자가 다를때 수정/삭제버튼 가리기
                pRgstId = qnaInfoDataSet.getNameValue(0, "rgstId");

                if(pRgstId == userId || roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
                	chkUserRgst(false);
                }
            });

            /* [DataSet] bind */
            var qnaInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: qnaInfoDataSet,
                bind: true,
                bindInfo: [
                    { id: 'qnaId',          ctrlId: 'qnaId',           value: 'value'} //일반Q&AID
                  , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'html' } //일반Q&A명
                  , { id: 'qnaClCd',        ctrlId: 'qnaClCd',         value: 'value'} //구분코드
                  , { id: 'qnaClNm',        ctrlId: 'qnaClNm',         value: 'html' } //구분이름
                  , { id: 'qustClCd',       ctrlId: 'qustClCd',        value: 'value'} //질문유형코드
                  , { id: 'qustClNm',       ctrlId: 'qustClNm',    	   value: 'value'} //질문유형이름
                  , { id: 'qustClNm',       ctrlId: 'qustClNmView',    value: 'html' } //질문유형이름
                  , { id: 'rltdWrtgId',     ctrlId: 'rltdWrtgId',      value: 'html' } //관련글
                  , { id: 'sbcNm',          ctrlId: 'sbcNm',           value: 'html' } //내용
                  , { id: 'keywordNm',      ctrlId: 'keywordNm',       value: 'html' } //키워드
                  , { id: 'attcFilId',      ctrlId: 'attcFilId',       value: 'html' } //첨부파일
                  , { id: 'rgstOpsId',      ctrlId: 'rgstOpsId',       value: 'value'} //등록자부서코드
                  , { id: 'rgstOpsNm',      ctrlId: 'rgstOpsNm',       value: 'html' } //등록자부서이름
                  , { id: 'rgstId',         ctrlId: 'rgstId',          value: 'value'} //등록자ID
                  , { id: 'rgstNm',         ctrlId: 'rgstNm',          value: 'html' } //등록자
                  , { id: 'frstRgstDt',     ctrlId: 'frstRgstDt',      value: 'html' } //등록일

              ]
            });

            <%--덧글 DATASET --%>
            qnaRebInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'qnaRebInfoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'rebId' }            /*덧글ID*/
					, { id: 'qnaId' }            /*일반Q&AID*/
					, { id: 'rebNm' }            /*덧글내용*/
					, { id: 'rgstId' }           /*등록자ID*/
					, { id: 'rgstNm' }           /*등록자이름*/
					, { id: 'delYn' }            /*삭제여부*/
					, { id: 'frstRgstDt' }       /*등록일*/
				 ]
            });
			/* 덧글 그리드 리스트 */
            getQnaRebInfoList = function() {
            	qnaRebInfoDataSet.load({
                    url: '<c:url value="/knld/qna/getGeneralQnaRebList.do"/>',
                    params :{
                    	qnaId : qnaId
                    }
                });
            }

            getQnaRebInfoList();

            var columnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                 	  { field: 'frstRgstDt', label: '등록일',  	sortable: false,  align:'center',  width: 120 }
                    , { field: 'rgstNm',     label: '등록자',  	sortable: false,  align:'center',  width: 120 }
                    , { field: 'rebNm',	     label: '내용',	    sortable: false,  align:'left',	   width: 800,  editable: true, editor: textArea,
                    	renderer: function(val, p, record, row, col) {
                    		return val.replaceAll('\n', '<br/>');
                    } }
                ]
            });

            qnaRebGrid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: qnaRebInfoDataSet,
                width: 600,
                height: 200,
                autoToEdit: true,
                autoWidth: true
            });

            qnaRebGrid.on('beforeEdit', function(e) {
            	if(qnaRebInfoDataSet.getNameValue(e.row, 'rgstId') != '${inputData._userId}') {
            		return false;
            	}
            });

            qnaRebGrid.render('qnaRebGrid');


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
                	qnaInfoDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                }
            };


            /*첨부파일 다운로드*/
            downloadAttachFile = function(attcFilId, seq) {
                downloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
                $('#attcFilId').val(attcFilId);
                $('#seq').val(seq);
                downloadForm.submit();
            };
            //첨부파일 끝

			/*덧글 저장 & 수정*/
            qnaRebSave = function(rebMode) {
            	var row = qnaRebInfoDataSet.getRow();
        	    var record = qnaRebInfoDataSet.getAt(row);
           	    var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

            	if(rebMode == "U"){
            		if(qnaRebInfoDataSet.getNameValue(row, 'rgstId') != '${inputData._userId}') {
    	        		return false;
    	        	}

            		if(qnaRebInfoDataSet.isUpdated() == false){
            			alert("변경된 내용이 없습니다.");
            			return ;
            		}

                    if(confirm("수정하시겠습니까?")){
	    	    		//update
	    	    		dm1.updateDataSet({
	    	    	        url: "<c:url value='/knld/qna/updateGeneralQnaRebInfo.do'/>",
	    	    	        dataSets: [qnaRebInfoDataSet]
	    	    	    });

            		 }

    	    	}else if(rebMode == "C"){
    	    		// 데이터셋 valid
        			if(!validation('aform')){
        	   		return false;
        	   		}

    	    		if(confirm("등록하시겠습니까?")){
	    	   		dm1.updateDataSet({
	    	    	       url: "<c:url value='/knld/qna/insertGeneralQnaRebInfo.do'/>",
	    	    	       params: {
	    	    	       	qnaId : document.aform.qnaId.value
	    	    	         , rebNm : rebNm.getValue()
	    	    	       }
	    	    	   });
    	    		}
    	    	}

    	    	dm1.on('success', function(e) {
    				var resultData = qnaRebInfoDataSet.getReadData(e);
    	            alert(resultData.records[0].rtnMsg);

    	            rebNm.setValue('');

    	            getQnaRebInfoList();

    			});

    			dm1.on('failure', function(e) {
    				ruiSessionFail(e);

    				var record = qnaInfoDataSet.getAt(qnaInfoDataSet.getRow());
    				record.set("rebNm",record.get("rebNm"));
    			});
            };


            /* 덧글 삭제 */
            qnaRebDel = function() {
            	var row = qnaRebInfoDataSet.getRow();
        	    var record = qnaRebInfoDataSet.getAt(row);

	           	if(qnaRebInfoDataSet.getNameValue(row, 'rgstId') != '${inputData._userId}') {
	        		return false;
	        	}

                $('#rebId').val(record.get("rebId"));

        	    var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	       		dm1.updateDataSet({
	       	        url: "<c:url value='/knld/qna/deleteGeneralQnaRebInfo.do'/>",
	       	        params: {
	       	        	rebId : document.aform.rebId.value
	       	        }
	   	    	});

	   	    	dm1.on('success', function(e) {
	   				var resultData = qnaRebInfoDataSet.getReadData(e);
	   	            alert(resultData.records[0].rtnMsg);

	   	        	getQnaRebInfoList();
	   			});

	   			dm1.on('failure', function(e) {
	   				ruiSessionFail(e);
	   			});

	        };

	        /* [버튼] 수정 */
            qnaRgstSave = function() {
         	   var record = qnaInfoDataSet.getAt(qnaInfoDataSet.getRow());
        	   document.aform.qnaId.value = record.get("qnaId");
        	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/knld/qna/generalQnaRgst.do'/>");
            };

            /* [버튼] 삭제 */
            qnaRgstDel = function() {
                fncDeleteQnaInfo();
            };

    		/* [버튼] 목록 */
            goQnaList = function() {
            	$(location).attr('href', '<c:url value="/knld/qna/retrieveGeneralQnaList.do"/>');
            };

            /* [버튼] 답변 */
         	qnaRgstAns = function(){
        	  var record = qnaInfoDataSet.getAt(qnaInfoDataSet.getRow());
        	  document.aform.qnaId.value = record.get("qnaId");
       	   	  document.aform.qustClCd.value = record.get("qustClCd");
       	   	  document.aform.qustClNm.value = record.get("qustClNm");
       	   	  document.aform.pageMode.value = 'A';
	          nwinsActSubmit(document.aform, "<c:url value='/knld/qna/generalQnaRgst.do'/>");

            };

            /* 상세내역 가져오기 */
       	 	qnaInfoDataSet.load({
                url: '<c:url value="/knld/qna/getGeneralQnaInfo.do"/>',
                params :{
                	qnaId : qnaId
                }
            });

            /* 수정/삭제버튼 */
       	    rebBtn = new Rui.ui.LButton('rebBtn');
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
       	 	butGoList = new Rui.ui.LButton('butGoList');

       	    rebBtn.on('click', function() {
       	    	qnaRgstAns();
		     });

       	    saveBtn.on('click', function() {
		    	qnaRgstSave();
             	/* Rui.confirm({
		             text: 'GRS요청을 하시겠습니까?',
		             handlerYes: function() {
		                 qnaRebSave('V');
		             },
		             handlerNo: Rui.emptyFn
		         }); */
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		qnaRgstDel();
		    	}
		     });

		    butGoList.on('click', function() {
		    	goQnaList();
		     });

		   //등록자와 사용자가 다를때 수정/삭제버튼 가리기
            chkUserRgst = function(display){
		    	 if(display) {
		    		 saveBtn.show();
		    		 delBtn.show();
	 	         }else {
	 	        	 saveBtn.hide();
	 	        	 delBtn.hide();
	 	         }
		    	 /*if(rowId != userId) {
	        		document.getElementById('saveBtn').style.display = "none";
	            	document.getElementById('delBtn').style.display = "none";
            	}
 	        	*/
            }

        	chkUserRgst(false);

        }); //onReady 끝

        <%--/*******************************************************************************
		 * FUNCTION 명 : validation
		 * FUNCTION 기능설명 : 입력 데이터셋 점검
		 *******************************************************************************/--%>

		  /*유효성 검사 validation*/
        vm = new Rui.validate.LValidatorManager({
            validators:[
            { id: 'rebNm',       validExp: '내용:true:maxByteLength=4000'}
            ]
        });


	   function validation(vForm){

		 	var vTestForm = vForm;
		 	if(vm.validateGroup(vTestForm) == false) {
		 		alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('<br>') );
		 		return false;
		 	}

		 	return true;
		 }



<%--/*******************************************************************************
 * FUNCTION 명 : fncDeleteQnaInfo (일반QnA 삭제)
 * FUNCTION 기능설명 : 일반QnA 삭제
 *******************************************************************************/--%>
	    fncDeleteQnaInfo = function(){
	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/knld/qna/deleteGeneralQnaInfo.do'/>",
    	        dataSets:[qnaInfoDataSet],
    	        params: {
    	        	qnaId : qnaId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = qnaRebInfoDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/qna/retrieveGeneralQnaList.do'/>");
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
		<input type="hidden" id="qnaId" name="qnaId" value=""/>
		<input type="hidden" id="rebId" name="rebId" value=""/>
		<input type="hidden" id="qustClCd" name="qustClCd" value=""/>
		<input type="hidden" id="qustClNm" name="qustClNm" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value=""/>
		<input type="hidden" id="rebMode"  name="rebMode"  value=""/>
		<input type="hidden" id="rgstId"  name="rgstId"  value=""/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	 				<h2>일반 Q&A</h2>
	 			</div>
				<div class="LblockButton top">
					<button type="button" id="rebBtn"    name="rebBtn"    >답변</button>
					<button type="button" id="saveBtn"   name="saveBtn"   >수정</button>
					<button type="button" id="delBtn"    name="delBtn"    >삭제</button>
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
   						    <th align="right">구분</th>
   							<td>
   								<span id="qnaClNm"></span>
   							</td>
   						    <th align="right">질문유형</th>
   							<td>
   								<span id="qustClNmView"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">제목</th>
   							<td>
   								<span id="titlNm"></span>
   							</td>
   							<th align="right">부서</th>
   							<td>
   								<span id="rgstOpsNm"></span>
   							</td>
   						</tr>
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
   						<tr>
    					<!--<th align="right">내용</th>-->
   							<td colspan="4">
   								<span id="sbcNm"></span>
   							</td>
   						</tr>
    					<tr>
   							<th align="right">키워드</th>
   							<td colspan="3">
   								<span id="keywordNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">첨부파일</th>
   							<td colspan="3" id="attchFileView" >
   							</td>
   							</tr>
   					</tbody>
   				</table>

				<br/>

				<table class="table table_txt_right">
					<tbody>
						<tr>
							<th align="right" width="15%">덧글</th>
   							<td>
   								<textarea id="rebNm"></textarea>
   							</td>
   							<td class="t_center" width="15%">
   								<a style="cursor: pointer;" onclick="qnaRebSave('C')" class="btn">등록</a>
   							</td>
						</tr>
					</tbody>
				</table>

				<br/>
				<div class="titArea">
					<div class="LblockButton">
 	   					<button type="button" class="btn"  id="saveBtn2" name="saveBtn2" onclick="qnaRebSave('U')">수정</button>
	   					<button type="button" class="btn"  id="delBtn2"  name="delBtn2"  onclick="qnaRebDel()">삭제</button>
   					</div>
   				</div>
				<div id="qnaRebGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>