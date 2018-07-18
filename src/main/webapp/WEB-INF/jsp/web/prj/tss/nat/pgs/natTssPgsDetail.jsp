<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssPgsDetail.jsp
 * @desc    : 
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.08
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<style>
 .L-tssLable {
 border: 0px
 }
</style>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">
    var gvTssCd     = "";
    var gvUserId    = "${inputData._userId}"; 
    var gvPgsStepCd = "PG"; //진행상태:PG(진행) 
    var gvTssSt     = ""; 
    var gvPkWbsCd   = ""; 
    var gvPageMode  = "";
    var gvTssNosSt  = "";
    
    var pgsStepNm = "";
    var dataSet;
    
    //Form
    var prjNm;
    var deptName;
    var ppslMbdCd;
    var bizDptCd;
    var wbsCd;
//     var tssNm;
    var saUserName;
    var tssAttrCd;
    var tssStrtDd;
    var tssFnhDd;

    var altrHistDialog;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //프로젝트명
        prjNm = new Rui.ui.form.LTextBox({
            applyTo: 'prjNm',
            editable: false,
            width: 300
        });
        
        //조직
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            editable: false,
            width: 300
        });
        
        //WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            editable: false,
            width: 80
        });
      
        //과제명
//         tssNm = new Rui.ui.form.LTextBox({
//             applyTo: 'tssNm',
//             editable: false,
//             width: 300
//         });
        
        //과제유형명
        bizDptNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizDptNm',
            editable: false,
            width: 300
        });
        
        //연구책임자
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            editable: false,
            width: 200
        });
        
        //주관부처
        supvOpsNm = new Rui.ui.form.LTextBox({
            applyTo: 'supvOpsNm',
            editable: false,
            width: 200
        });
        
        //전담기관
        exrsInstNm = new Rui.ui.form.LTextBox({
            applyTo: 'exrsInstNm',
            editable: false,
            width: 200
        });
        
        //사업명
        bizNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizNm',
            editable: false,
            width: 200
        });
        
        altrHistDialog = new Rui.ui.LFrameDialog({
   	        id: 'altrHistDialog', 
   	        title: '변경이력상세',
   	        width: 800,
   	        height: 650,
   	        modal: true,
   	        visible: false
   	    });
    	    
       	altrHistDialog.render(document.body);
       	
        //Form 비활성화 여부
        disableFields = function() {
            //버튼여부
            btnCmplRq.hide();
            btnAltrRq.hide();
            btnDcacRq.hide();
            
            if("TR01" == dataSet.getNameValue(0, "tssRoleId") || "${inputData._userSabun}" == dataSet.getNameValue(0, "saSabunNew")) {
	            if(gvTssSt == "100") {
	                btnCmplRq.show();
	                btnAltrRq.show();
	                btnDcacRq.show();
	            }
            }
            
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            Rui.select('.tssLableCss div').removeClass('L-disabled');
        }
        
        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 설정 
        dataSet = new Rui.data.LJsonDataSet({
            id: 'mstDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                { id: 'tssCd' }      //과제코드
                , { id: 'userId' }     //로그인ID
                , { id: 'prjCd' }      //프로젝트코드
                , { id: 'prjNm' }      //프로젝트명
                , { id: 'deptCode' }   //조직코드
                , { id: 'deptName' }   //조직명
                , { id: 'bizDptCd' }   //과제유형
                , { id: 'bizDptNm' }   //과제유형
                , { id: 'wbsCd' }      //WBSCode
                , { id: 'pkWbsCd' }    //WBSCode
                , { id: 'tssNm' }      //과제명
                , { id: 'saSabunNew' } //과제리더사번
                , { id: 'saUserName' } //과제리더명
                , { id: 'pgsStepCd' }  //진행단계코드
                , { id: 'tssScnCd' }   //과제구분코드
                , { id: 'tssNosSt' }   //과제차수상태
                , { id: 'supvOpsNm' }  //주관부처명
                , { id: 'exrsInstNm' } //전담기관명
                , { id: 'bizNm' }      //사업명
                , { id: 'tssSt' }      //과제상태
                , { id: 'pgTssCd' }
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
            ]
        });
        dataSet.on('load', function(e) {
            gvTssCd   = stringNullChk(dataSet.getNameValue(0, "tssCd"));
            gvTssSt   = stringNullChk(dataSet.getNameValue(0, "tssSt"));
            gvPkWbsCd = stringNullChk(dataSet.getNameValue(0, "pkWbsCd"));
            gvPageMode = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            gvTssNosSt = stringNullChk(dataSet.getNameValue(0, "tssNosSt"));
            
            document.getElementById('tssNm').innerHTML = dataSet.getNameValue(0, "tssNm");
            
            disableFields();
            
            tabView.selectTab(0);
        });
        
        
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'prjNm',      ctrlId: 'prjNm',      value: 'value' }
                , { id: 'deptName',   ctrlId: 'deptName',   value: 'value' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }
//                 , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'value' }
                , { id: 'bizDptNm',   ctrlId: 'bizDptNm',   value: 'value' }
                , { id: 'saUserName', ctrlId: 'saUserName', value: 'value' }
                , { id: 'supvOpsNm',  ctrlId: 'supvOpsNm',  value: 'value' }
                , { id: 'exrsInstNm', ctrlId: 'exrsInstNm', value: 'value' }
                , { id: 'bizNm',      ctrlId: 'bizNm',      value: 'value' }
            ]
        });
        
        
        
        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: '개요', content: '<div id="div-content-test0"></div>' },
                { label: '사업비', content: '<div id="div-content-test1"></div>' },
                { label: '참여연구원', content: '<div id="div-content-test2"></div>' },
                { label: '목표 및 산출물', content: '<div id="div-content-test3"></div>' },
                { label: '투자품목목록', content: '<div id="div-content-test4"></div>' },
                { label: '연구비카드', content: '<div id="div-content-test5"></div>' },
                { label: '변경이력', content: '<div id="div-content-test6"></div>' }
            ]
        });
        tabView.on('activeTabChange', function(e) {
            //iframe 숨기기
            for(var i = 0; i < 7; i++) { 
                if(i == e.activeIndex) {
                    Rui.get('tabContent' + i).show();
                } else {
                    Rui.get('tabContent' + i).hide();
                }
            }
            
            var tabUrl = "";
            
            switch(e.activeIndex) {
            //개요
            case 0:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsSmryIfm.do'/>"+"?tssCd="+gvTssCd+"&pkWbsCd="+gvPkWbsCd;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                }
                break;
            //사업비    
            case 1:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsTrwiBudgIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                break;
            //참여연구원    
            case 2:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsPtcRsstMbrIfm.do?pkWbsCd=" + gvPkWbsCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                break;
            //목표 및 산출물    
            case 3:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
                }
                break;
            //투자품목목록
            case 4:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsIvstIfm.do?tssCd=" + gvTssCd + "'/>" + "&pkWbsCd=" + gvPkWbsCd;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent4');
                }
                break;
            //연구비카드  
            case 5:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsCrdIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent5');
                }
                break;
            //변경이력
            case 6:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsAltrHistIfm.do?pkWbsCd=" + gvPkWbsCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent6');
                }
                break;
            default:
                break;
            }
        });
        tabView.render('tabView');
        
        
        
        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //변경품의 
        btnAltrRq = new Rui.ui.LButton('btnAltrRq');
        btnAltrRq.on('click', function() {
            Rui.confirm({
                text: '변경요청을 하시겠습니까?',
                handlerYes: function() {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/nat/natTssPgsCsus.do' />"+"?pgTssCd="+gvTssCd+"&pkWbsCd="+gvPkWbsCd+"&pgsStepCd=AL");
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        //중단품의 
        btnDcacRq = new Rui.ui.LButton('btnDcacRq');
        btnDcacRq.on('click', function() {
            Rui.confirm({
                text: '중단요청을 하시겠습니까?',
                handlerYes: function() {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/nat/natTssPgsCsus.do' />"+"?pgTssCd="+gvTssCd+"&pkWbsCd="+gvPkWbsCd+"&pgsStepCd=DC");
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        //완료품의 
        btnCmplRq = new Rui.ui.LButton('btnCmplRq');
        btnCmplRq.on('click', function() {
            Rui.confirm({
                text: '완료요청을 하시겠습니까?',
                handlerYes: function() {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/nat/natTssPgsCsus.do' />"+"?pgTssCd="+gvTssCd+"&pkWbsCd="+gvPkWbsCd+"&pgsStepCd=CM");
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {   
			$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
			$('#searchForm > input[name=saUserName]').val(encodeURIComponent($('#searchForm > input[name=saUserName]').val()));
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));
			
            nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
        
        //데이터 셋팅
        if(${resultCnt} > 0) { 
            console.log("mst searchData1");
            dataSet.loadData(${result}); 
        }
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnAltrRq").hide();
        	$("#btnDcacRq").hide();
        	$("#btnCmplRq").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnAltrRq").hide();
        	$("#btnDcacRq").hide();
        	$("#btnCmplRq").hide();
		}
    });
    
    function fncNatTssAltrDetail(cd) {
    	var params = "?tssCd="+cd;
    		altrHistDialog.setUrl('<c:url value="/prj/tss/nat/natTssAltrDetailPopup.do"/>'+params);
    		altrHistDialog.show();
    }
</script>
</head>
<body>
<form name="searchForm" id="searchForm"  method="post">
	<input type="hidden" name="wbsCd" value="${inputData.wbsCd}"/>
	<input type="hidden" name="tssNm" value="${inputData.tssNm}"/>
	<input type="hidden" name=saUserName value="${inputData.saUserName}"/>
	<input type="hidden" name="deptName" value="${inputData.deptName}"/>
	<input type="hidden" name="ttlCrroStrtDt" value="${inputData.ttlCrroStrtDt}"/>
	<input type="hidden" name="ttlCrroFnhDt" value="${inputData.ttlCrroFnhDt}"/>
	<input type="hidden" name="prjNm" value="${inputData.prjNm}"/>
	<input type="hidden" name="pgsStepCd" value="${inputData.pgsStepCd}"/>
	<input type="hidden" name="tssSt" value="${inputData.tssSt}"/>
</form>
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
	    <div class="titleArea">
	        <h2>국책과제 &gt;&gt; 진행</h2>
	    </div>
        <div class="sub-content">
            <div class="titArea">
                <div class="LblockButton">
                    <button type="button" id="btnAltrRq" name="btnAltrRq">변경요청</button>
                    <button type="button" id="btnDcacRq" name="btnDcacRq">중단요청</button>
                    <button type="button" id="btnCmplRq" name="btnCmplRq">완료요청</button>
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 12%;" />
                                <col style="width: 38%;" />
                                <col style="width: 12%;" />
                                <col style="width: 38%;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">프로젝트명</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="prjNm" />
                                    </td>
                                    <th align="right">조직</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="deptName" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">WBSCode</th>
                                    <td class="tssLableCss">
                                        <div id="wbsCd"></div>
                                    </td>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="bizDptNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제명</th>
                                    <td class="tssLableCss" colspan="3">
                                        <div id="tssNm" style="width:900px;padding:0px 5px">
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제리더</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="saUserName" />
                                    </td>
                                    <th align="right">주관부처</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="supvOpsNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">전담기관</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="exrsInstNm" />
                                    </td>
                                    <th align="right">사업명</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="bizNm" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </fieldset>
                </form>
            </div>    
            <br/>
            
            <div id="tabView"></div>
            
            <form name="tabForm" id="tabForm" method="post">
                <iframe name="tabContent0" id="tabContent0" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent1" id="tabContent1" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent2" id="tabContent2" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent3" id="tabContent3" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent4" id="tabContent4" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent5" id="tabContent5" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent6" id="tabContent6" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
            </form>
        </div>
    </div>

</body>
</html>