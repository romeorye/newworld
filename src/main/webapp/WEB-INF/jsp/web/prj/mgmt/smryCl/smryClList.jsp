<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : smryClList.jsp
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
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">
    //Form
    var wbsCd;
    var tssNm;
    var saSabunNew;
    var deptName;
    var tssStrtDd;
    var tssFnhDd;
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
        saSabunNew = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saSabunNew',
            defaultValue: '<c:out value="${inputData.saSabunNew}"/>',
            width: 200,
            editable: false,
            enterToPopup: true
        });
        saSabunNew.on('popup', function(e){
            saSabunNew.setValue('');
            document.aform.saSabunName.value = '';
            openUserSearchDialog(setLeaderInfo, 1, '');
        });
        saSabunNew.on('paste', function(e){
            document.aform.saSabunName.value = "";
        });
        saSabunNew.on('keyup', function(e){
            document.aform.saSabunName.value = "";
        });

        //조직
        deptName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'deptName',
            defaultValue: '<c:out value="${inputData.deptName}"/>',
            width: 200,
            editable: false,
            enterToPopup: true
        });
        deptName.on('popup', function(e){
            openDeptSearchDialog(setDeptInfo, 'prj');
        });

        //과제기간 시작일
        tssStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssStrtDd',
            defaultValue: '<c:out value="${inputData.tssStrtDd}"/>',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            width: 100,
            dateType: 'string'
        });
        tssStrtDd.on('blur', function() {
            if(tssStrtDd.getValue() == "") {
                return;
            }
            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(tssStrtDd.getValue(),"-","")))) {
                Rui.alert('날자형식이 올바르지 않습니다.!!');
                tssStrtDd.setValue(new Date());
            }
        });

        //과제기간 종료일
        tssFnhDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssFnhDd',
            defaultValue: '<c:out value="${inputData.tssFnhDd}"/>',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            width: 100,
            dateType: 'string'
        });
        tssFnhDd.on('blur', function() {
            if(tssFnhDd.getValue() == "") {
                return;
            }
            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(tssFnhDd.getValue(),"-","")))) {
                Rui.alert('날자형식이 올바르지 않습니다.!!');
                tssFnhDd.setValue(new Date());
            }
        });

        //상태
        tssSt = new Rui.ui.form.LCombo({
            applyTo: 'tssSt',
            name: 'tssSt',
            defaultValue: '<c:out value="${inputData.tssSt}"/>',
            useEmptyText: true,
            width: 150,
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


        /* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'wbsCd'}        //과제코드
                , { id: 'pkWbsCd'}      //wbs코드
                , { id: 'tssNm'}        //과제명
                , { id: 'prjNm'}        //소속명(프로젝트명)
                , { id: 'saUserName'}   //과제리더
                , { id: 'deptName'}     //조직
                , { id: 'tssStrtDd'}    //과제기간시작
                , { id: 'tssFnhDd'}     //과제기간종료
                , { id: 'cmplNxStrtDd'} //과제실적시작
                , { id: 'cmplNxFnhDd'}  //과제실적종료
                , { id: 'tssSt'}        //상태
                , { id: 'progressrate'} //진척율
                , { id: 'frstRgstDt'}   //최종실적등록일
                , { id: 'tssCd'}        //과제코드
                , { id: 'pgsStepCd'}    //진행단계코드
                , { id: 'grsEvSt'}      //GRS상태
                , { id: 'myTss'}
            ]
        });


        /* [Grid] 컬럼설정 */
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                  { field: 'wbsCd',        label: '과제코드', sortable: false, align:'center', width: 100, renderer: function(value, p, record, row, col) {
                        var stepCd = record.get("pgsStepCd");
                        if(stepCd == "PL") return "SEED-" + value;
                        return value;
                  }}
                , { field: 'tssNm',        label: '과제명', sortable: false, align:'left', width: 260 , renderer: function(value, p, record, row, col){
                    if(record.get("myTss") == "Y") p.css.push('font-bold');
                    return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                }}
                , { field: 'prjNm',        label: '소속명', sortable: false, align:'center', width: 200 }
                , { field: 'saUserName',   label: '과제리더', sortable: false, align:'center', width: 90 }
                , { field: 'deptName',     label: '조직', sortable: false, align:'center', width: 160 }
                , { id: 'G1', label: '과제기간(계획일)' }
                , { field: 'tssStrtDd',    label: '시작일', groupId: 'G1', sortable: false, align:'center', width: 90 }
                , { field: 'tssFnhDd',     label: '종료일', groupId: 'G1', sortable: false, align:'center', width: 90 }
                , { id: 'G2', label: '과제실적일' }
                , { field: 'cmplNxStrtDd', label: '시작일', groupId: 'G2', sortable: false, align:'center', width: 90 }
                , { field: 'cmplNxFnhDd',  label: '종료일', groupId: 'G2', sortable: false, align:'center', width: 90 }
                , { field: 'pgsStepCd',    label: '상태', sortable: false, align:'center', width: 70, editor: pgsStepCd, renderer: function(value, p, record, row, col) {
                    p.editable = false;
                    return value;
                } }
                , { field: 'tssSt',        label: '처리상태', sortable: false, align:'center', width: 85, editor: tssSt, renderer: function(value, p, record, row, col) {
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
            height: 400,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        grid.on('cellClick', function(e) {
            if(e.colId == "tssNm") {
                nwinsActSubmit(document.aform, "<c:url value='/prj/mgmt/smryCl/smryClDetail.do?tssCd="+dataSet.getNameValue(e.row, "tssCd")+"'/>");
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
        	// 목록 페이징
	    	paging(dataSet,"defaultGrid");
        });


        /* [버튼] 조회 */
        fnSearch = function() {
            dataSet.load({
                url: '<c:url value="/prj/mgmt/smryCl/retrieveSmryClList.do"/>'
              , params : {
                    wbsCd : document.aform.wbsCd.value                        //과제코드
                  , tssNm : encodeURIComponent(document.aform.tssNm.value)    //과제명
                  , saSabunNew : document.aform.saSabunName.value             //과제리더사번
                  , deptCode : document.aform.deptCode.value                  //조직
                  , tssStrtDd : nwinsReplaceAll(tssStrtDd.getValue(), "-","") //과제기간(시작일)
                  , tssFnhDd : nwinsReplaceAll(tssFnhDd.getValue(), "-","")   //과제기간(종료일)
                  , tssSt : document.aform.tssSt.value                        //상태
                  , prjNm : encodeURIComponent(document.aform.prjNm.value)    //프로젝트명
                  , saUserName : encodeURIComponent(saSabunNew.getValue())    //과제리더명
                  , pgsStepCd : document.aform.pgsStepCd.value                //상태
                }
            });
        };


        //fnSearch();
        init = function() {
        	   var wbsCd='${inputData.wbsCd}';
        	   var tssNm='${inputData.tssNm}';
        	   var saSabunNew='${inputData.saSabunNew}';
        	   var deptName='${inputData.deptName}';
        	   var prjNm='${inputData.prjNm}';
              	dataSet.load({
                    url: '<c:url value="/prj/mgmt/smryCl/retrieveSmryClList.do"/>',
                    params :{
                    	wbsCd : escape(encodeURIComponent(wbsCd)),
                    	tssNm : escape(encodeURIComponent(tssNm)),
                    	saSabunNew : escape(encodeURIComponent(saSabunNew)),
                    	deptName : escape(encodeURIComponent(deptName)),
                    	prjNm : escape(encodeURIComponent(prjNm)),
                    	tssStrtDd : '${inputData.tssStrtDd}',
                    	tssFnhDd : '${inputData.tssFnhDd}',
                    	pgsStepCd : '${inputData.pgsStepCd}',
                    	tssSt : '${inputData.tssSt}'
                    }
                });
            }
    });
</script>
<script>
//과제리더 팝업 셋팅
function setLeaderInfo(userInfo) {
    saSabunNew.setValue(userInfo.saName);
    document.aform.saSabunName.value = userInfo.saSabun;
}
function setDeptInfo(deptInfo) {
    deptName.setValue(deptInfo.upperDeptNm);
    document.aform.deptCode.value = deptInfo.upperDeptCd;
};
</script>
<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}" onload="init();">
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
        <div class="titleArea">
        	<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
            <h2>일반과제 개요 / 분류관리</h2>
        </div>

        <div class="sub-content">
            <form name="aform" id="aform" method="post">
            <input type="hidden" id="deptCode" value="">
            <input type="hidden" id="saSabunName" value="">

                <div class="search">
					<div class="search-content">
		   				<table>
		                    <colgroup>
		                        <col style="width:120px" />
								<col style="width:330px" />
								<col style="width:120px" />
								<col style="width:300px" />
								<col style="" />
		                    </colgroup>
		                    <tbody>
		                        <tr>
		                            <th>과제코드</th>
		                            <td>
		                                <input type="text" id="wbsCd" value="">
		                            </td>
		                            <th>과제명</th>
		                            <td>
		                                <input type="text" id="tssNm" value="">
		                            </td>
		                            <td></td>
		                        </tr>
		                        <tr>
		                            <th>과제리더</th>
		                            <td>
		                                <input type="text" id="saSabunNew" value="">
		                            </td>
		                            <th>조직</th>
		                            <td>
		                                <input type="text" id="deptName" value="">
		                            </td>
		                            <td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
		                        </tr>
		                        <tr>
		                            <th>과제기간</th>
		                            <td>
		                                <input type="text" id="tssStrtDd" /><em class="gab"> ~ </em><input type="text" id="tssFnhDd" />
		                            </td>
		                            <th>프로젝트명</th>
		                            <td>
		                                <input type="text" id="prjNm" value="">
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
                </div>
            </div>

            <div id="defaultGrid"></div>
        </div>
    </div>
</body>
</html>