<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: mchnInfoStatList.jsp
 * @desc    : 통계 > open기기 사용 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.11.02    IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<title><%=documentTitle%></title>
<script type="text/javascript">

	Rui.onReady(function(){
		/* grid */
		var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
	            { id: 'mchnHanNm' },
	            { id: 'mchnEnNm' },
	            { id: 'mchnClNm' },
	            { id: 'mchnNm' },
	            { id: 'smpoNm' },
	            { id: 'smpoQty' },
	            { id: 'uperDeptNm' },
	            { id: 'deptNm' },
	            { id: 'rgstNm' },
	            { id: 'prctDt' },
	            { id: 'prctFromDt' },
	            { id: 'prctFromDt' },
	            { id: 'prctToDt' },
	            { id: 'prctToTim' },
	            { id: 'opnYn' },
	            { id: 'mchnUfeClCd' },
	            { id: 'mchnUfe' },
	            { id: 'useTim' }
	        ]
	    });

	    var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	{ field: 'mchnClNm', 	label: '분류', 			align: 'center', width: 60},
	            { field: 'mchnNm',  	label: '분석기기', 		align: 'left', 	 width: 260},
	            { field: 'uperDeptNm',  label: '사업부',		align: 'center', width: 130},
	            { field: 'deptNm',  	label: '팀(PJT)', 		align: 'center', width: 190},
	            { field: 'rgstNm',  	label: '예약자', 		align: 'center', width: 80},
	            { field: 'smpoNm', 		label: '시료명', 		align: 'center', width: 135},
	            { field: 'smpoQty', 	label: '시료수',		align: 'center', width: 55},
	            { field: 'prctFromDt', 	label: '시작일',   		align: 'center', width: 120},
	            { field: 'prctToDt', 	label: '종료일',   		align: 'center', width: 120},
	            { field: 'useTim', 		label: '사용시간',   	align: 'center', width: 80},
	            { field: 'mchnUfe', 	label: '기기이용료' , 	align: 'center', width: 95,
	               	 renderer: function(value, p, record){
	               		if(Rui.isEmpty(value)){
	               			value=0;
	               		}
	  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
	  		       }
	            }
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

	  	//분석기기
	    var mchnNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        emptyValue : '',
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });


	  	//신청 시작일
	  	var cbPrctFrDt = new Rui.ui.form.LDateBox({
             applyTo: 'prctFrDt',
             mask: '9999-99-99',
             displayValue: '%Y-%m-%d',
             defaultValue: '<c:out value="${inputData.prctFrDt}"/>',
             dateType: 'string'
        });
	  	//신청 종료일
	  	var cbPrctToDt = new Rui.ui.form.LDateBox({
             applyTo: 'prctToDt',
             mask: '9999-99-99',
             displayValue: '%Y-%m-%d',
             defaultValue: '<c:out value="${inputData.prctToDt}"/>',
             dateType: 'string'
        });

		fnSearch = function(){

			dataSet.load({
				url: '<c:url value="/stat/anl/retrieveMchnInfoStateList.do"/>' ,
				params :{
					 mchnNm  : encodeURIComponent(mchnNm.getValue())	//분석기기
        			,prctFrDt    : cbPrctFrDt.getValue()		//신청일
        			,prctToDt    : cbPrctToDt.getValue()	//신청일
	                }
			});
		};

		dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    	// 목록 페이징
	    	paging(dataSet,"mhcnGrid");
	    });

		fnSearch();

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){
        	// 엑셀 다운로드시 전체 다운로드를 위해 추가
        	dataSet.clearFilter();
        	if(dataSet.getCount() > 0 ) {
	            var excelColumnModel = columnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('OPEN기기_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        	// 목록 페이징
        	paging(dataSet,"defaultGrid");
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
			<h2>OPEN기기사용</h2>
		</div>

		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="mchnPrctId" name="mchnPrctId" />
				<div class="search">
			   		<div class="search-content">
						<table>
							<colgroup>
								<col style="width:120px" />
								<col style="width:160px" />
								<col style="width:120px" />
								<col style="" />
								<col style="" />
							</colgroup>
							<tbody>
								<tr>
									<th align="right">분석기기</th>
									<td>
										<input type="text" id="mchnNm" />
									</td>
									<th align="right">사용일</th>
									<td>
										<input type="text" id="prctFrDt" /><em class="gab"> ~ </em>	<input type="text" id="prctToDt" />
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
