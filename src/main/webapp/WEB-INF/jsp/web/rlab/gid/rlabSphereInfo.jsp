<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlKind.jsp
 * @desc    : 분석분야소개
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.24  			최초생성
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<title><%=documentTitle%></title>
    <link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
    <link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.js"></script>
</head>

  <body style="overflow:auto">
		<div class="contents">
			<div class="titleArea">
				<a class="leftCon" href="#">
					<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
					<span class="hidden">Toggle 버튼</span>
				</a>    
				<h2>신뢰성시험 안내</h2>
		    </div>

			<div class="sub-content">
			
				<!-- tab-content start -->
				<div class="tab-content">
					
					<!-- 분석분야 -->
					<div class="tab-pane fade active in" id="tab01">
						<div class="tab_in" id="technical_tab01">
						
							<div class="analyze_field">
								<div class="analyze_box"><div class="analyze_img1"></div></div>
								<div class="analyze_cont">
									<div class="analyze_b_txt">
										장식재 사계절 시험
									</div>
									<div class="analyze_s_txt">고저온 싸이클 시험</div>
									<div class="analyze_s_txt">고온 유지시험</div>
									<div class="analyze_s_txt">저온 유지시험</div>
									<div class="analyze_s_txt">고온고습 유지시험</div>
								</div>
							</div>
		<!--
							<div class="clear"></div>
							<div class="analyze_line margin-10"></div> -->
		
							<div class="analyze_field">
								<div class="analyze_box"><div class="analyze_img2"></div></div>
								<div class="analyze_cont">
									<div class="analyze_b_txt">내후/내광성 시험</div>
									<div class="analyze_s_txt">축진 내후성 시험 (ISO 4892-2)</div>
									<div class="analyze_s_txt">축진 내광성 시험 (ISO 4892-3)</div>
									<div class="analyze_s_txt">가속 내후성 시험 (QUV/Spray)</div>
									<div class="analyze_s_txt">가속 내후성 시험 (WOM)</div>
									<div class="analyze_s_txt">UV/Condensation 시험</div>
								</div>
							 </div>
		
		<!--
							<div class="clear"></div>
							<div class="analyze_line margin-10"></div> -->
		
							<div class="analyze_field">
								<div class="analyze_box"><div class="analyze_img3"></div></div>
								<div class="analyze_cont">
									<div class="analyze_b_txt">옥외 폭로 시험</div>
									<div class="analyze_s_txt">일반 노출 시험</div>
									<div class="analyze_s_txt">Underglass 노출시험</div>
									<div class="analyze_s_txt">복층유리 시험</div>
									<div class="analyze_s_txt">완성창 노출시험</div>
									<div class="analyze_s_txt">PF단 열재 노출시험</div>
								</div>
							 </div>
		
		<!--
							<div class="clear"></div>
							<div class="analyze_line margin-10"></div> -->
		
							<div class="analyze_field">
								<div class="analyze_box"><div class="analyze_img4"></div></div>
								<div class="analyze_cont">
									<div class="analyze_b_txt">환경 시험</div>
									<div class="analyze_s_txt">고온잼버 유지시험</div>
									<div class="analyze_s_txt">고온고습잼버 유지시험</div>
									<div class="analyze_s_txt">고저온 잼버 싸이클 시험</div>
									<div class="analyze_s_txt">열충격 시험</div>
									<div class="analyze_s_txt">저온잼버 유지 시험</div>
									<div class="analyze_s_txt">완성창 가속주행 왕복시험</div>
								</div>
							</div>
		
		<!--
							<div class="clear"></div>
							<div class="analyze_line margin-10"></div> -->
						</div>
					</div>
					<!--  //분석분야 -->


					<!-- 분석 담당자 -->
					<div class="tab-pane fade" id="tab02">
						<div style="padding:20px; height:700px;">
							<img src="/iris/resource/web/images/newIris/img_tachnical_imsi.png">
						</div>
					</div>
					<!--  //분석 담당자 -->


					<!-- 분석의뢰 절차 -->
					<div class="tab-pane fade" id="tab03">
						<div style="padding:20px;">
							<ul class="processs">
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_consulting.png" alt=""></p>
									<p>1. 신뢰성 시험의뢰 등록</p>
								</li>
								<li class="next_pr"></li>
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_write.png" alt=""></p>
									<p>2. 시험 상담 </p>
								</li>
								<li class="next_pr"></li>
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_img.png" alt=""></p>
									<p>3. 시험 설계 및 접수</p>
								</li>
		                                                                                   						
								<li class="dn_pr bg_none"><p class="subtxt">[저장] > <span class="txt-red">'등록중'</span> > PL결재 > <span class="txt-red">접수대기</span></p></li>
								<li class="bg_none2"></li>
								<li class="dn_pr bg_none"><p class="subtxt">시럼법 및 시험기간 구체화 시료 전달</p></li>
								<li class="bg_none2"></li>
								<li class="dn_pr"><p class="subtxt"><span class="txt-red">'접수완료'</span></p></li>
		
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/procedure_i_06.png" alt=""></p>
									<p>6. 시험결과 피드백</p>
								</li>
								<li class="prev_pr"></li>
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_report.png" alt=""></p>
									<p>5.시험 정료 및 리포팅</p>
								</li>
								<li class="prev_pr"></li>
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_fb.png" alt=""></p>
									<p>4.시험진행</p>
								</li>
								
								<li class="dn_pr bg_none"><p class="subtxt"></p></li>
								<li class="bg_none2"></li>
								<li class="dn_pr bg_none"><p class="subtxt"><span class="txt-red">'시험완료'</span></p></li>
								<li class="bg_none2"></li>
								<li class="dn_pr bg_none"><p class="subtxt"><span class="txt-red">'시험진행'</span></p></li>
		
							<ul>
						</div>
					</div>
					<!-- //분석의뢰 절차 -->
				</div>
				<!-- //tab-content end -->
								
			</div>
			<!-- //sub-content -->
		</div><!-- //contents -->

</body>
</html>