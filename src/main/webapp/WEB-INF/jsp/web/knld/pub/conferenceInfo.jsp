<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: conferenceInfo.jsp
 * @desc    : 학회/컨퍼런스 상세조회
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

	var conferenceInfoDataSet;
	var conferenceId = ${inputData.conferenceId};
	var setConferenceInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId ;
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T01");


		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/
            <%-- DATASET --%>
            conferenceInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'conferenceInfoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'conferenceId' }     /*학회컨퍼런스ID*/
					, { id: 'titlNm' }           /*제목*/
					, { id: 'cfrnLocScnCd' }     /*장소코드*/
					, { id: 'cfrnLocScnNm' }     /*장소이름*/
					, { id: 'cfrnStrtDt' }       /*시작일*/
					, { id: 'cfrnFnhDt' }        /*종료일*/
					, { id: 'sbcNm'}            /*본문내용*/
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

            conferenceInfoDataSet.on('load', function(e) {
//             	var sbcNm = conferenceInfoDataSet.getNameValue(0, "sbcNm");
//             	conferenceInfoDataSet.setNameValue(0, 'sbcNm', sbcNm);

                lvAttcFilId = conferenceInfoDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                //등록자와 사용자가 다를때 수정/삭제버튼 가리기
                pRgstId = conferenceInfoDataSet.getNameValue(0, "rgstId");

                if(pRgstId == userId || roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
                	chkUserRgst(false);
                }
            });

            /* [DataSet] bind */
            var conferenceInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: conferenceInfoDataSet,
                bind: true,
                bindInfo: [
                    { id: 'conferenceId',   ctrlId: 'conferenceId',    value: 'value'} //학회컨퍼런스ID
                  , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'html' } //학회컨퍼런스명
                  , { id: 'cfrnLocScnCd',   ctrlId: 'cfrnLocScnCd',    value: 'value'} //장소코드
                  , { id: 'cfrnLocScnNm',   ctrlId: 'cfrnLocScnNm',    value: 'html' } //장소이름
                  , { id: 'cfrnStrtDt',     ctrlId: 'cfrnStrtDt',      value: 'html' } //시작일
                  , { id: 'cfrnFnhDt',      ctrlId: 'cfrnFnhDt',       value: 'html' } //종료일
                  , { id: 'sbcNm',          ctrlId: 'sbcNm',           value: 'html'} //내용
                  , { id: 'keywordNm',      ctrlId: 'keywordNm',       value: 'html' } //키워드
                  , { id: 'attcFilId',      ctrlId: 'attcFilId',       value: 'html' } //첨부파일
                  , { id: 'rgstNm',         ctrlId: 'rgstNm',          value: 'html' } //등록자
                  , { id: 'frstRgstDt',     ctrlId: 'frstRgstDt',      value: 'html' } //등록일

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
                	conferenceInfoDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
             getConferenceInfo = function() {
            	 conferenceInfoDataSet.load({
                     url: '<c:url value="/knld/pub/getConferenceInfo.do"/>',
                     params :{
                    	 conferenceId : conferenceId
                     }
                 });
             };

             getConferenceInfo();

            /*[버튼] 저장 */
            conferenceRgstSave = function() {
         	   var record = conferenceInfoDataSet.getAt(conferenceInfoDataSet.getRow());
        	   document.aform.conferenceId.value = record.get("conferenceId");
        	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/knld/pub/conferenceRgst.do'/>");
            };

            /* [버튼] 삭제 */
           conferenceRgstDel = function() {
                fncDeleteConferenceInfo();
            };

    		/* [버튼] 목록 */
            goConferenceList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveConferenceList.do"/>');
            };


            /* 수정/삭제버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
       	 	butGoList = new Rui.ui.LButton('butGoList');

       	    saveBtn.on('click', function() {
       	    	conferenceRgstSave();
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		conferenceRgstDel();
		    	}
		     });

		    butGoList.on('click', function() {
		    	goConferenceList();
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

        	chkUserRgst(false);

        }); //onReady 끝

   	<%--/*******************************************************************************
   	 * FUNCTION 명 : fncDeleteQnaInfo (학회/컨퍼런스 삭제)
   	 * FUNCTION 기능설명 : 학회/컨퍼런스 삭제
   	 *******************************************************************************/--%>
	    fncDeleteConferenceInfo = function(){

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/knld/pub/deleteConferenceInfo.do'/>",
    	        dataSets:[conferenceInfoDataSet],
    	        params: {
    	        	conferenceId : conferenceId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = conferenceInfoDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveConferenceList.do'/>");
			});

			dm1.on('failure', function(e) {
				ruiSessionFail(e);
			});
    	}

	</script>
	<style>
	.search-toggleBtn {display : none}
	</style>
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
 				<h2>학회/컨퍼런스</h2>
 			</div>

	 		<div class="sub-content">
				<div class="titArea btn_top">
				    <div class="LblockButton">
						<button type="button" id="saveBtn"   name="saveBtn"  >수정</button>
						<button type="button" id="delBtn"    name="delBtn"   >삭제</button>
						<button type="button" id="butGoList" name="butGoList">목록</button>
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
   							<th align="right">학회/컨퍼런스명</th>
   							<td>
   								<span id="titlNm"></span>
   							</td>
   						    <th align="right">장소</th>
   							<td>
   								<span id="cfrnLocScnNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">시작일</th>
   							<td>
   								<span id="cfrnStrtDt"></span>
   							</td>
   							<th align="right">종료일</th>
   							<td>
   								<span id="cfrnFnhDt"></span>
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

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>