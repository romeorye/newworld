<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: mchnInfoList.jsp
 * @desc    : Instrument >  공간성능평가 Tool > 보유 TOOL > 보유TOOL 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.23     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
<link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>

	<script type="text/javascript">
	
	
		Rui.onReady(function() {
			var mchnClCd = '${inputData.mchnClCd}';
			
			var tabView = new Rui.ui.tab.LTabView({
                tabs: [
                	// 전체 탭 주석 처리
            		//{ label: '전체', 			content: '<div id="tabContent0"></div>' },
                    { label: 'Simulation',       	content: '<div id="tabContent1"></div>' },
            		{ label: 'Mock-up',        content: '<div id="tabContent2"></div>' },
                    { label: 'Certification',        content: '<div id="tabContent3"></div>' },
                    { label: 'Measurement',        content: '<div id="tabContent4"></div>' }
                ]
            });
			
			goPage = function(target, mchnClCd) {
	        	$('#mchnClCd').val(mchnClCd);
	        	$('#opnYn').val("ALL");
	        	tabUrl = "<c:url value='/mchn/open/spaceMchn/retrieveMchnTab.do'/>";
	            
	        	nwinsActSubmit(document.aform, tabUrl, target);
	        }
			
			tabView.render('tabView');
			
			tabView.on('activeTabChange', function(e){
				//iframe 숨기기
	            for(var i = 0; i < 5; i++) {
	                if(i == e.activeIndex) {
	                    Rui.get('tabContentIfrm' + i).show();
	                }
	                else {
	                    Rui.get('tabContentIfrm' + i).hide();
	                }
	            }

	            var tabUrl = "";
	            
	        	switch(e.activeIndex){
	        	//Simulation
	        	case 0:
	                goPage('tabContentIfrm0', '01');
	        		break;
	            //Mock-up
	        	case 1:
                	goPage('tabContentIfrm1', '02');
	        		break;
	        	//Certification
	        	case 2:
                	goPage('tabContentIfrm2', '03');
	        		break;
	        	//Measurement
	        	case 3:
                	goPage('tabContentIfrm3', '04');
	        		break;
	        	}
	        	

	        });
			
			if(Rui.isEmpty(mchnClCd)){
				mchnClCd = "ALL";
			}
			
			//원하는 탭으로 호출
			if(mchnClCd == ''|| mchnClCd == 'ALL'){
				tabView.selectTab(0);
			}
			else if(mchnClCd == '01'){
				tabView.selectTab(0);
			}
			else if(mchnClCd == '02'){
				tabView.selectTab(1);
			}
			else if(mchnClCd == '03'){
				tabView.selectTab(2);
			}
			else if(mchnClCd == '04'){
				tabView.selectTab(3);
			}

			
		});	//end ready
	
		function fncMchnDtlMove(id){
			var frm = document.aform;

			frm.mchnInfoId.value = id;
			frm.target = "_self";
			frm.action = "<c:url value="/mchn/open/spaceMchn/retrieveMchnDtl.do"/>";
			frm.submit();
		}

		
	</script>
	
		
</head>
<body>
<!-- contents -->  
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
			<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			<span class="hidden">Toggle 버튼</span>
		</a>    
		<h2>보유 TOOL</h2>
    </div>
	<!-- sub-content -->
	<div class="sub-content">
		<!-- 메인1 tab start --><!-- **** rui 컴포넌트 이용시 불필요한 내용임 **** --> 
        <div id="tabView"></div>
        <br>
        <!-- 메인1  tab end -->
		<form  name="aform" id="aform" method="post">
			<input type="hidden" id="mchnClCd" name="mchnClCd" />
			<input type="hidden" id="mchnInfoId" name="mchnInfoId" />
			<input type="hidden" id="cbSrh" name="cbSrh" />
			<input type="hidden" id="srhInput" name="srhInput" />
			<input type="hidden" id="opnYn" name="opnYn" />
 				<iframe name="tabContentIfrm0" id="tabContentIfrm0" scrolling="no" width="100%" height="700px" frameborder="0" ></iframe>
 				<iframe name="tabContentIfrm1" id="tabContentIfrm1" scrolling="no" width="100%" height="700px" frameborder="0" ></iframe>
 				<iframe name="tabContentIfrm2" id="tabContentIfrm2" scrolling="no" width="100%" height="700px" frameborder="0" ></iframe>
 				<iframe name="tabContentIfrm3" id="tabContentIfrm3" scrolling="no" width="100%" height="700px" frameborder="0" ></iframe>
 				<iframe name="tabContentIfrm4" id="tabContentIfrm4" scrolling="no" width="100%" height="700px" frameborder="0" ></iframe>

		</form>
		
	</div>
	<!-- //sub-content -->
</div>
<!-- //contents -->
</body>
</html>