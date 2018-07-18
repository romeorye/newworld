<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*"%>
<%--
/*
 *************************************************************************
 * $Id      : genWbsGanttChartPopup.jsp
 * @desc    : 간트차트
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.11
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<link rel="stylesheet" type="text/css" href="<%=cssPath%>/jsgantt.css" />
<script language="javascript" src="<%=scriptPath%>/jsgantt.js"></script>


<div style="position:relative" class="gantt" id="GanttChartDIV"></div>
<script>

  var g = new JSGantt.GanttChart('g',document.getElementById('GanttChartDIV'), 'week');

  g.setShowRes(1); // Show/Hide Responsible (0/1)

  g.setShowDur(1); // Show/Hide Duration (0/1)

  g.setShowComp(0); // Show/Hide % Complete(0/1)

  g.setCaptionType('Resource');  // Set to Show Caption

  if( g ) {

	   if(${resultCnt} > 0) {
			<c:forEach var="rst" items="${rstList}">
		
			var color = "ffff00";
			<c:choose>
		 	<c:when test="${rst.depth == '1'}"> color = "00ffff" ; </c:when>
		 	<c:when test="${rst.depth == '2'}"> color = "00ff00" ;</c:when>
		 	
		 	<c:otherwise>color = "990000" ;</c:otherwise>
		 	</c:choose>
				g.AddTaskItem(new JSGantt.TaskItem("${ rst.wbsSn }",   '${ rst.tssNm }',   '${ rst.strtDt }', '${ rst.fnhDt }', color, ''//href
    												, 0,  '${ rst.saSabunNewNm }',  1, '${ rst.drRow }', '${ rst.depth}', 1));
	    	</c:forEach>
	    	
	   }else{
		   alert("not defined");
	   }
    
	 g.Draw();   

    g.DrawDependencies();
 

  }else{
    alert("not found data.");
  }

</script>

