<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: ProductListList.jsp
 * @desc    : 연구산출물 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.14  			최초생성
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

<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">
var prdtListDataSet;	// 프로젝트 데이터셋
var lvAttcFilId;
var dm;         // 데이터셋매니저
var prdtListGrid;       // 그리드
var affrClGroup = '${inputData.affrClId}';

	Rui.onReady(function() {
           /*******************
            * 변수 및 객체 선언
            *******************/
			/* 제목 */
           var titlNm = new Rui.ui.form.LTextBox({
                applyTo: 'titlNm',
                width: 400
           });

           titlNm.on('keypress', function(e) {
				if(e.keyCode == 13) {
					getPrdtList();
				}
	        });

			/* 등록자 */
           var rgstNm = new Rui.ui.form.LTextBox({
               applyTo: 'rgstNm',
               width: 200
           });

           rgstNm.on('keypress', function(e) {
				if(e.keyCode == 13) {
					getPrdtList();
				}
	        });

       	/* [버튼] 신규 등록 */
       	var rgstBtn = new Rui.ui.LButton('rgstBtn');
       	rgstBtn.on('click', function() {
       		fncPrdtListRgstPage('');
       	});

       	/* [버튼] EXCEL다운로드 */
       	var excelBtn = new Rui.ui.LButton('excelBtn');
       	excelBtn.on('click', function() {
       		fncExcelDown();
       	});

    	/** dataSet **/
    	prdtListDataSet = new Rui.data.LJsonDataSet({
    	    id: 'prdtListDataSet',
    	    remainRemoved: true,
    	    lazyLoad: true,
    	    //defaultFailureHandler:false,
    	    fields: [
				      { id: 'prdtId' }             /*산출물ID*/
					, { id: 'affrClId' }           /*업무분류ID*/
					, { id: 'affrClNm' }           /*업무분류이름*/
					, { id: 'affrClGroup' }        /*게시판분류이름*/
					, { id: 'titlNm' }             /*제목*/
					, { id: 'sbcNm' }              /*내용*/
					, { id: 'rtrvCnt' }            /*조회수*/
					, { id: 'keywordNm' }          /*키워드*/
					, { id: 'attcFilId' }          /*첨부파일*/
					, { id: 'rgstId' }             /*등록자ID*/
					, { id: 'rgstNm' }             /*등록자*/
					, { id: 'rgstOpsId' }          /*등록자부서ID*/
					, { id: 'delYn' }              /*삭제여부*/
					, { id: 'frstRgstDt' }         /*등록일*/
    		]
    	});


          var columnModel = new Rui.ui.grid.LColumnModel({
              columns: [
                    { field: 'affrClNm',    label: '업무분류', sortable: false,	align:'center',	width: 205 }
                  , { field: 'titlNm',	    label: '제목',	   sortable: false,	align:'left',	width: 635 }
                  , { field: 'rgstNm',	    label: '등록자',   sortable: false,	align:'center',	width: 100 }
			      , { field: 'frstRgstDt',	label: '등록일',   sortable: false, align:'center',	width: 100 }
		  	      , { field: 'rtrvCnt',     label: '조회',     sortable: false, align:'center', width: 60 }
		  	      , { id: 'attachDownBtn',  label: '첨부',                                      width: 65
		  	      	  ,renderer: function(val, p, record, row, i){
		  	    		  var recordFilId = nullToString(record.data.attcFilId);
		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'knldPolicy2', '*' ,'R')";
		  	    		  return Rui.isUndefined(record.get('attcFilId')) ? '' : '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
                      }}
              ]
          });

          prdtListGrid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: prdtListDataSet,
              width: 600,
              height: 400,
              autoToEdit: false,
              autoWidth: true
          });

          prdtListGrid.on('cellClick', function(e) {

	           if(e.colId == "titlNm") {
	        	   var record = prdtListDataSet.getAt(prdtListDataSet.getRow());
	        	   document.aform.prdtId.value = record.get("prdtId");
	        	   /* 조회수 증가 */
	        	   prdtListDataSet.load({
	                    url: '<c:url value="/knld/rsst/updateProductListRtrvCnt.do"/>',
	                    params :{
	                    	prdtId : record.get("prdtId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/knld/rsst/productListInfo.do?affrClId='/>"+affrClGroup);
                }

           });

          prdtListGrid.render('defaultGrid');

           /*첨부파일*/
           /* [기능] 첨부파일 조회*/
             var attachFileDataSet = new Rui.data.LJsonDataSet({
                 id: 'attachFileDataSet',
                 remainRemoved: true,
                 lazyLoad: true,
                 fields: [
                       { id: 'attcFilId'}
                     , { id: 'seq' }
                     , { id: 'filNm' }
                     , { id: 'filSize' }
                 ]
             });

             attachFileDataSet.on('load', function(e) {
                 getAttachFileInfoList();
             });

             getAttachFileList = function(attcFilId) {
                 attachFileDataSet.load({
                     url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                     params :{
                     	attcFilId : attcFilId
                     }
                 });
             };

             getAttachFileInfoList = function() {
                 var attachFileInfoList = [];

                 for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                     attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
                 }

                 setAttachFileInfo(attachFileInfoList);
             };

             /* [기능] 첨부파일 등록 팝업*/
             getAttachFileId = function() {
                 if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

                 return lvAttcFilId;
             };

             setAttachFileInfo = function(attachFileList) {
                 $('#attchFileView').html('');

                 for(var i = 0; i < attachFileList.length; i++) {
                     $('#attchFileView').append($('<a/>', {
                         href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                         text: attachFileList[i].data.filNm
                     })).append('<br/>');
                 }

                 if(Rui.isEmpty(lvAttcFilId)) {
                 	lvAttcFilId =  attachFileList[0].data.attcFilId;
                 	prdtListDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                 }

             };

             /*첨부파일 다운로드*/
             downloadAttachFile = function(attcFilId, seq) {
                 downloadForm.action = '<c:url value="/system/attach/downloadAttachFile.do"/>';
                 $('#attcFilId').val(attcFilId);
                 $('#seq').val(seq);
                 downloadForm.submit();
             };
			//첨부파일 끝

           /* 조회, 검색 */
           getPrdtList = function() {
        	   prdtListDataSet.load({
                   url: '<c:url value="/knld/rsst/getProductList.do"/>',
                   params :{
                	   affrClId : document.aform.affrClId.value,
                	   titlNm : escape(encodeURIComponent(document.aform.titlNm.value)),
                	   rgstNm : escape(encodeURIComponent(document.aform.rgstNm.value))
                   }
               });
           };

           prdtListDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + prdtListDataSet.getCount() + '건');
  	    		// 목록 페이징
  		    	paging(prdtListDataSet,"defaultGrid");
  	      	});

           getPrdtList();

           /* 게시판 이름 */
           getTitlName = function() {
        	   if(affrClGroup == "molecule"){
        		   $('#tTitlNm').text("고분자재료 Lab");
        	   }else if(affrClGroup == "adhesion"){
        		   $('#tTitlNm').text("점착기술 Lab");
        	   }else if(affrClGroup == "inorganic"){
        		   $('#tTitlNm').text("무기소재 Lab");
        	   }else if(affrClGroup == "coating"){
        		   $('#tTitlNm').text("코팅기술 Lab");
        	   }else if(affrClGroup == "common"){
        		   $('#tTitlNm').text("연구소 공통");
        	   }else if(affrClGroup == "industry"){
        		   $('#tTitlNm').text("LG화학 산업재연구소");
        	   }else if(affrClGroup == "techCenter"){
        		   $('#tTitlNm').text("LG화학 산업재테크센터");
        	   }else if(affrClGroup == "pms"){
        		   $('#tTitlNm').text("LG하우시스 연구소 PMS");
        	   }
           }
           getTitlName();
	});//onReady 끝

</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncProductListRgstPage (연구산출물 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncPrdtListRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.prdtId.value = record.get("prdtId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/knld/rsst/productListRgst.do?affrClId='/>"+affrClGroup)

}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

	// 엑셀 다운로드시 전체 다운로드를 위해 추가
	prdtListDataSet.clearFilter();

    if( prdtListDataSet.getCount() > 0){
    	prdtListGrid.saveExcel(toUTF8('공지사항 목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	alert('조회된 데이타가 없습니다.!!');
    }
	// 목록 페이징
    paging(prdtListDataSet,"defaultGrid");
}
</script>

    </head>
    <body>
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="prdtId" name="prdtId" value=""/>
		<input type="hidden" id="affrClId" value="<c:out value='${inputData.affrClId}'/>"/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />

   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
	        	</a>
   				<h2 id="tTitlNm"></h2>
   			</div>
			<div class="sub-content">
				<div class="search">
					<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style="width:400px;"/>
		   						<col style="width:110px;"/>
		   						<col style="width:200px;"/>
		   						<col style=";"/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">제목</th>
		   							<td>
		   								<input type="text" id="titlNm" value="">
		   							</td>
		   						    <th align="right">등록자</th>
		    						<td>
		   								<input type="text" id="rgstNm" value="">
		    						</td>
		   							<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getPrdtList();" class="btnL">검색</a>
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
   						<button type="button" id="excelBtn" name="excelBtn">Excel</button>
   					</div>
   				</div>

   				<div id="defaultGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>