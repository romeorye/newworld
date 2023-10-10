<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<script type="text/javascript">

closePop = function(){
	
	var checkYn = document.getElementById("cookieChk");
	
	if ( checkYn.checked ){
		var todayDate = new Date();
		
		todayDate.setDate( todayDate.getDate()+ 1);
		document.cookie = "notic=done;expires="+todayDate.toGMTString()+";";
	}

	close();
}

</script>
<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>
</head>
<body>
<div class="titArea">
			[중요] SAP CLOUD 이전 작업에 따른 시스템 중단 안내 (23.10.13(금) 18:00 PM ~ 23.10.16(월)  6:00 AM)
</div>
</br>
</br>
SAP(ERP) CLOUD 이전 작업으로 인해  일부 시스템을 사용할 수 없습니다.</br>
아래 일정 및 리스트 참고하시기 바랍니다.</br>
</br>
1. 일정 : 23.10.13(금) 18:00 PM ~ 23.10.16(월)  06:00 AM</br>
</br>
</br>
2. 내용</br>
   위의 일정 동안 ERP 연계 부분에 있어 장상적으로 동작이 안 되니 사전에 업무 준비 바랍니다.</br>
  </br> 
  </br> 
  </br> 
 <input  type="checkbox" id="cookieChk" name="cookieChk" onClick="javascript:closePop()">오늘 하루동안 보지 않기</input>
</body>
</html>