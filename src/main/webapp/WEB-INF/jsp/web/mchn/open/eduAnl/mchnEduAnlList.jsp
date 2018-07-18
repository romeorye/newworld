<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: mchnEduAnlList.jsp
 * @desc    : 분석기기 > open기기 > 기기교육 > 기기교육관리목록 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.05    IRIS05		최초생성
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
        		 {id: 'eduNm'}           	//교육명
        		,{id: 'pttDt'}           	//신청기간
        		,{id: 'mchnNm'}           	//기기명
        		,{id: 'eduDtTim'}          //교육일시
        		,{id: 'eduPl'}              //교육장소
        		,{id: 'ivttCpsn'}            //모집인원
        		,{id: 'eduCrgrNm'}          //교육 담당자명
        		,{id: 'eduCrgrId'}          //교육 담당자 ID
	        	,{id: 'mchnEduId' }          //기기 교육 ID
        		,{id: 'mchnInfoId'}         //기기 정보 ID
        		 ]
	    });

		var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	 {field: 'eduNm'              ,label:'교육명'   ,    sortable: false, align: 'left', width: 250}
	        	,{field: 'pttDt'              ,label:'신청기간' ,      sortable: false, align: 'center', width: 150}
	        	,{field: 'mchnNm'             ,label:'기기명'   ,    sortable: false, align: 'left', width: 230}
	        	,{field: 'eduDtTim'           ,label:'교육일시' ,      sortable: false, align: 'center', width: 150}
	        	,{field: 'eduPl'              ,label:'교육장소' ,    sortable: false, align: 'center', width: 100}
	        	,{field: 'ivttCpsn'           ,label:'모집인원' ,    sortable: false, align: 'center', width: 70}
	        	,{field: 'eduCrgrNm'          ,label:'교육담당자명',	sortable: false, align: 'center', width: 100}
	        	,{ id: 'btn', label: '신청', width: 80, renderer: function(val, p, record, row, i){
	                return '<button type="button" class="L-grid-button">관리</button>';
	            } },
	        	,{field: 'eduCrgrId'          ,hidden : true}
	        	,{field: 'mchnEduId'          ,hidden : true}
	        	,{field: 'mchnInfoId'         ,hidden : true}

	        ]
	    });

		dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    });

		var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width: 1150,
	        height: 540
	    });

		grid.render('mhcnGrid');

		grid.on('cellClick', function(e){
			var record = dataSet.getAt(dataSet.getRow());
			var column = columnModel.getColumnAt(e.col, true);
			
			if(dataSet.getRow() > -1) {
				if(column.id == 'btn') {
					document.aform.mchnEduId.value = dataSet.getValue(dataSet.getRow(),  dataSet.getFieldIndex('mchnEduId'));
			        document.aform.mchnInfoId.value = dataSet.getValue(dataSet.getRow(),  dataSet.getFieldIndex('mchnInfoId'));
					document.aform.action="<c:url value="/mchn/open/eduAnl/retrieveEduRgstList.do"/>";
					document.aform.submit();
				}else{
					document.aform.mchnEduId.value = record.get("mchnEduId");
					document.aform.action='<c:url value="/mchn/open/eduAnl/retrieveMchnEduAnlInfo.do"/>';
					document.aform.submit();
				}
			}
		});

		//교육명
	    var eduNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'eduNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.eduNm}"/>',
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

	 	// 상태combo
		var cbPttYn = new Rui.ui.form.LCombo({
			applyTo : 'pttYn',
			defaultValue: '<c:out value="${inputData.pttYn}"/>',
			name : 'pttYn',
			emptyText: '선택하세요',
				items: [
					{ text: '접수중', value: 'IN'},
                    { text: '마감', value: 'CLS' }
	                ]
		});

		//모집상태
		var rdEduScnCd = new Rui.ui.form.LRadioGroup({
	            applyTo : 'eduScnCd',
	            name : 'eduScnCd',
	            defaultValue: '<c:out value="${inputData.eduScnCd}"/>',
	            items : [
	                    {label : '전체',  value : 'ALL', checked: true},
	                    {label : '수시',  value : 'NRGL'},
	                    {label : '정시',  value : 'REGL'}
	            ]
	     });
		
	    fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/mchn/open/eduAnl/retrieveMchnEduAnlSearchList.do"/>',
				params :{
					 eduNm  : encodeURIComponent(document.aform.eduNm.value)	//교육명
					,mchnNm  : encodeURIComponent(document.aform.mchnNm.value)	//교육명
        			,pttYn    : document.aform.pttYn.value		//상태
        			,eduScnCd : rdEduScnCd.getValue()		//교육구분
	                }
			});
		}

		fnSearch();

		 /* [버튼] 신규기기 등록호출 */
    	var butRgst = new Rui.ui.LButton('butRgst');
    	butRgst.on('click', function() {
    		document.aform.action='<c:url value="/mchn/open/eduAnl/retrieveMchnEduAnlInfo.do"/>';
    		document.aform.submit();
    	});


	});		//end ready


</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="contents">
		 <div class="titleArea">
			<h2>기기교육 관리</h2>
		</div>
		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" value="IRIDE0105"/>
				<input type="hidden" id="mchnEduId" name="mchnEduId" />
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
							<th align="right">교육명</th>
							<td>
								<input type="text" id="eduNm" />
							</td>
							<th align="right">기기명</th>
							<td>
								<input type="text" id="mchnNm" />
							</td>
							<td rowspan="2" class="t_center"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
						</tr>
						<tr>
							<th align="right">교육구분</th>
							<td>
								<div id="eduScnCd"></div>
							</td>
							<th align="right">상태</th>
							<td>
								<select id="pttYn"></select>
							</td>
						</tr>
						</tbody>
				</table>
				<div class="titArea">
					<span class="table_summay_number" id="cnt_text"></span>
					<div class="LblockButton">
						<button type="button" id="butRgst" name="butRgst">신규교육</button>
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