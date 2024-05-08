<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlAnalyst.jsp
 * @desc    : 분석담당자
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.24  			최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title><%=documentTitle%></title>
    <link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
    <link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.js"></script>


<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

	<script type="text/javascript">

  		function getPersonInfo(sabunnew, loginSabun){
  			var popupUrl = "http://portal.lxhausys.com/epWeb/com/ep/ibs/mypage/UserInfoController.jpf?sabunnew=" + sabunnew +"&loginSabun=" + loginSabun ;
  			var popupOption = "width=750, height=500, top=300, left=400";
  			window.open(popupUrl,"",popupOption);
  		}

	</script>

    </head>

    <body style="overflow:auto">
		<div class="contents">
			<div class="titleArea">
				<h2>분석 담당자</h2>
		    </div>

			<div class="sub-content">
				<!-- table start -->
		        <div class="analyze_person">
		            <table class="person_tbl">
		                <caption>분류</caption>
		                <colgroup>
		                    <col width="20%" />
		                    <col width="20%" />
		                    <col width="20%" />
		                    <col width="20%" />
		                    <col />
		                </colgroup>
		                <div class="person_guide" >* 기타 사업조직 분석의뢰 시, 분석PJT PL과 상담해주시기 바랍니다.</div>
		                <thead>
		                    <tr>
		                        <th>사업분야</th>
<!-- 		                        <th>팀(PJT)</th> -->
		                        <th>형상분석</th>
		                        <th>유기분석</th>
		                        <th>유해물질분석</th>
		                    </tr>
		                </thead>
		                <tbody>
		                    <tr>
		                        <th >기반기술</th>
		                        <td>
		                        	<a href="javascript:getPersonInfo('00207776','kwonjihye')" class="person_link">권지혜</a>,
		                        	<a href="javascript:getPersonInfo('00208220','jihachoi')" class="person_link">최지하</a>
		                        	<!-- <a href="javascript:getPersonInfo('00207677','soonbo')" class="person_link">이순보</a> -->
		                        </td>
		                        <td>
		                        	<!-- <a href="javascript:getPersonInfo('00206813','suyune')" class="person_link">김수연</a> -->
		                        	<a href="javascript:getPersonInfo('00207783','kimsb')" class="person_link">김샛별</a>
		                        </td>
		                        <td rowspan="5" class="bottomL">
		                        	<a href="javascript:getPersonInfo('00207466','chlee')" class="person_link">이종한</a>
		                        	<br><br>
		                        	<a href="javascript:getPersonInfo('00207068','kojaeyoon')" class="person_link">고재윤</a>
		                        	<br><br>
		                        	<a href="javascript:getPersonInfo('00207779','lejaaa')" class="person_link">이은주</a>
		                        	<br><br>
		                        	<a href="javascript:getPersonInfo('00208219','sumin')" class="person_link">권수민</a>
		                        	<br><br>
		                        	
		                        	<a href="javascript:getPersonInfo('00206813','suyune')" class="person_link">김수연</a>
		                        </td>
		                    </tr>
		                    <tr>
		                        <th>자동차소재부품</th>
		                        <td>
		                        	<a href="javascript:getPersonInfo('00207776','kwonjihye')" class="person_link">권지혜</a>
		                        </td>
		                        <td class="rightL">
		                        	<!-- <a href="javascript:getPersonInfo('00206813','suyune')" class="person_link">김수연</a> -->
		                        	<a href="javascript:getPersonInfo('00208667','jyhan')" class="person_link">한종윤</a>
		                        </td>
		                    </tr>
		                    <tr>
		                        <th>창호</th>
		                        <td>
		                        	<!-- <a href="javascript:getPersonInfo('00208220','jihachoi')" class="person_link">최지하</a> -->
		                        	<a href="javascript:getPersonInfo('00207776','kwonjihye')" class="person_link">권지혜</a>
		                        </td>
		                        <td class="rightL">
		                        	<!-- <a href="javascript:getPersonInfo('00207783','kimsb')" class="person_link">김샛별</a> -->
		                        	<a href="javascript:getPersonInfo('00208667','jyhan')" class="person_link">한종윤</a>
		                        </td>
		                    </tr>

		                    <tr>
		                        <th>장식재</th>
		                        <td>
		                        	<a href="javascript:getPersonInfo('00208220','jihachoi')" class="person_link">최지하</a>
		                        </td>
		                        <td class="rightL">
		                        	<a href="javascript:getPersonInfo('00207783','kimsb')" class="person_link">김샛별</a>,
		                        	<a href="javascript:getPersonInfo('00208667','jyhan')" class="person_link">한종윤</a>
		                        </td>
		                    </tr>
		                    <tr>
		                        <th>표면소재</th>
		                        <td>
		                        	<a href="javascript:getPersonInfo('00207776','kwonjihye')" class="person_link">권지혜</a> ,
		                        	<a href="javascript:getPersonInfo('00208220','jihachoi')" class="person_link">최지하</a>
		                        </td>
		                        <td class="rightL">
		                        	<!-- <a href="javascript:getPersonInfo('00207466','chlee')" class="person_link">이종한</a>, -->
		                        	<a href="javascript:getPersonInfo('00208522','leesangheon')" class="person_link">이상헌</a>
		                        </td>
		                    </tr>

		                 </tbody>
		            </table>
		        </div><!-- table end -->

				<div class="clear"></div>


			</div><!-- //sub-content -->
		</div><!-- //contents -->

	</body>
</html>