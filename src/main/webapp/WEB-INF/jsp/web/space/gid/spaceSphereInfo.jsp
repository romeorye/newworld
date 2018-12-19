<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceSphereInfo.jsp
 * @desc    : 안내
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
        		{ label: '평가분야', content: '<div id="tabContent0"></div>' },
        		{ label: '평가담당자', content: '<div id="tabContent1"></div>' },
                { label: '평가의뢰 절차 및 메뉴얼', content: '<div id="tabContent2"></div>' }
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
						<div style="padding:0 20px;">
							<table class="tcn_tab01">
								<colgroup>
									<col style="width:150px;">
									<col style="width:150px;">
									<col style="">
								</colgroup>
								<tbody>
									<br/>
									<tr>
										<th>
											<div class="asset_list">
												<p></p>
												<p><span>에너지.열</span></p>
											</div>
										</th>
										<td class="bg_arrow"></td>
										<td class="asset_right">
											<div class="asset_img"><img src="/iris/resource/web/images/newIris/img_tachnical02.png" alt="에너지.열"></div>
											<div class="analyze_field asset_txt">
												<p class="analyze_s_txt">건물 에너지 부하, 건물 에너지 소비량, 건물 에너지 비용 산정</p>
												<p class="analyze_s_txt">건물 에너지 효율 등급, 제로에너지주택 등급</p>
												<p class="analyze_s_txt">재실자의 PMV (열쾌적도) 평가</p>
												<p class="analyze_s_txt">공간의 결로 성능 평가 </p>
											</div>
										</td>
									</tr>
									<tr>
										<th>
											<div class="asset_list">
												<p></p>
												<p><span>빛</span></p>
											</div>
										</th>
										<td class="bg_arrow"></td>
										<td class="asset_right">
											<div class="asset_img"><img src="/iris/resource/web/images/newIris/img_tachnical03.png" alt="빛"></div>
											<div class="analyze_field asset_txt">
												<p class="analyze_s_txt">채광 확보 수준</p>
												<p class="analyze_s_txt">일사로 인한 실내 현휘(눈부심) 평가 </p>
												<p class="analyze_s_txt">유리면 반사에 기인한 주변 건물 빛공해 평가 </p>
											</div>
										</td>
									</tr>
									<tr>
										<th>
											<div class="asset_list">
												<p></p>
												<p><span>공기질</span></p>
											</div>
										</th>
										<td class="bg_arrow"></td>
										<td class="asset_right">
											<div class="asset_img"><img src="/iris/resource/web/images/newIris/img_tachnical04.png" alt="공기질"></div>
											<div class="analyze_field asset_txt">
												<p class="analyze_s_txt">실내 공기질 개선도 평가</p>
												<p class="analyze_s_txt">제습, 가습 능력 평가</p>
											</div>
										</td>
									</tr>
									<!--
									 현재는 사용하지 않지만 나중에 사용할 부분임

									<tr>
										<th>
											<div class="asset_list">
												<p></p>
												<p><span>음</span></p>
											</div>
										</th>
										<td class="bg_arrow"></td>
										<td class="analyze_field asset_right">
											<div class="asset_img"><img src="/iris/resource/web/images/newIris/img_tachnical05.png" alt="음"></div>
											<div class="asset_txt">
												<p class="analyze_s_txt">층간 소음 개선도 평가  </p>
												<p class="analyze_s_txt">외피를 통한 소음 저감 효과 평가</p>
											</div>
										</td>
									</tr> -->
								</tbody>
							</table>
						</div>
					</div>
					<!--  //평가분야 -->


					<!-- 평가 담당자 -->
					<div class="tab-pane fade" id="tab1" >
						<div>
							<table class="table p-admin">
								<colgroup>
									<col style="width:16%;">
									<col style="width:21%;">
									<col style="width:21%;">
									<col style="width:21%;">
									<col style="width:21%;">
								</colgroup>
								<thead>
									<th></th>
									<th>
										<dl>
											<dt>열</dt>
										</dl>
									</th>
									<th>
										<dl>
											<dt>에너지</dt>
										</dl>
									</th>
									<th>
										<dl>
											<dt>빛</dt>
										</dl>
									</th>
									<th>
										<dl>
											<dt>공기질</dt>
										</dl>
									</th>
									<!-- <th>
										<dl>
											<dt>음</dt>
										</dl>
									</th> -->
								</thead>
								<tbody>
									<tr style="height:120px">
										<th class="txt-center">
											<dl>
												<dt>Simulation</dt>
												<dd>주:이진욱책임</dd>
												<dd>부:이유지선임</dd>
											</dl>
										</th>
										<!-- <td style="vertical-align:middle !important;"> -->
										<td>
											<span class="bullet_txt">Window/therm : 송수빈P / 김준혁S</span>
											<span class="bullet_txt">Physibel : 이진욱P / 이유지S</span>
											<span class="bullet_txt">Star CCM+ : 황효근P / 안남혁S</span>
										</td>
										<td>
											<p>
												<span class="bullet_txt">TRNSYS : 송수빈P / 이진욱P</span>
												<span class="bullet_txt">Design Builder : 이진욱P / 이유지S / 안남혁S</span>
												<span class="bullet_txt">Energyplus :박상훈P</span>
												<span class="bullet_txt">ECO2 : 이유지S</span>
											</p>
										</td>
										<td>
											<span class="bullet_txt">EcoTect : 이진욱P</span>
										</td>
										<td>
											<span class="bullet_txt">Star CCM+ : 황효근P / 안남혁S</span>
										</td>
									</tr>
									<tr style="height:120px">
										<th>
											<dl>
												<dt>Mockup</dt>
												<dd>주:황효근책임</dd>
												<dd>부:김준혁선임</dd>
											</dl>
										</th>
										<td>
											<p>
												<span class="bullet_txt">옥산 Test Cell : 황효근P / 이유지S</span>
											</p>
										</td>
										<td>
											<p>
												<span class="bullet_txt">옥산 Test Cell : 황효근P / 이유지S</span>
											</p>
										</td>
										<td>
											<p>
												<span class="bullet_txt">옥산 Test Cell : 박상훈P / 안남혁S</span>
											</p>
										</td>
										<td>
											<p>
												<span class="bullet_txt">옥산 Test Cell : 김준혁S / 안남혁S</span>
											</p>
										</td>

									</tr>
									<tr style="height:120px">
										<th>
											<dl>
												<dt>Certification</dt>
												<dd>주:박상훈책임</dd>
												<dd>부:안남혁선임</dd>
											</dl>
										</th>
										<td>
											<span class="bullet_txt">G-Seed 기반 : 박상훈P / 안남혁S</span>
											<span class="bullet_txt">LEED 기반 : 박상훈P / 안남혁S</span>
											<span class="bullet_txt">기타 : 박상훈P / 안남혁S</span>
										</td>
										<td>
											<span class="bullet_txt">G-Seed 기반 : 박상훈P / 안남혁S</span>
											<span class="bullet_txt">LEED 기반 : 박상훈P / 안남혁S</span>
											<span class="bullet_txt">기타 : 박상훈P / 안남혁S</span>
										</td>
										<td>
											<span class="bullet_txt">G-Seed 기반 : 박상훈P / 안남혁S</span>
											<span class="bullet_txt">LEED 기반 : 박상훈P / 안남혁S</span>
											<span class="bullet_txt">기타 : 박상훈P / 안남혁S</span>
										</td>
										<td>
											<span class="bullet_txt">G-Seed 기반 : 박상훈P / 안남혁S</span>
											<span class="bullet_txt">LEED 기반 : 박상훈P / 안남혁S</span>
											<span class="bullet_txt">기타 : 박상훈P / 안남혁S</span>
										</td>
									</tr>
									<tr>
										<th>
											<dl>
												<dt>Measurement</dt>
												<dd>주:박상훈책임</dd>
												<dd>부:안남혁선임</dd>
											</dl>
										</th>
										<td><span class="bullet_txt">박상훈P / 안남혁S</td>
										<td><span class="bullet_txt">박상훈P / 안남혁S</td>
										<td><span class="bullet_txt">박상훈P / 안남혁S</td>
										<td><span class="bullet_txt">박상훈P / 안남혁S</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<!--  //평가 담당자 -->


					<!-- 평가의뢰 절차 및 메뉴얼 -->
					<div class="tab-pane fade" id="tab2" >
						<div style="padding:20px 20px 0 0;">
							<ul class="processs">
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_consulting.png" alt=""></p>
									<p>1. 사전상담 (방문, 유선)</p>
								</li>
								<li class="next_pr"></li>
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_write.png" alt=""></p>
									<p>2. 평가의뢰서 작성 </p>
								</li>
								<li class="next_pr"></li>
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_img.png" alt=""></p>
									<p>3. 평가진행</p>
								</li>
								<li class="next_pr"></li>
								<li class="dn_pr bg_none"></li>
								<li class="bg_none2"></li>
								<li class="dn_pr bg_none"></li>
								<li class="bg_none2"></li>
								<!-- <li class="dn_pr"></li> -->

								<li class="bg_none2"></li>
								<li class="bg_none2"></li>

								<li class="bg_none2"></li>
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_result.png" alt=""></p>
									<p>4. 평가결과 확인</p>
								</li>

								<!-- <li class="prev_pr"></li> -->
								<li class="next_pr"></li>
								<li>
									<p class="img"><img src="/iris/resource/web/images/newIris/img_process_fb.png" alt=""></p>
									<p>5. 의뢰자 FeedBack</p>
								</li>

							<ul>
						</div>
					</div>
					<!-- //평가의뢰 절차 및 메뉴얼 -->
				</div>
				<!-- //tab-content end -->
				<!-- //tab end -->

			</div><!-- //sub-content -->
		</div><!-- //contents -->

</body>
</html>