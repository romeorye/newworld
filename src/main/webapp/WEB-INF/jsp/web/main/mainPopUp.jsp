<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title>LSSP반출신청</title>

<script type="text/javascript">
	
	Rui.onReady(function() {
	
		moveApprovalPg = function(cd){
			if( cd == "APP00369" ){
				openWindow('<c:url value="http://uapproval.lghausys.com:7001/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00369"/>', '정보기기', 900, 800, 'yes');
			}else if( cd == "APP00370" ){
				openWindow('<c:url value="http://uapproval.lghausys.com:7001/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00370"/>', '시료/샘플', 900, 800, 'yes');
			}else if( cd == "APP00371" ){
				openWindow('<c:url value="http://uapproval.lghausys.com:7001/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00371"/>', '문서', 900, 800, 'yes');
			}
			
			window.close();
		} 
	});

</script>
</head>
<body>
<div class="bd">
	<div class="sub-content">
			<h2>* 반출유형을 선택해주세요</h2>		
		</br>
		<div class="LblockButton1">
			<button type="button" class="btn"  id="prjSearchBtn" name="prjSearchBtn" onclick="javascript:moveApprovalPg('APP00369');">정보기기</button>
			<button type="button" class="btn"  id="prjSearchBtn" name="prjSearchBtn" onclick="javascript:moveApprovalPg('APP00370');">시료/샘플</button>
			<button type="button" class="btn"  id="tssSearchBtn" name="tssSearchBtn" onclick="javascript:moveApprovalPg('APP00371');">문서</button>
		</div>
	</div>	
</div>


</body>
</html>