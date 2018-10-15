<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: rfpList.jsp
 * @desc    : RFP 요청서>  RFP 요청서 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.01.16     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">

var adminYn = "N";

	Rui.onReady(function() {

		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
			adminYn ="Y";
		}else if("<c:out value='${inputData._userSabun}'/>".indexOf('00207583') > -1) {
			adminYn ="Y";
		}

		/*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
         dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
            	  { id: 'rfpId'}
            	 ,{ id: 'title'}
            	 ,{ id: 'reqDate'}
            	 ,{ id: 'rsechEngn'}
            	 ,{ id: 'descTclg'}
            	 ,{ id: 'exptAppl'}
            	 ,{ id: 'mainReq'}
            	 ,{ id: 'benchMarkTclg'}
            	 ,{ id: 'colaboTclg'}
            	 ,{ id: 'timeline'}
            	 ,{ id: 'comments'}
            	 ,{ id: 'companyNm'}
            	 ,{ id: 'rgstNm'}
            	 ,{ id: 'submitYn'}
 			]
         });

         dataSet.on('load', function(e){
 	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
 	    	// 목록 페이징
	    	paging(dataSet,"rfpGrid");
 	     });

         var columnModel = new Rui.ui.grid.LColumnModel({
             groupMerge: true,
             columns: [
            	 new Rui.ui.grid.LNumberColumn(),
            	 { field: 'title',    	label:'TITLE' , 			sortable: false, align: 'left', width: 200},
                 { field: 'reqDate',    label:'RequestDate' , 		sortable: false, align: 'center', width: 200},
                 { field: 'rsechEngn',  label:'ResearchEngineer', 	sortable: false, align: 'left', width: 200},
                 { field: 'rgstNm',    	label:'등록자', 			sortable: false, align: 'center', width: 200},
                 { field: 'submitYn',   label:'제출여부', 			sortable: false, align: 'center', width: 200},
                 { field: 'rfpId',  hidden : true}
             ]
         });


         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             height: 400,
             width : 1200,
             autoWidth:true
         });

        grid.render('rfpGrid');

        grid.on('cellClick', function(e) {
 			var record = dataSet.getAt(dataSet.getRow());

 			document.aform.rfpId.value = record.get("rfpId");
    	   	nwinsActSubmit(document.aform, "<c:url value="/prj/tss/rfp/rfpReg.do"/>");
 	 	});

       //과제명
  	    var title = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'title',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        defaultValue: '<c:out value="${inputData.title}"/>',
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

       //기관명
  	    var rgstNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'rgstNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        defaultValue: '<c:out value="${inputData.rgstNm}"/>',
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });

        fnSearch = function() {
 	    	dataSet.load({
 	            url: '<c:url value="/prj/tss/rfp/retrieveRfpSearchList.do"/>',
 	            params :{
 	            	  title  : encodeURIComponent(document.aform.title.value)
 	            	 ,rgstNm : encodeURIComponent(document.aform.rgstNm.value)
 	            	 ,adminYn : adminYn
 	    	          }
             });
        }

        fnSearch();

        /* [버튼] : 신규 페이지로 이동 */
        var butRgst = new Rui.ui.LButton('butRgst');

		butRgst.on('click', function(){
			document.aform.action='<c:url value="/prj/tss/rfp/rfpReg.do"/>';
			document.aform.submit();
		});

		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butRgst").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butRgst").hide();
		}


	});

</script>
</head>

<body onkeypress="if(event.keyCode==13) {fnSearch();}">
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
	          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	          <span class="hidden">Toggle 버튼</span>
			</a>
		<h2>RFP 요청서 목록</h2>
    </div>
  	<div class="sub-content">
			<form name="aform" id="aform" method="post">
			<input type="hidden" id="rfpId"  name="rfpId" />

  				<div class="search">
					<div class="search-content">
		                <table>
		  					<colgroup>
		  						<col style="width:120px" />
								<col style="width:200px" />
								<col style="width:120px" />
								<col style="width:400px" />
								<col style="" />
		  					</colgroup>
		  					<tbody>
		  					    <tr>
		  							<th align="right">RFP제목</th>
		  							<td>
										<input type="text"  id="title" >
		  							</td>
		  							<th align="right">등록자</th>
			   						<td>
			   							<input type="text" id="rgstNm" >
			   						</td>
		   							<td class="txt-right">
		  								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
		  							</td>
		  						</tr>
		  					</tbody>
		  				</table>
	  				</div>
  				</div>
  				<div class="titArea">
  					<span class=table_summay_number id="cnt_text"></span>
					<div class="LblockButton">
  						<button type="button" id="butRgst" name="butRgst" >신규</button>
  					</div>
  				</div>
  				<div id="rfpGrid"></div>
		</form>
  		</div><!-- //sub-content -->
</div><!-- //contents -->
</body>
</html>