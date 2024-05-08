<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssAltrDetail.jsp
 * @desc    : 대외협력과제 > 변경 상세 상단 탭 화면
              진행-GRS(변경) or 변경상태인 경우 진입
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.22  IRIS04		최초생성
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
    var gvTssSt     = "";
    var gvPgsStepCd = "AL"; //진행상태:AL(변경)
    var gvWbsCd     = "";
    var gvPgTssCd;			//진행 과제코드
    var gvPageMode  = "";
    var lvWbsCd  = "";

    var altrTssCd   = "";
    var dataSet;
    var tabInx = 0;

    var altrHistDialog;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //프로젝트명
        prjNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'prjNm2',
            width: 300,
            editable: false,
            enterToPopup: true
        });
        prjNm.on('popup', function(e){
            openPrjSearchDialog(setPrjInfo,'');
        });

        //조직코드
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName2',
            width: 300
        });

        //과제유형
        bizDptCd = new Rui.ui.form.LCombo({
            applyTo: 'bizDptCd2',
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
            applyTo: 'wbsCd2',
            width: 80,
        	attrs: { maxLength: 6 }
        });

        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm2',
            width: 500,
            attrs: { maxLength: 100 }
        });

        //연구책임자
        saUserName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saUserName2',
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
        		tabContent1.$('object').css('visibility', 'visible');
        	}catch(e){}
        });
        _userSearchDialog.on('submit', function(e) {
        	try{
        		tabContent1.$('object').css('visibility', 'visible');
        	}catch(e){}
        });
        _userSearchDialog.on('show', function(e) {
        	try{
        		tabContent1.$('object').css('visibility', 'hidden');
        	}catch(e){}
        });

        //과제기간 시작일
        tssStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssStrtDd2',
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
            applyTo: 'tssFnhDd2',
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

     	// 협력기관
        cooInstNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'cooInstNm2',
            width: 260,
            editable: false,
            placeholder: '',
            emptyValue: '',
            enterToPopup: true
        });
        cooInstNm.on('blur', function(e) {
        	cooInstNm2.setValue(cooInstNm2.getValue().trim());
        });
        cooInstNm.on('popup', function(e){
        	//dataSet.setNameValue(0, "cooInstCd" , '');
			//cooInstNm2.setValue('');
        	openOutsideSpecialistDialog(setOutsideSpecialistInfo);
        });

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
	    		tabContent1.$('object').css('visibility', 'visible');
	    	}catch(e){}
	    });
	    outsideSpecialistSearchDialog.on('submit', function(e) {
	    	try{
	    		tabContent1.$('object').css('visibility', 'visible');
	    	}catch(e){}
	    });
	    outsideSpecialistSearchDialog.on('show', function(e) {
	    	try{
	    		tabContent1.$('object').css('visibility', 'hidden');
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

	    //과제리더 팝업 셋팅
	    setLeaderInfo = function(userInfo) {
	        dataSet.setNameValue(0, "saSabunNew", userInfo.saSabun);
	        dataSet.setNameValue(0, "saUserName", userInfo.saName);
	    }
	    //프로젝트 팝업 셋팅
	    setPrjInfo = function(prjInfo) {
	        dataSet.setNameValue(0, "deptCode"  , prjInfo.upDeptCd);
	        dataSet.setNameValue(0, "deptName"  , prjInfo.upDeptName);
	        dataSet.setNameValue(0, "prjCd"     , prjInfo.prjCd);
	        dataSet.setNameValue(0, "prjNm"     , prjInfo.prjNm);
	        dataSet.setNameValue(0, "saSabunNew", prjInfo.plEmpNo);   //과제리더사번
	        dataSet.setNameValue(0, "saUserName", prjInfo.plEmpName); //과제리더명
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

        //Form 비활성화 여부
        disableFields = function() {

            //버튼여부
            btnCsusRq.hide();
//            btnInnerCsusRq.hide();

            var pTssRoleId = stringNullChk(dataSet.getNameValue(0, "tssRoleId"));

            //조건에 따른 보이기
//             if(pTssRoleId != "TR05" && pTssRoleId != "") {
	        if("TR01" == dataSet.getNameValue(0, "tssRoleId") || "${inputData._userSabun}" == dataSet.getNameValue(0, "pgSaSabunNew")) {
	            if(gvTssSt == "100" || gvTssSt == "102" ) {
	            	btnCsusRq.show(); 		//GRS - 100:작성중
//	            	btnInnerCsusRq.show();
	            }
            }

//             prjNm.disable();
//             deptName.disable();
//             ppslMbdNm.disable();
//             bizDptNm.disable();
//             tssNm.disable();
//             saUserName.disable();
//             tssAttrNm.disable();
//             tssStrtDd.disable();
//             tssFnhDd.disable();

//             Rui.select('.tssLableCss input').addClass('L-tssLable');
//             Rui.select('.tssLableCss div').addClass('L-tssLable');
//             Rui.select('.tssLableCss div').removeClass('L-disabled');
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
                { id: 'tssCd' }          // 과제코드
              , { id: 'userId' }         // 로그인ID
              , { id: 'prjCd' }          // 프로젝트코드
              , { id: 'prjNm' }          // 프로젝트명
              , { id: 'pgsStepCd' }      // 진행단계코드
              , { id: 'tssScnCd' }       // 과제구분코드
              , { id: 'wbsCd' }          // WBS코드
              , { id: 'pkWbsCd' }        // WBS코드(PK)
              , { id: 'tssNm' }          // 과제명
              , { id: 'saSabunNew' }     // 과제리더사번
              , { id: 'tssAttrCd' }      // 과제속성코드
              , { id: 'tssStrtDd' }      // 과제시작일
              , { id: 'tssFnhDd' }       // 과제종료일
              , { id: 'cmplBStrtDd' }    // 완료전시작일
              , { id: 'cmplBFnhDd' }     // 완료전종료일
              , { id: 'tssSt' }          // 과제상태
              , { id: 'saUserName' }     // 과제리더명
              , { id: 'deptName' }       // 조직(소속)명
              , { id: 'pgsStepNm' }      // 진행단계명
              , { id: 'ppslMbdNm' }      // 발의주체명
              , { id: 'bizDptNm' }       // 과제유형명
              , { id: 'tssAttrNm' }      // 과제속성명
              , { id: 'pgTssCd' }        // 진행과제코드
              , { id: 'mbrCnt' }
              , { id: 'ttsDifMonth'}     // 과제소요기간
              , { id: 'cooInstNm'}       // 협력기관명
              , { id: 'deptCode'}
              , { id: 'ppslMbdCd'}
              , { id: 'bizDptCd'}
              , { id: 'cooInstCd'}
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
            gvWbsCd = dataSet.getNameValue(0, "pkWbsCd");
            var pPgsStepCd = dataSet.getNameValue(0, "pgsStepCd");

            //PG:진행단계
            if(pPgsStepCd == "PG") {
                gvTssCd = "";                                                  //과제코드
                gvTssSt = "";                                                  //과제상태
                gvPgTssCd = stringNullChk(dataSet.getNameValue(0, "pgTssCd")); //진행단계 과제코드
            }
            //AL:변경단계
            else if(pPgsStepCd == "AL") {
                gvTssCd = stringNullChk(dataSet.getNameValue(0, "tssCd"));     //과제코드
                gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt"));     //과제상태
                gvPgTssCd = stringNullChk(dataSet.getNameValue(0, "pgTssCd")); //진행단계 과제코드
                lvWbsCd = stringNullChk(dataSet.getNameValue(0, "wbsCd")); //진행단계 과제코드
            }

            disableFields();

            Rui.get('tabContent0').hide();
            Rui.get('tabContent1').hide();
            tabView.selectTab(tabInx);
        });

        //폼에 출력
        var bind1 = new Rui.data.LBind({
            groupId: 'mstFormDiv1',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
              { id: 'prjNm',       ctrlId: 'prjNm1',       value: 'html' }
            , { id: 'deptName',    ctrlId: 'deptName1',    value: 'html' }
            , { id: 'wbsCd',       ctrlId: 'wbsCd1',       value: 'html' }
            , { id: 'tssNm',       ctrlId: 'tssNm1',       value: 'html' }
            , { id: 'saUserName',  ctrlId: 'saUserName1',  value: 'html' }
            , { id: 'tssStrtDd',   ctrlId: 'tssStrtDd1',   value: 'html' }
            , { id: 'tssFnhDd',    ctrlId: 'tssFnhDd1',    value: 'html' }
            , { id: 'cooInstNm',   ctrlId: 'cooInstNm1',   value: 'html' }  /*협력기관명*/
            , { id: 'bizDptNm',    ctrlId: 'bizDptNm1',    value: 'html' }  /*과제유형명*/
            , { id: 'mbrCnt',      ctrlId: 'mbrCnt1',      value: 'html' }  /*참여인원*/
            , { id: 'ttsDifMonth', ctrlId: 'ttsDifMonth1', value: 'html'}   /*과제소요기간*/
            , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'html' }				//과제 단계명
            , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'html' }				// GRS 단계명
            // , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'html' }		//Qgate 단계명

	        ]
	    });

        var bind2 = new Rui.data.LBind({
            groupId: 'mstFormDiv2',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',      ctrlId: 'tssCd2',      value: 'value' }
                , { id: 'prjCd',      ctrlId: 'prjCd2',      value: 'value' }
                , { id: 'prjNm',      ctrlId: 'prjNm2',      value: 'value' }
                , { id: 'deptCode',   ctrlId: 'deptCode2',   value: 'value' }
                , { id: 'deptName',   ctrlId: 'deptName2',   value: 'value' }
                , { id: 'ppslMbdCd',  ctrlId: 'ppslMbdCd2',  value: 'value' }
                , { id: 'bizDptCd',   ctrlId: 'bizDptCd2',   value: 'value' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd2',      value: 'value' }
                , { id: 'tssNm',      ctrlId: 'tssNm2',      value: 'value' }
                , { id: 'saSabunNew', ctrlId: 'saSabunNew2', value: 'value' }
                , { id: 'saUserName', ctrlId: 'saUserName2', value: 'value' }
                , { id: 'tssAttrCd',  ctrlId: 'tssAttrCd2',  value: 'value' }
                , { id: 'tssStrtDd',  ctrlId: 'tssStrtDd2',  value: 'value' }
                , { id: 'tssFnhDd',   ctrlId: 'tssFnhDd2',   value: 'value' }
                , { id: 'userId',     ctrlId: 'userId2',     value: 'value' }
                , { id: 'cooInstCd',  ctrlId: 'cooInstCd2',  value: 'value' } /*협력기관코드*/
                , { id: 'cooInstNm',  ctrlId: 'cooInstNm2',  value: 'value' } /*협력기관명*/
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

        //서버전송용
        var dm2 = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm2.on('success', function(e) {
            var data = dataSet.getReadData(e);
            alert(data.records[0].rtVal);

            fnSearch();	// 재조회
        });

        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: '변경개요'       , content: '<div id="div-content-test0"></div>' },
                { label: '개요'           , content: '<div id="div-content-test1"></div>' },
                { label: '참여연구원'     , content: '<div id="div-content-test2"></div>' },
                { label: '비용지급실적'   , content: '<div id="div-content-test3"></div>' },
                { label: '목표 및 산출물' , content: '<div id="div-content-test4"></div>' },
                { label: '변경이력'       , content: '<div id="div-content-test5"></div>' }
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
            for(var i = 0; i < 6; i++) {
                if(i == e.activeIndex) {
                    Rui.get('tabContent' + i).show();
                } else {
                    Rui.get('tabContent' + i).hide();
                }

                if(e.activeIndex == 1){
                	Rui.get("mstFormDiv1").hide();
                	Rui.get("mstFormDiv2").show();
                }else{
                	Rui.get("mstFormDiv1").show();
                	Rui.get("mstFormDiv2").hide();
                }
            }

            var tabUrl = "";

            switch(e.activeIndex) {
            //변경개요
            case 0:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                }
                break;
            //개요
            case 1:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrSmryIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                break;
            //참여연구원
            case 2:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "&wbsCd="+lvWbsCd+"'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                break;
            //비용지급실적
            case 3:
                if(e.isFirst) {
                	tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssCmplExpStoaIfm.do?wbsCd=" + lvWbsCd +"'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent3');
                }
                break;
            //목표 및 산출물
            case 4:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent4');
                }
                break;
            //변경이력
            case 5:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsAltrHistIfm.do?pkWbsCd=" + gvWbsCd + "'/>";
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
        //품의서요청
        btnCsusRq = new Rui.ui.LButton('btnCsusRq');
        btnCsusRq.on('click', function() {
            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate();
            if(!ifmUpdate) return false;

            if( confirm("품의서요청을 하시겠습니까?") == true ){
            	nwinsActSubmit(document.mstForm1, "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrCsusRq.do?tssCd="+gvTssCd+"&wbsCd="+lvWbsCd+"&userId="+gvUserId+"&innerCsusRqYn=Y'/>");
            }
        });

//       	//내부 품의서요청
//        btnInnerCsusRq = new Rui.ui.LButton('btnInnerCsusRq');
//        btnInnerCsusRq.on('click', function() {
//            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate();
//            if(!ifmUpdate) return false;
//
//            if( confirm("내부 품의서요청을 하시겠습니까?") == true ){
//            	nwinsActSubmit(document.mstForm1, "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrCsusRq.do?tssCd="+gvTssCd+"&userId="+gvUserId+"&innerCsusRqYn=Y' />" );
//            }
//        });

        //저장(신규 + 변경개요)
        fnSave1 = function() {
            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");
            if(!ifmUpdate) return false;

            if( confirm("저장하시겠습니까?") == true ){
                var smryDs = document.getElementById('tabContent0').contentWindow.dataSet1; //개요탭 DS
                var altrDs = document.getElementById('tabContent0').contentWindow.dataSet2; //개요탭 DS

                dataSet.setNameValue(0, "pgsStepCd" , "AL");      //진행단계: AL(변경)
                dataSet.setNameValue(0, "tssScnCd"  , "O");       //과제구분: O(대외협력)
                dataSet.setNameValue(0, "tssSt"     , "100");     //과제상태: 100(작성중)
                dataSet.setNameValue(0, "tssCd"     , gvTssCd);   //과제코드
                dataSet.setNameValue(0, "userId"    , gvUserId);  //사용자ID

                smryDs.setNameValue(0, "tssCd"      , gvTssCd);   //과제코드
                smryDs.setNameValue(0, "userId"     , gvUserId);  //사용자ID

                tabInx = 0;

                //신규(기존데이터 복사)
                if(gvTssCd == "") {
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/ousdcoo/insertOusdCooTssAltrMst.do"/>',
                        dataSets:[dataSet, smryDs, altrDs]
                    });
                }
                //수정(변경개요)
                else {
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssAltrSmry.do"/>',
                        dataSets:[dataSet, smryDs, altrDs]
                    });
                }
            }
        };

        //저장(마스터 + 일반개요 수정)
        fnSave2 = function() {
        	// 달력 blur
        	tssStrtDd.blur();
        	tssFnhDd.blur();

        	var smryDs       = document.getElementById('tabContent1').contentWindow.dataSet;            //개요탭 DS

            if( confirm("저장하시겠습니까?") == true ){
            	dataSet.setNameValue(0, "tssCd"     , gvTssCd);   //과제코드
                dataSet.setNameValue(0, "userId"    , gvUserId);  //사용자ID

                smryDs.setNameValue(0, "tssCd"      , gvTssCd);   //과제코드
                smryDs.setNameValue(0, "userId"     , gvUserId);  //사용자ID

                tabInx = 1;

                if(gvTssCd == "") {
                	return false;
                }
                //수정(마스터 + 일반개요 수정)
                else {
                    dm2.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssAltrMst.do"/>',
                        dataSets:[dataSet, smryDs]
                    });
                }
            }
        };

        /* 마스터 조회 */
        fnSearch = function() {
            dataSet.load({
                url: '<c:url value="/prj/tss/ousdcoo/retrieveOusdCooTssAltrMst.do"/>'
              , params : { tssCd : gvTssCd }	//과제코드
            });
        };

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

        disableFields();
        Rui.get("mstFormDiv2").hide();

        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnCsusRq").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnCsusRq").hide();
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
	<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
</form>
    <Tag:saymessage />
    <div class="contents">
<%--         <%@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>
	    <div class="titleArea">
			<h2>대외협력과제 &gt;&gt;변경</h2>
	    </div>

        <form name="mstForm" id="mstForm" method="post"></form><%-- 목록이동용 --%>

        <div class="sub-content">
            <div class="titArea">
                <div class="LblockButton">
                	<!-- <button type="button" id="btnInnerCsusRq" name="btnInnerCsusRq">내부 품의서요청</button> --><!-- 대외협력과제는 내부품의 없음 => 제거 -->
                    <button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
            <div id="mstFormDiv1">
                <form name="mstForm1" id="mstForm1" method="post">
                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 19%;" />
                                <col style="width: 36%;" />
                                <col style="width: 16.5%;" />
                                <col style="" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">프로젝트명</th>
                                    <td>
                                        <span id="prjNm1"></span>
                                    </td>
                                    <th align="right">조직</th>
                                    <td>
                                        <span id="deptName1"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td>
                                        <span id="bizDptNm1"></span>
                                    </td>
                                    <th align="right">연구책임자</th>
                                    <td>
                                        <span id="saUserName1"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">WBSCode / 과제명</th>
                                    <td colspan="3">
                                     	<span id="wbsCd1"></span>&#32;&#47;&#32;
                                        <span id="tssNm1"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">협력기관(기관명/소속/성명)</th>
                                    <td>
                                        <span id="cooInstNm1"></span>
                                    </td>
                                    <th align="right">과제기간</th>
                                    <td>
                                        <span id="tssStrtDd1"></span> ~
                                        <span id="tssFnhDd1"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">개발인원</th>
                                    <td>
                                        <span id="mbrCnt1"></span>
                                    </td>
                                    <th align="right">소요기간</th>
                                    <td>
                                        <span id="ttsDifMonth1"></span> 개월
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </fieldset>
                </form>
            </div>
            <div id="mstFormDiv2">
                <form name="mstForm2" id="mstForm2" method="post">
                    <input type="hidden" id="tssCd2"      name="tssCd2"      value=""> <!-- 과제코드 -->
                    <input type="hidden" id="userId2"     name="userId2"     value=""> <!-- 사용자ID -->
                    <input type="hidden" id="prjCd2"      name="prjCd2"      value=""> <!-- 프로젝트코드 -->
                    <input type="hidden" id="deptCode2"   name="deptCode2"   value=""> <!-- 조직코드 -->
                    <input type="hidden" id="saSabunNew2" name="saSabunNew2" value=""> <!-- 과제리더사번 -->
                    <input type="hidden" id="cooInstCd2"  name="cooInstCd2"  value=""> <!-- 협력기관코드 -->

                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 15%;" />
                                <col style="width: 35%;" />
                                <col style="width: 15%;" />
                                <col style="width: 35%;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">프로젝트명</th>
                                    <td>
                                        <input type="text" id="prjNm2" value="">
                                    </td>
                                    <th align="right">조직</th>
                                    <td>
                                        <input type="text" id="deptName2" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">WBSCode / 과제명</th>
                                    <td colspan="3">
                                     	<input type="text" id="wbsCd2" value=""> / <input type="text" id="tssNm2" value="">
                                    </td>
                                </tr>
                                <tr>
                                	<th align="right">과제리더</th>
                                    <td>
                                        <div id="saUserName2"></div>
                                    </td>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td>
                                        <div id="bizDptCd2"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">협력기관(기관명/소속/성명)</th>
                                    <td>
                                        <input type="text" id="cooInstNm2" value="">
                                    </td>
                                    <th align="right">과제기간</th>
                                    <td>
                                        <input type="text" id="tssStrtDd2" value="" /><em class="gab"> ~ </em>
                                        <input type="text" id="tssFnhDd2" value="" />
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
                <iframe name="tabContent0" id="tabContent0" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent1" id="tabContent1" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent2" id="tabContent2" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent3" id="tabContent3" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent4" id="tabContent4" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
                <iframe name="tabContent5" id="tabContent5" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
            </form>
        </div>
    </div>

</body>
</html>