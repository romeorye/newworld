<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: ManualList.jsp
 * @desc    : 규정/업무Manual 리스트
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


<script type="text/javascript">
var manualDataSet;	// 프로젝트 데이터셋
var dm;         // 데이터셋매니저
var manualGrid;       // 그리드
var lvAttcFilId;

	Rui.onReady(function() {
           /*******************
            * 변수 및 객체 선언
            *******************/
            /* 장소 분류 코드 */
            var prcpMnlScnCd = new Rui.ui.form.LCombo({
                applyTo: 'prcpMnlScnCd',
                name: 'prcpMnlScnCd',
                useEmptyText: true,
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PRCP_MNL_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            prcpMnlScnCd.on('keypress', function(e) {
              	if(e.keyCode == 13) {
              		getManualList();
               	}
	        });

			/* 제목 */
           var titlNm = new Rui.ui.form.LTextBox({
                applyTo: 'titlNm',
                width: 400
           });

           titlNm.on('keypress', function(e) {
             	if(e.keyCode == 13) {
             		getManualList();
              	}
	        });

			/* 등록자 */
           var rgstNm = new Rui.ui.form.LTextBox({
               applyTo: 'rgstNm',
               width: 200
           });

           rgstNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getManualList();
             	}
	        });

			/* 기간 */
           	/** dateBox **/
			var enfcStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'enfcStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				//defaultValue: new Date(),
				//defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
				width: 100,
				dateType: 'string'
			});

			enfcStrtDt.on('blur', function(){
// 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(enfcStrtDt.getValue(),"-","")) ) )  {
// 					alert('날짜형식이 올바르지 않습니다.!!');
// 					enfcStrtDt.setValue(new Date());
// 				}

				if(Rui.isEmpty(enfcStrtDt.getValue())) return;

            	if(!Rui.isEmpty(enfcFnhDt.getValue())) {
                	var startDt = enfcStrtDt.getValue().replace(/\-/g, "").toDate();
                	var fnhDt   = enfcFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    enfcStrtDt.setValue("");
	                    return;
	                }
            	}
			});

			var enfcFnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'enfcFnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				//defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			enfcFnhDt.on('blur', function(){
// 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(enfcFnhDt.getValue(),"-","")) ) )  {
// 					alert('날짜형식이 올바르지 않습니다.!!');
// 					enfcFnhDt.setValue(new Date());
// 				}

				if(Rui.isEmpty(enfcFnhDt.getValue())) return;

				if(!Rui.isEmpty(enfcStrtDt.getValue())) {
	                var startDt = enfcStrtDt.getValue().replace(/\-/g, "").toDate();
	                var fnhDt   = enfcFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    enfcFnhDt.setValue("");
	                    return;
	                }
	            }
			});

			enfcFnhDt.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getManualList();
             	}
	        });


       	/* [버튼] 신규 등록 */
       	var rgstBtn = new Rui.ui.LButton('rgstBtn');
       	rgstBtn.on('click', function() {
       		fncManualRgstPage('');
       	});

       	/* [버튼] EXCEL다운로드 */
       	var excelBtn = new Rui.ui.LButton('excelBtn');
       	excelBtn.on('click', function() {
       		fncExcelDown();
       	});

    	/** dataSet **/
    	manualDataSet = new Rui.data.LJsonDataSet({
    	    id: 'manualDataSet',
    	    remainRemoved: true,
    	    lazyLoad: true,
    	    //defaultFailureHandler:false,
    	    fields: [
				      { id: 'manualId'}
					, { id: 'titlNm' }
					, { id: 'prcpMnlScnCd' }
					, { id: 'prcpMnlScnNm' }
					, { id: 'enfcDt' }
					, { id: 'rfrmSbc' }
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
                    { field: 'prcpMnlScnNm', label: '구분',		  sortable: false,	align:'center',	width: 130 }
                  , { field: 'titlNm',		 label: '제목',       sortable: false,	align:'left',	width: 670 }
                  , { field: 'enfcDt',       label: '시행일',	  sortable: false,	align:'center',	width: 120 }
                  , { field: 'rgstNm',		 label: '등록자',	  sortable: false,	align:'center',	width: 120 }
                  , { field: 'frstRgstDt',	 label: '등록일',	  sortable: false,	align:'center',	width: 120 }
			      , { field: 'rtrvCnt',		 label: '조회',		  sortable: false, 	align:'center',	width: 69  }
		  	      , { id: 'attachDownBtn',   label: '첨부',                                         width: 80
		  	    	  ,renderer: function(val, p, record, row, i){
		  	    		  var recordFilId = nullToString(record.data.attcFilId);
		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'knldPolicy', '*' ,'R')";
		  	    		  return Rui.isUndefined(record.get('attcFilId')) ? '' : '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
                      }}
              ]
          });

          manualGrid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: manualDataSet,
              width: 600,
              height: 550,
              autoToEdit: false,
              autoWidth: true
          });

          manualGrid.on('cellClick', function(e) {

	           if(e.colId == "titlNm") {
	        	   var record = manualDataSet.getAt(manualDataSet.getRow());
	        	   document.aform.manualId.value = record.get("manualId");

	        	   manualDataSet.load({
	                    url: '<c:url value="/knld/pub/updateManualRtrvCnt.do"/>',
	                    params :{
	                    	manualId : record.get("manualId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/knld/pub/manualInfo.do'/>");
                }

           });

          manualGrid.render('defaultGrid');

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
                 	manualDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
           getManualList = function() {
        	   manualDataSet.load({
                   url: '<c:url value="/knld/pub/getManualList.do"/>',
                   params :{
                   	titlNm : escape(encodeURIComponent(document.aform.titlNm.value)),
                   	rgstNm : escape(encodeURIComponent(document.aform.rgstNm.value)),
                   	prcpMnlScnCd : document.aform.prcpMnlScnCd.value,
                   	enfcStrtDt : document.aform.enfcStrtDt.value,
                   	enfcFnhDt : document.aform.enfcFnhDt.value
                   }
               });
           };

           manualDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + manualDataSet.getCount() + '건');
  	      	});

           getManualList();
       });
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncManualRgstPage (규정/업무Manual 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncManualRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.manualId.value = record.get("manualId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/manualRgst.do'/>")

}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

    if( manualDataSet.getCount() > 0){
    	manualGrid.saveExcel(toUTF8('공지사항 목록_') + new Date().format('%Y%m%d') + '.xls');
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
		<input type="hidden" id="manualId" name="manualId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />

   		<div class="contents">   			
   			<div class="titleArea">
   				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a> 
   				<h2>공지/게시판 - 규정/업무Manual</h2>
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
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">제목</th>
		   							<td>
		   								<input type="text" id="titlNm" value="">
		   							</td>
		   						    <th align="right">구분</th>
		   							<td>
		   								<div id="prcpMnlScnCd"></div>
		   							</td>
		   							<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">시행일</th>
		   							<td>
		   								<input type="text" id="enfcStrtDt" /><em class="gab"> ~ </em>
		   								<input type="text" id="enfcFnhDt" />
		   							</td>
		   							<th align="right">등록자</th>
		    						<td>
		   								<input type="text" id="rgstNm" value="">
		    						</td>
		    						<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getManualList();" class="btnL">검색</a>
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