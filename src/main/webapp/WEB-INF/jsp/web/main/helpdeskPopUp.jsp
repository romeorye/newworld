<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>

<script >
	function init(){
		document.mainForm2.emp_no.value = '${inputData.emp_no}';
		document.mainForm2.fmd5_emp_no.value = '${inputData.fmd5_emp_no}';
		
		document.mainForm2.action = "http://espoc.lgcns.com/LGCNS.GES.UI.MAIN/LOGINCUST/LoginCustNew.aspx";
		document.mainForm2.target = "_self";
		document.mainForm2.submit();
	}
</script>

</head>
<body onload="init();">
<form  name="mainForm2" method="post">
 <input type="hidden" name="emp_no" />
 <input type="hidden" name="fmd5_emp_no" />
 <input type="hidden" name="comp_no" value="921700">
</form>


</body >
</html>