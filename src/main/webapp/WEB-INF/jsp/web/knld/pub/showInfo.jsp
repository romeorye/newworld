<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: showInfo.jsp
 * @desc    : 전시회 상세조회
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

	var showInfoDataSet;
	var showId = ${inputData.showId};
	var setShowInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId ;
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T01");

		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/
            <%-- DATASET --%>
            showInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'showInfoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'showId' }           /*전시회ID*/
					, { id: 'titlNm' }           /*전시회명*/
					, { id: 'swrmNatCd' }        /*개최국코드*/
					, { id: 'swrmNatNm' }        /*개최국이름*/
					, { id: 'swrmStrtDt' }       /*전시시작일*/
					, { id: 'swrmFnhDt' }        /*전시종료일*/
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

            showInfoDataSet.on('load', function(e) {
//             	var sbcNm = showInfoDataSet.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//             	showInfoDataSet.setNameValue(0, 'sbcNm', sbcNm);

                lvAttcFilId = showInfoDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                //등록자와 사용자가 다를때 수정/삭제버튼 가리기
                pRgstId = showInfoDataSet.getNameValue(0, "rgstId");

                if(pRgstId == userId || roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
                	chkUserRgst(false);
                }
            });

            /* [DataSet] bind */
            var showInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: showInfoDataSet,
                bind: true,
                bindInfo: [
                    { id: 'showId',         ctrlId: 'showId',          value: 'value'} //전시회ID
                  , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'html' } //전시회명
                  , { id: 'swrmNatCd',      ctrlId: 'swrmNatCd',       value: 'value'} //개최국코드
                  , { id: 'swrmNatNm',      ctrlId: 'swrmNatNm',       value: 'html' } //개최국이름
                  , { id: 'swrmStrtDt',     ctrlId: 'swrmStrtDt',      value: 'html' } //전시시작일
                  , { id: 'swrmFnhDt',      ctrlId: 'swrmFnhDt',       value: 'html' } //전시종료일
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
                	showInfoDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
             getShowInfo = function() {
            	 showInfoDataSet.load({
                     url: '<c:url value="/knld/pub/getShowInfo.do"/>',
                     params :{
                    	 showId : showId
                     }
                 });
             };

             getShowInfo();

            /* [버튼] 저장 */
            showRgstSave = function() {
         	   var record = showInfoDataSet.getAt(showInfoDataSet.getRow());
        	   document.aform.showId.value = record.get("showId");
        	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/knld/pub/showRgst.do'/>");
            };

            /* [버튼] 삭제 */
           showRgstDel = function() {
                fncDeleteShowInfo();
            };

    		/* [버튼] 목록 */
            goShowList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveShowList.do"/>');
            };

            /* 수정/삭제버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
       	 	butGoList = new Rui.ui.LButton('butGoList');

       	    saveBtn.on('click', function() {
       	    	showRgstSave();
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		showRgstDel();
		    	}
		     });

		    butGoList.on('click', function() {
		    	goShowList();
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
   	 * FUNCTION 명 : fncDeleteShowInfo (전시회 삭제)
   	 * FUNCTION 기능설명 : 전시회 삭제
   	 *******************************************************************************/--%>
	    fncDeleteShowInfo = function(){

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/knld/pub/deleteShowInfo.do'/>",
    	        dataSets:[showInfoDataSet],
    	        params: {
    	        	showId : showId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = showInfoDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveShowList.do'/>");
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
		<input type="hidden" id="showId" name="showId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	 				<h2>전시회</h2>
	 			</div>
				<div class="LblockButton top">
					<button type="button" id="saveBtn" name="saveBtn">수정</button>
					<button type="button" id="delBtn" name="delBtn">삭제</button>
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
   							<th align="right">전시회명</th>
   							<td>
   								<span id="titlNm"></span>
   							</td>
   						    <th align="right">개최국</th>
   							<td>
   								<span id="swrmNatNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">전시시작일</th>
   							<td>
   								<span id="swrmStrtDt"></span>
   							</td>
   							<th align="right">전시종료일</th>
   							<td>
   								<span id="swrmFnhDt"></span>
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