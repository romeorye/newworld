<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: GeneralQnaList.jsp
 * @desc    : 일반QnA 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.18  			최초생성
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
var qnaDataSet;	// 프로젝트 데이터셋
var dm;         // 데이터셋매니저
var qnaGrid;       // 그리드
var lvAttcFilId;

	Rui.onReady(function() {
           /*******************
            * 변수 및 객체 선언
            *******************/
            /* 질문유형 코드 */
            var qustClCd = new Rui.ui.form.LCombo({
                applyTo: 'qustClCd',
                name: 'qustClCd',
                useEmptyText: true,
                emptyText: '전체',
                defaultValue: '<c:out value="${inputData.qustClCd}"/>',
                emptyValue: '',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=QUST_CL_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            qustClCd.on('keypress', function(e) {
				if(e.keyCode == 13) {
					getQnaList();
				}
	        });

			/* 제목 */
           var titlNm = new Rui.ui.form.LTextBox({
                applyTo: 'titlNm',
                defaultValue: '<c:out value="${inputData.titlNm}"/>',
                width: 500
           });

           titlNm.on('keypress', function(e) {
				if(e.keyCode == 13) {
					getQnaList();
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
					getQnaList();
				}
	        });

			/* 기간 */
           	/** dateBox **/
			var strtDt = new Rui.ui.form.LDateBox({
				applyTo: 'strtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.strtDt}"/>',
				//defaultValue: new Date(),
				//defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
				width: 100,
				dateType: 'string'
			});

			strtDt.on('blur', function(){
// 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(strtDt.getValue(),"-","")) ) )  {
// 					alert('날짜형식이 올바르지 않습니다.!!');
// 					strtDt.setValue(new Date());
// 				}

				if(Rui.isEmpty(strtDt.getValue())) return;

            	if(!Rui.isEmpty(fnhDt.getValue())) {
                	var startDt1 = strtDt.getValue().replace(/\-/g, "").toDate();
                	var fnhDt1   = fnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt1 > fnhDt1) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    strtDt.setValue("");
	                    return;
	                }
            	}
			});

			var fnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'fnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.fnhDt}"/>',
				//defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			fnhDt.on('blur', function(){
// 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fnhDt.getValue(),"-","")) ) )  {
// 					alert('날짜형식이 올바르지 않습니다.!!');
// 					fnhDt.setValue(new Date());
// 				}

				if(Rui.isEmpty(fnhDt.getValue())) return;

				if(!Rui.isEmpty(strtDt.getValue())) {
	                var startDt2 = strtDt.getValue().replace(/\-/g, "").toDate();
	                var fnhDt2   = fnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt2 > fnhDt2) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    fnhDt.setValue("");
	                    return;
	                }
	            }
			});

			fnhDt.on('keypress', function(e) {
				if(e.keyCode == 13) {
					getQnaList();
				}
	        });


       	/* [버튼] 신규 등록 */
       	var rgstBtn = new Rui.ui.LButton('rgstBtn');
       	rgstBtn.on('click', function() {
       		fncQnaRgstPage('');
       	});

       	/* [버튼] EXCEL다운로드 */
       	var excelBtn = new Rui.ui.LButton('excelBtn');
       	excelBtn.on('click', function() {
       		fncExcelDown();
       	});

    	/** dataSet **/
    	qnaDataSet = new Rui.data.LJsonDataSet({
    	    id: 'qnaDataSet',
    	    remainRemoved: true,
    	    lazyLoad: true,
    	    //defaultFailureHandler:false,
    	    fields: [
				      { id: 'qnaId'}
					, { id: 'titlNm' }
					, { id: 'qnaClCd' }
					, { id: 'qnaClNm' }
					, { id: 'qustClCd' }
					, { id: 'qustClNm' }
					, { id: 'rltdWrtgId' }
					, { id: 'sbcNm' }
					, { id: 'rtrvCnt' }
					, { id: 'keywordNm' }
					, { id: 'attcFilId' }
					, { id: 'rgstId' }
					, { id: 'rgstNm' }
					, { id: 'rgstOpsId' }
					, { id: 'delYn' }
					, { id: 'frstRgstDt' }
					, { id: 'depth', type:'number' }

    		]
    	});


          columnModel = new Rui.ui.grid.LColumnModel({
              columns: [
                    { field: 'qnaClCd',     label: '구분',		sortable: false,	align:'center',	width: 100 }
            	  , { field: 'titlNm',		label: '제목',      sortable: false,	align:'left',	width: 700,
            	    	renderer:  function(val, p, record, row, i){
            	    	var titlNm = val;

            	    	if(record.get('depth') > 1) {
            	    		titlNm = ''.lPad("&nbsp;", (record.get('depth') - 2) * 30) +
                      		'<img src="<%=newImagePath%>/treemenu_images/last_normal.gif"/> ' + val;
            	    	}
                      return titlNm;
					} }
                  , { field: 'qustClNm',    label: '질문유형',	sortable: false,	align:'center',	width: 150 }
                  , { field: 'rgstNm',		label: '등록자',	sortable: false,	align:'center',	width: 110 }
                  , { field: 'frstRgstDt',	label: '등록일',	sortable: false,	align:'center',	width: 110 }
			      , { field: 'rtrvCnt',		label: '조회',		sortable: false, 	align:'center',	width: 70  }
		  	      , { id: 'attachDownBtn',  label: '첨부',                                          width: 85
		  	    	  ,renderer: function(val, p, record, row, i){
		  	    		  var recordFilId = nullToString(record.data.attcFilId);
		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'knldPolicy', '*' ,'R')";
		  	    		  return Rui.isUndefined(record.get('attcFilId')) ? '' : '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
                      }}
              ]
          });


          qnaGrid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: qnaDataSet,
              width: 600,
              height: 400,
              autoToEdit: false,
              autoWidth: true
          });


          qnaGrid.on('cellClick', function(e) {

	           if(e.colId == "titlNm") {
	        	   var record = qnaDataSet.getAt(qnaDataSet.getRow());
	        	   document.aform.qnaId.value = record.get("qnaId");

	        	   qnaDataSet.load({
	                    url: '<c:url value="/knld/qna/updateGeneralQnaRtrvCnt.do"/>',
	                    params :{
	                    	qnaId : record.get("qnaId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/knld/qna/generalQnaInfo.do'/>");
                }

           });

          qnaGrid.render('defaultGrid');

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
                 	qnaDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
           getQnaList = function() {
        	   qnaDataSet.load({
                   url: '<c:url value="/knld/qna/getGeneralQnaList.do"/>',
                   params :{
                   	titlNm : escape(encodeURIComponent(document.aform.titlNm.value)),
                   	rgstNm : escape(encodeURIComponent(document.aform.rgstNm.value)),
                   	qustClCd : document.aform.qustClCd.value,
                   	strtDt : document.aform.strtDt.value,
                   	fnhDt : document.aform.fnhDt.value
                   }
               });
           };

           qnaDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + qnaDataSet.getCount() + '건');
  	    		// 목록 페이징
  		    	paging(qnaDataSet,"defaultGrid");
  	      	});

           //getQnaList();
       });
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncQnaRgstPage (일반QnA 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncQnaRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.qnaId.value = record.get("qnaId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/knld/qna/generalQnaRgst.do'/>")
}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

	// 엑셀 다운로드시 전체 다운로드를 위해 추가
	qnaDataSet.clearFilter();

    if( qnaDataSet.getCount() > 0){
        var excelColumnModel = columnModel.createExcelColumnModel(false);
        duplicateExcelGrid(excelColumnModel);
    	nG.saveExcel(toUTF8('일반Q&A 목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	alert('조회된 데이타가 없습니다.!!');
    }

	// 목록 페이징
    paging(qnaDataSet,"defaultGrid");
}

init = function() {
	   var titlNm='${inputData.titlNm}';
	   var rgstNm='${inputData.rgstNm}';
	   qnaDataSet.load({
         url: '<c:url value="/knld/qna/getGeneralQnaList.do"/>',
         params :{
         	titlNm : escape(encodeURIComponent(titlNm)),
         	rgstNm : escape(encodeURIComponent(rgstNm)),
         	qustClCd : '${inputData.qustClCd}',
         	strtDt : '${inputData.strtDt}',
         	fnhDt : '${inputData.fnhDt}'
         }
     });
 }
</script>

    </head>
    <body onkeypress="if(event.keyCode==13) {getQnaList();}" onload="init();">
    <form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="qnaId" name="qnaId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />

   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
	        	</a>
   				<h2>일반 Q&A</h2>
   			</div>

			<div class="sub-content">
				<div class="search">
	                <div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style="width:400px;"/>
		   						<col style="width:120px;"/>
		   						<col style="width:200px"/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">제목</th>
		   							<td>
		   								<input type="text" id="titlNm" value="">
		   							</td>
		   						    <th align="right">질문유형</th>
		   							<td>
		   								<div id="qustClCd"></div>
		   							</td>
		   							<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">등록일</th>
		   							<td>
		   								<input type="text" id="strtDt" /><em class="gab"> ~ </em>
		   								<input type="text" id="fnhDt" />
		   							</td>
		   							<th align="right">등록자</th>
		    						<td>
		   								<input type="text" id="rgstNm" value="">
		    						</td>
		    						<td class="txt-right"><a style="cursor: pointer;" onclick="getQnaList();" class="btnL">검색</a></td>
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