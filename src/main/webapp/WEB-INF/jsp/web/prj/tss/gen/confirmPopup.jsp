<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>변경요청 팝업</title>
</head>
<body>
<pre>
본 변경요청은 단순 데이터 및 중간 심의간 변경 내용에 한해 진행 됩니다.

<b><span style = 'color : red'>1. GRS심의요청 </span></b>: 중간 심의를 통한 내용 변경건으로 GRS심의(GRS요청버튼)를 완료하신 후 
    변경요청을 해야 합니다.

- Case : 과제기간 / 개발등급 / 제품군 등  과제생성 간 관리자 입력 데이터
      ex1) 과제 총 기간 변경(종료 일정 24.10.31 → 24.12.31)
      ex2) 투입인원계획(MM)변경 되는 경우 (2.0 → 3.0 등) 
      ex3) ‘목표’항목이 추가/삭제 되는 경우
  
<b>2. 단순변경</b> : 위 Case 이외, 과제리더가 입력하는 데이터(개요 탭 → 산출물 등)
      ex1) 참여연구원의 추가 및 일정 수정(전,출입 인원 등)

변경 내용과 관련하여 <b><span style = 'color : red'>IRIS+ 사용자 매뉴얼</span></b> 참고 바람(문의사항 기술전략팀)
</pre>
</body>
</html>