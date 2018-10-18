<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>

<div id="rlabRqprStptDiv">
   				<form name="bform" id="bform" method="post">
   				<table class="table" id="saveStpt">
   					<colgroup>
   						<col style="width:20%;"/>
   						<col style="width:60%;"/>
   						<col style="width:20%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th>시험 상담의 질</th>
   							<td>
   								<div id="rlabCnsQlty"></div>
   							</td>
   							<td class="t_center" rowspan="3">
   								<a style="cursor: pointer;" onclick="rlabStptSave();" class="btnL">저장</a>
   							</td>
   						</tr>
   						<tr>
   							<th>시험 완료 기간</th>
   							<td>
   								<div id="rlabTrmQlty"></div>
   							</td>
   						</tr>
   						<tr>
   							<th>전체적인 만족도</th>
   							<td>
   								<div id="rlabAllStpt"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<table class="table" id="rsltStpt">
   					<colgroup>
						<col style="width:30%;">
						<col style="width:10%;">
						<col style="width:50%;">
						<col style="width:10%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<th>시험 상담의 질</th>
   							<td class="t_right">도움 안됨</td>
   							<td>
   								<div id="rlabCnsQltyRslt" style="background-color:#f1b224;width:0%;height:70%"></div>
   							</td>
   							<td>매우 유익함</td>
   						</tr>
   						<tr>
   							<th>시험 완료 기간</th>
   							<td class="t_right">도움 안됨</td>
   							<td>
   								<div id="rlabTrmQltyRslt" style="background-color:#f1b224;width:0%;height:70%"></div>
   							</td>
   							<td>매우 유익함</td>
   						</tr>
   						<tr>
   							<th>전체적인 만족도</th>
   							<td class="t_right">도움 안됨</td>
   							<td>
   								<div id="rlabAllStptRslt" style="background-color:#f1b224;width:0%;height:70%"></div>
   							</td>
   							<td>매우 유익함</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				</form>
   				</div>
</body>
</html>