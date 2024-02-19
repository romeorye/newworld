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

<script type="text/javascript">
    var gvTssCd  = "";
    var gvUserId = "${inputData._userId}";
    var gvTssSt  = "";
    var gvPageMode  = "";
    var gvRoleId = "";

    var pgsStepNm = "";
    var dataSet;
    var pgsStepCd = "";

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
    
    var tmpTssStrtDd;
    var tmpTssFnhDd;

    var altrHistDialog;

    var isEditable = false;

    Rui.onReady(function() {
        var isInsert = false;
        var form = new Rui.ui.form.LForm('mstForm');
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //프로젝트명
        prjNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'prjNm',
            width: 300,
            editable: false
        });
        prjNm.on('popup', function(e){
            openPrjSearchDialog(setPrjInfo,'');
        });

        //조직코드
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            width: 300
        });

        //발의주체
        ppslMbdCd = new Rui.ui.form.LCombo({
            applyTo: 'ppslMbdCd',
            name: 'ppslMbdCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PPSL_MBD_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        ppslMbdCd.getDataSet().on('load', function(e) {
            console.log('ppslMbdCd :: load');
        });

        //사업부문(Funding기준)
        bizDptCd = new Rui.ui.form.LCombo({
            applyTo: 'bizDptCd',
            name: 'bizDptCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=BIZ_DPT_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        bizDptCd.getDataSet().on('load', function(e) {
            console.log('bizDptCd :: load');
        });

        //WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            width: 100
        });

        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            width: 500
        });

        //과제리더
        saUserName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saUserName',
            width: 150,
            editable: false,
            enterToPopup: true
        });
        saUserName.on('popup', function(e){
            openUserSearchDialog(setLeaderInfo, 1, '');
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


        //과제속성
        tssAttrCd = new Rui.ui.form.LCombo({
            applyTo: 'tssAttrCd',
            name: 'tssAttrCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_ATTR_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
        tssAttrCd.getDataSet().on('load', function(e) {
            console.log('tssAttrCd :: load');
        });

        //제품군
        prodGCd = new Rui.ui.form.LCombo({
            applyTo: 'prodGCd',
            name: 'prodGCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PROD_G"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
        prodGCd.getDataSet().on('load', function(e) {
            console.log('prodGCd :: load');
        });

        //과제기간 시작일
        tssStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssStrtDd',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        tssStrtDd.on('blur', function() {
            if(Rui.isEmpty(tssStrtDd.getValue())) return;

            if(!Rui.isEmpty(tssFnhDd.getValue())) {
                var startDt = tssStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = tssFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    alert("시작일보다 종료일이 빠를 수 없습니다.");
                    tssStrtDd.setValue("");
                    return;
                }
            }

            if( !Rui.isEmpty(tssStrtDd.getValue()) && !Rui.isEmpty(tssFnhDd.getValue()) ){
            	document.getElementById('tabContent0').contentWindow.fncPtcCpsnYDisable(tssStrtDd.getValue(), tssFnhDd.getValue());
            }
        });

        tssStrtDd.on('changed', function(){
        	if( !Rui.isEmpty(tssStrtDd.getValue()) && !Rui.isEmpty(tssFnhDd.getValue()) ){
            	document.getElementById('tabContent0').contentWindow.fncPtcCpsnYDisable(tssStrtDd.getValue(), tssFnhDd.getValue());
            }
        });

        // 과제기간 종료일
        tssFnhDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssFnhDd',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        tssFnhDd.on('blur', function() {
            if(Rui.isEmpty(tssFnhDd.getValue())) return;

            if(!Rui.isEmpty(tssStrtDd.getValue())) {
                var startDt = tssStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = tssFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    alert("시작일보다 종료일이 빠를 수 없습니다.");
                    tssFnhDd.setValue("");
                    return;
                }
            }
            if( !Rui.isEmpty(tssStrtDd.getValue()) && !Rui.isEmpty(tssFnhDd.getValue()) ){
            	document.getElementById('tabContent0').contentWindow.fncPtcCpsnYDisable(tssStrtDd.getValue(), tssFnhDd.getValue());
            }
        });

        tssFnhDd.on('changed', function(){
        	if( !Rui.isEmpty(tssStrtDd.getValue()) &&  !Rui.isEmpty(tssFnhDd.getValue()) ){
            	document.getElementById('tabContent0').contentWindow.fncPtcCpsnYDisable(tssStrtDd.getValue(), tssFnhDd.getValue());
            }
        });

      //연구분야
        rsstSphe = new Rui.ui.form.LCombo({
            applyTo: 'rsstSphe',
            name: 'rsstSphe',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=RSST_SPHE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });

        rsstSphe.getDataSet().on('load', function(e) {
            console.log('rsstSphe :: load');
        });

        //유형
        tssType = new Rui.ui.form.LCombo({
            applyTo: 'tssType',
            name: 'tssType',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_TYPE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });


        tssType.getDataSet().on('load', function(e) {
            console.log('tssType :: load');
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

        //form 비활성화 여부
        var disableFields = function(disable) {
            //버튼
            btnDelRq.hide();
            btnGrsRq.hide();
            btnCsusRq.hide();

            //form
            prjNm.setEditable(false);
            deptName.setEditable(false);
            wbsCd.setEditable(false);

            //style
            $('#prjNm > a').attr('style', "display:none;");
            $('#prjNm').attr('style', "border-color:white;");
            $('#deptName').attr('style', "border-color:white;");
            $('#wbsCd').attr('style', "border-color:white;");

            //조건에 따른 보이기
            if("TR01" == gvRoleId || "${inputData._userSabun}" == dataSet.getNameValue(0, "saSabunNew")) {
	            if(gvTssSt == "100"){
	            	btnGrsRq.show();
	            	btnDelRq.show();
	            }else if(
                    pgsStepCd=="PL" && gvTssSt == "302" ||  // G1 GRS품의 완료
                    pgsStepCd!="PL" && gvTssSt == "102"){   // GRS평가 완료
	            	btnCsusRq.show();
	            }
	        }

            if("TR01" == gvRoleId) {
	            $('#prjNm > a').attr('style', "display:block;");
	            $('#prjNm').attr('style', "border-color:;");
            }

            if(disable) {
                prjNm.disable();
                deptName.disable();
                ppslMbdCd.disable();
                bizDptCd.disable();
                wbsCd.disable();
                tssNm.disable();
                saUserName.disable();
                tssAttrCd.disable();
                tssStrtDd.disable();
                tssFnhDd.disable();
                prodGCd.disable();
                rsstSphe.disable();
                tssType.disable();
            } else {
                prjNm.enable();
                deptName.enable();
                ppslMbdCd.enable();
                bizDptCd.enable();
                wbsCd.enable();
                tssNm.enable();
                saUserName.enable();
                tssAttrCd.enable();
                tssStrtDd.enable();
                tssFnhDd.enable();
                prodGCd.enable();
                rsstSphe.enable();
                tssType.enable();
            }


            if(pgsStepCd!=undefined && pgsStepCd=="PL"){
                btnDelRq.hide();        //삭제
                btnGrsRq.hide();       //GRS요청
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
                  { id: 'tssCd' }      //과제코드
                , { id: 'userId' }     //로그인ID
                , { id: 'prjCd' }      //프로젝트코드
                , { id: 'prjNm' }      //프로젝트명
                , { id: 'deptCode' }   //조직코드
                , { id: 'deptName' }   //조직명
                , { id: 'ppslMbdCd' }  //발의주체
                , { id: 'bizDptCd' }   //사업부문(Funding기준)
                , { id: 'wbsCd' }      //WBSCode
                , { id: 'pkWbsCd' }    //WBSCode
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
                , { id: 'prodGCd' }      //제품군
                , { id: 'rsstSphe' }      //연구분야
                , { id: 'tssType' }      //유형
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
                , {id: 'grsYn'}	// GRS G1 수행여부
                , {id: 'tssStepNm'}	//관제 단계
                , {id: 'grsStepNm'}	//GRS 단계
                , {id: 'qgateStepNm'}	//Qgate 단계
            ]
        });
        dataSet.on('load', function(e) {
            gvTssCd = stringNullChk(dataSet.getNameValue(0, "tssCd"));
            gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt"));
            
            if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T08') > -1 || "<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T09') > -1 
                || "<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T11') > -1  || "<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T13') > -1	
                || "<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T14') > -1 
            ) {
            	gvPageMode = "R";
            }else{
            	gvPageMode = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            }
            
            gvRoleId = stringNullChk(dataSet.getNameValue(0, "tssRoleId"));
            pgsStepCd = stringNullChk(dataSet.getNameValue(0, "pgsStepCd"));
            gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt"));


            tmpTssStrtDd = dataSet.getNameValue(0, 'tssStrtDd');
            tmpTssFnhDd =  dataSet.getNameValue(0, 'tssFnhDd');
            
            //최초 로그인사용자 정보 셋팅
            if(gvTssCd == "") {
                dataSet.setNameValue(0, "prjCd", "${userMap.prjCd}");          //프로젝트코드
                dataSet.setNameValue(0, "prjNm", "${userMap.prjNm}");          //프로젝트명
                dataSet.setNameValue(0, "deptCode", "${userMap.upDeptCd}");    //조직코드
                dataSet.setNameValue(0, "deptName", "${userMap.upDeptName}");  //조직명
                dataSet.setNameValue(0, "saSabunNew", "${inputData._userSabun}"); //과제리더사번
                dataSet.setNameValue(0, "saUserName", "${inputData._userNm}");    //과제리더명

                if(stringNullChk("${userMap.prjCd}") == "") {
                    alert("프로젝트 등록을 먼저 해주시기 바랍니다.");
                }
            }

            if(stringNullChk(dataSet.getNameValue(0, "wbsCd")) != "") {
                document.getElementById("seed").innerHTML = "SEED -";
            } else {
                document.getElementById("seed").innerHTML = "";
            }
            $('[name="wbsCd"]').css("width",50);
            $("#gap").css("margin","0px");

            disableFields();

            isFirst = gvTssSt == "";
            isEditable =
                isFirst
                || gvTssSt=="100" || gvTssSt=="102"
                // || dataSet.getNameValue(0, "grsYn")=="N" && (pgsStepCd=="PL" )
            ;


            tabView.selectTab(0);
            nwinsActSubmit(document.tabForm, "<c:url value='/prj/tss/gen/genTssPlnSmryIfm.do?tssCd=" + gvTssCd + "'/>", 'tabContent0');
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
                , { id: 'ppslMbdCd',  ctrlId: 'ppslMbdCd',  value: 'value' }
                , { id: 'bizDptCd',   ctrlId: 'bizDptCd',   value: 'value' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }
                , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'value' }
                , { id: 'saSabunNew', ctrlId: 'saSabunNew', value: 'value' }
                , { id: 'saUserName', ctrlId: 'saUserName', value: 'value' }
                , { id: 'tssAttrCd',  ctrlId: 'tssAttrCd',  value: 'value' }
                , { id: 'tssStrtDd',  ctrlId: 'tssStrtDd',  value: 'value' }
                , { id: 'tssFnhDd',   ctrlId: 'tssFnhDd',   value: 'value' }
                , { id: 'userId',     ctrlId: 'userId',     value: 'value' }
                , { id: 'prodGCd',    ctrlId: 'prodGCd',    value: 'value' }
                , { id: 'rsstSphe',   ctrlId: 'rsstSphe',   value: 'value' }
                , { id: 'tssType',    ctrlId: 'tssType',    value: 'value' }
                , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'html' }				//과제 단계명
                , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'html' }				// GRS 단계명
                , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'html' }		//Qgate 단계명

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
            
            document.getElementById('tabContent0').contentWindow.fnIfmInit();
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
                { label: '개요', content: '<div id="div-content-test1"></div>' },
                { label: '참여연구원', content: '<div id="div-content-test2"></div>' },
                { label: 'WBS', content: '<div id="div-content-test3"></div>' },
                { label: '투입예산', content: '<div id="div-content-test4"></div>' },
                { label: '목표 및 산출물', content: '<div id="div-content-test5"></div>' }
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
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPlnSmryIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                } else {
                    disableFields(false);
                }
                break;
            //참여연구원
            case 1:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPlnPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                disableFields(true);
                break;
            //WBS
            case 2:
                if(e.isFirst) {
                }
                tabUrl = "<c:url value='/prj/tss/gen/genTssPlnWBSIfm.do?tssCd=" + gvTssCd + "'/>";
                nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                disableFields(true);
                break;
            //투입예산
            case 3:
                if(e.isFirst) {
	                tabUrl = "<c:url value='/prj/tss/gen/genTssPlnTrwiBudgIfm.do?tssCd=" + gvTssCd + "'/>";
	                nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
                }
                disableFields(true);
                break;
            //목표 및 산출물
            case 4:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/gen/genTssPlnGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent4');
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
        //DB테이블 건수확인
        var regDm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        regDm.on('success', function(e) {
            var regCntMap = JSON.parse(e.responseText)[0].records[0];

            var errMsg = "";

            //계획
          	if(regCntMap.genSmryCnt <= 0)       errMsg = "개요를 입력해 주시기 바랍니다.";
              else if(regCntMap.genWbsCnt < 1)  errMsg = "WBS를 입력해 주시기 바랍니다.";
              else if(regCntMap.genTrwiCnt <= 0) errMsg = "투입예산을 입력해 주시기 바랍니다.";
              else if(regCntMap.comGoalCnt < 1) errMsg = "목표를 입력해 주시기 바랍니다.";
              else if(regCntMap.comMbrCnt <= 0)  errMsg = "참여원구원을 입력해 주시기 바랍니다.";
              else if(regCntMap.comYldCnt < 2)   errMsg = "산출물을 입력해 주시기 바랍니다.";

            if(errMsg != "") alert(errMsg);
            else {
                if(regCntMap.gbn == "GRS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/grs/grsEvRslt.do?tssCd="+gvTssCd+"&userId="+gvUserId+"'/>");
                else if(regCntMap.gbn == "CSUS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssPlnCsusRq.do'/>" + "?tssCd="+gvTssCd+"&userId="+gvUserId+"&appCode=APP00332");
            }
        });


        //삭제
        btnDelRq = new Rui.ui.LButton('btnDelRq');
        btnDelRq.on('click', function() {
        	if(confirm("삭제를 하시겠습니까?")) {
        		dm.updateDataSet({
                    modifiedOnly: false,
                    url:'<c:url value="/prj/tss/gen/deleteGenTssPlnMst.do"/>',
                    dataSets:[dataSet],
                    params: {
                    	tssCd : gvTssCd
                    }
                });
        	}
        		dm.on('success', function(e) {
    	  	    	nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
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


        //저장
        fnSave = function() {
            tssStrtDd.blur();
            tssFnhDd.blur();

            if(!vm.validateGroup("mstForm")) {
                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                return;
            }

            //개요탭 validation
            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");
            if(!ifmUpdate) return false;

            //수정여부
            var smryDs = document.getElementById('tabContent0').contentWindow.dataSet;                  //개요탭 DS

            var pmisTxt = document.getElementById('tabContent0').contentWindow.smryForm.pmisTxt.value;
            var bizDpt = bizDptCd.getValue();
            var bizDptNm = bizDptCd.getDisplayValue();

            if(  bizDpt == "07" || bizDpt == "08" || bizDpt == "09"  ){
            	var bizMsg =  bizDptNm+" 사업부문일경우 지적재산팀 검토의견을 입력하셔야 합니다";

            	if( Rui.isEmpty(pmisTxt)){
            		alert(bizMsg);
            		return;
            	}
            }

            if(confirm("저장하시겠습니까?")) {
                dataSet.setNameValue(0, "pgsStepCd", "PL"); //진행단계: PL(계획)
                dataSet.setNameValue(0, "tssScnCd", "G");   //과제구분: G(일반)
                dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                dataSet.setNameValue(0, "tssCd",  gvTssCd);  //과제코드
                dataSet.setNameValue(0, "userId", gvUserId); //사용자ID
                smryDs.setNameValue(0, "tssCd",  gvTssCd);   //과제코드
                smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID

                //신규
                if(gvTssCd == "") {
                	 dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/gen/insertGenTssPlnMst.do"/>',
                        dataSets:[dataSet, smryDs]
                    });
                }
                //수정
                else {
                	dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/gen/updateGenTssPlnMst.do"/>',
                        dataSets:[dataSet, smryDs]
                    });
                }
            }
        };


        //프로젝트 팝업
        prjSearchDialog = new Rui.ui.LFrameDialog({
            id: 'prjSearchDialog',
            title: '프로젝트 조회',
            width: 600,
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

   		//목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
			$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
			$('#searchForm > input[name=saUserName]').val(encodeURIComponent($('#searchForm > input[name=saUserName]').val()));
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));

            nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
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
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnDelRq").hide();
        	$("#btnGrsRq").hide();
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
//프로젝트 팝업 셋팅
function setPrjInfo(prjInfo) {
    console.log(prjInfo);
    dataSet.setNameValue(0, "deptCode", prjInfo.upDeptCd);
    dataSet.setNameValue(0, "deptName", prjInfo.upDeptName);
    dataSet.setNameValue(0, "prjCd", prjInfo.prjCd);
    dataSet.setNameValue(0, "prjNm", prjInfo.prjNm);
//     dataSet.setNameValue(0, "saSabunNew", prjInfo.plEmpNo);   //과제리더사번
//     dataSet.setNameValue(0, "saUserName", prjInfo.plEmpName); //과제리더명
}

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
            <h2>일반과제 &gt;&gt; 계획</h2>
        </div>

        <div class="sub-content">
            <div class="titArea mt0">
                <div class="titArea btn_top">
					<div class="LblockButton">
	                    <button type="button" id="btnDelRq" name="btnDelRq">삭제</button>
	                    <button type="button" id="btnGrsRq" name="btnGrsRq">GRS요청</button>
	                    <button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
	                    <button type="button" id="btnList" name="btnList">목록</button>
	                </div>
                </div>
            </div>
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
                    <input type="hidden" id="tssCd"      name="tssCd"      value=""> <!-- 과제코드 -->
                    <input type="hidden" id="userId"     name="userId"     value=""> <!-- 사용자ID -->
                    <input type="hidden" id="prjCd"      name="prjCd"      value=""> <!-- 프로젝트코드 -->
                    <input type="hidden" id="deptCode"   name="deptCode"   value=""> <!-- 조직코드 -->
                    <input type="hidden" id="saSabunNew" name="saSabunNew" value=""> <!-- 과제리더사번 -->

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
                                    <td colspan="3">
                                        <span id='seed'></span><input type="text" id="wbsCd" /> / <em class="gab"><input type="text" id="tssNm" style="width:900px;padding:0px 5px" />
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
                                    <th align="right">발의주체</th>
                                    <td>
                                        <div id="ppslMbdCd"></div>
                                    </td>
                                    <th align="right">제품군</th>
                                    <td>
                                        <div id="prodGCd" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제속성</th>
                                    <td>
                                        <div id="tssAttrCd"></div>
                                    </td>
                                    <th align="right">과제기간</th>
                                    <td>
                                        <input type="text" id="tssStrtDd" /><em class="gab"> ~ </em>
                                        <input type="text" id="tssFnhDd" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">연구분야</th>
                                    <td>
                                        <div id="rsstSphe">
                                    </td>
                                    <th align="right">유형</th>
                                    <td>
                                        <div id="tssType">
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
                <iframe name="tabContent0" id="tabContent0" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent1" id="tabContent1" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent2" id="tabContent2" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent3" id="tabContent3" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent4" id="tabContent4" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
            </form>
        </div>
    </div>

</body>
</html>