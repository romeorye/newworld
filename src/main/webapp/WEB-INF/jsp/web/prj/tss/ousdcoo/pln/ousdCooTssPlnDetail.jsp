<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssPlnDetail.jsp
 * @desc    : 대외협력과제 > 계획 상세 탭 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.18  IRIS04		최초생성
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
    var gvTssCd  = "";
    var gvUserId = "<c:out value='${inputData._userId}'/>";
    var gvTssSt  = "";
    var gvCooInstCd = "";
    var gvPageMode  = "";

    var pgsStepNm = "";
    var dataSet;

    //Form
    var prjNm;
    var deptName;
    var bizDptCd;
    var tssNm;
    var saUserName;
    var tssStrtDd;
    var tssFnhDd;

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

        //과제유형
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

        //WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            width: 80,
        	attrs: { maxLength: 6 }
        });

        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            width: 500,
            attrs: { maxLength: 100 }
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

        //과제기간 시작일
        tssStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssStrtDd',
            mask: '9999-99-99',
            width: 100,
            displayValue: '%Y-%m-%d',
			defaultValue: new Date(),
            dateType: 'string'
        });
        tssStrtDd.on('blur', function() {
            if(Rui.isEmpty(tssStrtDd.getValue())) return;

            if(!Rui.isEmpty(tssFnhDd.getValue())) {
                var startDt = tssStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = tssFnhDd.getValue().replace(/\-/g, "").toDate();

                if(startDt > fnhDt) {
                    alert("시작일보다 종료일이 빠를 수 없습니다.");
                    tssStrtDd.setValue("");
                    return;
                }
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

                if(startDt > fnhDt) {
                    alert("시작일보다 종료일이 빠를 수 없습니다.");
                    tssFnhDd.setValue("");
                    return;
                }
            }
        });

        //form 비활성화 여부
        var disableFields = function(disable) {

            //버튼여부
            btnDelRq.hide();
            btnGrsRq.hide();
            btnCsusRq.hide();

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

            var pTssRoleId = stringNullChk(dataSet.getNameValue(0, "tssRoleId"));

            //조건에 따른 보이기
            if(pTssRoleId != "TR05" && pTssRoleId != "") {
                if(gvTssSt == "100"){
                	btnDelRq.show();
                	btnGrsRq.show(); //GRS - 100:작성중
                }else if(gvTssSt == "102"){
                	btnCsusRq.show(); //품의 - 102:GRS완료
                }
            }

            //if(pTssRoleId == "TR01") {
                $('#prjNm > a').attr('style', "display:block;");
                $('#saUserName > a').attr('style', "display:block;");
                $('#prjNm').attr('style', "border-color:;");
                $('#saUserName').attr('style', "border-color:;");
            //}

            if(disable) {
                prjNm.disable();
                deptName.disable();
                bizDptCd.disable();
                wbsCd.disable();
                tssNm.disable();
                saUserName.disable();
                tssStrtDd.disable();
                tssFnhDd.disable();
                cooInstNm.disable();	//협력기관
            } else {
                prjNm.enable();
                deptName.enable();
                bizDptCd.enable();
                wbsCd.enable();
                tssNm.enable();
                saUserName.enable();
                tssStrtDd.enable();
                tssFnhDd.enable();
                cooInstNm.enable();	//협력기관
            }


            if(pgsStepCd=="PL"){
                btnDelRq.hide();
                btnGrsRq.hide();
                btnCsusRq.hide();
            }
        }

        // 협력기관
        cooInstNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'cooInstNm',
            width: 260,
            editable: false,
            placeholder: '',
            emptyValue: '',
            enterToPopup: true
        });
        cooInstNm.on('blur', function(e) {
        	cooInstNm.setValue(cooInstNm.getValue().trim());
        });
        cooInstNm.on('popup', function(e){
        	openOutsideSpecialistDialog(setOutsideSpecialistInfo);
        });

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
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
                , { id: 'isEditable' }
            ]
        });
        dataSet.on('load', function(e) {
            gvTssCd     = stringNullChk(dataSet.getNameValue(0, "tssCd"));
            gvTssSt     = stringNullChk(dataSet.getNameValue(0, "tssSt"));
            gvCooInstCd = stringNullChk(dataSet.getNameValue(0, "cooInstCd"));
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

            disableFields();

            isEditable =
                (pgsStepCd=="PL" && (gvTssSt=="100")) ||
                (pgsStepCd=="AL" && gvTssSt=="100") ||
                (dataSet.getNameValue(0, "isEditable")=="1" && pgsStepCd=="PL"); // GRS  평가완료한 경우(품의완료까지 수정가능)



            tabView.selectTab(0);
            nwinsActSubmit(document.tabForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssPlnSmryIfm.do?tssCd=" + gvTssCd + "'/>", 'tabContent0');
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
                , { id: 'cooInstCd',  ctrlId: 'cooInstCd',  value: 'value' } /*협력기관코드*/
                , { id: 'cooInstNm',  ctrlId: 'cooInstNm',  value: 'value' } /*협력기관명*/
            ]
        });

        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                   { id: 'prjNm',       validExp: '프로젝트명:true' }
                 , { id: 'bizDptCd',   validExp: '과제유형:true' }
                 , { id: 'tssNm',      validExp: '과제명:true' }
                 , { id: 'tssStrtDd',  validExp: '과제기간 시작일:true' }
                 , { id: 'tssFnhDd',   validExp: '과제기간 종료일:true' }
                 , { id: 'cooInstNm',  validExp: '협력기관:true' }
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

            // 완료시 재조회
            tabView.selectTab(0);
        });

        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: '개요'           , content: '<div id="div-content-test0"></div>' },
                { label: '참여연구원'     , content: '<div id="div-content-test1"></div>' },
                { label: '목표 및 산출물' , content: '<div id="div-content-test2"></div>' }
            ]
        });
        tabView.on('canActiveTabChange', function(e) {
            if((gvTssSt == "100" || gvTssSt == "") && dataSet.isUpdated()) {
                if(tabView.getActiveIndex() != 0) {
                    alert("개요 저장을 먼저 해주시기 바랍니다.");
                    return false;
                }
            }
        });
        tabView.on('activeTabChange', function(e) {
            //iframe 숨기기
            for(var i = 0; i < 3; i++) {
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
	                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPlnSmryIfm.do?tssCd=" + gvTssCd + "'/>";
	                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
	                } else {
	                    disableFields(false);
	                }
	                break;
	            //참여연구원
	            case 1:
	                if(e.isFirst) {
	                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPlnPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "'/>";
	                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
	                }
	                disableFields(true);
	                break;
	            //목표 및 산출물
	            case 2:
	                if(e.isFirst) {
	                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPlnGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
	                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
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
            if(regCntMap.ousdSmryCnt <= 0)     errMsg = "개요를 입력해 주시기 바랍니다.";
            else if(regCntMap.comMbrCnt <= 0)  errMsg = "참여원구원을 입력해 주시기 바랍니다.";
            else if(regCntMap.comGoalCnt <= 0) errMsg = "목표를 입력해 주시기 바랍니다.";
            else if(regCntMap.comYldCnt < 2)  errMsg = "산출물을 입력해 주시기 바랍니다.";

            if(errMsg != "") alert(errMsg);
            else {
                if(regCntMap.gbn == "GRS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/grs/grsEvRslt.do?tssCd="+gvTssCd+"&userId="+gvUserId+"'/>");
                else if(regCntMap.gbn == "CSUS") nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssPlnCsusRq.do?tssCd="+gvTssCd+"&userId="+gvUserId+"&outSpclId="+gvCooInstCd+"'/>");

            }
        });


      //삭제
        btnDelRq = new Rui.ui.LButton('btnDelRq');
        btnDelRq.on('click', function() {
        	if(confirm("삭제를 하시겠습니까?")) {
        		dm.updateDataSet({
                    modifiedOnly: false,
                    url:'<c:url value="/prj/tss/ousdcoo/deleteOusdCooTssPlnMst.do"/>',
                    dataSets:[dataSet],
                    params: {
                    	tssCd : gvTssCd
                    }
                });
        	}
        		dm.on('success', function(e) {
    	  	    	nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
    			});
        });

        //GRS요청
        btnGrsRq = new Rui.ui.LButton('btnGrsRq');
        btnGrsRq.on('click', function() {

        	if(confirm("GRS요청을 하시겠습니까?")) {
        		// 테이블 저장 체크
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
        		// 테이블 저장 체크
        	    regDm.update({
                    url:'<c:url value="/prj/tss/gen/getTssRegistCnt.do"/>',
                    params:'gbn=CSUS&tssCd='+gvTssCd
                });
        	}
        });

        //저장
        fnSave = function() {

        	// 달력 blur
        	tssStrtDd.blur();
        	tssFnhDd.blur();

        	// 마스터 validation 체크
             if(!vm.validateGroup("mstForm")) {
	                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
	                return;
			}

          	// 개요 validation 체크
         	if( document.getElementById('tabContent0').contentWindow.validation() ){
         		return false;
         	}

        	// 데이터 변경여부 확인
        	var smryDs = document.getElementById('tabContent0').contentWindow.dataSet;                  //개요탭 DS

            if( confirm("저장하시겠습니까?") == true ){
                dataSet.setNameValue(0, "pgsStepCd"   , "PL");      //진행단계: PL(계획)
                dataSet.setNameValue(0, "tssScnCd"    , "O");       //과제구분: O(대외협력과제)
                dataSet.setNameValue(0, "tssSt"       , "100");     //과제상태: 100(작성중)
                dataSet.setNameValue(0, "tssCd"       , gvTssCd);   //과제코드
                dataSet.setNameValue(0, "userId"      , gvUserId);  //사용자ID
                dataSet.setNameValue(0, "tssRoleType" , "W");       //화면권한

                smryDs.setNameValue(0, "tssCd"        , gvTssCd);   //과제코드
                smryDs.setNameValue(0, "userId"       , gvUserId);  //사용자ID

                //신규
                if(gvTssCd == "") {

                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/ousdcoo/insertOusdCooTssPlnMst.do"/>',
                        dataSets:[dataSet, smryDs] 
                    });
                }else {								//수정
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssPlnMst.do"/>',
                        dataSets:[dataSet, smryDs]
                    });
                }
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

     	// 사외전문가 팝업 DIALOG
	    outsideSpecialistSearchDialog = new Rui.ui.LFrameDialog({
	        id: 'prjSearchDialog',
	        title: '협력기관선택', 	//DIALOG TITLE
	        width: 750,
	        height: 500,
	        modal: true,
	        visible: false
	    });
	    outsideSpecialistSearchDialog.on('cancel', function(e) {
	    	try{
	    		tabContent0.$('object').css('visibility', 'visible');
	    	}catch(e){}
	    });
	    outsideSpecialistSearchDialog.on('submit', function(e) {
	    	try{
	    		tabContent0.$('object').css('visibility', 'visible');
	    	}catch(e){}
	    });
	    outsideSpecialistSearchDialog.on('show', function(e) {
	    	try{
	    		tabContent0.$('object').css('visibility', 'hidden');
	    	}catch(e){}
	    });
	    outsideSpecialistSearchDialog.render(document.body);

	    openOutsideSpecialistDialog = function(f,p) {
			var param = '?searchType=';
			if( !Rui.isNull(p) && p != ''){
				param += p;
			}

			_callback = f;

			outsideSpecialistSearchDialog.setUrl('<c:url value="/knld/pub/outsideSpecialistPopup.do"/>' + param);
			outsideSpecialistSearchDialog.show();
		};

		setOutsideSpecialistInfo = function(specialistInfo) {
			dataSet.setNameValue(0, "cooInstCd" , specialistInfo.outSpclId);
			cooInstNm.setValue(specialistInfo.instNm);
	    };


        //최초 데이터 셋팅
        var resultCnt = Number('<c:out value="${resultCnt}"/>');
       
        if(resultCnt > 0) {
            dataSet.loadData( ${result} );

        } else {
            dataSet.newRecord();
            tabView.selectTab(0);
            tssStrtDd.setValue(new Date());
        }

        disableFields();



      	//목록 
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {   
        	$('#searchForm > input[name=wbsCd]').val(encodeURIComponent($('#searchForm > input[name=wbsCd]').val()));
			$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
			$('#searchForm > input[name=saUserName]').val(encodeURIComponent($('#searchForm > input[name=saUserName]').val()));
			$('#searchForm > input[name=tssStrtDd]').val(encodeURIComponent($('#searchForm > input[name=tssStrtDd]').val()));
			$('#searchForm > input[name=tssFnhDd]').val(encodeURIComponent($('#searchForm > input[name=tssFnhDd]').val()));
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));
			$('#searchForm > input[name=pgsStepCd]').val(encodeURIComponent($('#searchForm > input[name=pgsStepCd]').val()));
			$('#searchForm > input[name=tssSt]').val(encodeURIComponent($('#searchForm > input[name=tssSt]').val()));
			
            nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
        });

    });// end rui load
</script>
<script type="text/javascript">
//과제리더 팝업 셋팅
function setLeaderInfo(userInfo) {
    dataSet.setNameValue(0, "saSabunNew", userInfo.saSabun);
    dataSet.setNameValue(0, "saUserName", userInfo.saName);
}
//프로젝트 팝업 셋팅
function setPrjInfo(prjInfo) {
    dataSet.setNameValue(0, "deptCode"  , prjInfo.upDeptCd);
    dataSet.setNameValue(0, "deptName"  , prjInfo.upDeptName);
    dataSet.setNameValue(0, "prjCd"     , prjInfo.prjCd);
    dataSet.setNameValue(0, "prjNm"     , prjInfo.prjNm);
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
			<h2>대외협력과제 &gt;&gt;계획</h2>
    	</div>
        <%-- <%@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>

        <div class="sub-content">
            <div class="titArea mt0">
                <div class="LblockButton">
                	<button type="button" id="btnDelRq" name="btnDelRq">삭제</button>
                    <button type="button" id="btnGrsRq" name="btnGrsRq">GRS요청</button>
                    <button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
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
                    <input type="hidden" id="cooInstCd"  name="cooInstCd"  value=""> <!-- 협력기관코드 -->
                    <input type="hidden" id="pkWbsCd"    name="pkWbsCd"    value=""> <!-- WBS CODE(PK) -->

                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 17%;" />
                                <col style="width: 34%;" />
                                <col style="width: 15%;" />
                                <col style="width: 34%;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">프로젝트명</th>
                                    <td>
                                        <input type="text" id="prjNm" value="">
                                    </td>
                                    <th align="right">조직</th>
                                    <td>
                                        <input type="text" id="deptName" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">WBSCode / 과제명</th>
                                    <td colspan="3">
                                     	<input type="text" id="wbsCd" value=""> / <input type="text" id="tssNm" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제리더</th>
                                    <td>
                                        <div id="saUserName"></div>
                                    </td>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td>
                                        <div id="bizDptCd"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">협력기관(기관명/소속/성명)</th>
                                    <td>
                                        <input type="text" id="cooInstNm" value="">
                                    </td>
                                    <th align="right">과제기간</th>
                                    <td>
                                        <input type="text" id="tssStrtDd" value="" /><em class="gab"> ~ </em><input type="text" id="tssFnhDd" value="" />
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
                <iframe name="tabContent0" id="tabContent0" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent1" id="tabContent1" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent2" id="tabContent2" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
            </form>

  		</div><!-- //sub-content -->
  	</div><!-- //contents -->
</body>
</html>