<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Tag" uri="http://www.dev-on.com/Tag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%--
/*
 *************************************************************************
 * $Id		: scheduleMonthList.jsp
 * @desc    : 연구소 주요일정 월별 리스트 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
	
<%
	Calendar c = Calendar.getInstance();
	Calendar cal = Calendar.getInstance();
	Calendar cal2 = Calendar.getInstance();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", java.util.Locale.KOREA);
	String adscMonth = (String)((HashMap<String, Object>)request.getAttribute("inputData")).get("adscMonth");
	int year = Integer.parseInt(adscMonth.substring(0, 4));
	int month = Integer.parseInt(adscMonth.substring(5)) - 1;
	
	// 시작요일 확인
	// - Calendar MONTH는 0-11까지임
	cal.set(year, month, 1);
	
	ArrayList monthScheduleList = (ArrayList) request.getAttribute("monthScheduleList");
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

<form name="aform" id="aform" method="post">
	<input type="hidden" name="adscMonth" id="adscMonth" value="<c:out value="${inputData.adscMonth}"/>"/>
</form>
        <!-- sch_reserv_present -->
        <div class="sch_reserv_present">
            <div class="tit_schedule_head">
                <div class="month_select">
                    <a href="javascript:getMonthScheduleList('<c:out value="${beforeMonth}"/>')" class="prev">이전</a>
                    <div class="this_month"><c:out value="${inputData.adscMonth}"/></div>
                    <a href="javascript:getMonthScheduleList('<c:out value="${afterMonth}"/>')" class="next">다음</a>
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
    <c:choose>
    	<c:when test="${fn:indexOf(inputData._roleId, 'WORK_IRI_T01') > -1}">
          	<span class="date"><a href="javascript:openScheduleRgstDialog('<%=formatter.format(cal2.getTime())%>');"><%=dispDay%></a></span>
	   	</c:when>
    	<c:when test="${inputData._userDept =='58129833'}">
          	<span class="date"><a href="javascript:openScheduleRgstDialog('<%=formatter.format(cal2.getTime())%>');"><%=dispDay%></a></span>
	   	</c:when>
	   	
	   	<c:otherwise>
          	<%=dispDay%>
    	</c:otherwise>
    </c:choose>
          	<ul class='sche'>
		          		<%
		          		if ( monthScheduleList.size() > 0 ){
		          			for (int z=0; z < monthScheduleList.size(); z++){
		          				item =  (HashMap<String, Object>)monthScheduleList.get(z);
		          				int chkDt = Integer.valueOf(item.get("dateNo").toString());
		
		          				if (  item.get("adscTitl").toString().length()  > 15  ){
		          					item.put("adscTitl", item.get("adscTitl").toString().substring(0,15)+"..");	
		          				}
		          				if( dispDay == chkDt ){
		          		%>
          		<li><a href="javascript:openScheduleDetailDialog('<%=item.get("labtAdscId")%>');" style="color:<%="Y".equals(item.get("isToday")) ? "red" : ""%>"><%=item.get("adscTim")%><br/> <span><%=item.get("adscTitl").toString()%></span></a><br/></li> 
		          		<%
		          				}
		          			}
		          		}
		          		%>
          	</ul>
          </td><%
                         count += 1;
                         dispDay += 1;
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