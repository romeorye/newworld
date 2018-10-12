<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: prjMstList.jsp
 * @desc    : 연구팀(Project) > 현황 : 프로젝트 현황 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.08  소영창		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
<%-- <script type="text/javascript" src="/iris/resource/js/lgHs_common.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">
var dataSet;	// 프로젝트 데이터셋
var dm;         // 데이터셋매니저
var grid;       // 그리드
var roleCheck = "PER";

Rui.onReady(function() {

	if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
		roleCheck = "ADM";
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T03') > -1) {
		roleCheck = "ADM";
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
		roleCheck = "ADM";
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
		roleCheck = "ADM";
	}

	/** dateBox **/
	var fromDate = new Rui.ui.form.LDateBox({
		applyTo: 'fromDate',
		mask: '9999-99-99',
		displayValue: '%Y-%m-%d',
		//defaultValue: new Date(),
//		defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
		width: 100,
		dateType: 'string'
	});

	fromDate.on('blur', function(){
		if( nwinsReplaceAll(fromDate.getValue(),"-","") != "" && ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromDate.getValue(),"-","")) ) )  {
			alert('날자형식이 올바르지 않습니다.!!');
			fromDate.setValue(new Date());
		}
	});

	var toDate = new Rui.ui.form.LDateBox({
		applyTo: 'toDate',
		mask: '9999-99-99',
		displayValue: '%Y-%m-%d',
//		defaultValue: new Date(),
		width: 100,
		dateType: 'string'
	});

	toDate.on('blur', function(){
		if( nwinsReplaceAll(toDate.getValue(),"-","") != "" && ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toDate.getValue(),"-","")) ) )  {
			alert('날자형식이 올바르지 않습니다.!!');
			toDate.setValue(new Date());
		}
	});

	var ltWbsCd = new Rui.ui.form.LTextBox({
    	applyTo: 'wbsCd',
    	width : 200,
//    	inputType: Rui.util.LString.PATTERN_TYPE_STRING,
//    	imeMode: 'disabled' ,
    	defaultValue: '',
    	emptyValue: '',
    	attrs: {
    			maxLength: 6
    			}
    });
 	/*
 	ltWbsCd.on('blur', function(e) {
		ltWbsCd.setValue(ltWbsCd.getValue().trim());
    });
  */

	var ltSaName = new Rui.ui.form.LTextBox({
    	applyTo: 'saName',
    	width : 200,
    	defaultValue: '',
    	emptyValue: '',
    	attrs: {
    			maxLength: 10
    			}
    });
	ltSaName.on('blur', function(e) {
		ltSaName.setValue(ltSaName.getValue().trim());
    });

    var ltPrjNm = new Rui.ui.form.LTextBox({
    	applyTo: 'prjNm',
    	width : 200,
    	defaultValue: '',
    	emptyValue: '',
    	attrs: {
    			maxLength: 33
    			}
    });
    ltPrjNm.on('blur', function(e) {
    	ltPrjNm.setValue((ltPrjNm.getValue()).trim());
    });

    var deptName = new Rui.ui.form.LTextBox({
    	applyTo: 'deptName',
    	width : 200,
    	defaultValue: '',
    	emptyValue: ''
    });
    deptName.on('blur', function(e) {
    	deptName.setValue(deptName.getValue().trim());
    });

    /*
    var lpTbdeptNm = new Rui.ui.form.LPopupTextBox({
        applyTo: 'deptName',
        width: 260,
        editable: true,
        placeholder: '검색한 조직을 선택해주세요',
        emptyValue: '',
        enterToPopup: true
    });
    lpTbdeptNm.on('blur', function(e) {
    	lpTbdeptNm.setValue(lpTbdeptNm.getValue().trim());
    });
    lpTbdeptNm.on('popup', function(e){
    	openDeptSearchDialog(setDeptInfo,'prj');
    });

    setDeptInfo = function(deptInfo) {
    	lpTbdeptNm.setValue(deptInfo.upperDeptNm);
    };
    */


	/* [버튼] 프로젝트등록 */
	var lbButRgst = new Rui.ui.LButton('butRgst');
	lbButRgst.on('click', function() {
		fncPrjRgstPage('');
	});

    /* [버튼] EXCEL다운로드 */
	var lbButExcl = new Rui.ui.LButton('butExcl');
	lbButExcl.on('click', function() {
		fncExcelDown();
	});

	/** dataSet **/
	dataSet = new Rui.data.LJsonDataSet({
	    id: 'dataSet',
	    remainRemoved: true,
	    lazyLoad: true,
	    //defaultFailureHandler:false,
	    fields: [
	    	  { id: 'prjCd' }
			, { id: 'wbsCd' }
			, { id: 'prjNm' }
			, { id: 'deptCd'}
			, { id: 'saName'}
			, { id: 'uperdeptName'}
			, { id: 'deptName'}
			, { id: 'prjStrDt'}
			, { id: 'prjEndDt'}
		]
	});

	/** columnModel **/
	var columnModel = new Rui.ui.grid.LColumnModel({
		columns: [
			  { field: 'prjCd'        , hidden : true}
			, { field: 'wbsCd'        , label: 'WBS CODE',  		   sortable: false,	align:'center', width: 120 }
			, { field: 'prjNm'        , label: '프로젝트명(소속명)',   sortable: false,	align:'left', width: 530
				, renderer: function(value){
            		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
            	}}
			, { field: 'saName'       , label: 'PL 명',  			   sortable: false,	align:'center', width: 110 }
			, { field: 'deptCd'       , label: '조직코드',  		   sortable: false,	align:'center', width:0, hidden: true}
			, { field: 'uperdeptName' , label: '조직',  		       sortable: false,	align:'left', width: 308 }
			, { id : '프로젝트기간'},
			, { field: 'prjStrDt'     , groupId: '프로젝트기간', label: '시작일',      sortable: false, align:'center', width: 120 }
			, { field: 'prjEndDt'     , groupId: '프로젝트기간', label: '종료일',      sortable: false, align:'center', width: 120 }
	   ]
	});

	/** default grid **/
	grid = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel,
	    dataSet: dataSet,
	    width: 600,
	    height: 400,
	    autoToEdit: false,
	    autoWidth: true
	});
	grid.render('defaultGrid');

	grid.on('cellClick', function(e) {
		var colId = e.colId; //col의 id
		if(colId == 'prjNm' && dataSet.getRow() > -1){
			var record = dataSet.getAt(dataSet.getRow());
			fncPrjRgstPage(record);
		}
	});

	/**
	총 건수 표시
	**/
	dataSet.on('load', function(e){
		document.getElementById("cnt_text").innerHTML = '총: '+ dataSet.getCount();
		// 목록 페이징
    	paging(dataSet,"defaultGrid");
	});

	// 조회
	fnSearch = function() {

		dataSet.load({
	       url: '<c:url value="/prj/rsst/mst/retrievePrjRsstMstSearchInfoList.do"/>' ,
	       params :{
			    fromDate : fromDate.getValue(),
			    toDate   : toDate.getValue(),
			    wbsCd    : document.aform.wbsCd.value,
			    roleCheck    : roleCheck,
			    prjNm    : encodeURIComponent(document.aform.prjNm.value),
			    saName   : encodeURIComponent(document.aform.saName.value),
			    uperdeptName   : encodeURIComponent(document.aform.deptName.value)
	          }
	      });
	}

    /** dataSet Manager : 결과값 처리 **/
	dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    dm.on('success', function(e) {
    });
    dm.on('failure', function(e) {
   		ruiSessionFail(e);
	});

	// 화면로드시 조회
	fnSearch();

	if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
		$('#butRgst').hide();
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
		$('#butRgst').hide();
	}
});
</script>

<script type="text/javascript">


<%--/*******************************************************************************
* FUNCTION 명 : fncPrjRgstPage (프로젝트 등록 상세이동)
* FUNCTION 기능설명 : 시공이슈 상세
*******************************************************************************/--%>
function fncPrjRgstPage(record) {

	var pageMode = 'V';	// view
	if(record == ''){
		pageMode = 'C';	// create
		document.aform.pageMode.value = pageMode;
		document.aform.prjCd.value = '';
	}else{
		document.aform.pageMode.value = pageMode;
		document.aform.prjCd.value = record.get("prjCd");
	}
	nwinsActSubmit(document.aform, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstDtlInfo.do'/>")
}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {
	// 엑셀 다운로드시 전체 다운로드를 위해 추가
	dataSet.clearFilter();

    if( dataSet.getCount() > 0){
    	grid.saveExcel(toUTF8('Project 목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	alert('조회된 데이타가 없습니다.!!');
    }
	// 목록 페이징
    paging(dataSet,"defaultGrid");
}
</script>

</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>현황</h2>
   		    </div>
<%--    		    <%@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>

   			<div class="sub-content">

				<form name="aform" id="aform" method="post">
				<input type="hidden" name="_GRANT" value='${inputData._GRANT}' />
				<input type="hidden" name="pageMode" value='' />
				<input type="hidden" name="prjCd" value='' />
				<div class="search">
					<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px"/>
		   						<col style="width:360px"/>
		   						<col style="width:120px"/>
		   						<col style="width:220px"/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   					    <tr>
		   							<th align="right">WBS 코드</th>
		   							<td>
		   								<span>
											<input type="text" id="wbsCd" name="wbsCd" value="" >
										</span>
		   							</td>
		   							<th align="right">프로젝트명</th>
		    						<td>
		    							<input type="text"  id="prjNm" name="prjNm" value="" >
		    						</td>
		    						<td></td>
		   						</tr>
			   					<tr>
		   							<th align="right">PL 명</th>
		    						<td>
		    							<input type="text" id="saName" name="saName" value="" >
		    						</td>
		   							<th align="right">조직</th>
		   							<td>
		   								<input type="text" id="deptName" name="deptName" value="" >
		   							</td>
		   							<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
		   						</tr>
		   						<tr>
		   							<th align="right">프로젝트기간</th>
		   							<td colspan="4">
		   								<input type="text" id="fromDate" /><em class="gab"> ~ </em>
		   								<input type="text" id="toDate" />
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text"></span>

<!--    					<h3>Project 목록</h3> -->
					<div class="LblockButton">
   						<button type="button" id="butRgst" name="butRgst"  class="redBtn">프로젝트 등록</button>
   						<button type="button" id="butExcl" name="butExcl" >EXCEL다운로드</button>
   					</div>
   				</div>
				<div id="defaultGrid"></div>

			</form>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
   </body>
</html>
