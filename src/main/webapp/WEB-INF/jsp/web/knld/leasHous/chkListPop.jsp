<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
  * $Id		: chkListPop.jsp
 * @desc    : 임차주택/ 체크리스트 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.11.27   IRIS005	최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>


<script type="text/javascript">

		Rui.onReady(function() {
		
			var chkCmpl = new Rui.ui.form.LCheckBox({
                applyTo: 'chkCmpl',
                label: '확인',
                value: 'Y'
            });
			
			chkCmpl.on('changed', function(e){
				setCookie("MyCookie", "adexe" , 1);
                parent.chkListDialog.submit(true);
            });
		});


		function setCookie( name, value, expiredays ){
			var todayDate = new Date();
			
			todayDate.setDate( todayDate.getDate() + expiredays );
			document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
			self.close();
		}

</script>
</head>
<body>
<div class="LblockMainBody">
	<div class="sub-content">
   			<div style="text-align:left;font-weight:bold;font-size:2.0em;font-family:LG스마트체2.0;" >- 계약 전 체크사항</div> 
   			<br/>
   			<div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			1. 본 임차주택의 계약 시 임차인은 ㈜LX하우시스  법인 명으로 한다.<br/>
   			</div>
   			<br/>
   			<div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			2. 임자보증금의 전세권설정에 임대인의 사전 동의를 득한다.<br/>
   			</div>
   			<br/>
   			<div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			3. 임대인의  신분확인을 위한 신분증,계좌사본 제출에 동의한다.</br>
   			</div>
   			<br/>
   			<div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			4. 해당 임차건물에 대한 임대인 명의 채권채무관계가 없어야하며 채무관계가 있을 경우에는 잔금일자에</br>  
               &nbsp;&nbsp;&nbsp;상환 말소하는  조건으로 진행한다(계약서 작성시 특약사항에 필수)</br>
   			</div>
   			<br/>
   			<div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			5. 등기부열람(을구 포함)을 확인하여 실명,채무관계를 반드시 중개사와 확인한다<br/>
   			</div>
   			<br/>
   			<div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			6. 임대차계약서에 대한 법무검토 완료 전에는  계약금 일부 송금을 금지하며 위반 시 모든 책임을 진다</br>
   			</br>
   			</div>
   			</br>
   			<div style="text-align:left;font-weight:bold;font-size:2.0em;font-family:LG스마트체2.0;" >- 계약 시</div>
   			<br/>
   			 <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			 1. 특약사항 기본문구 외 당사가 요구하는 사항을 필수적으로 작성한다</br>
   			 </div>
   			 </br>
   			 <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			 2. 특약 필수기제사항으로는 00억 전세보증금인 경우 잔금일자,㈜LX하우시스에서,0억을 임대인 명의계좌로</br>&nbsp;&nbsp;
   			       송금하며 (임대인계좌 00은행/123-3456-000 홍길동) 나머지 00천 만원은  세입자 000씨가 임대인 명의계좌로</br>&nbsp;&nbsp;&nbsp;송금한다 </br>
   			   </br>   
                    &nbsp;&nbsp;&nbsp;예시) 본 계약 만기 시에는 임대인 명의로 ㈜LX하우시스 법인계좌(우리은행 123-456-000)로  00억을</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;송금하며 나머지 잔금 0천만원에 대하여 임대인은 세입자 홍길동 계좌명의로 송금한다</br>
                    &nbsp;&nbsp;&nbsp;예시) 계약금에 대한 법적 lisk발생시 세입자 본인과 임대인과의 체결로 규정한다</br>
   			 </div>
   			 </br>
			<div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
             3. 세입자는 계약금 일부를 송금 전 반드시 전세물건 현장을 중개사와 시설물 점검을 확인 후 진행한다</br>
   			</div>
   			 </br>
   			 <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
             4. 법무팀 계약서 검토 시 임대인,중개사의 인장날인 또는 자필서명 된 것으로 제출한다.</br>
   			 </div>
   			 </br>
   			 </br>
   			 <div style="text-align:left;font-weight:bold;font-size:2.0em;font-family:LG스마트체2.0;" >- 연장,만기 시 체크사항</div>
   			<br/>
   			 <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
   			 1. 연장 또는 만기 시 1~6개월 전에 임차인은 임대인에게  사전 통보을 한다</br>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 주택임대차보호법 제6조 2항.</br>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 기존 계약 조건을 변경,종료 시 기간 안에 임차인에게 임대인은 통보를 해야함을 인지하셔야합니다 </br>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 임차인(세입자)이 1개월 전까지 통보를 안 할 경우 자동 연장(묵시적 갱신)이 됩니다</br>
              </div>
             </br>
             <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
             2. 임대인의 묵신경으로  계약기간을 2년 초과시 묵시적 갱신으로 동일한 조건으로 자동연장 된다.</br>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 주택임대차보호법 제6조(계약의 갱신))</br>
              </div>
             </br>
             <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
             3. 연장계약서를 작성하여 법무팀 계약서 검토요청 및 체결품의 후 신장날인까지 진행한다.</br>
             </div>
             </br>
             <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
             4. 본인의 사정으로 3개월 전 이사 시  중개수수료,법무사수수료는 본인(세입자)이 부담한다</br>
             </div>
             </br>
             <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >
             5. 만기 시 이사하는 날에 임대인에게 시설물 이상 유무를 확인 및 필요한 사항을 해당 중개사 임회하에 인계한다.</br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 관리비용,공과금은 깔금하게 정리한다</br>
             </div>   
             </br> 
             <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >   
             6. 만기 후 임차보증금 반환 확인과 동시에 전세권설정 말소을 진행한다.</br> 
             </div>
             </br> 
             <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >   
             7. 기존 계약 만기 시 회사지원  잔여기간이 있는 경우 임차주택관리 규정의 의거 임차주택 계약 신청을 한다.</br>
             </div>
             </br> 
             <div style="text-align:left;font-size:1.3em;font-family:LG스마트체2.0;" >   
             8. 만기 퇴실 후에 향후 계약 진행은 1차 계약 시와 동일한 Process로 진행한다.</br>
             </div>
             </br>    
             </br>    
	</div>   		
			<div id="chk" align="right" >
				<input type="checkbox" id="chkCmpl"/>
			</div>
</div>
</body>
</html>
