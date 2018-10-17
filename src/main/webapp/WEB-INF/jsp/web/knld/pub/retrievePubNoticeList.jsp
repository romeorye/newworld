<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: pubNoticeList.jsp
 * @desc    : 공지사항 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.07.25  민길문		최초생성
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
var dataSet;	// 프로젝트 데이터셋
var dm;         // 데이터셋매니저
var grid;       // 그리드
var lvAttcFilId;

	Rui.onReady(function() {
           /*******************
            * 변수 및 객체 선언
            *******************/

            var pwiScnCd = new Rui.ui.form.LCombo({
                applyTo: 'pwiScnCd',
                name: 'pwiScnCd',
                useEmptyText: true,
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PWI_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            pwiScnCd.on('keypress', function(e) {
     			if(e.keyCode == 13) {
     				getPwiImtrList();
      			}
	        });

           var titlNm = new Rui.ui.form.LTextBox({
                applyTo: 'titlNm',
                width: 600
           });

           titlNm.on('keypress', function(e) {
    			if(e.keyCode == 13) {
    				getPwiImtrList();
     			}
	        });

           var rgstNm = new Rui.ui.form.LTextBox({
               applyTo: 'rgstNm',
               width: 200
           });

           rgstNm.on('keypress', function(e) {
   				if(e.keyCode == 13) {
   					getPwiImtrList();
    			}
	        });

       	/* [버튼] 공지사항등록 */
       	var lbButRgst = new Rui.ui.LButton('rgstBtn');
       	lbButRgst.on('click', function() {
       		fncPrjRgstPage('');
       	});

       	/* [버튼] EXCEL다운로드 */
       	var lbButExcl = new Rui.ui.LButton('excelBtn');
       	lbButExcl.on('click', function() {
       		// 엑셀 다운로드시 전체 다운로드를 위해 추가
        	dataSet.clearFilter();
       		fncExcelDown();
       		// 목록 페이징
       		paging(dataSet,"defaultGrid");
       	});

    	/** dataSet **/
    	dataSet = new Rui.data.LJsonDataSet({
    	    id: 'dataSet',
    	    remainRemoved: true,
    	    lazyLoad: true,
    	    //defaultFailureHandler:false,
    	    fields: [
				  { id: 'pwiId'}
					, { id: 'titlNm' }
					, { id: 'titlNm2' }
					, { id: 'pwiScnCd' }
					, { id: 'pwiScnNm' }
					, { id: 'sbcNm' }
					, { id: 'rtrvCnt' }
					, { id: 'keywordNm' }
					, { id: 'attcFilId' }
					, { id: 'ugyYn' }
					, { id: 'rgstId' }
					, { id: 'rgstNm' }
					, { id: 'rgstOpsId' }
					, { id: 'frstRgstDt' }
    		]
    	});


          var columnModel = new Rui.ui.grid.LColumnModel({
              columns: [
                    { field: 'pwiScnNm',	label: '분류',		sortable: false,	align:'center',	width: 140 }
                  , { field: 'titlNm2',		label: '제목',		sortable: false,	align:'left',	width: 800,
                	  renderer: function(value, p, record, row, i) {
                          if(Rui.util.LObject.isEmpty(value) == false){
                        	  var valIndex = value.indexOf('[긴급]');
                     			if(valIndex == -1){
                     				return value ;
                     			}else if(valIndex != -1){
                     				value1 = value.substring(0, 4);
                                  value2 = value.substring(4);
                                  return  '<span style = "color : #FF5E00">' + value1 + '</span>' + value2;

                     			}
                          }

                	  } //글씨 색
                	}
                  , { field: 'rgstNm',		label: '등록자',	sortable: false,	align:'center',	width: 120 }
                  , { field: 'frstRgstDt',	label: '등록일',	sortable: false,	align:'center',	width: 120 }
			      , { field: 'rtrvCnt',		label: '조회',		sortable: false, 	align:'center',	width: 80 }
		  	      , { id: 'attachDownBtn',  label: '첨부파일',  width: 65 ,
		  	    	  renderer: function(val, p, record, row, i){
		  	    		  var recordFilId = nullToString(record.data.attcFilId);
		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'knldPolicy', '*' ,'R')";
		  	    		  return Rui.isUndefined(record.get('attcFilId')) ? '' : '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
                      }}
              ]
          });


          grid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: dataSet,
              width: 600,
              height: 400,
              autoToEdit: false,
              autoWidth : true
          });

           grid.on('cellClick', function(e) {

        	   /*
        	   var record = dataSet.getAt(dataSet.getRow());
        	   document.aform.pwiId.value = record.get("pwiId");

              	dataSet.load({
                    url: '<c:url value="/knld/updatePwiImtrRtrvCnt.do"/>',
                    params :{
                    	pwiId : record.get("pwiId")
                    }
                });

	           nwinsActSubmit(document.aform, "<c:url value='/knld/pwiImtrInfo.do'/>");
	           */

	           if(e.colId == "titlNm2") {
	        	   var record = dataSet.getAt(dataSet.getRow());
	        	   document.aform.pwiId.value = record.get("pwiId");

	              	dataSet.load({
	                    url: '<c:url value="/knld/pub/updatePubNoticeRtrvCnt.do"/>',
	                    params :{
	                    	pwiId : record.get("pwiId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/knld/pub/pubNoticeInfo.do'/>");
                }

           });

           grid.render('defaultGrid');

           /*첨부파일*/
//            var attachedDialog = new Rui.ui.LDialog({
//                 applyTo: 'attachedDialog',
//                 width: 400,
//                 visible: false,
//                 postmethod: 'none'
//            });

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
                 	dataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                 }

//                   attachedDialog.show(true);
             };

             /*첨부파일 다운로드*/
             downloadAttachFile = function(attcFilId, seq) {
                 downloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
                 $('#attcFilId').val(attcFilId);
                 $('#seq').val(seq);
                 downloadForm.submit();
             };


           /* 조회 */
           getPwiImtrList = function() {
           	dataSet.load({
                   url: '<c:url value="/knld/pub/getPubNoticeList.do"/>',
                   params :{
                   	titlNm : escape(encodeURIComponent(document.aform.titlNm.value)),
                   	rgstNm : escape(encodeURIComponent(document.aform.rgstNm.value)),
           		    pwiScnCd : document.aform.pwiScnCd.value
                   }
               });
           };

           dataSet.on('load', function(e) {
 	    		$("#cnt_text").html('총 ' + dataSet.getCount() + '건');
 	    		// 목록 페이징
 		    	paging(dataSet,"defaultGrid");
 	      	});


           getPwiImtrList();
       });

</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncPrjRgstPage (공지사항 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncPrjRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.pwiId.value = record.get("pwiId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/pubNoticeRgst.do'/>")

}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

    if( dataSet.getCount() > 0){
    	//gridExcel.saveExcel(toUTF8('Project 목록_') + new Date().format('%Y%m%d') + '.xls');
        var excelColumnModel = columnModel.createExcelColumnModel(false);
        duplicateExcelGrid(excelColumnModel);
    	nG.saveExcel(toUTF8('공지사항 목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	alert('조회된 데이타가 없습니다.!!');
    }
}
</script>

    </head>
    <body>
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="pwiId" name="pwiId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />
		<input type="hidden" id="test" name="test" value="3" />

   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
					<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
					<span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>공지사항</h2>
   			</div>
			<div class="sub-content">
				<div class="search">
					<div class="search-content">
		 				<table>
		 					<colgroup>
		 						<col style="width:120px;"/>
		 						<col style="width:240px;"/>
		 						<col style="width:120px;"/>
		 						<col style="width:200px;"/>
		 						<col style=";"/>
		 					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th>제목</th>
		   							<td colspan="3">
		   								<input type="text" id="titlNm" value="">
		   							</td>
		   							<td>
<!-- 	<button  type="button" class="btn_search"  onclick="getPwiImtrList();">검색</button> -->

		   							</td>
		   						</tr>
		   						<tr>
		   							<th>분류</th>
		   							<td>
		   								<div id="pwiScnCd" ></div>
		   							</td>
		   							<th>등록자</th>
		    						<td>
		   								<input type="text" id="rgstNm" value="">
		    						</td>
		    						<td class="txt-right"><a style="cursor: pointer;" onclick="getPwiImtrList();" class="btnL">검색</a></td>
		   						</tr>
		   					</tbody>
		   				</table>
		   			</div>
	   			</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
<!--    				<button type="button" id="qryBtn" name="qryBtn" onclick="getPwiImtrList()">조회</button> -->
   						<button type="button" id="rgstBtn" name="rgstBtn" >등록</button>
   						<button type="button" id="excelBtn" name="excelBtn">Excel</button>
   					</div>
   				</div>


   				<div id="defaultGrid"></div>
<!--    				<div id="attachedDialog"> -->
<!--    					<div class="hd">첨부파일 다운로드</div> -->
<!--    					<div class="bd" id="attchFileView"></div> -->
<!--    				</div> -->

   			</div><!-- //contents -->
		</form>
    </body>
</html>