<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssAltrDetail.jsp
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
    var gvTssSt     = "";
    var gvPgsStepCd = "AL"; //진행상태:AL(변경)
    var gvPkWbsCd   = "";
    var gvPageMode  = "";
    var gvTssNosSt  = "";

    var altrTssCd   = "";
    var dataSet;

    var altrHistDialog;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        var form = new Rui.ui.form.LForm('mstForm');

        //프로젝트명
        prjNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'prjNm',
            width: 300,
            editable: false,
            enterToPopup: true
        });
        prjNm.on('popup', function(e){
            openPrjSearchDialog(setPrjInfo,'');
        });

        //조직코드
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            width: 300
        });

        //WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            width: 100
        });

        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            width: 900
        });

        //과제유형
        bizDptCd = new Rui.ui.form.LCombo({
            applyTo: 'bizDptCd',
            name: 'bizDptCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=BIZ_DPT_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
        });

        //연구책임자
        saUserName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saUserName',
            width: 100,
            editable: false,
            enterToPopup: true
        });
        saUserName.on('popup', function(e){
            openUserSearchDialog(setLeaderInfo, 1, '');
        });
        _userSearchDialog.on('cancel', function(e) {
            tabContent0.$('object').css('visibility', 'visible');
        });
        _userSearchDialog.on('submit', function(e) {
            tabContent0.$('object').css('visibility', 'visible');
        });
        _userSearchDialog.on('show', function(e) {
            tabContent0.$('object').css('visibility', 'hidden');
        });

        //주관부처
        supvOpsNm = new Rui.ui.form.LTextBox({
            applyTo: 'supvOpsNm',
            width: 300
        });

        //전담기관
        exrsInstNm = new Rui.ui.form.LTextBox({
            applyTo: 'exrsInstNm',
            width: 300
        });

        //사업명
        bizNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizNm',
            width: 300
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
        var disableFields = function(disable) {
            //버튼설정
            btnCsusRq.hide();

            if("TR01" == dataSet.getNameValue(0, "tssRoleId") || "${inputData._userSabun}" == dataSet.getNameValue(0, "pgSaSabunNew")) {
                if(gvTssSt == "100") btnCsusRq.show(); //GRS - 100:작성중
            }

            deptName.setEditable(false);
            wbsCd.setEditable(false);

            document.getElementById('deptName').style.border = 0;
            document.getElementById('wbsCd').style.border = 0;

            if(disable) {
                prjNm.disable();
                deptName.disable();
                wbsCd.disable();
                tssNm.disable();
                bizDptCd.disable();
                saUserName.disable();
                supvOpsNm.disable();
                exrsInstNm.disable();
                bizNm.disable();
            } else {
                prjNm.enable();
                deptName.enable();
                wbsCd.enable();
                tssNm.enable();
                bizDptCd.enable();
                saUserName.enable();
                supvOpsNm.enable();
                exrsInstNm.enable();
                bizNm.enable();
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
                , { id: 'supvOpsNm' }      //주관부처명
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
                , { id: 'smryYn' }         //개요존재여부
                , { id: 'pgSaSabunNew' }   //진행상태의과제리더
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
                , {id: 'tssStepNm'}	//관제 단계
                , {id: 'grsStepNm'}	//GRS 단계
                // , {id: 'qgateStepNm'}	//Qgate 단계
            ]
        });
        dataSet.on('load', function(e) {
            gvPageMode = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            gvTssNosSt = stringNullChk(dataSet.getNameValue(0, "tssNosSt"));
            gvPkWbsCd = dataSet.getNameValue(0, "pkWbsCd");
            var pPgsStepCd = dataSet.getNameValue(0, "pgsStepCd");

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

            //개요존재여부
            if(dataSet.getNameValue(0, "smryYn") == "0") {
                gvTssSt = "";
            }

            disableFields();

            tabView.selectTab(0);
        });


        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                { id: 'tssCd',      ctrlId: 'tssCd',      value: 'value' }
                , { id: 'prjCd',      ctrlId: 'prjCd',      value: 'value' }
                , { id: 'prjNm',      ctrlId: 'prjNm',      value: 'value' }
                , { id: 'deptCode',   ctrlId: 'deptCode',   value: 'value' }
                , { id: 'deptName',   ctrlId: 'deptName',   value: 'value' }
                , { id: 'bizDptCd',   ctrlId: 'bizDptCd',   value: 'value' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }
                , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'value' }
                , { id: 'saSabunNew', ctrlId: 'saSabunNew', value: 'value' }
                , { id: 'saUserName', ctrlId: 'saUserName', value: 'value' }
                , { id: 'pgsStepCd', ctrlId: 'pgsStepCd', value: 'value' }
                , { id: 'tssScnCd', ctrlId: 'tssScnCd', value: 'value' }
                , { id: 'tssNosSt', ctrlId: 'tssNosSt', value: 'value' }
                , { id: 'supvOpsNm', ctrlId: 'supvOpsNm', value: 'value' }
                , { id: 'exrsInstNm', ctrlId: 'exrsInstNm', value: 'value' }
                , { id: 'bizNm', ctrlId: 'bizNm', value: 'value' }
                , { id: 'userId',     ctrlId: 'userId',     value: 'value' }
                , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'html' }				//과제 단계명
                , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'html' }				// GRS 단계명
                // , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'html' }		//Qgate 단계명
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


        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'tssCd',       validExp: '과제코드:false' }
                , { id: 'prjCd',       validExp: '프로젝트코드:false' }
                , { id: 'prjNm',       validExp: '프로젝트명:true' }
                , { id: 'deptCode',    validExp: '조직코드:false' }
                , { id: 'deptName',    validExp: '조직명:false' }
                , { id: 'bizDptCd',    validExp: '과제유형:false' }
                , { id: 'wbsCd',       validExp: 'WBSCode:false' }
                , { id: 'tssNm',       validExp: '과제명:false:maxLength=1000' }
                , { id: 'saSabunNew',  validExp: '과제리더사번:false' }
                , { id: 'saUserName',  validExp: '과제리더명:false' }
                , { id: 'pgsStepCd',   validExp: '진행단계코드:false' }
                , { id: 'tssScnCd',    validExp: '과제구분코드:false' }
                , { id: 'tssNosSt',    validExp: '과제차수상태:false' }
                , { id: 'supvOpsNm',   validExp: '주관부처:false:maxLength=100' }
                , { id: 'exrsInstNm',  validExp: '전담기관:false:maxLength=100' }
                , { id: 'bizNm',       validExp: '사업명:false:maxLength=500' }
                , { id: 'tssSt',       validExp: '과제상태:false' }
                , { id: 'userId',      validExp: '로그인ID:false' }
            ]
        });



        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: '변경개요', content: '<div id="div-content-test0"></div>' },
                { label: '개요', content: '<div id="div-content-test1"></div>' },
                { label: '사업비', content: '<div id="div-content-test2"></div>' },
                { label: '참여연구원', content: '<div id="div-content-test3"></div>' },
                { label: '목표 및 산출물', content: '<div id="div-content-test4"></div>' },
                { label: '투자품목목록', content: '<div id="div-content-test5"></div>' },
                { label: '연구비카드', content: '<div id="div-content-test6"></div>' },
                { label: '변경이력', content: '<div id="div-content-test7"></div>' }
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
            for(var i = 0; i < 8; i++) {
                if(i == e.activeIndex) {
                    Rui.get('tabContent' + i).show();
                } else {
                    Rui.get('tabContent' + i).hide();
                }
            }

            var tabUrl = "";

            switch(e.activeIndex) {
            //변경개요
            case 0:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssAltrIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                } else {
                    disableFields(false);
                }
                break;
            //개요
            case 1:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssAltrSmryIfm.do?tssCd=" + gvTssCd + "'/>" + "&pkWbsCd=" + gvPkWbsCd;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                disableFields(true);
                break;
            //사업비
            case 2:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssAltrTrwiBudgIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                disableFields(true);
                break;
            //참여연구원
            case 3:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssAltrPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
                }
                disableFields(true);
                break;
            //목표 및 산출물
            case 4:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssAltrGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent4');
                }
                disableFields(true);
                break;
            //투자품목목록
            case 5:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsIvstIfm.do?tssCd=" + dataSet.getNameValue(0, "pgTssCd") + "'/>" + "&pkWbsCd=" + gvPkWbsCd;
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent5');
                }
                break;
            //연구비카드
            case 6:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsCrdIfm.do?tssCd=" + dataSet.getNameValue(0, "pgTssCd") + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent6');
                }
                break;
            //변경이력
            case 7:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPgsAltrHistIfm.do?pkWbsCd=" + gvPkWbsCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent7');
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
        //품의서요청
        btnCsusRq = new Rui.ui.LButton('btnCsusRq');
        btnCsusRq.on('click', function() {
            Rui.confirm({
                text: '품의서요청을 하시겠습니까?',
                handlerYes: function() {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/nat/natTssAltrCsusRq.do?tssCd="+gvTssCd+"&userId="+gvUserId+"'/>");
                },
                handlerNo: Rui.emptyFn
            });
        });


        //저장
        fnSave = function() {
            //마스터 vm
            if(!vm.validateGroup("mstForm")) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return;
            }

            //개요 vm
            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");
            if(!ifmUpdate) return false;

            //수정여부
            var smryDs = document.getElementById('tabContent0').contentWindow.dataSet1; //개요탭 DS
            var altrDs = document.getElementById('tabContent0').contentWindow.dataSet2; //개요탭 DS

            if(!dataSet.isUpdated() && !smryDs.isUpdated() && !altrDs.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    var smryTssCd = stringNullChk(smryDs.getNameValue(0, "tssCd"));

                    dataSet.setNameValue(0, "pgsStepCd", "AL"); //진행단계: AL(변경)
                    dataSet.setNameValue(0, "tssScnCd", "G");   //과제구분: G(일반)
                    dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                    dataSet.setNameValue(0, "tssCd",  gvTssCd);  //과제코드
                    dataSet.setNameValue(0, "userId", gvUserId); //사용자ID
                    dataSet.setNameValue(0, "smryYn", "1");

                    smryDs.setNameValue(0, "tssCd",  gvTssCd);  //과제코드
                    smryDs.setNameValue(0, "userId", gvUserId); //사용자ID

                    //신규
                    if(smryTssCd == "") {
                        dm.updateDataSet({
                            modifiedOnly: false,
                            url:'<c:url value="/prj/tss/nat/insertNatTssAltrMst.do"/>',
                            dataSets:[dataSet, smryDs, altrDs]
                        });
                    }
                    //수정
                    else {
                        dm.updateDataSet({
                            modifiedOnly: false,
                            url:'<c:url value="/prj/tss/nat/updateNatTssAltrMst.do"/>',
                            dataSets:[dataSet, smryDs, altrDs]
                        });
                    }
                },
                handlerNo: Rui.emptyFn
            });
        };


        //프로젝트 팝업 DIALOG
        prjSearchDialog = new Rui.ui.LFrameDialog({
            id: 'prjSearchDialog',
            title: '프로젝트 조회',
            width: 620,
            height: 500,
            modal: true,
            visible: false
        });
        prjSearchDialog.on('cancel', function(e) {
            tabContent0.$('object').css('visibility', 'visible');
        });
        prjSearchDialog.on('submit', function(e) {
            tabContent0.$('object').css('visibility', 'visible');
        });
        prjSearchDialog.on('show', function(e) {
            tabContent0.$('object').css('visibility', 'hidden');
        });

        prjSearchDialog.render(document.body);

        openPrjSearchDialog = function(f,p) {
            var param = '?searchType=';
            if( !Rui.isNull(p) && p != ''){
                param += p;
            }

            _callback = f;

            prjSearchDialog.setUrl('<c:url value="/prj/rsst/mst/retrievePrjSearchPopup.do"/>' + param);
            prjSearchDialog.show();
        };

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
        	$("#btnCsusRq").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnCsusRq").hide();
		}
    });
</script>
<script type="text/javascript">
//과제리더 팝업 셋팅
function setLeaderInfo(userInfo) {
    dataSet.setNameValue(0, "saSabunNew", userInfo.saSabun);
    dataSet.setNameValue(0, "saUserName", userInfo.saName);
}

//프로젝트 팝업셋팅
function setPrjInfo(prjInfo) {
    dataSet.setNameValue(0, "prjNm", prjInfo.prjNm);
    dataSet.setNameValue(0, "prjCd", prjInfo.prjCd);
    dataSet.setNameValue(0, "deptCode", prjInfo.upDeptCd);
    dataSet.setNameValue(0, "deptName", prjInfo.upDeptName);
    dataSet.setNameValue(0, "saSabunNew", prjInfo.plEmpNo);   //과제리더사번
    dataSet.setNameValue(0, "saUserName", prjInfo.plEmpName); //과제리더명
}

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
	<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
</form>
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
        <div class="titleArea">
            <h2>국책과제 &gt;&gt; 변경</h2>
        </div>
        <div class="sub-content">
            <div class="titArea">
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
                                    <td>
                                       <input type="text" id="prjNm" />
                                    </td>
                                    <th align="right">조직</th>
                                    <td>
                                        <input type="text" id="deptName" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">WBSCode / 과제명</th>
                                    <td  colspan="3">
                                        <input type="text" id="wbsCd" /> / <input type="text" id="tssNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제리더</th>
                                    <td>
                                        <input type="text" id="saUserName" />
                                    </td>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td>
                                        <div id="bizDptCd"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">전담기관</th>
                                    <td>
                                         <input type="text" id="exrsInstNm" />
                                    </td>
                                    <th align="right">사업명</th>
                                    <td>
                                       <input type="text" id="bizNm" />
                                    </td>
                                </tr>
                                <tr>
                                	<th align="right">주관부처</th>
                                    <td colspan="3">
                                         <input type="text" id="supvOpsNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">진행단계 / GRS</th>
                                    <td  colspan="3"><span id="tssStepNm"></span> / <span id="grsStepNm"></span></td>
<%--

                                    <th align="right">Q-gate 단계</th>
                                    <td><span id="qgateStepNm"></span> </td>
--%>

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
                <iframe name="tabContent7" id="tabContent7" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
            </form>
        </div>
    </div>

</body>
</html>