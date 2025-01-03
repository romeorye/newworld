<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: spaceChrgDialog.jsp
 * @desc    : 평가방법 선택 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.23  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 2차 프로젝트
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
		setSpaceChrgInfo = function(spaceEvCtgr, spaceEvPrvs, id, name) {
			var spaceChrgInfo = {
					spaceEvCtgr : spaceEvCtgr,
					spaceEvPrvs : spaceEvPrvs,
					id : id,
					name : name
			};

			parent._callback(spaceChrgInfo);
			parent.spaceChrgListDialog.submit(true);
		};

	</script>
    </head>
    <body>


	<!-- pop컨텐츠 -->
	<div class="bd pop_conin">
		<table class="table p-admin">
			<colgroup>
				<col style="width:;">
				<col style="width:21%;">
				<col style="width:21%;">
				<col style="width:21%;">
				<col style="width:21%;">
				<col style="">
			</colgroup>
			<thead>
				<th></th>
				<th>열</th>
				<th>에너지</th>
				<th>빛</th>
				<th>공기질</th>
				<!-- <th class="txt_gray">(음/화재안전)</th> -->
			</thead>
			<tbody>
				<tr>
					<th class="txt-center">
						<dl>
							<dt>Simulation</dt>
							<!-- <dd>주:이진욱책임</dd>
							<dd>부:이유지선임</dd> -->
						</dl>
					</th>
					<td>
						<!-- Simulation: 01,  열 : 02,   -->
						<a href="#" onClick="setSpaceChrgInfo('01','02','rumor',     '이진욱')">이진욱P</a>		 
						<!-- 	
						<span class="bullet_txt">Window/therm :<br>
							<a href="#" onClick="setSpaceChrgInfo('01','02','jollypeas', '송수빈')">송수빈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('01','02','giantsteps','김준혁')">김준혁S</a>
						</span>
						<span class="bullet_txt">Physibel :<br>
							<a href="#" onClick="setSpaceChrgInfo('01','02','rumor',     '이진욱')">이진욱P</a> /
							<a href="#" onClick="setSpaceChrgInfo('01','02','yujilee',   '이유지')">이유지S</a>
						</span>
						<span class="bullet_txt">Star CCM+ :<br>
							<a href="#" onClick="setSpaceChrgInfo('01','04','hyokeun',   '황효근')">황효근P</a> /
							<a href="#" onClick="setSpaceChrgInfo('01','01','nhahn',     '안남혁')">안남혁S</a>
						</span>
						 -->
					</td>
					<td>
						<!-- Simulation: 01,  에너지 : 01,   -->
						<a href="#" onClick="setSpaceChrgInfo('01','01','rumor',     '이진욱')">이진욱P</a>	
						<!-- 
						<p>
						<span class="bullet_txt">TRNSYS : <br>
							<a href="#" onClick="setSpaceChrgInfo('01','01','jollypeas', '송수빈')">송수빈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('01','01','rumor',     '이진욱')">이진욱P</a>
						</span>
						<span class="bullet_txt">Design Builder : <br>
							<a href="#" onClick="setSpaceChrgInfo('01','01','rumor',     '이진욱')">이진욱P</a> /
							<a href="#" onClick="setSpaceChrgInfo('01','01','yujilee',   '이유지')">이유지S</a> /
							<a href="#" onClick="setSpaceChrgInfo('01','01','nhahn',     '안남혁')">안남혁S</a>
						</span>
						<span class="bullet_txt">Energyplus : <br>
							<a href="#" onClick="setSpaceChrgInfo('01','01','shoonpark', '박상훈')">박상훈P</a>
						</span>
						<span class="bullet_txt">ECO2: <br>
							<a href="#" onClick="setSpaceChrgInfo('01','01','yujilee',   '이유지')">이유지S</a>
						</span>
						</p>
						 -->
					</td>
					<td>
						<!-- Simulation: 01,  빛 : 03,   -->
						<a href="#" onClick="setSpaceChrgInfo('01','03','rumor',     '이진욱')">이진욱P</a>
						<!-- 
						<span class="bullet_txt">EcoTect:<br>
							<a href="#" onClick="setSpaceChrgInfo('01','03','rumor',     '이진욱')">이진욱P</a>
						</span>
						 -->
					</td>
					<td class="txt_gray">
						<!-- Simulation: 01,  공기질 : 04,   -->
						<a href="#" onClick="setSpaceChrgInfo('01','04','rumor',     '이진욱')">이진욱P</a>
						<!-- 
						<span class="bullet_txt">Star CCM+:<br>
							<a href="#" onClick="setSpaceChrgInfo('01','04','hyokeun',   '황효근')">황효근P</a> /
							<a href="#" onClick="setSpaceChrgInfo('01','04','nhahn',     '안남혁')">안남혁S</a>
						</span>
						 -->
					</td>
				</tr>
				<tr>
					<th>
						<dl>
							<dt>Mockup</dt>
							<!-- <dd>주:황효근책임</dd>
							<dd>부:김준혁선임</dd> -->
						</dl>
					</th>
					<td>
						<!-- Mockup: 02,  열 : 02,   -->
						<a href="#" onClick="setSpaceChrgInfo('02','02','jollypeas', '송수빈')">송수빈P</a> 
					<!-- 	
						<span class="bullet_txt">옥산 Test Cell :<br>
						 	<a href="#" onClick="setSpaceChrgInfo('02','02','hyokeun',   '황효근')">황효근P</a> /
							<a href="#" onClick="setSpaceChrgInfo('02','02','yujilee',   '이유지')">이유지S</a>
						</span>
					 -->	
					</td>
					<td>
						<!-- Mockup: 02,  에너지 : 01,   -->
						<a href="#" onClick="setSpaceChrgInfo('02','01','jollypeas', '송수빈')">송수빈P</a>
						<!-- 
						<span class="bullet_txt">옥산 Test Cell :<br>
							<a href="#" onClick="setSpaceChrgInfo('02','01','hyokeun',   '황효근')">황효근P</a> /
							<a href="#" onClick="setSpaceChrgInfo('02','01','yujilee',   '이유지')">이유지S</a>
						</span>
						 -->
					</td>
					<td>
						<!-- Mockup: 02,  빛 : 03,   -->
						<a href="#" onClick="setSpaceChrgInfo('02','03','jollypeas', '송수빈')">송수빈P</a>
						<!-- 
						<span class="bullet_txt">옥산 Test Cell :<br>
							<a href="#" onClick="setSpaceChrgInfo('02','03','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('02','03','nhahn',     '안남혁')">안남혁S</a>
						</span>
						 -->
					</td>
					<td>
						<!-- Mockup: 02,  공기질 : 04  -->
						<a href="#" onClick="setSpaceChrgInfo('02','04','jollypeas', '송수빈')">송수빈P</a>
						<!-- 
						<span class="bullet_txt">옥산 Test Cell :<br>
							<a href="#" onClick="setSpaceChrgInfo('02','04','giantsteps','김준혁')">김준혁S</a> /
							<a href="#" onClick="setSpaceChrgInfo('02','04','nhahn',     '안남혁')">안남혁S</a>
						</span>
						 -->
					</td>
				</tr>
				<tr>
					<th>
						<dl>
							<dt>Certification</dt>
							<!-- <dd>주:박상훈책임</dd>
							<dd>부:안남혁선임</dd> -->
						</dl>
					</th>
					<td>
						<!-- Certification: 03,  열 : 02  -->
						<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> 
<!-- 
						<span class="bullet_txt">G-Seed 기반 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
						<span class="bullet_txt">LEED 기반 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
						<span class="bullet_txt">기타 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
 -->
					</td>
					<td>
						<!-- Certification: 03,  에너지 : 01  -->
						<a href="#" onClick="setSpaceChrgInfo('03','01','shoonpark', '박상훈')">박상훈P</a> 
<!-- 							
						<span class="bullet_txt">G-Seed 기반 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
						<span class="bullet_txt">LEED 기반 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
						<span class="bullet_txt">기타 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>
						 -->
					</td>
					<td>
						<!-- Certification: 03,  빛 : 03  -->
						<a href="#" onClick="setSpaceChrgInfo('03','03','shoonpark', '박상훈')">박상훈P</a> 
<!-- 							
						<span class="bullet_txt">G-Seed 기반 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
						<span class="bullet_txt">LEED 기반 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
						<span class="bullet_txt">기타 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>
 -->					
					</td>
					<td>
						<!-- Certification: 03,  공기질 : 04  -->
						<a href="#" onClick="setSpaceChrgInfo('03','04','shoonpark', '박상훈')">박상훈P</a> 
<!-- 							
						<span class="bullet_txt">G-Seed 기반 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
						<span class="bullet_txt">LEED 기반 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>	
						<span class="bullet_txt">기타 :<br>
							<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈P</a> /
							<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁S</a>
						</span>
 -->
 					</td>
				</tr>
				<tr>
					<th class="txt-center">
						<dl>
							<dt>Measurement</dt>
							<!-- <dd>주:박상훈책임</dd>
							<dd>부:안남혁선임</dd> -->
						</dl>
					</th>
					<td>
						<!-- Measurement: 04,  열 : 02  -->
						<a href="#" onClick="setSpaceChrgInfo('04','02','shoonpark', '박상훈')">박상훈P</a> 
<!-- 						<span class="bullet_txt">
						<a href="#" onClick="setSpaceChrgInfo('04','01','shoonpark', '박상훈')">박상훈P</a> /
						<a href="#" onClick="setSpaceChrgInfo('04','01','nhahn',     '안남혁')">안남혁S</a>
 -->					
 					</td>
					<td>
						<!-- Measurement: 04,  에너지 : 01  -->
						<a href="#" onClick="setSpaceChrgInfo('04','01','shoonpark', '박상훈')">박상훈P</a> 
<!-- 
						<span class="bullet_txt">
						<a href="#" onClick="setSpaceChrgInfo('04','02','shoonpark', '박상훈')">박상훈P</a> /
						<a href="#" onClick="setSpaceChrgInfo('04','02','nhahn',     '안남혁')">안남혁S</a>
 -->
					</td>
					<td>
						<!-- Measurement: 04,  빛 : 03  -->
						<a href="#" onClick="setSpaceChrgInfo('04','03','shoonpark', '박상훈')">박상훈P</a> 
<!-- 
						<span class="bullet_txt">
						<a href="#" onClick="setSpaceChrgInfo('04','03','shoonpark', '박상훈')">박상훈P</a> /
						<a href="#" onClick="setSpaceChrgInfo('04','03','nhahn',     '안남혁')">안남혁S</a>
 -->
					</td>
					<td>
						<!-- Measurement: 04,  공기질 : 04  -->
						<a href="#" onClick="setSpaceChrgInfo('04','04','shoonpark', '박상훈')">박상훈P</a> 
<!-- 						
						<span class="bullet_txt">
						<a href="#" onClick="setSpaceChrgInfo('04','04','shoonpark', '박상훈')">박상훈P</a> /
						<a href="#" onClick="setSpaceChrgInfo('04','04','nhahn',     '안남혁')">안남혁S</a>
 -->
					</td>
				</tr> 	
			</tbody>
		</table>
	</div>
	<!-- //pop컨텐츠 -->



	</body>
</html>