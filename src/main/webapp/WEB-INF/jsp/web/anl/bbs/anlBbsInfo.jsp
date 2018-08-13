<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlNoticeInfo.jsp
 * @desc    : 공지사항 상세조회
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

	var anlBbsDataSet;
	var bbsId = ${inputData.bbsId};
	var bbsCd = '${inputData.bbsCd}';
	var target = '${inputData.target}';
	var userId = '${inputData._userId}';
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T06");
	var lvAttcFilId ;
	var attcFilId ;

		Rui.onReady(function() {
			/*******************
             * 변수 및 객체 선언
             *******************/
            var aform = new Rui.ui.form.LForm('aform');

            /* 덧글 내용 */
            var textArea = new Rui.ui.form.LTextArea({
                emptyText: ''
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
	            			alert("변경된 내용이 없습니다.");
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
	    	    	         	, rebNm : $('#rebNm').val()
	    	    	       }
	    	    	   });
	   	    		}
    	        }

    	    	dm1.on('success', function(e) {
    				var resultData = anlQnaRebInfoDataSet.getReadData(e);
    	            alert(resultData.records[0].rtnMsg);

    	            $('#rebNm').val('');

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

            <%-- DATASET --%>
            anlBbsDataSet = new Rui.data.LJsonDataSet({
                id: 'anlBbsDataSet',
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

            anlBbsDataSet.on('load', function(e) {
//             	var bbsSbc = anlBbsDataSet.getNameValue(0, "bbsSbc").replaceAll('\n', '<br/>');
//             	AnlBbsDataSet.setNameValue(0, 'bbsSbc', bbsSbc);

                lvAttcFilId = anlBbsDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                //roleId가 분석담당자이면 등록자와 사용자가 달라고 수정/삭제 가능
              	//이외의 사용자는 상세회면 조회만 가능
                if(roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
                	chkUserRgst(false);
                }

                parent.bbsId = '';

            });

            /* [DataSet] bind */
            var anlBbsInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: anlBbsDataSet,
                bind: true,
                bindInfo: [
                    { id: 'bbsId',       ctrlId: 'bbsId',      value: 'value'} //공지사항ID
                  , { id: 'bbsNm',       ctrlId: 'bbsNm',      value: 'html' } //구분
                  , { id: 'bbsTitl',     ctrlId: 'bbsTitl',    value: 'html' } //제목
                  , { id: 'bbsSbc',      ctrlId: 'bbsSbc',     value: 'html' } //내용
                  , { id: 'attcFilId',   ctrlId: 'attcFilId',  value: 'html' } //첨부파일
                  , { id: 'bbsKwd',      ctrlId: 'bbsKwd',     value: 'html' } //키워드
                  , { id: 'rgstNm',      ctrlId: 'rgstNm',     value: 'html' } //등록자
                  , { id: 'frstRgstDt',  ctrlId: 'frstRgstDt', value: 'html' } //등록일
                  , { id: 'docNo',  	 ctrlId: 'docNo', 	   value: 'html' } //문서번호
                  , { id: 'rtrvCt',  	 ctrlId: 'rtrvCt', 	   value: 'html' } //조회건수

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
                	anlBbsDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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


             /* 상세내역 가져오기 */
             getAnlBbsInfo = function() {
            	 anlBbsDataSet.load({
                     url: '<c:url value="/anl/bbs/getAnlBbsInfo.do"/>',
                     params :{
                    	 bbsId : bbsId
                     }
                 });
             };

             getAnlBbsInfo();

            /* [버튼] 저장 */
            anlBbsRgstSave = function() {
         	   var record = anlBbsDataSet.getAt(anlBbsDataSet.getRow());
        	   document.aform.bbsId.value = record.get("bbsId");
        	   document.aform.bbsCd.value = record.get("bbsCd");
        	   document.aform.target.value =  target;
        	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlBbsRgst.do'/>");
            };

            /* [버튼] 삭제 */
           anlBbsRgstDel = function() {
                fncDeleteAnlBbsInfo();
            };

//     		/* [버튼] 목록 */
//             goAnlBbsList = function() {
//             	$(location).attr('href', '<c:url value="/anl/bbs/retrieveAnlBbsList.do"/>'+"?bbsCd="+bbsCd);
//             };

            /* [버튼] 목록 */
            goPage = function(target, bbsCd) {
            	$('#bbsId').val('');
            	$('#bbsCd').val(bbsCd);
            	$('#target').val(target);
            	tabUrl = "<c:url value='/anl/bbs/anlBbsTab.do'/>";
                nwinsActSubmit(document.aform, tabUrl, target);
            };

            /* 수정/삭제버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
//        	 	butGoList = new Rui.ui.LButton('butGoList');
       	 	goPageBtn = new Rui.ui.LButton('goPageBtn');

       	    saveBtn.on('click', function() {
       	    	anlBbsRgstSave();
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		anlBbsRgstDel();
		    	}
		     });

		    goPageBtn.on('click', function() {
		    	goPage(target, bbsCd);
		    });

		    // roleId가 분석담당자이면 등록자와 사용자가 달라도 수정/삭제 가능
		    //이외의 사용자는 상세보기만 가능
		    //등록자와 사용자가 다를때 수정/삭제버튼 가리기
            chkUserRgst = function(display){
		    	 if(display) {
		    		 saveBtn.show();
		    		 delBtn.show();
	 	         }else {
	 	        	 //saveBtn.hide();
	 	        	 //delBtn.hide();
	 	         }
            }

        	chkUserRgst(false);

        });//onReady 끝


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
	        	alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('<br>') );
	        	return false;
	        }
         	return true;
         }
	<%--/*******************************************************************************
   	 * FUNCTION 명 : fncDeleteAnlBbsInfo (공지사항 삭제)
   	 * FUNCTION 기능설명 : 공지사항 삭제
   	 *******************************************************************************/--%>
	    fncDeleteAnlBbsInfo = function(){

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/anl/bbs/deleteAnlBbsInfo.do'/>",
    	        dataSets:[anlBbsDataSet],
    	        params: {
    	        	bbsId : bbsId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = anlBbsDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

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
		<input type="hidden" id="rebId"  name="rebId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>

				<div class="titArea">
					<div class="LblockButton">
						<button type="button" id="saveBtn" name="saveBtn" >수정</button>
						<button type="button" id="delBtn" name="delBtn" >삭제</button>
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
   							<th align="right">구분</th>
   							<td>
   								<span id="bbsNm"></span>
   							</td>

   							<th align="right">조회수</th>
   							<td>
                            	<span id="rtrvCt"></span>
   							</td>
   						</tr>  						
   						<tr>
    					<th align="right">내용</th>
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

		</form>
    </body>
</html>