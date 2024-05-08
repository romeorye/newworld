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
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<title><%=documentTitle%></title>

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css" />

<script type="text/javascript">
var anlLibDataSet;	// 프로젝트 데이터셋
var anlLibGrid;       // 그리드
var roleId = '${inputData._roleId}';
var roleIdIndex = roleId.indexOf("WORK_IRI_T06");
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
               defaultValue: '<c:out value="${inputData.searchCd}"/>',
               useEmptyText: false,
//                emptyText: '선택',
               width: 150,
               items: [
            	   { value: 'bbsTitlCode',    text: '제목'},
                   { value: 'bbsSbcCode',     text: '내용'},
                   { value: 'rgstNmCode',     text: '작성자'}
               ]
           });

       	   /*검색 분류 코드*/
       	   if(bbsCd == '04'){
	           var anlTlcgClCd = new Rui.ui.form.LCombo({
	               applyTo: 'anlTlcgClCd',
	               name: 'anlTlcgClCd',
	               defaultValue: '<c:out value="${inputData.anlTlcgClCd}"/>',
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
        	   defaultValue: '<c:out value="${inputData.searchNm}"/>',
               width: 390
           });

           searchNm.on('keypress', function(e) {
     			if(e.keyCode == 13) {
     				if(bbsCd == '04'){
     					getAnlLibList04();
     				}else {
	     				getAnlLibList();
     				}
     			}
             });

       	   /* [버튼] 신규 등록 */
       	   var rgstBtn = new Rui.ui.LButton('rgstBtn');

       	   rgstBtn.on('click', function() {
       		   fncAnlLibRgstPage('');
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
    	   anlLibDataSet = new Rui.data.LJsonDataSet({
    	       id: 'anlLibDataSet',
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
		   			, { id: 'sopNo' }       /*SOP번호*/
		   			, { id: 'anlTlcgClCd' } /*분석기술정보분류코드*/
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

        	   anlLibDataSet.load({
                    url: '<c:url value="/anl/lib/updateAnlLibRtrvCnt.do"/>',
                    params :{
                    	bbsId : bbsId
                    }
                });

                nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlLibInfo.do'/>");
                return;
           }

		   //표준실험절차서
           var columnModel01 = new Rui.ui.grid.LColumnModel({
        	   columns: [
                    { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 730 }
			      , { field: 'sopNo',		label: 'SOP No.', sortable: false, 	align:'center',	width: 355 }
                  , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 120 }
                  , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 120 }
               ]
           });

           anlLibGrid01 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel01,
               dataSet: anlLibDataSet,
               width: 600,
               height: 400,
               autoToEdit: false,
               autoWidth: true
           });

           anlLibGrid01.on('cellClick', function(e) {
	           if(e.colId == "bbsTitl") {
	        	   if(roleIdIndex == -1){
	        		   return false;
	        	   }
	        	   var record = anlLibDataSet.getAt(anlLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlLibDataSet.load({
	                    url: '<c:url value="/anl/lib/updateAnlLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlLibInfo.do'/>");

                }

           });

           anlLibGrid01.render("anlLibGrid01");

           //분석사례
           var columnModel02 = new Rui.ui.grid.LColumnModel({
        	   columns: [
                    { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 730 }
			      , { field: 'docNo',		label: '문서번호',sortable: false, 	align:'center',	width: 355 }
                  , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 120 }
                  , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 120 }
               ]
           });

           anlLibGrid02 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel02,
               dataSet: anlLibDataSet,
               width: 600,
               height: 400,
               autoToEdit: false,
               autoWidth: true
           });

           anlLibGrid02.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = anlLibDataSet.getAt(anlLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlLibDataSet.load({
	                    url: '<c:url value="/anl/lib/updateAnlLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlLibInfo.do'/>");
                }

           });

           anlLibGrid02.render("anlLibGrid02");

           //기기메뉴얼
           var columnModel03 = new Rui.ui.grid.LColumnModel({
        	   columns: [
                    { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 730 }
			      , { field: 'docNo',		label: '문서번호',sortable: false, 	align:'center',	width: 355 }
                  , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 120 }
                  , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 120 }
               ]
           });

           anlLibGrid03 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel03,
               dataSet: anlLibDataSet,
               width: 600,
               height: 400,
               autoToEdit: false,
               autoWidth: true
           });


           anlLibGrid03.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = anlLibDataSet.getAt(anlLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlLibDataSet.load({
	                    url: '<c:url value="/anl/lib/updateAnlLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlLibInfo.do'/>");
                }

           });

           anlLibGrid03.render("anlLibGrid03");

           //분석기술정보
           var columnModel04 = new Rui.ui.grid.LColumnModel({
        	   columns: [
                    { field: 'anlTlcgClNm', label: '분류',    sortable: false,	align:'center',	width: 185 }
                  , { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 800 }
                  , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 120 }
                  , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 120 }
                  , { field: 'rtrvCt',	    label: '조회',    sortable: false,	align:'center',	width: 100 }
               ]
           });

           anlLibGrid04 = new Rui.ui.grid.LGridPanel({
        	   columnModel: columnModel04,
               dataSet: anlLibDataSet,
               width: 600,
               height: 400,
               autoToEdit: false,
               autoWidth: true
           });

           anlLibGrid04.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = anlLibDataSet.getAt(anlLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlLibDataSet.load({
	                    url: '<c:url value="/anl/lib/updateAnlLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlLibInfo.do'/>");
                }

           });

           anlLibGrid04.render("anlLibGrid04");

           anlLibDataSet.on('load', function(e) {
        		// 엑셀 다운로드시 전체 다운로드를 위해 추가
        	   anlLibDataSet.clearFilter();
  	    		$("#cnt_text").html('총 ' + anlLibDataSet.getCount() + '건');

  	    		if(roleIdIndex != -1) {
  	    			chkUserRgst(true);
                }
  	    	// 목록 페이징
  	    		if("${inputData.bbsCd}"=="01"){
	  	    		paging(anlLibDataSet,"anlLibGrid01");
  	    		}else if("${inputData.bbsCd}"=="02"){
	  	    		paging(anlLibDataSet,"anlLibGrid02");
  	    		}else if("${inputData.bbsCd}"=="03"){
	  	    		paging(anlLibDataSet,"anlLibGrid03");
  	    		}else if("${inputData.bbsCd}"=="04"){
	  	    		paging(anlLibDataSet,"anlLibGrid04");
  	    		}
  	      	});

           /* 조회, 검색 */
           getAnlLibList = function() {
        	   anlLibDataSet.load({
                   url: '<c:url value="/anl/lib/getAnlLibList.do"/>',
                   params :{
                	   bbsCd : '${inputData.bbsCd}',
                	   //anlTlcgClCd : escape(encodeURIComponent(document.aform.anlTlcgClCd.value)),
                	   searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                	   searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };

           /* 조회, 검색 bbsCd04*/
           getAnlLibList04 = function() {
        	   anlLibDataSet.load({
                   url: '<c:url value="/anl/lib/getAnlLibList.do"/>',
                   params :{
                	   bbsCd : '${inputData.bbsCd}',
                	   anlTlcgClCd : escape(encodeURIComponent(document.aform.anlTlcgClCd.value)),
                	   searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                	   searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };


           if(bbsCd == '04'){
        	   getAnlLibList04();
           }else{
        	   getAnlLibList();
           }

           chkUserRgst(false);


       });//onReady 끝
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncAnlLibRgstPage (분석자료실 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncAnlLibRgstPage(record) {
	var bbsCd = "${inputData.bbsCd}";

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
		document.aform.bbsCd.value = bbsCd;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.bbsId.value = record.get("bbsId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlLibRgst.do'/>")

}

init = function() {
	var bbsCd = '${inputData.bbsCd}';
	var searchNm='${inputData.searchNm}';

	if(bbsCd == '04'){
		dataSet.load({
	         url: '<c:url value="/anl/lib/getAnlLibList.do"/>',
	         params :{
	        	 bbsCd : '${inputData.bbsCd}',
	        	 searchNm : escape(encodeURIComponent(searchNm)),
	         	 anlTlcgClCd : '${inputData.anlTlcgClCd}',
	         	 searchCd : '${inputData.searchCd}'
	         }
	     });

	}else{
		dataSet.load({
	         url: '<c:url value="/anl/lib/getAnlLibList.do"/>',
	         params :{
	        	 searchNm : escape(encodeURIComponent(searchNm)),
	        	 bbsCd : '${inputData.bbsCd}',
	         	 searchCd : '${inputData.searchCd}'
	         }
	     });
    }


 }

</script>

    </head>
    <body onload="init();">
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
		   									<a style="cursor: pointer;" onclick="getAnlLibList04();" class="btnL">검색</a>
		   									</c:when>
		   									<c:otherwise>
		   									<a style="cursor: pointer;" onclick="getAnlLibList();" class="btnL">검색</a>
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

				<c:if test="${inputData.bbsCd == '01'}"><div id="anlLibGrid01"></div></c:if>
				<c:if test="${inputData.bbsCd == '02'}"><div id="anlLibGrid02"></div></c:if>
				<c:if test="${inputData.bbsCd == '03'}"><div id="anlLibGrid03"></div></c:if>
				<c:if test="${inputData.bbsCd == '04'}"><div id="anlLibGrid04"></div></c:if>

<!--    			</div>//sub-content -->
<!--    		</div>//contents -->
		</form>
    </body>
</html>