<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: anlChrgDialog.jsp
 * @desc    : 분석담당자 선택 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
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

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">

		setAnlChrgInfo = function(id, name) {
			var anlChrgInfo = {
					id : id,
					name : name
			};

			parent._callback(anlChrgInfo);

			parent.anlChrgListDialog.submit(true);
		};

	</script>
    </head>
    <body>
	* 기타 사업조직 분석의뢰 시, 분석 PJT PL과 상담해주시기 바랍니다.
	<table class="table p-admin">
		<colgroup>
			<col style="width:20%;"/>
			<col style="width:20%;"/>
			<col style="width:20%;"/>
			<col style="width:20%;"/>
			<col style="width:20%;"/>
		</colgroup>
		<tbody>
			<thead>
                <tr>
                    <th>사업분야</th>
                    <th>형상분석</th>
                    <th>유기분석</th>
                    <th>TVOC, HCHO</th>
				    <th>무기, 방사선농도분석</th>
                </tr>
            </thead>
			<tbody>
         		<tr>
                  <th >연구소</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                      <a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">김수연</a>,
                      <a href="#" onClick="setAnlChrgInfo('elinkim', '김은경')">김은경</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;"  rowspan="5">
                      <a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">고재윤</a><br/>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;" rowspan="9">
                  		<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">권수민</a><br/>
                  </td>
              </tr>
         		<tr>
                  <th >자동차</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                      <a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">김수연</a>
                  </td>
              </tr>
         		<tr>
                  <th >단열재</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('duhwanlee', '이두환')">이두환</a>
                  </td>
              </tr>
			  <tr>
                  <th >바닥재</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                      <a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">고재윤</a><br/>
                  </td>
              </tr>
         		<tr>
                  <th >창호</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('elinkim', '김은경')">김은경</a>
                  </td>
              </tr>
              
              <tr>
                  <th >인테리어</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                      <a href="#" onClick="setAnlChrgInfo('elinkim', '김은경')">김은경</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;" rowspan="2">
                      <a href="#" onClick="setAnlChrgInfo('duhwanlee', '이두환')">이두환</a>
                  </td>
              </tr>
              <tr>
                  <th >벽지</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                      <a href="#" onClick="setAnlChrgInfo('duhwanlee', '이두환')">이두환</a>
                  </td>
              </tr>
         		<tr>
                  <th >표면소재</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('elinkim', '김은경')">김은경</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;" rowspan="2">
                      <a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">고재윤</a>
                  </td>
              </tr>
         		<tr>
                  <th >산업용필름</th>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>,
                  	<a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a>
                  </td>
                  <td style="text-align:center;vertical-align:middle !important;">
                  	<a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">김수연(데코,가전)</a></br>
                  	<a href="#" onClick="setAnlChrgInfo('elinkim', '김은경')">김은경(점착)</a>
                  </td>
              </tr>
      	</tbody>       
	</table>
	</body>
</html>