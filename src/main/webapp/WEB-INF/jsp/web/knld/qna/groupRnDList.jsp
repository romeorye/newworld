<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: groupRnDList.jsp
 * @desc    : Group R&D 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
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
</style>

	<script type="text/javascript">

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            boardType = new Rui.ui.form.LCombo({
                applyTo: 'boardType',
                name: 'boardType',
                useEmptyText: false,
                selectedIndex: 0,
                width: 140,
                items: [
                    { value: 'http://lgrnd.lg.co.kr/rnd/board/BoardItemListView.do?moduleType=BD2&boardSystemId=1&board.boardId=1231295517265&folder.folderId=1231295517265&boardSkin=&isSkin=Y', text: 'Group Q&A'},
                    { value: 'http://lgrnd.lg.co.kr/rnd/board/BoardItemListView.do?moduleType=BD2&boardSystemId=1&board.boardId=1231399643000&folder.folderId=1231399643000&boardSkin=&isSkin=Y', text: 'Idea 제안방'},
                    { value: 'http://lgrnd.lg.co.kr/rnd/board/BoardItemListView.do?moduleType=BD2&boardSystemId=1&board.boardId=1329334632769&folder.folderId=1329334632769&boardSkin=&isSkin=Y', text: 'Technology Center'}
                ]
            });

            boardType.on('changed', function(e) {
                $('#listIFrm').attr('src', e.value);
            });

            rndForm.submit();
        });

	</script>
    </head>
    <body>
    <div class="titleArea">
 			<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>
			<h2 id="h2Titl">Group Q&A</h2>
		</div>

    <form name="rndForm" id="rndForm" method="post" action="http://lgrnd.lg.co.kr/LGRnDLogin.do" target="hiddenIFrame">
    	<input type="hidden" name="cid" value="LG06"/>
    	<input type="hidden" name="authKey" value="<c:out value="${inputData.authKey}"/>"/>
    	<input type="hidden" name="userInfo" value="<c:out value="${inputData.userInfo}"/>"/>
    	<input type="hidden" name="boardCd" value="01"/>
    </form>
	<form name="aform" id="aform" method="post">

   		<div class="contents">

   			<div class="sub-content">
	   			<div id="boardType"></div>
   				<br/>
   				<iframe id="listIFrm" src="" frameborder="0" scrolling="no" style="width:100%; height:630px;"></iframe>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
	<iframe id="hiddenIFrame" name="hiddenIFrame" style="display:none;" onLoad="try{boardType.doChanged()}catch(e){}"></iframe>
    </body>
</html>