<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlMachineList.jsp
 * @desc    : 분석기기 > open기기 > 기기교육 > 기기교육목록 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.04    IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>


<script type="text/javascript">

	Rui.onReady(function(){
		/* grid */
		var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
        		 {id: 'eduScnNm'}           //모집상태
        		,{id: 'eduNm'}           	//교육명
        		,{id: 'pttDt'}           	//신청기간
        		,{id: 'mchnNm'}           	//기기명
        		,{id: 'ivttCpsn'}            //모집인원
        		,{id: 'eduDtTim'}          //교육일시
        		,{id: 'eduPl'}              //교육장소
        		,{id: 'eduCrgrNm'}          //교육 담당자명
        		,{id: 'eduCrgrId'}          //교육 담당자 ID
	        	,{id: 'mchnEduId' }          //기기 교육 ID
        		,{id: 'mchnInfoId'}         //기기 정보 ID
        		 ]
	    });

		dataSet.on('load', function(e){
        	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    });

	    var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	 {field: 'eduScnNm'           ,label:'상태' ,		sortable: false, align: 'center', 	width: 80}
	        	,{field: 'eduNm'              ,label:'교육명'   ,   sortable: false, align: 'left', 	width: 260}
	        	,{field: 'pttDt'              ,label:'신청기간' ,   sortable: false, align: 'center', 	width: 160}
	        	,{field: 'mchnNm'             ,label:'기기명'   ,   sortable: false, align: 'left', 	width: 240}
	        	,{field: 'eduDtTim'           ,label:'교육일시' ,   sortable: false, align: 'center', 	width: 140}
	        	,{field: 'eduPl'              ,label:'교육장소' ,   sortable: false, align: 'center', 	width: 120}
	        	,{field: 'ivttCpsn'           ,label:'모집인원' ,   sortable: false, align: 'center', 	width: 60}
	        	,{field: 'eduCrgrNm'          ,label:'담당자',		sortable: false, align: 'center', 	width: 70}
	        	,{field: 'mchnInfoId'         ,hidden : true}
	        	,{field: 'mchnEduId'          ,hidden : true}
	        	,{field: 'eduCrgrId'          ,hidden : true}

	        ]
	    });

	    var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width:1150,
	        height: 540,
	    });

	    grid.render('mhcnGrid');

	    grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());
			if(dataSet.getRow() > -1) {
				document.aform.mchnEduId.value = record.get("mchnEduId");
				document.aform.action="<c:url value="/mchn/open/edu/retrieveEduInfo.do"/>";
				document.aform.submit();
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

	 	// 상태combo
		var cbPttYn = new Rui.ui.form.LCombo({
			applyTo : 'pttYn',
			name : 'pttYn',
			defaultValue: '<c:out value="${inputData.pttYn}"/>',
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

		//교육일 
		var frEduDt = new Rui.ui.form.LDateBox({
			applyTo: 'frEduDt',
			mask: '9999-99-99',
			defaultValue: '<c:out value="${inputData.frEduDt}"/>',
			width: 100,
			dateType: 'string'
		});
		
		//교육일 
		var toEduDt = new Rui.ui.form.LDateBox({
			applyTo: 'toEduDt',
			mask: '9999-99-99',
			defaultValue: '<c:out value="${inputData.toEduDt}"/>',
			width: 100,
			dateType: 'string'
		});
		
		fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/mchn/open/edu/retrieveMchnEduSearchList.do"/>',
				params :{
					 eduNm  : encodeURIComponent(document.aform.eduNm.value)	//교육명
        			,pttYn    : document.aform.pttYn.value		//상태
        			,eduScnCd : rdEduScnCd.getValue() //document.aform.eduScnCd.value		//모집구분rdEduScnCd.getValue()
        			,frEduDt : frEduDt.getValue() //document.aform.eduScnCd.value		//모집구분rdEduScnCd.getValue()
        			,toEduDt : toEduDt.getValue() //document.aform.eduScnCd.value		//모집구분rdEduScnCd.getValue()
	                }
			});
		}

		fnSearch();

		
	});		//end ready

</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="contents">
		 <div class="titleArea">
			<h2>기기교육</h2>
		</div>

		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" value="IRIDE0104"/>
				<input type="hidden" id="mchnEduId" name="mchnEduId" />
				
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
							<th align="right">상태</th>
							<td>
								<select id="pttYn"></select>
							</td>
							<td rowspan="2" class="t_center"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
						</tr>
						<tr>
							<th align="right">교육구분</th>
							<td>
								<div id="eduScnCd"></div>
							</td>
							<th align="right">교육일</th>
							<td>
								<input type="text" id="frEduDt" /><em class="gab"> ~ </em>	<input type="text" id="toEduDt" />
							</td>
						</tr>
						
						
						
						</tbody>
				</table>
				<!-- <div class="titArea">
					<h3></h3>
					<div class="LblockButton">
						<button type="button" id="butExcl">EXCEL다운로드</button>
					</div>
				</div> -->
				<br>
				<br>
				<span class="table_summay_number" id="cnt_text"></span>
				<div id="mhcnGrid"></div>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>