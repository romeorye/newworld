<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : insertGenTssSmry.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.08
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */


 ** 운영반영시
 ** GRS, 품의버튼 클릭시 validation 주석제거




--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">
    var gvTssCd     = "";
    var gvUserId    = "${inputData._userId}";
    var gvPgsStepCd = "PL";
    var gvTssSt     = "";
    var gvPkWbsCd   = "";
    var gvTssNosSt  = "";
    var gvPageMode  = "";

    var pgsStepNm = "";
    var dataSet;

    var isEditable = false;

    Rui.onReady(function() {
        var form = new Rui.ui.form.LForm('mstForm');
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
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
     	// 공통 유저조회 Dialog
        _userSearchDialog.on('cancel', function(e) {
        	try{
        		tabContent0.$('object').css('visibility', 'visible');
        	}catch(e){}
        });
        _userSearchDialog.on('submit', function(e) {
        	try{
        		tabContent0.$('object').css('visibility', 'visible');
        	}catch(e){}
        });
        _userSearchDialog.on('show', function(e) {
        	try{
        		tabContent0.$('object').css('visibility', 'hidden');
        	}catch(e){}
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
            width: 200
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


        //주관부처
        supvOpsNm = new Rui.ui.form.LTextBox({
            applyTo: 'supvOpsNm',
            width: 1000
        });

        //전담기관
        exrsInstNm = new Rui.ui.form.LTextBox({
            applyTo: 'exrsInstNm',
            width: 400
        });

        //사업명
        bizNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizNm',
            width: 300
        });

        //Form 비활성화 여부
        var disableFields = function(disable) {

            //버튼여부
            btnDelRq.hide();
            btnGrsRq.hide();
            btnCsusRq.hide();
            btnPgsRq.hide();

            //form
            deptName.setEditable(false);
            wbsCd.setEditable(false);
            prjNm.setEditable(false);
            saUserName.setEditable(false);

            //style
            $('#prjNm > a').attr('style', "display:none;");
            $('#saUserName > a').attr('style', "display:none;");
            $('#prjNm').attr('style', "border-color:white;");
            $('#saUserName').attr('style', "border-color:white;");
            $('#deptName').attr('style', "border-color:white;");
            $('#wbsCd').attr('style', "border-color:white;");

            //조건에 따른 보이기
            if("TR01" == dataSet.getNameValue(0, "tssRoleId") || "${inputData._userSabun}" == dataSet.getNameValue(0, "saSabunNew")) {
                if(gvTssNosSt == "1") { //1차년도
                    if(gvTssSt == "100"){
                    	btnDelRq.show();
                    	btnGrsRq.show();
                    }else if(gvTssSt == "302"){ // GRS품의 완료
                    	btnCsusRq.show();
                    }
                }
                else {
                    if(gvTssSt == "100") btnPgsRq.show();
                }
            }

            //if("TR01" == dataSet.getNameValue(0, "tssRoleId")) {
                $('#prjNm > a').attr('style', "display:block;");
                $('#saUserName > a').attr('style', "display:block;");
                $('#prjNm').attr('style', "border-color:;");
                $('#saUserName').attr('style', "border-color:;");
            //}

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



            if(pgsStepCd=="PL"){
                btnDelRq.hide();
                btnGrsRq.hide();
                btnPgsRq.hide();
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
                , { id: 'prjCd' }      //프로젝트코드
                , { id: 'prjNm' }      //프로젝트명
                , { id: 'deptCode' }   //조직코드
                , { id: 'deptName' }   //조직명
                , { id: 'bizDptCd' }   //과제유형
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
                , { id: 'userId' }     //로그인ID
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
                , { id: 'isEditable' }
                , {id: 'tssStepNm'}	//관제 단계
                , {id: 'grsStepNm'}	//GRS 단계
                // , {id: 'qgateStepNm'}	//Qgate 단계
            ]
        });
        dataSet.on('load', function(e) {
            gvTssCd     = stringNullChk(dataSet.getNameValue(0, "tssCd"));
            gvPgsStepCd = stringNullChk(dataSet.getNameValue(0, "pgsStepCd")); //진행상태코드
            gvTssNosSt  = stringNullChk(dataSet.getNameValue(0, "tssNosSt"));
            gvTssSt     = stringNullChk(dataSet.getNameValue(0, "tssSt"));
            gvPageMode  = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            pgsStepCd = stringNullChk(dataSet.getNameValue(0, "pgsStepCd"));

            //최초 로그인사용자 정보 셋팅
            if(gvTssCd == "") {
                dataSet.setNameValue(0, "prjCd", "${userMap.prjCd}");          //프로젝트코드
                dataSet.setNameValue(0, "prjNm", "${userMap.prjNm}");          //프로젝트명
                dataSet.setNameValue(0, "deptCode", "${userMap.upDeptCd}");    //조직코드
                dataSet.setNameValue(0, "deptName", "${userMap.upDeptName}");  //조직명
                //dataSet.setNameValue(0, "saSabunNew", "${userMap.plEmpNo}");   //과제리더사번
                //dataSet.setNameValue(0, "saUserName", "${userMap.plEmpName}"); //과제리더명

                if(stringNullChk("${userMap.prjCd}") == "") {
                    alert("프로젝트 등록을 먼저 해주시기 바랍니다.");
                }
            }

            if(stringNullChk(dataSet.getNameValue(0, "wbsCd")) != "" && (gvTssNosSt == "" || gvTssNosSt == "1")) {
                document.getElementById("seed").innerHTML = "SEED-";
            } else {
                document.getElementById("seed").innerHTML = "";
            }

            disableFields();

            isFirst = gvTssSt == "";
            isEditable =
                isFirst ||
                gvTssSt=="100" ||
                dataSet.getNameValue(0, "isEditable")=="1" && (pgsStepCd=="PL" );


            tabView.selectTab(0);
	        nwinsActSubmit(document.tabForm, "<c:url value='/prj/tss/nat/natTssPlnSmryIfm.do?tssCd=" + gvTssCd + "'/>", 'tabContent0');
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
        //Tab 설정
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: '개요', content: '<div id="div-content-test1"></div>' },
                { label: '참여연구원', content: '<div id="div-content-test2"></div>' },
                { label: '사업비', content: '<div id="div-content-test3"></div>' },
                { label: '목표 및 산출물', content: '<div id="div-content-test4"></div>' }
            ]
        });
        tabView.on('canActiveTabChange', function(e) {
            if(gvTssCd == "" || dataSet.isUpdated()) {
                if(tabView.getActiveIndex() != 0) {
                    alert("개요 저장을 먼저 해주시기 바랍니다.");
                    return false;
                }
            }
        });
        tabView.on('activeTabChange', function(e) {
            //iframe 숨기기
            for(var i = 0; i < 4; i++) {
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
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPlnSmryIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                } else {
                    disableFields(false);
                }
                break;
            //참여연구원
            case 1:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPlnPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                disableFields(true);
                break;

            //사업비
            case 2:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPlnTrwiBudgIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                disableFields(true);
                break;
            //목표 및 산출물
            case 3:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/nat/natTssPlnGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
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
        //저장
        fnSave = function() {
            var smryDs = document.getElementById('tabContent0').contentWindow.dataSet; //개요 정보
            var smryLstDs = document.getElementById('tabContent0').contentWindow.smryDataLstSet; //개요 수행기관

            //마스터 vm
            if(!vm.validateGroup("mstForm")) {
                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                return;
            }

            //개요 vm
            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");
            if(!ifmUpdate) return false;

            if( confirm("저장하시겠습니까?") == true ){
                smryDs = document.getElementById('tabContent0').contentWindow.dataSet; //개요 정보

                Rui.get("userId").setValue(gvUserId); //사용자ID셋팅

                //신규
                if(gvTssCd == "") {
                    //국책과제걔요
                    dataSet.setNameValue(0, "pgsStepCd", "PL");     //진행단계: PL(계획)
                    dataSet.setNameValue(0, "tssScnCd",  "N");      //과제구분: N(국책)
                    dataSet.setNameValue(0, "tssSt",     "100");    //과제상태: 100(작성중)
                    dataSet.setNameValue(0, "tssNosSt",  "1");      //차수: 1차년도
                    dataSet.setNameValue(0, "tssCd",     gvTssCd);  //과제코드
                    dataSet.setNameValue(0, "userId",    gvUserId); //사용자ID

                    smryDs.setNameValue(0, "tssCd",  gvTssCd);   //과제코드
                    smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID

                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/nat/insertNatTssPlnMst.do"/>',
                        dataSets:[dataSet, smryDs, smryLstDs]
                    });
                }
                //수정
                else {
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/nat/updateNatTssPlnMst.do"/>',
                        dataSets:[dataSet, smryDs, smryLstDs]
                    });
                }
            }
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
        	try{
        		tabContent0.$('object').css('visibility', 'visible');
        	}catch(e){}
        });
        prjSearchDialog.on('submit', function(e) {
        	try{
        		tabContent0.$('object').css('visibility', 'visible');
        	}catch(e){}
        });
        prjSearchDialog.on('show', function(e) {
        	try{
        		tabContent0.$('object').css('visibility', 'hidden');
        	}catch(e){}
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


        //DB테이블 건수확인
        var regDm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        regDm.on('success', function(e) {
            var regCntMap = JSON.parse(e.responseText)[0].records[0];

            var errMsg = "";
            if(regCntMap.natSmryCnt <= 0)       errMsg = "개요를 입력해 주시기 바랍니다.";
            else if(regCntMap.natCrroCnt <= 0) errMsg = "수행기관을 입력해 주시기 바랍니다.";
            else if(regCntMap.comMbrCnt <= 0)  errMsg = "참여원구원을 입력해 주시기 바랍니다.";
            else if(regCntMap.natBizCnt <= 0)  errMsg = "사업비를 입력해 주시기 바랍니다.";
            else if(regCntMap.comGoalCnt <= 0) errMsg = "목표를 입력해 주시기 바랍니다.";
            else if(regCntMap.comYldCnt < 2)  errMsg = "산출물을 입력해 주시기 바랍니다.";

            if(errMsg != "") alert(errMsg);
            else {
                if(regCntMap.gbn == "GRS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/grs/grsEvRslt.do'/>"+"?tssCd="+gvTssCd+"&userId="+gvUserId);
                else if(regCntMap.gbn == "CSUS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/nat/natTssPlnCsusRq.do'/>" + "?tssCd="+gvTssCd+"&userId="+gvUserId);
                else if(regCntMap.gbn == "PGS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/nat/natTssPlnPgsMove.do' />"+"?tssCd="+gvTssCd+"&userId="+gvUserId);
            }
        });


      //삭제
        btnDelRq = new Rui.ui.LButton('btnDelRq');
        btnDelRq.on('click', function() {
        	if(confirm("삭제를 하시겠습니까?")) {
        		dm.updateDataSet({
                    modifiedOnly: false,
                    url:'<c:url value="/prj/tss/nat/deleteNatTssPlnMst.do"/>',
                    dataSets:[dataSet],
                    params: {
                    	tssCd : gvTssCd
                    }
                });
        	}
        		dm.on('success', function(e) {
    	  	    	nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
    			});
        });


        //GRS요청
        btnGrsRq = new Rui.ui.LButton('btnGrsRq');
        btnGrsRq.on('click', function() {
        	if(confirm("GRS요청을 하시겠습니까?")) {
        	    regDm.update({
                    url:'<c:url value="/prj/tss/gen/getTssRegistCnt.do"/>',
                    params:'gbn=GRS&tssCd='+gvTssCd
                });
        	}
        });


        //품의서요청
        btnCsusRq = new Rui.ui.LButton('btnCsusRq');
        btnCsusRq.on('click', function() {
        	if(confirm("품의서요청을 하시겠습니까?")) {
        	    regDm.update({
                    url:'<c:url value="/prj/tss/gen/getTssRegistCnt.do"/>',
                    params:'gbn=CSUS&tssCd='+gvTssCd
                });
        	}
        });


        //진행
        btnPgsRq = new Rui.ui.LButton('btnPgsRq');
        btnPgsRq.on('click', function() {
        	if(confirm("차년도 과제를 진행 하시겠습니까?")) {
        	    regDm.update({
                    url:'<c:url value="/prj/tss/gen/getTssRegistCnt.do"/>',
                    params:'gbn=PGS&tssCd='+gvTssCd
                });
        	}
        });


      //목록 
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {   
			$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
			$('#searchForm > input[name=saUserName]').val(encodeURIComponent($('#searchForm > input[name=saUserName]').val()));
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));
			
            nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
        
        //최초 데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("mst searchData1");
            dataSet.loadData(${result});
        } else {
            console.log("mst searchData2");
            dataSet.newRecord();
            tabView.selectTab(0);
        }


        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnDelRq").hide();
        	$("#btnGrsRq").hide();
        	$("#btnCsusRq").hide();
        	$("#btnPgsRq").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnDelRq").hide();
        	$("#btnGrsRq").hide();
        	$("#btnCsusRq").hide();
        	$("#btnPgsRq").hide();
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
	    	<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
	        <h2>국책과제 &gt;&gt; 계획</h2>
	    </div>
        <div class="sub-content">
            <div class="titArea mt0">
                <div class="LblockButton mt0">
                	<button type="button" id="btnDelRq" name="btnDelRq">삭제</button>
                    <button type="button" id="btnGrsRq" name="btnGrsRq">GRS요청</button>
                    <button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
                    <button type="button" id="btnPgsRq" name="btnPgsRq">진행</button>
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
                    <input type="hidden" id="tssCd"      name="tssCd"      value=""> <!-- 과제코드 -->
                    <input type="hidden" id="userId"     name="userId"     value=""> <!-- 사용자ID -->
                    <input type="hidden" id="prjCd"      name="prjCd"      value=""> <!-- 프로젝트코드 -->
                    <input type="hidden" id="deptCode"   name="deptCode"   value=""> <!-- 조직코드 -->
                    <input type="hidden" id="saSabunNew" name="saSabunNew" value=""> <!-- 과제리더사번 -->

                    <input type="hidden" id="pgsStepCd" name="pgsStepCd" value="PL"> <!-- 진행단계코드 -->
                    <input type="hidden" id="tssScnCd" name="tssScnCd" value="N"> <!-- 과제구분코드 -->
                    <input type="hidden" id="tssSt"      name="tssSt"  value="100"> <!-- 과제상태 -->
                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 13%;" />
                                <col style="width: 36%;" />
                                <col style="width: 14%;" />
                                <col style="" />
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
                                    <td colspan="3">
                                        <span id='seed'></span><input type="text" id="wbsCd" />/ <em class="gab"><input type="text" id="tssNm" />
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
                                    <td colspan="3"><span id="tssStepNm"></span> / <span id="grsStepNm"></span></td>
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
                </form>
        </div>
        <!-- //sub-content -->
    </div>
    <!-- //contents -->

</body>
</html>