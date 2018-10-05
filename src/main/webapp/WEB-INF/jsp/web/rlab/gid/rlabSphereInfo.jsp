<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabSphereInfo.jsp
 * @desc    : 분석분야소개
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.10.24  			최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>


<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css" />
<style>
	.L-navset {overflow:hidden;}
</style>
</head>
<script type="text/javascript">

	Rui.onReady(function() {
       /*******************
        * 변수 및 객체 선언
        *******************/
        /* [TAB] */
        tabView = new Rui.ui.tab.LTabView({
        	tabs: [
        		{ label: '신뢰성 시험분야', content: '<div id="tabContent0"></div>' },
        		{ label: '신뢰성 시험 담당자', content: '<div id="tabContent1"></div>' },
                { label: '신뢰성 시험 절차', content: '<div id="tabContent2"></div>' }
            ]
        });

        tabView.on('activeTabChange', function(e){
        	// 숨기기 / 보이기
            for(var i = 0; i < 3; i++) {
                if(i == e.activeIndex) {
                    Rui.get('tab' + i).show();
                }
                else {
                    Rui.get('tab' + i).hide();
                }
            }
        });

        tabView.render('tabView');

		//페이지 온로드시 0번째 탭 선택
        tabView.selectTab(0);

	});//onReady 끝
</script>

  <body style="overflow:auto">
		<div class="contents">
			<div class="titleArea">
				<a class="leftCon" href="#">
					<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
					<span class="hidden">Toggle 버튼</span>
				</a>
				<!-- <h2>분석분야</h2> -->
				<h2>공간성능평가 안내</h2>
		    </div>

			<div class="sub-content">


			    <!-- tab start -->
			    <div id="tabView"></div><br/>
				<!-- tab-content start -->

				<div class="tab-content">

					<!-- 평가분야 -->
					<div class="tab-pane fade active in" id="tab0">

						탭1

					</div>
					<!--  //평가분야 -->


					<!-- 평가 담당자 -->
					<div class="tab-pane fade" id="tab1" >

						탭2

					</div>
					<!--  //평가 담당자 -->


					<!-- 평가의뢰 절차 및 메뉴얼 -->
					<div class="tab-pane fade" id="tab2" >

						탭3

					</div>
					<!-- //평가의뢰 절차 및 메뉴얼 -->
				</div>
				<!-- //tab-content end -->
				<!-- //tab end -->

			</div><!-- //sub-content -->
		</div><!-- //contents -->

</body>
</html>