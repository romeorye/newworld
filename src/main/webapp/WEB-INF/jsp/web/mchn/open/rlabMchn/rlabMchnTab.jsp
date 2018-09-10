<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%--
/*
 *************************************************************************
 * $Id		: rlabMchnTab.jsp
 * @desc    : Instrument > 신뢰성시험 장비 > 보유 장비 > 분석자료실 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.27   IRIS05			최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<%
	ArrayList mchnList = (ArrayList) request.getAttribute("mchnList");
	HashMap<String, Object> item = new HashMap<String, Object>();
%>
<title><%=documentTitle%></title>
<link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
<link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">

	<script type="text/javascript">
	var fnSearch;
	
		Rui.onReady(function(){
			
			var mchnClCd = document.aform.mchnClCd.value;

			var opnYn = '${inputData.opnYn}';
			var cbSrh = '${inputData.cbSrh}';
			var srhInput = '${inputData.srhInput}';
		
			if(!Rui.isEmpty(opnYn)){
				var radio = document.all.opnYn;
				
				for ( var i = 0; i < radio.length; i++ ) {
					if(radio[i].value == opnYn){
						radio[i].checked = true;
					} 
				}
			}
			if(!Rui.isEmpty(cbSrh)){
				document.aform.cbSrh.value = cbSrh;
			}
			if(!Rui.isEmpty(srhInput)){
				document.aform.srhInput.value = srhInput;
			}
			
			var url = "<c:url value='/mchn/open/rlabMchn/retrieveMchnTab.do'/>";
			fnSearch = function() {
				var frm = document.aform;
				//frm.opnYn.value = opnYn;
				//frm.mchnClCd.value = mchnClCd;
				frm.action = url;
				frm.submit();
	     	}
		});	//end ready
	
		 //내부 스크롤 제거
	    $(window).load(function() {
	        initFrameSetHeight();
	    });

	</script>
<body>	
	<!-- sub-content -->
	<div class="sub-content">
        <form class="equ" name="aform" id="aform" method="post">
        	<input type="hidden" id="mchnClCd" name="mchnClCd" value="<c:out value='${inputData.mchnClCd}'/>">
            <fieldset>
            	<span class="table_summay_number" id="cnt_text">총 <%=mchnList.size()%>건</span>
            	
                <div class="fr">
                	<input type="radio" id="opnYn" name="opnYn" value="ALL">전체</>&nbsp;
                    <input type="radio" id="opnYn" name="opnYn" value="Y">OPEN</>&nbsp;&nbsp;&nbsp;
                    <select class="select" id="cbSrh" name="cbSrh">
                        <option value="nm">장비명</option>
                        <option value="id">담당자명</option>
                    </select>
                    <div class="equ_search"><span class="equ_info"><input type="text" id="srhInput" name="srhInput" class="equ_search_input" placeholder="검색어를 입력하세요" onkeypress="if(event.keyCode==13) {fnSearch();}"> <a href="javascript:fnSearch();"><span class="equ_icon_search"></span></a></span></div>
                </div>
                
                
            </fieldset>
        </form>
     	 <!-- equipment -->
        <ul class="equipment">
				<%
				for(int i =0 ; i < mchnList.size(); i++){
					String url = "/system/attach/downloadAttachFile.do";
					item = (HashMap<String, Object>)mchnList.get(i);
					String param ="?attcFilId="+item.get("attcFilId")+"&seq="+item.get("seq");
					url = url+param;
				%>
					<li>
	                	<div>
	                		<div class="equipment_box"><img src='<c:url value="<%=url%>"/>'/></div>
		                    <div class="contxt">
		                     <a href="javascript:parent.fncMchnDtlMove('<%=item.get("mchnInfoId")%>');" >
		                        <ul>
		                        	<li class="txt_b">
		                                <span><%=item.get("mchnHanNm")%> | <%=item.get("mchnEnNm")%></span>
		                                <div class="normal_icon01">
		                               <%if( item.get("mchnUsePsblYn").equals("Y") ){ %>
			                                <span class="icon01"></span>
		                                	<span class="pt1"><%=item.get("mchnUsePsblNm")%></span>
		                               <%}else{ %>
			                                <span class="icon02"></span>
		                                	<span class="pt2"><%=item.get("mchnUsePsblNm")%></span>
		                               <%} %>
	                                	</div>
		                             	<%if( item.get("opnYn").equals("Y") ){ %>
		                             	<div class="normal_icon01">
			                                <span class="icon03"></span>
		                                	<span class="pt3"><%=item.get("opnNm")%></span>
	                                	</div>
		                               <%}%>
		                            </li>
		                            <li class="txt_box_s"><%=item.get("mdlNm")%> | <%=item.get("mkrNm")%></li>
		                            <li class="txt_s"><%=item.get("mchnExpl")%></li>
		                            <!--  
		                            <li class="txt_ss">[ <%=item.get("mchnLoc")%> ] <%=item.get("crgrNm")%></li>
		                            -->
		                            <li class="txt_ss">담당자 : <%=item.get("crgrNm")%></li>
		                        </ul>
		                     </a>   
		                    </div>
		                 </div>
		                <div class="clear"></div>
		            </li>
				<%} %>
  		</ul>
   		<!-- // equipment -->

	</div>
	<!-- //sub-content -->
</body>
</html>
	