<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoRlisTodoList.jsp
 * @desc    : 자산관리 >  자산실사 TO_do
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.21     IRIS05		최초생성
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>

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
 				  { id: 'prjNm'}
 				, { id: 'fxaNo'}
 				, { id: 'fxaNm'}
 				, { id: 'fxaQty'}
 				, { id: 'fxaUtmNm'}
 				, { id: 'crgrNm'}
 				, { id: 'fxaClss'}
 				, { id: 'rlisDt'}
 				, { id: 'fxaSsisYn'}
 				, { id: 'fxaRem'}
 				, { id: 'rlisMappId'}
 				, { id: 'fxaInfoId'}
 				, { id: 'deptCd'}
 				, { id: 'crgrId'}
             	, { id: 'wbsCd'}
 			]
         });
		
         dataSet.on('load', function(e){
        	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
  	    });

         var columnModel = new Rui.ui.grid.LColumnModel({
             columns: [
         	 	       { field: 'prjNm'      , label: '프로젝트명', sortable: false,	align:'left', width: 230}
                     , { field: 'fxaNo'      , label: '자산번호',  	sortable: false,	align:'center', width: 100}
                     , { field: 'fxaNm'      , label: '자산명',  	sortable: false,	align:'left', width:300}
                     , { field: 'fxaQty' 	 , label: '수량',  		sortable: false,	align:'center', width: 30}
                     , { field: 'fxaUtmNm'   , label: '단위',  		sortable: false,	align:'center', width: 40}
                     , { field: 'crgrNm'     , label: '담당자',  	sortable: false,	align:'center', width: 70}
                     , { field: 'fxaClss'    , label: '자산클래스', sortable: false,	align:'center', width: 80}
                     , { field: 'rlisDt' 	 , label: '최근실사일', sortable: false,	align:'center', width: 80}
                     , { field: 'fxaSsisYn'  , label: '자산유무',  	sortable: false,	align:'center', width: 70, renderer: function(val, p, record, row, i){
                        	if(val == "Y"){
                        		val ="사용";
                        	}else{
                        		val ="미사용";
                        	}
                     }}
                     , { field: 'fxaRem'     , label: '비고',  	    sortable: false,	align:'center', width: 150, editor: new Rui.ui.form.LTextBox() }
 					 , { field: 'wbsCd'      , label: 'WBS 코드',   hidden: true}
             	     , { field: 'rlisMappId' , hidden : true}
             	     , { field: 'fxaInfoId'  , hidden : true}
             	     , { field: 'deptCd'      , hidden : true}
             	     , { field: 'crgrId'     , hidden : true}
             ]
         });

         /** default grid **/
         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             width: 600,
             height: 350,
             autoToEdit: false,
             autoWidth: true
         });

         grid.render('defaultGrid');
		
         fnSearch = function() {
 	    	dataSet.load({
 	            url: '<c:url value="/fxa/rlis/retrieveFxaRlisTodoViewList.do"/>',
 	            params :{
 	            	fxaRlisId : document.aform.fxaRlisId.value, 	// 
                 }
             });
         }

         // 화면로드시 조회
 	    fnSearch();
         
        /* [버튼] : 자산실사 목록 화면이동 */
     	var butList = new Rui.ui.LButton('butList');
     	butList.on('click', function(){
     		document.aform.action='<c:url value="/fxa/rlis/retrieveFxaRlisList.do"/>';
    		document.aform.submit();
     	});
     
     	 //document.domain = 'lghausys.com';
         // 유관시스템 확인 버튼 클릭시 같이 호출 parent.TodoCallBack();
     	
	});		//end ready

</script>
    </head>
    <body >
    		<div class="contents">
    			<div class="titleArea">
    				<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
	        	</a>  
    				<h2>자산실사처리 To_do</h2>
    		    </div>
    			<div class="sub-content">

					<form name="aform" id="aform" method="post">
					<input type="hidden" id="menuType"  name="menuType" />
					<input type="hidden" id="fxaRlisId"  name="fxaRlisId" value="<c:out value='${inputData.fxaRlisId}'/>">
					<input type="hidden" id="rlisStCd"  name="rlisStCd" value="<c:out value='${inputData.rlisStCd}'/>">

    					
						<div class="titArea btn_top">
							<span class="table_summay_number" id="cnt_text"></span>
							<div class="LblockButton">  								
    							<button type="button" id="butList">목록</button>
    						</div>
    					</div>
    				<table class="table table_txt_right">
    				</table>
    				<div id="defaultGrid"></div>
				</form>

    			</div><!-- //sub-content -->
    		</div><!-- //contents -->
    </body>
    </html>