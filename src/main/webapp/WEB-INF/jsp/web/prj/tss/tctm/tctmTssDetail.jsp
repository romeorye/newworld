<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="iris.web.prj.tss.tctm.TctmUrl"%>
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
	<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>

	<script type="text/javascript">

        var gvTssCd  = "";
        var gvUserId = "${inputData._userId}";
        var gvTssSt  = "";
        var gvPageMode  = "";
        var gvRoleId = "";

        var grsEvSt = "";
        var hasAltr = 0;

        var pgsStepNm = "";
        var pgsStepCd ="";
        var dataSet;

        var isEditable = false;

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

            function setBtn(){
                btnDelRq.hide();	//삭제
                btnAltrRq.hide();	//변경요청
                btnStepPg.hide();	//변경취소
                btnGrsRq.hide();	//GRS요청
                btnCsusRq.hide();	//품의서요청
                btnCsusRq2	.hide();//내부품의서요청

                if(isOwner()){
                  
                	if(pgsStepCd=="PL" && gvTssSt=="100"){
                        //계획 진행중
                        btnDelRq.show();	// 삭제
                    }

                    if(gvTssSt=="100"){
                        //진행중
                        btnGrsRq.show();	//GRS  요청
                    }
                    
                    console.log(pgsStepCd,grsYn, gvTssSt);
                    
                    if(
						(pgsStepCd=="PL" && grsYn=="N" && gvTssSt=="100")			//GRS N(계획) 인경우 바로 품의서 요청
						|| (pgsStepCd=="PL" && grsYn=="Y" && gvTssSt=="302" )	//GRS Y(계획) 인경우 GRS 품의완료시 품의서 요청
						|| (pgsStepCd=="PL" && gvTssSt=="102" )	//GRS Y(계획) 인경우 GRS 품의완료시 품의서 요청
						|| (pgsStepCd=="PG" && gvTssSt=="302")							//진행인 경우 GRS 평가완료
					){
                        btnCsusRq.show();	// 품의서요청
                    }

                    if(pgsStepCd=="PG" && gvTssSt=="100"){
                        btnAltrRq.show();		//변경 요청
                    }


                    if(pgsStepCd=="AL"  && gvTssSt=="100"){
                        btnStepPg.show();
                        btnCsusRq2.show();
                        btnGrsRq.hide();
                    }
                }

                /*

                            if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
                $("#btnDelRq").hide();
                $("#btnGrsRq").hide();
                $("#btnCsusRq").hide();
            }else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
                $("#btnDelRq").hide();
                $("#btnGrsRq").hide();
                $("#btnCsusRq").hide();
            }
*/

                /*

                            //조건에 따른 보이기
                            if(isOwner()) {
                                if(gvTssSt == "100"){
                                    btnGrsRq.show();
                                    btnDelRq.show();
                                }else if(gvTssSt == "102"){
                                    btnCsusRq.show();
                                }
                            }
                */

            }



            //form 비활성화 여부
            var disableFields = function(disable) {
                //form
                prjNm.setEditable(false);
                deptName.setEditable(false);
                // wbsCd.setEditable(false);

                //style
                $('#prjNm > a').attr('style', "display:none;");
                $('#prjNm').attr('style', "border-color:white;");
                $('#deptName').attr('style', "border-color:white;");
                $('#wbsCd').attr('style', "border-color:white;");


                if(isOwner()) {
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

                    , {id: 'cmplBStrtDd'}   //완료기간S
                    , {id: 'cmplBFnhDd'}   //완료기간E

                    , {id: 'dcacBStrtDd'}   //완료기간S
                    , {id: 'dcacBFnhDd'}   //완료기간E


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
                    , {id: 'grsEvSt'}
                    , {id: 'hasAltr'}


                    ,{id: 'plTssCd'}  //계획 과제코드
                    ,{id: 'pgTssCd'}  //진행 과제코드
                    ,{id: 'alTssCd'}  //변경 과제코드
                    , {id: 'cmTssCd'} //완료 과제코드
                    , {id: 'dcTssCd'}	//중단 과제코드

                    , {id: 'tssStepNm'}	//관제 단계
                    , {id: 'grsStepNm'}	//GRS 단계
                    , {id: 'qgateStepNm'}	//Qgate 단계
                    , {id: 'grsYn'}	//grs(p1) 사용여부




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
                    // , { id: 'ppslMbdCd',  ctrlId: 'ppslMbdCd',  value: 'value' }
                    , { id: 'bizDptCd',   ctrlId: 'bizDptCd',   value: 'value' }
                    // , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }         /SEED를 추가하기 위해 bind 주석
                    , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'value' }
                    , { id: 'saSabunNew', ctrlId: 'saSabunNew', value: 'value' }
                    , { id: 'saSabunName', ctrlId: 'saSabunName', value: 'value' }
                    , { id: 'tssAttrCd',  ctrlId: 'tssAttrCd',  value: 'value' }
                    , { id: 'tssStrtDd',  ctrlId: 'tssStrtDd',  value: 'value' }
                    , { id: 'tssFnhDd',   ctrlId: 'tssFnhDd',   value: 'value' }

                    , { id: 'cmplBStrtDd',  ctrlId: 'cmplBStrtDd',  value: 'value' }
                    , { id: 'cmplBFnhDd',   ctrlId: 'cmplBFnhDd',   value: 'value' }

                    , { id: 'dcacBStrtDd',  ctrlId: 'dcacBStrtDd',  value: 'value' }
                    , { id: 'dcacBFnhDd',   ctrlId: 'dcacBFnhDd',   value: 'value' }

                    , { id: 'userId',     ctrlId: 'userId',     value: 'value' }
                    , { id: 'prodG',    ctrlId: 'prodG',    value: 'value' }
                    , { id: 'rsstSphe',   ctrlId: 'rsstSphe',   value: 'value' }
                    , { id: 'tssType',    ctrlId: 'tssType',    value: 'value' }
                    , { id: 'custSqlt',    ctrlId: 'custSqlt',    value: 'value' }
                    , { id: 'tssSmryTxt',    ctrlId: 'tssSmryTxt',    value: 'value' }

                    , { id: 'tssStepNm',    ctrlId: 'tssStepNm',    value: 'value' }				//과제 단계명
                    , { id: 'grsStepNm',    ctrlId: 'grsStepNm',    value: 'value' }				// GRS 단계명
                    , { id: 'qgateStepNm',    ctrlId: 'qgateStepNm',    value: 'value' }		//Qgate 단계명
                ]
            });


            function setValidation(){
                vm = new Rui.validate.LValidatorManager({
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

                        , { id: 'cmplBStrtDd',   validExp: '완료기간 시작일:'+ isCm() }
                        , { id: 'cmplBFnhDd',    validExp: '완료기간 종료일:'+ isCm() }

                        , { id: 'dcacBStrtDd',   validExp: '중단기간 시작일:'+isDc() }
                        , { id: 'dcacBFnhDd',    validExp: '중단기간 종료일:'+isDc()}

                        , { id: 'pgsStepNm',   validExp: '진행단계명:false' }
                        , { id: 'tssSt',       validExp: '과제상태:false' }
                        , { id: 'pgsStepCd',   validExp: '진행단계:false' }
                        , { id: 'tssScnCd',    validExp: '과제구분:false' }
                        , { id: 'prodG',     validExp: '제품군:true' }
                        , { id: 'rsstSphe',    validExp: '연구분야:true' }
                        , { id: 'tssType',     validExp: '유형:true' }
                    ]
                });
            }


            dataSet.on('load', function(e) {

                gvTssCd = stringNullChk(dataSet.getNameValue(0, "tssCd"));
                gvTssSt = stringNullChk(dataSet.getNameValue(0, "tssSt"));
                gvPageMode = stringNullChk(dataSet.getNameValue(0, "tssRoleType"));
                gvRoleId = stringNullChk(dataSet.getNameValue(0, "tssRoleId"));

                pgsStepCd = stringNullChk(dataSet.getNameValue(0, "pgsStepCd"));
                pgsStepNm  = stringNullChk(dataSet.getNameValue(0, "pgsStepNm"));
                grsEvSt  = stringNullChk(dataSet.getNameValue(0, "grsEvSt"));
                hasAltr  = stringNullChk(dataSet.getNameValue(0, "hasAltr"));
                grsYn  = stringNullChk(dataSet.getNameValue(0, "grsYn"));



                    //계획 단계의 경우 SEED 표현, width 조정
                    var wbsCdStr = stringNullChk(dataSet.getNameValue(0, "wbsCd"));
                    if(pgsStepCd=="PL"){
                        $('[name="wbsCd"]').css("width",70);
                        wbsCdStr = "SEED-" + wbsCdStr;
                    }else{
                        $('[name="wbsCd"]').css("width",50);
                    }
                    wbsCd.setValue(wbsCdStr);



                //단계별 과제코드
                plTssCd  = stringNullChk(dataSet.getNameValue(0, "plTssCd"));	//계획
                pgTssCd  = stringNullChk(dataSet.getNameValue(0, "pgTssCd"));	//진행
                alTssCd  = stringNullChk(dataSet.getNameValue(0, "alTssCd"));	//변경
                cmTssCd  = stringNullChk(dataSet.getNameValue(0, "cmTssCd"));	//완료
                dcTssCd  = stringNullChk(dataSet.getNameValue(0, "dcTssCd"));	//중단

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

                isFirst = gvTssSt == "";

                isEditable =
                    isFirst
                    || gvTssSt=="100"
                // || dataSet.getNameValue(0, "grsYn")=="N" && (pgsStepCd=="PL" )
                ;


                console.log(gvTssSt);
                console.log(">>>>>>>>>>>>>>>>>>>>>");
                console.log(isEditable);
                disableFields();

                setTab();				//Tab 생성
                setStepNm();			// 진행상태명 생성
                setValidation();		// Validation Rule 생성
                if(isFirst){
                    $("#tssNm > input").focus();
                    $("#grsYnTd0101").show();
                    $("#grsYnTd0102").show();
                    $("#grsYnTd0201").hide();
                    $("#grsYnTd0202").hide();
                }else{
                    $("#grsYnTd0101").hide();
                    $("#grsYnTd0102").hide();
                    $("#grsYnTd0201").show();
                    $("#grsYnTd0202").show();

                    // $("#grsYnTd02").hide();
                }
                if(!isEditable)setViewform();		//읽기용 뷰로 변경
                setBtn()					//버튼 표시
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


            function setStepNm(){
                if(pgsStepNm==""){
                    $("#stepNm").html("계획");
                }else{
                    if( grsEvSt=="P2" && gvTssSt=="102"){
                        //완료 GRS 완료
                        $("#stepNm").html("완료");
                    }else if(grsEvSt=="D" && gvTssSt=="102") {
                        //중단 GRS 완료
                        $("#stepNm").html("중단");
                    }else{
                        $("#stepNm").html(pgsStepNm);
                    }
                }
            }

            /*============================================================================
            =================================      Tab       =============================
            ============================================================================*/

            // Tab 생성
            function setTab() {
                if($("#tabView").children().length>0)return; //재생성 방지

                IfrmUrls = [
                    "<%=request.getContextPath()+TctmUrl.doTabCmpl%>?tssCd=" + cmTssCd + "&pgsStepCd=" + pgsStepCd,
                    "<%=request.getContextPath()+TctmUrl.doTabDcac%>?tssCd=" + dcTssCd + "&pgsStepCd=" + pgsStepCd,
                    "<%=request.getContextPath()+TctmUrl.doTabAltr%>?tssCd=" + alTssCd + "&pgsStepCd=" + pgsStepCd,
                    "<%=request.getContextPath()+TctmUrl.doTabSum%>?tssCd=" + gvTssCd + "&pgsStepCd=" + pgsStepCd,
                    "<%=request.getContextPath()+TctmUrl.doTabGoal%>?tssCd=" + gvTssCd + "&pgsStepCd=" + pgsStepCd,
                    "<%=request.getContextPath()+TctmUrl.doTabAltrHis%>?pkWbsCd=" + dataSet.getNameValue(0, "pkWbsCd")
                ]

                tabView = new Rui.ui.tab.LTabView({
                    tabs: [
                        {label: '완료', content: '<div id="div-content-test0"></div>'},
                        {label: '중단', content: '<div id="div-content-test1"></div>'},
                        {label: '변경개요', content: '<div id="div-content-test2"></div>'},
                        {label: '개요', content: '<div id="div-content-test3"></div>'},
                        {label: '산출물', content: '<div id="div-content-test4"></div>'},
                        {label: '변경이력', content: '<div id="div-content-test5"></div>'}
                    ]
                });

                tabView.on('activeTabChange', function (e) {
                    // iframe 숨기기

                    for (var i = 0; i < $("#tabForm").children().length; i++) {
                        if (i == e.activeIndex) {
                            Rui.get('tabContent' + i).show();
                        } else {
                            Rui.get('tabContent' + i).hide();
                        }
                    }
                    var tabUrl = "";
                    console.log("tabb Idx", e.activeIndex);

                    if (e.isFirst) {
                        nwinsActSubmit(document.tabForm, IfrmUrls[e.activeIndex], 'tabContent' + e.activeIndex);
                    } else {
                        disableFields(false);
                    }
                });


                tabView.render('tabView');
                // if (pgsStepCd == "PL" || pgsStepCd == "PG") {
                //     var fIdx = 1;
                //     $(".L-nav").children().eq(0).css("display", "none");
                //     // $(".L-nav").children().eq(3).css("display","none");
                // } else if (pgsStepCd == "AL") {
                //     var fIdx = 0;
                //     $(".L-nav").children().eq(0).css("display", "block");
                //     // $(".L-nav").children().eq(3).css("display","block");
                // }


                $(".L-nav").children().eq(0).css("display","none");
                $(".L-nav").children().eq(1).css("display","none");
                $(".L-nav").children().eq(2).css("display","none");
                $(".L-nav").children().eq(3).css("display","block");
                $(".L-nav").children().eq(4).css("display","block");
                $(".L-nav").children().eq(5).css("display","none");

                $("#cmDdRow").hide();
                $("#dcDdRow").hide();


                if(isAl()) {
                    //변경
                    $(".L-nav").children().eq(2).css("display","block");    // 변경
                }else if(isCm()){
                    //완료 GRS 완료
                    $(".L-nav").children().eq(0).css("display","block");    //완료
                    $("#cmDdRow").show();
                }else if(isDc()) {
                    //중단 GRS 완료
                    $(".L-nav").children().eq(1).css("display","block");    //중단
                    $("#dcDdRow").show();
                }

                if(hasAltr>0){
                    //변경 이력이 있는경우
                    $(".L-nav").children().eq(5).css("display","block"); //변경 이력
                }

                // 보여지는 첫번째 탭 선택
                var fIdx=0;
                for (var i = 0; i < $(".L-nav").children().length; i++) {
                    if($(".L-nav").children().eq(i).css("display")=="block"){
                        fIdx=i;
                        break;
                    }
                }

                tabView.selectTab(fIdx);
                nwinsActSubmit(document.tabForm, IfrmUrls[fIdx], 'tabContent'+fIdx);
            }


            // 변경 요청
            function reqAltr(){
                btnAltrRq.hide();
                btnGrsRq.hide();
                btnStepPg.show();
                btnGrsRq.hide();

                $(".L-nav").children().eq(2).css("display","block");
                $(".L-nav").children().eq(5).css("display","block");
                var fIdx = 2;
                tabView.selectTab(fIdx);
                nwinsActSubmit(document.tabForm, IfrmUrls[fIdx], 'tabContent'+fIdx);

                isEditable =  false;
                setViewform();	//수정불가능하도록 (과제 내용)
                try{
                    //화면 생성전 접근할경우 에러 발생
                    document.getElementById('tabContent3').contentWindow.setViewform();	//수정불가능하도록 (개요)
                    document.getElementById('tabContent4').contentWindow.disableFields();	//수정불가능하도록 (산출물)
                }catch(e){}

            }



            function isPg(){

            }
            function isAl(){
                return pgsStepCd=="AL";
            }

            function isCm(){
                return (grsEvSt=="P2" && gvTssSt=="102") || pgsStepCd =="CM";
            }

            function isDc(){
                return (grsEvSt=="D" && gvTssSt=="102") || pgsStepCd =="DC";
            }

            function isOwner(){
                return "TR01" == gvRoleId || "${inputData._userSabun}" == dataSet.getNameValue(0, "saSabunNew");
            }


            function setViewform(){
                setReadonly("wbsCd");
                setReadonly("tssNm");
                setReadonly("prjNm");
                setReadonly("prodG");
                setReadonly("bizDptCd");
                setReadonly("custSqlt");
                setReadonly("saSabunName");

                setReadonly("tssStrtDd");
                $("#tssStrtDd").css("cssText", "border-width:0px; width: 80px !important;");
                $("#tssStrtDd").next().css("cssText","padding-right:5px;margin:0px !important");
                setReadonly("tssFnhDd");

                setReadonly("tssSmryTxt");
                setReadonly("ppslMbdCd");
                setReadonly("rsstSphe");
                setReadonly("tssAttrCd");
                setReadonly("tssType");

                //완료시점
                setReadonly("cmplBStrtDd");
                $("#cmplBStrtDd").css("cssText", "border-width:0px; width: 80px !important;");
                $("#cmplBFnhDd").next().css("margin-left","0px");
                setReadonly("cmplBFnhDd");
                //중단시점
                setReadonly("dcacBStrtDd");
                $("#dcacBStrtDd").css("cssText", "border-width:0px; width: 80px !important;");
                $("#dcacBStrtDd").next().css("margin-left","0px");
                setReadonly("dcacBFnhDd");

				
                if(gvTssSt=="102"){
                    if(isCm() ){
                        //품의 요청시 개발완기간 수정가능
                        setEditable("cmplBStrtDd");
                        setEditable("cmplBFnhDd");
                    }

                    if(isDc() ){
                        //품의 요청시 개발완기간 수정가능
                        setEditable("dcacBStrtDd");
                        setEditable("dcacBFnhDd");
                    }
                }
            }



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
                // if (regCntMap.tctmSmryCnt > 0) {
                //     if (regCntMap.comYldCnt < 2) errMsg = "산출물을 입력해 주시기 바랍니다.";
                // } else {
                //     errMsg = "개요를 입력해 주시기 바랍니다.";
                // }

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
            btnDelRq.on('click', function () {
                if (confirm("삭제를 하시겠습니까?")) {
                    dm.updateDataSet({
                        modifiedOnly: false,
                        <%--url:'<c:url value="/prj/tss/gen/deleteGenTssPlnMst.do"/>',--%>
                        url: '<%=request.getContextPath()+TctmUrl.doDeleteInfo%>',
                        dataSets: [dataSet],
                        params: {
                            tssCd: gvTssCd
                        }
                    });
                }
                dm.on('success', function (e) {
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


            //변경요청
            btnAltrRq = new Rui.ui.LButton('btnAltrRq');
            btnAltrRq.on('click', function() {
                if(confirm("변경요청을 하시겠습니까?")) {
                    reqAltr();
                }
/*                Rui.confirm({
                    text: "과제변경을 진행하겠습니까? ",
                    // "본 변경요청은 단순 데이터 변경으로, 팀 내부승인 진행 건에 한해 진행됩니다. <br/><br/> "
                    // + "하기 변경이 발생하는 경우에는 반드시 <span style = 'color : red'>GRS심의(GRS요청버튼)를 완료</span>하신 후 변경요청을 해야 합니다. <br/>"
                    // + "Case 1. '과제 총 기간'이 변경되는 경우 (ex. 2017.12.31 -> 2018.12.31) <br/>"
                    // + "Case 2. '참여연구원'의 총 M/M가 증가하는 경우 (ex. 4 M/M -> 5 M/M) <br/>"
                    // + "Case 3. '목표' 항목이 추가/삭제 되는 경우 <br/><br/>"
                    // + "단순과제변경을 진행하겠습니까? ",
                    width : 630 ,
                    height : 270 ,
                    handlerYes: function() {
                        /!*nwinsActSubmit(document.mstForm, "<c:url value='/prj/tss/gen/genTssPgsAltrCsus.do' />"+"?tssCd="+gvTssCd+"&userId="+gvUserId);*!/
                        reqAltr();
                    },
                    handlerNo: Rui.emptyFn
                });*/
            });

/*            btnAltr = new Rui.ui.LButton('btnAltr');
            btnAltr.on('click', function(){

                Rui.confirm({
                    text: '변경하시겠습니까?',
                    buttons: [{
                        text: '내부변경'
                    },{
                        text: 'GRS변경'
                    }],
                    handlerYes: function() {
                        reqAltr();
                    },
                    handlerNo: function() {
                        regDm.update({
                            url:'<c:url value="/prj/tss/gen/getTssRegistCnt.do"/>',
                            params:'gbn=GRS&tssCd='+gvTssCd
                        });
                    }
                })

            });*/



            //변경 취소
            btnStepPg = new Rui.ui.LButton('btnStepPg');
            btnStepPg.on('click', function() {
                if (confirm("진행단계로 이동하시겠습니까?\n변경에서 작성한 데이터는 삭제됩니다.")) {
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url: '<%=contextPath+TctmUrl.doCancelInfoAltr%>',
                        dataSets: [dataSet],
                        params: {
                            tssCd: gvTssCd
                            ,userId:gvUserId
                        }
                    });
                }
                dm.on('success', function (e) {
                    location.href = "<%=request.getContextPath()+TctmUrl.doList%>";
                });
            });


            //내부품의
            btnCsusRq2 = new Rui.ui.LButton('btnCsusRq2');
            btnCsusRq2.on('click', function() {
                if(confirm('품의서요청을 하시겠습니까?')) {
                    nwinsActSubmit(document.mstForm, "<%=request.getContextPath()+TctmUrl.doAltrCsusView%>"+"?tssCd="+gvTssCd+"&userId="+gvUserId+"&appCode=APP00339");
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
                var smryDs = document.getElementById('tabContent3').contentWindow.dataSet;                  //개요탭 DS
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



                    if(pgsStepCd=="")pgsStepCd = "PL"
                    dataSet.setNameValue(0, "pgsStepCd", pgsStepCd);
                    dataSet.setNameValue(0, "tssScnCd", "D");   //과제구분: D(기술팀)
                    dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                    dataSet.setNameValue(0, "tssCd",  gvTssCd);  //과제코드
                    dataSet.setNameValue(0, "userId", gvUserId); //사용자ID

                    smryDs.setNameValue(0, "tssCd",  gvTssCd);   //과제코드
                    smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID

                    dm.updateDataSet({
                        modifiedOnly: false,
                        url: '<%=request.getContextPath()+TctmUrl.doUpdateInfo%>',
                        dataSets: [dataSet, smryDs],
                    });
                    dm.on('success', function (e) {
                        location.href = "<%=request.getContextPath()+TctmUrl.doList%>";
                    });
                }
            };

            //변경 저장
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
                var smryDs = document.getElementById('tabContent2').contentWindow.dataSet1; //개요탭 DS
                var altrDs = document.getElementById('tabContent2').contentWindow.dataSet2; //개요탭 DS

                // if(!dataSet.isUpdated() && !smryDs.isUpdated() && !altrDs.isUpdated()) {
                //     alert("변경된 데이터가 없습니다.");
                //     return;
                // }

                if(confirm('저장하시겠습니까?')) {
                    dataSet.setNameValue(0, "pgTssCd", gvTssCd);
                    dataSet.setNameValue(0, "tssScnCd", "D");   //과제구분: D
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
                    dm.on('success', function (e) {
                        location.href = "<%=request.getContextPath()+TctmUrl.doList%>";
                    });
                }
            }

            //완료 저장
            cmSave = function() {
                cmplBStrtDd.blur();
                cmplBFnhDd.blur();

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
                if(confirm('저장하시겠습니까?')) {
                    dataSet.setNameValue(0, "tssCd",  gvTssCd); //과제코드
                    dataSet.setNameValue(0, "pgsStepCd", "CM"); //진행단계: CM(완료)
                    dataSet.setNameValue(0, "tssScnCd", "D");   //과제구분: D
                    dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                    dataSet.setNameValue(0, "userId", gvUserId);  //사용자ID
                    dataSet.setNameValue(0, "tssRoleType", "W"); //화면권한


                    smryDs.setNameValue(0, "tssCd",  gvTssCd); //과제코드
                    smryDs.setNameValue(0, "plTssCd",  plTssCd); //과제코드
                    smryDs.setNameValue(0, "pgTssCd",  pgTssCd); //과제코드
                    smryDs.setNameValue(0, "alTssCd",  alTssCd); //과제코드
                    smryDs.setNameValue(0, "cmTssCd",  cmTssCd); //과제코드
                    smryDs.setNameValue(0, "dcTssCd",  dcTssCd); //과제코드
                    smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID



                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<%=request.getContextPath()+TctmUrl.doUpdateCmplInfo%>',
                        dataSets:[dataSet, smryDs]
                    });
                    dm.on('success', function (e) {
                        location.href = "<%=request.getContextPath()+TctmUrl.doList%>";
                    });
                }
            };


            dcSave = function() {
                dcacBStrtDd.blur();
                dcacBFnhDd.blur();

                if(!vm.validateGroup("mstForm")) {
                    Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                    return;
                }

                //validation
                var ifmUpdate = document.getElementById('tabContent1').contentWindow.fnIfmIsUpdate("SAVE");
                if(!ifmUpdate) return false;

                //수정여부
                var smryDs = document.getElementById('tabContent1').contentWindow.dataSet; //개요탭 DS
                if(!dataSet.isUpdated() && !smryDs.isUpdated()) {
                    Rui.alert("변경된 데이터가 없습니다.");
                    return;
                }

                if(confirm('저장하시겠습니까?')) {
                    dataSet.setNameValue(0, "tssCd",  gvTssCd); //과제코드
                    dataSet.setNameValue(0, "pgsStepCd", "DC"); //진행단계: CM(완료)
                    dataSet.setNameValue(0, "tssScnCd", "D");   //과제구분: D
                    dataSet.setNameValue(0, "tssSt", "100");    //과제상태: 100(작성중)
                    dataSet.setNameValue(0, "userId", gvUserId);  //사용자ID
                    dataSet.setNameValue(0, "tssRoleType", "W"); //화면권한


                    smryDs.setNameValue(0, "tssCd",  gvTssCd); //과제코드
                    smryDs.setNameValue(0, "plTssCd",  plTssCd); //과제코드
                    smryDs.setNameValue(0, "pgTssCd",  pgTssCd); //과제코드
                    smryDs.setNameValue(0, "alTssCd",  alTssCd); //과제코드
                    smryDs.setNameValue(0, "cmTssCd",  cmTssCd); //과제코드
                    smryDs.setNameValue(0, "dcTssCd",  dcTssCd); //과제코드
                    smryDs.setNameValue(0, "userId", gvUserId);  //사용자ID


                    console.log(smryDs);
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<%=request.getContextPath()+TctmUrl.doUpdateDcacInfo%>',
                        dataSets:[dataSet, smryDs]
                    });
                    dm.on('success', function (e) {
                        location.href = "<%=request.getContextPath()+TctmUrl.doList%>";
                    });
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
            altrHistDialog.setUrl('<%=request.getContextPath()+TctmUrl.doTabAltrHisPop%>'+params);
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
		<a class="leftCon" href="#">
			<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			<span class="hidden">Toggle 버튼</span>
		</a>
		<h2 id="h2Titl">기술팀과제 &gt;&gt;&nbsp;</h2><h2 id="stepNm"></h2>
	</div>

	<div class="sub-content">
		<div class="titArea mt0">
			<div class="LblockButton">
				<button type="button" id="btnDelRq" name="btnDelRq">삭제</button>
				<%--<button type="button" id="btnAltr" name="btnAltr">변경</button>--%>
				<button type="button" id="btnAltrRq" name="btnAltrRq">변경요청</button>
				<button type="button" id="btnStepPg" name="btnStepPg">변경취소</button>
				<button type="button" id="btnGrsRq" name="btnGrsRq">GRS요청</button>
				<button type="button" id="btnCsusRq" name="btnCsusRq">품의서요청</button>
				<button type="button" id="btnCsusRq2" name="btnCsusRq2">내부품의서요청</button>
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
							<th align="right">개발부서</th>
							<td><input type="text" id="prjNm"/></td>
							<th align="right">사업부</th>
							<td>
								<input type="text" id="deptName" />
							</td>
						</tr>

						<tr>
							<th align="right">WBS Code / 과제명</th>
							<td class="tssLableCss" colspan="3">
								<span id='seed'/>
								<input type="text" id="wbsCd" /><em>/</em>
								<input type="text" id="tssNm" />
							</td>
						</tr>
						<tr>
							<th align="right">과제리더</th>
							<td><input type="text" id="saSabunName"/></td>
							<th align="right">사업부문(Funding기준)</th>
							<td>
								<div id="bizDptCd"/>
							</td>
						</tr>
						<tr>
							<th align="right">제품군</th>
							<td class="tssLableCss">
								<div id="prodG" />
							</td>
							<th align="right">과제기간</th>
							<td class="tssLableCss">
								<input type="text" id="tssStrtDd"/><em class="gab"> ~ </em>
								<input type="text" id="tssFnhDd"/>
							</td>
						</tr>
						<tr>
							<th align="right">고객특성</th>
							<td><div id="custSqlt"/> </td>
							<th align="right" style="display: none">Concept</th>
							<td style="display: none"><input type="text" id="tssSmryTxt"></td>

							<th align="right">발의주체</th>
							<td class="tssLableCss">
								<div id="ppslMbdCd"/>
							</td>

						</tr>
						<tr>
							<th align="right">연구분야</th>
							<td>
								<div id="rsstSphe"/>
							</td>
							<th align="right">과제속성</th>
							<td class="tssLableCss">
								<div id="tssAttrCd"/>
							</td>
						</tr>
						<tr>
							<th align="right">신제품 유형</th>
							<td>
								<div id="tssType"/>
							</td>
							<th align="right">Q-gate 단계</th>
							<td><span id="qgateStepNm"/> </td>
						</tr>
						<tr>
							<th align="right">진행단계</th>
							<td><span id="tssStepNm"/></td>

							<th align="right" id="grsYnTd0101" style="display: none">GRS(P1) 사용여부</th>
                            <td id="grsYnTd0102" style="display: none"><div id="grsYn"/></td>
                            <th align="right" id="grsYnTd0201"">GRS 상태</th>
                            <td id="grsYnTd0202"><span id="grsStepNm"/> </td>
						</tr>
						<tr id="cmDdRow" style="display: none">
							<th align="right">실적(개발완료시점)</th>
							<td colspan="3">
								<input type="text" id="cmplBStrtDd" value="" /><em class="gab"> ~ </em>
								<input type="text" id="cmplBFnhDd" value="" />
							</td>
						</tr>
						<tr id="dcDdRow" style="display: none">
							<th align="right">실적(개발중단시점)</th>
							<td colspan="3">
								<input type="text" id="dcacBStrtDd" value="" /><em class="gab"> ~ </em>
								<input type="text" id="dcacBFnhDd" value="" />
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
			<!-- 완료 -->
			<iframe name="tabContent0" id="tabContent0" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
			<!-- 중단 -->
			<iframe name="tabContent1" id="tabContent1" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
			<!-- 변경 -->
			<iframe name="tabContent2" id="tabContent2" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
			<!-- 개요 -->
			<iframe name="tabContent3" id="tabContent3" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
			<!-- 산출물 -->
			<iframe name="tabContent4" id="tabContent4" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
			<!-- 변경이력 -->
			<iframe name="tabContent5" id="tabContent5" scrolling="auto" width="100%" height="100%" frameborder="0"></iframe>
		</form>
	</div>
</div>
</body>
<script>

    //WBS Code
    wbsCd = new Rui.ui.form.LTextBox({
        applyTo: 'wbsCd',
        editable: false,
        width: 100
    });
    $("#wbsCd").css("border-width", "0px");

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


    nCombo('ppslMbdCd','PPSL_MBD_CD');

    nCombo('bizDptCd', 'BIZ_DPT_CD');

    //과제 리더
    saSabunName = new Rui.ui.form.LPopupTextBox({
        applyTo: 'saSabunName',
        width: 150,
        editable: false,
        enterToPopup: true
    });


    nCombo('tssAttrCd', 'TSS_ATTR_CD');

    nCombo('prodG', 'PROD_G');


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
        width : 120,
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
    /*    tssSmryTxt = new Rui.ui.form.LTextBox({
            applyTo: 'tssSmryTxt',
            width: 300
        });*/
    nTextBox('tssSmryTxt', 300);
    nCombo('rsstSphe','RSST_SPHE');
    //유형
    nCombo('tssType','TSS_TYPE');


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



    //완료 시작일
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

    //완료 종료일
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
    //종료 시작일
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

    //종료 종료일
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

    //진행 단계
    tssStepNm = new Rui.ui.form.LTextBox({
        applyTo: 'tssStepNm',
        editable: false,
        width: 200
    });
    $("#tssStepNm").css("border-width", "0px");

    //GRS 단계
    grsStepNm = new Rui.ui.form.LTextBox({
        applyTo: 'grsStepNm',
        editable: false,
        width: 200
    });
    $("#grsStepNm").css("border-width", "0px");
    //Q-gate 단계
    qgateStepNm = new Rui.ui.form.LTextBox({
        applyTo: 'qgateStepNm',
        editable: false,
        width: 200
    });
    $("#qgateStepNm").css("border-width", "0px");




    nCombo('grsYn', 'COMM_YN') // GRS 수행여부



    window.onload = function(){
        bizDptCd.on('changed',function(e){
            setRsstSpheVal();
        });
        prodG.on('changed',function(e){
            setRsstSpheVal();
        });

        function setRsstSpheVal(){
            //		창호 01/장식재 03 > 건장재01
            //		자동차 05 > 자동차04
            //		표면소재 06(데코 P11,가전 P12,S&G P13) > 산업용필름02
            //		표면소재 06(그외) > 건장재01
            var bdc = bizDptCd.getValue();
            var pdg = prodG.getValue();
            var result = "";
            if(bdc=="01" || bdc=="03"){
                result = "01";
            }else if(bdc=="05"){
                result = "04";
            }else if(bdc=="06" && (pdg=="P11" || pdg=="P12" || pdg=="P13")){
                result = "02";
            }else if(bdc=="06"){
                result = "01";
            }else{
                result = "03";
            }
            rsstSphe.setValue(result);
        }

        ppslMbdCd.setValue('02');	//사업부 fix
        grsYn.setValue('N');	// P1 수행하지 않음(기본값)
	}

</script>
</html>