<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: spaceEvToolUseMgmtList.jsp
 * @desc    : 분석기기 >  관리 > 공간평가 Tool 사용관리
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.07   			최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<%-- staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
%>


<script type="text/javascript">

	Rui.onReady(function(){
		/* grid */
		var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
	            { id: 'toolNm' },
	            { id: 'prctToDt' },
	            { id: 'prctTitl' },
	            { id: 'prctFromDt' },
	            { id: 'mchnPrctId' },
	            { id: 'saName' },
	            { id: 'lastMdfyId' },
	            { id: 'lastMdfyDt' },
	            { id: 'frstRgstId' },
	            { id: 'frstRgstDt' },
	            { id: 'prctDt' }
	        ]
	    });

		dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    	// 목록 페이징
	    	paging(dataSet,"mhcnGrid");
	    });

	    var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	{ field: 'toolNm', 	label: 'Tool', 	sortable: false, align: 'center', width: 360},
	            { field: 'prctTitl',  	label: '평가명', 	sortable: false, align: 'center', width: 439},
	            { field: 'saName',  	label: '사용자',	  	sortable: false, align: 'center', width: 250},
	            { field: 'prctDt',  	label: '사용일', 	sortable: false, align: 'center', width: 250},
	            { field: 'mchnPrctId',   hidden : true},
	            { field: 'lastMdfyId',  hidden : true},
	            { field: 'lastMdfyDt',  hidden : true},
	            { field: 'frstRgstId',  hidden : true},
	            { field: 'frstRgstDt',  hidden : true}
	        ]
	    });

	    var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width : 1180,
	        height: 400,
            autoWidth: true
	    });

	    grid.render('mhcnGrid');


	  	//평가명
	    var prctTitl = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'prctTitl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.prctTitl}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	  	//Tool
	    var toolNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'toolNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.toolNm}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	  	//사용자명
	    var saName = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'saName',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.saName}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });



	  //사용 시작일자
        prctToDt = new Rui.ui.form.LDateBox({
            applyTo: 'prctToDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            width: 100,
            dateType: 'string'
        });
        prctToDt.on('blur', function() {
            if(prctToDt.getValue() == "") {
                return;
            }
            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(prctToDt.getValue(),"-","")))) {
                Rui.alert('날자형식이 올바르지 않습니다.!!');
                prctToDt.setValue(new Date());
            }
        });

        //사용 종료일자
        prctFromDt = new Rui.ui.form.LDateBox({
            applyTo: 'prctFromDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            width: 100,
            dateType: 'string'
        });
        prctFromDt.on('blur', function() {
            if(prctFromDt.getValue() == "") {
                return;
            }
            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(prctFromDt.getValue(),"-","")))) {
                Rui.alert('날자형식이 올바르지 않습니다.!!');
                prctFromDt.setValue(new Date());
            }
        });




		fnSearch = function(){

			dataSet.load({
				url: '<c:url value="/mchn/mgmt/spaceEvToolUseMgmtSearchList.do"/>' ,
				params :{
					saName  : encodeURIComponent(document.aform.saName.value)	//사용자
					,prctTitl  : encodeURIComponent(document.aform.prctTitl.value)	//평가명
					,toolNm  : encodeURIComponent(document.aform.toolNm.value)	//Tool
        			,prctFromDt    : encodeURIComponent(document.aform.prctToDt.value)		//사용시작일자
        			,prctToDt    : encodeURIComponent(document.aform.prctFromDt.value)	//사용종료일자
	                }
			});
		};
		fnSearch();

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){

        	// 엑셀 다운로드시 전체 다운로드를 위해 추가
        	dataSet.clearFilter();

        	if(dataSet.getCount() > 0 ) {
	            var excelColumnModel = columnModel.createExcelColumnModel(false);
	            duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('공간성능평가 Tool사용관리_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        	// 목록 페이징
        	paging(dataSet,"mhcnGrid");
        });


	});		//end ready

</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="contents">
		 <div class="titleArea">
		 	<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>
			<h2>공간성능평가 Tool 사용관리</h2>
		</div>

		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" value="IRIDE0103"/>
				<input type="hidden" id="mchnPrctId" name="mchnPrctId" />
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
									<th align="right">Tool</th>
									<td>
										<input type="text" id=toolNm />
									</td>
									<th align="right">사용자</th>
									<td>
										<input type="text" id="saName" />
									</td>
									<td></td>
								</tr>
								<tr>
									<th align="right">평가명</th>
									<td>
										<input type="text" id="prctTitl" />
									</td>
									<th align="right">사용일</th>
		                            <td>
		                                <input type="text" id="prctToDt" /><em class="gab"> ~ </em><input type="text" id="prctFromDt" />
		                            </td>
		                            <td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
								</tr>
								</tbody>
						</table>
					</div>
				</div>
				<div class="titArea">
					<h3><span class="table_summay_number" id="cnt_text"></span></h3>
					<div class="LblockButton">
					<button type="button" id="butExcl">EXCEL</button>
					</div>
				</div>
				<div id="mhcnGrid"></div>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>
