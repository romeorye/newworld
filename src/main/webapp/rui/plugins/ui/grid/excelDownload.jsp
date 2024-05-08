<%

request.setCharacterEncoding("UTF-8"); 

String fileName = request.getParameter("LFileName");
String excelData = request.getParameter("LExcelData");
String LExcelType = request.getParameter("LExcelType");
if(excelData == null) excelData = "";

if("xml".equals(LExcelType)) {
%><?xml version="1.0" encoding="utf-8"?>
<%
} else if("json".equals(LExcelType)){
	response.setHeader("Content-Description", "JSP Generated Data");
// 	response.setContentType("application/vnd.ms-excel;charset=euc-kr");

	response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	
	fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
	response.setHeader("Content-Disposition","attachment;filename="+fileName+";");
	
	byte datas[] = devonframework.bridge.rui.util.LRuiExcelConverter.convertToExcel(excelData);
	java.io.BufferedInputStream bis = new java.io.BufferedInputStream(new java.io.ByteArrayInputStream(datas));
    
    try{
        int data = -999;
        while(-1 != (data=bis.read())){
            out.write(data);
        }
    }finally{
        bis.close();
    }
    return;
} else {
%>
<!DOCTYPE html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Cache-Control" content="no-cache; no-store; no-save"/>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;charset=UTF-8"/>
<%
}
response.setHeader("Content-Description", "JSP Generated Data");

// response.setContentType("application/vnd.ms-excel");
response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
response.setHeader("Content-Disposition","attachment;filename="+fileName+";");


out.print(excelData);
%>