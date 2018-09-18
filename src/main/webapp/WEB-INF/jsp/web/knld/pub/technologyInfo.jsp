<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: TechnologyInfo.jsp
 * @desc    : 시장기술정보 상세조회
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.09.11  		     최초생성
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

	var techInfoDataSet;
	var techId = ${inputData.techId};
	var setTechnologyInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId ;
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T01");

		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/
            <%-- DATASET --%>
            techInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'techInfoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                      { id: 'techId' }       //시장기술정보ID
                    , { id: 'titlNm' }       //제목
                    , { id: 'techScnCd' }  //시장기술정보구분코드
                    , { id: 'techScnNm' }  //시장기술정보구분코드내용
                    , { id: 'infoPrvnKindCd' }  //시장기술정보 출처구분코드
                    , { id: 'infoPrvnKindNm' }  //시장기술정보 출처구분코드내용
                    , { id: 'infoPrvnNm' }  //시장기술정보 출처내용
                    , { id: 'sbcNm' }     //내용
                    , { id: 'keywordNm' }  //키워드
                    , { id: 'attcFilId' }  //첨부파일ID
                    , { id: 'rgstId' }     //등록자ID
                    , { id: 'rgstNm' }     //등록자
                    , { id: 'frstRgstDt' }     //등록일
                ]
            });

            techInfoDataSet.on('load', function(e) {
//             	var sbcNm = techInfoDataSet.getNameValue(0, "sbcNm").replaceAll('\n', '<br/>');
//             	techInfoDataSet.setNameValue(0, 'sbcNm', sbcNm);

                lvAttcFilId = techInfoDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

              //등록자와 사용자가 다를때 수정/삭제버튼 가리기
                pRgstId = techInfoDataSet.getNameValue(0, "rgstId");

                if(pRgstId == userId || roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
                	chkUserRgst(false);
                }
            });

            /* [DataSet] bind */
            var techInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: techInfoDataSet,
                bind: true,
                bindInfo: [
                      { id: 'techId',         ctrlId: 'techId',           value: 'value' }    //시장기술정보 ID
                    , { id: 'techScnCd',      ctrlId: 'techScnCd',        value: 'value' }    //구분코드
                    , { id: 'techScnNm',      ctrlId: 'techScnNm',        value: 'html' }     //구분코드 내용
                    , { id: 'infoPrvnKindCd', ctrlId: 'infoPrvnKindCd',   value: 'value' }    //출처구분코드
                    , { id: 'infoPrvnKindNm', ctrlId: 'infoPrvnKindNm',   value: 'html' }     //출처구분코드 내용
                    , { id: 'infoPrvnNm',     ctrlId: 'infoPrvnNm',       value: 'html' }     //출처 내용
                    , { id: 'titlNm',         ctrlId: 'titlNm',           value: 'html' }     //제목
                    , { id: 'sbcNm',          ctrlId: 'sbcNm',            value: 'html' }    //내용
                    , { id: 'keywordNm',      ctrlId: 'keywordNm',        value: 'html' }     //키워드
                    , { id: 'rgstNm',         ctrlId: 'rgstNm',           value: 'html' }     //등록자
                    , { id: 'frstRgstDt',     ctrlId: 'frstRgstDt',       value: 'html' }     //등록일
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
                	techInfoDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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

            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'titlNm',				validExp: '제목:true:maxByteLength=100' },
                { id: 'techScnCd',			validExp: '분류:true' }
                ]
            });

           /* 상세내역 가져오기 */
            getTechnologyInfo = function() {
           	 techInfoDataSet.load({
                    url: '<c:url value="/knld/pub/getTechnologyInfo.do"/>',
                    params :{
                    	techId : techId
                    }
                });
            };

            getTechnologyInfo();

             /* [버튼] 저장 */
            techRgstSave = function() {
          	   var record = techInfoDataSet.getAt(techInfoDataSet.getRow());
         	   document.aform.techId.value = record.get("techId");
         	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/knld/pub/technologyRgst.do'/>");
             };

             /* [버튼] 삭제 */
            techRgstDel = function() {
                fncDeleteTechnologyInfo();
            };

    		/* [버튼] 목록 */
            goTechnologyList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveTechnologyList.do"/>');
            };

            /* 수정/삭제버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
       	 	butGoList = new Rui.ui.LButton('butGoList');

       	    saveBtn.on('click', function() {
       	    	techRgstSave();
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		techRgstDel();
		    	}
		     });

		    butGoList.on('click', function() {
		    	goTechnologyList();
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
   	 * FUNCTION 명 : fncDeleteTechnologyInfo (시장/기술정보 삭제)
   	 * FUNCTION 기능설명 : 시장/기술정보 삭제
   	 *******************************************************************************/--%>
	    fncDeleteTechnologyInfo = function(){

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/knld/pub/deleteTechnologyInfo.do'/>",
    	        dataSets:[techInfoDataSet],
    	        params: {
    	            techId : techId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = techInfoDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveTechnologyList.do'/>");
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
		<input type="hidden" id="techId" name="techId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
	        	</a>    
 				<h2>시장기술정보</h2>
 			</div>
	 		<div class="sub-content">
				<div class="titArea btn_top">
					<div class="LblockButton">	   
						<button type="button" id="saveBtn"   name="saveBtn">수정</button>
						<button type="button" id="delBtn"    name="delBtn">삭제</button>
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
   							<th align="right">제목</th>
   							<td>
   								<span id="titlNm"></span>
   							</td>
   						    <th align="right">분류</th>
   							<td>
   								<span id="techScnNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">정보출처종류</th>
   							<td>
   								<span id="infoPrvnKindNm"></span>
   							</td>
   							<th align="right">정보출처명</th>
   							<td>
   								<span id="infoPrvnNm"></span>
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