<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: eduInfo.jsp
 * @desc    : 교육/세미나 상세조회
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

	var eduInfoDataSet;
	var eduId = ${inputData.eduId};
	var setEduInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId ;
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T01");


		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/
            <%-- DATASET --%>
            eduInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'eduInfoDataSet',
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

            eduInfoDataSet.on('load', function(e) {
//             	var sbcNm = eduInfoDataSet.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//             	eduInfoDataSet.setNameValue(0, 'sbcNm', sbcNm);

                lvAttcFilId = eduInfoDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                //등록자와 사용자가 다를때 수정/삭제버튼 가리기
                pRgstId = eduInfoDataSet.getNameValue(0, "rgstId");

                if(pRgstId == userId || roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
                	chkUserRgst(false);
                }
            });

            /* [DataSet] bind */
            var eduInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: eduInfoDataSet,
                bind: true,
                bindInfo: [
                    { id: 'eduId',          ctrlId: 'eduId',           value: 'value'} //교육세미나ID
                  , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'html' } //교육세미나명
                  , { id: 'eduPlScnCd',     ctrlId: 'eduPlScnCd',      value: 'value'} //교육장소코드
                  , { id: 'eduPlScnNm',     ctrlId: 'eduPlScnNm',      value: 'html'} //교육장소코드
                  , { id: 'eduInstNm',      ctrlId: 'eduInstNm',       value: 'html' } //교육기관/강사명
                  , { id: 'eduStrtDt',      ctrlId: 'eduStrtDt',       value: 'html' } //교육시작일
                  , { id: 'eduFnhDt',       ctrlId: 'eduFnhDt',        value: 'html' } //교육종료일
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
                	eduInfoDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
             getEduInfo = function() {
            	 eduInfoDataSet.load({
                     url: '<c:url value="/knld/pub/getEduInfo.do"/>',
                     params :{
                     	eduId : eduId
                     }
                 });
             };

             getEduInfo();

            /* [버튼] 저장 */
            eduRgstSave = function() {
         	   var record = eduInfoDataSet.getAt(eduInfoDataSet.getRow());
        	   document.aform.eduId.value = record.get("eduId");
        	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/knld/pub/eduRgst.do'/>");
            };

            /* [버튼] 삭제 */
           eduRgstDel = function() {
                fncDeleteEduInfo();
            };

    		/* [버튼] 목록 */
            goEduList = function() {
            	//$(location).attr('href', '<c:url value="/knld/pub/retrieveEduList.do"/>');
            	nwinsActSubmit(document.searchForm, '<c:url value="/knld/pub/retrieveEduList.do"/>');
            };

            /* 수정/삭제버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
       	 	butGoList = new Rui.ui.LButton('butGoList');

       	    saveBtn.on('click', function() {
       	    	eduRgstSave();
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		eduRgstDel();
		    	}
		     });

		    butGoList.on('click', function() {
		    	goEduList();
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

        });//onReady 끝

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncDeleteEduInfo (교육/세미나 삭제)
	     * FUNCTION 기능설명 : 교육/세미나 삭제
	     *******************************************************************************/--%>
	    fncDeleteEduInfo = function(){

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/knld/pub/deleteEduInfo.do'/>",
    	        dataSets:[eduInfoDataSet],
    	        params: {
    	            eduId : eduId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = eduInfoDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveEduList.do'/>");
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
    <form name="searchForm" id="searchForm"  method="post">
		<input type="hidden" name="titlNm" value="${inputData.titlNm}"/>
		<input type="hidden" name="eduPlScnCd" value="${inputData.eduPlScnCd}"/>
		<input type="hidden" name=eduStrtDt value="${inputData.eduStrtDt}"/>
		<input type="hidden" name=eduFnhDt value="${inputData.eduFnhDt}"/>
		<input type="hidden" name=rgstNm value="${inputData.rgstNm}"/>
		<input type="hidden" name=pageNum value="${inputData.pageNum}"/>
	</form>
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="eduId" name="eduId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
		<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
	   				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	   				<span class="hidden">Toggle 버튼</span>
   				</a>
 				<h2>교육/세미나</h2>
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
   							<th align="right">교육/세미나명</th>
   							<td>
   								<span id="titlNm"></span>
   							</td>
   						    <th align="right">교육장소</th>
   							<td>
   								<span id="eduPlScnNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">교육기관/강사명</th>
   							<td>
   								<span id="eduInstNm"></span>
   							</td>
   							<th align="right">교육기간</th>
   							<td>
   								<span id="eduStrtDt"></span> ~
   								<span id="eduFnhDt"></span>

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