<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlMachineList.jsp
 * @desc    : 분석기기 >  관리 > 소모품 관리
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.25     IRIS05		최초생성
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

		//grid dataset
		var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'cgdsNm'}
            	 ,{ id: 'mkrNm'}
            	 ,{ id: 'stkNo'}
            	 ,{ id: 'curIvQty'}
            	 ,{ id: 'prpIvQty'}
            	 ,{ id: 'utmCd'}
            	 ,{ id: 'ivStCd'}
            	 ,{ id: 'cgdCrgrNm'}
            	 ,{ id: 'cgdCrgrId'}
            	 ,{ id: 'cgdsId'}
            	 ,{ id: 'cgdsMgmtId'}
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
		        	{ field: 'cgdsNm', 		label:'소모품명' , 	sortable: false, align: 'left', width: 370},
		            { field: 'mkrNm',  		label:'제조사', 	sortable: false, align: 'center', width: 170},
		            { field: 'stkNo',  		label:'Stock No.', 	sortable: false, align: 'center', width: 160},
		            { field: 'curIvQty',  	label:'현재고', 	renderer: function(val, p, record, row, i){
		            	if( record.get('ivStCd') == "Y" ){
			            	return'<span style = "color : #FF5E00">'+val+'</span>';
		            	}else{
			            	return val;
		            	}
		            }, sortable: false, align: 'center', width: 110},
		            { field: 'prpIvQty', 	label: '적정재고', 	sortable: false, align: 'center', width: 120},
		            { field: 'utmCd', 		label: '단위',   	sortable: false, align: 'center', width: 130},
		            { field: 'cgdCrgrNm', 	label: '담당자',   	sortable: false, align: 'center', width: 150},
		            { id: 'btn', label: '소모품', width: 115, renderer: function(val, p, record, row, i){
		                return '<button type="button" class="L-grid-button">관리</button>';
		            } },
		            { field: 'cgdCrgrId',  		hidden : true},
		            { field: 'cgdsId',  		hidden : true},
		            { field: 'cgdsMgmtId',  	hidden : true}
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

 		//소모품명
		var cgdsNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'cgdsNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.cgdsNm}"/>',
	        placeholder: '소모품명을 입력하세요',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

 		//제조사
		var mkrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mkrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.mkrNm}"/>',
	        placeholder: '제조사를 입력하세요',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

 		//Stock No.
		var stkNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'stkNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.stkNo}"/>',
	        placeholder: 'Stock No를 입력하세요',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

 		//담당자명.
		var cgdCrgrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'cgdCrgrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.cgdCrgrNm}"/>',
	        placeholder: '담당명을 입력하세요',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		fnSearch = function() {
	    	dataSet.load({
	        url: '<c:url value="/mchn/mgmt/retrieveCdgsList.do"/>' ,
        	params :{
        			cgdsNm : encodeURIComponent(document.aform.cgdsNm.value)		//소모품명
        		   ,mkrNm : encodeURIComponent(document.aform.mkrNm.value)		//제조사
        		   ,stkNo : encodeURIComponent(document.aform.stkNo.value)		//Stock no
        	       ,cgdCrgrNm : encodeURIComponent(document.aform.cgdCrgrNm.value) 	//담당자
	                }
         	});
     	}

		fnSearch();

		grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());
			var column = columnModel.getColumnAt(e.col, true);

			if(dataSet.getRow() > -1) {

				if(column.id == 'btn') {
					document.aform.cgdsId.value = dataSet.getValue(dataSet.getRow(),  dataSet.getFieldIndex('cgdsId'));
					document.aform.action="<c:url value="/mchn/mgmt/retrieveCgdsMgmtList.do"/>";
					document.aform.submit();
				}else{
					var cgdsId = record.get("cgdsId");
					document.aform.cgdsId.value = cgdsId;
					document.aform.action="<c:url value="/mchn/mgmt/retrieveCgdgAnlDtl.do"/>";
					document.aform.submit();
				}


			}
	 	});

		/* [버튼] : 소모품등록 화면*/
    	var butReg = new Rui.ui.LButton('butReg');
    	butReg.on('click', function(){
    		document.aform.action='<c:url value="/mchn/mgmt/retrieveCgdgAnlDtl.do"/>';
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
nG.saveExcel(encodeURIComponent('소모품 목록_') + new Date().format('%Y%m%d') + '.xls', {
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
			<h2>소모품 관리</h2>
		</div>

		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" value="IRIED0202"/>
				<input type="hidden" id="cgdsId" name="cgdsId"  value="<c:out value='${inputData.cgdsId}'/>">

				<div class="search">
					<div class="search-content">
		                <table>
		                    <colgroup>
		                        <col style="width: 120px;" />
		                        <col style="width: 330px;" />
		                        <col style="width: 120px;" />
		                        <col style="width: 300px;" />
		                        <col style=" " />
		                    </colgroup>
							<tbody>
								<tr>
									<th align="right">소모품명</th>
									<td>
										<input type="text" id="cgdsNm"/>
									</td>
									<th align="right">제조사</th>
									<td>
										<input type="text" id="mkrNm"/>
									</td>
									<td></td>
								</tr>
								<tr>
									<th align="right">Stock No.</th>
									<td>
										<input type="text" id="stkNo"/>
									</td>
									<th align="right">담당자</th>
									<td>
										<input type="text" id="cgdCrgrNm"/>
									</td>
									<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
								</tr>
								</tbody>
						</table>
					</div>
				</div>
				<div class="titArea">
   					<span class="table_summay_number" id="cnt_text"></span>
					<div class="LblockButton">
   						<button type="button" id="butReg">소모품등록</button>
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