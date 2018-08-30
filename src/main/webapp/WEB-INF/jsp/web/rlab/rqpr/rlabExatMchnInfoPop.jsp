<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMachineLis.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 등록 > 고정자산 조회 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.28     IRIS05		최초생성
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<%-- rui Validator --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/validate/LCustomValidator.js"></script>

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
        		 {id: 'mchnNm'}          //기기명
        		,{id: 'mdlNm'}           //모델명
        		,{id: 'mkrNm'}           //제조사
        		,{id: 'mchnClNm'}        //대분류
        		,{id: 'mchnClDtlNm'}        //소분류
        		,{id: 'mchnCrgrNm'}      //담당자
        		,{id: 'mchnInfoId'}      //기기 정보 ID
        		 ]
	    });

		var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	 {field: 'mchnNm'     ,label:'기기명' ,	sortable: false, align: 'center', width: 260}
	        	,{field: 'mdlNm'      ,label:'모델명' , sortable: false, align: 'center', width: 130}
	        	,{field: 'mkrNm'      ,label:'제조사' , sortable: false, align: 'center', width: 130}
	        	,{field: 'mchnClNm'   ,label:'대분류'   , sortable: false, align: 'center', width: 130}
	        	,{field: 'mchnClDtlNm'   ,label:'소분류'   , sortable: false, align: 'center', width: 100}
	        	,{field: 'mchnCrgrNm' ,label:'담당자' , sortable: false, align: 'center', width: 100}
	        	,{field: 'mchnInfoId' ,hidden : true}
	        ]
	    });

	    var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        height: 300,
	        scrollerConfig: {
	            scrollbar: 'y'
	        },
	        autoToEdit: true,
	        autoWidth: true
	    });

	    grid.render('mhcnGrid');

	    grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());

			if(dataSet.getRow() > -1) {
				if(!parent.setMchnInfoCheck(record)){
					return;
				}
				parent._callback(record);
				parent.mchnDialog.submit(true);
			}
     	});

		//기기명
		var mchnNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//담당자명
		var mchnCrgrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnCrgrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//분류
		var rdMchnClCd = new Rui.ui.form.LRadioGroup({
	            applyTo : 'mchnClCd',
	            name : 'mchnClCd',
	            items : [
	            	{label : '전체', 				value : 'ALL'},
	            	{label : '장식재 사계절 시험', 	value : '01'},
	            	{label : '내후/내광성 시험', 	value : '02'},
	            	{label : '옥외폭로 시험', 		value : '03'},
	            	{label : '환경챔버 시험', 		value : '04'},
	            	{label : '측정,평가,분석', 		value : '05'}
	            ]
	    });

		fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/rlab/retrieveMachineList.do"/>',
				params :{
					 mchnNm  : encodeURIComponent(document.aform.mchnNm.value)	//기기명
					,mchnCrgrNm  : encodeURIComponent(document.aform.mchnCrgrNm.value)	//담당자명
					,mchnClCd  : rdMchnClCd.getValue()	//기기
	                }
			});
		}

		fnSearch();

	});			//end Ready

</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="bd">
		<div class="sub-content">

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" />

				<table class="searchBox">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">기기명</th>
							<td>
								<span>
									<div id="mchnNm"></div>
								</span>
							</td>
							<th align="right">담당자</th>
							<td>
								<div id="mchnCrgrNm"></div>
							</td>
							<td rowspan="1" class="t_center"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
						</tr>
						<tr>
							<th align="right">대분류</th>
							<td colspan="4">
								<div id="mchnClCd"></div>
							</td>
						</tr>
					</tbody>
				</table>
			<BR/>
			<div id="mhcnGrid"></div>

			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>