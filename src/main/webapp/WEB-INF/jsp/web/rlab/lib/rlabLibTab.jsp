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
var roleIdIndex = roleId.indexOf("WORK_IRI_T17");
var bbsId = "${inputData.bbsId}";
var bbsCd = "${inputData.bbsCd}";
var target = "${inputData.target}";
var gb = "";

	Rui.onReady(function() {
       /*******************
        * 변수 및 객체 선언
        *******************/
		 if( bbsCd == "01" ){
			 gb = "AAAAA";
	     }else if( bbsCd == "02" ){
	    	 gb = "RLAB_DB_CD";
	     }else if( bbsCd == "03" ){
	    	 gb = "RLAB_REFERENCE_CD";
	     }else if( bbsCd == "04" ){
	    	 gb = "RLAB_IP_CD";
	     }
		
        
        /* 검색 코드 */
           var searchCd = new Rui.ui.form.LCombo({
        	   applyTo: 'searchCd',
               name: 'searchCd',
               defaultValue: '<c:out value="${inputData.searchCd}"/>',
               useEmptyText: false,
//                emptyText: '(선택)',
               width: 150,
               items: [
            	   { value: 'bbsTitlSbcCode',    text: '제목 + 내용'},
                   { value: 'rgstNmCode',     text: '등록자'}
               ]
           });

           /* 검색 내용 */
           var searchNm = new Rui.ui.form.LTextBox({
        	   applyTo: 'searchNm',
        	   defaultValue: '<c:out value="${inputData.searchNm}"/>',
               width: 390
           });

           searchNm.on('keypress', function(e) {
     			if(e.keyCode == 13) {
	     			getAnlLibList();
     			}
             });
           
           /* 구분 검색 코드 */
           var gbSearchCd = new Rui.ui.form.LCombo({
        	   applyTo: 'gbSearchCd',
               name: 'gbSearchCd',
               defaultValue: '<c:out value="${inputData.gbSearchCd}"/>',
               useEmptyText: true,
               width: 150,
               url: '<c:url value="/common/code/retrieveCodeListForCache.do"/>'+'?comCd='+gb,
               displayField: 'COM_DTL_NM',
               valueField: 'COM_DTL_CD'
           });
           
           gbSearchCd.getDataSet().on('load', function(e) {
        	   
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
                    url: '<c:url value="/rlab/lib/updateRlabLibRtrvCnt.do"/>',
                    params :{
                    	bbsId : bbsId
                    }
                });

                nwinsActSubmit(document.aform, "<c:url value='/rlab/lib/rlabLibInfo.do'/>");
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
	        		   //return false;
	        	   }
	        	   var record = anlLibDataSet.getAt(anlLibDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");
	        	   document.aform.target.value = target ;

	        	   anlLibDataSet.load({
	                    url: '<c:url value="/rlab/lib/updateRlabLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/rlab/lib/rlabLibInfo.do'/>");

                }

           });

           anlLibGrid01.render("anlLibGrid01");

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
	                    url: '<c:url value="/rlab/lib/updateRlabLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/rlab/lib/rlabLibInfo.do'/>");
                }

           });

           anlLibGrid02.render("anlLibGrid02");

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
	                    url: '<c:url value="/rlab/lib/updateRlabLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/rlab/lib/rlabLibInfo.do'/>");
                }

           });

           anlLibGrid03.render("anlLibGrid03");

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
	                    url: '<c:url value="/rlab/lib/updateRlabLibRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/rlab/lib/rlabLibInfo.do'/>");
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
                   url: '<c:url value="/rlab/lib/getRlabLibList.do"/>',
                   params :{
                	   bbsCd : '${inputData.bbsCd}',
                	   target : '${inputData.target}',
                	   searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                	   gbSearchCd : escape(encodeURIComponent(document.aform.gbSearchCd.value)),
                	   searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };

           /* 조회, 검색 bbsCd04*/
           getAnlLibList04 = function() {
        	   anlLibDataSet.load({
                   url: '<c:url value="/rlab/lib/getRlabLibList.do"/>',
                   params :{
                	   bbsCd : '${inputData.bbsCd}',
                	   anlTlcgClCd : escape(encodeURIComponent(document.aform.anlTlcgClCd.value)),
                	   searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                	   searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };

           //getAnlLibList();

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
		document.aform.target.value = target;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.bbsId.value = record.get("bbsId");
		document.aform.target.value = target;
	}

	nwinsActSubmit(document.aform, "<c:url value='/rlab/lib/rlabLibRgst.do'/>")

}

init = function() {
	var searchNm='${inputData.searchNm}';
	   anlLibDataSet.load({
         url: '<c:url value="/rlab/lib/getRlabLibList.do"/>',
         params :{
         	bbsCd : '${inputData.bbsCd}',
      	    target : '${inputData.target}',
         	searchNm : escape(encodeURIComponent(searchNm)),
         	searchCd : '${inputData.searchCd}',
         	gbSearchCd : '${inputData.gbSearchCd}'
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
   							<td colspan="3">
   								<div id="searchCd"></div>
   								<div id="gbSearchCd"></div>
   								<input type="text" id="searchNm" value="">
   							</td>
   							<td class="t_center">
   								<a style="cursor: pointer;" onclick="getAnlLibList();" class="btnL">검색</a>
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