<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil, org.apache.logging.log4j.Logger, org.apache.logging.log4j.LogManager"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlMachineList.jsp
 * @desc    : 분석기기 > 기기예약 > 기기교육 > 기기교육  상세 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.01    IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript">

var chkCcs;

Rui.onReady(function(){
		var eduPttStBtn = new Rui.ui.LButton('eduPttSt');
		eduPttStBtn.on('click', function(){

        });
        <%-- RESULT DATASET --%>
        var resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });

		var eduPttStCd = document.aform.eduPttStCd.value;
		var eduPttStNm = document.aform.eduPttStNm.value;

		/* [버튼] : 교육신청 저장 */
    	var butSave = new Rui.ui.LButton('butSave');
   		butSave.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    		dm.on('success', function(e) {      // 승인 성공시
    			var resultData = resultDataSet.getReadData(e);

    			if( resultData.records[0].rtnSt == "S"){
	    			Rui.alert(resultData.records[0].rtnMsg);
	    			fncMchnEduList();
    			}else{
	    			Rui.alert(resultData.records[0].rtnMsg);
    			}
    	    });

    	    dm.on('failure', function(e) {      // 승인 실패시
                Rui.alert("신청 Fail");
    	    });

    	    if(fncVaild()){
    	    	Rui.confirm({
        			text: '교육신청을 하시겠습니까?',
        	        handlerYes: function() {
        	        	dm.updateDataSet({
        	        	    url: "<c:url value='/mchn/open/edu/insertEduInfoDetail.do'/>"
        	        	  ,	params: {                                 // 업데이트시 조건 파라메터를 기술합니다.
        	        		        prctScnCd : 'APPR'
      	        	    		    ,mchnEduId : document.aform.mchnEduId.value
        	        	            }
        	        	});
        	        }
        		});
    	    }

   	 	});

   		/* [버튼] : 교육취소 */
    	var butCancel = new Rui.ui.LButton('butCancel');
    	butCancel.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    		dm.on('success', function(e) {      // 승인 성공시
    			var resultData = resultDataSet.getReadData(e);

    			if( resultData.records[0].rtnSt == "S"){
	    			Rui.alert(resultData.records[0].rtnMsg);
	    			fncMchnEduList();
    			}else{
	    			Rui.alert(resultData.records[0].rtnMsg);
    			}
    	    });

    	    dm.on('failure', function(e) {      // 승인 실패시
                Rui.alert("신청 Fail");
    	    });

    	    if(fncVaild()){
    	    	Rui.confirm({
        			text: '교육신청을 취소 하시겠습니까?',
        	        handlerYes: function() {
        	        	dm.updateDataSet({
        	        	    url: "<c:url value='/mchn/open/edu/updateEduCancel.do'/>"
        	        	  ,	params: {                                 // 업데이트시 조건 파라메터를 기술합니다.
        	        		        mchnEduId : document.aform.mchnEduId.value
        	        	            }
        	        	});
        	        }
        		});
    	    }

   	 	});

   		if(eduPttStCd == "CLS"){
			eduPttStBtn.hide();
			eduPttStBtn.hide();
			butSave.disable();
			butCancel.disable();
		}else{
			Rui.get("eduPttStNm").html("eduPttStNm");
			butSave.enable();
			butCancel.show();
			eduPttStBtn.show();
		}

    	/* [버튼] : 기기교육 목록 이동 */
    	var butList = new Rui.ui.LButton('butList');
    	butList.on('click', function(){
    		fncMchnEduList();
    	});

    	//신청시 예외처리
    	var fncVaild = function(){
    		//정원수 체크
    		var pttCpsn = '${result.pttCpsn}';
    		var ivttCpsn ='${result.ivttCpsn}';

    		if(Number(pttCpsn) >= Number(ivttCpsn) ){
    			Rui.alert("모집 인원이 초과 하였습니다. 담당자에게 문의 하세요.");
    			return false;
    		}
    		return true;
    	}

    	//분석기기 목록 화면으로 이동
    	var fncMchnEduList = function(){
    		$('#searchForm > input[name=eduNm]').val(encodeURIComponent($('#searchForm > input[name=eduNm]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/mchn/open/edu/retrieveEduList.do"/>");
    	}

    	/* //첨부파일 다운로드
    	var fncDownload = function(attId, seq){
    	 	document.aform.attcFilId.value = attId;
    	 	document.aform.seq.value = seq;
    	 	document.aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>";
    	 	document.mstForm.target='dnFrame';
    	 	document.aform.submit();
    	} */
        chkCcs = '${result.eduStCd}';

    	var eduStnmHtml = "";

         if(chkCcs == "RQ" ){
 			eduStnmHtml =  '${result.eduStNm}';
 		}else if(chkCcs == "CCS"   ){
 			eduStnmHtml =  '${result.eduStNm}'+ "(수료일 : "+'${result.ccsDt}'+")";
 		}else if(chkCcs == "NCPE"   ){
 			eduStnmHtml =  '${result.eduStNm}'+ "(미수료일 : "+'${result.ccsDt}'+")";
 		}

         Rui.get("lastEduInfo").html(eduStnmHtml);


         if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
         	$("#butSave").hide();
         	$("#butCancel").hide();
     	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
         	$("#butSave").hide();
         	$("#butCancel").hide();
 		}

	});	//end ready

	//첨부파일 다운로드
	function fncDownload(attId, seq){
		document.aform.attcFilId.value = attId;
	 	document.aform.seq.value = seq;
	 	document.aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>";
	 	//document.aform.target='aform';
	 	document.aform.submit();
	}


</script>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>
			<h2>기기교육 상세</h2>
		</div>
	<div class="sub-content">

	<form name="searchForm" id="searchForm">
		<input type="hidden" name="eduNm" value="${inputData.eduNm}"/>
		<input type="hidden" name="pttYn" value="${inputData.pttYn}"/>
		<input type="hidden" name="eduScnCd" value="${inputData.eduScnCd}"/>
		<input type="hidden" name="frEduDt" value="${inputData.frEduDt}"/>
		<input type="hidden" name="toEduDt" value="${inputData.toEduDt}"/>
		<input type="hidden" name=pageNum value="${inputData.pageNum}"/>
    </form>


			<form name="aform" id="aform"  method="post">
				<input type="hidden" id="menuType" name="menuType" value="IRIIDE0104"/>
				<input type="hidden" id="mchnEduId" name="mchnEduId" value="<c:out value='${result.mchnEduId}'/>">
				<input type="hidden" id="eduPttStCd" name="eduPttStCd" value="<c:out value='${result.eduPttStCd}'/>">
				<input type="hidden" id="eduPttStNm" name="eduPttStNm" />

				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="seq" name="seq" />

				<div class="LblockButton top mt0">
					<button type="button" id="butSave">교육신청</button>
					<button type="button" id="butCancel">교육취소</button>
					<button type="button" id="butList">목록</button>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">교육명</th>
							<td>
								<div id="eduPttSt"><c:out value='${result.eduPttStNm}'/></div>
								[<c:out value='${result.eduScnNm}'/>]<c:out value='${result.eduNm}'/>
							</td>
							<th align="right">분석기기</th>
							<td>
								<c:out value='${result.mchnNm}'/>
							</td>
						</tr>
						<tr>
							<th align="right">교육일시</th>
							<td>
								<c:out value='${result.eduDt}'/> <c:out value='${result.eduFromTim}'/>시 ~ <c:out value='${result.eduToTim}'/>시
							</td>
							<th align="right">교육장소</th>
							<td>
								<c:out value='${result.eduPl}'/>
							</td>
						</tr>
						<tr>
							<th align="right">신청기간</th>
							<td>
								<c:out value='${result.pttFromDt}'/> ~ <c:out value='${result.pttToDt}'/>
							</td>
							<th align="right">모집인원</th>
							<td>
								신청 : <c:out value='${result.pttCpsn}'/> /  정원 : <c:out value='${result.ivttCpsn}'/>
							</td>
						</tr>
						<tr>
							<th align="right">담당자</th>
							<td>
								<c:out value='${result.eduCrgrNm}'/>
							</td>
							<th align="right">최종교육일</th>
							<td>
								<span id="lastEduInfo" ></span>
								<%-- <c:out value='${inputData.ccsDt}'/> --%>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<c:out value='${result.dtlSbc}' escapeXml="false"/>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
							<td colspan="3">
								<c:forEach var="attachFileList" items="${attachFileList}">
                        			<a href="javascript:fncDownload('${attachFileList.attcFilId}','${attachFileList.seq}');">${attachFileList.filNm}</a><br>
								</c:forEach>
							</td>
						</tr>
						</tbody>
				</table>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>