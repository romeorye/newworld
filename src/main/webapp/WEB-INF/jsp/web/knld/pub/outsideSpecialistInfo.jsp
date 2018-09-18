<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: outsideSpecialistInfo.jsp
 * @desc    : 사외전문가 상세조회
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

	var outSpclInfoDataSet;
	var outSpclId = ${inputData.outSpclId};
	var setOutSpclIdInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId ;
	var roleId = '${inputData._roleId}';
	var roleIdIndex = roleId.indexOf("WORK_IRI_T01");


		Rui.onReady(function() {

            /*******************
             * 변수 및 객체 선언
             *******************/
            <%-- DATASET --%>
            outSpclInfoDataSet = new Rui.data.LJsonDataSet({
                id: 'outSpclInfoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'outSpclId' }        /*사외전문가ID*/
					, { id: 'instNm'    }        /*기관명*/
					, { id: 'opsNm'     }        /*부서*/
					, { id: 'poaNm'     }        /*직위*/
					, { id: 'spltNm'    }        /*사외전문가명*/
					, { id: 'tlocNm'    }        /*소재지*/
					, { id: 'ccpcNo'    }        /*연락처*/
					, { id: 'eml'       }        /*이메일*/
					, { id: 'repnSphe'  }        /*대표분야*/
					, { id: 'hmpg'      }        /*홈페이지*/
					, { id: 'timpCarr'  }        /*주요경력*/
					, { id: 'attcFilId' }        /*정보제공동의서ID*/
					, { id: 'rgstId'    }        /*등록자ID*/
					, { id: 'rgstNm'    }        /*등록자이름*/
					, { id: 'rgstOpsId' }        /*부서ID*/
					, { id: 'delYn'     }        /*삭제여부*/
					, { id: 'frstRgstDt'}        /*등록일*/
				 ]
            });

            outSpclInfoDataSet.on('load', function(e) {
//             	var timpCarr = outSpclInfoDataSet.getNameValue(0, "timpCarr").replaceAll('\n', '<br/>');
//             	outSpclInfoDataSet.setNameValue(0, 'timpCarr', timpCarr);

                lvAttcFilId = outSpclInfoDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                //등록자와 사용자가 다를때 수정/삭제버튼 가리기
                pRgstId = outSpclInfoDataSet.getNameValue(0, "rgstId");

                $('#emlLink').attr('href', 'mailto:' + outSpclInfoDataSet.getNameValue(0, 'eml'));
                $('#hmpgLink').attr('href', outSpclInfoDataSet.getNameValue(0, 'hmpg'));

                if(pRgstId == userId || roleIdIndex != -1) {
                	chkUserRgst(true);
                } else {
                	chkUserRgst(false);
                }
            });

            /* [DataSet] bind */
            var outSpclInfoBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: outSpclInfoDataSet,
                bind: true,
                bindInfo: [
                    { id: 'outSpclId',   ctrlId: 'outSpclId', value: 'value'} //사외전문가ID
                  , { id: 'instNm',      ctrlId: 'instNm',    value: 'html' } //기관명
                  , { id: 'opsNm',       ctrlId: 'opsNm',     value: 'html' } //부서
                  , { id: 'poaNm',       ctrlId: 'poaNm',     value: 'html' } //직위
                  , { id: 'spltNm',      ctrlId: 'spltNm',    value: 'html' } //사외전문가명
                  , { id: 'tlocNm',      ctrlId: 'tlocNm',    value: 'html' } //소재지
                  , { id: 'ccpcNo',      ctrlId: 'ccpcNo',    value: 'html' } //연락처
                  , { id: 'eml',         ctrlId: 'eml',       value: 'html' } //이메일
                  , { id: 'repnSphe',    ctrlId: 'repnSphe',  value: 'html' } //대표분야
                  , { id: 'hmpg',        ctrlId: 'hmpg',      value: 'html' } //홈페이지
                  , { id: 'timpCarr',    ctrlId: 'timpCarr',  value: 'html' } //주요경력
                  , { id: 'attcFilId',   ctrlId: 'attcFilId', value: 'html' } //정보제공동의서
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
                	outSpclInfoDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
             getOutSpclInfo = function() {
            	 outSpclInfoDataSet.load({
                     url: '<c:url value="/knld/pub/getOutsideSpecialistInfo.do"/>',
                     params :{
                    	 outSpclId : outSpclId
                     }
                 });
             };

             getOutSpclInfo();

            /* [버튼] 저장 */
            outSpclRgstSave = function() {
         	   var record = outSpclInfoDataSet.getAt(outSpclInfoDataSet.getRow());
        	   document.aform.outSpclId.value = record.get("outSpclId");
        	   document.aform.pageMode.value = 'V';
	           nwinsActSubmit(document.aform, "<c:url value='/knld/pub/outsideSpecialistRgst.do'/>");
            };

            /* [버튼] 삭제 */
           outSpclRgstDel = function() {
                fncDeleteOutSpclInfo();
            };

    		/* [버튼] 목록 */
            goOutSpclList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveOutsideSpeciaList.do"/>');
            };

            /* 수정/삭제버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
       	    delBtn = new Rui.ui.LButton('delBtn');
       	 	butGoList = new Rui.ui.LButton('butGoList');

       	    saveBtn.on('click', function() {
       	    	outSpclRgstSave();
		     });

		    delBtn.on('click', function() {
		    	if(confirm("삭제하시겠습니까?")){
		    		outSpclRgstDel();
		    	}
		     });

		    butGoList.on('click', function() {
		    	goOutSpclList();
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
   	 * FUNCTION 명 : fncDeleteOutSpclInfo (사외전문가 삭제)
   	 * FUNCTION 기능설명 : 사외전문가 삭제
   	 *******************************************************************************/--%>
	    fncDeleteOutSpclInfo = function(){

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.updateDataSet({
    	        url: "<c:url value='/knld/pub/deleteOutsideSpecialistInfo.do'/>",
    	        dataSets:[outSpclInfoDataSet],
    	        params: {
    	        	outSpclId : outSpclId
    	        }
	    	});

	    	dm1.on('success', function(e) {
				var resultData = outSpclInfoDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveOutsideSpeciaList.do'/>");
			});

			dm1.on('failure', function(e) {
				ruiSessionFail(e);
			});
    	}


	  /*   goHmpg = function(){
	    	document.form.target="_blank";
	    	document.form.action = document.aform.hmpg.value;

	    } */

	</script>
    </head>

    <body>
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="outSpclId" name="outSpclId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">   			
   			<div class="titleArea">
   				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a> 
 				<h2>사외전문가</h2>
 			</div>
 			
	 		<div class="sub-content">
				<div class="titArea btn_top">
					<div class="LblockButton">   
						<button type="button" id="saveBtn" name="saveBtn">수정</button>
						<button type="button" id="delBtn" name="delBtn">삭제</button>
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
   							<th align="right">기관명</th>
   							<td>
   								<span id="instNm"></span>
   							</td>
   							<th align="right">부서</th>
   							<td>
   								<span id="opsNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">직위</th>
   							<td>
   								<span id="poaNm"></span>
   							</td>
   							<th align="right">사외전문가명</th>
   							<td>
   								<span id="spltNm"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">소재지</th>
   							<td>
   								<span id="tlocNm"></span>
   							</td>
   							<th align="right">연락처</th>
   							<td>
   								<span id="ccpcNo"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">eMail</th>
   							<td>
   								<a id="emlLink" href=""><span id="eml"></span></a>
   							</td>
   							<th align="right">대표분야</th>
   							<td>
   								<span id="repnSphe"></span>
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
   							<th align="right">홈페이지</th>
   							<td colspan="3">
   								<a id="hmpgLink" href="" target="_blank"><span id="hmpg"></span></a>
   							</td>
   						</tr>
   						<tr>
    					<!--<th align="right">주요경력</th>-->
   							<td colspan="4">
   								<span id="timpCarr"></span>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">정보제공동의서</th>
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