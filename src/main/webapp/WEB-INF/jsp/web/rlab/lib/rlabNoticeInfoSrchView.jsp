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
//RTRV_RQ_DOC_CD rtrvRqDocCd
	var anlSrchViewDataSet;
	var bbsId = ${inputData.bbsId};
	var bbsCd = '${inputData.bbsCd}';
	var userId = '${inputData._userId}';
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T06");
	var lvAttcFilId ;

		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/
            var aform = new Rui.ui.form.LForm('aform');

            <%-- DATASET --%>
            anlSrchViewDataSet = new Rui.data.LJsonDataSet({
                id: 'anlSrchViewDataSet',
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

            anlSrchViewDataSet.on('load', function(e) {
//             	var bbsSbc = anlSrchViewDataSet.getNameValue(0, "bbsSbc").replaceAll('\n', '<br/>');
//             	anlSrchViewDataSet.setNameValue(0, 'bbsSbc', bbsSbc);

                lvAttcFilId = anlSrchViewDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                //roleId가 분석담당자이면 등록자와 사용자가 달라고 수정/삭제 가능
              	//이외의 사용자는 상세회면 조회만 가능
               /* 
              	if(roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
                	chkUserRgst(false);
                }
 */
            });

            /* [DataSet] bind */
            var anlLibInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: anlSrchViewDataSet,
                bind: true,
                bindInfo: [
                    { id: 'bbsId',       ctrlId: 'bbsId',      value: 'value'} //공지사항ID
                  , { id: 'bbsTitl',     ctrlId: 'bbsTitl',    value: 'html' } //제목
                  , { id: 'bbsSbc',      ctrlId: 'bbsSbc',     value: 'html' } //내용
                  , { id: 'attcFilId',   ctrlId: 'attcFilId',  value: 'html' } //첨부파일
                  , { id: 'bbsKwd',      ctrlId: 'bbsKwd',     value: 'html' } //키워드
                  , { id: 'rgstNm',      ctrlId: 'rgstNm',     value: 'html' } //등록자
                  , { id: 'frstRgstDt',  ctrlId: 'frstRgstDt', value: 'html' } //등록일
                  , { id: 'docNo',  	 ctrlId: 'docNo', 	   value: 'html' } //문서번호
                  , { id: 'sopNo',  	 ctrlId: 'sopNo', 	   value: 'html' } //SOP No.
                  , { id: 'anlTlcgClNm', ctrlId: 'anlTlcgClNm',value: 'html' } //분석기술정보분류이름
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
                	anlSrchViewDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
             getAnlLibInfo = function() {
            	 anlSrchViewDataSet.load({
                     url: '<c:url value="/anl/lib/getAnlLibInfo.do"/>',
                     params :{
                    	 bbsId : bbsId
                     }
                 });
             };

             getAnlLibInfo();


        });//onReady 끝


	<%--/*******************************************************************************
   	 * FUNCTION 명 : fncDeleteAnlLibInfo (공지사항 삭제)
   	 * FUNCTION 기능설명 : 공지사항 삭제
   	 *******************************************************************************/--%>
	    fncDeleteAnlLibInfo = function(){

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/anl/lib/deleteAnlLibInfo.do'/>",
    	        dataSets:[anlSrchViewDataSet],
    	        params: {
    	        	bbsId : bbsId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = anlSrchViewDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/anl/lib/retrieveAnlLibList.do'/>"+"?bbsCd="+bbsCd);
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
		<input type="hidden" id="rebId" name="rebId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>

   		<div class="contents"> <!-- style="padding-bottom:10px" -->
   			<div class="sub-content">
				<div class="LblockButton top">
					<!-- 
					<button type="button" id="saveBtn" name="saveBtn" >수정</button>
					<button type="button" id="delBtn" name="delBtn" >삭제</button>
					<button type="button" id="butGoList" name="butGoList" >목록</button>
					 -->
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
   						<c:if test="${inputData.bbsCd == '01'}">
   						<tr>
   							<th align="right">SOP No.</th>
   							<td colspan="3">
   								<span id="sopNo"></span>
   							</td>
   						</tr>
   						</c:if>
   						<c:if test="${inputData.bbsCd=='02'|| inputData.bbsCd=='03'}">
   						<tr>
   							<th align="right">문서번호</th>
   							<td colspan="3">
   								<span id="docNo"></span>
   							</td>
   						</tr>
   						</c:if>
   						<c:if test="${inputData.bbsCd == '04'}">
   						<tr>
   							<th align="right">분류</th>
   							<td colspan="3">
   								<span id="anlTlcgClNm"></span>
   							</td>
   						</tr>
   						</c:if>
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

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
	</form>
    </body>
</html>