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
   			<div style="text-align:left;font-size:1.6em;font-family:LG스마트체2.0;" >
   			 - 특약 사항 /(필수기재사항) 
   			</div>
   			<br/>
   			<br/>
   			<div style="text-align:left;font-size:1.1em;font-family:LG스마트체2.0;" >
   			1. 예시)- (주)LX하우시스에서 잔금일자 10/02에 임대인 ○○○ 명의계좌로
   			   &nbsp;&nbsp;&nbsp;000원을 송금하기로 한다. 세입자가 추가로 부담하는 경우- 세입자 ○○○는 
   			     &nbsp;&nbsp;&nbsp;임대인 명의계좌로 000원을 송금한다
               (임대인 ○○○명의/계좌00-0000)<br/>
   			</div>
   			</br>
   			<div style="text-align:left;font-size:1.1em;font-family:LG스마트체2.0;" >
   			2. 본 계약 만기시에는 ㈜LX하우시스 법인명의 계좌로 000원을 송금하며 세
   			      &nbsp;&nbsp;&nbsp;입자○○○에게 000원을 송금하기로 한다 (법인명의계좌 00-000-0000)
   			</div>
   			</br>
   			<div style="text-align:left;font-size:1.1em;font-family:LG스마트체2.0;" >
   			3. 임대인은 잔금일자에 보증금 입금과 동시에 법인명의로 전세권설정을 진행
   			   &nbsp;&nbsp;&nbsp;한다.
   			</div>
   			</br>
   			<div style="text-align:left;font-size:1.1em;font-family:LG스마트체2.0;" >
   			4. 본 계약 종료 후 임대인은 임대차 보증금 중 ( )원을 주식회사 LX하우시스 
   			   &nbsp;&nbsp;&nbsp;대표계좌( )으로 입금하여  반환하여야 하고, 이외의 계좌로 입금한 경우 보증
   			   &nbsp;&nbsp;&nbsp;금 반환의 효력이  없다.
   			</div>
	</div>   		
</div>
</body>
</html>