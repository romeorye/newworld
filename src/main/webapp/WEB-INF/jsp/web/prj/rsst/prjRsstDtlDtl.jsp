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
 * 1.0  2018.08.31  IRIS05		최초생성
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
var pTopForm = parent.topForm; 
var pageMode = pTopForm.pageMode.value;
var pTrResultDataSet = parent.trResultDataSet; // 처리결과 호출용 데이터셋
var dataSet01;

	Rui.onReady(function() {
		
		<%-- RESULT DATASET --%>
	    resultDataSet = new Rui.data.LJsonDataSet({
	        id: 'resultDataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
	              { id: 'prjCd' }   //프로젝트코드
	            , { id: 'rtnSt' }   //결과코드
	            , { id: 'rtnMsg' }  //결과메시지
	        ]
	    });
	    
	    resultDataSet.on('load', function(e) {
	    });
	    
		<%-- DATASET --%>
	    dataSet01 = new Rui.data.LJsonDataSet({
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
		
	    dataSet01.on('load', function(e) {
	    	// 에디터에 데이터 세팅
	    	CrossEditor0.SetBodyValue( dataSet01.getNameValue(0, "rsstDevScp"));
	    	CrossEditor1.SetBodyValue( dataSet01.getNameValue(0, "bizArea") );
	    	CrossEditor2.SetBodyValue( dataSet01.getNameValue(0, "mnBaseTclg") );
	    	
	    });
		
	    /* [DataSet] bind */
	    var bind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: dataSet01,
	        bind: true,
	        bindInfo: [
	              { id: 'prjCd',       ctrlId: 'prjCd',           value: 'value' }
	            , { id: 'rsstDevScp',  ctrlId: 'rsstDevScp',      value: 'value' }
	            , { id: 'bizArea',     ctrlId: 'bizArea',         value: 'value' }
	            , { id: 'mnBaseTclg',  ctrlId: 'mnBaseTclg',      value: 'value' }
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
	    	
	    	if( index == 0 ){
	    		document.getElementById("divWec0").style.display = "block";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "none";	
	    	
	    	}else if( index == 1 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "block";	
	    		document.getElementById("divWec2").style.display = "none";		
	    	
	    	}else if( index == 2 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "block";	
	    	}
		});
		
	    
	    tabViewS.render('tabViewS');
	  
	    fnPrjDtlSearch = function() {
	    	dataSet01.load({
	            url: '<c:url value="/prj/rsst/mst/retrievePrjDtlSearchInfo.do"/>' ,
	            params :{
	    		    prjCd : document.aform.prjCd.value
	            }
	        });
	    }
	    
		 fnPrjDtlSearch();

	    /* 저장 */
	    fncInsertPrjRsstMstInfo = function(){  	
	    	var pDataSet = parent.dataSet;
	    	
	    	var frm = document.aform;
	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});
	    	
	    	if(!validation()){
	    		return false;
	    	}
	    	
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
		    	        url: "<c:url	value='/prj/rsst/mst/insertPrjRsstMstInfo.do'/>",
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
			            document.aform.prjCd.value = resultData.records[0].newPrjCd;
			            nwinsActSubmit(parent.topForm, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstDtlInfo.do'/>",'_self');
		            }
	            }

			});

			dm1.on('failure', function(e) {
				ruiSessionFail(e);
			});
	    	
	    	
			function validation(){
		    	/** 1. 상단 topForm **/
		    	
		    	// wbsCd코드
		    	if(pTopForm.wbsCd.value == ''){
		    		alert('유효하지 않습니다.\n WBS 코드');
		    		pTopForm.wbsCd.focus();
					return;
		    	}
		    	// 프로젝트명
		    	if(pTopForm.prjNm.value == ''){
		    		alert('유효하지 않습니다.\n 프로젝트명');
					pTopForm.prjNm.focus();
					return false;
		    	}
		    	// 프로젝트기간 시작일자
		    	if(pTopForm.fromDate.value == ''){
		    		alert('유효하지 않습니다.\n 프로젝트기간 시작일자');
					pTopForm.fromDate.focus();
					return false;
		    	}

		    	// 에디터 valid
				if( CrossEditor0.GetBodyValue() == "<p><br></p>" || CrossEditor0.GetBodyValue() == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
					alert("연구개발 범위를 입력해주십시오.");
					CrossEditor0.SetFocusEditor(); // 크로스에디터 Focus 이동
	     		    return false;
	     		}
				if( CrossEditor1.GetBodyValue() == "<p><br></p>" || CrossEditor1.GetBodyValue() == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
					alert("사업영역(제품군)을 입력해주십시오.");
					CrossEditor1.SetFocusEditor(); // 크로스에디터 Focus 이동
	     		    return false;
	     		}
				if( CrossEditor2.GetBodyValue() == "<p><br></p>" || CrossEditor2.GetBodyValue() == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
					alert("핵심기반기술을 입력해주십시오.");
					CrossEditor2.SetFocusEditor(); // 크로스에디터 Focus 이동
	     		    return false;
	     		}
				
				dataSet01.setNameValue(0, "rsstDevScp", CrossEditor0.GetBodyValue() );
				dataSet01.setNameValue(0, "bizArea", CrossEditor1.GetBodyValue() );
				dataSet01.setNameValue(0, "mnBaseTclg", CrossEditor2.GetBodyValue() );
				
				return true;
		    }
	    	
	    	
	    	
	    	
	    	
	    	
	    	
	    	
	    	
	    	
	    	
	    	
	    	
	    };	
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncGoPage (목록으로 이동)
	     * FUNCTION 기능설명 : 프로젝트 현황목록 화면으로 이동
	     *******************************************************************************/--%>
	    fncGoPage = function(){
	    	nwinsActSubmit(document.aform, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
	    }
	    
	    if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
	     	$("#butRgst").hide();
	 	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
	     	$("#butRgst").hide();
	 	}
	});
	
	

</script>
</head>

<body>
	<form  id="aform" name="aform">
	<input type="hidden" id="prjCd" value="<c:out value='${inputData.prjCd}'/>"/>

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
                		<div id="divWec0">
                		<textarea id="rsstDevScp" name="rsstDevScp"></textarea>
                			<script type="text/javascript" language="javascript">
								var CrossEditor0 = new NamoSE('rsstDevScp');
								CrossEditor0.params.Width = "100%";
								CrossEditor0.params.UserLang = "auto";
								
								var uploadPath = "<%=uploadPath%>"; 
								
								CrossEditor0.params.ImageSavePath = uploadPath+"/prj";
								CrossEditor0.params.FullScreen = false;
								
								CrossEditor0.EditorStart();
								
								function OnInitCompleted0(e){
									e.editorTarget.SetBodyValue(document.getElementById("rsstDevScp").value);
								}
							</script>
                		</div>
                		<div id="divWec1" style="display:none">
                		<textarea id="bizArea" name="bizArea"></textarea>
                			<script type="text/javascript" language="javascript">
								var CrossEditor1 = new NamoSE('bizArea');
								CrossEditor1.params.Width = "100%";
								CrossEditor1.params.UserLang = "auto";
								
								var uploadPath = "<%=uploadPath%>"; 
								
								CrossEditor1.params.ImageSavePath = uploadPath+"/prj";
								CrossEditor1.params.FullScreen = false;
								
								CrossEditor1.EditorStart();
								
								function OnInitCompleted1(e){
									e.editorTarget.SetBodyValue(document.getElementById("bizArea").value);
								}
							</script>
                		</div>
                		<div id="divWec2"  style="display:none">
                		<textarea id="mnBaseTclg" name="mnBaseTclg"></textarea>
                			<script type="text/javascript" language="javascript">
								var CrossEditor2 = new NamoSE('mnBaseTclg');
								CrossEditor2.params.Width = "100%";
								CrossEditor2.params.UserLang = "auto";
								
								var uploadPath = "<%=uploadPath%>"; 
								
								CrossEditor2.params.ImageSavePath = uploadPath+"/prj";
								CrossEditor2.params.FullScreen = false;
								
								CrossEditor2.EditorStart();
								
								function OnInitCompleted2(e){
									e.editorTarget.SetBodyValue(document.getElementById("mnBaseTclg").value);
								}
							</script>
                		</div>
                	</td>
                </tr>
			</tbody>
		</table>
		
		</form>
	<!-- </div> -->
	<div class="titArea">
		<div class="LblockButton">
			<button type="button" id="butRgst" name="butRgst"  onclick="javascript:fncInsertPrjRsstMstInfo();" >저장</button>
			<button type="button" id="butList" name="butList" onclick="javascript:fncGoPage();">목록</button>
		</div>
	</div>


</body>
</html>