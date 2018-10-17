<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlMachineList.jsp
 * @desc    : 분석기기 > open기기 > 보유기기 관리 > 기기예약 관리 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.31    IRIS05		최초생성
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
	            { id: 'prctTitl' },
	            { id: 'mchnNm' },
	            { id: 'teamNm' },
	            { id: 'rgstNm' },
	            { id: 'prctDt' },
	            { id: 'prctTim' },
	            { id: 'prctScnNm' },
	            { id: 'prctScnCd' },
	            { id: 'mchnCrgrNm' },
	            { id: 'mchnCrgrId' },
	            { id: 'mchnPrctId' },
	            { id: 'mchnInfoId' }
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
	        	{ field: 'prctTitl', 	label: '신청제목', 	sortable: false, align: 'left', width: 330},
	            { field: 'mchnNm',  	label: '기기명', 	sortable: false, align: 'left', width: 300},
	            { field: 'teamNm',  	label: '팀',	  	sortable: false, align: 'center', width: 240},
	            { field: 'rgstNm',  	label: '예약자', 	sortable: false, align: 'center', width: 82},
	            { field: 'prctDt', 		label: '예약일', 	sortable: false, align: 'center', width: 90},
	            { field: 'prctTim', 	label: '예약시간',	sortable: false, align: 'center', width: 100},
	            { field: 'prctScnNm', 	label: '구분',   	sortable: false, align: 'center', width: 90},
	            { field: 'mchnCrgrNm', 	label: '담당자' , 	sortable: false, align: 'center', width: 92},
	            { field: 'prctScnCd',   hidden : true},
	            { field: 'mchnCrgrId',  hidden : true},
	            { field: 'mchnPrctId',  hidden : true},
	            { field: 'mchnInfoId',  hidden : true}
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

	    grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());
			if(dataSet.getRow() > -1) {
				document.aform.mchnPrctId.value = record.get("mchnPrctId");
				document.aform.action="<c:url value="/mchn/open/appr/retrieveMchnApprDtl.do"/>";
				document.aform.submit();
			}
	 	});

	  	//신청제목
	    var prctTitl = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'prctTitl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.prctTitl}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	  	//예약자
	    var rgstNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'rgstNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.rgstNm}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	  	//기기명
	    var mchnNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.mchnNm}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	  	//구분
	 // 상태combo
		var cbPrctScnCd = new Rui.ui.form.LCombo({
			applyTo : 'prctScnCd',
			name : 'prctScnCd',
			defaultValue: '<c:out value="${inputData.prctScnCd}"/>',
			useEmptyText: true,
	           emptyText: '전체',
	           url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MCHN_APPR_RQ_ST"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD',
	     });

		cbPrctScnCd.getDataSet().on('load', function(e) {
           console.log('cbPrctScnCd :: load');
       	});

		fnSearch = function(){

			dataSet.load({
				url: '<c:url value="/mchn/open/appr/retrieveMchnApprSearchList.do"/>' ,
				params :{
					 prctTitl  : encodeURIComponent(document.aform.prctTitl.value)	//신청제목
        			,rgstNm    : encodeURIComponent(document.aform.rgstNm.value)		//예약자
        			,mchnNm    : encodeURIComponent(document.aform.mchnNm.value)	//기기명
        			,prctScnCd : document.aform.prctScnCd.value		//상태
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
nG.saveExcel(encodeURIComponent('분석기기 예약관리_') + new Date().format('%Y%m%d') + '.xls', {
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
			<h2>기기예약 관리</h2>
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
									<th align="right">신청제목</th>
									<td>
										<input type="text" id="prctTitl" />
									</td>
									<th align="right">예약자</th>
									<td>
										<input type="text" id="rgstNm" />
									</td>
									<td></td>
								</tr>
								<tr>
									<th align="right">기기명</th>
									<td>
										<input type="text" id="mchnNm" />
									</td>
									<th align="right">구분</th>
									<td>
										<select id= "prctScnCd"></select>
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
