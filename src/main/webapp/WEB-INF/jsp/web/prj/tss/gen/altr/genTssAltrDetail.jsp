<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssAltrDetail.jsp
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
    var gbnCd        = "${inputData.gbnCd}";
    var gvTssSt     = "";
    var gvPgsStepCd = "AL"; //진행상태:AL(변경)
    var gvPkWbsCd   = "";
    var gvPageMode  = "";
    var gvPgTssCd   = "";
    var gvPgTssSt   = "";
    var gvWbsCd       = "";
    var altrTssCd   = "";
    var dataSet;

    var tssAttrCd;
    var bizDptCd;
    var tssStrtDd;
    var tssFnhDd;
    var tssNm;
    
    var urlParam;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //Form 비활성화 여부
        disableFields = function(disable) {
            //버튼여부
            btnStepPg.hide();
            btnCsusRq.hide();
            btnCsusRq2.hide();

            gvPgTssSt = dataSet.getNameValue(0, "pgTssSt");
console.log("[gvPgTssSt]",gvPgTssSt, "", dataSet.getNameValue(0, "tssRoleId"));
            if("TR01" == dataSet.getNameValue(0, "tssRoleId") || "${inputData._userSabun}" == dataSet.getNameValue(0, "pgSaSabunNew")) {
                if(gvTssSt == "100") {
                    //if (stringNullChk(gvPgTssSt) == "202") {
                        btnCsusRq.show();
                    //} else if (stringNullChk(gvPgTssSt) == "201") {
                        btnStepPg.show();
                        btnCsusRq2.show();
                    //}
                }
            }
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
                , { id: 'prjCd' }          //프로젝트코드
                , { id: 'prjNm' }          //프로젝트명
                , { id: 'pgsStepCd' }      //진행단계코드
                , { id: 'tssScnCd' }       //과제구분코드
                , { id: 'wbsCd' }          //WBS코드
                , { id: 'pkWbsCd' }        //WBS코드
                , { id: 'deptCode' }       //조직코드(소속)
                , { id: 'ppslMbdCd' }      //발의주체코드
                , { id: 'bizDptCd' }       //과제유형코드
                , { id: 'tssNm' }          //과제명
                , { id: 'saSabunNew' }     //과제리더사번
                , { id: 'tssAttrCd' }      //과제속성코드
                , { id: 'tssStrtDd' }      //과제시작일
                , { id: 'tssFnhDd' }       //과제종료일
                , { id: 'altrBStrtDd' }    //변경전시작일
                , { id: 'altrBFnhDd' }     //변경전종료일
                , { id: 'altrNxStrtDd' }   //변경후시작일
                , { id: 'altrNxFnhDd' }    //변경후종료일
                , { id: 'altrBStrtDd' }    //완료전시작일
                , { id: 'altrBFnhDd' }     //완료전종료일
                , { id: 'altrNxStrtDd' }   //완료후시작일
                , { id: 'altrNxFnhDd' }    //완료후종료일
                , { id: 'dcacBStrtDd' }    //중단전시작일
                , { id: 'dcacBFnhDd' }     //중단전종료일
                , { id: 'dcacNxStrtDd' }   //중단후시작일
                , { id: 'dcacNxFnhDd' }    //중단후종료일
                , { id: 'cooInstCd' }      //협력기관코드
                , { id: 'supvOpsNm' }      //주관부서명
                , { id: 'exrsInstNm' }     //전담기관명
                , { id: 'bizNm' }          //사업명
                , { id: 'tssSt' }          //과제상태
                , { id: 'tssNosSt' }       //과제차수상태
                , { id: 'tssStTxt' }       //과제상태의견
                , { id: 'saUserName' }     //과제리더명
                , { id: 'deptName' }       //조직(소속)명
                , { id: 'pgsStepNm' }      //진행단계명
                , { id: 'ppslMbdNm' }      //발의주체명
                , { id: 'bizDptNm' }       //과제유형명
                , { id: 'tssAttrNm' }      //과제속성명
                , { id: 'pgTssCd' }        //진행과제코드
                , { id: 'mbrCnt' }         //참여인원
                , { id: 'prodGCd' }        //제품군
                , { id: 'prodGNm' }        //제품군
                , { id: 'pgTssSt' }        //진행상태의상태값
                , { id: 'pgSaSabunNew' }   //진행상태의과제리더
                , { id: 'rsstSphe' }      //연구분야
                , { id: 'rsstSpheNm' }      //연구분야
                , { id: 'tssType' }      //유형
                , { id: 'tssTypeNm' }      //유형
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
                , {id: 'tssStepNm'}    //관제 단계
                , {id: 'grsStepNm'}    //GRS 단계
                // , {id: 'qgateStepNm'}    //Qgate 단계
            ]
        });
        dataSet.on('load', function(e) {
            gvPageMode = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            gvPkWbsCd = dataSet.getNameValue(0, "pkWbsCd");
            var pPgsStepCd = dataSet.getNameValue(0, "pgsStepCd");
            gvPgTssCd = dataSet.getNameValue(0, "pgTssCd");
            gvPgTssSt = dataSet.getNameValue(0, "pgTssSt"); //진행상태의상태값

            tssAttrCd = dataSet.getNameValue(0, 'tssAttrCd');
            bizDptCd = dataSet.getNameValue(0, 'bizDptCd');
            bizDptNm = dataSet.getNameValue(0, 'bizDptNm');

            tssStrtDd = dataSet.getNameValue(0, 'tssStrtDd');
            tssFnhDd  = dataSet.getNameValue(0, 'tssFnhDd');
            tssNm  = dataSet.getNameValue(0, 'tssNm');
            gvWbsCd = stringNullChk(dataSet.getNameValue(0, "wbsCd"));

            //PG:진행단계
            if(pPgsStepCd == "PG") {
                gvTssCd = ""; //과제코드
                gvTssSt = ""; //과제상태
            }
            //AL:변경단계
            else if(pPgsStepCd == "AL") {
                gvTssCd = stringNullChk(dataSet.getNameValue(0, "tssCd")); //과제코드
                gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt")); //과제상태
            }

            disableFields(false);

            tabView.selectTab(0);
        });

        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'prjNm',       ctrlId: 'prjNm',       value: 'html' }
                , { id: 'deptName',    ctrlId: 'deptName',    value: 'html' }
                , { id: 'ppslMbdCd',   ctrlId: 'ppslMbdCd',   value: 'html' }
                , { id: 'bizDptCd',    ctrlId: 'bizDptCd',    value: 'value' }
                , { id: 'bizDptNm',    ctrlId: 'bizDptNm',    value: 'html' }
                , { id: 'tssNm',       ctrlId: 'tssNm',       value: 'html' }
                , { id: 'saUserName',  ctrlId: 'saUserName',  value: 'html' }
                , { id: 'tssAttrCd',   ctrlId: 'tssAttrCd',   value: 'html' }
                , { id: 'tssAttrNm',   ctrlId: 'tssAttrNm',   value: 'html' }
                , { id: 'tssStrtDd',   ctrlId: 'tssStrtDd',   value: 'html' }
                , { id: 'tssFnhDd',    ctrlId: 'tssFnhDd',    value: 'html' }
                , { id: 'mbrCnt',      ctrlId: 'mbrCnt',      value: 'html' }
                , { id: 'wbsCd',       ctrlId: 'wbsCd',       value: 'html' }
                , { id: 'prodGCd',     ctrlId: 'prodGCd',     value: 'html' }
                , { id: 'prodGNm',     ctrlId: 'prodGNm',     value: 'html' }
                , { id: 'rsstSpheNm',   ctrlId: 'rsstSpheNm',   value: 'html' }
                , { id: 'rsstSphe',   ctrlId: 'rsstSphe',   value: 'html' }
                , { id: 'tssType',    ctrlId: 'tssType',    value: 'html' }
                , { id: 'tssTypeNm',    ctrlId: 'tssTypeNm',    value: 'html' }
                , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'html' }                //과제 단계명
                , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'html' }                // GRS 단계명
                , { id: 'ppslMbdNm',    ctrlId: 'ppslMbdNm',    value: 'html' }                // GRS 단계명
                // , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'html' }        //Qgate 단계명
            ]
        });

        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'tssCd',       validExp: '과제코드:false' }
                , { id: 'userId',      validExp: '로그인ID:false' }
                , { id: 'prjCd',       validExp: '프로젝트코드:false' }
                , { id: 'prjNm',       validExp: '프로젝트명:true' }
                , { id: 'deptCode',    validExp: '조직코드:false' }
                , { id: 'deptName',    validExp: '조직명:false' }
                , { id: 'ppslMbdCd',   validExp: '발의주체:true' }
                , { id: 'bizDptCd',    validExp: '사업부문(Funding기준):true' }
                , { id: 'wbsCd',       validExp: 'WBSCode:false' }
                , { id: 'tssNm',       validExp: '과제명:true:maxLength=1000' }
                , { id: 'saSabunNew',  validExp: '과제리더사번:false' }
                , { id: 'saUserName',  validExp: '과제리더명:true' }
                , { id: 'tssAttrCd',   validExp: '과제속성:true' }
                , { id: 'tssStrtDd',   validExp: '과제기간 시작일:true' }
                , { id: 'tssFnhDd',    validExp: '과제기간 종료일:true' }
                , { id: 'pgsStepNm',   validExp: '진행단계명:false' }
                , { id: 'tssSt',       validExp: '과제상태:false' }
                , { id: 'pgsStepCd',   validExp: '진행단계:false' }
                , { id: 'tssScnCd',    validExp: '과제구분:false' }
                , { id: 'prodGCd',     validExp: '제품군:true' }
                , { id: 'rsstSphe',    validExp: '연구분야:true' }
                , { id: 'tssType',     validExp: '유형:true' }
            ]
        });


        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);

            alert(data.records[0].rtVal);

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
                { label: '변경개요', content: '<div id="div-content-test0"></div>' },
                { label: '개요', content: '<div id="div-content-test1"></div>' },
                { label: '참여연구원', content: '<div id="div-content-test2"></div>' },
                { label: 'WBS', content: '<div id="div-content-test3"></div>' },
                { label: '개발비', content: '<div id="div-content-test3"></div>' },
                { label: '목표 및 산출물', content: '<div id="div-content-test4"></div>' },
                { label: '변경이력', content: '<div id="div-content-test5"></div>' }
            ]
        });
        tabView.on('canActiveTabChange', function(e) {
            if(gvTssSt == "100" || gvTssSt == "") {
                if(tabView.getActiveIndex() != 0) {
                    var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate();
                    if(!ifmUpdate) return false;
                }
            }
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
            urlParam = "?tssCd="+gvTssCd+"&wbsCd="+gvWbsCd+"&pgTssSt="+gvPgTssSt +"&pgTssCd="+gvPgTssCd;

            switch(e.activeIndex) {
            //변경개요
            case 0:
                if(e.isFirst) {
                    //tabUrl = "<c:url value='/prj/tss/gen/genTssAltrIfm.do?tssCd=" + gvTssCd +"&pgTssCd="+gvPgTssCd+" '/>";
                    tabUrl = "<c:url value='/prj/tss/gen/genTssAltrIfm.do'/>"+urlParam;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                } else {
                    disableFields(false);
                }
                break;
            //개요
            case 1:
                if(e.isFirst) {
                    //tabUrl = "<c:url value='/prj/tss/gen/genTssAltrSmryIfm.do?tssCd=" + gvTssCd + "&pgTssCd="+gvPgTssCd+"'/>";
                    tabUrl = "<c:url value='/prj/tss/gen/genTssAltrSmryIfm.do'/>"+urlParam;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                disableFields(true);
                break;
            //참여연구원
            case 2:
                if(e.isFirst) {
                    //tabUrl = "<c:url value='/prj/tss/gen/genTssAltrPtcRsstMbrIfm.do?tssCd="+gvTssCd+"&wbsCd="+gvWbsCd+" '/>";
                    tabUrl = "<c:url value='/prj/tss/gen/genTssAltrPtcRsstMbrIfm.do'/>"+urlParam;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                disableFields(true);
                break;
            //WBS
            case 3:
                if(e.isFirst) {
                }
                //tabUrl = "<c:url value='/prj/tss/gen/genTssAltrWBSIfm.do?tssCd=" + gvTssCd + "'/>";
                tabUrl = "<c:url value='/prj/tss/gen/genTssAltrWBSIfm.do'/>"+urlParam;
                nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
                disableFields(true);
                break;
            //개발비
            case 4:
                if(e.isFirst) {
                    //tabUrl = "<c:url value='/prj/tss/gen/genTssPgsTrwiBudgIfm.do?tssCd=" + gvPgTssCd + "'/>";
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsTrwiBudgIfm.do'/>"+urlParam;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent4');
                }
                disableFields(true);
                break;
            //목표 및 산출물
            case 5:
                if(e.isFirst) {
                    //tabUrl = "<c:url value='/prj/tss/gen/genTssAltrGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    tabUrl = "<c:url value='/prj/tss/gen/genTssAltrGoalYldIfm.do'/>"+urlParam;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent5');
                }
                disableFields(true);
                break;
            //변경이력
            case 6:
                if(e.isFirst) {
                    //tabUrl = "<c:url value='/prj/tss/gen/genTssPgsAltrHistIfm.do?pkWbsCd=" + gvPkWbsCd + "'/>";
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPgsAltrHistIfm.do'/>"+urlParam;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent6');
                }
                disableFields(true);
                break;
            default:
                break;
            }
        });
        tabView.render('tabView');



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //진행으로 회귀
        btnStepPg = new Rui.ui.LButton('btnStepPg');
        btnStepPg.on('click', function() {
        	if(confirm('진행단계로 이동하시겠습니까?\r\n변경에서 작성한 데이터는 삭제됩니다.')) {
                nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssPgsDetail.do'/>"+"?tssCd="+gvTssCd+"&pgTssCd="+gvPgTssCd+"&userId="+gvUserId);
            }
        });


        //품의서요청-GRS품의
        btnCsusRq = new Rui.ui.LButton('btnCsusRq');
        btnCsusRq.on('click', function() {
            if(confirm('품의서요청을 하시겠습니까?')) {
                nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssAltrCsusRq.do'/>"+"?tssCd="+gvTssCd+"&pgTssCd="+gvPgTssCd+"&userId="+gvUserId+"&appCode=APP00332");
            }
        });


        //품의서요청-내부품의
        btnCsusRq2 = new Rui.ui.LButton('btnCsusRq2');
        btnCsusRq2.on('click', function() {
            if(confirm('품의서요청을 하시겠습니까?')) {
                nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genSimpleTssAltrCsusRq.do'/>"+"?tssCd="+gvTssCd+"&pgTssCd="+gvPgTssCd+"&userId="+gvUserId+"&wbsCd="+gvWbsCd+"&appCode=APP00339");
            }
        });


        //저장
        fnSave = function() {
            if(!vm.validateGroup("mstForm")) {
                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                return;
            }

            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");

            if(!ifmUpdate) return false;

            var smryDs = document.getElementById('tabContent0').contentWindow.dataSet1; //개요탭 DS
            var altrDs = document.getElementById('tabContent0').contentWindow.dataSet2; //개요탭 DS

            if(confirm('저장하시겠습니까?')) {
                dataSet.setNameValue(0, "pgsStepCd", "AL"); //진행단계: AL(변경)
                dataSet.setNameValue(0, "tssScnCd", "G");   //과제구분: G(일반)
                dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                dataSet.setNameValue(0, "tssCd",  gvTssCd);  //과제코드
                dataSet.setNameValue(0, "userId", gvUserId); //사용자ID
                dataSet.setNameValue(0, "tssRoleType", "W"); //화면권한

                smryDs.setNameValue(0, "tssCd",  gvTssCd); //과제코드
                smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID
                
                //신규
                if(gvTssCd == "") {
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/gen/insertGenTssAltrMst.do"/>',
                        dataSets:[dataSet, smryDs, altrDs]
                    });
                }
                //수정
                else {
                    altrDs.setNameValue(0, "tssCd",  gvTssCd);  //과제코드
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/gen/updateGenTssAltrMst.do"/>',
                        dataSets:[dataSet, smryDs, altrDs]
                    });
                }
                console.log("[urlParam]", urlParam);
                nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>"+urlParam);
            }
        };


        //프로젝트 팝업
        prjSearchDialog = new Rui.ui.LFrameDialog({
            id: 'prjSearchDialog',
            title: '프로젝트 조회',
            width: 620,
            height: 500,
            modal: true,
            visible: false
        });
        prjSearchDialog.on('cancel', function(e) {
            try{
                tabContent1.$('object').css('visibility', 'visible');
            }catch(e){}
        });
        prjSearchDialog.on('submit', function(e) {
            try{
                tabContent1.$('object').css('visibility', 'visible');
            }catch(e){}
        });
        prjSearchDialog.on('show', function(e) {
            try{
                tabContent1.$('object').css('visibility', 'hidden');
            }catch(e){}
        });

        prjSearchDialog.render(document.body);

        openPrjSearchDialog = function(f,p) {
            var param = '?searchType=';
            if(!Rui.isNull(p) && p != '') {
                param += p;
            }

            _callback = f;

            prjSearchDialog.setUrl('<c:url value="/prj/rsst/mst/retrievePrjSearchPopup.do"/>' + param);
            prjSearchDialog.show();
        };


        openPrjSearchDialog2 = function(f, p) {
            _callback = f;

             var param = '?searchType=';
                if(!Rui.isNull(p) && p != '') {
                    param += p;
                }

               var loadingUrl = '<c:url value="/prj/rsst/mst/retrievePrjSearchPopup2.do"/>'+param;

                var sFeatures = "dialogHeight: 500px; dialogWidth:600px";

             if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {

                    window.showModalDialog(loadingUrl, self, sFeatures);
             }else{
                 alert("Internet Explorer browser인지 확인해 주세요");
              }

           };


        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("mst searchData1");
            dataSet.loadData(${result});
        }
    });
</script>
<script type="text/javascript">
//과제리더 팝업 셋팅
function setLeaderInfo(userInfo) {
    dataSet.setNameValue(0, "saSabunNew", userInfo.saSabun);
    dataSet.setNameValue(0, "saUserName", userInfo.saName);
}
//프로젝트 팝업 셋팅
function setPrjInfo(prjInfo) {
    dataSet.setNameValue(0, "deptCode", prjInfo.upDeptCd);
    dataSet.setNameValue(0, "deptName", prjInfo.upDeptName);
    dataSet.setNameValue(0, "prjCd", prjInfo.prjCd);
    dataSet.setNameValue(0, "prjNm", prjInfo.prjNm);
//     dataSet.setNameValue(0, "saSabunNew", prjInfo.plEmpNo);   //과제리더사번
//     dataSet.setNameValue(0, "saUserName", prjInfo.plEmpName); //과제리더명
}
</script>
</head>
<body>
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
        <div class="titleArea">
            <a class="leftCon" href="#">
            <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
            <span class="hidden">Toggle 버튼</span>
            </a>
            <h2>연구팀 과제 &gt;&gt; 변경</h2>
        </div>
        <div class="sub-content">
            <div class="titArea mt0">
                <div class="LblockButton">
                    <button type="button" id="btnStepPg" name="btnStepPg">변경취소</button>
                    <button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
                    <button type="button" id="btnCsusRq2" name="btnCsusRq2">내부품의서요청</button>
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
                                        <span id="prjNm" />
                                    </td>
                                    <th align="right">조직</th>
                                    <td>
                                        <span id="deptName" />
                                    </td>
                                </tr>
                                <tr>
                                  <th align="right">WBSCode/과제명</th>
                                    <td class="tssLableCss" colspan="3">
                                        <span id="wbsCd"></span> / <span id="tssNm"></span>
                                    </td>
                                 </tr>
                                 <tr>
                                     <th align="right">과제리더</th>
                                    <td class="tssLableCss">
                                        <span id="saUserName" />
                                    </td>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td class="tssLableCss">
                                        <span id="bizDptNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">발의주체</th>
                                    <td class="tssLableCss">
                                        <span id="ppslMbdNm" />
                                    </td>
                                    <th align="right">제품군</th>
                                    <td class="tssLableCss">
                                        <span id="prodGNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제속성</th>
                                    <td class="tssLableCss">
                                        <span id="tssAttrNm"></div>
                                    </td>
                                    <th align="right">참여인원</th>
                                    <td>
                                        <span id="mbrCnt" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">연구분야</th>
                                    <td>
                                        <span id="rsstSpheNm">
                                    </td>
                                    <th align="right">개발등급</th>
                                    <td>
                                        <span id="tssTypeNm">
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제기간</th>
                                    <td class="tssLableCss">
                                        <span id="tssStrtDd"></span> ~ <span id="tssFnhDd"></span>
                                    </td>
                                    <!-- <th align="right">진행단계 / GRS</th>
                                    <td colspan="3"><span id="tssStepNm"/> / <span id="grsStepNm"/></td> -->
                                    <th align="right">진행단계 / GRS</th>
                                    <td class="tssLableCss">
                                    	<div style="float:left;"><span id="tssStepNm"/></div>
                                    	<div style="float:left;"><em class="gab">/<em class="gab"></div>
                                    	<div style="float:left;"><span id="grsStepNm"/></div>
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