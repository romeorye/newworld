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
		
		
        function getPersonInfo(sabunnew, loginSabun){
    		var popupUrl = "http://gportal.lxhausys.com/portal/main/listUserMain.do?hideOrgYN=true&rightFrameUrl=/support/profile/getProfile.do?targetUserId="+loginSabun ;	
    			var popupOption = "width=900, height=700, top=300, left=400";
    			window.open(popupUrl,"",popupOption);
    	}

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
				<h2>신뢰성시험 안내</h2>
		    </div>

			<div class="sub-content">


			    <!-- tab start -->
			    <div id="tabView"></div><br/>
				<!-- tab-content start -->

				<div class="tab-content">

					<!-- 붆석분야 -->
					<div class="tab-pane fade active in" id="tab0">
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
									<div class="analyze_s_txt">촉진 내후성 시험 (ISO 4892-2)</div>
									<div class="analyze_s_txt">촉진 내광성 시험 (ISO 4892-3)</div>
									<div class="analyze_s_txt">가속 내후성 시험 (QUV/Spray)</div>
									<div class="analyze_s_txt">가속 내후성 시험 (WOM)</div>
									<div class="analyze_s_txt">초가속 내후성 시험(WOM)</div>
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


					<!-- 담당자 -->
					<div class="tab-pane fade" id="tab1" >
						<div style="display:inline-block; padding:10px 0 0 10px;">
							<div align="right">※ 신뢰성시험 의뢰 시, 시험 담당자 or 제품신뢰성연구PJT PL에게 문의 바랍니다.</div>
							<table class="table anlch_ta">
								<colgroup>
									<col style="width:25%;">
									<col style="width:25%;">
									<col style="width:50%;">
								</colgroup>
								<tbody>
									<th colspan="2">사업부/사업담당</th>
									<th>시험 담당자</th>
									<tr>
										<th colspan="2" align="center">총괄</th>
										<td style="text-align:center;vertical-align:middle !important;">
				                        	<a href="javascript:getPersonInfo('00206637','sheleemin')" class="person_link">이민</a>
				                        </td>
									</tr>
									<tr>
										<th rowspan="2" align="center">창호</th>
										<th align="center">시스템창, 중문, 통합시공</th>
										<td style="text-align:center;vertical-align:middle !important;">
				                        	<a href="javascript:getPersonInfo('00203224','hobaly')" class="person_link">임호연</a>
				                        </td>
									</tr>
									<tr>
										<th align="center">PL창</th>
										<td style="text-align:center;vertical-align:middle !important;">
				                        	<a href="javascript:getPersonInfo('00207774','jhbyun')" class="person_link">변재현</a>
				                        </td>
									</tr>
									<tr>
										<th colspan="2" align="center">인테리어</th>
										<td style="text-align:center;vertical-align:middle !important;">
				                        	<a href="javascript:getPersonInfo('00208483','induohgee')" class="person_link">이동희</a>
				                        </td>
									</tr>
									<tr>
										<th colspan="2" align="center">표면소재</th>
										<td style="text-align:center;vertical-align:middle !important;">
				                        	<a href="javascript:getPersonInfo('00206638','jndkim')" class="person_link">김지니다</a>
				                        </td>
									</tr>
									<tr>
										<th colspan="2" align="center">산업용필름</th>
										<td style="text-align:center;vertical-align:middle !important;">
				                        	<a href="javascript:getPersonInfo('00207790','tekang')" class="person_link">강태의</a>
				                        </td>
									</tr>
									<tr>
										<th colspan="2" align="center">바닥재</th>
										<td rowspan="2" style="text-align:center;vertical-align:middle !important;">
				                        	<a href="javascript:getPersonInfo('00209433','sungfepark')" class="person_link">박성철</a>
				                        </td>
									</tr>
									<tr>
										<th colspan="2" align="center">벽지</th>
									</tr>
									<tr>
										<th colspan="2" align="center">단열재</th>
										<td style="text-align:center;vertical-align:middle !important;">
											<a href="javascript:getPersonInfo('00206638','jndkim')" class="person_link">김지니다</a>,
											<a href="javascript:getPersonInfo('00209433','sungfepark')" class="person_link">박성철</a>
										</td> 
									</tr>
								</tbody>
							</table>

						</div>
					</div>
					<!--  // 담당자 -->


					<!-- 시험의뢰 절차 -->
					<div class="tab-pane fade" id="tab2" >
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
					<!-- //시험의뢰 절차-->
				</div>
				<!-- //tab-content end -->
				<!-- //tab end -->

			</div><!-- //sub-content -->
		</div><!-- //contents -->

</body>
</html>