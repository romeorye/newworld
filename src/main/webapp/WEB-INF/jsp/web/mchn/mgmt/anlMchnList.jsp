<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMachineLis.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 관리
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.24     IRIS05		최초생성
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

	Rui.onReady(function(){
		/*******************
	 	* 변수 및 객체 선언
	 	*******************/
		/* grid */
		var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
	            { id: 'mchnNm' },
	            { id: 'fxaNo' },
	            { id: 'mdlNm' },
	            { id: 'mkrNm' },
	            { id: 'mchnClNm' },
	            { id: 'opnYn' },
	            { id: 'mchnCrgrNm' },
	            { id: 'mchnUsePsblNm' },
	            { id: 'mchn' },
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
	        	{ field: 'mchnNm', 			label:'기기명' , 	sortable: false, align: 'left', width: 400},
	            { field: 'fxaNo',  			label:'자산번호', 	sortable: false, align: 'center', width: 120},
	            { field: 'mdlNm',  			label:'모델명', 	sortable: false, align: 'center', width: 220},
	            { field: 'mkrNm',  			label:'제조사', 	sortable: false, align: 'center', width: 150},
	            { field: 'mchnClNm', 		label: '분류', 		sortable: false, align: 'center', width: 90},
	            { field: 'opnYn', 			label: 'OPEN',   	sortable: false, align: 'center', width: 60},
	            { field: 'mchnCrgrNm',  	label:'담당자' , 	sortable: false, align: 'center', width: 90},
	            { field: 'mchnUsePsblNm',  	label:'상태' , 		sortable: false, align: 'center', width: 100},
	            { id: 'btn', label: '기기', width: 95, renderer: function(val, p, record, row, i){
	                return '<button type="button" class="L-grid-button">관리</button>';
	            } },
	            { field: 'mchnInfoId',  hidden : true}
	        ]
	    });

	    var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width : 1150,
	        height: 400,
            autoWidth: true
	    });

	    grid.render('mhcnGrid');

	    grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());
			var column = columnModel.getColumnAt(e.col, true);

			if(dataSet.getRow() > -1) {
				if(column.id == 'btn') {
					document.aform.mchnInfoId.value = dataSet.getValue(dataSet.getRow(),  dataSet.getFieldIndex('mchnInfoId'));
					document.aform.action="<c:url value="/mchn/mgmt/mchnMgmtList.do"/>";
					document.aform.submit();
		        }else{
					var mchnInfoId = record.get("mchnInfoId");
					document.aform.mchnInfoId.value = mchnInfoId;
					document.aform.action="<c:url value="/mchn/mgmt/retrieveAnlMchnReg.do"/>";
					document.aform.submit();
		        }
			}
	 	});

		//기기명
	    var mchnNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.mchnNm}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		 //자산명
	    var fxaNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'fxaNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.fxaNo}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		 //담당자명
	    var mchnCrgrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnCrgrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        defaultValue: '<c:out value="${inputData.mchnCrgrNm}"/>',
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//분류 combo
		var cbMchnClCd = new Rui.ui.form.LCombo({
			applyTo : 'mchnClCd',
			name : 'mchnClCd',
			defaultValue: '<c:out value="${inputData.mchnClCd}"/>',
			useEmptyText: true,
	           emptyText: '(전체)',
	           url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MCHN_CL_CD"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD',
	    	width : 200
       	});

		cbMchnClCd.getDataSet().on('load', function(e) {
	          console.log('cbMchnClCd :: load');
	    });

		// 상태combo
		var cbMchnUsePsblYn = new Rui.ui.form.LCombo({
			applyTo : 'mchnUsePsblYn',
			name : 'mchnUsePsblYn',
			defaultValue: '<c:out value="${inputData.mchnUsePsblYn}"/>',
			useEmptyText: true,
	           emptyText: '(전체)',
	           url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MCHN_PRCT_ST"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD',
	    	width : 200
	     });

		cbMchnUsePsblYn.getDataSet().on('load', function(e) {
           console.log('cbMchnUsePsblYn :: load');
       	});

		//open 기기
		var cbOpnYn = new Rui.ui.form.LCombo({
			applyTo : 'opnYn',
			name : 'opnYn',
			defaultValue: '<c:out value="${inputData.opnYn}"/>',
			width : 200,
			emptyText: '(선택)',
				items: [
	                   { code: 'Y', value: 'Y' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: 'N', value: 'N' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                	]
		});

	     fnSearch = function() {
		    	dataSet.load({
		        url: '<c:url value="/mchn/mgmt/retrieveAnlMchnSearchList.do"/>' ,
	        	params :{
	        		    mchnNm : encodeURIComponent(document.aform.mchnNm.value)		//기기명
	        	       ,mchnClCd : document.aform.mchnClCd.value		//분류
	        	       ,fxaNo  : document.aform.fxaNo.value		//자산번호
	        	       ,opnYn : document.aform.opnYn.value		//오픈기기 여부
	        	       ,mchnCrgrNm : encodeURIComponent(document.aform.mchnCrgrNm.value) 	//담당자
	        	       ,mchnUserPsblYn : document.aform.mchnUsePsblYn.value	//상태
		                }
	         });
	     }

    	//fnSearch();

    	/* [버튼] 분석기기 등록호출 */
    	var butRgst = new Rui.ui.LButton('butRgst');
    	butRgst.on('click', function() {
    		document.aform.action="<c:url value="/mchn/mgmt/retrieveAnlMchnReg.do"/>";
    		document.aform.submit();
    	});

    	/* [버튼] 분석기기 등록호출 */
    	var butAll = new Rui.ui.LButton('butAll');
    	butAll.on('click', function() {
    		document.aform.action="<c:url value="/mchn/mgmt/retrieveAnlMchnAll.do"/>";
    		document.aform.submit();
    	});

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){

        	// 엑셀 다운로드시 전체 다운로드를 위해 추가
        	dataSet.clearFilter();

        	if(dataSet.getCount() > 0 ) {
	            var excelColumnModel = columnModel.createExcelColumnModel(false);
	            duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('분석기기_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}

        	// 목록 페이징
        	paging(dataSet,"mhcnGrid");
        });

        init = function() {
     	   var mchnNm='${inputData.mchnNm}';
     	   var fxaNo='${inputData.fxaNo}';
     	   var mchnCrgrNm='${inputData.mchnCrgrNm}';
           	dataSet.load({
                 url: '<c:url value="/mchn/mgmt/retrieveAnlMchnSearchList.do"/>',
                 params :{
                	 mchnNm : escape(encodeURIComponent(mchnNm)),
                	 fxaNo : escape(encodeURIComponent(fxaNo)),
                	 mchnCrgrNm : escape(encodeURIComponent(mchnCrgrNm)),
                 	mchnClCd : '${inputData.mchnClCd}',
                 	opnYn : '${inputData.opnYn}',
                 	mchnUserPsblYn : '${inputData.mchnUsePsblYn}'
                 }
             });
         }


	});    //end ready



</script>
<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
<style type="text/css">
.search-toggleBtn {display:none;}
</style>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}" onload="init();">
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>분석기기 관리</h2>
		</div>

		<div class="sub-content">

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" />

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
									<th align="right">기기명</th>
									<td><input type="text" id="mchnNm"/></td>
									<th align="right">분류</th>
									<td>
										<select  id="mchnClCd" ></select>
									</td>
									<td></td>
								</tr>
								<tr>
									<th align="right">자산번호</th>
									<td><input type="text" id="fxaNo" /></td>
									<th align="right">OPEN기기</th>
									<td>
										<select id="opnYn" name="opnYn" />
									</td>
									<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
								</tr>
								<tr>
									<th align="right">담당자</th>
									<td><input type="text" id="mchnCrgrNm" /></td>
									<th align="right">상태</th>
									<td>
										<select id="mchnUsePsblYn"></select>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="titArea">
					<span class="table_summay_number" id="cnt_text"></span>
					<div class="LblockButton">
						<button type="button" id="butAll">전체이력</button>
						<button type="button" id="butRgst" name="butRgst">기기등록</button>
						<button type="button" id="butExcl" name="butExcl">EXCEL</button>
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