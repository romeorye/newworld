<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: rfpListPop.jsp
 * @desc    : RFP 요청서 리스트  팝업창
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.05.17     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">

	Rui.onReady(function() {
		/*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
         dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
            	  { id: 'rfpId'}
            	 ,{ id: 'title'}
            	 ,{ id: 'reqDate'}
            	 ,{ id: 'rsechEngn'}
            	 ,{ id: 'descTclg'}
            	 ,{ id: 'exptAppl'}
            	 ,{ id: 'mainReq'}
            	 ,{ id: 'benchMarkTclg'}
            	 ,{ id: 'colaboTclg'}
            	 ,{ id: 'timeline'}
            	 ,{ id: 'comments'}
            	 ,{ id: 'companyNm'}
            	 ,{ id: 'rgstNm'}
            	 ,{ id: 'submitYn'}
 			]
         });

         dataSet.on('load', function(e){
 	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
 	     });

         var columnModel = new Rui.ui.grid.LColumnModel({
             columns: [
             	new Rui.ui.grid.LSelectionColumn(),
            	 { field: 'title',    	label:'Title' , 			sortable: false, align: 'left', width: 240},
                 { field: 'reqDate',    label:'RequestDate' , 		sortable: false, align: 'center', width: 100},
                 { field: 'rsechEngn',  label:'ResearchEngineer', 	sortable: false, align: 'left', width: 200},
                 { field: 'rgstNm',    	label:'등록자', 			sortable: false, align: 'center', width: 100},
                 { field: 'submitYn',   label:'제출여부', 			sortable: false, align: 'center', width: 80},
                 { field: 'rfpId',  hidden : true}
             ]
         });

         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             height: 280,
             width : 750.

         });

        grid.render('rfpGrid');

         grid.on('cellClick', function(e) {
 			var record = dataSet.getAt(dataSet.getRow());

 			if(dataSet.getRow() > -1) {
 				parent._callback(record);
 				parent.rfpDialog.submit(true);
 			}
      	});

         fnSearch = function() {
  	    	dataSet.load({
  	            url: '<c:url value="/prj/tss/rfp/retrieveRfpSearchList.do"/>',
  	            params :{
  	            	  title  : encodeURIComponent(document.aform.title.value)
  	            	 ,rgstNm : encodeURIComponent(document.aform.rgstNm.value)
  	            	 ,adminYn : "Y"
  	    	          }
              });
         }

         fnSearch();

	});
</script>
</head>

<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="bd">
		<!-- <div class="titleArea">
  			<h2>RFP 요청서 목록</h2>
  	    </div> -->
  		<div class="sub-content" style="padding:10px 7px 0 8px;">
			<form name="aform" id="aform">
				<div class="search mb5">
				<div class="search-content">
  				<table>
  					<colgroup>
  						<col style="width:90px"/>
  						<col style="width:"/>
  						<col style="width:90px"/>
  						<col style="width:"/>
  						<col style="width:"/>
  					</colgroup>
  					<tbody>
  					    <tr>
  							<th align="right">RFP제목</th>
  							<td>
								<input type="text"  id="title" >
  							</td>
  							<th align="right">등록자</th>
	   						<td>
	   							<input type="text"  id="rgstNm" >
	   						</td>
   							<td  class="txt-right">
  								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
  							</td>
  						</tr>
  					</tbody>
  				</table>
  				</div>
  				</div>

  				<div class="titArea">
  					<span class=table_summay_number id="cnt_text"></span>
  				</div>
  				<div id="rfpGrid"></div>
			</form>
		</div>
	</div>
</body>
</html>