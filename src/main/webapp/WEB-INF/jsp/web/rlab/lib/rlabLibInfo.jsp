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

	var rlabLibDataSet;
	var bbsId = ${inputData.bbsId};
	var bbsCd = '${inputData.bbsCd}';
	var target = '${inputData.target}';
	var userId = '${inputData._userId}';
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T17");
	var lvAttcFilId ;
	var attcFilId ;

		Rui.onReady(function() {
			/*******************
             * 변수 및 객체 선언
             *******************/
            var aform = new Rui.ui.form.LForm('aform');

            <%-- DATASET --%>
            rlabLibDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabLibDataSet',
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

            rlabLibDataSet.on('load', function(e) {

                lvAttcFilId = rlabLibDataSet.getNameValue(0, "attcFilId");
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
            var anlLibInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: rlabLibDataSet,
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

                if(roleIdIndex != -1) {
	                for(var i = 0; i < attachFileList.length; i++) {
	                    $('#attchFileView').append($('<a/>', {
	                        href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
	                        text: attachFileList[i].data.filNm
	                    })).append('<br/>');
	                }
                }else {
	                for(var i = 0; i < attachFileList.length; i++) {
	                    $('#attchFileView').append($('<a/>', {
	                        //href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
	                        text: attachFileList[i].data.filNm
	                    })).append('<br/>');
	                }                	
                }

                if(Rui.isEmpty(lvAttcFilId)) {
                	lvAttcFilId =  attachFileList[0].data.attcFilId;
                	rlabLibDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
             getRlabLibInfo = function() {
            	 rlabLibDataSet.load({
                     url: '<c:url value="/rlab/lib/getRlabLibInfo.do"/>',
                     params :{
                    	 bbsId : bbsId
                     }
                 });
             };

             getRlabLibInfo();

            /* [버튼] 저장 */
            rlabLibRgstSave = function() {
         	   var record = rlabLibDataSet.getAt(rlabLibDataSet.getRow());
        	   document.aform.bbsId.value = record.get("bbsId");
        	   document.aform.bbsCd.value = record.get("bbsCd");
        	   document.aform.target.value =  target;
        	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/rlab/lib/rlabLibRgst.do'/>");
            };

            /* [버튼] 삭제 */
           rlabLibRgstDel = function() {
                fncDeleteRlabLibInfo();
            };

            /* [버튼] 목록 */
            goPage = function(target, bbsCd) {
            	$('#bbsId').val('');
            	$('#bbsCd').val(bbsCd);
            	$('#target').val(target);
            	tabUrl = "<c:url value='/rlab/lib/rlabLibTab.do'/>";
                nwinsActSubmit(document.searchForm, tabUrl, target);
            };

            /* 수정/삭제버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
       	 	goPageBtn = new Rui.ui.LButton('goPageBtn');

       	    saveBtn.on('click', function() {
       	    	rlabLibRgstSave();
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		rlabLibRgstDel();
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
	 	        	 saveBtn.hide();
	 	        	 delBtn.hide();
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
   	 * FUNCTION 명 : fncDeleteRlabLibInfo (공지사항 삭제)
   	 * FUNCTION 기능설명 : 공지사항 삭제
   	 *******************************************************************************/--%>
	    fncDeleteRlabLibInfo = function(){

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/rlab/lib/deleteRlabLibInfo.do'/>",
    	        dataSets:[rlabLibDataSet],
    	        params: {
    	        	bbsId : bbsId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = rlabLibDataSet.getReadData(e);
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
    <form name="searchForm" id="searchForm"  method="post">
		<input type="hidden" name="bbsCd" value="${inputData.bbsCd}"/>
		<input type="hidden" name="target" value="${inputData.target}"/>
		<input type="hidden" name="searchNm" value="${inputData.searchNm}"/>
		<input type="hidden" name="searchCd" value="${inputData.searchCd}"/>
		<input type="hidden" name=pageNum value="${inputData.pageNum}"/>
	</form>
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
		<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>

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

		</form>
    </body>
</html>