<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlQnaInfo.jsp
 * @desc    : 분석QnA 상세조회
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

	var anlQnaInfoDataSet;
	var bbsId = ${inputData.bbsId};
	var bbsCd = '${inputData.bbsCd}';
	var target = '${inputData.target}';
	var userId = '${inputData._userId}';
	var roleId = '${inputData._roleId}';
	var lvAttcFilId ;
	var vm;			//  Validator
	var roleIdIndex = roleId.indexOf("WORK_IRI_T06");

		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/
            var aform = new Rui.ui.form.LForm('aform');

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
            anlQnaInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'anlQnaInfoDataSet',
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

            anlQnaInfoDataSet.on('load', function(e) {
//             	var sbcNm = anlQnaInfoDataSet.getNameValue(0, "bbsSbc").replaceAll('\n', '<br/>');
//             	anlQnaInfoDataSet.setNameValue(0, 'bbsSbc', sbcNm);

                lvAttcFilId = anlQnaInfoDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                //등록자와 사용자가 다를때 수정/삭제버튼 가리기
                pRgstId = anlQnaInfoDataSet.getNameValue(0, "rgstId");

                if(roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
	                if(pRgstId == userId) {
	                	chkUserRgst(true);
	                } else {
	                	chkUserRgst(false);
	                }
                }

                //분석담당자일때만 답변 버튼 보이기
                if(roleIdIndex != -1 ) {
                	chkUserAns(true);
                } else {
                	chkUserAns(false);
                }
            });

            /* [DataSet] bind */
            var anlQnaInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: anlQnaInfoDataSet,
                bind: true,
                bindInfo: [
                    { id: 'bbsId',          ctrlId: 'bbsId',           value: 'value'} //분석Q&AID
                  , { id: 'bbsTitl',        ctrlId: 'bbsTitl',         value: 'html' } //분석Q&A명
                  , { id: 'qnaClCd',        ctrlId: 'qnaClCd',         value: 'value'} //구분코드
                  , { id: 'qnaClNm',        ctrlId: 'qnaClNm',         value: 'html' } //구분이름
                  , { id: 'rltdBulPath',    ctrlId: 'rltdBulPath',     value: 'html' } //관련글
                  , { id: 'bbsSbc',         ctrlId: 'bbsSbc',          value: 'html' } //내용
                  , { id: 'attcFilId',      ctrlId: 'attcFilId',       value: 'html' } //첨부파일
                  , { id: 'bbsKwd',         ctrlId: 'bbsKwd',          value: 'html' } //키워드
                  , { id: 'rgstId',         ctrlId: 'rgstId',          value: 'value'} //등록자ID
                  , { id: 'rgstNm',         ctrlId: 'rgstNm',          value: 'html' } //등록자
                  , { id: 'frstRgstDt',     ctrlId: 'frstRgstDt',      value: 'html' } //등록일

              ]
            });

            <%--덧글 DATASET --%>
            anlQnaRebInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'anlQnaRebInfoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'rebId' }            /*덧글ID*/
					, { id: 'bbsId' }            /*분석Q&AID*/
					, { id: 'rebNm' }            /*덧글내용*/
					, { id: 'rgstId' }           /*등록자ID*/
					, { id: 'rgstNm' }           /*등록자이름*/
					, { id: 'delYn' }            /*삭제여부*/
					, { id: 'frstRgstDt' }       /*등록일*/
				 ]
            });
			/* 덧글 그리드 리스트 */
            getAnlQnaRebInfoList = function() {
            	anlQnaRebInfoDataSet.load({
                    url: '<c:url value="/anl/bbs/getAnlQnaRebList.do"/>',
                    params :{
                    	bbsId : bbsId
                    }
                });
            }

            getAnlQnaRebInfoList();

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

            anlQnaRebGrid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: anlQnaRebInfoDataSet,
                width: 600,
                height: 200,
                autoToEdit: true,
                autoWidth: true
            });

            //덧글수정하기위해 셀 클릭 가능여부
            anlQnaRebGrid.on('beforeEdit', function(e) {
            	if(roleIdIndex != -1) {
            		return true;
            	}else {
	            	if(anlQnaRebInfoDataSet.getNameValue(e.row, 'rgstId') != '${inputData._userId}') {
	            		return false;
	            	}
            	}

            });

            anlQnaRebGrid.render('anlQnaRebGrid');


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
                	anlQnaInfoDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            	var row = anlQnaRebInfoDataSet.getRow();
        	    var record = anlQnaRebInfoDataSet.getAt(row);
           	    var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

            	if(rebMode == "U"){
            		if(roleIdIndex == -1 && anlQnaRebInfoDataSet.getNameValue(row, 'rgstId') != '${inputData._userId}') {
                		return false;
                	}else if(roleIdIndex != -1 || anlQnaRebInfoDataSet.getNameValue(row, 'rgstId') == '${inputData._userId}') {

	            		if(anlQnaRebInfoDataSet.isUpdated() == false){
	            			Rui.alert("변경된 내용이 없습니다.");
	            			return ;
	            		}

	                    if(confirm("수정하시겠습니까?")){
		    	    		//update
		    	    		dm1.updateDataSet({
		    	    	        url: "<c:url value='/anl/bbs/updateAnlQnaRebInfo.do'/>",
		    	    	        dataSets: [anlQnaRebInfoDataSet]
		    	    	    });

	            		 }
                	}

    	    	}else if(rebMode == "C"){

    	    		if(!validation('aform')){
    	    	   		return false;
    	    	   	}

	   	    		if(confirm("등록하시겠습니까?")){
	    	   		dm1.updateDataSet({
	    	    	       url: "<c:url value='/anl/bbs/insertAnlQnaRebInfo.do'/>",
	    	    	       params: {
	    	    	       	bbsId : document.aform.bbsId.value
	    	    	         , rebNm : rebNm.getValue()
	    	    	       }
	    	    	   });
	   	    		}
    	        }

    	    	dm1.on('success', function(e) {
    				var resultData = anlQnaRebInfoDataSet.getReadData(e);
    	            alert(resultData.records[0].rtnMsg);

    	            rebNm.setValue('');

    	            getAnlQnaRebInfoList();

    			});

    			dm1.on('failure', function(e) {
    				ruiSessionFail(e);

    				var record = anlQnaInfoDataSet.getAt(anlQnaInfoDataSet.getRow());
    				record.set("rebNm",record.get("rebNm"));
    			});
            };


            /* 덧글 삭제 */
            qnaRebDel = function() {
            	var row = anlQnaRebInfoDataSet.getRow();
        	    var record = anlQnaRebInfoDataSet.getAt(row);

            	if(roleIdIndex == -1 && anlQnaRebInfoDataSet.getNameValue(row, 'rgstId') != '${inputData._userId}') {
            		return false;
            	}else if(roleIdIndex != -1 || anlQnaRebInfoDataSet.getNameValue(row, 'rgstId') == '${inputData._userId}') {

	                $('#rebId').val(record.get("rebId"));

	        	    var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	        	    if(confirm("삭제하시겠습니까?")){
			       		dm1.updateDataSet({
			       	        url: "<c:url value='/anl/bbs/deleteAnlQnaRebInfo.do'/>",
			       	        params: {
			       	        	rebId : document.aform.rebId.value
			       	        }
			   	    	});
	        	    }

		   	    	dm1.on('success', function(e) {
		   				var resultData = anlQnaRebInfoDataSet.getReadData(e);
		   	            alert(resultData.records[0].rtnMsg);

		   	        	getAnlQnaRebInfoList();
		   			});

		   			dm1.on('failure', function(e) {
		   				ruiSessionFail(e);
		   			});
            	}

	        };

	        /* [버튼] 수정 */
            qnaRgstSave = function() {
         	   var record = anlQnaInfoDataSet.getAt(anlQnaInfoDataSet.getRow());
        	   document.aform.bbsId.value = record.get("bbsId");
        	   document.aform.bbsCd.value = record.get("bbsCd");
        	   document.aform.target.value =  target;
        	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlQnaRgst.do'/>");
            };

            /* [버튼] 삭제 */
            qnaRgstDel = function() {
                fncDeleteAnlQnaInfo();
            };

    		/* [버튼] 목록 */
    		/*
            goQnaList = function() {
            	$(location).attr('href', '<c:url value="/anl/bbs/retrieveAnlQnaList.do"/>');
            };
            */

            /* [버튼] 목록 */
            goPage = function(target, bbsCd) {
            	$('#bbsId').val('');
            	$('#bbsCd').val(bbsCd);
            	$('#target').val(target);
            	tabUrl = "<c:url value='/anl/bbs/anlQnaTab.do'/>";
                nwinsActSubmit(document.aform, tabUrl, target);
            };

            /* [버튼] 답변 */
         	qnaRgstAns = function(){
        	  var record = anlQnaInfoDataSet.getAt(anlQnaInfoDataSet.getRow());
        	  document.aform.bbsId.value = record.get("bbsId");
       	   	  document.aform.pageMode.value = 'A';
	          nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlQnaRgst.do'/>");

            };

            /* 상세내역 가져오기 */
       	 	anlQnaInfoDataSet.load({
                url: '<c:url value="/anl/bbs/getAnlQnaInfo.do"/>',
                params :{
                	bbsId : bbsId
                }
            });

            /* 수정/삭제버튼 */
       	    rebBtn = new Rui.ui.LButton('rebBtn');  //답변
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
       	    goPageBtn = new Rui.ui.LButton('goPageBtn');
       	 	//butGoList = new Rui.ui.LButton('butGoList');

       	    rebBtn.on('click', function() {
       	    	qnaRgstAns();
		     });

       	    saveBtn.on('click', function() {
		    	qnaRgstSave();
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		qnaRgstDel();
		    	}
		     });

		    /*
		    butGoList.on('click', function() {
		    	goQnaList();
		     });
		    */

		    goPageBtn.on('click', function() {
		    	goPage(target, bbsCd);
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
            }

		 //분석담당자만 답변 버튼 보이기
           chkUserAns = function(display){
		    	 if(display) {
		    		 rebBtn.show();
	 	         }else {
	 	        	 rebBtn.hide();
	 	         }
           }

        	chkUserRgst(false);
        	chkUserAns(false);

        }); //onReady 끝

<%--/*******************************************************************************
* FUNCTION 명 : 덧글 validation
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
		 		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('<br>') );
		 		return false;
		 	}

		 	return true;
		 }


<%--/*******************************************************************************
 * FUNCTION 명 : fncDeleteAnlQnaInfo (분석QnA 삭제)
 * FUNCTION 기능설명 : 분석QnA 삭제
 *******************************************************************************/--%>
	    fncDeleteAnlQnaInfo = function(){
	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/anl/bbs/deleteAnlQnaInfo.do'/>",
    	        dataSets:[anlQnaInfoDataSet],
    	        params: {
    	        	bbsId : bbsId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = anlQnaRebInfoDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	//nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/retrieveAnlQnaList.do'/>");
	  	    	goPage(target, bbsCd)

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
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="target" name="target" value=""/>
		<input type="hidden" id="rebId" name="rebId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value=""/>
		<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>

			<div class="titArea">
				<div class="LblockButton">
					<button type="button" id="rebBtn"    name="rebBtn"    >답변</button>
					<button type="button" id="saveBtn"   name="saveBtn"   >수정</button>
					<button type="button" id="delBtn"    name="delBtn"    >삭제</button>
					<button type="button" id="goPageBtn" name="goPageBtn" >목록</button>
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
   							<th align="right">제목</th>
   							<td colspan="3">
   								<span id="bbsTitl"></span>
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
    					<th align="right">개요</th>
   							<td colspan="3">
   								<span id="bbsSbc"></span>
   							</td>
   						</tr>
    					<tr>
   							<th align="right">키워드</th>
   							<td colspan="3">
   								<span id="bbsKwd"></span>
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
				<div id="anlQnaRebGrid"></div>

	  </form>
    </body>
</html>