<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>
<%--
/*
 *************************************************************************
 * $Id		: nrmList.jsp
 * @desc    : 소장 규격 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.08.01   IRIS05			최초생성
 * ---	-----------	----------	-----------------------------------------
 * 
 *************************************************************************
 */
--%>				 

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<script type="text/javascript">

	Rui.onReady(function() {
		
		/*******************
         * 변수 및 객체 선언
         *******************/
         var knldNrmDataSet = new Rui.data.LJsonDataSet({
             id: 'knldNrmDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
		         { id : 'nrmId' } 
				,{ id : 'nrmNo'}			//규격번호
				,{ id : 'nrmNm'}			//규격명
				,{ id : 'issAuth'}			// 발행기관
				,{ id : 'aplcNo'}			//	신청자사번 
				,{ id : 'aplcNm'}			//신청자 명   
				,{ id : 'getDt'}			//입수일  
				,{ id : 'enctDt'}			//제정일 
				,{ id : 'lastRfrmDt'}		//최종개정일  
				,{ id : 'subsidiaryInfo' } 	//부화합정보 
				,{ id : 'lang'}				//언어 
				,{ id : 'pce'}				//가격    
				,{ id : 'pageCnt'}			//페이지수  
				,{ id : 'abst'}				//초록  
				,{ id : 'attcFileId' }
			]
         });
		
         knldNrmDataSet.on('load', function(e){
 	    	document.getElementById("cnt_text").innerHTML = '총 ' + knldNrmDataSet.getCount() + '건';
 	    	// 목록 페이징
 	    	paging(knldNrmDataSet,"knldNrmGrid");
 	     });
		
         var knldNrmColumnModel = new Rui.ui.grid.LColumnModel({
             columns: [
                   { field: 'nrmNo',	label: '규격번호',	sortable: false,	align:'center',	width: 100 }
                 , { field: 'nrmNm',	label: '규격명',		sortable: false,	align:'left',	width: 680 }
                 , { field: 'issAuth',	label: '발행기관',	sortable: false,	align:'center',	width: 250 }
                 , { field: 'aplcNm',	label: '신청자',		sortable: false,	align:'center',	width: 100 }
				 , { field: 'getDt',	label: '입수일',		sortable: false, 	align:'center',	width: 100 }
				 , { field: 'nrmId',	hidden:true}
             ]
         });
		
         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: knldNrmColumnModel,
             dataSet: knldNrmDataSet,
             width: 1300,
             height: 400
         });
		
         grid.render('knldNrmGrid');	
		
         grid.on('cellClick', function(e) {
        	var record = knldNrmDataSet.getAt(knldNrmDataSet.getRow());
        	 
        	document.aform.nrmId.value = record.get("nrmId");
			nwinsActSubmit(document.aform, "<c:url value="/knld/nrm/nrmInfoDtl.do"/>");
         })
         
         //규격 코드
  	    var nrmNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'nrmNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        placeholder: ''
  	    });
         
  	  	//규격 명
 	    var nrmNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'nrmNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: ''
 	    });
  
 	   	//발행기관
 	    var issAuth = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'issAuth',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: ''
 	    });

        fnSearch = function() {
        	 knldNrmDataSet.load({
 	            url: '<c:url value="/knld/nrm/retrieveNrmSearchList.do"/>' ,
 	            params :{
 	            	 nrmNo :  document.aform.nrmNo.value
 	    		    ,nrmNm :  encodeURIComponent(document.aform.nrmNm.value)	
 	    		    ,issAuth : encodeURIComponent(document.aform.issAuth.value)
                 }
             });
        }
        
        // 화면로드시 조회
 	    fnSearch();
		
        /* [버튼] : 신규화면으로 이동 */
		var butRgst = new Rui.ui.LButton('butRgst');
		
        butRgst.on('click', function(){
			nwinsActSubmit(document.aform, "<c:url value="/knld/nrm/nrmInfoDtl.do"/>");
		});
		
	
		
		
	});

</script>
</head>

<body  onkeypress="if(event.keyCode==13) {fnSearch();}" >
	<form name="aform" id="aform" method="post">
   		<input type="hidden" id="nrmId" name ="nrmId" />
   		
   		<div class="contents">
   			<div class="titleArea">
					<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
        		</a>
   				<h2>소장규격</h2>
   			</div>

  			<div class="sub-content">
	   			<div class="search">
					<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style="width:300px;"/>
		   						<col style="width:120px;"/>
		   						<col style="width:300px;"/>
		   						<col style=";"/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">규격번호</th>
		   							<td>
		   								<input type="text" id="nrmNo"/>
		   							</td>
		   						    <th align="right">규격명</th>
		   							<td>
		   								<input type="text" id="nrmNm"/>
		   							</td>
		   						</tr>
		   						<tr>
		   							<th align="right">발행기관</th>
		   							<td>
		   								<input type="text" id="issAuth"/>
		   							</td>
		   							<td></td>
		   							<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
					</div>
   				</div>
					
   				<div class="titArea">
  					<span class=table_summay_number id="cnt_text"></span>
					<div class="LblockButton">
  						<button type="button" id="butRgst" name="butRgst" >신규</button>
  					</div>
  				</div>

   				<div id="knldNrmGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>



			
				 