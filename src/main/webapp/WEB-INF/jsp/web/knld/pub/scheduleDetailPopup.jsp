<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: scheduleDetailPopup.jsp
 * @desc    : 연구소 주요일정 상세 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
				 
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .search-toggleBtn {display:none;}
</style>

	<script type="text/javascript">
        
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
             
            var dm = new Rui.data.LDataSetManager();
            
            dm.on('load', function(e) {
            });
            
            dm.on('success', function(e) {
                var data = parent.dayDataSet.getReadData(e);
                
                alert(data.records[0].resultMsg);
                
                if(data.records[0].resultYn == 'Y') {
                	parent.getDayScheduleList();
                	parent.scheduleDetailDialog.cancel();
                }
            });
            
            /* 수정화면 이동 */
            goModify = function() {
            	nwinsActSubmit(aform, "<c:url value="/knld/schedule/saveSchedulePopup.do"/>");
            };
            
            /* 삭제 */
            deleteSchedule = function(type) {
            	if(confirm('삭제 하시겠습니까?')) {
                    dm.updateDataSet({
                        url:'<c:url value="/knld/schedule/deleteSchedule.do"/>',
                        params: {
                        	labtAdscId : $('#labtAdscId').val()
                        }
                    });
            	}
            };
            
            /* 반복일정 삭제 */
            deleteGroupSchedule = function(type) {
            	if(confirm('반복일정을 삭제 하시겠습니까?')) {
                    dm.updateDataSet({
                        url:'<c:url value="/knld/schedule/deleteSchedule.do"/>',
                        params: {
                        	labtAdscGroupId : $('#labtAdscGroupId').val()
                        }
                    });
            	}
            };
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="labtAdscId" name="labtAdscId" value="<c:out value="${inputData.labtAdscId}"/>"/>
		<input type="hidden" id="labtAdscGroupId" name="labtAdscGroupId" value="<c:out value="${scheduleInfo.labtAdscGroupId}"/>"/>
		
   		<div class="LblockMainBody">

   			<div>
   				
   				<div class="titArea">
   					<div class="LblockButton">
   				<c:if test="${inputData._userId == scheduleInfo.rgstId}">
   						<button type="button" class="btn"  id="modifyBtn" name="modifyBtn" onclick="goModify()">수정</button>
   						<button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="deleteSchedule()">삭제</button>
   					<c:if test="${scheduleInfo.labtAdscGroupCnt > 1}">
   						<button type="button" class="btn"  id="deleteGroupBtn" name="deleteGroupBtn" onclick="deleteGroupSchedule()">반복일정삭제</button>
   					</c:if>
   				</c:if>
   						<button type="button" class="btn"  id="cancelBtn" name="cancelBtn" onclick="parent.scheduleDetailDialog.cancel()">닫기</button>
   					</div>
   				</div>
	   			
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:90px;"/>
   						<col style="width:290px;"/>
   						<col style="width:90px;"/>
   						<col style=""/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">제목</th>
   							<td colspan="3">${scheduleInfo.adscTitl}</td>
   						</tr>
   						<tr>
   							<th align="right">일정구분</th>
   							<td>${scheduleInfo.adscKindNm}</td>
   							<th align="right">등록자</th>
   							<td>${scheduleInfo.rgstNm}</td>
   						</tr>
   						<tr>
   							<th align="right">일정일</th>
   							<td>${scheduleInfo.adscDt}</td>
   							<th align="right">일정시간</th>
   							<td>${scheduleInfo.adscStrtTim}:${scheduleInfo.adscStrtMinu} ~ ${scheduleInfo.adscFnhTim}:${scheduleInfo.adscFnhMinu}</td>
   						</tr>
   						<tr>
   							<th align="right">설명</th>
   							<td colspan="3">${fn:replace(scheduleInfo.adscSbc, nl, '<br/>')}</td>
   						</tr>
   					</tbody>
   				</table>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>