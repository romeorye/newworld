
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabTeamGateist.jsp
 * @desc    : Technical Service >  신뢰성시험 > Team Gate 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.11.19  dongys   		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>

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
	            { id: 'teamGateId' },
	            { id: 'titl' },
	            { id: 'sbc' },
	            { id: 'cmplYn' },
	            { id: 'cmplNm' },
	            { id: 'evCnt' },
	            { id: 'attcFilId' },
	            { id: 'delYn' },
	            { id: 'frstRgstDt' },
	            { id: 'frstRgstId' },
	            { id: 'frstRgstNm' }
	        ]
	    });

		dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    	// 목록 페이징
	    	paging(dataSet,"teamGateGrid");
	    });

	    var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	{ field: 'titl', 			label:'제목' , 		sortable: false, align: 'left', width: 500},
	            { field: 'frstRgstNm', 		label:'등록자',   	sortable: false, align: 'center', width: 220},
	            { field: 'frstRgstDt',  	label:'등록일', 		sortable: false, align: 'center', width: 220},
	            { field: 'cmplNm',  		label:'완료여부', 	sortable: false, align: 'center', width: 200},
	            { field: 'evCnt',  			label:'참여인원', 	sortable: false, align: 'center', width: 185},
	            { field: 'sbc',  			hidden : true},
	            { field: 'teamGateId',  hidden : true},
	            { field: 'delYn',  		hidden : true},
	            { field: 'attcFilId',  	hidden : true},
	            { field: 'cmplYn',  	hidden : true},
	            { field: 'frstRgstId',  hidden : true}
	        ]
	    });

	    var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width : 1150,
	        height: 400,
            autoWidth: true
	    });

	    grid.render('teamGateGrid');

	    grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());
			var column = columnModel.getColumnAt(e.col, true);

			if(dataSet.getRow() > -1) {
				var teamGateId = record.get("teamGateId");
				var frstRgstId = record.get("frstRgstId");
				var cmplYn = record.get("cmplYn");
				var user='<c:out value="${inputData._userId}"/>';
				if(cmplYn=='Y'){
					document.aform.teamGateId.value = teamGateId;
					document.aform.action="<c:url value="/rlab/tmgt/rlabTeamGateCmpl.do"/>";
					document.aform.submit();
				}else{
					if(frstRgstId==user){
						document.aform.teamGateId.value = teamGateId;
						document.aform.action="<c:url value="/rlab/tmgt/rlabTeamGateRegEv.do"/>";
						document.aform.submit();
					}else{
						document.aform.teamGateId.value = teamGateId;
						document.aform.action="<c:url value="/rlab/tmgt/rlabTeamGateEv.do"/>";
						document.aform.submit();
					}
				}
			}
	 	});

		//제목
	    var titl = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'titl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.titl}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//완료여부 기기
		var cbCmplYn = new Rui.ui.form.LCombo({
			applyTo : 'cmplYn',
			name : 'cmplYn',
			defaultValue: '<c:out value="${inputData.cmplYn}"/>',
			width : 200,
			emptyText: '전체',
				items: [
	                   { code: 'Y', value: 'Y' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                   { code: 'N', value: 'N' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	                	]
		});

	     fnSearch = function() {
		    	dataSet.load({
		        url: '<c:url value="/rlab/tmgt/rlabTeamGateList.do"/>' ,
	        	params :{

	        		    titl : encodeURIComponent(document.aform.titl.value)		//기기명
	        	       ,cmplYn : document.aform.cmplYn.value		//완료 여부

		                }
	         });
	     }

    	/* [버튼] 평가 등록호출 */
    	var butRgst = new Rui.ui.LButton('butRgst');
    	butRgst.on('click', function() {
    		document.aform.action="<c:url value="/rlab/tmgt/rlabTeamGateReg.do"/>";
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
nG.saveExcel(encodeURIComponent('TeamGate_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        	// 목록 페이징
        	paging(dataSet,"teamGateGrid");
        });

        init = function() {
     	   var titl='${inputData.titl}';
           	dataSet.load({
                 url: '<c:url value="/rlab/tmgt/rlabTeamGateList.do"/>',
                 params :{
                	 titl : escape(encodeURIComponent(titl)),
                	 cmplYn : '${inputData.cmplYn}',
                 }
             });
         }

	});    //end ready



</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}" onload="init();">
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
	        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	        	<span class="hidden">Toggle 버튼</span>
        	</a>
			<h2>TEAM GATE</h2>
		</div>

		<div class="sub-content">

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="teamGateId" name="teamGateId" />
				<input type="hidden" id="delYn" name="delYn" />
				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="frstRgstId" name="frstRgstId" />

					<div class="search">
					<div class="search-content">
				<table>
					<colgroup>
						<col style="width: 120px;" />
                        <col style="width: 300px;" />
                        <col style="width: 120px;" />
                        <col style="width: 300px;" />
                        <col style="" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">제목</th>
							<td><input type="text" id="titl"/></td>
							<th align="right">완료여부</th>
							<td>
								<select id="cmplYn" name="cmplYn" />
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
						<button type="button" id="butRgst" name="butRgst">설문등록</button>
						<button type="button" id="butExcl" name="butExcl">EXCEL</button>
					</div>
				</div>
				<div id="teamGateGrid"></div>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>