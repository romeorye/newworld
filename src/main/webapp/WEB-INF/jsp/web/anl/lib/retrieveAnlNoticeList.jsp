<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: AnlNoticeList.jsp
 * @desc    : 공지사항 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.26  			최초생성
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
var anlNoticeDataSet;	// 프로젝트 데이터셋
var anlNoticeGrid;       // 그리드
var roleId = '${inputData._roleId}';
var roleIdIndex = roleId.indexOf("WORK_IRI_T06");

	Rui.onReady(function() {
       /*******************
        * 변수 및 객체 선언
        *******************/
        /* 검색 코드 */
        var searchCd = new Rui.ui.form.LCombo({
             applyTo: 'searchCd',
             name: 'searchCd',
             useEmptyText: true,
             emptyText: '선택',
             width: 150,
             items: [
                 { value: 'bbsTitlCode',    text: '제목'},
                 { value: 'bbsSbcCode',     text: '내용'},
                 { value: 'rgstNmCode',     text: '등록자'},
                 { value: 'bbsTitlSbcCode', text: '제목+내용'}
             ]
        });

        /* 검색 내용 */
        var searchNm = new Rui.ui.form.LTextBox({
             applyTo: 'searchNm',
             width: 600
        });

        searchNm.on('keyup', function(e) {
			if(e.keyCode == 13 && document.aform.searchCd.value != '') {
				getAnlNoticeList();
			}
        });

       	/* [버튼] 신규 등록 */
       	var rgstBtn = new Rui.ui.LButton('rgstBtn');
       	rgstBtn.on('click', function() {
       		fncAnlNoticeRgstPage('');
       	});

      //분석담당자만 등록 버튼 보이기
        chkUserRgst = function(display){
		    	 if(display) {
		    		 rgstBtn.show();
	 	         }else {
	 	        	rgstBtn.hide();
	 	         }
        }

    	/** dataSet **/
    	anlNoticeDataSet = new Rui.data.LJsonDataSet({
    	    id: 'anlNoticeDataSet',
    	    remainRemoved: true,
    	    lazyLoad: true,
    	    //defaultFailureHandler:false,
    	    fields: [
				      { id: 'bbsId' }     /*게시판ID*/
					, { id: 'bbsCd' }     /*분석게시판코드*/
					, { id: 'bbsNm' }     /*게시판명*/
					, { id: 'bbsTitl'}    /*게시판제목*/
					, { id: 'bbsSbc' }    /*게시판내용*/
					, { id: 'rgstId' }    /*등록자ID*/
					, { id: 'rgstNm' }    /*등록자이름*/
					, { id: 'rtrvCt' }    /*조회건수*/
					, { id: 'bbsKwd' }    /*키워드*/
					, { id: 'attcFilId' } /*첨부파일ID*/
					, { id: 'frstRgstDt'} /*등록일*/
					, { id: 'delYn' }     /*삭제여부*/
    		]
    	});


          var columnModel = new Rui.ui.grid.LColumnModel({
              columns: [
                    { field: 'bbsTitl',		label: '제목',    sortable: false,	align:'left',	width: 905 }
                  , { field: 'rgstNm',		label: '등록자',  sortable: false,	align:'center',	width: 100 }
                  , { field: 'frstRgstDt',	label: '등록일',  sortable: false,	align:'center',	width: 100 }
			      , { field: 'rtrvCt',		label: '조회',	  sortable: false, 	align:'center',	width: 60  }
              ]
          });

          anlNoticeGrid = new Rui.ui.grid.LGridPanel({
              columnModel: columnModel,
              dataSet: anlNoticeDataSet,
              width: 600,
              height: 400,
              autoToEdit: false,
              autoWidth: true
          });

          anlNoticeGrid.on('cellClick', function(e) {

	           if(e.colId == "bbsTitl") {
	        	   var record = anlNoticeDataSet.getAt(anlNoticeDataSet.getRow());
	        	   document.aform.bbsId.value = record.get("bbsId");
	        	   document.aform.bbsCd.value = record.get("bbsCd");

	        	   anlNoticeDataSet.load({
	                    url: '<c:url value="/anl/lib/updateAnlNoticeRtrvCnt.do"/>',
	                    params :{
	                    	bbsId : record.get("bbsId")
	                    }
	                });

                    nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlNoticeInfo.do'/>");
                }

           });

          anlNoticeGrid.render('defaultGrid');

           /* 조회, 검색 */
           getAnlNoticeList = function() {
        	   anlNoticeDataSet.load({
                   url: '<c:url value="/anl/lib/getAnlNoticeList.do"/>',
                   params :{
                	   bbsCd : '00',
                	   searchCd : escape(encodeURIComponent(document.aform.searchCd.value)),
                   	   searchNm : escape(encodeURIComponent(document.aform.searchNm.value))
                   }
               });
           };

           anlNoticeDataSet.on('load', function(e) {
  	    		$("#cnt_text").html('총 ' + anlNoticeDataSet.getCount() + '건');

  	    		if(roleIdIndex != -1) {
  	    			chkUserRgst(true);
                }

  	    		// 목록 페이징
  		    	paging(dataSet,"defaultGrid");
  	      	});

           getAnlNoticeList();
           chkUserRgst(false);

       });//onReady 끝
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncAnlNoticeRgstPage (공지사항 등록 )
* FUNCTION 기능설명 :
*******************************************************************************/--%>
function fncAnlNoticeRgstPage(record) {

	var pageMode = 'V';	// view

	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.bbsId.value = record.get("bbsId");
	}

	nwinsActSubmit(document.aform, "<c:url value='/anl/lib/anlNoticeRgst.do'/>")

}

</script>

    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="bbsId" name="bbsId" value=""/>
		<input type="hidden" id="bbsCd" name="bbsCd" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="" />

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
		   						<col style="width:10%;"/>
		   						<col style="width:30%;"/>
		   						<col style="width:15%;"/>
		   						<col style="width:"/>
		   						<col style="width:10%;"/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th  align="right">
		   								<div id="searchCd"></div>
		   							</th>
		   							<td>
		   								<input type="text" id="searchNm" value="">
		   							</td>
		   							<td class="t_center">
		   								<a style="cursor: pointer;" onclick="getAnlNoticeList();" class="btnL">검색</a>
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

   				<div id="defaultGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>