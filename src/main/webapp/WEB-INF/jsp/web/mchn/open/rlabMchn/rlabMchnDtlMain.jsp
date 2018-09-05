<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: rlabMachineList.jsp
 * @desc    : Instrument > 신뢰성시험 장비 > 보유 장비 > 보유장비 상세화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.24    IRIS05		최초생성
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
var mchnPrctInfoDialog;
var mchnPrctId;

var frtTab;
var rtnUrl;
var mchnInfoId;

	Rui.onReady(function() {
		mchnInfoId = '${inputData.mchnInfoId}';
		var tabId = '${inputData.tabId}';
		
		var opnYn = '${result.opnYn}';
		var attId = '${result.attcFilId}';
		var seq = '${result.seq}';
		var param = "?attcFilId="+attId+"&seq="+seq;
	
		Rui.getDom('imgView').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;

		if(Rui.isEmpty(tabId)){
			tabId = "SMRY";
		}
		
		//동작원리, 예약현황 TAB
		var tabView = new Rui.ui.tab.LTabView({
             tabs: [
            	     {label: '장비개요',	content: '<div id="tabContent0"></div>' }
            	     ,{label: '예약현황',	content: '<div id="tabContent1"></div>' }
             		]
         });

		var tabUrl = "";
		
		goPage = function(target, id) {
        	$('#tabId').val(id);
        	$('#mchnInfoId').val(mchnInfoId);
        	$('#rtnUrl').val(rtnUrl);

        	if( id == "PRCT"){
	        	tabUrl = "<c:url value='/mchn/open/rlabMchn/retrieveMchnPrctTab.do'/>";
        	}else{
	        	tabUrl = "<c:url value='/mchn/open/rlabMchn/retrieveMchnInfoTab.do'/>";
        	}

        	nwinsActSubmit(document.aform, tabUrl, target);
        }

		tabView.render('tabView');
		
		if( opnYn == "N" ){
			tabView.removeAt(tabView.getTabCount() - 1);
		}
		
		
		tabView.on('activeTabChange', function(e){
        	 //iframe 숨기기
        	 for(var i = 0; i < 2; i++) {
                if(i == e.activeIndex) {
                    Rui.get('tabContentIfrm' + i).show();
                }
                else {
                    Rui.get('tabContentIfrm' + i).hide();
                }
            }
        	
        	switch(e.activeIndex){
        	//전체
        	case 0:
        		if(e.isFirst){
        			rtnUrl = "web/mchn/open/rlabMchn/rlabMchnSmry";
                	goPage('tabContentIfrm0', 'SMRY');
                }
        		break;
        	case 1:
                if(e.isFirst){
        			rtnUrl = "web/mchn/open/rlabMchn/rlabMchnPrctTab";
                	goPage('tabContentIfrm1', 'PRCT');
                }
        		break;
        	}
        });

		//원하는 탭으로 호출
		if(tabId == 'PRCT'){
			tabView.selectTab(1);
		}else{
			tabView.selectTab(0);
		}
		
		
		/* [ 보유기기신청 예약 Dialog] */
		mchnPrctInfoDialog = new Rui.ui.LFrameDialog({
	        id: 'mchnPrctInfoDialog',
	        title: '보유장비신청 예약',
	        width:  1000,
	        height: 600,
	        modal: true,
	        visible: false
	    });

		mchnPrctInfoDialog.render(document.body);
		
		
		/* [버튼] : 보유장비 목록으로 이동 */
    	var butList = new Rui.ui.LButton('butList');
    	butList.on('click', function(){
    		document.aform.action='<c:url value="/mchn/open/rlabMchn/retrieveMachineList.do"/>';
    		aform.target = '_self';
			document.aform.submit();
    	});
		

	});	//end ready

	
	function  fncMchnPrctPop(id, y, m, d, i){
		/* 
		var dt = new Date();
		var toDay =  dt.getDate();
		
		if(toDay < Number(d) ){
			
		}else{
			alert("현재일 이전날짜는 예약이 불가능합니다.");
		}
		 */
		if(Rui.isEmpty(id)){
			mchnPrctId = "";
		}
		var mchnUsePsblYn = '${result.mchnUsePsblYn}'
		var mchnClCd = '${result.mchnClCd}'
		
		if(mchnClCd == "" ||mchnClCd == null){
			mchnClCd = i;
		}

		if(mchnPrctId=="" && mchnUsePsblYn == "N" ){
			alert("해당장비는 점검중입니다. 관리자에게 문의하세요.");
			return;
		}

		var param = "?mchnPrctId="+id
				    +"&year="+y 
				    +"&mm="+m 
				    +"&day="+d 
				    +"&mchnInfoId="+mchnInfoId 
				    +"&mchnClCd="+mchnClCd
					;

		mchnPrctInfoDialog.setUrl('<c:url value="/mchn/open/rlabMchn/retrieveMchnPrctInfoPop.do"/>'+param);
		mchnPrctInfoDialog.show(true);	
	}
	
	function fncMchnDtl( mchnPId , mchnId, tabId){
		$('#tabId').val(tabId);
    	$('#mchnInfoId').val(mchnId);
    	$('#mchnPrctId').val(mchnPId);
    	$('#rtnUrl').val("web/mchn/open/rlabMchn/rlabMchnPrctTab");
    	tabUrl = "<c:url value='/mchn/open/rlabMchn/retrieveMchnPrctTab.do'/>";

    	nwinsActSubmit(document.aform, tabUrl, "tabContentIfrm1");
	}
	
	//닫기
	function fncPopCls(){
		mchnPrctInfoDialog.cancel(true);
	}
	
</script>
</head>


<body>
<form  id="aform" name="aform" method="post">
<input type="hidden" id="mchnInfoId" name="mchnInfoId">
<input type="hidden" id="tabId" name="tabId">
<input type="hidden" id="mchnClCd" name="mchnClCd" value="<c:out value='${inputData.mchnClCd}'/>">
<input type="hidden" id="mchnClCd2" name="mchnClCd2" value="<c:out value='${result.mchnClCd}'/>">
<input type="hidden" id="mchnSmry" name="mchnSmry" value="<c:out value='${result.mchnSmry}'/>">
<input type="hidden" id="mchnUsePsblYn" name="mchnUsePsblYn" value="<c:out value='${result.mchnUsePsblYn}'/>">
<input type="hidden" id="rtnUrl" name="rtnUrl">
 <!-- contents -->  
<div class="contents">
	<div class="titleArea">
		<h2>장비예약</h2>
    </div>
	<!-- sub-content -->
	<div class="sub-content">
			<div class="LblockButton top">
				<button type="button" id="butList">목록</button>
			</div>
		<!-- schedule_reserv -->
		<div class="schedule_reserv">
            <div>
                <div class="reserv_box">
                	<!-- <img src="../images/newIris/sub_img.png"> -->
                	<img id="imgView"/>
                </div>
                <div class="reserv_table">
                    <!--table-->
                    <table class="tbl">
                        <caption>분류</caption>
                        <colgroup>
                            <col width="20%" />
                            <col width="30" />
                            <col width="20%" />
                            <col width="30%" />
                        </colgroup>
                        <thead>
                        </thead>
                         <tbody>
                            <tr>
                                <th>장비명</th>
                                <td colspan="3"><c:out value='${result.mchnNm}'/></td>
                            </tr>
                            <tr>
                                <th>상태</th>
                                <td><c:out value='${result.mchnUsePsblNm}'/></td>
                                <th>구분</th>
                                <td><c:out value='${result.opnNm}'/> </td>
                            </tr>
                            <tr>
                                <th>사양</th>
                                <td><c:out value='${result.mdlNm}'/></td>
                                <th>제조사</th>
                                <td><c:out value='${result.mkrNm}'/> </td>
                            </tr>
                            <tr>
                                <th>담당자</th>
                                <td><c:out value='${result.crgrNm}'/></td>
                                <th>위치</th>
                                <td><c:out value='${result.mchnLoc}'/> </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                	<div class="prg">
                                		<span id="mchnExpl"><c:out value='${result.mchnExpl}' escapeXml="false"/> </span> 
                                	</div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!--// table-->
                </div>
             </div>
            <div class="clear"></div>
            <br>
           <div id="tabView"></div>
            <!-- 메인1 tab start --><!-- **** rui 컴포넌트 이용시 불필요한 내용임 **** -->
 			<iframe name="tabContentIfrm0" id="tabContentIfrm0" scrolling="no" width="100%" height="1200px" frameborder="0" ></iframe> 
 			<iframe name="tabContentIfrm1" id="tabContentIfrm1" scrolling="yes" width="100%" height="700px" frameborder="0" ></iframe> 
            <!-- 메인1  tab end -->                        
        </div>
        <!-- // schedule_reserv -->
        <div class="clear"></div>
                 
        </div>	
		<!-- // sch_reserv_present -->
		
	</div>
	<!-- //sub-content -->

</div>
<!-- //contents -->
 
 </form>	   
</body>
</html>