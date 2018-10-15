<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: ShowList.jsp
 * @desc    : 전시회 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.13  			최초생성
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
var showDataSet;	// 프로젝트 데이터셋
var dm;         // 데이터셋매니저
var showGrid;       // 그리드
var lvAttcFilId;

	Rui.onReady(function() {
           /*******************
            * 변수 및 객체 선언
            *******************/
            /* 장소 분류 코드 */
            var swrmNatCd = new Rui.ui.form.LCombo({
                applyTo: 'swrmNatCd',
                name: 'swrmNatCd',
                useEmptyText: true,
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=CFRN_LOC_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            swrmNatCd.on('keypress', function(e) {
 				if(e.keyCode == 13) {
 					getShowList();
  				}
	        });

			/* 제목 */
           var titlNm = new Rui.ui.form.LTextBox({
                applyTo: 'titlNm',
                width: 400
           });

           titlNm.on('keypress', function(e) {
				if(e.keyCode == 13) {
					getShowList();
 				}
	        });

			/* 등록자 */
           var rgstNm = new Rui.ui.form.LTextBox({
               applyTo: 'rgstNm',
               width: 200
           });

           rgstNm.on('keypress', function(e) {
				if(e.keyCode == 13) {
					getShowList();
				}
	        });

			/* 기간 */
           	/** dateBox **/
			var swrmStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'swrmStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
// 				defaultValue: new Date(),
				//defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
				width: 100,
				dateType: 'string'
			});

			swrmStrtDt.on('blur', function(){
// 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(swrmStrtDt.getValue(),"-","")) ) )  {
// 					alert('날짜형식이 올바르지 않습니다.!!');
// 					swrmStrtDt.setValue(new Date());
// 				}

				if(Rui.isEmpty(swrmStrtDt.getValue())) return;

				if(!Rui.isEmpty(swrmFnhDt.getValue())) {
                	var startDt = swrmStrtDt.getValue().replace(/\-/g, "").toDate();
                	var fnhDt   = swrmFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    swrmStrtDt.setValue("");
	                    return;
	                }
            	}
			});

			var swrmFnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'swrmFnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				//defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			swrmFnhDt.on('blur', function(){
// 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(swrmFnhDt.getValue(),"-","")) ) )  {
// 					alert('날짜형식이 올바르지 않습니다.!!');
// 					swrmFnhDt.setValue(new Date());
// 				}

				if(Rui.isEmpty(swrmFnhDt.getValue())) return;

				if(!Rui.isEmpty(swrmStrtDt.getValue())) {
	                var startDt = swrmStrtDt.getValue().replace(/\-/g, "").toDate();
	                var fnhDt   = swrmFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    swrmFnhDt.setValue("");
	                    return;
	                }
	            }
			});

			swrmFnhDt.on('keypress', function(e) {
				if(e.keyCode == 13) {
					getShowList();
				}
	        });


       	/* [버튼] 신규 등록 */
       	var rgstBtn = new Rui.ui.LButton('rgstBtn');
       	rgstBtn.on('click', function() {
       		fncShowRgstPage('');
       	});

       	/* [버튼] EXCEL다운로드 */
       	var excelBtn = new Rui.ui.LButton('excelBtn');
       	excelBtn.on('click', function() {
       		fncExcelDown();
       	});

    	/** dataSet **/
    	showDataSet = new Rui.data.LJsonDataSet({
    	    id: 'showDataSet',
    	    remainRemoved: true,
    	    lazyLoad: true,
    	    //defaultFailureHandler:false,
    	    fields: [
				      { id: 'showId'}
					, { id: 'titlNm' }
					, { id: 'swrmNatCd' }
					, { id: 'swrmNatNm' }
					, { id: 'swrmStrtDt' }
					, { id: 'swrmFnhDt' }
					, { id: 'sbcNm' }
					, { id: 'rtrvCnt' }
					, { id: 'keywordNm' }
					, { id: 'attcFilId' }
					, { id: 'rgstId' }
					, { id: 'rgstNm' }
					, { id: 'rgstOpsId' }
					, { id: 'delYn' }
					, { id: 'frstRgstDt' }
    		]
    	});


          var columnModel = new Rui.ui.grid.LColumnModel({
              columns: [
                    { field: 'titlNm',		label: '전시회명',        sortable: false,	align:'left',	width: 620 }
                  , { field: 'swrmNatNm',   label: '개최국',		  sortable: false,	align:'center',	width: 100 }
                  , { field: 'swrmStrtDt',  label: '전시시작일',	  sortable: false,	align:'center',	width: 110 }
                  , { field: 'swrmFnhDt',   label: '전시종료일',	  sortable: false,	align:'center',	width: 110 }
                  , { field: 'rgstNm',		label: '등록자',		  sortable: false,	align:'center',	width: 110 }
                  , { field: 'frstRgstDt',	label: '등록일',		  sortable: false,	align:'center',	width: 110 }
			      , { field: 'rtrvCnt',		label: '조회',		      sortable: false, 	align:'center',	width: 60 }
		  	      , { id: 'attachDownBtn',  label: '첨부',                                              width: 89
		  	    	  ,renderer: function(val, p, record, row, i){
		  	    		  var recordFilId = nullToString(record.data.attcFilId);
		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'knldPolicy', '*' ,'R')";
		  	    		  return Rui.isUndefined(record.get('attcFilId')) ? '' : '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
                      }}
              ]
          });

          showGrid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: showDataSet,
              width: 600,
              height: 400,
              autoToEdit: false,
              autoWidth: true
          });

          showGrid.on('cellClick', function(e) {

	           if(e.colId == "titlNm") {
	        	   var record = showDataSet.getAt(showDataSet.getRow());
	        	   document.aform.showId.value = record.get("showId");

	        	   showDataSet.load({
	                    url: '<c:url value="/knld/pub/updateShowRtrvCnt.do"/>',
	                    params :{
	                    	showId : record.get("showId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/knld/pub/showInfo.do'/>");
                }

           });

          showGrid.render('defaultGrid');

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
                 	showDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                 }

             };

             /*첨부파일 다운로드*/
             downloadAttachFile = function(attcFilId, seq) {
                 downloadForm.action = '<c:url value="/system/attach/downloadAttachFile.do"/>';
                 $('#attcFilId').val(attcFilId);
                 $('#seq').val(seq);
                 downloadForm.submit();
             };


           /* 조회, 검색 */
           getShowList = function() {
        	   showDataSet.load({
                   url: '<c:url value="/knld/pub/getShowList.do"/>',
                   params :{
                   	titlNm : escape(encodeURIComponent(document.aform.titlNm.value)),
                   	rgstNm : escape(encodeURIComponent(document.aform.rgstNm.value)),
                   	swrmNatCd : document.aform.swrmNatCd.value,
                   	swrmStrtDt : document.aform.swrmStrtDt.value,
                   	swrmStrtDt : document.aform.swrmStrtDt.value
                   }
               });
           };

           showDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + showDataSet.getCount() + '건');
  	    		// 목록 페이징
  		    	paging(showDataSet,"defaultGrid");
  	      	});

           getShowList();
       });
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncShowRgstPage (전시회 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncShowRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.showId.value = record.get("showId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/showRgst.do'/>")

}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

	// 엑셀 다운로드시 전체 다운로드를 위해 추가
	showDataSet.clearFilter();

    if( showDataSet.getCount() > 0){
    	showGrid.saveExcel(toUTF8('전시회 목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	alert('조회된 데이타가 없습니다.!!');
    }

	// 목록 페이징
    paging(showDataSet,"defaultGrid");

}
</script>

    </head>
    <body>
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="showId" name="showId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />

   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
		          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		          <span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>공지/게시판 - 전시회</h2>
   			</div>
			<div class="sub-content">
				<div class="search">
	                <div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120PX;"/>
		   						<col style="width:400PX;"/>
		   						<col style="width:120PX;"/>
		   						<col style="width:200PX"/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">전시회명</th>
		   							<td>
		   								<input type="text" id="titlNm" value="">
		   							</td>
		   						    <th align="right">개최국</th>
		   							<td>
		   								<div id="swrmNatCd"></div>
		   							</td>
		   							<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">전시시작일</th>
		   							<td>
		   								<input type="text" id="swrmStrtDt" /><em class="gab"> ~ </em>
		   								<input type="text" id="swrmFnhDt" />
		   							</td>
		   							<th align="right">등록자</th>
		    						<td>
		   								<input type="text" id="rgstNm" value="">
		    						</td>
		    						<td class="txt-right"><a style="cursor: pointer;" onclick="getShowList();" class="btnL">검색</a></td>
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