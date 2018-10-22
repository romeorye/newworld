<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: rlabTestEqipPrctMgmtDtlWp.jsp
 * @desc    : 기기 > 관리 > 신뢰성시험장비 예약관리 > 상세화면(내후성)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.17    		최초생성
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
var dm;
var mailTitl;

	Rui.onReady(function(){

		<%-- RESULT DATASET --%>
        resultDataSet = new Rui.data.LJsonDataSet({
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

        var prctScnCd = "<c:out value='${inputData.prctScnCd}'/>";
        mailTitl = "신뢰성시험장비 예약 신청 결과 안내";

		dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		/* [버튼] : 승인 저장 */
    	var butSave = new Rui.ui.LButton('butSave');
		/* if(prctScnCd != "RQ"){
			butSave.disable();
		} */

   		butSave.on('click', function(){
    		Rui.confirm({
    			text: '승인 처리하시겠습니까?',
    	        handlerYes: function() {
    	        	var prctScnCd = "APPR";
    	        	fncSaveMchnApprInfo(prctScnCd);
    	        }
    		});
   	 	});

		/* [버튼] : 반려 저장  */
    	var butRe = new Rui.ui.LButton('butRe');
    	/* if(prctScnCd != "RQ"){
			butRe.disable();
		} */
    	butRe.on('click', function(){
    		Rui.confirm({
    			text: '반려 처리하시겠습니까?',
    	        handlerYes: function() {
    	        	var prctScnCd = "REJ";
    	        	fncSaveMchnApprInfo(prctScnCd);
    	        }
    		});

   	 	});

    	var fncSaveMchnApprInfo = function(cd){
    		dm.on('success', function(e) {      // 업데이트 성공시
	    		var resultData = resultDataSet.getReadData(e);

    			alert(resultData.records[0].rtnMsg);
	    		if( resultData.records[0].rtnSt == "Y"){
		    		fncMchnApprList();
	    		}
	    	});
    	    dm.on('failure', function(e) {      // 업데이트 실패시
                Rui.alert("update Fail");
    	    });

    	    document.aform.prctScnCd.value = cd;

    	    var confirmMsg = "처리 하시겠습니까?";
    	    if(cd == "APPR" ){
    	    	confirmMsg = "승인"+confirmMsg;
    	    	document.aform.prctScnNm.value = "승인";
    	    }else{
    	    	confirmMsg = "반려"+confirmMsg;
    	    	document.aform.prctScnNm.value = "반려";
    	    }

          	dm.updateForm({
          		url: "<c:url value='/mchn/mgmt/updateRlabTestEqipPrctInfo.do'/>"
          	   ,form : 'aform'
          	   ,params : {
	        	    	 mailTitl : mailTitl				//mail title
	        	    }
          	});
    	}

    	/* [버튼] : 기기예약 관리목록 이동 */
    	var butList = new Rui.ui.LButton('butList');
    	butList.on('click', function(){
    		fncMchnApprList();
    	});

    	//기기예약 관리목록 화면으로 이동
    	var fncMchnApprList = function(){
			$('#searchForm > input[name=prctTitl]').val(encodeURIComponent($('#searchForm > input[name=prctTitl]').val()));
			$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
			$('#searchForm > input[name=mchnNm]').val(encodeURIComponent($('#searchForm > input[name=mchnNm]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/mchn/mgmt/retrieveRlabTestEqipPrctMgmtList.do"/>");
    	}

	});	//end ready


</script>
<style type="text/css">
.search-toggleBtn {display:none;}
</style>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
	        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	        	<span class="hidden">Toggle 버튼</span>
        	</a>
			<h2>기기예약관리 상세</h2>
		</div>
		<div class="sub-content">

		<form name="searchForm" id="searchForm">
			<input type="hidden" name="prctTitl" value="${inputData.prctTitl}"/>
			<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
			<input type="hidden" name="mchnNm" value="${inputData.mchnNm}"/>
			<input type="hidden" name="prctScnCd" value="${inputData.prctScnCd}"/>
			<input type="hidden" name="rlabClCd" value="${inputData.rlabClCd}"/>
			<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
	    </form>


			<form name="aform" id="aform"  method="post">
				<input type="hidden" id="menuType" name="menuType" />
				<input type="hidden" id="mchnPrctId" name="mchnPrctId" value="<c:out value='${inputData.mchnPrctId}'/>">

				<input type="hidden" id="prctDt" name="prctDt"  value="<c:out value='${result.prctDt}'/>">
				<input type="hidden" id="rgstNm" name="rgstNm"  value="<c:out value='${result.rgstNm}'/>">
				<input type="hidden" id="mchnHanNm" name="mchnHanNm" value="<c:out value='${result.mchnHanNm}'/>">
				<input type="hidden" id="mchnEnNm" name="mchnEnNm" value="<c:out value='${result.mchnEnNm}'/>">
				<input type="hidden" id="prctFromTim" name="prctFromTim" value="<c:out value='${result.prctFromTim}'/>">
				<input type="hidden" id="prctToTim" name="prctToTim" value="<c:out value='${result.prctToTim}'/>">
				<input type="hidden" id="prctScnCd" name="prctScnCd" />
				<input type="hidden" id="toMailAddr" name="toMailAddr" value="<c:out value='${result.rgstMail}'/>">
				<input type="hidden" id="prctScnNm" name="prctScnNm" >
				<input type="hidden" id="prctFromToDt" name="prctFromToDt" value="<c:out value='${result.prctFromToDt}'/>">

				<div class="LblockButton top mt10">
					<button type="button" id="butSave">승인</button>
					<button type="button" id="butRe">반려</button>
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
						<th align="right">장비분류</th>
							<td>
								<c:out value='${result.comDtlNm}'/>
							</td>
							<th align="right">신청제목</th>
							<td>
								<c:out value='${result.prctTitl}'/>
							</td>
						</tr>
						<tr>
							<th align="right">장비명</th>
							<td>
								<c:out value='${result.mchnHanNm}'/>
							</td>
							<th align="right">예약자</th>
							<td>
								<c:out value='${result.rgstNm}'/>(<c:out value='${result.teamNm}'/>)
							</td>
						</tr>
						<tr>
							<th align="right">시료명</th>
							<td>
								<c:out value='${result.smpoNm}'/>
							</td>
							<th align="right">시료수</th>
							<td>
								<c:out value='${result.smpoQty}'/>
							</td>
						</tr>
						<tr>
							<th align="right">예약일</th>
							<td>
								<c:out value='${result.prctFromToDt}'/>
							</td>
							<th align="right">구분</th>
							<td>
								<c:out value='${result.prctScnNm}'/>
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
