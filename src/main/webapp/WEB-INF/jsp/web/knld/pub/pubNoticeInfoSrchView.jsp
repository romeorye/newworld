<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: pwiImtrInfo.jsp
 * @desc    : 공지사항 상세조회
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.07.25  민길문		최초생성
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

	var dataSet01;
	var pwiId = ${inputData.pwiId};
	var setpwImtrInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId ;

		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/
            var aform = new Rui.ui.form.LForm('aform');

            <%-- DATASET --%>
            dataSet01 = new Rui.data.LJsonDataSet({
                id: 'dataSet01',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                      { id: 'pwiId' }        //공지사항ID
                    , { id: 'titlNm' }       //제목
                    , { id: 'pwiScnCd' }     //공지사항구분코드
                    , { id: 'ugyYn' }        //긴급일반 구분
                    , { id: 'ugyYnNm' }      //긴급일반 구분 내용
                    , { id: 'sbcNm' }        //내용
                    , { id: 'keywordNm' }    //키워드
                    , { id: 'attcFilId' }    //첨부파일ID
                    , { id: 'rgstId' }       //등록자ID
                    , { id: 'rgstNm' }       //등록자
                    , { id: 'frstRgstDt' }   //등록일
                    , { id: 'pwiScnNm' }     //공지사항구분 내용
                ]
            });

            dataSet01.on('load', function(e) {
//             	var sbcNm = dataSet01.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//             	dataSet01.setNameValue(0, 'sbcNm', sbcNm);

                lvAttcFilId = dataSet01.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

            });

            /* [DataSet] bind */
            var bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: dataSet01,
                bind: true,
                bindInfo: [
                      { id: 'pwiId',       ctrlId: 'pwiId',           value: 'value' }    //공지사항 ID
                    , { id: 'pwiScnCd',    ctrlId: 'pwiScnCd',        value: 'value' }    //구분코드
                    , { id: 'ugyYn',       ctrlId: 'ugyYn',           value: 'value' }    //긴급구분
                    , { id: 'ugyYnNm',     ctrlId: 'ugyYnNm',         value: 'html' }     //긴급구분
                    , { id: 'titlNm',      ctrlId: 'titlNm',          value: 'html' }     //제목
                    , { id: 'sbcNm',       ctrlId: 'sbcNm',           value: 'html' }    //내용
                    , { id: 'keywordNm',   ctrlId: 'keywordNm',       value: 'html' }     //키워드
                    , { id: 'rgstNm',      ctrlId: 'rgstNm',          value: 'html' }     //등록자
                    , { id: 'frstRgstDt',  ctrlId: 'frstRgstDt',      value: 'html' }     //등록일
                    , { id: 'pwiScnNm',    ctrlId: 'pwiScnNm',        value: 'html' }     //구분코드 내용
                ]
            });

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
                	dataSet01.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                }
            };


            /*첨부파일 다운로드*/
            downloadAttachFile = function(attcFilId, seq) {
                downloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
                $('#attcFilId').val(attcFilId);
                $('#seq').val(seq);
                downloadForm.submit();
            };


            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'titlNm',				validExp: '제목:true:maxByteLength=100' },
                { id: 'pwiScnCd',			validExp: '공지구분코드:true' }
                ]
            });

             /* 상세내역 가져오기 */
             getPwiImtrInfo = function() {
            	 dataSet01.load({
                     url: '<c:url value="/knld/pub/getPubNoticeInfo.do"/>',
                     params :{
                     	pwiId : pwiId
                     }
                 });
             };

             getPwiImtrInfo();



        });//onReady 끝


	</script>
    </head>

    <body>
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="pwiId" name="pwiId" value=""/>
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
    						<th align="right">구분</th>
   							<td>
   							    <span id="pwiScnNm"></span>
   							</td>
   							<th align="right">긴급여부</th>
   							<td>
   								<span id="ugyYnNm"></span>
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
   							<td colspan="3" id="attchFileView"></td>
   						</tr>
   					</tbody>

   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>