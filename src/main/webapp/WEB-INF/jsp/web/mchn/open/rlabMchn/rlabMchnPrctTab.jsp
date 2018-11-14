<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlMachineList.jsp
 * @desc    : Instrument > 신뢰성시험 장비 > 보유 장비 > 보유장비 상세화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.24    IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
	
<%
	Calendar c = Calendar.getInstance();	
	Calendar cal = Calendar.getInstance();
	Calendar cal2 = Calendar.getInstance();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", java.util.Locale.KOREA);
	int year = request.getParameter("year") == null ? cal.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("year"));
	int month = request.getParameter("month") == null ? cal.get(Calendar.MONTH) : (Integer.parseInt(request.getParameter("month")) - 1);
	
	String toMonth = "";
	 
	if(month+1 < 10){
		toMonth = "0"+String.valueOf(month+1);
	}else{
		toMonth = String.valueOf(month+1);
	}
	// 시작요일 확인
	// - Calendar MONTH는 0-11까지임
	cal.set(year, month, 1);
	
	ArrayList mchnPrctList = (ArrayList) request.getAttribute("mchnPrctList");
	HashMap<String, Object> item = null;
	
%>

<%!
     public boolean isDate(int y, int m, int d) {
          m -= 1;
          Calendar c = Calendar.getInstance();
          c.setLenient(false);
         
          try {
               c.set(y, m, d);
               Date dt = c.getTime();
          } catch(IllegalArgumentException e) {
               return false;
          }
          
          return true;
     }
%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
<link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">

<script type="text/javascript">
var mchnPrctInfoDialog;
var mchnPrctId;

	Rui.onReady(function() {
		mchnPrctId = '${inputDate.mchnPrctId}';
		
		
	});
	
	function fncPrevMon(){
		var frm = document.aform;

		frm.year.value = "<%=year%>";
		frm.month.value = "<%=month%>";
		frm.mchnClCd2.value = parent.aform.mchnClCd2.value;
		
		if(frm.month.value < 1){
			frm.year.value = "<%=year-1%>";
			frm.month.value = 12 -Number(frm.month.value);
		}
		
		if (frm.month.value  < 10){
			frm.month.value = "0"+frm.month.value+"";
		}
		
		frm.srhDt.value = frm.year.value+"-"+frm.month.value;
		frm.rtnUrl.value ="web/mchn/open/rlabMchn/rlabMchnPrctTab";
		frm.action = '<c:url value='/mchn/open/rlabMchn/retrieveMchnPrctTab.do'/>';
		frm.submit();
	}
	
	function fncNextMon(){
		var frm = document.aform;
		
		frm.year.value = "<%=year%>";
		frm.month.value ="<%=month+2%>";
		frm.mchnClCd2.value = parent.aform.mchnClCd2.value;
		
		if(frm.month.value > 12){
			frm.year.value = "<%=year+1%>";
			frm.month.value = Number(frm.month.value)-12;
		}
		
		if (frm.month.value  < 10){
			frm.month.value = "0"+frm.month.value+"";
		}
		frm.srhDt.value = frm.year.value+"-"+frm.month.value;
		frm.rtnUrl.value ="web/mchn/open/rlabMchn/rlabMchnPrctTab";
		frm.action = '<c:url value='/mchn/open/rlabMchn/retrieveMchnPrctTab.do'/>';
		frm.submit();
	}
	
	//내부 스크롤 제거
    $(window).load(function() {
        initFrameSetHeight();
    });

</script>


</head>
<body>
<form  id="aform" name="aform" method="post">
<input type="hidden" id="year" name="year" />
<input type="hidden" id="month" name="month" />
<input type="hidden" id="srhDt" name="srhDt" />
<input type="hidden" id="rtnUrl" name="rtnUrl" />
<input type="hidden" id="mchnClCd2" name="mchnClCd2" />
<input type="hidden" id="mchnInfoId" name="mchnInfoId"  value="<c:out value='${inputData.mchnInfoId}'/>">
 <!-- contents -->  
<div>
	<!-- sub-content -->
	<div class="sub-content">
		<!-- schedule_reserv -->
		<div class="schedule_reserv">
        <!-- sch_reserv_present -->
        <div class="sch_reserv_present">
            <font><b>예약방법</b> : 장비에 대한 예약을 원하시면 해당 날짜의 예약 현황을 확인 하신 후  일자를 클릭 하시면 예약이  가능 합니다.</font>
            <div class="tit_schedule_head">
                <div class="month_select">
                    <a href="javascript:fncPrevMon()" class="prev">이전</a>
                    <div class="this_month"><%=year%>.<%=toMonth%></div>
                    <a href="javascript:fncNextMon()" class="next">다음</a>
                </div>                        
            </div>
            <div class="reserv_table01">
                <!--table-->
                <table class="tbl01">
                    <caption>분류</caption>
                    <colgroup>
                        <col width="14.2%" />
                        <col width="14.4%" />
                        <col width="14.4%" />
                        <col width="14.4%" />
                        <col width="14.4%" />
                        <col width="14.4%" />
                        <col />
                    </colgroup>
                    <thead>
                    <tr>
                        <th class="ti_sun">Sun</th>
                        <th>Mon</th>
                        <th>Tue</th>
                        <th>Wed</th>
                        <th>Thu</th>
                        <th>Fri</th>
                        <th class="ti_sat">Sat</th>
                    </tr>
                    </thead>
                    <tbody>
<%
//'Calendar loop
     int currDay;
     String todayColor;
     int count = 1;
     int dispDay = 1;
     String tdClass = "weeks";
     boolean isDate = false;

     for (int w = 1; w < 7; w++){
%>
       <tr>
<%
          for (int d = 1; d < 8; d++){
               if (!(count >= cal.get(Calendar.DAY_OF_WEEK))) {

%>
          <td class="weeks">&nbsp;</td>
<%
                    count += 1;
               }else{
            	   
            	   	isDate = isDate (year, month + 1,dispDay);

                    if (isDate){
                         
                         cal2.set(year, month, dispDay);
%>
          <td class='<%=d==1 ? "sun" : (d==7 ? "sat" : "weeks") %>'>
          	<span class="date"><a href="javascript:parent.fncMchnPrctPop('','<%=year%>', '<%=month+1%>','<%=dispDay%>','');"><%=dispDay%></a></span>
          	<ul class='sche'>
          		<%
          		int chkQty = 0;
          		if ( mchnPrctList.size() > 0 ){
          			
          			for (int z=0; z < mchnPrctList.size(); z++){
          				item =  (HashMap<String, Object>)mchnPrctList.get(z);
          				int chkDt = Integer.valueOf(item.get("dateNo").toString());
          				
          				String mchnClCd = item.get("mchnClCd").toString();

          				if( dispDay == chkDt ){
          					chkQty = chkQty + 1;
          					if(mchnClCd.equals("01")){
				          		%>
				          		<li><a href="javascript:parent.fncMchnPrctPop('<%=item.get("mchnPrctId")%>','<%=year%>', '<%=month%>','<%=dispDay%>','<%=item.get("mchnClCd")%>');">
				          		    <%=item.get("testSpceNm")%>&nbsp;<span><%=item.get("rgstNm") %></span><br><%=item.get("testCnd") %>&nbsp;<%=item.get("cycleFlag") %>
				          		    </a>
				          		</li> 
				          		<%
					         } 
							if(mchnClCd.equals("02")){
								if(chkQty == 1){
					          		%>
					          		<li>
					          		    <span>총 시료수 <%=item.get("sumQty") %>/<%=item.get("totSmpoQty") %>
					          		</li> 
					          		<%							
								} 
				          		%>
				          		<li><a href="javascript:parent.fncMchnPrctPop('<%=item.get("mchnPrctId")%>','<%=year%>', '<%=month%>','<%=dispDay%>','<%=item.get("mchnClCd")%>');">
				          		    <span><%=item.get("rgstNm") %></span>&nbsp;<%=item.get("smpoQty") %>
				          		    </a>
				          		</li> 
				          		<%
							} 
							if(mchnClCd.equals("03")){
				          		%>
				          		<li><a href="javascript:parent.fncMchnPrctPop('<%=item.get("mchnPrctId")%>','<%=year%>', '<%=month%>','<%=dispDay%>','<%=item.get("mchnClCd")%>');">
				          		    <%=item.get("prctTim")%>&nbsp;<span><%=item.get("rgstNm") %></span>&nbsp;
				          		    </a>
				          		</li> 
				          		<%          						
							}
          				} 
          			}
          		}
          		%>
          	</ul>
          </td><%
                         count += 1;
                         dispDay += 1;
                         chkQty = 0;
                    }else{
%>
          <td class="weeks">&nbsp;</td>
<%
                    }
               }
       }	//end for d	
%>
       </tr>
<%
		if(dispDay >= 28 && isDate == false) {
			break;
		}
	}	//end for w
%>
                     </tbody>
                </table>       
            </div>
        </div>	
		<!-- // sch_reserv_present -->
		
	</div>
	<!-- //sub-content -->
	
</div>
<!-- //contents -->
</div>
</form>    
</body>
</html>          