<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceRqprOpiFb.jsp
 * @desc    : 의견피드백 todo
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.25  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 2차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .L-navset {overflow:hidden;}
</style>

	<script type="text/javascript">

		var callback;
		var spaceRqprDataSet;
		var opiId;
		var rqprId = '${inputData.MW_TODO_REQ_NO}';
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = spaceRqprWayCrgrDataSet.getReadData(e);

                if(Rui.isEmpty(data.records[0].resultMsg) == false) {
                    alert(data.records[0].resultMsg);
                }

                if(data.records[0].resultYn == 'Y') {
                	if(data.records[0].cmd == 'update') {
                		;
                	} else if(data.records[0].cmd == 'requestApproval') {
                		// guid= B : 신뢰성 분석의뢰, D : 신뢰성 분석완료, E : 공간성능 평가의뢰, G : 공간성능 평가완료 + rqprId
                    	var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00333&approvalLineInform=SUB001&from=iris&guid=E${inputData.rqprId}';

                   		openWindow(url, 'spaceRqprApprovalPop', 800, 500, 'yes');
                	} else {
                		dm.loadDataSet({
                            dataSets: [spaceRqprFbDataSet],
                            url: '<c:url value="/space/getSpaceRqprDetailInfo.do"/>',
                            params: {
                                rqprId: rqprId
                            }
                        });
                	}
                }
            });

            //$('#fbTssPgsStep').hide();

          	/////////////////////////////////////////////////
          	//의견 피드백
          	/* 피드백카테고리 */
        	var fbRsltCtgr = new Rui.ui.form.LCombo({
                applyTo: 'fbRsltCtgr',
                name: 'fbRsltCtgr',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 300,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FB_RSLT_CTGR"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

        	/* 피드백내용 */
             var fbRsltSbcTxtArea = new Rui.ui.form.LTextArea({
            	 applyTo: 'fbRsltSbc',
                  editable: true,
                  disabled:false,
                  width: 800,
                  height:100
             });

             /* 피드백과제진행단계구분 */
          	var fbTssPgsStep = new Rui.ui.form.LCombo({
                  applyTo: 'fbTssPgsStep',
                  name: 'fbTssPgsStep',
                  emptyText: '선택',
                  defaultValue: '',
                  emptyValue: '',
                  width: 400,
                  url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FB_TSS_PGS_STEP"/>',
                  displayField: 'COM_DTL_NM',
                  valueField: 'COM_DTL_CD'
              });

             /* 피드백구분 */
         	var fbRsltScn = new Rui.ui.form.LCombo({
                 applyTo: 'fbRsltScn',
                 name: 'fbRsltScn',
                 emptyText: '선택',
                 defaultValue: '',
                 emptyValue: '',
                 width: 300,
                 url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FB_RSLT_SCN"/>',
                 displayField: 'COM_DTL_NM',
                 valueField: 'COM_DTL_CD'
             });

         	/* 피드백 개선요청사항 */
              var fbRsltBttmTxtArea = new Rui.ui.form.LTextArea({
             	 applyTo: 'fbRsltBttm',
                   editable: true,
                   disabled:false,
                   width: 800,
                   height:100
              });

			fbRsltCtgr.on('changed', function(e) {
				if(e.value=="03"){
					fbRsltSbcTxtArea.setValue("");
					fbRsltSbcTxtArea.hide();
					fbTssPgsStep.show();
				}else{
					fbRsltSbcTxtArea.show();
					fbTssPgsStep.hide();
					fbTssPgsStep.setValue("");
				}

            });

			/* fbRsltScn.on('changed', function(e) {
				alert(e.value);
				if(e.value=="04"){
					//$('#fbRsltBttm').attr('disabled', 'disabled');
					$('#fbRsltBttm').attr('readonly', true);

				} else{
					$('#fbRsltBttm').attr('abled', 'abled');
				}

            });
			*/
			var spaceRqprFbDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprFbDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId' }
                	, { id: 'fbRsltCtgr'	}
					, { id: 'fbRsltSbc'		}
					, { id: 'fbRsltScn'		}
					, { id: 'fbRsltBttm'	}
					, { id: 'spaceStpt'		}
					, { id: 'fbCmplYn'		}
					, { id: 'fbTssPgsStep'	}
                ]
            });

          	spaceRqprFbBind = new Rui.data.LBind({
                groupId: 'bform',
                dataSet: spaceRqprFbDataSet,
                bind: true,
                bindInfo: [
					{ id: 'rqprId',				ctrlId: 'rqprId',			value:'value'},
                    { id: 'fbRsltCtgr',			ctrlId: 'fbRsltCtgr',		value:'value'},
					{ id: 'fbRsltSbc',			ctrlId: 'fbRsltSbc',		value:'value'},
					{ id: 'fbRsltScn',			ctrlId: 'fbRsltScn',		value:'value'},
					{ id: 'fbRsltBttm',			ctrlId: 'fbRsltBttm',		value:'value'},
					{ id: 'spaceStpt',			ctrlId: 'spaceStpt',		value:'value'},
					{ id: 'fbCmplYn',			ctrlId: 'fbCmplYn',			value:'value'},
					{ id: 'fbTssPgsStep',		ctrlId: 'fbTssPgsStep',		value:'value'}
                ]
            });

          //평가방법 / 담당자 데이터셋
            var spaceRqprWayCrgrDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprWayCrgrDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'crgrId', defaultValue: '' }
                	, { id: 'rqprId', defaultValue: '' }
					, { id: 'evCtgr' }
					, { id: 'evPrvs' }
					, { id: 'infmPrsnId' }
					, { id: 'infmPrsnNm' }

                ]
            });

			spaceRqprFbDataSet.on('load', function(e) {

				if(spaceRqprFbDataSet.getNameValue(0, 'fbCmplYn')=="Y"){
					$("#saveFbBtn").hide();
					$("#cmplFbBtn").hide();
				}else{
					$("#saveFbBtn").show();
					$("#cmplFbBtn").show();
				}
				if(spaceRqprFbDataSet.getNameValue(0, 'fbRsltCtgr')=="03"){
					fbRsltSbcTxtArea.hide();
					fbTssPgsStep.show();
					if(spaceRqprFbDataSet.getNameValue(0, 'fbCmplYn')=="Y"){
						fbRsltSbcTxtArea.disable();
						fbTssPgsStep.disable();
						fbRsltCtgr.disable();
						fbRsltScn.disable();
						fbRsltBttmTxtArea.disable();
					}else{
						fbRsltSbcTxtArea.enable();
						fbTssPgsStep.enable();
						fbRsltCtgr.enable();
						fbRsltScn.enable();
						fbRsltBttmTxtArea.enable();
					}
				}else{
					fbRsltSbcTxtArea.show();
					fbTssPgsStep.hide();
					if(spaceRqprFbDataSet.getNameValue(0, 'fbCmplYn')=="Y"){
						fbRsltSbcTxtArea.disable();
						fbTssPgsStep.disable();
						fbRsltCtgr.disable();
						fbRsltScn.disable();
						fbRsltBttmTxtArea.disable();
					}else{
						fbRsltSbcTxtArea.enable();
						fbTssPgsStep.enable();
						fbRsltCtgr.enable();
						fbRsltScn.enable();
						fbRsltBttmTxtArea.enable();
					}
				}
            });

			//피드백저장
            opinitionFbSave = function() {
            	var fbRsltCtgr = document.bform.fbRsltCtgr.value;
            	var fbRsltSbc = document.bform.fbRsltSbc.value;
            	var fbRsltScn = document.bform.fbRsltScn.value;
            	var fbRsltBttm = document.bform.fbRsltBttm.value;
            	var fbTssPgsStep = document.bform.fbTssPgsStep.value;

            	if(fbRsltCtgr==""){
            		alert("평가 카테고리를 선택해 주세요.");
            		return;
            	}

            	if(fbRsltScn==""){
            		alert("구분값을 선택해 주세요.");
            		return;
            	}

            	if(fbRsltCtgr=="03"){
            		if(fbTssPgsStep==""){
            			alert("평가명을 선택해 주세요.");
            			return;
            		}
            	}else{
            		if(fbRsltSbc=""){
            			alert("평가명을 입력해 주세요.")
            		}
            	}

            	if(confirm('저장 하시겠습니까?')) {
               		dm.updateDataSet({
                        url:'<c:url value="/space/saveSpaceRqprFb.do"/>',
                        //dataSets:[dataSet]
                        params: {
                        	rqprId : rqprId
                        	, fbRsltCtgr : document.bform.fbRsltCtgr.value
    	    	         	, fbRsltSbc : document.bform.fbRsltSbc.value
    	    	         	, fbRsltScn : document.bform.fbRsltScn.value
    	    	         	, fbRsltBttm : document.bform.fbRsltBttm.value
    	    	         	, fbTssPgsStep : document.bform.fbTssPgsStep.value
    	    	       }
                    });
               	}
            };

          //피드백확정
            cmplFbSave = function() {
            	var fbRsltCtgr = document.bform.fbRsltCtgr.value;
            	var fbRsltSbc = document.bform.fbRsltSbc.value;
            	var fbRsltScn = document.bform.fbRsltScn.value;
            	var fbRsltBttm = document.bform.fbRsltBttm.value;
            	var fbTssPgsStep = document.bform.fbTssPgsStep.value;

            	if(fbRsltCtgr==""){
            		alert("평가 카테고리를 선택해 주세요.");
            		return;
            	}

            	if(fbRsltScn==""){
            		alert("구분값을 선택해 주세요.");
            		return;
            	}

            	if(fbRsltCtgr=="03"){
            		if(fbTssPgsStep==""){
            			alert("평가명을 선택해 주세요.");
            			return;
            		}
            	}else{
            		if(fbRsltSbc=""){
            			alert("평가명을 입력해 주세요.")
            		}
            	}
               	if(confirm('확정 하시겠습니까?')) {
               		dm.updateDataSet({
                        url:'<c:url value="/space/saveSpaceRqprFbCmpl.do"/>',
                        //dataSets:[dataSet]
                        params: {
                        	rqprId : rqprId
                        	, fbRsltCtgr : document.bform.fbRsltCtgr.value
    	    	         	, fbRsltSbc : document.bform.fbRsltSbc.value
    	    	         	, fbRsltScn : document.bform.fbRsltScn.value
    	    	         	, fbRsltBttm : document.bform.fbRsltBttm.value
    	    	         	, fbTssPgsStep : document.bform.fbTssPgsStep.value
    	    	       }
                    });
               	}
            };
          	/////////////////////////////////////////////////


    	    /* 유효성 검사 */
    	    isValidate = function(type) {
                if (spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '00') {
                    alert('작성중 상태일때만 ' + type + ' 할 수 있습니다.');
                    return false;
                }

                if (vm.validateDataSet(spaceRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

                var spaceRqprWayCrgrDataSetCnt = spaceRqprWayCrgrDataSet.getCount();
                var spaceRqprWayCrgrDataSetDelCnt = 0;

                for(var i=0; i<spaceRqprWayCrgrDataSetCnt; i++) {
                	if(spaceRqprWayCrgrDataSet.isRowDeleted(i)) {
                		spaceRqprWayCrgrDataSetDelCnt++;
                	}
                }

                if (spaceRqprWayCrgrDataSetCnt == spaceRqprWayCrgrDataSetDelCnt) {
                    alert('시료정보를 입력해주세요.');
                    return false;
                } else if (vm.validateDataSet(spaceRqprWayCrgrDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

//                 if (spaceRqprAttachDataSet.getCount() == 0) {
//                 	alert('시료사진/첨부파일을 첨부해주세요.');
//                 	return false;
//                 }

                return true;
    	    }


    	    dm.loadDataSet({
                dataSets: [spaceRqprFbDataSet],
                url: '<c:url value="/space/getSpaceRqprDetailInfo.do"/>',
                params: {
                    rqprId: rqprId
                }
            });



		});


	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="spaceNm" value="${inputData.spaceNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="rgstId" value="${inputData.rgstId}"/>
		<input type="hidden" name="spaceChrgNm" value="${inputData.spaceChrgNm}"/>
		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="spaceAcpcStCd" value="${inputData.spaceAcpcStCd}"/>
		<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
		          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		          <span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>공간평가 피드백</h2>
   			</div>
   			<div class="sub-content">

   				<div id="spaceRqprOpinitionFbDiv">
   				<form name="bform" id="bform" method="post">
   				<div class="titArea">
   					<h3><span style="color:red;">* </span>프로젝트 결과</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveFbBtn" name="saveFbBtn" onclick="opinitionFbSave()">임시저장</button>
   						<button type="button" class="btn"  id="cmplFbBtn" name="cmplFbBtn" onclick="cmplFbSave()">확정</button>
   					</div>
   				</div>
   				<table class="table">
   					<colgroup>
						<col style="width:30%;">
						<col style="width:70%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<th>평가카테고리</th>
   							<th colspan="2">평가명</th>
   						</tr>
   						<tr>
   							<td>
   								<div id="fbRsltCtgr"></div>
   							</td>
   							<td class="spacerqpr_tain">
   								<div id="fbTssPgsStep"></div>
   								<input id="fbRsltSbc" type="text">
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<div class="titArea">
   					<h3><span style="color:red;">* </span>공간평가시스템 개선 요청 사항</h3>
   					<div class="LblockButton">
   					</div>
   				</div>
   				<table class="table">
   					<colgroup>
						<col style="width:30%;">
						<col style="width:70%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<th>구분</th>
   							<th>비고</th>
   						</tr>
   						<tr>
   							<td>
   								<div id="fbRsltScn"></div>
   							</td>
   							<td class="spacerqpr_tain">
   								<textarea id="fbRsltBttm"></textarea>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				</form>
   				</div>
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>