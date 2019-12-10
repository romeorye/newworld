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

	

</script>
</head>
<body>
<div class="LblockMainBody">
	<div class="sub-content">
   			<div style="text-align:center">
   			<h1> 전세계약서 작성시 </h1>
   			</div>
   			
   			<br/>
   			<br/>
   			1. 전세 계약기간-2년(24개월).<br/>
   			<br/>
   			2. 계약내용:잔금일자-계약시작일-보증금-계약금-잔금<br/>
   			<br/>
   			3. 임대인 주소작성-실거주지역-주민등록주소지로한다<br/>
   			<br/>
   			4. 임차인주소-법인명의<br/>
   			<br/>
   			5. 특약사항 예시)- (주)엘지하우시스에서 임대인○○○에게 잔금일자 10/02  원을 송금하기로한다 
                           예시)세입자000은 임대인000 명의의 계좌로00원을 00일자로 송금한다(임대인 계좌00-0000)
                <br/>
   			<br/>
   			6. 임대인은 잔금일자에 입금과 동시에 전세권설정을 진행한다<br/>
   			<br/>
   			
	</div>   		
</div>
</body>
</html>