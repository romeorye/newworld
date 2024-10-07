<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssCmplDetail.jsp
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
<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>
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
    var gvTssSt     = "";
    var gvPgsStepCd = "CM"; //진행상태:CM(완료)
    var gvPkWbsCd   = "";
    var gvPageMode  = "";
    var progressrateReal = "${inputData.progressrateReal}";
    var progressrate     = "${inputData.progressrate}";
    var pGrsEvSt     = "${inputData.pGrsEvSt}";

    var initFlowYn     = "";
    var initFlowStrtDt = "";
    var initFlowFnhDt  = "";

    var cmplTssCd   = "";
    var dataSet;
    var altrHistDialog;
    var rtnMsg = "${inputData.rtnMsg}";
    var itmFlag ="N";	//필수산출물 체크
    var gvWbsCd   = "";
    
    var gvGuid        = "${resultCsus.guid}";
    var gvAprdocState = "${resultCsus.aprdocstate}";
    
    var pPgsStepCd     = "";

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

        //발의주체
        ppslMbdNm = new Rui.ui.form.LTextBox({
            applyTo: 'ppslMbdNm',
            editable: false,
            width: 300
        });

        //참여연구원 수
        mbrCnt = new Rui.ui.form.LTextBox({
            applyTo: 'mbrCnt',
            editable: false,
            width: 100
        });

        //사업부문(Funding기준)
        bizDptNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizDptNm',
            editable: false,
            width: 150
        });

        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            editable: false,
            width: 500
        });

        //wbs code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            editable: false,
            width: 100
        });

        //과제리더
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            editable: false,
            width: 200
        });

        //과제속성
        tssAttrNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssAttrNm',
            editable: false,
            width: 150
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


        //계획 시작일
        tssStrtDd = new Rui.ui.form.LTextBox({
            applyTo: 'tssStrtDd',
            editable: false,
            width: 100
        });

        //계획 종료일
        tssFnhDd = new Rui.ui.form.LTextBox({
            applyTo: 'tssFnhDd',
            editable: false,
            width: 100
        });

        //실적 시작일
        cmplBStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'cmplBStrtDd',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        cmplBStrtDd.on('blur', function() {
            if(Rui.isEmpty(cmplBStrtDd.getValue())) return;

            if(!Rui.isEmpty(cmplBFnhDd.getValue())) {
                var startDt = cmplBStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = cmplBFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    cmplBStrtDd.setValue("");
                    return;
                }
            }
        });

        //실적 종료일
        cmplBFnhDd = new Rui.ui.form.LDateBox({
            applyTo: 'cmplBFnhDd',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        cmplBFnhDd.on('blur', function() {
            if(Rui.isEmpty(cmplBFnhDd.getValue())) return;

            if(!Rui.isEmpty(cmplBStrtDd.getValue())) {
                var startDt = cmplBStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = cmplBFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    cmplBFnhDd.setValue("");
                    return;
                }
            }


          	if (!Rui.isEmpty( dataSet.getNameValue(0, 'evDt')   )    )  {
          		var evDt  =  dataSet.getNameValue(0, 'evDt').replace(/\-/g, "").toDate();
                var fnhDt =  cmplBFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - evDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("GRS 회의일보다 실적종료일이 빠를 수 없습니다.");
                    cmplBFnhDd.setValue("");
                    cmplBFnhDd.focus();
                    return;
                }
          	}

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
            btnCsusRq.hide(); //[춤의서요청]
            btnCsusRq2.hide(); //[초기유동 품의서요청]
            //btnAltrRq.hide(); //[변경요청]
            
            if("TR01" == dataSet.getNameValue(0, "tssRoleId") || "${inputData._userSabun}" == dataSet.getNameValue(0, "saSabunNew")) {
                if(gvTssSt == "100" || gvTssSt == "102") {
                	btnCsusRq.show(); //100: 작성중, 102: GRS평가완료
                	//btnAltrRq.show(); //100: 작성중, 102: GRS평가완료
                } else if (gvTssSt == "600") { // 600: 초기유동작성중
                	btnCsusRq2.show();
                }
            }

            //if(gvTssSt=="104" || gvTssSt=="600" || gvTssSt=="603" || gvTssSt=="604"){
            if(gvTssSt != "100" && gvTssSt != "") {
                setReadonly("cmplBStrtDd");
                setReadonly("cmplBFnhDd");
            }

            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            Rui.select('.tssLableCss div').removeClass('L-disabled');
        }



        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'mstDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }          //과제코드
                , { id: 'userId' }         //로그인ID
                , { id: 'prjNm' }          //프로젝트명
                , { id: 'pgsStepCd' }      //진행단계코드
                , { id: 'tssScnCd' }       //과제구분코드
                , { id: 'wbsCd' }          //WBS코드
                , { id: 'pkWbsCd' }        //WBS코드
                , { id: 'tssNm' }          //과제명
                , { id: 'wbsNm' }          //과제명+ wbsCd
                , { id: 'saSabunNew' }     //과제리더사번
                , { id: 'tssAttrCd' }      //과제속성코드
                , { id: 'tssStrtDd' }      //과제시작일
                , { id: 'tssFnhDd' }       //과제종료일
                , { id: 'cmplBStrtDd' }    //완료전시작일
                , { id: 'cmplBFnhDd' }     //완료전종료일
                , { id: 'tssSt' }          //과제상태
                , { id: 'saUserName' }     //과제리더명
                , { id: 'deptName' }       //조직(소속)명
                , { id: 'pgsStepNm' }      //진행단계명
                , { id: 'ppslMbdNm' }      //발의주체명
                , { id: 'bizDptNm' }       //과제유형명
                , { id: 'tssAttrNm' }      //과제속성명
                , { id: 'pgTssCd' }        //진행과제코드
                , { id: 'prodGCd' }        //제품군
                , { id: 'prodGNm' }        //제품군
                , { id: 'rsstSpheNm' }    //연구분야
                , { id: 'tssTypeNm' }    //유형
                , { id: 'tssRoleType' }
                , { id: 'mbrCnt' }
                , { id: 'tssRoleId' }
                , { id: 'tssStepNm'}	//관제 단계
                , { id: 'grsStepNm'}	//GRS 단계
                , { id: 'qgateStepNm'}	//Qgate 단계
                , { id: 'evDt'}	//Qgate 단계
                , { id: 'initFlowYn'}	//초기유동관리여부
                , { id: 'initFlowStrtDt'}	//초기유동관리시작일
                , { id: 'initFlowFnhDt'}	//초기유동관리종료일
            ]
        });
        dataSet.on('load', function(e) {
            gvTssCd     = stringNullChk(dataSet.getNameValue(0, "pgTssCd")); //진행단계 과제코드
            gvPageMode  = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            gvPkWbsCd   = dataSet.getNameValue(0, "pkWbsCd");
            gvWbsCd     = stringNullChk(dataSet.getNameValue(0, "wbsCd"));
            //gvPgsStepCd = stringNullChk(dataSet.getNameValue(0, "pgsStepCd"));
            
            initFlowYn = stringNullChk(dataSet.getNameValue(0, "initFlowYn"));
            initFlowStrtDt = stringNullChk(dataSet.getNameValue(0, "initFlowStrtDt"));
            initFlowFnhDt = stringNullChk(dataSet.getNameValue(0, "initFlowFnhDt"));
            
            document.tabForm.tssSt.value = dataSet.getNameValue(0, "tssSt");
            document.tabForm.pgsStepCd.value = dataSet.getNameValue(0, "pgsStepCd");
            /* document.tabForm.initFlowYn.value = initFlowYn;
            document.tabForm.initFlowStrtDt.value = initFlowStrtDt;
            document.tabForm.initFlowFnhDt.value = initFlowFnhDt; */
            
            pPgsStepCd = dataSet.getNameValue(0, "pgsStepCd");

            //PG:진행단계
            if(pPgsStepCd == "PG") {
                cmplTssCd = "";  //완료단계 과제코드
                gvTssSt = ""; //과제상태
            }
            //CM:완료단계
            else if(pPgsStepCd == "CM") {
                cmplTssCd = dataSet.getNameValue(0, "tssCd"); //완료단계 과제코드
                gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt")); //과제상태
            }

            tmpTssStrtDd = dataSet.getNameValue(0, 'tssStrtDd');
            tmpTssFnhDd =  dataSet.getNameValue(0, 'tssFnhDd');
            
            /* 초기유동관리 여부 */
            //$("#initFlowYn").val(dataSet.getNameValue(0, "initFlowYn"));
            /* 초기유동관리시작일 */
            //$("#initFlowStrtDt").val(dataSet.getNameValue(0, "initFlowStrtDt"));
            /* 초기유동관리종료일 */
            //$("#initFlowFnhDt").val(dataSet.getNameValue(0, "initFlowFnhDt"));
        
            //document.getElementById('tssNm').innerHTML = dataSet.getNameValue(0, "tssNm");
            //document.getElementById('wbsNm').innerHTML = dataSet.getNameValue(0, "wbsNm");

            tmpInitFlowStrtDt = dataSet.getNameValue(0, 'initFlowStrtDt');
            tmpInitFlowFnhDt =  dataSet.getNameValue(0, 'initFlowFnhDt');
            
            disableFields();

            tabView.selectTab(0);

            if(!Rui.isEmpty(rtnMsg)){
            	if(rtnMsg == "G"){
            		Rui.alert("목표기술성과 실적값을 모두 입력하셔야 합니다.");
            	}else if(rtnMsg == "P"){
            		Rui.alert("진척율값이 100이 아닙니다.");
            	}else if(rtnMsg == "I"){
            		Rui.alert("필수산출물을 모두 등록하셔야 합니다.");
            	}
            }
        });


        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'prjNm',       ctrlId: 'prjNm',       value: 'value' }
                , { id: 'wbsCd',       ctrlId: 'wbsCd',    	  value: 'value' }
                , { id: 'tssNm',       ctrlId: 'tssNm',       value: 'value' }
                , { id: 'deptName',    ctrlId: 'deptName',    value: 'value' }
                , { id: 'ppslMbdNm',   ctrlId: 'ppslMbdNm',   value: 'value' }
                , { id: 'bizDptNm',    ctrlId: 'bizDptNm',    value: 'value' }
                , { id: 'saUserName',  ctrlId: 'saUserName',  value: 'value' }
                , { id: 'tssAttrNm',   ctrlId: 'tssAttrNm',   value: 'value' }
                , { id: 'tssStrtDd',   ctrlId: 'tssStrtDd',   value: 'value' }
                , { id: 'tssFnhDd',    ctrlId: 'tssFnhDd',    value: 'value' }
                , { id: 'cmplBStrtDd', ctrlId: 'cmplBStrtDd', value: 'value' }
                , { id: 'cmplBFnhDd',  ctrlId: 'cmplBFnhDd',  value: 'value' }
                , { id: 'prodGNm',     ctrlId: 'prodGNm',     value: 'value' }
                , { id: 'rsstSpheNm', ctrlId: 'rsstSpheNm', value: 'value' }
                , { id: 'tssTypeNm',  ctrlId: 'tssTypeNm',  value: 'value' }
                , { id: 'mbrCnt',  ctrlId: 'mbrCnt',  value: 'value' }
                , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'html' }				//과제 단계명
                , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'html' }				// GRS 단계명
                , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'html' }		//Qgate 단계명
                
                , { id: 'initFlowYn',    ctrlId: 'initFlowYn',    value: 'value' }
                , { id: 'initFlowStrtDt',    ctrlId: 'initFlowStrtDt',    value: 'value' }
                , { id: 'initFlowFnhDt',    ctrlId: 'initFlowFnhDt',    value: 'value' }
            ]
        });


        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'cmplBStrtDd', validExp: '실적시작일:true' }
                , { id: 'cmplBFnhDd',  validExp: '실적종료일:true' }
            ]
        });


        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);

            Rui.alert(data.records[0].rtVal);

            //실패일경우 ds insert모드로 변경
            if(data.records[0].rtCd == "FAIL") {
                dataSet.setState(0, 1);
            } else {
                //신규저장일 경우 pk값 전역으로 셋팅
                if(data.records[0].rtType == "I") {
                    dataSet.loadData(data);
                }
                else {
                    disableFields();
                }
            }
        });



        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                 { label: '완료', content: '<div id="div-content-test0"></div>' }
                ,{ label: '개요', content: '<div id="div-content-test1"></div>' }
                ,{ label: '참여연구원', content: '<div id="div-content-test2"></div>' }
                ,{ label: 'WBS', content: '<div id="div-content-test3"></div>' }
                ,{ label: '개발비', content: '<div id="div-content-test4"></div>' }
                ,{ label: '목표 및 산출물', content: '<div id="div-content-test5"></div>' }
                ,{ label: '변경이력', content: '<div id="div-content-test6"></div>' }
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
            //완료
            case 0:
                if(e.isFirst) { gvTssSt.indexOf("60") > -1
                	if( gvTssSt.indexOf("60") > -1 ) {
                        tabView.getActiveTab().setLabel("초기유동관리");
                        //tabUrl = "<c:url value='/prj/tss/gen/genTssCmplIfm.do?tssCd="+cmplTssCd+"&pgTssCd="+gvTssCd+"'/>";
                    } else {
                    	tabView.getActiveTab().setLabel("완료");
                        //tabUrl = "<c:url value='/prj/tss/gen/genTssCmplIfm.do?tssCd="+cmplTssCd+"&pgTssCd="+gvTssCd+"'/>";
                    }
                	
                    tabUrl = "<c:url value='/prj/tss/gen/genTssCmplIfm.do?tssCd="+cmplTssCd+"&pgTssCd="+gvTssCd+"'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                }
                break;
            //개요
            case 1:
            	if(e.isFirst) {
                	tabUrl = "<c:url value='/prj/tss/gen/genTssPgsSmryIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                break;
                //참여연구원
            case 2:
                if(e.isFirst) {
                	//[2024.09.26]초기유동관리 단계가 추가되면 변경함
                	//tabUrl = "<c:url value='/prj/tss/gen/genTssPgsPtcRsstMbrIfm.do?tssCd="+ gvTssCd+"&pkWbsCd=" + gvPkWbsCd + "&pgsStepCd=PG'/>";
                	tabUrl = "<c:url value='/prj/tss/gen/genTssCmplPtcRsstMbrIfm.do?tssCd="+ gvTssCd+"&pkWbsCd=" + gvPkWbsCd + "&pgsStepCd=CM'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                break;
            //WBS
            case 3:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsWBSIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
                }
                break;
            //개발비
            case 4:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsTrwiBudgIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent4');
                }
                break;
            //목표 및 산출물
            case 5:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent5');
                }
                break;
            //변경이력
            case 6:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsAltrHistIfm.do?pkWbsCd=" + gvPkWbsCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent6');
                }
                break;
            /*//초기유동관리
            case 7:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssCmplPtcRsstMbrIfm.do?tssCd="+ gvTssCd+"&pkWbsCd=" + gvPkWbsCd + "&pgsStepCd=CM'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent7');
                }
                break;*/
            default:
                break;
            }
        });
        tabView.render('tabView');

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
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
		if($("#btnAltrRq").length > 0){
	        btnAltrRq = new Rui.ui.LButton('btnAltrRq');
	        btnAltrRq.on('click', function() {
	        	openDialog();
	        });
		}

        //[품의서요청]
        if($("#btnCsusRq").length > 0){
	        btnCsusRq = new Rui.ui.LButton('btnCsusRq');
	        btnCsusRq.on('click', function() {

				/* var chkNum =   document.getElementById('tabContent0').contentWindow.fnAttchValid();  
				
	        	if(chkNum == 0){
	        		Rui.alert("평가 결과서 첨부파일을 추가하셔야 합니다.");
	        		return;
	        	} */
	        	
	            document.mstForm.tssSt.value = dataSet.getNameValue(0, 'tssSt');
	            document.mstForm.pgsStepCd.value = dataSet.getNameValue(0, 'pgsStepCd');
	            /* document.mstForm.initFlowYn.value = dataSet.getNameValue(0, 'initFlowYn');
	            document.mstForm.initFlowStrtDt.value = dataSet.getNameValue(0, 'initFlowStrtDt');
	            document.mstForm.initFlowFnhDt.value = dataSet.getNameValue(0, 'initFlowFnhDt'); */
	
	            var pgsStepCd = document.mstForm.pgsStepCd.value;
	            console.log("[pgsStepCd]", pgsStepCd);
	
	            /* console.log("[tabContent5]('01').length", $("#tabContent5").contents().find("[yldType='01']").length);
	            console.log("[tabContent5]('01')", $("#tabContent5").contents().find("[yldType='01']:contains('Y')").size());
	            console.log("[tabContent5]('03').length", $("#tabContent5").contents().find("[yldType='03']").length);
	            console.log("[tabContent5]('03')", $("#tabContent5").contents().find("[yldType='03']:contains('Y')").size());
	            console.log("[tabContent5]('06').length", $("#tabContent5").contents().find("[yldType='06']").length);
	            console.log("[tabContent5]('06')", $("#tabContent5").contents().find("[yldType='06']:contains('Y')").size());
	            console.log("[tabContent5]('10').length", $("#tabContent5").contents().find("[yldType='10']").length);
	            console.log("[tabContent5]('10')", $("#tabContent5").contents().find("[yldType='10']:contains('Y')").size()); */
	
	            if (pgsStepCd == "CM" || pgsStepCd == "DC"){
	                //if ($("#tabContent5").contents().find("[yldItmType='01']:contains('Y'),[yldItmType='03']:contains('Y'),[yldItmType='06']:contains('Y'),[yldItmType='10']:contains('Y')").size()<4){
	                if (  ( $("#tabContent5").contents().find("[yldType='01']").length == 0 )
	                	||( $("#tabContent5").contents().find("[yldType='01']").length>0 && $("#tabContent5").contents().find("[yldType='01']:contains('Y')").size()==0 )
	                    ||( $("#tabContent5").contents().find("[yldType='03']").length>0 && $("#tabContent5").contents().find("[yldType='03']:contains('Y')").size()==0 )
	                    ||( $("#tabContent5").contents().find("[yldType='06']").length>0 && $("#tabContent5").contents().find("[yldType='06']:contains('Y')").size()==0 )
	                    ||( $("#tabContent5").contents().find("[yldType='10']").length>0 && $("#tabContent5").contents().find("[yldType='10']:contains('Y')").size()==0 ) ) {
	
	                    //Rui.alert("필수산출물을 모두 등록하셔야 합니다.");
	                    Rui.alert("목표및산출물 탭의 필수산출물이 모두 등록되었는지<br/>또는 첨부파일 유무가 'Y'인지 확인하시기 바랍니다.");
	                    return;
	                }
	            }
	
	          	Rui.confirm({
	                text: '품의서요청을 하시겠습니까?',
	                handlerYes: function() {
	                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssCmplCsusRq.do'/>" + "?tssCd="+cmplTssCd+"&userId="+gvUserId+"&wbsCd="+gvWbsCd+"&itmFlag="+itmFlag+"&appCode=APP00332"+"&pgTssCd="+gvTssCd);
	                },
	                handlerNo: Rui.emptyFn
	            });
	        });
	    }
	    
        //[초기유동 품의서요청]
        if($("#btnCsusRq2").length > 0){
        	btnCsusRq2 = new Rui.ui.LButton('btnCsusRq2');
	        btnCsusRq2.on('click', function() {
	            document.mstForm.tssSt.value = dataSet.getNameValue(0, 'tssSt');
	            document.mstForm.pgsStepCd.value = dataSet.getNameValue(0, 'pgsStepCd');
	
	            var pgsStepCd = document.mstForm.pgsStepCd.value;
	
	            if (pgsStepCd == "CM" || pgsStepCd == "DC"){
	            }
	
	          	Rui.confirm({
	                text: '초기유동 품의서요청을 하시겠습니까?',
	                handlerYes: function() {
	                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssCmplCsusRq.do'/>" + "?tssCd="+cmplTssCd+"&userId="+gvUserId+"&wbsCd="+gvWbsCd+"&itmFlag="+itmFlag+"&appCode=APP00332"+"&pgTssCd="+gvTssCd);
	                },
	                handlerNo: Rui.emptyFn
	            });
	        });
        }
	        
	        
        fnInitFlow = function(initFlowYn, initFlowStrtDt, initFlowFnhDt) {
        	$("#initFlowYn").val(initFlowYn);
        	$("#initFlowStrtDt").val(initFlowStrtDt);
        	$("#initFlowFnhDt").val(initFlowFnhDt);
        	
        	tmpInitFlowStrtDt = Rui.isEmpty(initFlowStrtDt) ? tmpInitFlowStrtDt : initFlowStrtDt;
        	tmpInitFlowFnhDt  = Rui.isEmpty(initFlowFnhDt) ? tmpInitFlowFnhDt : initFlowFnhDt;
        }
        
        //저장
        fnSave = function() {
            cmplBStrtDd.blur();
            cmplBFnhDd.blur();

            //마스터 vm
            if(!vm.validateGroup("mstForm")) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return;
            }

            //개요탭 validation
            dataSet.setNameValue(0, "initFlowYn",     $("#initFlowYn").val()); 
            dataSet.setNameValue(0, "initFlowStrtDt", $("#initFlowStrtDt").val());
            dataSet.setNameValue(0, "initFlowFnhDt",  $("#initFlowFnhDt").val());

            console.log("[ifmUpdate]",ifmUpdate);
            console.log("[dataSet]",dataSet);

            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");
            if(!ifmUpdate) return false;

            //수정여부
            var smryDs = document.getElementById('tabContent0').contentWindow.dataSet; //개요탭 DS
            console.log("[smryDs.isUpdated()]",smryDs.isUpdated());
            console.log("[dataSet.isUpdated()]",dataSet.isUpdated());
            
            //if( !(dataSet.isUpdated() || smryDs.isUpdated()) ) {
            if(!dataSet.isUpdated() && !smryDs.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
	                var smryTssCd = stringNullChk(smryDs.getNameValue(0, "tssCd"));

	                dataSet.setNameValue(0, "pgsStepCd", "CM"); //진행단계: CM(완료)
	                dataSet.setNameValue(0, "tssScnCd", "G");   //과제구분: G(일반)
	                dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
	                dataSet.setNameValue(0, "tssCd",  cmplTssCd); //과제코드
	                dataSet.setNameValue(0, "userId", gvUserId);  //사용자ID
	                dataSet.setNameValue(0, "tssRoleType", "W"); //화면권한

	                smryDs.setNameValue(0, "tssCd",  cmplTssCd); //과제코드
	                smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID
	                
	                //신규
	                if(cmplTssCd == "") {
	                    dm.updateDataSet({
	                        modifiedOnly: false,
	                        url:'<c:url value="/prj/tss/gen/insertGenTssCmplMst.do"/>',
	                        dataSets:[dataSet, smryDs]
	                    });
	                    
	                    document.searchForm.tssSt.value = "";
	    	            document.searchForm.pgsStepCd.value = "";
	                    
	                    btnList.click(); //신규일때 TSS_CD가 새로 부여되므로 목록으로 보내기 [아주중요]
	                }
	                //수정
	                else {
	                    dm.updateDataSet({
	                        modifiedOnly: false,
	                        url:'<c:url value="/prj/tss/gen/updateGenTssCmplMst.do"/>',
	                        dataSets:[dataSet, smryDs]
	                    });
	                }
                },
                handlerNo: Rui.emptyFn
            });
        };

        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
			$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
			$('#searchForm > input[name=saUserName]').val(encodeURIComponent($('#searchForm > input[name=saUserName]').val()));
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));

            nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });

        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("mst searchData1");
            dataSet.loadData(${result});
        }

        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1 || "<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnCsusRq").hide();
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
	        <h2>연구팀 과제 &gt;&gt; 완료</h2>
	    </div>
        <div class="sub-content">
            <div class="titArea mt0">
                <div class="LblockButton">
                    <button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
                    <button type="button" id="btnCsusRq2" name="btnCsusRq2">초기유동 품의서요청</button>
                    <!-- <button type="button" id="btnAltrRq" name="btnAltrRq">변경요청</button> -->
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
                	<input type="hidden" id="pgsStepCd" name="pgsStepCd" />
                	<input type="hidden" id="tssSt" name="tssSt" />
                	
                	<input type="hidden" id="initFlowYn" name="initFlowYn" />
                	<input type="hidden" id="initFlowStrtDt" name="initFlowStrtDt" />
                	<input type="hidden" id="initFlowFnhDt" name="initFlowFnhDt" />
                	
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
                                    <th align="right">WBSCode / 과제명</th>
                                    <td class="tssLableCss" colspan="3">
                                        <input type="text" id="wbsCd" /> / <em class="gab"> <input type="text" id="tssNm" style="width:900px;padding:0px 5px" />
                                    </td>
                                </tr>
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
                                	<th align="right">과제속성</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="tssAttrNm"></div>
                                    </td>
                                    <th align="right">참여인원</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="mbrCnt" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">계획(개발계획시점)</th>
                                    <td class="tssLableCss gen_tain">
                                        <input type="text" id="tssStrtDd" value="" /><em class="gab"> ~ </em>
                                        <input type="text" id="tssFnhDd" value="" />
                                    </td>
                                    <th align="right"><span style="color:red;">* </span>실적(개발완료시점)</th>
                                    <td>
                                        <input type="text" id="cmplBStrtDd" value="" /><em class="gab"> ~ </em>
                                        <input type="text" id="cmplBFnhDd" value="" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">진행단계 | GRS</th>
                                    <td>
                                        <div style="float:left;"><span id="tssStepNm"/></div>
                                        <div style="float:left;">&nbsp;|&nbsp;</div>
                                        <div style="float:left;"><span id="grsStepNm"/></div>
                                    </td>
                                    <th align="right">Q-gate 단계</th>
                                    <td><span id="qgateStepNm"/></td>
                                </tr>
                            </tbody>
                        </table>
                    </fieldset>
                </form>
            </div>
            <br/>

            <div id="tabView"></div>

            <form name="tabForm" id="tabForm" method="post">
            	<input type="hidden" id="tssSt" name="tssSt" value=""/>
            	<input type="hidden" id="pgsStepCd" name="pgsStepCd" value=""/>
                <iframe name="tabContent0" id="tabContent0" scrolling="yes" width="100%" height="100%" frameborder="0" ></iframe>
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