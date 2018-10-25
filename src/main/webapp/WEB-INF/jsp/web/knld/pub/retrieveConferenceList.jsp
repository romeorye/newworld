<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: ConferenceList.jsp
 * @desc    : 학회컨퍼런스 리스트
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/validate/LCustomValidator.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/validate/LCustomValidator.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">
var conferenceDataSet;	// 프로젝트 데이터셋
var dm;         // 데이터셋매니저
var conferenceGrid;       // 그리드
var lvAttcFilId;

	Rui.onReady(function() {
           /*******************
            * 변수 및 객체 선언
            *******************/
            /* 장소 분류 코드 */
            var cfrnLocScnCd = new Rui.ui.form.LCombo({
                applyTo: 'cfrnLocScnCd',
                name: 'cfrnLocScnCd',
                useEmptyText: true,
                emptyText: '전체',
                defaultValue: '<c:out value="${inputData.cfrnLocScnCd}"/>',
                emptyValue: '',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=CFRN_LOC_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            cfrnLocScnCd.on('keypress', function(e) {
         	   if(e.keyCode == 13) {
         		   getConferenceList();
            	   }
            });

			/* 제목 */
           var titlNm = new Rui.ui.form.LTextBox({
                applyTo: 'titlNm',
                defaultValue: '<c:out value="${inputData.titlNm}"/>',
                width: 400
           });

           titlNm.on('keypress', function(e) {
        	   if(e.keyCode == 13) {
        		   getConferenceList();
           	   }
           });

			/* 등록자 */
           var rgstNm = new Rui.ui.form.LTextBox({
               applyTo: 'rgstNm',
               defaultValue: '<c:out value="${inputData.rgstNm}"/>',
               width: 200
           });

           rgstNm.on('keypress', function(e) {
              	if(e.keyCode == 13) {
              		getConferenceList();
              	}
           });

			/* 기간 */
           	/** dateBox **/
			var cfrnStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'cfrnStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.cfrnStrtDt}"/>',
				//defaultValue: new Date(),
				//defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
				width: 100,
				dateType: 'string'
			});

			cfrnStrtDt.on('blur', function(){
// 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(cfrnStrtDt.getValue(),"-","")) ) )  {
// 					alert('날짜형식이 올바르지 않습니다.!!');
// 					cfrnStrtDt.setValue(new Date());
// 				}

				if(Rui.isEmpty(cfrnStrtDt.getValue())) return;

            	if(!Rui.isEmpty(cfrnFnhDt.getValue())) {
                	var startDt = cfrnStrtDt.getValue().replace(/\-/g, "").toDate();
                	var fnhDt   = cfrnFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    cfrnStrtDt.setValue("");
	                    return;
	                }
            	}
			});

			var cfrnFnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'cfrnFnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.cfrnFnhDt}"/>',
				//defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			cfrnFnhDt.on('blur', function(){
// 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(cfrnFnhDt.getValue(),"-","")) ) )  {
// 					alert('날짜형식이 올바르지 않습니다.!!');
// 					cfrnFnhDt.setValue(new Date());
// 				}

				if(Rui.isEmpty(cfrnFnhDt.getValue())) return;

				if(!Rui.isEmpty(cfrnStrtDt.getValue())) {
	                var startDt = cfrnStrtDt.getValue().replace(/\-/g, "").toDate();
	                var fnhDt   = cfrnFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    cfrnFnhDt.setValue("");
	                    return;
	                }
	            }
			});

			cfrnFnhDt.on('keypress', function(e) {
              	if(e.keyCode == 13) {
              		getConferenceList();
              	}
            });

       	/* [버튼] 신규 등록 */
       	var rgstBtn = new Rui.ui.LButton('rgstBtn');
       	rgstBtn.on('click', function() {
       		fncConferenceRgstPage('');
       	});

       	/* [버튼] EXCEL다운로드 */
       	var excelBtn = new Rui.ui.LButton('excelBtn');
       	excelBtn.on('click', function() {
       		fncExcelDown();
       	});

    	/** dataSet **/
    	conferenceDataSet = new Rui.data.LJsonDataSet({
    	    id: 'conferenceDataSet',
    	    remainRemoved: true,
    	    lazyLoad: true,
    	    //defaultFailureHandler:false,
    	    fields: [
				      { id: 'conferenceId'}
					, { id: 'titlNm' }
					, { id: 'cfrnLocScnCd' }
					, { id: 'cfrnLocScnNm' }
					, { id: 'cfrnStrtDt' }
					, { id: 'cfrnFnhDt' }
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


           columnModel = new Rui.ui.grid.LColumnModel({
              columns: [
                    { field: 'titlNm',		  label: '학회/컨퍼런스명',  sortable: false,	align:'left',	width: 620 }
                  , { field: 'cfrnLocScnNm',  label: '장소',		     sortable: false,	align:'center',	width: 65 }
                  , { field: 'cfrnStrtDt',    label: '시작일',	         sortable: false,	align:'center',	width: 120 }
                  , { field: 'cfrnFnhDt',     label: '종료일',	         sortable: false,	align:'center',	width: 120 }
                  , { field: 'rgstNm',		  label: '등록자',		     sortable: false,	align:'center',	width: 120 }
                  , { field: 'frstRgstDt',	  label: '등록일',		     sortable: false,	align:'center',	width: 120 }
			      , { field: 'rtrvCnt',		  label: '조회',		     sortable: false, 	align:'center',	width: 70  }
		  	      , { id: 'attachDownBtn',    label: '첨부',                                                width: 90
		  	    	  ,renderer: function(val, p, record, row, i){
		  	    		  var recordFilId = nullToString(record.data.attcFilId);
		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'knldPolicy', '*' ,'R')";
		  	    		  return Rui.isUndefined(record.get('attcFilId')) ? '' : '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
                      }}
              ]
          });

          conferenceGrid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: conferenceDataSet,
              width: 600,
              height: 400,
              autoToEdit: false,
              autoWidth: true
          });

          conferenceGrid.on('cellClick', function(e) {

	           if(e.colId == "titlNm") {
	        	   var record = conferenceDataSet.getAt(conferenceDataSet.getRow());
	        	   document.aform.conferenceId.value = record.get("conferenceId");

	        	   conferenceDataSet.load({
	                    url: '<c:url value="/knld/pub/updateConferenceRtrvCnt.do"/>',
	                    params :{
	                    	conferenceId : record.get("conferenceId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/knld/pub/conferenceInfo.do'/>");
                }

           });

          conferenceGrid.render('defaultGrid');

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
                 	conferenceDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
           getConferenceList = function() {
        	   conferenceDataSet.load({
                   url: '<c:url value="/knld/pub/getConferenceList.do"/>',
                   params :{
                   	titlNm : escape(encodeURIComponent(document.aform.titlNm.value)),
                   	rgstNm : escape(encodeURIComponent(document.aform.rgstNm.value)),
                   	cfrnLocScnCd : document.aform.cfrnLocScnCd.value,
                   	cfrnStrtDt : document.aform.cfrnStrtDt.value,
                   	cfrnFnhDt : document.aform.cfrnFnhDt.value
                   }
               });
           };

           conferenceDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + conferenceDataSet.getCount() + '건');
  	    		// 목록 페이징
  		    	paging(conferenceDataSet,"defaultGrid");
  	      	});

           //getConferenceList();
       });//onReady 끝
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncConferenceRgstPage (학회/컨퍼런스 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncConferenceRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.conferenceId.value = record.get("conferenceId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/conferenceRgst.do'/>")

}


<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

	// 엑셀 다운로드시 전체 다운로드를 위해 추가
	conferenceDataSet.clearFilter();

    if( conferenceDataSet.getCount() > 0){
        var excelColumnModel = columnModel.createExcelColumnModel(false);
        duplicateExcelGrid(excelColumnModel);
    	nG.saveExcel(toUTF8('학회/컨퍼런스 목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	alert('조회된 데이타가 없습니다.!!');
    }

 	// 목록 페이징
    paging(conferenceDataSet,"defaultGrid");
}

init = function() {
	var titlNm='${inputData.titlNm}';
	conferenceDataSet.load({
         url: '<c:url value="/knld/pub/getConferenceList.do"/>',
         params :{
         	titlNm : escape(encodeURIComponent(titlNm)),
         	rgstNm : escape(encodeURIComponent('${inputData.rgstNm}')),
         	cfrnLocScnCd : '${inputData.cfrnLocScnCd}',
         	cfrnStrtDt : '${inputData.cfrnStrtDt}',
         	cfrnFnhDt : '${inputData.cfrnFnhDt}'
         }
     });
 }



</script>

    </head>
    <body onkeypress="if(event.keyCode==13) {getConferenceList();}" onload="init();">
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="conferenceId" name="conferenceId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />

   		<div class="contents">

   			<div class="titleArea">
   				<a class="leftCon" href="#">
		          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		          <span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>공지/게시판 - 학회/컨퍼런스</h2>
   			</div>

			<div class="sub-content">
				<div class="search">
	                <div class="search-content">
	   				<table>
	   					<colgroup>
	   						<col style="width:120px;"/>
	   						<col style="width:400px;"/>
	   						<col style="width:120px;"/>
	   						<col style="width:200px;"/>
	   						<col style=""/>
	   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">학회/컨퍼런스명</th>
		   							<td>
		   								<input type="text" id="titlNm" value="">
		   							</td>
		   						    <th align="right">장소</th>
		   							<td>
		   								<div id="cfrnLocScnCd"></div>
		   							</td>
		   							<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">시작일</th>
		   							<td>
		   								<input type="text" id="cfrnStrtDt" /><em class="gab"> ~ </em>
		   								<input type="text" id="cfrnFnhDt" />
		   							</td>
		   							<th align="right">등록자</th>
		    						<td>
		   								<input type="text" id="rgstNm" value="">
		    						</td>
		    						<td class="txt-right"><a style="cursor: pointer;" onclick="getConferenceList();" class="btnL">검색</a></td>
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