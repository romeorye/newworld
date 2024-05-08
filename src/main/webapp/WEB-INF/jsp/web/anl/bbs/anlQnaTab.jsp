<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlBbsList.jsp
 * @desc    : 분석자료실 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.27  			최초생성
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css" />

<script type="text/javascript">
var anlQnaDataSet;	// 프로젝트 데이터셋
var anlBbsGrid;       // 그리드
var bbsId = "${inputData.bbsId}";
var bbsCd = "${inputData.bbsCd}";
var target = "${inputData.target}";

	Rui.onReady(function() {
       /*******************
        * 변수 및 객체 선언
        *******************/
           /* 검색 코드 */
           var searchCd = new Rui.ui.form.LCombo({
        	   applyTo: 'searchCd',
               name: 'searchCd',
               useEmptyText: false,
//                emptyText: '선택',
               width: 150,
               items: [
            	   { value: 'bbsTitlSbcCode',    text: '제목 + 내용'},
                   { value: 'rgstNmCode',     text: '등록자'}
               ]
           });

           /* 검색 내용 */
           var searchNm = new Rui.ui.form.LTextBox({
        	   applyTo: 'searchNm',
               width: 390
           });

           searchNm.on('keypress', function(e) {
     			if(e.keyCode == 13) {
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
		   		      { id: 'bbsId' }       /*게시판ID*/
		   			, { id: 'bbsCd' }       /*분석게시판코드*/
		   			, { id: 'bbsNm' }       /*게시판명*/
		   			, { id: 'bbsTitl'}      /*게시판제목*/
		   			, { id: 'bbsSbc' }      /*게시판내용*/
		   			, { id: 'rgstId' }      /*등록자ID*/
		   			, { id: 'rgstNm' }      /*등록자이름*/
		   			, { id: 'rtrvCt' }      /*조회건수*/
		   			, { id: 'bbsKwd' }      /*키워드*/
		   			, { id: 'attcFilId' }   /*첨부파일ID*/
		   			, { id: 'docNo' }       /*문서번호*/
		   			, { id: 'anlTlcgClNm' } /*분석기술정보분류이름*/
		   			, { id: 'qnaClCd' }     /*질문답변구분코드*/
		   			, { id: 'qnaClNm' }     /*질문답변구분이름*/
		   			, { id: 'frstRgstDt'}   /*등록일*/
		   			, { id: 'delYn' }       /*삭제여부*/
    	   	  ]
    	   });
    	   
		   //표준실험절차서
           var columnModel01 = new Rui.ui.grid.LColumnModel({
               columns: [
                new Rui.ui.grid.LNumberColumn()
              , { field: 'bbsNm',		label: '분석구분',    sortable: false,	align:'left',	width: 200 }
           	  , { field: 'qnaClCd',     label: '구분',		sortable: false,	align:'center',	width: 100 }
           	  , { field: 'bbsTitl',		label: '제목',      sortable: false,	align:'left',	width: 560,
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

           anlBbsGrid01 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel01,
               dataSet: anlQnaDataSet,
               width: 1180,
               height: 525
           });

           anlBbsGrid01.on('cellClick', function(e) {
	           if(e.colId == "bbsTitl") {
	        	   var record = anlQnaDataSet.getAt(anlQnaDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlQnaDataSet.load({
	                    url: '<c:url value="/anl/bbs/updateAnlQnaRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlQnaInfo.do'/>");
                }

           });

           anlBbsGrid01.render("anlBbsGrid01");

           //분석사례
           var columnModel02 = new Rui.ui.grid.LColumnModel({
               columns: [
            	   new Rui.ui.grid.LNumberColumn()
              , { field: 'bbsNm',		label: '분석구분',    sortable: false,	align:'left',	width: 200 }
              , { field: 'qnaClCd',     label: '구분',		sortable: false,	align:'center',	width: 100 }
           	  , { field: 'bbsTitl',		label: '제목',      sortable: false,	align:'left',	width: 560,
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

           anlBbsGrid02 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel02,
               dataSet: anlQnaDataSet,
               width: 1180,
               height: 525
           });

           anlBbsGrid02.on('cellClick', function(e) {
	           if(e.colId == "bbsTitl") {
	        	   var record = anlQnaDataSet.getAt(anlQnaDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlQnaDataSet.load({
	                    url: '<c:url value="/anl/bbs/updateAnlQnaRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlQnaInfo.do'/>");
                }

           });

           anlBbsGrid02.render("anlBbsGrid02");

           //기기메뉴얼
           var columnModel03 = new Rui.ui.grid.LColumnModel({
               columns: [
            	   new Rui.ui.grid.LNumberColumn()
              , { field: 'bbsNm',		label: '분석구분',    sortable: false,	align:'left',	width: 200 }
              , { field: 'qnaClCd',     label: '구분',		sortable: false,	align:'center',	width: 100 }
           	  , { field: 'bbsTitl',		label: '제목',      sortable: false,	align:'left',	width: 560,
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

           anlBbsGrid03 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel01,
               dataSet: anlQnaDataSet,
               width: 1180,
               height: 525
           });

           anlBbsGrid03.on('cellClick', function(e) {
	           if(e.colId == "bbsTitl") {
	        	   var record = anlQnaDataSet.getAt(anlQnaDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlQnaDataSet.load({
	                    url: '<c:url value="/anl/bbs/updateAnlQnaRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlQnaInfo.do'/>");
                }

           });

           anlBbsGrid03.render("anlBbsGrid03");

           //분석기술정보
           var columnModel04 = new Rui.ui.grid.LColumnModel({
               columns: [
            	   new Rui.ui.grid.LNumberColumn()
              , { field: 'bbsNm',		label: '분석구분',    sortable: false,	align:'left',	width: 200 }
              , { field: 'qnaClCd',     label: '구분',		sortable: false,	align:'center',	width: 100 }
           	  , { field: 'bbsTitl',		label: '제목',      sortable: false,	align:'left',	width: 560,
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

           anlBbsGrid04 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel04,
               dataSet: anlQnaDataSet,
               width: 1180,
               height: 525
           });

           anlBbsGrid04.on('cellClick', function(e) {
	           if(e.colId == "bbsTitl") {
	        	   var record = anlQnaDataSet.getAt(anlQnaDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlQnaDataSet.load({
	                    url: '<c:url value="/anl/bbs/updateAnlQnaRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlQnaInfo.do'/>");
                }

           });

           anlBbsGrid04.render("anlBbsGrid04");

           anlQnaDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + anlQnaDataSet.getCount() + '건');
  	      	});

           /* 조회, 검색 */
           getAnlQnaList = function() {
        	   anlQnaDataSet.load({
                   url: '<c:url value="/anl/bbs/getAnlQnaList.do"/>',
                   params :{
                	   
                	bbsCd : '${inputData.bbsCd}',
                    target : '${inputData.target}',
                	searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                   	searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };

           anlQnaDataSet.on('load', function(e) {
 	    		$("#cnt_text").html('총 ' + anlQnaDataSet.getCount() + '건');
 	      	});

          getAnlQnaList();


       });//onReady 끝
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
		document.aform.bbsCd.value = bbsCd;
		document.aform.target.value = target;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.bbsId.value = record.get("bbsId");
		document.aform.target.value = target;
	}
	
	nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlQnaRgst.do'/>")
}

</script>

    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="bbsId" name="bbsId" value=""/>
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="target" name="target" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value=""/>

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
   				
				<c:if test="${inputData.bbsCd == '10'}"><div id="anlBbsGrid01"></div></c:if>
				<c:if test="${inputData.bbsCd == '11'}"><div id="anlBbsGrid02"></div></c:if>
				<c:if test="${inputData.bbsCd == '12'}"><div id="anlBbsGrid03"></div></c:if>
				<c:if test="${inputData.bbsCd == '13'}"><div id="anlBbsGrid04"></div></c:if>

<!--    			</div>//sub-content -->
<!--    		</div>//contents -->
		</form>
    </body>
</html>