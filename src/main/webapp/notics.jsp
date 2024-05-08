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
			[중요] IRIS+시스템 CLOUD 이전 작업에 따른 시스템 중단 안내 
</div>
</br>
</br>
고객님께 더 나은 서비스를 제공하기 위해 클라우드 마이그레이션 작업을 진행하게 되었습니다.</br>
이에 따라, 아래와 같이 서비스가 일시적으로 중단될 예정입니다.</br>
</br>
- 서비스 중단 일시: [11/24(금) 19:00 ~ 11/27(월) 08:00]</br>
- 서비스 중단 예상 시간: [61시간]</br>
- 서비스 중단 대상: [아래 목록 참조]</br>
</br>
</br>
  </br> 
  </br> 
 <input  type="checkbox" id="cookieChk" name="cookieChk" onClick="javascript:closePop()">오늘 하루동안 보지 않기</input>
</body>
</html>