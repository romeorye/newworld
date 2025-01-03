<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssCmplDetail.jsp
 * @desc    : 대외협력과제 > 완료 상세 상단 탭 화면
              진행-GRS(완료) or 완료상태인 경우 진입
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.21  IRIS04		최초생성
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
    var gvTssSt     = "";
    var gvPgsStepCd = "CM"; //진행상태:CM(완료)
    var gvWbsCd     = "";
    var gvPageMode  = "";
    var lvWbsCd  = "";

    var cmplTssCd   = "";
    var dataSet;
    var rtnMsg = "${inputData.rtnMsg}";

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
        //과제유형
        bizDptNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizDptNm',
            editable: false,
            width: 150
        });

        //WBS코드
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            editable: false,
            width: 80
        });

        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            editable: false,
            width: 300
        });

        //과제리더
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            editable: false,
            width: 200
        });

        //
        cooInstNm = new Rui.ui.form.LTextBox({
            applyTo: 'cooInstNm',
            editable: false,
            width: 400
        });

        //
        ttsDifMonth = new Rui.ui.form.LTextBox({
            applyTo: 'ttsDifMonth',
            editable: false,
            width: 100
        });

        //
        mbrCnt = new Rui.ui.form.LTextBox({
            applyTo: 'mbrCnt',
            editable: false,
            width: 400
        });

/*         //과제속성
        tssAttrNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssAttrNm',
            width: 150
        }); */

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

            var pTssRoleId = stringNullChk(dataSet.getNameValue(0, "tssRoleId"));

            //조건에 따른 보이기
            if(pTssRoleId != "TR05" && pTssRoleId != "") {
                if(gvTssSt == "100") btnCsusRq.show(); //GRS - 100:작성중
            }

            prjNm.disable();
            deptName.disable();

            tssNm.disable();
            saUserName.disable();
            tssStrtDd.disable();
            tssFnhDd.disable();

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
                , { id: 'pkWbsCd' }        //WBS코드(PK)
                , { id: 'tssNm' }          //과제명
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
                , { id: 'cooInstNm' }        //
                , { id: 'ttsDifMonth' }        //
                , { id: 'mbrCnt' }        //
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
            lvWbsCd = dataSet.getNameValue(0, "wbsCd");
            var pPgsStepCd = dataSet.getNameValue(0, "pgsStepCd");

            document.tabForm.tssSt.value = dataSet.getNameValue(0, "tssSt");
            document.tabForm.pgsStepCd.value = dataSet.getNameValue(0, "pgsStepCd");


            //PG:진행단계
            if(pPgsStepCd == "PG") {
                cmplTssCd = "";  //완료단계 과제코드
                gvTssCd = stringNullChk(dataSet.getNameValue(0, "pgTssCd")); //진행단계 과제코드
                gvTssSt = ""; //과제상태
            }
            //CM:완료단계
            else if(pPgsStepCd == "CM") {
                cmplTssCd = dataSet.getNameValue(0, "tssCd"); //완료단계 과제코드
                gvTssCd = stringNullChk(dataSet.getNameValue(0, "pgTssCd")); //진행단계 과제코드
                gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt")); //과제상태
            }

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
                , { id: 'deptName',    ctrlId: 'deptName',    value: 'value' }
//                , { id: 'ppslMbdNm',   ctrlId: 'ppslMbdNm',   value: 'value' }
                , { id: 'bizDptNm',    ctrlId: 'bizDptNm',    value: 'value' }
                , { id: 'wbsCd',       ctrlId: 'wbsCd',       value: 'value' }
                , { id: 'tssNm',       ctrlId: 'tssNm',       value: 'value' }
                , { id: 'saUserName',  ctrlId: 'saUserName',  value: 'value' }
                , { id: 'cooInstNm',  ctrlId: 'cooInstNm',  value: 'value' }
                , { id: 'ttsDifMonth',  ctrlId: 'ttsDifMonth',  value: 'value' }
                , { id: 'mbrCnt',  ctrlId: 'mbrCnt',  value: 'value' }
//                , { id: 'tssAttrNm',   ctrlId: 'tssAttrNm',   value: 'value' }
                , { id: 'tssStrtDd',   ctrlId: 'tssStrtDd',   value: 'value' }
                , { id: 'tssFnhDd',    ctrlId: 'tssFnhDd',    value: 'value' }
                , { id: 'cmplBStrtDd', ctrlId: 'cmplBStrtDd', value: 'value' }
                , { id: 'cmplBFnhDd',  ctrlId: 'cmplBFnhDd',  value: 'value' }
                , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'html' }				//과제 단계명
                , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'html' }				// GRS 단계명
                // , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'html' }		//Qgate 단계명
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
            }
        });

        /*============================================================================
        =================================      Tab       =============================
        ============================================================================*/
        var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { label: '완료'           , content: '<div id="div-content-test0"></div>' },
                { label: '개요'           , content: '<div id="div-content-test1"></div>' },
                { label: '참여연구원'     , content: '<div id="div-content-test2"></div>' },
                { label: '비용지급실적'   , content: '<div id="div-content-test3"></div>' },
                { label: '목표 및 산출물' , content: '<div id="div-content-test4"></div>' },
                { label: '변경이력'       , content: '<div id="div-content-test5"></div>' }
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
            //완료
            case 0:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssCmplSmryIfm.do?tssCd=" + cmplTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                }
                break;
            //개요
            case 1:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsSmryIfm.do?tssCd=" + gvTssCd + "'/>";
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                }
                break;
            //참여연구원
            case 2:
                if(e.isFirst) {
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsPtcRsstMbrIfm.do?tssCd=" + gvTssCd + "&wbsCd="+ lvWbsCd +"'/>";
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
                    tabUrl = "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsGoalYldIfm.do?tssCd=" + gvTssCd + "'/>";
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
            if(!vm.validateGroup("mstForm")) {
                 Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                 return;
            }

			var chkNum =   document.getElementById('tabContent0').contentWindow.fnAttchValid();  
			
        	if(chkNum == 0){
        		Rui.alert("평가 결과서 첨부파일을 추가하셔야 합니다.");
        		return;
        	}
        	
            if(dataSet.isUpdated()) {
                Rui.alert("완료탭 저장을 먼저 해주시기 바랍니다.");
                return false;
            }

            Rui.confirm({
                text: '품의서요청을 하시겠습니까?',
                handlerYes: function() {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssCmplCsusRq.do'/>" + "?tssCd="+cmplTssCd+"&wbsCd="+lvWbsCd+"&userId="+gvUserId+"&pgTssCd="+gvTssCd);
                },
                handlerNo: Rui.emptyFn
            });
        });

        //저장
        fnSave = function() {
            if(!vm.validateGroup("mstForm")) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    var smryDs = document.getElementById('tabContent0').contentWindow.dataSet; //개요탭 DS

                    dataSet.setNameValue(0, "pgsStepCd", "CM");   //진행단계: CM(완료)
                    dataSet.setNameValue(0, "tssScnCd", "O");     //과제구분: O(대외협력)
                    dataSet.setNameValue(0, "tssSt", "100");      //과제상태: 100(작성중)
                    dataSet.setNameValue(0, "tssCd",  cmplTssCd); //과제코드
                    dataSet.setNameValue(0, "userId", gvUserId);  //사용자ID

                    smryDs.setNameValue(0, "tssCd"   , cmplTssCd);  //과제코드
                    smryDs.setNameValue(0, "userId"  , gvUserId);   //사용자ID

                    //신규
                    if(cmplTssCd == "") {
                        dm.updateDataSet({
                            modifiedOnly: false,
                            url:'<c:url value="/prj/tss/ousdcoo/insertOusdCooTssCmplMst.do"/>',
                            dataSets:[dataSet, smryDs]
                        });
                    }
                    //수정
                    else {
                        dm.updateDataSet({
                            modifiedOnly: false,
                            url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssCmplMst.do"/>',
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

            nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
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
    <Tag:saymessage /><%--<!--  sayMessage 사용시 필요 -->--%>

    <div class="contents">
<%--         <%@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>
		<div class="titleArea">
			<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>대외협력과제 &gt;&gt;완료</h2>
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
                                <col style="width: 19%" />
                                <col style="width: 34%" />
                                <col style="width: 15.5%" />
                                <col style="" />
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
                                    <td  class="tssLableCss" colspan="3">
                                    	<input type="text" id="wbsCd" />&nbsp;&#47;&nbsp;
                                        <input type="text" id="tssNm" />
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
                                	<th align="right">협력기관(기관명/소속/성명)</th>
                                    <td class="tssLableCss space_tain" colspan="3">
                                        <input type="text" id="cooInstNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">개발인원</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="mbrCnt" />
                                    </td>
                                    <th align="right">소요기간</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="ttsDifMonth" /> 개월
                                    </td>
                                </tr>
                                <tr>
                                    <!-- <th align="right">완료전 개발기간</th> -->
                                    <th align="right">계획(개발계획시점)</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="tssStrtDd" value="" /> ~ </em>
                                        <input type="text" id="tssFnhDd" value="" />
                                    </td>
                                    <!-- <th align="right">완료후 개발기간</th> -->
                                    <th align="right">실적(개발완료시점)</th>
                                    <td>
                                        <input type="text" id="cmplBStrtDd" value="" /><em class="gab"> ~ </em>
                                        <input type="text" id="cmplBFnhDd" value="" />
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
            	<input type="hidden" id="tssSt" name="tssSt" value=""/>
            	<input type="hidden" id="pgsStepCd" name="pgsStepCd" value=""/>
                <iframe name="tabContent0" id="tabContent0" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent1" id="tabContent1" scrolling="no" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent2" id="tabContent2" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent3" id="tabContent3" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent4" id="tabContent4" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
                <iframe name="tabContent5" id="tabContent5" scrolling="auto" width="100%" height="100%" frameborder="0" ></iframe>
            </form>
        </div>
    </div>

</body>
</html>