<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
  * $Id		: leasHousDpyPop.jsp
 * @desc    : 임차주택/ 확약서 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.10.28   IRIS005	최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>


<script type="text/javascript">

		Rui.onReady(function() {
		
			var dplYn = new Rui.ui.form.LCheckBox({
                applyTo: 'dplYn',
                label: '동의',
                value: 'Y'
            });
			
			dplYn.on('changed', function(e){
                alert("확약서에 동의하셨습니다.");
                parent.fncDplYn("Y");
                parent.leasHousDplDialog.submit(true);
            });
			
			//parent.dpy(record);
			//parent.faxInfoDialog.submit(true);
		});

</script>
</head>
<body>
<div class="LblockMainBody">
	<div class="sub-content">
   			
   			<div style="text-align:center">
   			<h1> 확약서 </h1>
   			</div>
   			<br/>
   			본인은 (주)LX하우시스(이하 '회사'라 함)에서 본인에게 제공하는 임차주택 지원과 관련하여 아래 사항을 준수할 것을 확인합니다.<br/>
   			<br/>
   			<br/>
   			<div style="text-align:center">
   			 <h4>- 아 래 -</h4>
   			</div> 
   			<br/>
   			<br/>
   			1. 본인은 회사가 마련한 '연구소 박사 임차주택관리 규정'에 관한 설명을 듣고, 충분히 &nbsp;&nbsp;&nbsp;듣고 이해하였으며,본 규정을 준수할 것을 약속한다.<br/>
   			<br/>
   			2. 임차주택의 경매, 임대인의 임차보증금 지급 불능 등의 사유로 임대차 보증금 원금에 &nbsp;&nbsp;&nbsp;손실이 발생한 경우, 회사 지원금과 본인 부담금의비율에 따라 그 손실을부담하기로 &nbsp;&nbsp;&nbsp;한다.<br/>
   			<br/>
   			3. 본인은 임차주택을 지원받고 4년 이내에 퇴사하게 되는 경우, 회사가 임차보증금을 &nbsp;&nbsp;&nbsp;지원한 때로부터 회사에 지원금을 반환하기까지 발생한 이자, 입주를 위해소요된 &nbsp;&nbsp;&nbsp;공인중개사 수수료,
   			   전세권 설정비용, 법무사 수수료를 포함하여 회사가 임차주택 &nbsp;&nbsp;&nbsp;지원을 위해 부담한 금액 일체를 반환할 것을 약속한다.
   			<br/>
   			<br/>
   			
   			<div id="chk">
   				<input type="checkbox" id="chkCmpl"/>
   			</div>
	</div>   		
</div>
</body>
</html>