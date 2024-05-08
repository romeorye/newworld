<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: AnlLibList.jsp
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
var spaceLibDataSet;	// 프로젝트 데이터셋
var spaceLibGrid;       // 그리드
var roleId = '${inputData._roleId}';
var roleIdIndex = roleId.indexOf("WORK_IRI_T18");
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
	     			getSpaceLibList();
     			}
             });

       	   /* [버튼] 신규 등록 */
       	   var rgstBtn = new Rui.ui.LButton('rgstBtn');

       	   rgstBtn.on('click', function() {
       		   fncSpaceLibRgstPage('');
       	   });

           //분석담당자만 등록 버튼 보이기
           chkUserRgst = function(display){
        	   if(display) {
        		   rgstBtn.show();
	   	       }else {
	   	           rgstBtn.hide();
	   	       }
           };

    	   /** dataSet **/
    	   spaceLibDataSet = new Rui.data.LJsonDataSet({
    	       id: 'spaceLibDataSet',
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
		   			, { id: 'frstRgstDt'}   /*등록일*/
		   			, { id: 'delYn' }       /*삭제여부*/
    	   	  ]
    	   });

           //분석Main에서 바로 상세화면으로
           if(bbsId != ''){
        	   document.aform.bbsId.value = bbsId ;
        	   document.aform.bbsCd.value = bbsCd ;
        	   document.aform.target.value = target ;

        	   spaceLibDataSet.load({
                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
                    params :{
                    	bbsId : bbsId
                    }
                });

                nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");
                return;
           }

		   //표준실험절차서
           var columnModel01 = new Rui.ui.grid.LColumnModel({
        	   columns: [
          		    new Rui.ui.grid.LNumberColumn()
          		    , { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                    , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 530 }
                    , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}

               ]
           });

           spaceLibGrid01 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel01,
               dataSet: spaceLibDataSet,
               width: 600,
               height: 525,
               autoToEdit: false,
               autoWidth: true
           });

           spaceLibGrid01.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   if(roleIdIndex == -1){
	        		  // return false;
	        	   }
	        	   var record = spaceLibDataSet.getAt(spaceLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   spaceLibDataSet.load({
	                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");

                }

           });

           spaceLibGrid01.render("spaceLibGrid01");

           //분석사례
           var columnModel02 = new Rui.ui.grid.LColumnModel({
        	   columns: [
          		    new Rui.ui.grid.LNumberColumn()
          		    , { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                    , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 530 }
                    , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}

               ]
           });

           spaceLibGrid02 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel02,
               dataSet: spaceLibDataSet,
               width: 600,
               height: 525,
               autoToEdit: false,
               autoWidth: true
           });

           spaceLibGrid02.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = spaceLibDataSet.getAt(spaceLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   spaceLibDataSet.load({
	                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");
                }

           });

           spaceLibGrid02.render("spaceLibGrid02");

           //기기메뉴얼
           var columnModel03 = new Rui.ui.grid.LColumnModel({
        	   columns: [
          		    new Rui.ui.grid.LNumberColumn()
          		    , { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                    , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 530 }
                    , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}

               ]
           });

           spaceLibGrid03 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel03,
               dataSet: spaceLibDataSet,
               width: 600,
               height: 525,
               autoToEdit: false,
               autoWidth: true
           });


           spaceLibGrid03.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = spaceLibDataSet.getAt(spaceLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   spaceLibDataSet.load({
	                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");
                }

           });

           spaceLibGrid03.render("spaceLibGrid03");

           //분석기술정보
           var columnModel04 = new Rui.ui.grid.LColumnModel({
        	   columns: [
          		    new Rui.ui.grid.LNumberColumn()
          		    , { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                    , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 530 }
                    , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}
               ]
           });

           spaceLibGrid04 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel04,
               dataSet: spaceLibDataSet,
               width: 600,
               height: 525,
               autoToEdit: false,
               autoWidth: true
           });

           spaceLibGrid04.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = spaceLibDataSet.getAt(spaceLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   spaceLibDataSet.load({
	                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");
                }

           });

           spaceLibGrid04.render("spaceLibGrid04");

           //분석기술정보
           var columnModel05 = new Rui.ui.grid.LColumnModel({
        	   columns: [
          		    new Rui.ui.grid.LNumberColumn()
          		    , { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                    , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 530 }
                    , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}
               ]
           });

           spaceLibGrid05 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel05,
               dataSet: spaceLibDataSet,
               width: 600,
               height: 525,
               autoToEdit: false,
               autoWidth: true
           });

           spaceLibGrid05.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = spaceLibDataSet.getAt(spaceLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   spaceLibDataSet.load({
	                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");
                }

           });

           spaceLibGrid05.render("spaceLibGrid05");

           //분석기술정보
           var columnModel06 = new Rui.ui.grid.LColumnModel({
        	   columns: [
          		    new Rui.ui.grid.LNumberColumn()
          		    , { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                    , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 530 }
                    , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}
               ]
           });

           spaceLibGrid06 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel06,
               dataSet: spaceLibDataSet,
               width: 600,
               height: 525,
               autoToEdit: false,
               autoWidth: true
           });

           spaceLibGrid06.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = spaceLibDataSet.getAt(spaceLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   spaceLibDataSet.load({
	                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");
                }

           });

           spaceLibGrid06.render("spaceLibGrid06");

           //분석기술정보
           var columnModel07 = new Rui.ui.grid.LColumnModel({
        	   columns: [
          		    new Rui.ui.grid.LNumberColumn()
          		    , { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                    , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 530 }
                    , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}
               ]
           });

           spaceLibGrid07 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel07,
               dataSet: spaceLibDataSet,
               width: 600,
               height: 525,
               autoToEdit: false,
               autoWidth: true
           });

           spaceLibGrid07.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = spaceLibDataSet.getAt(spaceLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   spaceLibDataSet.load({
	                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");
                }

           });

           spaceLibGrid07.render("spaceLibGrid07");

           //분석기술정보
           var columnModel08 = new Rui.ui.grid.LColumnModel({
        	   columns: [
          		    new Rui.ui.grid.LNumberColumn()
          		    , { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                    , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 530 }
                    , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 170 }
                    , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}
               ]
           });

           spaceLibGrid08 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel08,
               dataSet: spaceLibDataSet,
               width: 600,
               height: 525,
               autoToEdit: false,
               autoWidth: true
           });

           spaceLibGrid08.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = spaceLibDataSet.getAt(spaceLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   spaceLibDataSet.load({
	                    url: '<c:url value="/space/lib/updateSpaceLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibInfo.do'/>");
                }

           });

           spaceLibGrid08.render("spaceLibGrid08");

           spaceLibDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + spaceLibDataSet.getCount() + '건');

  	    		if(roleIdIndex != -1) {
  	    			chkUserRgst(true);
                }
  	      	});

           /* 조회, 검색 */
           getSpaceLibList = function() {
        	   spaceLibDataSet.load({
                   url: '<c:url value="/space/lib/getSpaceLibList.do"/>',
                   params :{
                	   bbsCd : '${inputData.bbsCd}',
                	   target : '${inputData.target}',
                	   searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                	   searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };

           //getSpaceLibList();

           chkUserRgst(false);


       });//onReady 끝
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncSpaceLibRgstPage (분석자료실 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncSpaceLibRgstPage(record) {
	var bbsCd = "${inputData.bbsCd}";

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

	nwinsActSubmit(document.aform, "<c:url value='/space/lib/spaceLibRgst.do'/>")

}

init = function() {
	   var searchNm='${inputData.searchNm}';
	   spaceLibDataSet.load({
         url: '<c:url value="/space/lib/getSpaceLibList.do"/>',
         params :{
        	 searchNm : escape(encodeURIComponent(searchNm)),
         	bbsCd : '${inputData.bbsCd}',
     	   target : '${inputData.target}',
     	  searchCd : '${inputData.searchCd}'
         }
     });
 }


</script>

    </head>
    <body onload="init();">
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="bbsId" name="bbsId" value=""/>
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="target" name="target" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value=""/>

				<div class="search">
				<div class="search-content">
   				<table>
   					<colgroup>
   						<col style="width:10%;"/>
   						<col style="width:30%;"/>
   						<col style="width:15%;"/>
   						<col style="width:"/>
   						<col style="width:10%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<td colspan="2">
   								<div id="searchCd"></div>
   								<input type="text" id="searchNm" value="">
   							</td>
   							<td class="t_center">
   								<a style="cursor: pointer;" onclick="getSpaceLibList();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" id="rgstBtn" name="rgstBtn" >등록</button>
   					</div>
   				</div>

				<c:if test="${inputData.bbsCd == '01'}"><div id="spaceLibGrid01"></div></c:if>
				<c:if test="${inputData.bbsCd == '02'}"><div id="spaceLibGrid02"></div></c:if>
				<c:if test="${inputData.bbsCd == '03'}"><div id="spaceLibGrid03"></div></c:if>
				<c:if test="${inputData.bbsCd == '04'}"><div id="spaceLibGrid04"></div></c:if>
				<c:if test="${inputData.bbsCd == '05'}"><div id="spaceLibGrid05"></div></c:if>
				<c:if test="${inputData.bbsCd == '06'}"><div id="spaceLibGrid06"></div></c:if>
				<c:if test="${inputData.bbsCd == '07'}"><div id="spaceLibGrid07"></div></c:if>
				<c:if test="${inputData.bbsCd == '08'}"><div id="spaceLibGrid08"></div></c:if>

		</form>
    </body>
</html>