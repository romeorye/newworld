<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: AnlQnaList.jsp
 * @desc    : 분석QnA 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.18  			최초생성
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

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript">
var anlQnaDataSet;	// 프로젝트 데이터셋
var anlQnaGrid;       // 그리드

	Rui.onReady(function() {
      /*******************
       * 변수 및 객체 선언
       *******************/
          /* 검색 코드 */
          var searchCd = new Rui.ui.form.LCombo({
              applyTo: 'searchCd',
              name: 'searchCd',
              useEmptyText: true,
              emptyText: '선택',
              width: 150,
              items: [
                  { value: 'bbsTitlCode',text: '제목'},
                  { value: 'bbsSbcCode', text: '내용'},
                  { value: 'rgstNmCode', text: '등록자'}
              ]
          });

		  /* 검색 내용 */
          var searchNm = new Rui.ui.form.LTextBox({
              applyTo: 'searchNm',
              width: 500
          });

          searchNm.on('keypress', function(e) {
  			if(e.keyCode == 13 && document.aform.searchCd.value != '' ) {
  				getAnlQnaList();
  			}
          });

       	  /* [버튼] 신규 등록 */
       	  var rgstBtn = new Rui.ui.LButton('rgstBtn');
       	  rgstBtn.on('click', function() {
       		  fncAnlQnaRgstPage('');
       	  });

    	  /** dataSet **/
    	  anlQnaDataSet = new Rui.data.LJsonDataSet({
    	      id: 'anlQnaDataSet',
    	      remainRemoved: true,
    	      lazyLoad: true,
    	      //defaultFailureHandler:false,
    	      fields: [
		  		       { id: 'bbsId'}
		  			 , { id: 'bbsCd' }
		  			 , { id: 'bbsNm' }
		  			 , { id: 'rltdBulPath' }
		  			 , { id: 'bbsTitl' }
		  			 , { id: 'bbsSbc' }
		  			 , { id: 'docNo' }
		  			 , { id: 'sopNo' }
		  			 , { id: 'anlTlcgClCd' }
		  			 , { id: 'anlTlcgClNm' }
		  			 , { id: 'qnaClCd' }
		  			 , { id: 'qnaClNm' }
		  			 , { id: 'rtrvCt' }
		  			 , { id: 'bbsKwd' }
		  			 , { id: 'attcFilId' }
		  			 , { id: 'rgstId' }
		  			 , { id: 'rgstNm' }
		  			 , { id: 'delYn' }
		  			 , { id: 'frstRgstDt' }
		  			 , { id: 'depth', type:'number' }
		  		]
    	  });


          var columnModel = new Rui.ui.grid.LColumnModel({
              columns: [
            	    { field: 'qnaClCd',     label: '구분',		sortable: false,	align:'center',	width: 100 }
            	  , { field: 'bbsTitl',		label: '제목',      sortable: false,	align:'left',	width: 805,
            	    	renderer:  function(val, p, record, row, i){
            	    	var titlNm = val;

            	    	if(record.get('depth') > 1) {
            	    		titlNm = ''.lPad("&nbsp;", (record.get('depth') - 2) * 30) +
                      		'<img src="<%=newImagePath%>/treemenu_images/last_normal.gif"/> ' + val;
            	    	}
                      return titlNm;
					} }
                  , { field: 'rgstNm',		label: '작성자',	sortable: false,	align:'center',	width: 100 }
                  , { field: 'frstRgstDt',	label: '게시일',	sortable: false,	align:'center',	width: 100 }
			      , { field: 'rtrvCt',		label: '조회',		sortable: false, 	align:'center',	width: 60  }
              ]
          });


          anlQnaGrid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: anlQnaDataSet,
              width: 600,
              height: 585,
              autoToEdit: false,
              autoWidth: true
          });


          anlQnaGrid.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = anlQnaDataSet.getAt(anlQnaDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");

	        	   anlQnaDataSet.load({
	                    url: '<c:url value="/anl/lib/updateAnlQnaRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlQnaInfo.do'/>");
                }

           });

          anlQnaGrid.render('defaultGrid');

           /* 조회, 검색 */
           getAnlQnaList = function() {
        	   anlQnaDataSet.load({
                   url: '<c:url value="/anl/lib/getAnlQnaList.do"/>',
                   params :{
                	searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                   	searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };

           anlQnaDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + anlQnaDataSet.getCount() + '건');
  	      	});

           getAnlQnaList();
       });
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncAnlQnaRgstPage (분석QnA 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncAnlQnaRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.bbsId.value = record.get("bbsId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlQnaRgst.do'/>")
}

</script>

    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="bbsId" name="bbsId" value=""/>
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />

   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	   				<h2>분석 Q&A</h2>
	   			</div>

   				<table class="searchBox">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:30%;"/>
   						<col style="width:15%;"/>
   						<col style="width:"/>
   						<col style="width:10%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">
   							<div id="searchCd"></div>
   							</th>
   							<td>
   								<input type="text" id="searchNm" value="">
   							</td>
   							<td class="t_center" >
   								<a style="cursor: pointer;" onclick="getAnlQnaList();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" id="rgstBtn" name="rgstBtn" >등록</button>
   					</div>
   				</div>

   				<div id="defaultGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>