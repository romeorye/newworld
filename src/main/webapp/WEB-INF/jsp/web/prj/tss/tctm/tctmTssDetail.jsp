<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ page import="iris.web.prj.tss.tctm.TctmUrl" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : tctmTssDetail.jsp
 * @desc    : 기술팀 과제 상세
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
    var pgsStepCd ="";
    var dataSet;

    // // 프로젝트명
    // var prjNm;
    // // 조직명
    // var deptName;
    // //발의주체
    // var ppslMbdCd;
    // //사업부문(Funding기준)
    // var bizDptCd;
    // //wbsCd
    // var wbsCd;
    // //과제명
    // var tssNm;
    // //과제리더
    // var saSabunName;
    // //과제 속성
    // var tssAttrCd;
    //  // 과제기간 시작일
    // var tssStrtDd;
    // // 과제기간 종료일
    // var tssFnhDd;
    // // 변경이력 상세 Dialog
    // var altrHistDialog;

    Rui.onReady(function() {
        var isInsert = false;
        var form = new Rui.ui.form.LForm('mstForm');
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        prjNm.on('popup', function(e){
            openPrjSearchDialog(setPrjInfo,'');
        });


        ppslMbdCd.getDataSet().on('load', function(e) {
            console.log('ppslMbdCd :: load');
        });


        bizDptCd.getDataSet().on('load', function(e) {
            console.log('bizDptCd :: load');
        });


        saSabunName.on('popup', function(e){
            openUserSearchDialog(setLeaderInfo, 1, '');
        });
        // 공통 유저조회 Dialog
        _userSearchDialog.on('cancel', function (e) {
            try {
                tabContent0.$('object').css('visibility', 'visible');
            } catch (e) {
            }
        });
        _userSearchDialog.on('submit', function (e) {
            try {
                tabContent0.$('object').css('visibility', 'visible');
            } catch (e) {
            }
        });
        _userSearchDialog.on('show', function (e) {
            try {
                tabContent0.$('object').css('visibility', 'hidden');
            } catch (e) {
            }
        });


        tssAttrCd.getDataSet().on('load', function(e) {
            console.log('tssAttrCd :: load');
        });


        prodG.getDataSet().on('load', function(e) {
            console.log('prodG :: load');
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

            // if( !Rui.isEmpty(tssStrtDd.getValue()) && !Rui.isEmpty(tssFnhDd.getValue()) ){
            // 	document.getElementById('tabContent0').contentWindow.fncPtcCpsnYDisable(tssStrtDd.getValue(), tssFnhDd.getValue());
            // }
        });

        tssStrtDd.on('changed', function(){
            // if( !Rui.isEmpty(tssStrtDd.getValue()) && !Rui.isEmpty(tssFnhDd.getValue()) ){
            // 	document.getElementById('tabContent0').contentWindow.fncPtcCpsnYDisable(tssStrtDd.getValue(), tssFnhDd.getValue());
            // }
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
            // if( !Rui.isEmpty(tssStrtDd.getValue()) && !Rui.isEmpty(tssFnhDd.getValue()) ){
            // 	document.getElementById('tabContent0').contentWindow.fncPtcCpsnYDisable(tssStrtDd.getValue(), tssFnhDd.getValue());
            // }
        });

        tssFnhDd.on('changed', function(){
            // if( !Rui.isEmpty(tssStrtDd.getValue()) &&  !Rui.isEmpty(tssFnhDd.getValue()) ){
            // 	document.getElementById('tabContent0').contentWindow.fncPtcCpsnYDisable(tssStrtDd.getValue(), tssFnhDd.getValue());
            // }
        });


        rsstSphe.getDataSet().on('load', function(e) {
            console.log('rsstSphe :: load');
        });



        tssType.getDataSet().on('load', function(e) {
            console.log('tssType :: load');
        });



        //form 비활성화 여부
        var disableFields = function(disable) {
            //버튼
            btnDelRq.hide();
            btnGrsRq.hide();
            btnCsusRq.hide();

            //form
            prjNm.setEditable(false);
            deptName.setEditable(false);
            // wbsCd.setEditable(false);

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
	            }else if(gvTssSt == "102"){
	            	btnCsusRq.show();
	            }
	        }

            if("TR01" == gvRoleId) {
	            $('#prjNm > a').attr('style', "display:block;");
	            $('#prjNm').attr('style', "border-color:;");
            }
/*임시 주석

            var objs = [prjNm, deptName, ppslMbdCd, bizDptCd, wbsCd, tssNm, saSabunName, tssAttrCd, tssStrtDd, tssFnhDd, prodG, rsstSphe, tssType];
            for (var i = 0; i < objs.length; i++) {
                if (disable) {
                    objs[i].disable();
                } else {
                    objs[i].enable();
                }
            }
*/


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
                {id: 'tssCd'}      //과제코드
                ,{id: 'plTssCd'}  //계획 과제코드
                ,{id: 'pgTssCd'}  //진행 과제코드
                ,{id: 'alTssCd'}  //변경 과제코드
                , {id: 'userId'}     //로그인ID
                , {id: 'prjCd'}      //프로젝트코드
                , {id: 'prjNm'}      //프로젝트명
                , {id: 'deptCode'}   //조직코드
                , {id: 'deptName'}   //조직명
                , {id: 'ppslMbdCd'}  //발의주체
                , {id: 'bizDptCd'}   //사업부문(Funding기준)
                , {id: 'wbsCd'}      //WBSCode
                , {id: 'pkWbsCd'}    //WBSCode
                , {id: 'tssNm'}      //과제명
                , {id: 'saSabunNew'} //과제리더사번
                , {id: 'saSabunName'} //과제리더명
                , {id: 'tssAttrCd'}  //과제속성
                , {id: 'tssStrtDd'}  //과제기간S
                , {id: 'tssFnhDd'}   //과제기간E
                , {id: 'pgsStepNm'}  //진행단계명
                , {id: 'tssSt'}      //과제상태
                , {id: 'pgsStepCd'}  //진행단계
                , {id: 'tssScnCd'}   //과제구분
                , {id: 'prodG'}      //제품군
                , {id: 'rsstSphe'}      //연구분야
                , {id: 'tssType'}      //유형
                , {id: 'tssRoleType'}
                , {id: 'tssRoleId'}
                , {id: 'custSqlt'}
                , {id: 'tssSmryTxt'}
            ]
        });

        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                { id: 'tssCd',      ctrlId: 'tsscCd',      value: 'value' }
                , { id: 'prjCd',      ctrlId: 'prjCd',      value: 'value' }
                , { id: 'prjNm',      ctrlId: 'prjNm',      value: 'value' }
                , { id: 'deptCode',   ctrlId: 'deptCode',   value: 'value' }
                , { id: 'deptName',   ctrlId: 'deptName',   value: 'value' }
                , { id: 'ppslMbdCd',  ctrlId: 'ppslMbdCd',  value: 'value' }
                , { id: 'bizDptCd',   ctrlId: 'bizDptCd',   value: 'value' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }
                , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'value' }
                , { id: 'saSabunNew', ctrlId: 'saSabunNew', value: 'value' }
                , { id: 'saSabunName', ctrlId: 'saSabunName', value: 'value' }
                , { id: 'tssAttrCd',  ctrlId: 'tssAttrCd',  value: 'value' }
                , { id: 'tssStrtDd',  ctrlId: 'tssStrtDd',  value: 'value' }
                , { id: 'tssFnhDd',   ctrlId: 'tssFnhDd',   value: 'value' }
                , { id: 'userId',     ctrlId: 'userId',     value: 'value' }
                , { id: 'prodG',    ctrlId: 'prodG',    value: 'value' }
                , { id: 'rsstSphe',   ctrlId: 'rsstSphe',   value: 'value' }
                , { id: 'tssType',    ctrlId: 'tssType',    value: 'value' }
                , { id: 'custSqlt',    ctrlId: 'custSqlt',    value: 'value' }
                , { id: 'tssSmryTxt',    ctrlId: 'tssSmryTxt',    value: 'value' }
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
                , { id: 'saSabunName',  validExp: '과제리더명:true' }
                , { id: 'tssAttrCd',   validExp: '과제속성:true' }
                , { id: 'tssStrtDd',   validExp: '과제기간 시작일:true' }
                , { id: 'tssFnhDd',    validExp: '과제기간 종료일:true' }
                , { id: 'pgsStepNm',   validExp: '진행단계명:false' }
                , { id: 'tssSt',       validExp: '과제상태:false' }
                , { id: 'pgsStepCd',   validExp: '진행단계:false' }
                , { id: 'tssScnCd',    validExp: '과제구분:false' }
                , { id: 'prodG',     validExp: '제품군:true' }
                , { id: 'rsstSphe',    validExp: '연구분야:true' }
                , { id: 'tssType',     validExp: '유형:true' }
            ]
        });


        dataSet.on('load', function(e) {
            gvTssCd = stringNullChk(dataSet.getNameValue(0, "tssCd"));
            gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt"));
            gvPageMode = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
            gvRoleId = stringNullChk(dataSet.getNameValue(0, "tssRoleId"));

            pgsStepCd = stringNullChk(dataSet.getNameValue(0, "pgsStepCd"));
            pgsStepNm  = stringNullChk(dataSet.getNameValue(0, "pgsStepNm"));

            if(pgsStepNm==""){
            	$("#stepNm").html("계획");
			}else{
                $("#stepNm").html(pgsStepNm);
			}

            //최초 로그인사용자 정보 셋팅
            if(gvTssCd == "") {
                dataSet.setNameValue(0, "prjCd", "${userMap.prjCd}");          //프로젝트코드
                dataSet.setNameValue(0, "prjNm", "${userMap.prjNm}");          //프로젝트명
                dataSet.setNameValue(0, "deptCode", "${userMap.upDeptCd}");    //조직코드
                dataSet.setNameValue(0, "deptName", "${userMap.upDeptName}");  //조직명
                dataSet.setNameValue(0, "saSabunNew", "${inputData._userSabun}"); //과제리더사번
                dataSet.setNameValue(0, "saSabunName", "${inputData._userNm}");    //과제리더명
/* 임시 주석

                if(stringNullChk("${userMap.prjCd}") == "") {
                    alert("프로젝트 등록을 먼저 해주시기 바랍니다.");
                }
*/

            }

            // if(stringNullChk(dataSet.getNameValue(0, "wbsCd")) != "") {
            //     document.getElementById("seed").innerHTML = "SEED-";
            // } else {
            //     document.getElementById("seed").innerHTML = "";
            // }

            disableFields();

            tabView.selectTab(0);
            <%--nwinsActSubmit(document.tabForm, "<%=request.getContextPath()+TctmUrl.doTabSum%>?tssCd="+gvTssCd, 'tabContent1');--%>
            nwinsActSubmit(document.tabForm, "<%=request.getContextPath()+TctmUrl.doTabAltr%>?tssCd="+gvTssCd, 'tabContent0');

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
                { label: '산출물', content: '<div id="div-content-test2"></div>' },
                { label: '변경이력', content: '<div id="div-content-test3"></div>' }
            ]
        });

        tabView.on('activeTabChange', function(e) {
            // iframe 숨기기

            for(var i = 0; i < $("#tabForm").children().length; i++) {
                if(i == e.activeIndex) {
                    Rui.get('tabContent' + i).show();
                } else {
                    Rui.get('tabContent' + i).hide();
                }
            }
            var tabUrl = "";
            console.log("tabb Idx", e.activeIndex);
            switch(e.activeIndex) {
            //변경
            case 0:
                if(e.isFirst) {
                    tabUrl = "<%=request.getContextPath()+TctmUrl.doTabAltr%>?tssCd=" + gvTssCd + "&pgsStepCd="+dataSet.getNameValue(0, "pgsStepCd");
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent0');
                } else {
                    disableFields(false);
                }
                break;
            //개요
            case 1:
                if(e.isFirst) {
                    tabUrl = "<%=request.getContextPath()+TctmUrl.doTabSum%>?tssCd=" + gvTssCd + "&pgsStepCd="+dataSet.getNameValue(0, "pgsStepCd");
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent1');
                } else {
                    disableFields(false);
                }
                break;
            //목표 및 산출물
            case 2:
                if(e.isFirst) {
                    tabUrl = "<%=request.getContextPath()+TctmUrl.doTabGoal%>?tssCd=" + gvTssCd + "&pgsStepCd="+dataSet.getNameValue(0, "pgsStepCd");
                    nwinsActSubmit(document.tabForm, tabUrl, 'tabContent2');
                }
                disableFields(true);
                break;
            //변경 이력
            case 3:
                if(e.isFirst) {
                    tabUrl = "<%=request.getContextPath()+TctmUrl.doTabAltrHis%>?tssCd=" + gvTssCd + "&pgsStepCd="+dataSet.getNameValue(0, "pgsStepCd");
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
        //DB테이블 건수확인
        var regDm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        regDm.on('success', function(e) {
            var regCntMap = JSON.parse(e.responseText)[0].records[0];

            var errMsg = "";

            console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            console.log(regCntMap);
            //계획
            if (regCntMap.tctmSmryCnt > 0) {
                if (regCntMap.comYldCnt < 2) errMsg = "산출물을 입력해 주시기 바랍니다.";
            } else {
                errMsg = "개요를 입력해 주시기 바랍니다.";
            }

            if (errMsg == "") {
                if (regCntMap.gbn != "GRS") {		//GRS효청
                    if (regCntMap.gbn == "CSUS"){	//품의서 요청
                        nwinsActSubmit(document.mstForm, "<%=request.getContextPath()+TctmUrl.doCsusView%>" + "?tssCd=" + gvTssCd + "&userId=" + gvUserId + "&appCode=APP00332");
					}
                } else {
                    nwinsActSubmit(document.mstForm, "<c:url value='/prj/grs/grsEvRslt.do?tssCd="+gvTssCd+"&userId="+gvUserId+"'/>");
                }
            } else {
                alert(errMsg);
            }
        });


        //삭제
        btnDelRq = new Rui.ui.LButton('btnDelRq');
        btnDelRq.on('click', function() {
        	if(confirm("삭제를 하시겠습니까?")) {
        		dm.updateDataSet({
                    modifiedOnly: false,
                    <%--url:'<c:url value="/prj/tss/gen/deleteGenTssPlnMst.do"/>',--%>
                    url:'<%=request.getContextPath()+TctmUrl.doDeleteInfo%>',
                    dataSets:[dataSet],
                    params: {
                    	tssCd : gvTssCd
                    }
                });
        	}
        		dm.on('success', function(e) {

    	  	    	/*nwinsActSubmit(document.mstForm, "<%=request.getContextPath()+TctmUrl.doList%>");*/
    	  	    	location.href = "<%=request.getContextPath()+TctmUrl.doList%>";
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


        // 개요저장
        smrySave = function() {
            tssStrtDd.blur();
            tssFnhDd.blur();
/*	 임시주석

            if(!vm.validateGroup("mstForm")) {
                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                return;
            }
*/

/* 임시주석

            //개요탭 validation
            var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");
            if(!ifmUpdate) return false;
*/

            //수정여부
            var smryDs = document.getElementById('tabContent1').contentWindow.dataSet;                  //개요탭 DS
            // var smryIsUpdate = document.getElementById('tabContent0').contentWindow.fnEditorIsUpdate(); //개요탭 에디터 변경여부
/* 임시주석

            if(!dataSet.isUpdated() && !smryDs.isUpdated() && !smryIsUpdate) {
                alert("변경된 데이터가 없습니다.");
                return;
            }
*/

            // var pmisTxt = document.getElementById('tabContent0').contentWindow.smryForm.pmisTxt.value;
            var bizDpt = bizDptCd.getValue();
            var bizDptNm = bizDptCd.getDisplayValue();

            // if(  bizDpt == "07" || bizDpt == "08" || bizDpt == "09"  ){
            // 	var bizMsg =  bizDptNm+" 사업부문일경우 지적재산권 통보내용을 입력하셔야 합니다";
            //
            // 	if( Rui.isEmpty(pmisTxt)){
            // 		alert(bizMsg);
            // 		return;
            // 	}
            // }

            if(confirm("저장하시겠습니까?")) {
                dataSet.setNameValue(0, "pgsStepCd", "PL"); //진행단계: PL(계획)
                dataSet.setNameValue(0, "tssScnCd", "D");   //과제구분: G(기술팀)
                dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                dataSet.setNameValue(0, "tssCd",  gvTssCd);  //과제코드
                dataSet.setNameValue(0, "userId", gvUserId); //사용자ID

                smryDs.setNameValue(0, "tssCd",  gvTssCd);   //과제코드
                smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID

				dm.updateDataSet({
					modifiedOnly: false,
					url: '<%=request.getContextPath()+TctmUrl.doUpdateInfo%>',
					dataSets: [dataSet, smryDs],
					params: {
					}
				});

            }
        };

		/*변경개요 저장*/
        altrSave = function() {
            tssStrtDd.blur();
            tssFnhDd.blur();

            // if(!vm.validateGroup("mstForm")) {
            //     alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
            //     return;
            // }
            //
            // var ifmUpdate = document.getElementById('tabContent0').contentWindow.fnIfmIsUpdate("SAVE");
            // if(!ifmUpdate) return false;
            //
            // //수정여부
            var smryDs = document.getElementById('tabContent0').contentWindow.dataSet1; //개요탭 DS
            var altrDs = document.getElementById('tabContent0').contentWindow.dataSet2; //개요탭 DS
            // if(!dataSet.isUpdated() && !smryDs.isUpdated() && !altrDs.isUpdated()) {
            //     alert("변경된 데이터가 없습니다.");
            //     return;
            // }

            if(confirm('저장하시겠습니까?')) {
                 dataSet.setNameValue(0, "pgTssCd", gvTssCd);
                dataSet.setNameValue(0, "tssScnCd", "D");   //과제구분: D(일반)
                dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                dataSet.setNameValue(0, "tssCd",  gvTssCd);  //과제코드
                dataSet.setNameValue(0, "userId", gvUserId); //사용자ID
                dataSet.setNameValue(0, "tssRoleType", "W"); //화면권한
				
				console.log(dataSet);
                smryDs.setNameValue(0, "tssCd",  gvTssCd); //과제코드
                smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID
                dm.updateDataSet({
                    modifiedOnly: false,
                    url:'<%=contextPath+TctmUrl.doUpdateInfoAltr%>',
                    dataSets:[dataSet, smryDs, altrDs]
                });


/*
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
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/gen/updateGenTssAltrMst.do"/>',
                        dataSets:[dataSet, smryDs, altrDs]
                    });
                }
                */

            }
        }


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

   		//목록dbo.IRIS_TSS_MGMT_MST
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
			$('#searchForm > input[name=tssNm]').val(encodeURIComponent($('#searchForm > input[name=tssNm]').val()));
			$('#searchForm > input[name=saSabunName]').val(encodeURIComponent($('#searchForm > input[name=saSabunName]').val()));
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));

            nwinsActSubmit(document.searchForm, "<c:url value='/prj/tss/tctm/tctmTssList.do'/>");
        });

        //최초 데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("mst searchData1");
            dataSet.loadData(${result});
        }else {
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
    console.log(userInfo);
    dataSet.setNameValue(0, "saSabunNew", userInfo.saSabun);
    dataSet.setNameValue(0, "saSabunName", userInfo.saName);
}
//프로젝트 팝업 셋팅
function setPrjInfo(prjInfo) {
    console.log(prjInfo);
    dataSet.setNameValue(0, "deptCode", prjInfo.upDeptCd);
    dataSet.setNameValue(0, "deptName", prjInfo.upDeptName);
    dataSet.setNameValue(0, "prjCd", prjInfo.prjCd);
    dataSet.setNameValue(0, "prjNm", prjInfo.prjNm);
//     dataSet.setNameValue(0, "saSabunNew", prjInfo.plEmpNo);   //과제리더사번
//     dataSet.setNameValue(0, "saSabunName", prjInfo.plEmpName); //과제리더명
}

function fncGenTssAltrDetail(cd) {
	var params = "?tssCd="+cd;
	altrHistDialog.setUrl('<c:url value="/prj/tss/gen/genTssAltrDetailPopup.do"/>'+params);
	altrHistDialog.show();
}
</script>

</head>
<body>
<form name="searchForm" id="searchForm" method="post">
	<%--<input type="hidden" name="wbsCd" value="${inputData.wbsCd}"/>--%>
	<%--<input type="hidden" name="tssNm" value="${inputData.tssNm}"/>--%>
	<input type="hidden" name=saSabunName value="${inputData.saSabunName}"/>
	<input type="hidden" name="deptName" value="${inputData.deptName}"/>
	<input type="hidden" name="tssStrtDd" value="${inputData.tssStrtDd}"/>
	<input type="hidden" name="tssFnhDd" value="${inputData.tssFnhDd}"/>
	<input type="hidden" name="prjNm" value="${inputData.prjNm}"/>
	<input type="hidden" name="pgsStepCd" value="${inputData.pgsStepCd}"/>
	<input type="hidden" name="tssSt" value="${inputData.tssSt}"/>
</form>

<Tag:saymessage/>
<%--<!--  sayMessage 사용시 필요 -->--%>
<div class="contents">
	<div class="titleArea">
		<h2>기술팀과제 &gt;&gt; <h2 id="stepNm"></h2> </h2>
	</div>

	<div class="sub-content">
		<div class="titArea">
			<div class="LblockButton">
                <span>TSS_CD : ${inputData.tssCd} ....${inputData.pgsStepCd}</span>
				<button type="button" id="testBtn" name="testBtn" onclick="setTestCode()">Test입력</button>
				<button type="button" id="btnDelRq" name="btnDelRq">삭제</button>
				<button type="button" id="btnAltrRq" name="btnAltrRq">변경요청</button>
				<button type="button" id="btnGrsRq" name="btnGrsRq">GRS요청</button>
				<button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
				<button type="button" id="btnList" name="btnList">목록</button>
			</div>
		</div>
		<div id="mstFormDiv">
			<form name="mstForm" id="mstForm" method="post">
				<input type="hidden" id="tssCd" name="tssCd" value=""> <!-- 과제코드 -->
				<input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
				<input type="hidden" id="prjCd" name="prjCd" value=""> <!-- 프로젝트코드 -->
				<input type="hidden" id="deptCode" name="deptCode" value=""> <!-- 조직코드 -->
				<input type="hidden" id="saSabunNew" name="saSabunNew" value=""> <!-- 과제리더사번 -->

				<fieldset>
					<table class="table table_txt_right">
						<colgroup>
							<col style="width: 12%;"/>
							<col style="width: 38%;"/>
							<col style="width: 12%;"/>
							<col style="width: 38%;"/>
						</colgroup>
						<tbody>
						<tr>
							<th align="right">WBS Code / 과제명</th>
							<td class="tssLableCss" colspan="3">
								<span id='seed'/>
								<input type="text" id="wbsCd" /><em>/</em>
								<input type="text" id="tssNm" />
							</td>
						</tr>
						<tr>
							<th align="right">개발부서</th>
							<td><input type="text" id="prjNm"/></td>
							<th align="right">사업부문(Funding기준)</th>
							<td>
								<div id="bizDptCd"/>
							</td>
						</tr>
						<tr>
							<th align="right">사업부</th>
							<td>
								<input type="text" id="deptName" />
							</td>
							<th align="right">제품군</th>
							<td class="tssLableCss">
								<div id="prodG" />
							</td>
						</tr>
						<tr>
							<th align="right">과제담당자</th>
							<td><input type="text" id="saSabunName"/></td>
							<th align="right">과제기간</th>
							<td class="tssLableCss">
								<input type="text" id="tssStrtDd"/><em class="gab"> ~ </em>
								<input type="text" id="tssFnhDd"/>
							</td>
						</tr>
						<tr>
							<th align="right">고객특성</th>
							<td><div id="custSqlt"/> </td>
							<th align="right">Concept</th>
							<td><input type="text" id="tssSmryTxt"></td>
						</tr>
						<tr>
							<th align="right">발의주체</th>
							<td class="tssLableCss">
								<div id="ppslMbdCd"/>
							</td>
							<th align="right">연구분야</th>
							<td>
								<div id="rsstSphe"/>
							</td>
						</tr>
						<tr>
							<th align="right">과제속성</th>
							<td class="tssLableCss">
								<div id="tssAttrCd"/>
							</td>
							<th align="right">신제품 유형</th>
							<td>
								<div id="tssType"/>
							</td>
						</tr>
						<tr>
							<th align="right">진행단계</th>
							<td></td>
							<th align="right">GRS 상태</th>
							<td></td>
						</tr>
						<tr>
							<th align="right">Q-gate 단계</th>
							<td></td>
							<th align="right">GRS(P1) 사용여부</th>
							<td></td>
						</tr>
						</tbody>
					</table>
				</fieldset>
			</form>
		</div>
		<br/>

		<div id="tabView"></div>

		<form name="tabForm" id="tabForm" method="post">
			<!-- 변경개요 -->
			<iframe name="tabContent0" id="tabContent0" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
			<!-- 개요 -->
			<iframe name="tabContent1" id="tabContent1" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
			<!-- 산출물 -->
			<iframe name="tabContent2" id="tabContent2" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
			<!-- 변경이력 -->
			<iframe name="tabContent3" id="tabContent3" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
		</form>
	</div>
</div>
</body>
<script>

    //WBS Code
    wbsCd = new Rui.ui.form.LTextBox({
        applyTo: 'wbsCd',
        width: 100
    });

    //과제명
    tssNm = new Rui.ui.form.LTextBox({
        applyTo: 'tssNm',
        width: 300
    });

    //프로젝트명
    prjNm = new Rui.ui.form.LPopupTextBox({
        applyTo: 'prjNm',
        width: 300,
        editable: false
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
	// 사업부문(Funding 기준)
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


	//과제 리더
    saSabunName = new Rui.ui.form.LPopupTextBox({
        applyTo: 'saSabunName',
        width: 150,
        editable: false,
        enterToPopup: true
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
    //제품군
    prodG = new Rui.ui.form.LCombo({
        applyTo: 'prodG',
        name: 'prodG',
        useEmptyText: true,
        emptyText: '전체',
        url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PROD_G"/>',
        displayField: 'COM_DTL_NM',
        valueField: 'COM_DTL_CD',
        width: 100
    });
	// 과제기간 시작일
    tssStrtDd = new Rui.ui.form.LDateBox({
        applyTo: 'tssStrtDd',
        mask: '9999-99-99',
        width: 100,
        dateType: 'string'
    });

    // 과제기간 종료일
    tssFnhDd = new Rui.ui.form.LDateBox({
        applyTo: 'tssFnhDd',
        mask: '9999-99-99',
        width: 100,
        dateType: 'string'
    });

    //고객 특성
    var custSqlt = new Rui.ui.form.LCombo({
        applyTo : 'custSqlt',
        emptyValue : '',
        emptyText : '선택',
        width : 100,
        defaultValue : '${inputData.custSqlt}',
        items : [ {
            text : 'B2B제품군',
            value : '01'
        }, {
            text : '일반제품군',
            value : '02'
        }, ]
    });


	//Concept
    tssSmryTxt = new Rui.ui.form.LTextBox({
        applyTo: 'tssSmryTxt',
        width: 300
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


    // 변경이력 상세 팝업
    altrHistDialog = new Rui.ui.LFrameDialog({
        id: 'altrHistDialog',
        title: '변경이력상세',
        width: 800,
        height: 650,
        modal: true,
        visible: false
    });

    altrHistDialog.render(document.body);



    //변경요청
    btnAltrRq = new Rui.ui.LButton('btnAltrRq');
    btnAltrRq.on('click', function() {
        Rui.confirm({
            text: "본 변경요청은 단순 데이터 변경으로, 팀 내부승인 진행 건에 한해 진행됩니다. <br/><br/> "
            + "하기 변경이 발생하는 경우에는 반드시 <span style = 'color : red'>GRS심의(GRS요청버튼)를 완료</span>하신 후 변경요청을 해야 합니다. <br/>"
            + "Case 1. '과제 총 기간'이 변경되는 경우 (ex. 2017.12.31 -> 2018.12.31) <br/>"
            + "Case 2. '참여연구원'의 총 M/M가 증가하는 경우 (ex. 4 M/M -> 5 M/M) <br/>"
            + "Case 3. '목표' 항목이 추가/삭제 되는 경우 <br/><br/>"
            + "단순과제변경을 진행하겠습니까? ",
            width : 630 ,
            height : 270 ,
            handlerYes: function() {
                nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssPgsAltrCsus.do' />"+"?tssCd="+gvTssCd+"&userId="+gvUserId);
            },
            handlerNo: Rui.emptyFn
        });
    });



	function setTestCode(){
        // wbsCd.setValue("R18RH0");
        tssNm.setValue("기술팀과제 테스트01");
        // prjNm.setValue("표면소재.연구PJT");
        // $("#prjCd").val("PRJ00003");
        // $("#deptCode").val("58163580");
        // deptName.setValue("표면소재 사업부");
        bizDptCd.setSelectedIndex(1);
        prodG.setSelectedIndex(1);
        // $("#saSabunNew").val("FB0399");
        // saSabunName.setValue("조윤혜");
        tssStrtDd.setValue("2018-08-25");
        tssFnhDd.setValue("2018-08-25");
        custSqlt.setSelectedIndex(1);
        tssSmryTxt.setValue("컨셉");
        ppslMbdCd.setSelectedIndex(1);
        rsstSphe.setSelectedIndex(1);
        tssAttrCd.setSelectedIndex(1);
        tssType.setSelectedIndex(1);
        document.getElementById('tabContent0').contentWindow.smrSmryTxt.setValue("서머리개요");
        document.getElementById('tabContent0').contentWindow.smrGoalTxt.setValue("서머리목표");
        document.getElementById('tabContent0').contentWindow.ctyOtPlnM.setValue("2018-09");
        document.getElementById('tabContent0').contentWindow.nprodSalsPlnY.setValue("5.22");
    }



</script>
</html>