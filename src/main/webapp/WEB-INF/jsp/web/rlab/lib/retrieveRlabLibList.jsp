<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: AnlLibList.jsp
 * @desc    : 분석자료실 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.27  			최초생성
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

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css" />
<style>
	.L-navset {overflow:hidden;}
</style>

<script type="text/javascript">
var bbsId = '${inputData.bbsId}';
var bbsCd = '${inputData.bbsCd}';
var refresh = "";

	Rui.onReady(function() {
       /*******************
        * 변수 및 객체 선언
        *******************/
        /* [TAB] */
        tabView = new Rui.ui.tab.LTabView({
        	tabs: [
        		{ label: '전체', content: '<div id="tabContent0"></div>' },
        		{ label: '신뢰성DB',            content: '<div id="tabContent1"></div>' },
                { label: '신뢰성자료실',         content: '<div id="tabContent2"></div>' },
                { label: '신뢰IP',       content: '<div id="tabContent3"></div>' }
            ]
        });

        goPage = function(target, bbsCd) {
        	var lvTarget = target;
        	$('#bbsId').val(bbsId);
        	$('#bbsCd').val(bbsCd);
        	$('#target').val(lvTarget);
        	tabUrl = "<c:url value='/rlab/lib/rlabLibTab.do'/>";
            nwinsActSubmit(document.aform, tabUrl, target);
        }


        tabView.on('activeTabChange', function(e){
        	 //iframe 숨기기
            for(var i = 0; i < 4; i++) {
                if(i == e.activeIndex) {
                    Rui.get('tabContentIfrm' + i).show();
                }
                else {
                    Rui.get('tabContentIfrm' + i).hide();
                }
            }

            var tabUrl = "";

        	switch(e.activeIndex){
        	//표준실험절차서(SOP)
        	case 0:
        		refresh  = true;
        		$('#h2Titl').text('자료실 - 전체');

        		if(e.isFirst){
                	goPage('tabContentIfrm0', '01');
                }else if(refresh==true){                //탭 이동시 작업중 화면이 아닌 리스트 화면으로 refresh
                	goPage('tabContentIfrm0', '01');
        		   	refresh = false;
    		   	}
        		break;
            //분석사례
        	case 1:
        		refresh  = true;
        		$('#h2Titl').text('자료실 - 신뢰성DB');

                if(e.isFirst){
                	goPage('tabContentIfrm1', '02');
                }else if(refresh==true){
                	goPage('tabContentIfrm1', '02');
        		   	refresh = false;
    		   	}

        		break;
        	//기기 매뉴얼
        	case 2:
        		refresh  = true;
        		$('#h2Titl').text('자료실 - 신뢰성자료실');

                if(e.isFirst){
                	goPage('tabContentIfrm2', '03');
                }else if(refresh==true){
                	goPage('tabContentIfrm2', '03');
        		   	refresh = false;
    		   	}

        		break;
        	//분석 기술정보
        	case 3:
        		refresh  = true;
        		$('#h2Titl').text('자료실 - 신뢰IP');

                if(e.isFirst){
                	goPage('tabContentIfrm3', '04');
                }else if(refresh==true){
                	goPage('tabContentIfrm3', '04');
        		   	refresh = false;
    		   	}

        		break;
        	}
        });

        tabView.render('tabView');

        //원하는 탭으로 호출
		if(bbsCd == ''|| bbsCd == '01'){
			tabView.selectTab(0);
		}
		else if(bbsCd == '02'){
			tabView.selectTab(1);
		}
		else if(bbsCd == '03'){
			tabView.selectTab(2);
		}
		else if(bbsCd == '04'){
			tabView.selectTab(3);
		}

       });//onReady 끝
</script>
</head>

    <body>
	   	<div class="contents">
		<form  name="aform" id="aform" method="post">
		<input type="hidden" id="bbsId" name="bbsId" value=""/>
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="target" name="target" value=""/>

 		<div class="titleArea">
			<h2 id="h2Titl"></h2>
		</div>

   		<div id="tabView"></div><br/>
 		<iframe name="tabContentIfrm0" id="tabContentIfrm0" scrolling="yes" width="100%" height="650px" frameborder="0" ></iframe>
 		<iframe name="tabContentIfrm1" id="tabContentIfrm1" scrolling="yes" width="100%" height="650px" frameborder="0" ></iframe>
 		<iframe name="tabContentIfrm2" id="tabContentIfrm2" scrolling="yes" width="100%" height="650px" frameborder="0" ></iframe>
 		<iframe name="tabContentIfrm3" id="tabContentIfrm3" scrolling="yes" width="100%" height="650px" frameborder="0" ></iframe>

		</form>
   		</div><!--//content end-->
    </body>
</html>