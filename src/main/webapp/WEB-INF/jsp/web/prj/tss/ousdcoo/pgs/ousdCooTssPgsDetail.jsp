<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssPgsDetail.jsp
 * @desc    : 대외협력과제 > 진행 상세 상단 탭 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.19  IRIS04		최초생성
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

<script type="text/javascript">
    var gvTssCd     = "";
    var gvUserId    = "${inputData._userId}"; 
    var gvPgsStepCd = "PG"; //진행상태:PG(진행) 
    var gvTssSt     = ""; 
    var gvWbsCd     = ""; 
    var gvPageMode  = ""; 
    
    var pgsStepNm = "";
    var dataSet;
    
    //Form
    var prjNm;
    var deptName;
    var ppslMbdCd;
    var bizDptCd;
    var wbsCd;
    var tssNm;
    var saUserName;
    var tssAttrCd;
    var tssStrtDd;
    var tssFnhDd;

    var altrHistDialog;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //form 비활성화 여부
        var disableFields = function(disable) {
            
            //버튼여부
            btnGrsRq.hide();
            
            var pTssRoleId = stringNullChk(dataSet.getNameValue(0, "tssRoleId"));
            
            //조건에 따른 보이기
            if(pTssRoleId != "TR05" && pTssRoleId != "") {
                if(gvTssSt == "100") btnGrsRq.show(); //GRS - 100:작성중
            }
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
                , { id: 'ppslMbdCd' }  //발의주체
                , { id: 'bizDptCd' }   //과제유형
                , { id: 'wbsCd' }      //WBSCode
                , { id: 'pkWbsCd' }    //WBSCode(PK)
                , { id: 'tssNm' }      //과제명
                , { id: 'saSabunNew' } //과제리더사번
                , { id: 'saUserName' } //과제리더명
                , { id: 'tssAttrCd' }  //과제속성
                , { id: 'tssStrtDd' }  //과제기간S
                , { id: 'tssFnhDd' }   //과제기간E
                , { id: 'pgsStepNm' }  //진행단계명
                , { id: 'tssSt' }      //과제상태
                , { id: 'pgsStepCd' }  //진행단계
                , { id: 'tssScnCd' }   //과제구분
                , { id: 'cooInstCd' }  //협력기관코드
                , { id: 'cooInstNm' }  //협력기관명
                , { id: 'bizDptNm' }   //과제유형명
                , { id: 'mbrCnt' }     //참여인원(추가)
                , { id: 'ttsDifMonth'} //과제소요기간
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
                , {id: 'tssStepNm'}	//관제 단계
                , {id: 'grsStepNm'}	//GRS 단계
                , {id: 'qgateStepNm'}	//Qgate 단계
            ]
        });
        dataSet.on('load', function(e) {
        	 gvTssCd     = stringNullChk(dataSet.getNameValue(0, "tssCd"));
             gvTssSt     = stringNullChk(dataSet.getNameValue(0, "tssSt"));
             gvWbsCd     = stringNullChk(dataSet.getNameValue(0, "pkWbsCd"));
             gvCooInstCd = stringNullChk(dataSet.getNameValue(0, "cooInstCd"));
             gvPageMode  = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            
           disableFields();
            
            tabView.selectTab(0);
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
       
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'prjNm',       ctrlId: 'prjNm',       value: 'html' }
                , { id: 'deptName',    ctrlId: 'deptName',    value: 'html' }
                , { id: 'wbsCd',       ctrlId: 'wbsCd',       value: 'html' }
                , { id: 'tssNm',       ctrlId: 'tssNm',       value: 'html' }
                , { id: 'saUserName',  ctrlId: 'saUserName',  value: 'html' }
                , { id: 'tssStrtDd',   ctrlId: 'tssStrtDd',   value: 'html' }
                , { id: 'tssFnhDd',    ctrlId: 'tssFnhDd',    value: 'html' }
                , { id: 'cooInstNm',   ctrlId: 'cooInstNm',   value: 'html' }  /*협력기관명*/
                , { id: 'bizDptNm',    ctrlId: 'bizDptNm',    value: 'html' }  /*과제유형명*/
                , { id: 'mbrCnt',      ctrlId: 'mbrCnt',      value: 'html' }  /*참여인원*/
                , { id: 'ttsDifMonth', ctrlId: 'ttsDifMonth', value: 'html'}   /*과제소요기간*/
                , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'html' }				//과제 단계명
                , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'html' }				// GRS 단계명
                , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'html' }		//Qgate 단계명

            ]
        });
        
        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: '개요'           , content: '<div id="div-content-test0"></div>' },
                { label: '참여연구원'     , content: '<div id="div-content-test1"></div>' },
                { label: '비용지급실적'   , content: '<div id="div-content-test2"></div>' },
                { label: '목표 및 산출물' , content: '<div id="div-content-test3"></div>' },
                { label: '변경이력'       , content: '<div id="div-content-test4"></div>' }
            ]
        });
        tabView.on('activeTabChange', function(e) {
            //iframe 숨기기
            for(var i = 0; i < 5; i++) { 
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
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsSmryIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                }
                break;
            //참여연구원
            case 1:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "&pkWbsCd="+ gvWbsCd +"'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                break;
            //비용지급실적
            case 2:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsExpStoaIfm.do?tssCd=" + gvTssCd + "'/>";    
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                break;
            //목표 및 산출물    
            case 3:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
                }
                break;
            //변경이력
            case 4:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsAltrHistIfm.do?pkWbsCd=" + gvWbsCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent4');
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
        var regDm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        regDm.on('success', function(e) {
            var regCntMap = JSON.parse(e.responseText)[0].records[0];
            
            var errMsg = "";
            if(regCntMap.ousdSmryCnt <= 0)      errMsg = "개요를 입력해 주시기 바랍니다.";
            else if(regCntMap.comMbrCnt <= 0)   errMsg = "참여원구원을 입력해 주시기 바랍니다.";
            else if(regCntMap.ousdStoaCnt <= 0) errMsg = "비용지급실적을 입력해 주시기 바랍니다.";
            else if(regCntMap.comGoalCnt <= 0)  errMsg = "목표를 입력해 주시기 바랍니다.";
            else if(regCntMap.comYldCnt <= 0)   errMsg = "산출물을 입력해 주시기 바랍니다.";
            
//             if(errMsg != "") alert(errMsg);
//             else {
                if(regCntMap.gbn == "GRS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/grs/grsEvRslt.do' />"+"?tssCd="+gvTssCd+"&userId="+gvUserId+"&callPageId=ousdCooTss");
//                else if(regCntMap.gbn == "CSUS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssPlnCsusRq.do'/>" + "?tssCd="+gvTssCd+"&userId="+gvUserId+"&appCode=APP00332");
//             }
        });
        
        //GRS요청 
        btnGrsRq = new Rui.ui.LButton('btnGrsRq');
        btnGrsRq.on('click', function() {
        	// 테이블 저장 체크
			if(confirm("GRS요청을 하시겠습니까?")) {
				regDm.update({
                url:'<c:url value="/prj/tss/gen/getTssRegistCnt.do"/>', 
                params:'gbn=GRS&tssCd='+gvTssCd
           		});
			}
        });
        
        //변경품의 
/*         btnAltrRq = new Rui.ui.LButton('btnAltrRq');
        btnAltrRq.on('click', function() {
            Rui.confirm({
                text: '변경품의를 진행 하시겠습니까?',
                handlerYes: function() {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/ousdcoo/genTssPgsAltrCsus.do' />"+"?tssCd="+gvTssCd+"&userId="+gvUserId+"&tssSt=102");
                },
                handlerNo: Rui.emptyFn
            });
        }); */
        

        //목록 
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {   
			$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
			$('#searchForm > input[name=saUserName]').val(encodeURIComponent($('#searchForm > input[name=saUserName]').val()));
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));
			
			nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
        });

        //데이터 셋팅
        if(${resultCnt} > 0) { 
            dataSet.loadData(${result}); 
        }
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnGrsRq").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnGrsRq").hide();
		}
    });
    
    function fncOusdCooTssAltrDetail(cd) {
    	var params = "?tssCd="+cd;
   		altrHistDialog.setUrl('<c:url value="/prj/tss/ousdCoo/ousdCooTssAltrDetailPopup.do"/>'+params);
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
	<input type="hidden" name="tssStrtDd" value="${inputData.tssStrtDd}"/>
	<input type="hidden" name="tssFnhDd" value="${inputData.tssFnhDd}"/>
	<input type="hidden" name="prjNm" value="${inputData.prjNm}"/>
	<input type="hidden" name="pgsStepCd" value="${inputData.pgsStepCd}"/>
	<input type="hidden" name="tssSt" value="${inputData.tssSt}"/>
</form>
    <Tag:saymessage /><%--<!--  sayMessage 사용시 필요 -->--%>
    
    <div class="contents">
        <div class="titleArea">
        	<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>대외협력과제 &gt;&gt;진행</h2>
    	</div>
        <%-- <%@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>

        <div class="sub-content">
            <div class="titArea mt0">
                <div class="LblockButton">
<!--                     <button type="button" id="btnAltrRq" name="btnAltrRq">변경품의</button> -->
                    <button type="button" id="btnGrsRq" name="btnGrsRq">GRS요청</button>
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 16%;" />
                                <col style="width: 35%;" />
                                <col style="width: 15%;" />
                                <col style="" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">프로젝트명</th>
                                    <td>
                                        <span id="prjNm"></span>
                                    </td>
                                    <th align="right">조직</th>
                                    <td>
                                        <span id="deptName"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">WBSCode / 과제명</th>
                                    <td colspan="3">
                                     	<span id="wbsCd"></span>&#32;&#47;&#32;
                                        <span id="tssNm"></span>
                                    </td>
                                </tr>
                                
                                <tr>
                                	<th align="right">과제리더</th>
                                    <td>
                                        <span id="saUserName"></span>
                                    </td>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td>
                                        <span id="bizDptNm"></span>
                                    </td>
                                    
                                </tr>
                                <tr>
                                    <th align="right">협력기관(기관명/소속/성명)</th>
                                    <td>
                                        <span id="cooInstNm"></span>
                                    </td>
                                    <th align="right">과제기간</th>
                                    <td>
                                        <span id="tssStrtDd"></span> ~ 
                                        <span id="tssFnhDd"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">개발인원</th>
                                    <td>
                                        <span id="mbrCnt"></span>
                                    </td>
                                    <th align="right">소요기간</th>
                                    <td>
                                        <span id="ttsDifMonth"></span> 개월
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">진행단계 / GRS</th>
                                    <td><span id="tssStepNm"></span> / <span id="grsStepNm"></span></td>
                                    <th align="right">Q-gate 단계</th>
                                    <td><span id="qgateStepNm"></span> </td>
                                </tr>


                            </tbody>
                        </table>
                    </fieldset>
                </form>
            </div>    
            <br/>
            
            <div id="tabView"></div>
            
            <form name="tabForm" id="tabForm" method="post">
                <iframe name="tabContent0" id="tabContent0" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent1" id="tabContent1" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent2" id="tabContent2" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent3" id="tabContent3" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent4" id="tabContent4" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
            </form>
  		</div><!-- //sub-content -->
  	</div><!-- //contents -->

</body>
</html>