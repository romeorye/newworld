<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssDcacDetail.jsp
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
    var gvPgsStepCd = "DC"; //진행상태:DC(중단)
    var gvPkWbsCd   = "";
    var gvWbsCd   = "";
    var gvPageMode  = "";
    var progressrateReal = "${inputData.progressrateReal}";
    var progressrate     = "${inputData.progressrate}";

    var dcacTssCd   = "";
    var dataSet;
    var rtnMsg = "${inputData.rtnMsg}";
    var itmFlag ="Y";    //필수산출물 체크
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
            width: 300
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

        //wbsCd
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
        dcacBStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'dcacBStrtDd',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        dcacBStrtDd.on('blur', function() {
            if(Rui.isEmpty(dcacBStrtDd.getValue())) return;

            if(!Rui.isEmpty(dcacBFnhDd.getValue())) {
                var startDt = dcacBStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = dcacBFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    dcacBStrtDd.setValue("");
                    return;
                }
            }
        });

        //실적 종료일
        dcacBFnhDd = new Rui.ui.form.LDateBox({
            applyTo: 'dcacBFnhDd',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        dcacBFnhDd.on('blur', function() {
            if(Rui.isEmpty(dcacBFnhDd.getValue())) return;

            if(!Rui.isEmpty(dcacBStrtDd.getValue())) {
                var startDt = dcacBStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = dcacBFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    dcacBFnhDd.setValue("");
                    return;
                }
            }
        });

      //참여연구원 수
        mbrCnt = new Rui.ui.form.LTextBox({
            applyTo: 'mbrCnt',
            editable: false,
            width: 100
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
            btnCsusRq.hide();

            if("TR01" == dataSet.getNameValue(0, "tssRoleId") || "${inputData._userSabun}" == dataSet.getNameValue(0, "saSabunNew")) {
                if(gvTssSt == "100") btnCsusRq.show(); //GRS - 100:작성중
                if(gvTssSt == "102") btnCsusRq.show(); //GRS - 100:작성중
                if(gvTssSt == "302") btnCsusRq.show(); //GRS - 100:작성중
            }

            if(gvTssSt=="104"){
                setReadonly("dcacBStrtDd");
                setReadonly("dcacBFnhDd");
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
                , { id: 'wbsNm' }          //과제명+ wbscd
                , { id: 'saSabunNew' }     //과제리더사번
                , { id: 'tssAttrCd' }      //과제속성코드
                , { id: 'tssStrtDd' }      //과제시작일
                , { id: 'tssFnhDd' }       //과제종료일
                , { id: 'dcacBStrtDd' }    //중단전시작일
                , { id: 'dcacBFnhDd' }     //중단전종료일
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
                , { id: 'tssRoleId' }
                , { id: 'mbrCnt' }
                , {id: 'tssStepNm'}    //관제 단계
                , {id: 'grsStepNm'}    //GRS 단계
                , {id: 'qgateStepNm'}    //Qgate 단계
            ]
        });
        dataSet.on('load', function(e) {
            gvTssCd    = stringNullChk(dataSet.getNameValue(0, "pgTssCd")); //진행단계 과제코드
            gvTssSt    = stringNullChk(dataSet.getNameValue(0, "pgTssSt")); //진행단계 코드
            gvPageMode = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            gvPkWbsCd  = dataSet.getNameValue(0, "pkWbsCd");
            gvWbsCd  = dataSet.getNameValue(0, "wbsCd");
            document.tabForm.tssSt.value = dataSet.getNameValue(0, "tssSt");
            document.tabForm.pgsStepCd.value = dataSet.getNameValue(0, "pgsStepCd");

            var pPgsStepCd = dataSet.getNameValue(0, "pgsStepCd");

            //PG:진행단계
            if(pPgsStepCd == "PG") {
                dcacTssCd = "";  //중단단계 과제코드
                gvTssSt = ""; //과제상태
            }
            //DC:중단단계, HD:보류단계 추가
            else if(pPgsStepCd == "DC" || pPgsStepCd == "HD") {
                dcacTssCd = dataSet.getNameValue(0, "tssCd"); //중단단계 과제코드
                gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt")); //과제상태
                if (gvTssCd == "" ) {
                    gvTssCd = dcacTssCd; //중단단계 과제코드
                }
            }

            //document.getElementById('tssNm').innerHTML = dataSet.getNameValue(0, "tssNm");
            //document.getElementById('wbsNm').innerHTML = dataSet.getNameValue(0, "wbsNm");
            disableFields();

            tabView.selectTab(0);

            if(!Rui.isEmpty(rtnMsg)){
                if(rtnMsg == "G"){
                    Rui.alert("목표기술성과 실적값을 모두 입력하셔야 합니다.");
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
                , { id: 'wbsCd',    ctrlId: 'wbsCd',    value: 'value' }
                , { id: 'mbrCnt',    ctrlId: 'mbrCnt',    value: 'value' }
                , { id: 'tssNm',    ctrlId: 'tssNm',    value: 'value' }
                , { id: 'ppslMbdNm',   ctrlId: 'ppslMbdNm',   value: 'value' }
                , { id: 'bizDptNm',    ctrlId: 'bizDptNm',    value: 'value' }
                , { id: 'saUserName',  ctrlId: 'saUserName',  value: 'value' }
                , { id: 'tssAttrNm',   ctrlId: 'tssAttrNm',   value: 'value' }
                , { id: 'tssStrtDd',   ctrlId: 'tssStrtDd',   value: 'value' }
                , { id: 'tssFnhDd',    ctrlId: 'tssFnhDd',    value: 'value' }
                , { id: 'dcacBStrtDd', ctrlId: 'dcacBStrtDd', value: 'value' }
                , { id: 'dcacBFnhDd',  ctrlId: 'dcacBFnhDd',  value: 'value' }
                , { id: 'prodGNm',     ctrlId: 'prodGNm',     value: 'value' }
                , { id: 'rsstSpheNm', ctrlId: 'rsstSpheNm', value: 'value' }
                , { id: 'tssTypeNm',  ctrlId: 'tssTypeNm',  value: 'value' }
                , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'html' }                //과제 단계명
                , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'html' }                // GRS 단계명
                , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'html' }        //Qgate 단계명


            ]
        });


        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'dcacBStrtDd', validExp: '실적시작일:true' }
                , { id: 'dcacBFnhDd',  validExp: '실적종료일:true' }
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
            }
        });



        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: '중단', content: '<div id="div-content-test0"></div>' },
                { label: '개요', content: '<div id="div-content-test1"></div>' },
                { label: '참여연구원', content: '<div id="div-content-test2"></div>' },
                { label: 'WBS', content: '<div id="div-content-test3"></div>' },
                { label: '개발비', content: '<div id="div-content-test4"></div>' },
                { label: '목표 및 산출물', content: '<div id="div-content-test5"></div>' },
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
            //완료
            case 0:
                if(e.isFirst) {
                    /* tabUrl = "<c:url value='/prj/tss/gen/genTssDcacSmryIfm.do?tssCd=" + dcacTssCd + "'/>"; */
                    tabUrl = "<c:url value='/prj/tss/gen/genTssDcacSmryIfm.do?tssCd=" + dcacTssCd+"&pgTssCd="+gvTssCd+"'/>";
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
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "'/>" + "&pkWbsCd=" + gvPkWbsCd + "&pgsStepCd=PG";
                    /* tabUrl = "<c:url value='/prj/tss/gen/genTssPgsPtcRsstMbrIfm.do?pkWbsCd=" + gvPkWbsCd +"&pgsStepCd=PG'/>"; */
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
            default:
                break;
            }
        });
        tabView.render('tabView');



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //품의서요청
        btnCsusRq = new Rui.ui.LButton('btnCsusRq');
        btnCsusRq.on('click', function() {
            Rui.confirm({
                text: '품의서요청을 하시겠습니까?',
                handlerYes: function() {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssDcacCsusRq.do'/>" + "?tssCd="+dcacTssCd+"&userId="+gvUserId+"&itmFlag="+itmFlag+"&appCode=APP00332"+"&pgTssCd="+gvTssCd );
                },
                handlerNo: Rui.emptyFn
            });
        });


        //저장
        fnSave = function() {
            dcacBStrtDd.blur();
            dcacBFnhDd.blur();

            if(!vm.validateGroup("mstForm")) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return;
            }

            //개요탭 validation
            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");
            if(!ifmUpdate) return false;

            //수정여부
            var smryDs = document.getElementById('tabContent0').contentWindow.dataSet; //개요탭 DS
            if(!dataSet.isUpdated() && !smryDs.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    dataSet.setNameValue(0, "pgsStepCd", "DC"); //진행단계: DC(중단)
                    dataSet.setNameValue(0, "tssScnCd", "G");   //과제구분: G(일반)
                    dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                    dataSet.setNameValue(0, "tssCd",  dcacTssCd); //과제코드
                    dataSet.setNameValue(0, "userId", gvUserId);  //사용자ID
                    dataSet.setNameValue(0, "tssRoleType", "W"); //화면권한

                    smryDs.setNameValue(0, "tssCd",  dcacTssCd); //과제코드
                    smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID

                    //신규
                    if(dcacTssCd == "") {
                        dm.updateDataSet({
                            modifiedOnly: false,
                            url:'<c:url value="/prj/tss/gen/insertGenTssDcacMst.do"/>',
                            dataSets:[dataSet, smryDs]
                        });
                    }
                    //수정
                    else {
                        dm.updateDataSet({
                            modifiedOnly: false,
                            url:'<c:url value="/prj/tss/gen/updateGenTssDcacMst.do"/>',
                            dataSets:[dataSet, smryDs]
                        });
                    }
                },
                handlerNo: Rui.emptyFn
            });
        };


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
            $("#btnCsusRq").hide();
        }else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
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
            <h2>연구팀 과제 &gt;&gt; 중단</h2>
        </div>
        <div class="sub-content">
            <div class="titArea mt0">
                <div class="LblockButton">
                    <button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
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
                                    <th align="right">WBSCode / 과제명</th>
                                    <td class="tssLableCss" colspan="3">
                                        <input type="text" id="wbsCd" />  /  <em class="gab"> <input type="text" id="tssNm" style="width:900px;padding:0px 5px" />
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
                                    <th align="right">계획(개발계획시점)</th>
                                    <td class="tssLableCss gen_tain">
                                        <input type="text" id="tssStrtDd" value="" /><em class="gab"> ~ </em>
                                        <input type="text" id="tssFnhDd" value="" />
                                    </td>
                                    <th align="right">실적(개발중단시점)</th>
                                    <td>
                                        <input type="text" id="dcacBStrtDd" value="" /><em class="gab"> ~ </em>
                                        <input type="text" id="dcacBFnhDd" value="" />
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
                <input type="hidden" id="tssSt" name="tssSt" value=""/>
                <input type="hidden" id="pgsStepCd" name="pgsStepCd" value=""/>
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