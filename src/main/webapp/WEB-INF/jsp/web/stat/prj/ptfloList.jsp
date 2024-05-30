<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
                 java.util.*,
                 devonframe.util.NullUtil,
                 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssStat.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.25
 * ---  ----------- ----------  -----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
var gvUserId = "${inputData._userId}";
var gvActiveIndex = 0;

var nowDate = new Date();
var strNowMonth = createDashMonthToString(nowDate);

    Rui.onReady(function() {
        /*******************
         * 변수 및 객체 선언
         *******************/
        searchStartYymm = new Rui.ui.form.LMonthBox({
            applyTo: 'searchStartYymm',
            mask: '9999-99',
            displayValue: '%Y-%m',
            width: 100,
            defaultValue: strNowMonth,
            dateType: 'string'
        });
        searchStartYymm.on('changed', function(e){
            if(searchStartYymm.getValue() == ''){
                Rui.alert('시작년월을 입력해주세요.');
                searchStartYymm.setValue(strNowMonth);
                searchStartYymm.focus();
                return false;
            }
        });
        
        searchEndYymm = new Rui.ui.form.LMonthBox({
            applyTo: 'searchEndYymm',
            mask: '9999-99',
            displayValue: '%Y-%m',
            width: 100,
            defaultValue: strNowMonth,
            dateType: 'string'
        });
        searchEndYymm.on('changed', function(e){
            if(searchEndYymm.getValue() == ''){
                Rui.alert('종료년월을 입력해주세요.');
                searchEndYymm.setValue(strNowMonth);
                searchEndYymm.focus();
                return false;
            }
        });
        
        fnGridNumberFormt = function(value, p, record, row, col) {
            
        	if(dataSet.getCount() == row ){
        		value.toFixed();
        	}else{
        		value.toFixed(1);
        	}
        	
        	return Rui.util.LFormat.numberFormat(value);
        };
        
        fnGridNumberFormt1 = function(value, p, record, row, col) {
            console.log(row)
        	if(dataSet1.getCount() == row ){
        		value.toFixed();
        	}else{
        		value.toFixed(1);
        	}
        	
        	return Rui.util.LFormat.numberFormat(value);
        };
        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            fields: [
                  { id:'comDelNm' }   //분류 
                , { id:'arslExp' }    //비용실적          
                , { id:'arslExpSum' } //구성비1                
            ]
        });
        dataSet.on('load', function(e) {
            grid1.setDataSet(dataSet);
        });   
            
        dataSet1 = new Rui.data.LJsonDataSet({
            id: 'dataSet1',
            fields: [
                  { id:'comDelNm' }   //분류 
                , { id:'prodGMm' }    //인원             
                , { id:'prodGMmSum' } //구성비2
            ]
        });
        dataSet1.on('load', function(e) {
            grid2.setDataSet(dataSet1);
        });
        
        var columnModel1 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { field: 'comDelNm',   label: '분류', sortable: false, align:'center', width: 100 }
                , { field: 'arslExp',    label: '비용실적', sortable: false, align:'right', width: 50, renderer: fnGridNumberFormt }
                , { field: 'arslExpSum', label: '구성비', sortable: false, align:'right', width: 50, renderer: fnGridNumberFormt }
            ]
        });
        
        var columnModel2 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                new Rui.ui.grid.LNumberColumn()
                , { field: 'comDelNm',   label: '분류', sortable: false, align:'center', width: 100 }
                , { field: 'prodGMm',    label: '인원', sortable: false, align:'right', width: 50, renderer: fnGridNumberFormt1 }
                , { field: 'prodGMmSum', label: '구성비', sortable: false, align:'right', width: 50, renderer: fnGridNumberFormt1 }
            ]
        });
        
        var grid1 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel1,
            dataSet: dataSet,
            width: 500,
            height: 330,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });
        
        grid1.render('grid1');
        
        var grid2 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel2,
            dataSet: dataSet1,
            width: 500,
            height: 330,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        grid2.render('grid2');
        
        
        /* 조회 */
        fnSearch = function() {
            var url = "";
            var guideTxt = "";
            
            var statId1 = "";
            var statId2 = "";
            
            if(gvActiveIndex == 0){
            	url = "<c:url value='/stat/prj/retrievePtfloFunding.do'/>";
            	statId1 = "1";
            	statId2 = "2";
            }else if(gvActiveIndex == 1){
            	url = "<c:url value='/stat/prj/retrievePtfloTrm.do'/>";
            	statId1 = "3";
            	statId2 = "4";
            }else if(gvActiveIndex == 2){
            	url = "<c:url value='/stat/prj/retrievePtfloAttr.do'/>";
            	statId1 = "5";
            	statId2 = "6";
            }else if(gvActiveIndex == 3){
            	url = "<c:url value='/stat/prj/retrievePtfloSphe.do'/>";
            	statId1 = "7";
            	statId2 = "8";
            }else if(gvActiveIndex == 4){
            	url = "<c:url value='/stat/prj/retrievePtfloType.do'/>";
            	statId1 = "9";
            	statId2 = "10";
            }
            
            if(gvActiveIndex <= 2) guideTxt = "";
            else guideTxt = "* 연구분야 분류가 입력되지 않은 과제의 경우에는 모수에서 제외됩니다."
 
            document.getElementById("guideTxt").innerHTML = guideTxt;
            
            var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
            
            dm.loadDataSet({
            	dataSets: [ dataSet, dataSet1],		
                url: url,
                params :{
                    searchStartYymm: searchStartYymm.getValue() == null ? "" : searchStartYymm.getValue()
                   ,searchEndYymm: searchEndYymm.getValue() == null ? "" : searchEndYymm.getValue()
                }
            });
            
            var srcUrl = '<%=lghausysReportPath%>/portfolioInfo_new.jsp?reportMode=HTML&clientURIEncoding=UTF-8&reportParams=skip_decimal_point:true,showMenuBar:false&menu=old';
            var stYymm = searchStartYymm.getValue() == null ? "" : searchStartYymm.getValue();
            var edYymm =  searchEndYymm.getValue() == null ? "" : searchEndYymm.getValue();
       
            var param1 = "&searchStartYymm="+stYymm+"&searchEndYymm="+edYymm+"&sheetNum="+statId1; 
            var param2 = "&searchStartYymm="+stYymm+"&searchEndYymm="+edYymm+"&sheetNum="+statId2; 
            
            //var param1 = "&startYymm="+stYymm.replace("-", "")+"&endYymm="+edYymm.replace("-", "")+"&searchStartYymm="+stYymm+"&searchEndYymm="+edYymm+"&sheetNum="+statId1; 
            //var param2 = "&startYymm="+stYymm.replace("-", "")+"&endYymm="+edYymm.replace("-", "")+"&searchStartYymm="+stYymm+"&searchEndYymm="+edYymm+"&sheetNum="+statId2; 

            var iframe1 = document.getElementById("view1");
            var iframe2 = document.getElementById("view2");
            
            iframe1.src = srcUrl+param1;
            iframe2.src = srcUrl+param2;
        };
        
        
        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: 'Funding기준', content: '<div id="div-content-test1"></div>', active: true },
                { label: '기간', content: '<div id="div-content-test2"></div>' },
                { label: '과제속성', content: '<div id="div-content-test3"></div>' },
                { label: '연구분야', content: '<div id="div-content-test4"></div>' },
                { label: '유형', content: '<div id="div-content-test5"></div>' }
            ]
        });
        tabView.on('activeTabChange', function(e) {
            gvActiveIndex = e.activeIndex;

            fnSearch();
        });

        tabView.render('tabView');
        
    });
</script>
</head>
<body>
    <form name="aform" id="aform" method="post">
        <div class="contents">   
	        <div class="titleArea">
	      		<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
				</a>
	            <h2>일반과제</h2>
	        </div>
            <div class="sub-content">
               <div class="search">
				   <div class="search-content">
		               <table>
		                    <colgroup>
		                        <col style="width:120px;"/>
		                        <col style=""
		                    </colgroup>
		                    <tbody>
		                        <tr>
		                            <th align="right">년도</th>
		                            <td>
		                                <input type="text" id="searchStartYymm" /><em class="gab"> ~ </em>
		                                <input type="text" id="searchEndYymm" /> 
		
		                                <a style="margin-left:37px; cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		              </div>
		            </div>
                <br/>

	            <div id="tabView"></div>
	            
	            <table style="width:100%">
	               <colgroup>
                       <col style="width:48.5%"/>
                       <col style=""/>
                       <col style="width:48.5%"/>
                   </colgroup>
	               <tr>
	                   <td>
	                   	<div class="titArea"><h4>비용(기준:ERP실적)</h4><span class="t_right_txt">(단위: 억원)</span></div>	                   	
	                   </td>
	                   <td>&nbsp;</td>
	                   <td>
	                   	<!-- <div class="titArea"><span class="sub-tit"><h4>&gt; 인원(기준:M/M평균)<em class="gab">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em>(단위 : 명)</h4></span></div> -->
	                   	<div class="titArea"><h4>인원(기준:M/M평균)</h4><span class="t_right_txt">(단위: 억원)</span></div>
	                   	</td>
	               </tr>
	               <tr>
	                   <td><div id="grid1"></div></td>
	                   <td>&nbsp;</td>
	                   <td><div id="grid2"></div></td>
	               </tr>
	               <tr>
		               	<td height="40"></td>
		               	<td></td>
		               	<td></td>
	               </tr>
	                <tr>
	                   <td>
		                 	<iframe id="view1" name="view1" width="550" height="380" frameborder="0" scrolling="no"></iframe> 
	                   	</td>
	                   <td>&nbsp;</td>
	                   <td>
	                   		<iframe id="view2" name="view2" width="550" height="380" frameborder="0" scrolling="no"></iframe> 
	                   </td>
	               </tr>
	               <tr>
	                   <td class="alignR" colspan="3"><span id="guideTxt"></span></td>
	               </tr>
	            </table>
            </div><!-- //sub-content -->
        </div><!-- //contents -->
        </form>
    </body>
</html>