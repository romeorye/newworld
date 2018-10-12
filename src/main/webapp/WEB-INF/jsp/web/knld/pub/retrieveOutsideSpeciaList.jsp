<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: OutsideSpecialistList.jsp
 * @desc    : 사외전문가 리스트
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
var outSpclDataSet;	// 프로젝트 데이터셋
var dm;         // 데이터셋매니저
var outSpclGrid;       // 그리드
var lvAttcFilId;

	Rui.onReady(function() {
           /*******************
            * 변수 및 객체 선언
            *******************/
			/* 기관명 */
           var instNm = new Rui.ui.form.LTextBox({
                applyTo: 'instNm',
                width: 400
           });

           instNm.on('keypress', function(e) {
         		if(e.keyCode == 13) {
         			getOutSpclList();
          		}
	        });

			/* 사외전문가명 */
           var spltNm = new Rui.ui.form.LTextBox({
               applyTo: 'spltNm',
               width: 200
           });

           spltNm.on('keypress', function(e) {
        		if(e.keyCode == 13) {
        			getOutSpclList();
         		}
	        });

			/* 대표분야 */
           var repnSphe = new Rui.ui.form.LTextBox({
               applyTo: 'repnSphe',
               width: 400
          });

           repnSphe.on('keypress', function(e) {
       			if(e.keyCode == 13) {
       				getOutSpclList();
        		}
	        });

       	/* [버튼] 신규 등록 */
       	var rgstBtn = new Rui.ui.LButton('rgstBtn');
       	rgstBtn.on('click', function() {
       		fncOutSpclRgstPage('');
       	});

       	/* [버튼] EXCEL다운로드 */
       	var excelBtn = new Rui.ui.LButton('excelBtn');
       	excelBtn.on('click', function() {
       		fncExcelDown();
       	});

    	/** dataSet **/
    	outSpclDataSet = new Rui.data.LJsonDataSet({
    	    id: 'outSpclDataSet',
    	    remainRemoved: true,
    	    lazyLoad: true,
    	    //defaultFailureHandler:false,
    	    fields: [
				      { id: 'outSpclId' }
					, { id: 'instNm'    }
					, { id: 'opsNm'     }
					, { id: 'poaNm'     }
					, { id: 'spltNm'    }
					, { id: 'tlocNm'    }
					, { id: 'ccpcNo'    }
					, { id: 'eml'       }
					, { id: 'repnSphe'  }
					, { id: 'hmpg'      }
					, { id: 'timpCarr'  }
					, { id: 'attcFilId' }
					, { id: 'rgstId'    }
					, { id: 'rgstNm'    }
					, { id: 'rgstOpsId' }
					, { id: 'delYn'     }
					, { id: 'frstRgstDt'}
    		]
    	});


          var columnModel = new Rui.ui.grid.LColumnModel({
              columns: [
                    { field: 'instNm',	  label: '기관명',       sortable: false,	align:'center',	width: 300 }
                  , { field: 'opsNm',	  label: '부서',		 sortable: false,	align:'center',	width: 230 }
                  , { field: 'poaNm',	  label: '직위',		 sortable: false,	align:'center',	width: 160 }
			      , { field: 'spltNm',	  label: '사외전문가명', sortable: false, 	align:'center',	width: 195 }
		  	      , { field: 'repnSphe',  label: '대표분야',     sortable: false, 	align:'center', width: 423 }
              ]
          });

          outSpclGrid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: outSpclDataSet,
              width: 600,
              height: 400,
              autoToEdit: false,
              autoWidth: true
          });

          outSpclGrid.on('cellClick', function(e) {

	           //if(e.colId == "spltNm") {
	        	   var record = outSpclDataSet.getAt(outSpclDataSet.getRow());
	        	   document.aform.outSpclId.value = record.get("outSpclId");
	        	   /* 조회수 증가
	        	   outSpclDataSet.load({
	                    url: '<c:url value="/knld/pub/updateOutsideSpecialistRtrvCnt.do"/>',
	                    params :{
	                    	outSpclId : record.get("outSpclId")
	                    }
	                });
	        	   */
                    nwinsActSubmit(document.aform, "<c:url value='/knld/pub/outsideSpecialistInfo.do'/>");
                //}

           });

          outSpclGrid.render('defaultGrid');

           /*첨부파일*/
           var attachedDialog = new Rui.ui.LDialog({
                applyTo: 'attachedDialog',
                width: 400,
                visible: false,
                postmethod: 'none'
           });

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
                 	outSpclDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                 }

                  attachedDialog.show(true);
             };

             /*첨부파일 다운로드*/
             downloadAttachFile = function(attcFilId, seq) {
                 downloadForm.action = '<c:url value="/system/attach/downloadAttachFile.do"/>';
                 $('#attcFilId').val(attcFilId);
                 $('#seq').val(seq);
                 downloadForm.submit();
             };


           /* 조회, 검색 */
           getOutSpclList = function() {
        	   outSpclDataSet.load({
                   url: '<c:url value="/knld/pub/getOutsideSpeciaList.do"/>',
                   params :{
                	instNm : escape(encodeURIComponent(document.aform.instNm.value)),
                	spltNm : escape(encodeURIComponent(document.aform.spltNm.value)),
                	repnSphe : escape(encodeURIComponent(document.aform.repnSphe.value))
                   }
               });
           };

           outSpclDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + outSpclDataSet.getCount() + '건');
  	    		// 목록 페이징
  		    	paging(outSpclDataSet,"defaultGrid");
  	      	});

           getOutSpclList();
       });
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncOutsideSpecialistRgstPage (사외전문가 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncOutSpclRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.outSpclId.value = record.get("outSpclId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/outsideSpecialistRgst.do'/>")

}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

	// 엑셀 다운로드시 전체 다운로드를 위해 추가
	outSpclDataSet.clearFilter();

    if( outSpclDataSet.getCount() > 0){
    	outSpclGrid.saveExcel(toUTF8('공지사항 목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	alert('조회된 데이타가 없습니다.!!');
    }
	// 목록 페이징
  	paging(outSpclDataSet,"defaultGrid");
}
</script>

    </head>
    <body>
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="outSpclId" name="outSpclId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />

   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>공지/게시판 - 사외전문가</h2>
   			</div>

			<div class="sub-content">
				<div class="search">
	                <div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style="width:400px;"/>
		   						<col style="width:120px;"/>
		   						<col style=""/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">기관</th>
		   							<td>
		   								<input type="text" id="instNm" value="">
		   							</td>
		   						    <th align="right">사외전문가명</th>
		    						<td>
		   								<input type="text" id="spltNm" value="">
		    						</td>
		   							<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">대표분야</th>
		   							<td colspan="3">
		   								<input type="text" id="repnSphe" value="">
		   							</td>
		   							<td class="txt-right"><a style="cursor: pointer;" onclick="getOutSpclList();" class="btnL">검색</a></td>
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
   				<div id="attachedDialog">
   					<div class="hd">첨부파일 다운로드</div>
   					<div class="bd" id="attchFileView"></div>
   				</div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>