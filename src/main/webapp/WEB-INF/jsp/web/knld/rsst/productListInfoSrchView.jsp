<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: productListInfo.jsp
 * @desc    : 연구산출물 상세조회
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

	var prdtListInfoDataSet;
	var prdtId = ${inputData.prdtId};
	var userId = '${inputData._userId}';
	var affrClGroup = '${inputData.affrClId}';

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            <%-- DATASET --%>
            prdtListInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'prdtListInfoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'prdtId' }            /*산출물ID*/
					, { id: 'affrClId'  }         /*업무분류ID*/
					, { id: 'affrClNm'  }         /*업무분류이름*/
					, { id: 'affrClGroup'}        /*게시판분류이름*/
					, { id: 'titlNm'    }         /*제목*/
					, { id: 'sbcNm'     }         /*내용*/
					, { id: 'rtrvCnt'   }         /*조회수*/
					, { id: 'keywordNm' }         /*키워드*/
					, { id: 'attcFilId' }         /*첨부파일*/
					, { id: 'rgstId'    }         /*등록자ID*/
					, { id: 'rgstNm'    }         /*등록자*/
					, { id: 'rgstOpsId' }         /*등록자부서ID*/
					, { id: 'delYn'     }         /*삭제여부*/
					, { id: 'frstRgstDt'}         /*등록일*/
				 ]
            });

            prdtListInfoDataSet.on('load', function(e) {
//             	var sbcNm = prdtListInfoDataSet.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//             	prdtListInfoDataSet.setNameValue(0, 'sbcNm', sbcNm);

                lvAttcFilId = prdtListInfoDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

            });

            /* [DataSet] bind */
            var prdtListInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: prdtListInfoDataSet,
                bind: true,
                bindInfo: [
                    { id: 'prdtId',      ctrlId: 'prdtId',    value: 'value'} //연구산출물ID
                  , { id: 'titlNm',      ctrlId: 'titlNm',    value: 'html' } //제목
                  , { id: 'affrClNm',    ctrlId: 'affrClNm',  value: 'html' } //업무분류
                  , { id: 'sbcNm',       ctrlId: 'sbcNm',     value: 'html' } //내용
                  , { id: 'keywordNm',   ctrlId: 'keywordNm', value: 'html' } //키워드
                  , { id: 'attcFilId',   ctrlId: 'attcFilId', value: 'html' } //첨부파일
                  , { id: 'rgstNm',      ctrlId: 'rgstNm',    value: 'html' } //등록자
                  , { id: 'frstRgstDt',  ctrlId: 'frstRgstDt',value: 'html' } //등록일

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
                	prdtListInfoDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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


             /* 상세내역 가져오기 */
             getPrdtListInfo = function() {
            	 prdtListInfoDataSet.load({
                     url: '<c:url value="/knld/rsst/getProductListInfo.do"/>',
                     params :{
                    	 prdtId : prdtId
                     }
                 });
             };

             getPrdtListInfo();

        });//onReady 끝

	</script>
    </head>

    <body>
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="prdtId" name="prdtId" value=""/>
		<input type="hidden" id="affrClId" value="<c:out value='${inputData.affrClId}'/>"/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">

   			<div class="sub-content">
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
   								<span id="titlNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">업무분류</th>
   							<td colspan="3">
   								<span id="affrClNm"></span>
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
   							<td colspan="4">
   								<span id="sbcNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">키워드</th>
   							<td colspan="3">
   								<span id="sbcNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">첨부파일</th>
   							<td colspan="3" id="attchFileView">
   							</td>
   						</tr>
   					</tbody>
   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>