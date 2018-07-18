<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,devonframe.util.NullUtil" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: prjRsstDtlDtl.jsp
 * @desc    : 연구팀(Project) > 현황 > 프로젝트 등록
              연구팀(Project) 프로젝트 개요 탭
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.10  IRIS04		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<title><%=documentTitle%></title>

<script language="JavaScript" type="text/javascript">
var pTopForm = parent.topForm;                 // 프로젝트마스터 폼
var pTrResultDataSet = parent.trResultDataSet; // 처리결과 호출용 데이터셋
var editorDataFields = "rsstDevScp,bizArea,mnBaseTclg";	//에디터사용 데이터 필드

Rui.onReady(function() {

	<%-- FORM Element  --%>
	var orgRsstDevScp;	//변경 전 연구개발범위
	var orgBizArea;		//변경 전 사업영역
	var orgMnBaseTclg	//변경 전 핵심기반기술

    <%-- DATASET --%>
    var dataSet01 = new Rui.data.LJsonDataSet({
        id: 'dataSet01',
        remainRemoved: true,
        lazyLoad: true,
        fields: [
              { id: 'prjCd' }       		//프로젝트코드
            , { id: 'wbsCd' }       		//WBS코드
            , { id: 'rsstDevScp' }  		//연구개발범위
            , { id: 'bizArea' }     		//사업영역
            , { id: 'mnBaseTclg' }  		//핵심기반기술
            , { id: 'editorDataFields' }	// 에디터필드
        ]
    });

    <%-- RESULT DATASET --%>
    var resultDataSet = new Rui.data.LJsonDataSet({
        id: 'resultDataSet',
        remainRemoved: true,
        lazyLoad: true,
        fields: [
              { id: 'prjCd' }   //프로젝트코드
            , { id: 'rtnSt' }   //결과코드
            , { id: 'rtnMsg' }  //결과메시지
        ]
    });

    dataSet01.on('load', function(e) {
    	// 데이터필드 세팅
    	dataSet01.setNameValue(0,"editorDataFields", editorDataFields);
    	
    	orgRsstDevScp = dataSet01.getNameValue(0, "rsstDevScp");
    	orgBizArea    = dataSet01.getNameValue(0, "bizArea");
    	orgMnBaseTclg = dataSet01.getNameValue(0, "mnBaseTclg");
    	
    	// 에디터에 데이터 세팅
    	document.tabForm01.Wec0.value=dataSet01.getNameValue(0, "rsstDevScp");
    	document.tabForm01.Wec1.value=dataSet01.getNameValue(0, "bizArea");
    	document.tabForm01.Wec2.value=dataSet01.getNameValue(0, "mnBaseTclg");
    });

    resultDataSet.on('load', function(e) {
    });

    /* [DataSet] bind */
    var bind = new Rui.data.LBind({
        groupId: 'tabForm01',
        dataSet: dataSet01,
        bind: true,
        bindInfo: [
              { id: 'prjCd',       ctrlId: 'prjCd',           value: 'value' }
            , { id: 'rsstDevScp',  ctrlId: 'rsstDevScp',      value: 'value' }
            , { id: 'bizArea',     ctrlId: 'bizArea',         value: 'value' }
            , { id: 'mnBaseTclg',  ctrlId: 'mnBaseTclg',      value: 'value' }
        ]
    });

    <%-- VALIDATOR --%>
    var validatorManager = new Rui.validate.LValidatorManager({
        validators:[
//            { id: 'rsstDevScp', validExp:'연구개발 범위:true'}
//          , { id: 'bizArea', validExp:'사업영역:true'}
//          , { id: 'mnBaseTclg', validExp:'핵심기반기술:true'}
        ]
    });
    
 	// 개요 에디터 탭
    tabViewS = new Rui.ui.tab.LTabView({
        contentHeight: 200,
        tabs: [
            {
            	label: '연구개발 범위',
                content: ''
            }, {
                label: '사업영역(제품군)',
                content: ''
            }, {
                label: '핵심기반기술',
                content: ''
            }
        ]
    });
    tabViewS.on('activeTabChange', function(e){
    	var index = e.activeIndex;
    	
    	fnDisplyNone();
    	
    	$("#Wec"+index).ready(function(){
    		
    		fnDisplyBlock(index);
    		
    		if(e.isFirst){
    			setTimeout(function () {
    				fnSetDataEditor(index);
            	}, 1000);	
    		  }
    	});
	});

    <%--/*******************************************************************************
     * FUNCTION 명 : fnPrjDtlSearch (프로젝트 상세 조회)
     * FUNCTION 기능설명 : 프로젝트 상세 조회
     * PARAM : prjCd
     *******************************************************************************/--%>
    fnPrjDtlSearch = function() {

    	dataSet01.load({
            url: '<c:url value="/prj/rsst/mst/retrievePrjDtlSearchInfo.do"/>' ,
            params :{
    		    prjCd : document.tabForm01.prjCd.value
            }
        });
    }
    fnPrjDtlSearch();


    <%--/*******************************************************************************
    * FUNCTION 명 : fncGoPage (목록으로 이동)
    * FUNCTION 기능설명 : 프로젝트 현황목록 화면으로 이동
    *******************************************************************************/--%>
    fncGoPage = function(){
    	nwinsActSubmit(document.tabForm01, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
    }

    <%--/*******************************************************************************
     * FUNCTION 명 : fncInsertPrjRsstMstInfo (프로젝트 개요정보 저장)
     * FUNCTION 기능설명 : 프로젝트 마스터, 상세 개요정보 저장
     *******************************************************************************/--%>
    fncInsertPrjRsstMstInfo = function(){  	
    	var pageMode = parent.topForm.pageMode.value;
    	var pDataSet = parent.dataSet;
    	var smryIsUpdate = fnEditorIsUpdate(); //개요 에디터 변경여부
    	
    	//마스터 달력 blur
    	//parent.fromDate.blur();
    	//parent.toDate.blur();
    	
    	// 에디터데이터 => 데이터셋
    	var frm = document.tabForm01;
		frm.rsstDevScp.value = fnEditorGetMimeValue(frm.Wec0.isDirty(),frm.Wec0,'');
		frm.bizArea.value    = fnEditorGetMimeValue(frm.Wec1.isDirty(),frm.Wec1,'');
		frm.mnBaseTclg.value = fnEditorGetMimeValue(frm.Wec2.isDirty(),frm.Wec2,'');
		
		dataSet01.setNameValue(0,"rsstDevScp" , frm.rsstDevScp.value);
		dataSet01.setNameValue(0,"bizArea"    , frm.bizArea.value);
		dataSet01.setNameValue(0,"mnBaseTclg" , frm.mnBaseTclg.value);

    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    	if(!validation()){
    		return false;
    	}
    	
    	//수정여부
        if(!pDataSet.isUpdated() && !dataSet01.isUpdated() && !smryIsUpdate) {
            alert("변경된 데이터가 없습니다.");
            return;
        }
    	
        // 개요 데이터셋 업데이트 상태로 강제처리
        dataSet01.setState(0, Rui.data.LRecord.STATE_UPDATE);

    	if(pageMode == 'V'){	// update
    		
    		if( confirm("저장하시겠습니까?") == true ){
    		
	    		// 마스터 변경데이터 세팅
	    		if(parent.dataSet.getAt(0).get("plEmpNo") != pTopForm.hPlEmpNo.value){
	    			parent.dataSet.getAt(0).set("plEmpNo"  , pTopForm.hPlEmpNo.value);
	    		}
	    		if(parent.dataSet.getAt(0).get("deptCd") != pTopForm.hDeptCd.value){
	    			parent.dataSet.getAt(0).set("deptCd"   , pTopForm.hDeptCd.value);
	    		}
	    		if(parent.dataSet.getAt(0).get("prjCpsn") != pTopForm.userDeptCnt.value){
	    			parent.dataSet.getAt(0).set("prjCpsn"  , pTopForm.userDeptCnt.value);
	    		}
	    		if(parent.dataSet.getAt(0).get("prjStrDt") != parent.fromDate.getValue()){
	    			parent.dataSet.getAt(0).set("prjStrDt" , parent.fromDate.getValue());
	    		}
	    		if(parent.dataSet.getAt(0).get("prjEndDt") != parent.toDate.getValue()){
	    			parent.dataSet.getAt(0).set("prjEndDt" , parent.toDate.getValue());
	    		}
	    		dm1.updateDataSet({
	    	        url: "<c:url value='/prj/rsst/mst/insertPrjRsstMstInfo.do'/>",
	    	        dataSets:[dataSet01,pDataSet,resultDataSet],
	    	        params: {
	    	              prjCd : parent.topForm.prjCd.value
	    	        }
	    	    });
    		}
    	}else if(pageMode == 'C'){	// insert
    		
    		if( confirm("저장하시겠습니까?") == true ){
	    		// 마스터데이터 세팅
	    		parent.dataSet.getAt(0).set("plEmpNo"  , pTopForm.hPlEmpNo.value);
	   			parent.dataSet.getAt(0).set("deptCd"   , pTopForm.hDeptCd.value);
	   			parent.dataSet.getAt(0).set("prjCpsn"  , pTopForm.userDeptCnt.value);
	   			parent.dataSet.getAt(0).set("deptUper"  , pTopForm.deptUper.value);
	   			parent.dataSet.getAt(0).set("prjStrDt" , parent.fromDate.getValue());
	   			parent.dataSet.getAt(0).set("prjEndDt" , parent.toDate.getValue());
	
	   			// 상세 데이터세팅
	   			dataSet01.getAt(0).set("wbsCd"   , parent.dataSet.getAt(0).get("wbsCd"));
	
	   			dm1.updateDataSet({
	    	        url: "<c:url value='/prj/rsst/mst/insertPrjRsstMstInfo.do'/>",
	    	        dataSets:[dataSet01,parent.dataSet],
	    	        params: {
	    	              prjCd : parent.topForm.prjCd.value
	    	        }
	    	    });
    		}
    	}

    	dm1.on('success', function(e) {
			var resultData = pTrResultDataSet.getReadData(e);
            
            if(resultData.records[0].rtnSt == 'S'){
	            // 최초저장 성공 후 페이지 새로고침
	            if(pageMode == 'C'){
		            parent.topForm.prjCd.value = resultData.records[0].newPrjCd;
		            parent.topForm.pageMode.value = 'V';
		            document.tabForm01.prjCd.value = resultData.records[0].newPrjCd;
		            nwinsActSubmit(parent.topForm, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstDtlInfo.do'/>",'_self');
	            }
            }

		});

		dm1.on('failure', function(e) {
			ruiSessionFail(e);
		});
		

    }

    <%--/*******************************************************************************
    * FUNCTION 명 : validation
    * FUNCTION 기능설명 : 입력값 점검
    *******************************************************************************/--%>
    function validation(){

    	/** 1. 상단 topForm **/
    	// wbsCd코드
    	if(pTopForm.wbsCd.value == ''){
    		alert('유효하지 않습니다.\n WBS 코드');
    		pTopForm.wbsCd.focus();
			return;
    	}
    	// WBS 코드 약어
    	/*
    	if(pTopForm.wbsCdA.value == ''){
    		alert('유효하지 않습니다.\n WBS 코드 약어');
    		pTopForm.wbsCdA.focus();
			return;
    	}
    	// WBS 코드 약어 2자리수 체크
    	 
    	if( (pTopForm.wbsCdA.value).length < 2){
    		alert('WBS 코드 약어는 두자리로 입력되어야 합니다.');
    		pTopForm.wbsCdA.focus();
			return;
    	}
    	// 프로젝트명
    	if(pTopForm.prjNm.value == ''){
    		alert('유효하지 않습니다.\n 프로젝트명');
			pTopForm.prjNm.focus();
			return false;
    	}
    	 */
    	// 프로젝트기간 시작일자
    	if(pTopForm.fromDate.value == ''){
    		alert('유효하지 않습니다.\n 프로젝트기간 시작일자');
			pTopForm.fromDate.focus();
			return false;
    	}

    	/** 2. 하단tabForm01 **/
//         if( !validatorManager.validateGroup("tabForm01") ) {
//              alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + validatorManager.getMessageList().join(''));
//              return false;
//         }
//     	// 에디터데이터 필수값 체크
//     	var testEditValue1 = fnEditorGetMimeValue(document.tabForm01.Wec0.isDirty(),document.tabForm01.Wec0,'body');
//         var testEditValue2 = fnEditorGetMimeValue(document.tabForm01.Wec1.isDirty(),document.tabForm01.Wec1,'body');
//         var testEditValue3 = fnEditorGetMimeValue(document.tabForm01.Wec2.isDirty(),document.tabForm01.Wec2,'body');
//         var testEditIsDirty1 = document.tabForm01.Wec0.isDirty();
//     	var testEditIsDirty2 = document.tabForm01.Wec1.isDirty();
//     	var testEditIsDirty3 = document.tabForm01.Wec2.isDirty();

//     	if( (testEditIsDirty1 == 1 && (testEditValue1 == null || testEditValue1 == '' || testEditValue1 == "<P>&nbsp;</P>")) ||
//     		(testEditIsDirty1 == 0 && stringNullChk(orgRsstDevScp) == "")                                                    ){
//     		alert("연구개발 범위 는 필수입력입니다.");
//     		return false;
//     	}
//         if( (testEditIsDirty2 == 1 && (testEditValue2 == null || testEditValue2 == '' || testEditValue2 == "<P>&nbsp;</P>")) ||
//         	(testEditIsDirty2 == 0 && stringNullChk(orgBizArea) == "")                                                       ){
//     		alert("사업영역 은 필수입력입니다.");
//     		return false;
//     	}
//         if( (testEditIsDirty3 == 1 && (testEditValue3 == null || testEditValue3 == '' || testEditValue3 == "<P>&nbsp;</P>")) ||
//         	(testEditIsDirty3 == 0 && stringNullChk(orgMnBaseTclg) == "")                                                    ){
//     		alert("핵심기반기술 은 필수입력입니다.");
//     		return false;
//     	}

    	return true;
    }

	parent.fnChangeFormEdit('enable');
	
    tabViewS.render('tabViewS');
    
    /** ============================================= Editor ================================================================================= **/
	createNamoEdit('Wec0', '100%', 400, 'divWec0');
	createNamoEdit('Wec1', '100%', 400, 'divWec1');
	createNamoEdit('Wec2', '100%', 400, 'divWec2');
	
    // editor
    fnSetDataEditor = function(val){
   		var Wec = eval("document.tabForm01.Wec"+val);
//        	Wec.DefaultCharSet = "utf-8";
 		Wec.MIMEEncodeRange = 1;
   	 
       	Wec.value = Wec.CleanupHtml(Wec.value);
       	// Wec.value  =  Wec.MIMEValue ;
       	Wec.BodyValue  =  Wec.value ;
       	var txt = "";
       	if(dataSet01.getCount() > 0){
	       	txt = dataSet01.getNameValue(0, "rsstDevScp");
	        if(val==0){
	       		txt = dataSet01.getNameValue(0, "rsstDevScp");
	        }else if(val==1){
	        	txt = dataSet01.getNameValue(0, "bizArea");
	        }else if(val==2){
	        	txt = dataSet01.getNameValue(0, "mnBaseTclg");
	        }
       	}
       	Wec.BodyValue = txt;
       	Wec.setDirty(false);	// 변경상태 초기화처리
    }
    
    //editor show hide function
    fnDisplyBlock= function(val){
    	document.getElementById('divWec'+val).style.display = 'block';
    }
    fnDisplyNone = function(){
    	document.getElementById('divWec0').style.display = 'none';
    	document.getElementById('divWec1').style.display = 'none';
    	document.getElementById('divWec2').style.display = 'none';
    }
 	// 에디터변경여부
    fnEditorIsUpdate = function(){
    	isUpdate = false;
    	var Wec0 = document.tabForm01.Wec0;
    	var Wec1 = document.tabForm01.Wec1;
    	var Wec2 = document.tabForm01.Wec2;

    	if( (Wec0 != null && Wec0.IsDirty() == 1) || (Wec1 != null && Wec1.IsDirty() == 1) || (Wec2 != null && Wec2.IsDirty() == 1) ){
    		isUpdate = true;
    	}
    	return isUpdate;
    }
    /* 에디터값 가져오기(변경상태 유지) type(body, mime) */
    fnEditorGetMimeValue = function(beforeDirty,editor,type){
    	
    	var returnValue = editor.MIMEValue;
    	if(type == 'body'){ returnValue = editor.BodyValue; }
    	
    	editor.setDirty(beforeDirty);
    	return returnValue;
    }
    /** ===============================================  Editor End ==================================================================================== **/

    $("#Wec0").ready(function(){
    	tabViewS.selectTab(0);
    });
    
    if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
    	$("#butRgst").hide();
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
    	$("#butRgst").hide();
	}
	
}); // end RUI Lodd

</script>
</head>
<body>

<form name="tabForm01" id="tabForm01">
	<input type="hidden" id="prjCd" value="<c:out value='${inputData.prjCd}'/>"/>
	<input type="hidden" id="prjCd01" value=""/>
	<input type="hidden" id="rsstDevScp"/> <!-- 연구개발 범위 -->
	<input type="hidden" id="bizArea"/>    <!-- 사업영역(제품군) -->
	<input type="hidden" id="mnBaseTclg"/> <!-- 핵심기반기술 -->

	<div class="titArea">
		<!-- <h3>개요</h3> -->
	</div>
	<br>
	<!-- <div class="titArea"> -->
		<table class="table table_txt_right" >
			<colgroup>
				<col style="width:10%;">
				<col style="width:*;">
			<tbody>
				<tr>
                	<th align="right" rowspan="2">개요 상세</th>
                    <td>
                    	<div id="tabViewS"></div>
					</td>
                </tr>
                <tr>
                	<td>
                		<div id="divWec0"></div>
                		<div id="divWec1"></div>
                		<div id="divWec2"></div>
                	</td>
                </tr>
			</tbody>
		</table>
	<!-- </div> -->
	<div class="titArea">
		<div class="LblockButton">
			<button type="button" id="butRgst" name="butRgst"  onclick="javascript:fncInsertPrjRsstMstInfo();" >저장</button>
			<button type="button" id="butList" name="butList" onclick="javascript:fncGoPage();">목록</button>
		</div>
	</div>
</form>

</body>
</html>