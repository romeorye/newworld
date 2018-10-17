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
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<title><%=documentTitle%></title>

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css" />

<script type="text/javascript">
var anlBbsDataSet;	// 프로젝트 데이터셋
var anlBbsGrid;       // 그리드
var roleId = '${inputData._roleId}';
var bbsId = "${inputData.bbsId}";
var bbsCd = "${inputData.bbsCd}";
var target = "${inputData.target}";
var roleIdIndex = roleId.indexOf("WORK_IRI_T06");

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

       	   /*검색 분류 코드*/
       	   if(bbsCd == '04'){
	           var anlTlcgClCd = new Rui.ui.form.LCombo({
	               applyTo: 'anlTlcgClCd',
	               name: 'anlTlcgClCd',
	               useEmptyText: true,
	               emptyText: '전체',
	               defaultValue: '',
	               emptyValue: '',
	               url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ANL_TLCG_CL_CD"/>',
	               displayField: 'COM_DTL_NM',
	               valueField: 'COM_DTL_CD'
	           });
       	   }

           /* 검색 내용 */
           var searchNm = new Rui.ui.form.LTextBox({
        	   applyTo: 'searchNm',
               width: 390
           });

           searchNm.on('keypress', function(e) {
     			if(e.keyCode == 13) {
     				if(bbsCd == '04'){
     					getAnlBbsList04();
     				}else {
	     				getAnlBbsList();
     				}
     			}
             });

       	   /* [버튼] 신규 등록 */
       	   var rgstBtn = new Rui.ui.LButton('rgstBtn');

       	   rgstBtn.on('click', function() {
       		   fncAnlBbsRgstPage('');
       	   });

    	   /** dataSet **/
    	   anlBbsDataSet = new Rui.data.LJsonDataSet({
    	       id: 'anlBbsDataSet',
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

           //분석Main에서 바로 상세화면으로
           if(bbsId != ''){
        	   document.aform.bbsId.value = bbsId ;
        	   document.aform.bbsCd.value = bbsCd ;
        	   document.aform.target.value = target ;

        	   anlBbsDataSet.load({
                    url: '<c:url value="/anl/bbs/updateAnlBbsRtrvCnt.do"/>',
                    params :{
                    	bbsId : bbsId
                    }
                });

                nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlBbsInfo.do'/>");
                return;
           }

		   //표준실험절차서
           var columnModel01 = new Rui.ui.grid.LColumnModel({
        	   columns: [
        		     { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 250 }
                  , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 560 }
                  , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 160 }
                  , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 153 }
                  , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 150}
               ]
           });

           anlBbsGrid01 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel01,
               dataSet: anlBbsDataSet,
               width: 1150,
               height: 400,
               autoWidth: true
           });

           anlBbsGrid01.on('cellClick', function(e) {
	           if(e.colId == "bbsTitl") {

	        	   var record = anlBbsDataSet.getAt(anlBbsDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlBbsDataSet.load({
	                    url: '<c:url value="/anl/bbs/updateAnlBbsRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlBbsInfo.do'/>");

                }

           });

           anlBbsGrid01.render("anlBbsGrid01");

           //분석사례
           var columnModel02 = new Rui.ui.grid.LColumnModel({
        	   columns: [
       		    { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 300 }
                , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 470 }
                , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 175 }
                , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 175 }
                , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}
               ]
           });

           anlBbsGrid02 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel02,
               dataSet: anlBbsDataSet,
               width: 1150,
               height: 400,
               autoToEdit: false,
               autoWidth: true
           });

           anlBbsGrid02.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = anlBbsDataSet.getAt(anlBbsDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlBbsDataSet.load({
	                    url: '<c:url value="/anl/bbs/updateAnlBbsRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlBbsInfo.do'/>");
                }

           });

           anlBbsGrid02.render("anlBbsGrid02");

           //기기메뉴얼
           var columnModel03 = new Rui.ui.grid.LColumnModel({
        	   columns: [
        		    { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 300 }
                   , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 470 }
                   , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 175 }
                   , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 175 }
                   , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}
               ]
           });

           anlBbsGrid03 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel03,
               dataSet: anlBbsDataSet,
               width: 1150,
               height: 400,
               autoToEdit: false,
               autoWidth: true
           });


           anlBbsGrid03.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = anlBbsDataSet.getAt(anlBbsDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlBbsDataSet.load({
	                    url: '<c:url value="/anl/bbs/updateAnlBbsRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlBbsInfo.do'/>");
                }

           });

           anlBbsGrid03.render("anlBbsGrid03");

           //분석기술정보
           var columnModel04 = new Rui.ui.grid.LColumnModel({
        	   columns: [
        		    { field: 'bbsNm',		label: '구분',    sortable: false,	align:'left',	width: 300 }
                   , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 470 }
                   , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 175 }
                   , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 175 }
                   , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 170}
               ]
           });

           anlBbsGrid04 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel04,
               dataSet: anlBbsDataSet,
               width: 1150,
               height: 400,
               autoToEdit: false,
               autoWidth: true
           });

           anlBbsGrid04.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = anlBbsDataSet.getAt(anlBbsDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlBbsDataSet.load({
	                    url: '<c:url value="/anl/bbs/updateAnlBbsRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlBbsInfo.do'/>");
                }

           });

           anlBbsGrid04.render("anlBbsGrid04");

           anlBbsDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + anlBbsDataSet.getCount() + '건');
  	    		
   	            if(roleIdIndex != -1) {
 	              	chkUserRgst(true);
 	            } else {
 	              	chkUserRgst(false);
 	            }
   	            
	  	    	// 목록 페이징
	  	    	if(bbsCd=='06'){
	  	    		paging(anlBbsDataSet,"anlBbsGrid01");
	  	    	}else if(bbsCd=='07'){
	  	    		paging(anlBbsDataSet,"anlBbsGrid02");
	  	    	}else if(bbsCd=='08'){
	  	    		paging(anlBbsDataSet,"anlBbsGrid03");
	  	    	}else if(bbsCd=='09'){
	  	    		paging(anlBbsDataSet,"anlBbsGrid04");
	  	    	}
  	      	});

           /* 조회, 검색 */
           getAnlBbsList = function() {
        	   anlBbsDataSet.load({
                   url: '<c:url value="/anl/bbs/getAnlBbsList.do"/>',
                   params :{
                	   bbsCd : '${inputData.bbsCd}',
                	   target : '${inputData.target}',
                	   searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                	   searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };
           
		    // roleId가 분석담당자이면 등록자와 사용자가 달라도 수정/삭제 가능
		    //이외의 사용자는 상세보기만 가능
		    //등록자와 사용자가 다를때 수정/삭제버튼 가리기
            chkUserRgst = function(display){
		    	 if(display) {
		    		 rgstBtn.show();
	 	         }else {
	 	        	 rgstBtn.hide();
                }
		    }

           getAnlBbsList();

           //chkUserRgst(false);


       });//onReady 끝
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncAnlBbsRgstPage (분석자료실 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncAnlBbsRgstPage(record) {
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

	nwinsActSubmit(document.aform, "<c:url value='/anl/bbs/anlBbsRgst.do'/>")

}

</script>

    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="bbsId" name="bbsId" value=""/>
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="target" name="target" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value=""/>

<!--    		<div class="contents"> style="padding-top:10px" -->
<!--    			<div class="sub-content"> -->
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
   							<c:if test="${inputData.bbsCd == '04'}">
   							<th  align="right">분류</th>
   							<td>
   								<div id="anlTlcgClCd"></div>
   							</td>
   							</c:if>
   							<td colspan="2">
   								<div id="searchCd"></div>
   								<input type="text" id="searchNm" value="">
   							</td>
   							<td class="t_center">
   								<c:choose>
  									<c:when test="${inputData.bbsCd == '04'}">
   									<a style="cursor: pointer;" onclick="getAnlBbsList04();" class="btnL">검색</a>
   									</c:when>
   									<c:otherwise>
   									<a style="cursor: pointer;" onclick="getAnlBbsList();" class="btnL">검색</a>
   									</c:otherwise>
   								</c:choose>
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

				<c:if test="${inputData.bbsCd == '06'}"><div id="anlBbsGrid01"></div></c:if>
				<c:if test="${inputData.bbsCd == '07'}"><div id="anlBbsGrid02"></div></c:if>
				<c:if test="${inputData.bbsCd == '08'}"><div id="anlBbsGrid03"></div></c:if>
				<c:if test="${inputData.bbsCd == '09'}"><div id="anlBbsGrid04"></div></c:if>

<!--    			</div>//sub-content -->
<!--    		</div>//contents -->
		</form>
    </body>
</html>