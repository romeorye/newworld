<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>			
<%@ page import="java.text.*
			   , java.util.*
			   , devonframe.util.NullUtil
			   , devonframe.util.DateUtil
			   , iris.web.common.util.CommonUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: lgUserPopup.jsp
 * @desc    : LG사용자 팝업 
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.07.25  김찬웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LPager.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LPager.css" />

<!-- script type="text/javascript" src="<%=contextPath%>/rui/sample/general/rui_sample.js"></script  -->

<script type="text/javascript">
    var dataSet;
    var searchBtn;
    
    Rui.onReady(function() {
        <%--// ******************
         * 변수 및 객체 선언
        ****************** --%>

        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                { id: 'saUser' },
                { id: 'saName' },
                { id: 'saJobxName' },
                { id: 'saDeptName' },
                { id: 'saTel' },
                { id: 'saHand' }
            ]
        });


        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                { field: 'saUser',     label: 'ID', 	sortable: false, align:'center', autoWidth: true },
                { field: 'saName',     label: '사원명',  	sortable: false, align:'center', autoWidth: true },
                { field: 'saJobxName', label: '직위',  	sortable: false, align:'center', autoWidth: true },
                { field: 'saDeptName',  label: '부서명',   sortable: false, align:'center', autoWidth: true },
                { field: 'saTel',      label: '사무실전화',	sortable: false, align:'center', autoWidth: true },
                { field: 'saHand',     label: '휴대전화', 	sortable: false, align:'center', autoWidth: true }
            ]
        });

        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
			width: 600,
			height: 300,
            // LGridStatusBar는 샘플용으로 사용
            footerBar: new Rui.ui.grid.LGridStatusBar(),
            autoToEdit: false,
            autoWidth: true
        });
        
        <%--// 
        // 페이징처리 
        var pager = new Rui.ui.LPager({
            //gridPanel: grid,
            totalCount: 300,
            pageSize:10
        });
        
        pager.on('beforeChange', function(e){
            //Rui.alert('current pageNumber : ' + this.pageNumber + ', new pageNumber : ' + e.pageNumber);
        });
        
        pager.on('changed', function(e){
            //Rui.alert('Page No. ' + e.pageNumber);
            if( e.pageNumber != null) {
             dataSet.load({
                 url: '<c:url value="/esti/popup/NwinsEstiPopup/retrieveAgencyPopup.do"/>',
                 params: {
                 	custCd: document.getElementById('custCd').value,
                 	custNm: document.getElementById('custNm').value,
                 	devonTargetRow : ((e.pageNumber-1) * 10 + 1) ,
                 	pageNumber : e.pageNumber,
                 	devonRowSize : 10
                 }
             });                 
            }
            
        });
        
        //pager.render();
        pager.render('divPager');
         --%>
        
        
        grid.render('defaultGrid');
        
        grid.on('cellClick', function(e) {
            if(dataSet.getRow() > -1) {
             var record = dataSet.getAt(dataSet.getRow());
             fncSetValue(record.get("saUser") , record.get("saName"));
        	}
        });            
        
        
        <%--// *******************
         * 버튼 이벤트 
         ******************* --%>
        searchBtn = new Rui.ui.LButton('searchBtn');
        searchBtn.on('click', function(){
        	fncSearch();  
        });   
        
        
        dataSet.on('load', function(e){
        	<%--//alert(dataSet.getCount() + "dataset load" + pager.pageNumber);--%>
            if( dataSet.getCount() == 1){
            	<%--// 페이징처리
            	//if(pager.pageNumber == 1) {--%>
             	var record = dataSet.getAt(0);
             	fncSetValue(record.get("saUser") , record.get("saName"));
             	<%--//};--%>
            } else {
            	//alert(document.getElementById("cnt_text").innerHTML);--%>
            	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
            }
            <%--// 
            // 페이징처리
            if( dataSet.getCount() > 0) {
            	var record = dataSet.getAt(0);
            	pager.setTotalCount(record.get("totCnt"));
            } else {
            	pager.setTotalCount(0);
            }
             --%>
            
        });
        
        <%--// 화면로딩시 자동 조회--%>
        //fncSearch();             
        
        

    });
    
    <%--/*******************************************************************************
    * FUNCTION 명 : fncSetValue (값 셋팅)
    * FUNCTION 기능설명 : 폼에 값을 return한다. 
    *******************************************************************************/--%>
    function fncSetValue(saUser, saName){

    	var oReceiver = window.dialogArguments;
    	
    	if (oReceiver.eeId    != null) oReceiver.eeId.value    = saUser;	
    	if (oReceiver.eeNm    != null) oReceiver.eeNm.value    = saName;
    		
    	top.close();
    }
    
    function fncSearch(){
        dataSet.load({
            url: '<c:url value="/system/user/retreiveLgUserList.do"/>',
            params: {
            		  eeId: document.getElementById('eeId').value
         			, eeNm: escape(encodeURIComponent(document.getElementById('eeNm').value)) 
         	<%--//  페이징처리
         	,devonTargetRow : 1
         	,pageNumber : 1
         	,devonRowSize : 10
         	 --%>
         	
            }
        });        	
    }

</script>
</head>
<base target="_self" />

<body id="popup_body">
<Tag:saymessage/><%--<!--  sayMessage 사용시 필요 -->--%>
<form id="pform" name="pform" method="post"> 

<div class="pop-wrap" style="width:800px;">
	<div class="pop-title">
		<h2>대리점 조회</h2>
		<a href="javascript:window.close();" class="cbtn">닫기</a>
	</div>

	<div class="pop-container">
		<div class="titArea">
											
			<table class="searchBox">
				<tbody>
					<tr>
						<th>사원ID</th>
						<td><input type="text" class="Ltext" id="eeId" name="eeId" value="<c:out value="${query.eeId}"/>" size="15" onKeyDown="javascript:if(window.event.keyCode==13){fncSearch();}"/></td>
						<th>사원명</th>
						<td><input type="text" class="Ltext"" id="eeNm" name="eeNm" value="<c:out value="${query.eeNm}"/>" size="15" onKeyDown="javascript:if(window.event.keyCode==13){fncSearch();}"/></td>
						<td>
							<div class="LblockButton">
								<button type="button" id="searchBtn" >검색</button>
							</div>						
						</td>							
					</tr>
				</tbody>
			</table>
													
		</div>
	    <span class="Ltotal" id="cnt_text">총  0건 </span>
		<div id="defaultGrid"></div>
	</div><!-- //pop-container -->
	<div class="pop-footer">
		<p>COPYRIGHT 2010 BY LG HAUSYS,LTD ALL RIGHT RESERVED.</p>
		<a class="pop-close" href="javascript:window.close();">CLOSE</a>
	</div>
</div><!-- //pop-wrap -->

</form>    

</body>
</html>

