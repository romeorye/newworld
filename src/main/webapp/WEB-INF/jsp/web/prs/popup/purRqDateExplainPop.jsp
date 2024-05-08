<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purRqItemPop.jsp
 * @desc    : 구매요청 Item 등록 팝업 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.11.23   김연태		최초생성
 * ---	-----------	----------	-----------------------------------------
 * PRS 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
</head>
<body>
<body leftmargin="0" topmargin="0">
<table width="805" border="0" cellspacing="0" cellpadding="0">
     <tr>
          <td valign="top">
               <!--컨텐츠 영역 시작 -->
               <table width="95%" border="0" align="center" cellpadding="3" cellspacing="0">
                    <tr> 
                         <td width="2%" align="center" valign="top" ><img src="/epWeb/resources/images/r_icon_simple_01.gif" width="11" height="11"> 
                         </td>
                         <td width="98%" valign="top" class="pop_back_mid">납품 요청일 도움말</td>
                    </tr>
                    <tr class="table_height20"> 
                         <td width="2%" align="center"  valign="top"></td>
                         <td width="98%" valign="top" style="padding-top:5px;"> 
                         ▶ 납품 요청일은 업체의 지연 벌금(지체상금)과 연관 되므로 실제 입고 가능한 날짜를 지정하여 주시기 바랍니다.<br>
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(전산 자동 청구로 인한 논쟁의 원인 및 변경처리시 업무 로드 증가의 원인이 됨)
                        </td>
                    </tr>
                    <tr class="title-text"> 
                         <td align="center"  valign="top"></td>
                         <td valign="top" class="title-text" style="padding-top:3px;"></td>
                    </tr>
                    <tr> 
                         <td align="center"  valign="top" class="pop_back_mid"></td>
                         <td valign="top" class="table_height20" style="padding-top:5px;"> 
                          ▶ PR결재 (약3일 소요) 및 구매 품의 결재(약 3일 소요)를 고려하면 PR요청후 평균 6일 이후 발주가 나가게 됩니다.<br>                            
                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;따라서,반드시 업체 견적서를 참조 바라며 견적서에 기록된 "발주후 00일"에 6일을 추가한 날짜를 납품 요청일로 <br>
                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;하여 주시기 바랍니다.<br>                            
                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(긴급 사항시 업체와 협의한 날짜에 5일 정도를 추가하여 기록하여 주시기 바랍니다.)


                        </td>
                    </tr>
               </table>
               <!--컨텐츠 영역 끝-->
               <!--조회 위 여백 -->
               <table width="100" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                         <td height="15"></td>
                    </tr>
               </table>
               <!-- 본문영역-->
               <!--문의사항 시작 -->
               <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                         <td height="15" align="center" class="output_textfield4">
               <!--문의사항 끝-->
                              <b>문의사항 : 조한각 차장 (내선번호:2913)</b></td>
                    </tr>
               </table>
               <!--조회 위 여백 -->
               <table width="100" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                         <td height="15"></td>
                    </tr>
               </table>
               <!-- 본문영역-->
               <table width="805" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                         <td class="pop_back_grayline"></td>
                    </tr>
                    <tr> 
                         <td align="right" class="pop_back_gray"></td>
                    </tr>
               </table></td>
     </tr>
</table>
</body>
</html>