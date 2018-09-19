<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssList.jsp
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<style>
.font-bold div{
    font-weight: bold;
}
</style>

<script type="text/javascript">
	var pageRoleType = '${inputData.tssRoleType}';
	var pageRoleId   = '${inputData.tssRoleId}';

    var wbsCd;
    var tssNm;
    var saUserName;
    var deptName;
    var ttlCrroStrtDt;
    var ttlCrroFnhDt;
    var tssSt;
    var prjNm;

    Rui.onReady(function() {
        //WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            defaultValue: '<c:out value="${inputData.wbsCd}"/>',
            width: 200
        });
        
        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            defaultValue: '<c:out value="${inputData.tssNm}"/>',
            width: 200
        });
       
        //과제리더
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            defaultValue: '<c:out value="${inputData.saUserName}"/>',
            width: 200
        });
        
        //조직
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            defaultValue: '<c:out value="${inputData.deptName}"/>',
            width: 200
        });
        /*
        saUserName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saUserName',
            width: 200,
            
            editable: false,
            enterToPopup: true
        });
        saUserName.on('popup', function(e){
            saUserName.setValue('');
            document.aform.saSabunNew.value = '';
            openUserSearchDialog(setLeaderInfo, 1, '');
        });
        saUserName.on('paste', function(e){
            document.aform.saSabunNew.value = "";
        });
        saUserName.on('keyup', function(e){
            document.aform.saSabunNew.value = "";
        });
        */
        //조직
        /*
        deptName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'deptName',
            width: 200,
            editable: false,
            enterToPopup: true
        });
		*/
		
        //과제기간 시작일
        ttlCrroStrtDt = new Rui.ui.form.LMonthBox({
            applyTo: 'ttlCrroStrtDt',
            defaultValue: '<c:out value="${inputData.ttlCrroStrtDt}"/>',
            width: 100,
            dateType: 'string'
        });
		/* 
        ttlCrroStrtDt = new Rui.ui.form.LDateBox({
            applyTo: 'ttlCrroStrtDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue: '<c:out value="${inputData.ttlCrroStrtDt}"/>',
            width: 100,
            dateType: 'string'
        });
        ttlCrroStrtDt.on('blur', function() {
            if(ttlCrroStrtDt.getValue() == "") {
                return;
            }
            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(ttlCrroStrtDt.getValue(),"-","")))) {
                Rui.alert('날자형식이 올바르지 않습니다.!!');
                ttlCrroStrtDt.setValue(new Date());
            }
        });
 */
        //과제기간 종료일
         ttlCrroFnhDt = new Rui.ui.form.LMonthBox({
            applyTo: 'ttlCrroFnhDt',
            defaultValue: '<c:out value="${inputData.ttlCrroFnhDt}"/>',
            width: 100,
            dateType: 'string'
        });
 /* 
        ttlCrroFnhDt = new Rui.ui.form.LDateBox({
            applyTo: 'ttlCrroFnhDt',
            mask: '9999-99-99',
            defaultValue: '<c:out value="${inputData.ttlCrroFnhDt}"/>',
            displayValue: '%Y-%m-%d',
            width: 100,
            dateType: 'string'
        });
        ttlCrroFnhDt.on('blur', function() {
            if(ttlCrroFnhDt.getValue() == "") {
                return;
            }
            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(ttlCrroFnhDt.getValue(),"-","")))) {
                Rui.alert('날자형식이 올바르지 않습니다.!!');
                ttlCrroFnhDt.setValue(new Date());
            }
        });
 */
        //상태
        tssSt = new Rui.ui.form.LCombo({
            applyTo: 'tssSt',
            name: 'tssSt',
            useEmptyText: true,
            defaultValue: '<c:out value="${inputData.tssSt}"/>',
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_ST"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            autoMapping: true
        });

        //과제명
        prjNm = new Rui.ui.form.LTextBox({
            applyTo: 'prjNm',
            defaultValue: '<c:out value="${inputData.prjNm}"/>',
            width: 200
        });

        //진행상태
        pgsStepCd = new Rui.ui.form.LCombo({
            applyTo: 'pgsStepCd',
            name: 'pgsStepCd',
            defaultValue: '<c:out value="${inputData.pgsStepCd}"/>',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PGS_STEP_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            autoMapping: true
        });


        //form 비활성화 여부
        var disableFields = function() {
            //연구소장 or GRS담당자
            if(pageRoleType == "S3" || pageRoleId == "TR05") {
                butTssNew.hide();
            }
        }

        /* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'wbsCd'}         //과제코드
                , { id: 'pkWbsCd'}       //wbs코드
                , { id: 'tssNm'}         //과제명
                , { id: 'prjNm'}         //소속명(프로젝트명)
                , { id: 'saUserName'}    //과제리더
                , { id: 'deptName'}      //조직
                , { id: 'ttlCrroStrtDt'} //과제기간시작
                , { id: 'ttlCrroFnhDt'}  //과제기간종료
                , { id: 'cmplNxStrtDd'}  //과제기간시작
                , { id: 'cmplNxFnhDd'}   //과제기간종료
                , { id: 'tssSt'}         //상태
                , { id: 'pgsStepNm'} 	 //처리상태
                , { id: 'tssNosStNm'}    //단계
                , { id: 'frstRgstDt'}    //최종실적등록일
                , { id: 'tssCd'}		 //과제코드
                , { id: 'myTss'}
                , { id: 'tssNosSt'}
            ]
        });


        /* [Grid] 컬럼설정 */
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  { field: 'wbsCd',         label: '과제코드', sortable: true, align:'center', width: 80, vMerge: true, renderer: function(value, p, record, row, col) {
                      var stepCd = record.get("pgsStepCd");
                      var tssNosSt = record.get("tssNosSt");
                      if(stepCd == "PL" && tssNosSt == "1 ") return "SEED-" + value;
                      return value;
                } }
                , { field: 'tssNm',         label: '과제명', sortable: true, align:'left', width: 240, vMerge: true }
                , { field: 'tssNosStNm',    label: '단계', sortable: true, align:'center', width: 80 , renderer: function(value, p, record, row, col){
                    if(record.get("myTss") == "Y") p.css.push('font-bold');
                    return "<a href='javascript:void(0);'><u>" + value + "<u></a>"; 
                } }
                , { field: 'prjNm',         label: '프로젝트명', sortable: true, align:'center', width: 110 } 
                , { field: 'saUserName',    label: '과제리더', sortable: true, align:'center', width: 70 }
                , { field: 'deptName',      label: '조직', sortable: true, align:'center', width: 110 }
                , { id: 'G1', label: '과제기간(계획일)' }
                , { field: 'ttlCrroStrtDt', label: '시작일', groupId: 'G1', sortable: true, align:'center', width: 90 }
                , { field: 'ttlCrroFnhDt',  label: '종료일', groupId: 'G1', sortable: true, align:'center', width: 90 }
                , { id: 'G2', label: '과제실적일' }
                , { field: 'cmplNxStrtDd',  label: '시작일', groupId: 'G2', sortable: true, align:'center', width: 90 }
                , { field: 'cmplNxFnhDd',   label: '종료일', groupId: 'G2', sortable: true, align:'center', width: 90 }
                , { field: 'pgsStepNm',     label: '상태', sortable: true, align:'center', width: 50 }
                , { field: 'tssSt',	        label: '처리상태', sortable: true, align:'center', width: 80, editor: tssSt, renderer: function(value, p, record, row, col) {
                    p.editable = false;
                    return value;
                } }
            ]
        });


        /* [Grid] 패널설정 */
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 500,
            useRightActionMenu: false,
            autoWidth: true
        });

        grid.on('cellClick', function(e) {
            if(e.colId == "tssNosStNm") {
                var pTssCd     = dataSet.getNameValue(e.row, "tssCd");     //과제코드
                var pPgsStepCd = dataSet.getNameValue(e.row, "pgsStepCd"); //진행상태코드
                var pTssSt     = dataSet.getNameValue(e.row, "tssSt");     //과제상태
                var pGrsEvSt   = dataSet.getNameValue(e.row, "grsEvSt");   //GRS상태

                //계획
                if(pPgsStepCd == "PL") {
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssPlnDetail.do?tssCd="+pTssCd+"'/>");
                }
                //진행
                else if(pPgsStepCd == "PG") {
                    if(pTssSt == "102") {
                        //진행_GRS완료_중단
                        if(pGrsEvSt == "D") {
                            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssDcacDetail.do?tssCd="+pTssCd+"'/>");
                        }
                        //진행_GRS완료_완료
                        else if(pGrsEvSt == "P2") {
                            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssCmplDetail.do?tssCd="+pTssCd+"'/>");
                        }
                        //진행_GRS완료_변경
                        else {
                            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssAltrDetail.do?tssCd="+pTssCd+"'/>");
                        }
                    } else {
                        nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssPgsDetail.do?tssCd="+pTssCd+"'/>");
                    }
                }
                //완료
                else if(pPgsStepCd == "CM") {
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssCmplDetail.do?tssCd="+pTssCd+"'/>");
                }
                //변경
                else if(pPgsStepCd == "AL") {
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssAltrDetail.do?tssCd="+pTssCd+"'/>");
                }
                //중단
                else if(pPgsStepCd == "DC") {
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssDcacDetail.do?tssCd="+pTssCd+"'/>");
                }
            }
        });

        grid.render('defaultGrid');

        /**
    	총 건수 표시
    	**/
    	dataSet.on('load', function(e){
    		var seatCnt = 0;
    	    var sumOrd = 0;
    	    var sumMoOrd = 0;
    	    var tmp;
    	    var tmpArray;
    		var str = "";

    		document.getElementById("cnt_text").innerHTML = '총: '+ dataSet.getCount();
    		
    		if( '${inputData._roleId}' == "WORK_IRI_T16" ){
            	deptName.setValue('${inputData._userDeptName}');
            	deptName.disable();
            }

    	});
        /* [버튼] 조회 */
        fnSearch = function() {
            dataSet.load({
                url: '<c:url value="/prj/tss/nat/retrieveNatTssList.do"/>'
              , params : {
                    wbsCd : document.aform.wbsCd.value                        //과제번호
                  , tssNm : encodeURIComponent(document.aform.tssNm.value)    //과제명
                  //, saSabunNew : document.aform.saSabunNew.value              //과제리더
                  //, deptCode : document.aform.deptCode.value                  //조직
                  , deptName : encodeURIComponent(document.aform.deptName.value)                  //조직
                  , ttlCrroStrtDt : nwinsReplaceAll(ttlCrroStrtDt.getValue(), "-","") //과제기간(시작일)
                  , ttlCrroFnhDt : nwinsReplaceAll(ttlCrroFnhDt.getValue(), "-","")   //과제기간(종료일)
                  , tssSt : document.aform.tssSt.value                        //상태
                  , pgsStepCd : document.aform.pgsStepCd.value				  //진행상태
                  , prjNm : encodeURIComponent(document.aform.prjNm.value)    //프로젝트명
                  , tssScnCd : "N" // 프로젝트 구분
                  , saUserName : encodeURIComponent(document.aform.saUserName.value)    //과제리더명
                }
            });
        };


        /* [버튼] 과제등록 */
        var butTssNew = new Rui.ui.LButton('butTssNew');
        butTssNew.on('click', function() {
            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/nat/natTssPlnDetail.do'/>");
        });


        /* [버튼] 엑셀 */
        var butExcel = new Rui.ui.LButton('butExcel');
        butExcel.on('click', function() {

            if(dataSet.getCount() > 0) {
                var excelColumnModel = columnModel.createExcelColumnModel(false);
                grid.saveExcel(encodeURIComponent('과제관리_국책과제') + new Date().format('%Y%m%d') + '.xls', {
                    columnModel: excelColumnModel
                });
            } else {
                Rui.alert("조회 후 엑셀 다운로드 해주세요.");
            }
        });
/* 
	    setDeptInfo = function(deptInfo) {
	    	deptName.setValue(deptInfo.deptNm);
	    };
 */

	    fnSearch();
	    disableFields();
	    
	    if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
    		$('#butTssNew').hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
    		$('#butTssNew').hide();
    	}
	    
    });
/* 
    //과제리더 팝업 셋팅
    function setLeaderInfo(userInfo) {
        saUserName.setValue(userInfo.saName);
        document.aform.saSabunNew.value = userInfo.saSabun;
    } */
</script>


</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>국책과제</h2>
	    </div>
        <div class="sub-content">
            <form name="aform" id="aform" method="post">
                <input type="hidden" id="deptCode" value="">
                <input type="hidden" id="saSabunNew" value="">
				<div class="search">
					<div class="search-content">
		                <table>
		                    <colgroup>
		                        <col style="width: 120px;" />
		                        <col style="width: 330px;" />
		                        <col style="width: 120px;" />
		                        <col style="width: 300px;" />
		                        <col style=" " />
		                    </colgroup>
		                    <tbody>
		                        <tr>
		                            <th>과제번호</th>
		                            <td><input type="text" id="wbsCd" /></td>
		                            <th>과제명</th>
		                            <td><input type="text" id="tssNm" /></td>
		                            <td></td>
		                        </tr>
		                        <tr>
		                            <th>과제리더</th>
		                            <td><input type="text" id="saUserName" /></td>
		                            <th>조직</th>
		                            <td><input type="text" id="deptName" /></td>
		                            <td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
		                        </tr>
		                        <tr>
		                            <th>과제기간</th>
		                            <td><input type="text" id="ttlCrroStrtDt" /><em class="gab"> ~ </em>
		                                <input type="text" id="ttlCrroFnhDt" /></td>
		                            <th>프로젝트명</th>
		                            <td>
		                                <input type="text" id="prjNm" />
		                            </td>
		                            <td></td>
		                        </tr>
		                        <tr>
		                            <th>상태</th>
		                            <td>
		                                <div id="pgsStepCd"></div>
		                            </td>
		                            <th>처리상태</th>
		                            <td>
		                                <div id="tssSt"></div>
		                            </td>
		                            <td></td>
		                        </tr>
		                    </tbody>
		                </table>
	                </div>
                </div>
            </form>

            <div class="titArea">
             	<span class="Ltotal" id="cnt_text">총 : 0 </span>
                <div class="LblockButton">
                    <button type="button" id="butTssNew" name="itemCreate" class="redBtn">과제등록</button>
                    <button type="button" id="butExcel" name="butExcel">EXCEL다운로드</button>
                </div>
            </div>

            <div id="defaultGrid"></div>

        </div>
    </div>
</body>
</html>