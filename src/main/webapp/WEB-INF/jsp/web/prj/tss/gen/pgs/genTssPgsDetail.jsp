<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPgsDetail.jsp
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

<script type="text/javascript">
    var gvTssCd     = "";
    var gvUserId    = "${inputData._userId}";
    var gvPgsStepCd = "PG"; //진행상태:PG(진행)
    var gvTssSt     = "";
    var gvPkWbsCd   = "";
    var gvWbsCd   = "";
    var gvPageMode  = "";
    var progressrateReal = "${inputData.progressrateReal}";
    var progressrate     = "${inputData.progressrate}";
    var pgsStepNm = "";
    var gvInitFlowYn   = ""; //초기유동관리
    
    var dataSet;

    //Form
    var prjNm;
    var deptName;
    var ppslMbdNm;
    var bizDptNm;
    var wbsCd;
//     var tssNm;
    var saUserName;
    var bizDptNm;
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

        //조직코드
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            editable: false,
            width: 300
        });

        //발의주체
        ppslMbdNm = new Rui.ui.form.LTextBox({
            applyTo: 'ppslMbdNm',
            editable: false,
            width: 200
        });

        //사업부문(Funding기준)
        bizDptNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizDptNm',
            editable: false,
            width: 200
        });

        //WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            editable: false,
            width: 70
        });

        //과제명
         tssNm = new Rui.ui.form.LTextBox({
             applyTo: 'tssNm',
             editable: false,
             width: 500
         });

        //과제리더
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            editable: false,
            width: 200
        });

        // 과제속성
        tssAttrNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssAttrNm',
            editable: false,
            width: 200
        });

        //제품군
        prodGNm = new Rui.ui.form.LTextBox({
            applyTo: 'prodGNm',
            editable: false,
            width: 200
        });

        //연구분야
        rsstSpheNm = new Rui.ui.form.LTextBox({
            applyTo: 'rsstSpheNm',
            editable: false,
            width: 200
        });

        //유형
        tssTypeNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssTypeNm',
            editable: false,
            width: 200
        });

        //과제기간 시작일
        tssStrtDd = new Rui.ui.form.LTextBox({
            applyTo: 'tssStrtDd',
            editable: false,
            width: 100
        });

        // 과제기간 종료일
        tssFnhDd = new Rui.ui.form.LTextBox({
            applyTo: 'tssFnhDd',
            editable: false,
            width: 100
        });

        //참여인원
        mbrCnt = new Rui.ui.form.LTextBox({
            applyTo: 'mbrCnt',
            editable: false,
            width: 200
        });

        //Form 비활성화 여부
        disableFields = function() {
            //버튼여부
            //btnGrsRq.hide();
            btnAltrRq.hide();

            if("TR01" == dataSet.getNameValue(0, "tssRoleId") || "${inputData._userSabun}" == dataSet.getNameValue(0, "saSabunNew")) {
	            if(gvTssSt == "100") {
	                //btnGrsRq.show();
	                btnAltrRq.show();
	            }
            }

            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            Rui.select('.tssLableCss div').removeClass('L-disabled');
        }


        altrHistDialog = new Rui.ui.LFrameDialog({
   	        id: 'altrHistDialog',
   	        title: '변경이력상세',
   	        width: 800,
   	        height: 650,
   	        modal: true,
   	        visible: false
   	    });

       	altrHistDialog.render(document.body);

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
                , { id: 'ppslMbdNm' }  //발의주체
                , { id: 'bizDptCd' }   //사업부문(Funding기준)
                , { id: 'bizDptNm' }   //사업부문(Funding기준)
                , { id: 'wbsCd' }      //WBSCode
                , { id: 'pkWbsCd' }    //WBSCode
                , { id: 'tssNm' }      //과제명
                , { id: 'saSabunNew' } //과제리더사번
                , { id: 'saUserName' } //과제리더명
                , { id: 'tssAttrCd' }  //과제속성
                , { id: 'tssAttrNm' }  //과제속성
                , { id: 'tssStrtDd' }  //과제기간S
                , { id: 'tssFnhDd' }   //과제기간E
                , { id: 'pgsStepNm' }  //진행단계명
                , { id: 'tssSt' }      //과제상태
                , { id: 'pgsStepCd' }  //진행단계
                , { id: 'tssScnCd' }   //과제구분
                , { id: 'mbrCnt' }     //참여인원
                , { id: 'prodGCd' }    //제품군
                , { id: 'prodGNm' }    //제품군
                , { id: 'rsstSpheNm' }    //연구분야
                , { id: 'tssTypeNm' }    //유형
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
                , {id: 'tssStepNm'}	//관제 단계
                , {id: 'grsStepNm'}	//GRS 단계
                , {id: 'qgateStepNm'}	//Qgate 단계
            ]
        });
        dataSet.on('load', function(e) {
            gvTssCd   = stringNullChk(dataSet.getNameValue(0, "tssCd"));
            gvTssSt   = stringNullChk(dataSet.getNameValue(0, "tssSt"));
            gvPkWbsCd = stringNullChk(dataSet.getNameValue(0, "pkWbsCd"));
            gvPageMode = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            gvWbsCd = stringNullChk(dataSet.getNameValue(0, "wbsCd"));
            gvInitFlowYn = stringNullChk(dataSet.getNameValue(0, "gvInitFlowYn"));
            
            tmpTssStrtDd = dataSet.getNameValue(0, 'tssStrtDd');
            tmpTssFnhDd =  dataSet.getNameValue(0, 'tssFnhDd');
            
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
                , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'value' }
                , { id: 'deptName',   ctrlId: 'deptName',   value: 'value' }
                , { id: 'ppslMbdNm',  ctrlId: 'ppslMbdNm',  value: 'value' }
                , { id: 'bizDptNm',   ctrlId: 'bizDptNm',   value: 'value' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }
                , { id: 'saUserName', ctrlId: 'saUserName', value: 'value' }
                , { id: 'tssAttrNm',  ctrlId: 'tssAttrNm',  value: 'value' }
                , { id: 'tssStrtDd',  ctrlId: 'tssStrtDd',  value: 'value' }
                , { id: 'tssFnhDd',   ctrlId: 'tssFnhDd',   value: 'value' }
                , { id: 'mbrCnt',     ctrlId: 'mbrCnt',     value: 'value' }
                , { id: 'prodGNm',    ctrlId: 'prodGNm',    value: 'value' }
                , { id: 'rsstSpheNm', ctrlId: 'rsstSpheNm', value: 'value' }
                , { id: 'tssTypeNm',  ctrlId: 'tssTypeNm',  value: 'value' }
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
                { label: '개요', content: '<div id="div-content-test0"></div>' },
                { label: '참여연구원', content: '<div id="div-content-test1"></div>' },
                { label: 'WBS', content: '<div id="div-content-test2"></div>' },
                { label: '개발비', content: '<div id="div-content-test3"></div>' },
                { label: '목표 및 산출물', content: '<div id="div-content-test4"></div>' },
                { label: '변경이력', content: '<div id="div-content-test5"></div>' }
            ]
        });
        tabView.on('activeTabChange', function(e) {
            //iframe 숨기기
            for(var i = 0; i < 6; i++) {
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
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsSmryIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                }
                break;
            //참여연구원
            case 1:
            	if(e.isFirst) {
                	tabUrl = "<c:url value='/prj/tss/gen/genTssPgsPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "'/>" + "&pkWbsCd=" + gvPkWbsCd + "&pgsStepCd=PG";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                break;
            //WBS
            case 2:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsWBSIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                break;
            //개발비
            case 3:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsTrwiBudgIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
                }
                break;
            //목표 및 산출물
            case 4:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent4');
                }
                break;
            //변경이력
            case 5:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsAltrHistIfm.do?pkWbsCd=" + gvPkWbsCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent5');
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
        //GRS요청
        /*
        btnGrsRq = new Rui.ui.LButton('btnGrsRq');
        btnGrsRq.on('click', function() {
            Rui.confirm({
                text: 'GRS요청을 하시겠습니까?',
                handlerYes: function() {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/grs/grsEvRslt.do' />"+"?tssCd="+gvTssCd+"&userId="+gvUserId+"&callPageId=genTss");
                },
                handlerNo: Rui.emptyFn
            });
        });
 */

		 var confirmDialog = new Rui.ui.LFrameDialog({
		     id: 'confirmDialog',
		     title: '변경요청',
		     width: 550,
		     height: 320,
		     modal: true,
		     visible: false,
		     buttons: [
		             { text: '단순변경', handler: function(){
		            	 nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssPgsAltrCsus.do' />"+"?tssCd="+gvTssCd+"&userId="+gvUserId+"&gbnCd=DL");
		             }},
		             { text: 'GRS심의요청', handler: function(){
		            	 nwinsActSubmit(document.mstForm, "<c:url value='/prj/grs/grsEvRslt.do' />"+"?tssCd="+gvTssCd+"&userId="+gvUserId+"&callPageId=genTss");
		             }},
		             { text: 'Close', handler: function(){
		                 this.cancel();
		             }},
		         ]
		 });

		 confirmDialog.render(document.body);

		 openDialog = function(url){
			 confirmDialog.setUrl('<c:url value="/prj/tss/gen/confirmPopup.do?tssCd="/>' + gvTssCd + '&userIds=' + gvUserId);
			 confirmDialog.show();
         };

		 //변경요청
        btnAltrRq = new Rui.ui.LButton('btnAltrRq');
        btnAltrRq.on('click', function() {
        	openDialog();
        });

        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("mst searchData1");
            dataSet.loadData(${result});
        }

        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
			$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
			$('#searchForm > input[name=saUserName]').val(encodeURIComponent($('#searchForm > input[name=saUserName]').val()));
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));

            nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });

        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnAltrRq").hide();
        	//$("#btnGrsRq").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnAltrRq").hide();
        	//$("#btnGrsRq").hide();
		}
    });

    function fncGenTssAltrDetail(cd) {
    	var params = "?tssCd="+cd;
   		altrHistDialog.setUrl('<c:url value="/prj/tss/gen/genTssAltrDetailPopup.do"/>'+params);
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
	<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
</form>

    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
	    <div class="titleArea">
	    	<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
	        <h2>연구팀 과제 &gt;&gt; 진행</h2>
	    </div> 
        <div class="sub-content">
            <div class="titArea mt0">
                <div class="LblockButton">
                    <button type="button" id="btnAltrRq" name="btnAltrRq">변경요청</button>
                    <!-- <button type="button" id="btnGrsRq" name="btnGrsRq">GRS요청</button> -->
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 14%;" />
                                <col style="width: 36%;" />
                                <col style="width: 14%;" />
                                <col style="width: 36%;" />
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
                                	<th align="right">WBSCode / 과제명</th>
                                    <td class="tssLableCss" colspan="3">
                                        <input type="text" id="wbsCd" />  /  <em class="gab"> <input type="text" id="tssNm" style="width:900px;padding:0px 5px" />
                                    </td>
                                <tr>
                                    <th align="right">과제리더</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="saUserName" />
                                    </td>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="bizDptNm" />
                                    </td>
                                </tr>
                               <tr>
                               		<th align="right">발의주체</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="ppslMbdNm" />
                                    </td>
                                    <th align="right">제품군</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="prodGNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제속성</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="tssAttrNm" />
                                    </td>
                                    <th align="right">과제기간</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="tssStrtDd" /> ~ <input type="text" id="tssFnhDd" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">연구분야</th>
                                    <td class="tssLableCss">
                                        <div id="rsstSpheNm">
                                    </td>
                                    <th align="right">개발등급</th>
                                    <td class="tssLableCss">
                                        <div id="tssTypeNm">
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">참여인원</th>
                                    <td class="tssLableCss" colspan="3">
                                        <input type="text" id="mbrCnt" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">진행단계 / GRS</th>
                                    <td><span id="tssStepNm"/> / <span id="grsStepNm"/></td>
                                    <th align="right">Q-gate 단계</th>
                                    <td><span id="qgateStepNm"/> </td>
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
            </form>
        </div>
    </div>
</body>
</html>