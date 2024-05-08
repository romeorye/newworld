<%--
/**------------------------------------------------------------------------------
 * NAME : main.jsp
 * DESC : 
 * VER  : v1.0
 * PROJ : LG CNS WINS UPGRADE PROJECT
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.05.27   김수예		 WINS UPGRADE PROJECT			  
 *------------------------------------------------------------------------------*/
--%>  
<%@ page language ="java"  pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>								
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="<%=cssPath%>/common.css" type="text/css" />
<script type="text/javascript">

</script>
<head>
<title>WINS MAIN</title>
</head>
<form name="aform" id="aform" method="post">
	<div class="contents">
		<div class="userGroupArea">
			<div class="groupTop">
				<div class="groupColumn">
					<dl class="groupInner">
						<dt>
							<h3>시공자 정보</h3>
							<a href="#none">정보관리</a>
						</dt>
						<dd>
							<strong>하우징테크(주)</strong>
							<span>홍길동</span>
							<p>서울시 중구 중림동 419번지드림오피스 타운</p>
						</dd>
					</dl>
					<div class="columnRowRight">
						<ul class="groupInfo">
							<li>
								<h4>
									시공 인력 <br />
									현황
								</h4>
								<a href="#none">활동관리</a>
							</li>
							<li>
								<span>금일배치인원/팀</span>
								<strong>0/0</strong>
							</li>
							<li>
								<span>총 등록인원/팀</span>
								<strong>0/0</strong>
							</li>
							<li>
								<span>가동율/팀</span>
								<strong>25%</strong>
							</li>
						</ul>
						
					</div>
					<div class="columnRowRight">
						<ul class="groupInfo">
							<li>
								<h4>
									금일 시공 <br />
									현장 현황
								</h4>
							</li>
							<li>
								<span>미접수시공중</span>
								<strong>5</strong>
							</li>
							<li>
								<span>시공중</span>
								<strong>8</strong>
							</li>
							<li>
								<span>시공완료</span>
								<strong>0</strong>
							</li>
							<li>
								<span>이슈현장</span>
								<strong>12</strong>
							</li>
						</ul>
					</div>
				</div>
				<!-- // groupColumn -->


				<div class="groupColumn">
					<div class="columnRowLeft">
						<ul class="groupInfo">
							<li>
								<h4>
									시공인력 <br />
									현황
								</h4>
							</li>
							<li>
								<span>신규시공주문</span>
								<strong>0</strong>
							</li>
							<li>
								<span>시공주문접수</span>
								<strong>2</strong>
							</li>
							<li>
								<span>시공주문변경/취소</span>
								<strong>2/3</strong>
							</li>
							<li>
								<span>완료승인요청</span>
								<strong>0</strong>
							</li>
							<li>
								<span>완료승인</span>
								<strong>5</strong>
							</li>
							<li class="pointBg">
								<span>완료승인반려</span>
								<strong>25</strong>
							</li>
						</ul>
					</div>
					<div class="columnRowRight">
						<ul class="groupInfo">
							<li>
								<h4>
									점검현황 <br />
									(QCS)
								</h4>
							</li>
							<li>
								<span>금일배정현장(건/점)</span>
								<strong>5/0</strong>
							</li>
							<li>
								<span>금월배정현장(건/점)</span>
								<strong>5/20</strong>
							</li>
						</ul>
					</div>
				</div>
				<!-- // groupColumn -->


				<div class="groupColumn">
					<div class="columnRowLeft">
						<ul class="groupInfo type02">
							<li>
								<h4>
									정산현황 <br />
									<span class="pointB">전월26일 ~ 당월25일</span>
								</h4>
							</li>
							<li>
								<span>정산예정 금액(건/원)</span>
								<strong>
									<span>5/</span>
									258,600,000
								</strong>
							</li>
							<li>
								<span>정산확정 금액(건/원)</span>
								<strong>
									<span>4/</span>
									258,600
								</strong>
							</li>
							<li>
								<span>전월 미정산 잔액(건/원)</span>
								<strong>
									<span>12/</span>
									258,600
								</strong>
							</li>
							<li>
								<span>유보금 잔액(건/원)</span>
								<strong>
									<span>0/</span>
									258,600
								</strong>
							</li>
						</ul>
						<p class="desc">
							<strong>미정산금액</strong> : '13년~전월 마감시점까지의 현장
						</p>
					</div>
					<div class="columnRowRight">
						<ul class="groupInfo type02">
							<li>
								<h4>
									시공사 평가 <br />
									(금월)
								</h4>
							</li>
							<li>
								<span>금일배정현장(건/점)</span>
								<strong>5/0</strong>
							</li>
							<li>
								<span>금월배정현장(건/점)</span>
								<strong>0/0</strong>
							</li>
						</ul>
					</div>
				</div>
				<!-- // groupColumn -->
			</div>
			<!-- // groupTop -->


			<div class="groupBot">
				<div class="notice-area">
					<div class="tit-area">
						<h3>Notice</h3>
						<a href="#none" class="notice-more"></a>
					</div>
					<div class="notice-top">
						<h4><a href="#none">지인몰 유통 품질관리에 대한 약정건 공지</a></h4>
						<span class="date">2016-05-30</span>
						<p class="desc ellipsis">
							<a href="#none">실측상담의 경우 평일상담을 원칙으로 하고 있으나, 담당 컨
							통해 주말에도 상담을 받으실 수 있으며 토요일 오전에 한하여여여여여여여여여여여여여여여여여여여여</a>
						</p>
					</div>
					<ul class="notice-list">
						<li>
							<a href="#none">지인몰 유통 품질관리에 대한 약정건 공지 자세한 지인몰 유통 품질관리에 대한 약정건 공지 자세한 </a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">포장본수 공유</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">개보수 몰딩 마감재 풀지 공지의견</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">부고_창문지지 이연행 사상님 모친상</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">파워슬림 형상 일부변경에 따른 기존자재 혼용금지</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">개보수 몰딩 마감재 풀지 공지의견</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">개보수 몰딩 마감재 풀지 공지의견</a>
							<span class="date">2016-05-30</span>
						</li>
					</ul>
				</div>
				<div class="groupRight">
					<div class="customer">
						<h3>고객센타</h3>
						<strong>02-2039-7185</strong>
						<p>
							평일 : 09:00 ~ 18:00 <br />
							토,일요일 및 공휴일 휴무
						</p>
					</div>
					<ul class="groupLink">
						<li>
							<a href="#none">
								<img src="../resource/images/common/group_link01.png" alt="" />
							</a>
						</li>
						<li>
							<a href="#none">
								<img src="../resource/images/common/group_link02.png" alt="" />
							</a>
						</li>
						<li>
							<a href="#none">
								<img src="../resource/images/common/group_link03.png" alt="" />
							</a>
						</li>
					</ul>
				</div>
			</div>
			<!-- // groupBot -->


		</div>	
	</div><!-- //contents -->
</form>	
</html>