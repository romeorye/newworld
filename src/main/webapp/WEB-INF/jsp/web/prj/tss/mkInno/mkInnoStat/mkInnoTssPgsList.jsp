<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: mkInnoTssPgsList.jsp
 * @desc    :  제조혁신 대시보드 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.11.12  IRIS005
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>


<script type="text/javascript">
	Rui.onReady(function() {
		var dm = new Rui.data.LDataSetManager();

		dm.on('load', function(e) {
		});
		
		var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { 
                  active : true,
               	  label: '과제건수 관리',
                  id : 'tssCntMgtDiv'
                },
                { 
                	label: '과제진행현황 관리',
                  id : 'tssPgsMgtDiv'
                }
            ]
        });
		
		tabView.on('canActiveTabChange', function(e){

            switch(e.activeIndex){
            case 0:
                break;

            case 1:
                break;
            default:
                break;
            }
        });

        tabView.on('activeTabChange', function(e){
            switch(e.activeIndex){
            case 0:
                break;

            case 1:
                if(e.isFirst){
                }
                break;
           
            default:
                break;
            }

        });

        tabView.render('tabView');
        
        var searchMonth = new Rui.ui.form.LMonthBox({
			applyTo: 'searchMonth',
			width: 100,
			defaultValue : new Date(),
			dateType: 'string'
		});
        
        cntBizDataSet = new Rui.data.LJsonDataSet({
			id: 'cntBizDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	    { id: 'bizNm' }                                      //사업부 
                  , { id: 'tssPlCnt' }                                        //신규과제         
                  , { id: 'tssPgCnt' }                                        //진행과제         
                  , { id: 'tssCmCnt' }                                          //완료과제               
                  , { id: 'tssDlCnt' }                                          //지연과제               
                  , { id: 'tssTot' }                                            //총과제
            ]
		});
        
        cntBizDataSet.on('load', function(e) {
			
		});
        
        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
             autoWidth: true,
             columns: [
                    { field: 'bizNm', 		label: '사업부', 	sortable: false, align:'center', width: 250 }
                   ,{ field: 'tssPlCnt', 	label: '신규과제', 	sortable: false, align:'right', width: 120 }
                   ,{ field: 'tssPgCnt', 	label: '진행과제', 	sortable: false, align:'right', width: 120} 
  	               ,{ field: 'tssCmCnt', 	label: '완료과제', 	sortable: false, align:'right', width: 120} 
                   ,{ field: 'tssDlCnt', 	label: '지연과제', 	sortable: false, align:'right', width: 150 }
                   ,{ field: 'tssTot', 		label: '총과제', 	sortable: false, align:'right', width: 150 }
              ]
         });
  		
  		var grid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: cntBizDataSet,
              width: 1100,
              height: 230
          });
  		
          grid.render('tssCntBizGrid');
          
        cntTeamDataSet = new Rui.data.LJsonDataSet({
			id: 'cntTeamDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	    { id: 'teamNm' }                                      //팀별 
                  , { id: 'tssPlCnt' }                                        //신규과제         
                  , { id: 'tssPgCnt' }                                        //진행과제         
                  , { id: 'tssCmCnt' }                                          //완료과제               
                  , { id: 'tssDlCnt' }                                          //지연과제               
                  , { id: 'tssTot' }                                            //총과제
            ]
		});
        cntTeamDataSet.on('load', function(e) {
			
		});
      
		//그리드
        var columnModel1 = new Rui.ui.grid.LColumnModel({
             autoWidth: true,
             columns: [
                    { field: 'teamNm', 		label: '팀명', 	sortable: false, align:'center', width: 250 }
                   ,{ field: 'tssPlCnt', 	label: '신규과제', 	sortable: false, align:'right',	 width: 120 }
                   ,{ field: 'tssPgCnt', 	label: '진행과제', 	sortable: false, align:'right', width: 120} 
  	               ,{ field: 'tssCmCnt', 	label: '완료과제', 	sortable: false, align:'right', width: 120} 
                   ,{ field: 'tssDlCnt', 	label: '지연과제', 	sortable: false, align:'right', width: 150 }
                   ,{ field: 'tssTot', 		label: '총과제', 	sortable: false, align:'right', width: 150 }
              ]
         });
  		
  		var grid1 = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel1,
              dataSet: cntTeamDataSet,
              width: 1100,
              height: 230
         });
  		
         grid1.render('tssCntTeamGrid');
        
        pgsBizDataSet = new Rui.data.LJsonDataSet({
			id: 'pgsBizDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	    { id: 'bizNm' }                                      //사업부 
                  , { id: 'grn' }                                        //신규과제         
                  , { id: 'yel' }                                        //진행과제         
                  , { id: 'red' }                                          //완료과제               
                  , { id: 'tot' }                                          //지연과제               
            ]
		});
        
        pgsBizDataSet.on('load', function(e) {
			
		});
        
      //그리드
        var columnModel2 = new Rui.ui.grid.LColumnModel({
             autoWidth: true,
             columns: [
                    { field: 'bizNm', 	label: '사업부', 	sortable: false, align:'center', width: 250 }
                   ,{ field: 'grn', 	label: 'Green', 	sortable: false, align:'right', width: 120 }
                   ,{ field: 'yel', 	label: 'Yellow', 	sortable: false, align:'right', width: 120} 
  	               ,{ field: 'red', 	label: 'Red', 		sortable: false, align:'right', width: 120} 
                   ,{ field: 'tot', 	label: '총합', 		sortable: false, align:'right', width: 150 }
              ]
         });
  		
  		var grid2 = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel2,
              dataSet: pgsBizDataSet,
              width: 1100,
              height: 230
          });
  		
          grid2.render('tssPgsBizGrid');
          
          
        pgsTeamDataSet = new Rui.data.LJsonDataSet({
			id: 'pgsTeamDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	    { id: 'teamNm' }                                      //팀별 
            	   ,{ id: 'grn' }                                        //신규과제         
                   ,{ id: 'yel' }                                        //진행과제         
                   ,{ id: 'red' }                                          //완료과제               
                   ,{ id: 'tot' }                                          //지연과제        
            ]
		});
        pgsTeamDataSet.on('load', function(e) {
			
		});
        
      //그리드
        var columnModel3 = new Rui.ui.grid.LColumnModel({
             autoWidth: true,
             columns: [
                     { field: 'teamNm', label: '팀명', 		sortable: false, align:'center', width: 250 }
                    ,{ field: 'grn', 	label: 'Green', 	sortable: false, align:'right', width: 120 }
                    ,{ field: 'yel', 	label: 'Yellow', 	sortable: false, align:'right', width: 120}
   	                ,{ field: 'red', 	label: 'Red', 		sortable: false, align:'right', width: 120} 
                    ,{ field: 'tot', 	label: '총합', 		sortable: false, align:'right', width: 150 }
              ]
         });
  		
  		var grid3 = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel3,
              dataSet: pgsTeamDataSet,
              width: 1100,
              height: 230
          });
  		
        grid3.render('tssPgsTeamGrid');
         
        
        fncMkInnoTssInfoList = function(){
        	dm.loadDataSet({
                dataSets: [cntBizDataSet, cntTeamDataSet, pgsBizDataSet, pgsTeamDataSet],
                url: '<c:url value="/prj/tss/mkInnoStat/retrieveMkInnoStatInfoList.do"/>',
                params: {
                	searchMonth : searchMonth.getValue()
                }
            });
        }
		
        
	});	
</script>
</head>
<boyd>
<form name="aform" id="aform" method="post">
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
	   		<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	   		<span class="hidden">Toggle 버튼</span>
   		</a>
   		<h2>대시보드  통계</h2>
	</div>
	<div class="sub-content">
		<div class="search">
			<div class="search-content">
				<table>
   					<colgroup>
   						<col style="width:120px;"/>
   						<col style="width:276px;"/>
   						<col style=""/>
   					</colgroup>
		   			<tbody>
		   				<tr>
		   					<th align="right">기간</th>
		    				<td>
		   						<input type="text" id="searchMonth"/>
		    				</td>
		    				<td>	
   								<a style="cursor: pointer;" onclick="fncMkInnoTssInfoList();" class="btnL">검색</a>
		   					</td>
   						</tr>
   					</tbody>
   				</table>
			</div>
		</div>
		<br/> 
        <div id="tabView"></div>
		<br/>
		<div id="tssCntMgtDiv">
			<div class="titArea">
   				<h3>- 사업부별 관리 현항</h3>
   			</div>	
			<div id="tssCntBizGrid"></div>
			<br/>
			<div class="titArea">
   				<h3>- 팀별관리 현황</h3>
   			</div>
			<div id="tssCntTeamGrid"></div>
		</div>
		<div id="tssPgsMgtDiv">
			<div class="titArea">
   				<h3>- 사업부별 관리 현항</h3>
   			</div>
			<div id="tssPgsBizGrid"></div>
			<br/>
			<div class="titArea">
   				<h3>- 팀별관리 현황</h3>
   			</div>
			<div id="tssPgsTeamGrid"></div>
		</div>
	</div>	
</div>
</form>
</body>
</html>