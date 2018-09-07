<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: openOpinitionPopup.jsp
 * @desc    : 평가 > 평가의뢰 > 평가목록 > 의견 >
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.01.16     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title>Insert title here</title>
<script>
Rui.onReady(function() {
	var opi = '<c:out value="${inputData.opiSbc}"/>';
	var opiSbc1 = opi.replaceAll("&lt;br/&gt;", "\n");

	var opiSbc = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
        applyTo: 'opiSbc',                           // 해당 DOM Id 위치에 텍스트박스를 적용
        width: 585,                                    // 텍스트박스 폭을 설정
        height: 250,
        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
    });

	opiSbc.setValue(opiSbc1);
})
</script>
</head>
<body>
<div class="bd">
	<div class="sub-content">
		<table class="table table_txt_right">
			<tr>
				<td>
					<input type="text" id="opiSbc" name="opiSbc" />
				</td>
			</tr>
		</table>
	</div>
</div>
</body>
</html>