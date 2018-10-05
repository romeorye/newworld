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
				<h2>기기분석 안내</h2>
		    </div>

			<div class="sub-content">

				<!-- tab-content start -->
				<div class="tab-content">

					<!-- 분석안내 -->
					<div class="tab-pane fade active in" id="tab0">
						<div class="analyze_field">
					        <div class="analyze_box"><div class="analyze_img1"></div></div>
		
					        <div class="analyze_cont">
					            <div class="analyze_b_txt">
					                형상분석
					            </div>
					            <div class="analyze_s_txt">Micro 및 Nano Level 에서의 형상, 성분, 상태, 물리적  특성 분석</div>
					            <div class="analyze_s_txt">Atomic Structure, Crystallinity 분석</div>
					        </div>
					     </div>
		
					     <div class="clear"></div>
		
					    <div class="analyze_line margin-10"></div>
		
					    <div class="analyze_field">
					        <div class="analyze_box"><div class="analyze_img2"></div></div>
		
					        <div class="analyze_cont">
					            <div class="analyze_b_txt">
					                유기분석
					            </div>
					            <div class="analyze_s_txt">소재의 판별 및 조성 분석</div>
					            <div class="analyze_s_txt">유기 첨가제의 정성 및 정량 분석</div>
					        </div>
					     </div>
		
					     <div class="clear"></div>
		
					    <div class="analyze_line margin-10"></div>
		
					    <div class="analyze_field">
					        <div class="analyze_box"><div class="analyze_img3"></div></div>
		
					        <div class="analyze_cont">
					            <div class="analyze_b_txt">
					                유해물질분석
					            </div>
					            <div class="analyze_s_txt">수입/수출 규제 및 환경 관련 유해물질의 극미량 분석 </div>
					            <div class="analyze_s_txt">전성분 분석을 통한 비의도적 유해물질분석</div>
					        </div>
					     </div>
		
					     <div class="clear"></div>
		
					    <div class="analyze_line margin-10"></div>
					</div>
					<!--  //분석안내 -->


					<!-- 분석 담당자 -->
					<div class="tab-pane fade" id="tab1" >
						<div class="analyze_person" style="padding:20px 20px 0 0;">
				            <table class="table p-admin">
				                <caption>분류</caption>
				                <colgroup>
				                    <col width="20%" />
				                    <col width="20%" />
				                    <col width="20%" />
				                    <col width="20%" />
				                    <col />
				                </colgroup>
				                <div class="person_guide mb" >* 기타 사업조직 분석의뢰 시, 분석PJT PL과 상담해주시기 바랍니다.</div>
				                <thead>
				                    <tr>
				                        <th>사업부</th>
		<!-- 		                        <th>팀(PJT)</th> -->
				                        <th>형상분석</th>
				                        <th>유기분석</th>
				                        <th>유해물질분석</th>
				                    </tr>
				                </thead>
				                <tbody>
				                    <tr>
				                        <th >중앙연구소</th>
				                        <td>
				                        	<a href="javascript:getPersonInfo('00207677','soonbo')" class="person_link">이순보</a>
				                        </td>
				                        <td>
				                        	<a href="javascript:getPersonInfo('00206813','suyune')" class="person_link">김수연</a>
				                        </td>
				                        <td rowspan="5" class="bottomL">
				                        	<a href="javascript:getPersonInfo('00207068','kojaeyoon')" class="person_link">고재윤</a>
				                        	<br><br>
				                        	<a href="javascript:getPersonInfo('00207779','lejaaa')" class="person_link">이은주</a>
				                        	<br><br>
				                        	<a href="javascript:getPersonInfo('00208219','sumin')" class="person_link">권수민</a>
				                        </td>
				                    </tr>
				                    <tr>
				                        <th>자동차소재부품</th>
				                        <td>
				                        	<a href="javascript:getPersonInfo('00206766','jihee')" class="person_link">손지희</a>
				                        </td>
				                        <td class="rightL">
				                        	<a href="javascript:getPersonInfo('00206813','suyune')" class="person_link">김수연</a>
				                        </td>
				                    </tr>
				                    <tr>
				                        <th>창호</th>
				                        <td>
				                        	<a href="javascript:getPersonInfo('00208220',' jihachoi')" class="person_link">최지하</a>
				                        </td>
				                        <td class="rightL">
				                        	<a href="javascript:getPersonInfo('00207783','kimsb')" class="person_link">김샛별</a>
				                        </td>
				                    </tr>
		
				                    <tr>
				                        <th>장식재</th>
				                        <td>
				                        	<a href="javascript:getPersonInfo('00206766','jihee')" class="person_link">손지희</a>
				                        </td>
				                        <td class="rightL">
				                        	<a href="javascript:getPersonInfo('00207783','kimsb')" class="person_link">김샛별</a>
				                        </td>
				                    </tr>
				                    <tr>
				                        <th>표면소재</th>
				                        <td>
				                        	<a href="javascript:getPersonInfo('00207776','kwonjihye')" class="person_link">권지혜</a> ,
				                        	<a href="javascript:getPersonInfo('00208220',' jihachoi')" class="person_link">최지하</a>
				                        </td>
				                        <td class="rightL">
				                        	<a href="javascript:getPersonInfo('00207466','chlee')" class="person_link">이종한</a>
				                        </td>
				                    </tr>
		
				                 </tbody>
				            </table>
				        </div>
					</div>
					<!--  //분석 담당자 -->


					<!-- 평가의뢰 절차 및 메뉴얼 -->
					<div class="tab-pane fade" id="tab2" >						
						<div class="analy_proce" style="padding:20px 20px 0 0;">
				            <div class="analy_proce_box">
				                <div class="analy_proce_img img01"></div>
				                <div class="analy_proce_txt">분석의뢰절차</div>
				            </div>
				            <div class="analy_proce_arrow arrow01"></div>
				            <div class="analy_proce_box">
				                <div class="analy_proce_img img02"></div>
				                <div class="analy_proce_txt">1. 분석상담(방문 및 유선)</div>
				            </div>
				            <div class="analy_proce_arrow arrow01"></div>
				            <div class="analy_proce_box">
				                <div class="analy_proce_img img03"></div>
				                <div class="analy_proce_txt">2. 분석의뢰서 작성</div>
				            </div>
		
				            <div class="clear"></div>
				            <div class="analy_proce_arrow arrow03"></div>
				        </div>
				        <div class="clear"></div>
				        <div class="analy_proce_lay">
				            <div class="analy_proce_box">
				                <div class="analy_proce_img img06"></div>
				                <div class="analy_proce_txt">5. 분석결과 확인</div>
				            </div>
				            <div class="analy_proce_arrow arrow02"></div>
				            <div class="analy_proce_box">
				                <div class="analy_proce_img img05"></div>
				                <div class="analy_proce_txt">4. 분석진행</div>
				            </div>
				            <div class="analy_proce_arrow arrow02"></div>
				            <div class="analy_proce_box">
				                <div class="analy_proce_img img04"></div>
				                <div class="analy_proce_txt">3. 시료접수</div>
				            </div>
				        </div>
						<div class="clear"></div>
				         <div class="analy_adress">
				            <div class="analy_adress_box">
				                <div class="adress_txt_box"><div class="adress_txt">주소</div></div>
				                <div class="adress_txt_s">서울특별시 강서구 마곡중앙10로 30 (마곡동) LG사이언스파크 LG하우시스.중앙연구소.분석PJT</div>
				                <div class="adress_txt_ss">* 수령인에 분석담당자의 이름과 연락처를 기재하여 발송해 주시기 바랍니다.</div>
				            </div>
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