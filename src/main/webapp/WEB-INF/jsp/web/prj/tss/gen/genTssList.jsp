<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : retrieveGenTssList.jsp
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LPager.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LPager-debug.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LPager.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<script type="text/javascript" src="/iris/resource/js/lgHs_common.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<style>
.font-bold div{
    font-weight: bold;
}

.LblockButton .progress{ float:left; display:-webkit-box; margin:10px 0;}
.LblockButton .progress li{color:#646464; font-size:12px; margin-right:10px; display: inline-block; height: 11px; line-height: 9px; border-radius:2px}
.LblockButton .progress li:nth-of-type(1){background:#69b3b7; font-size:8px; color:#fff; padding:0 3px;}
.LblockButton .progress li span{}
.LblockButton .progress li:last-child{margin-right:0;}
.LblockButton .progress_bg01{background:#6abd76; display:inline-block; border-radius:50px; width:11px; height:11px; display:inline-block; vertical-align:middle;}
.LblockButton .progress_bg02{background:#8bb6da; display:inline-block; border-radius:50px; width:11px; height:11px; display:inline-block; vertical-align:middle;}
.LblockButton .progress_bg03{background:#da8bb6; border-radius:50px; width:11px; height:11px; display:inline-block; vertical-align:middle;}

</style>

<script type="text/javascript">
    var pageRoleType = '${inputData.tssRoleType}';
    var pageRoleId   = '${inputData.tssRoleId}';

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
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            defaultValue: '<c:out value="${inputData.saUserName}"/>',
            width: 200
        });

        /*
        saSabunNew = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saSabunNew',
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
		*/

        //조직
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            defaultValue: '<c:out value="${inputData.deptName}"/>',
            width: 200
        });
		/*
        deptName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'deptName',
            width: 200,
            editable: false,
            enterToPopup: true
        });
        deptName.on('popup', function(e){
            openDeptSearchDialog(setDeptInfo, 'prj');
        });
 		*/
        //과제기간 시작일
        tssStrtDd = new Rui.ui.form.LMonthBox({
            applyTo: 'tssStrtDd',
            defaultValue: '<c:out value="${inputData.tssStrtDd}"/>',
            width: 100,
            dateType: 'string'
        });
       /*
        tssStrtDd.on('blur', function() {
            if(tssStrtDd.getValue() == "") {
                return;
            }
            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(tssStrtDd.getValue(),"-","")))) {
                Rui.alert('날자형식이 올바르지 않습니다.!!');
                //tssStrtDd.setValue(new Date());
            }
        });
 */
        //과제기간 종료일
        tssFnhDd = new Rui.ui.form.LMonthBox({
            applyTo: 'tssFnhDd',
            defaultValue: '<c:out value="${inputData.tssFnhDd}"/>',
            width: 100,
            dateType: 'string'
        });
     /*
        tssFnhDd.on('blur', function() {
            if(tssFnhDd.getValue() == "") {
                return;
            }
            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(tssFnhDd.getValue(),"-","")))) {
               //tssFnhDd.setValue(new Date());
            }
        });
 */
        //상태
        tssSt = new Rui.ui.form.LCombo({
            applyTo: 'tssSt',
            name: 'tssSt',
            emptyValue: '',
            useEmptyText: true,
            width: 150,
            defaultValue: '<c:out value="${inputData.tssSt}"/>',
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_ST"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            autoMapping: true
        });
        tssSt.getDataSet().on('load', function(e) {
             var tssStDs = tssSt.getDataSet();

            for(var i = tssStDs.getCount(); i > -1; i--) {
                if(stringNullChk(tssStDs.getNameValue(i, "COM_DTL_CD")).substr(0,1) == "5") {
                    tssStDs.removeAt(i);
                }
            }
        });

        //프로젝트명
        prjNm = new Rui.ui.form.LTextBox({
            applyTo: 'prjNm',
            defaultValue: '<c:out value="${inputData.prjNm}"/>',
            width: 200
        });

        //진행상태
        pgsStepCd = new Rui.ui.form.LCombo({
            applyTo: 'pgsStepCd',
            name: 'pgsStepCd',
            emptyValue: '',
            useEmptyText: true,
            defaultValue: '<c:out value="${inputData.pgsStepCd}"/>',
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
                , { id: 'progressrateReal'} //진척율
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
                  { field: 'wbsCd',      label: '과제코드', sortable: true, align:'center', width: 90, renderer: function(value, p, record, row, col) {
                        var stepCd = record.get("pgsStepCd");
                        if(stepCd == "PL") return "SEED-" + value;
                        return value;
                  }}
                , { field: 'tssNm',        label: '과제명', sortable: true, align:'left', width: 280 , renderer: function(value, p, record, row, col){
                    if(record.get("myTss") == "Y") p.css.push('font-bold');
                    return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                }}
                , { field: 'prjNm',        label: '프로젝트명', sortable: true, align:'center', width: 160 }
                , { field: 'saUserName',   label: '과제리더', sortable: true, align:'center', width: 80 }
                , { field: 'deptName',     label: '조직', sortable: true, align:'center', width: 109 }
                , { id: 'G1', label: '과제기간(계획일)' }
                , { field: 'tssStrtDd',    label: '시작일', groupId: 'G1', sortable: true, align:'center', width: 80 }
                , { field: 'tssFnhDd',     label: '종료일', groupId: 'G1', sortable: true, align:'center', width: 80 }
                , { id: 'G2', label: '과제실적일' }
                , { field: 'cmplNxStrtDd', label: '시작일', groupId: 'G2', sortable: true, align:'center', width: 80 }
                , { field: 'cmplNxFnhDd',  label: '종료일', groupId: 'G2', sortable: true, align:'center', width: 80 }
                , { field: 'pgsStepCd',    label: '상태', sortable: true, align:'center', width: 60, editor: pgsStepCd, renderer: function(value, p, record, row, col) {
                    p.editable = false;
                    return value;
                } }
                , { field: 'tssSt',        label: '처리상태', sortable: true, align:'center', width: 80, editor: tssSt, renderer: function(value, p, record, row, col) {
                    p.editable = false;
                    return value;
                } }
                , { field: 'progressrateReal', label: '진척율<br>(실적/계획)', sortable: true, align:'center', width: 80 }
                , { id: 'pg', label: '진척도', align:'center', width: 50 ,renderer :function(value, p, record, row, col) {

                    var pgN =' <img src="<%=contextPath%>/resource/images/icon/sign_green.png"/> ';
                    var pgS =' <img src="<%=contextPath%>/resource/images/icon/sign_blue.png"/> ';
                    var pgD =' <img src="<%=contextPath%>/resource/images/icon/sign_red.png"/> ';

                    var progressrate= record.get('progressrate');

                    var arrPrg = progressrate.split('/')

                    var rWgvl = floatNullChk(arrPrg[0]) ; // 실적
                    var gWgvl  = floatNullChk(arrPrg[1]) ; //목표

                    var pg = pgN ;

                    if(rWgvl > gWgvl){
                        pg = pgS ;
                    }else if(rWgvl < gWgvl){
                        pg = pgD ;
                    }else if(rWgvl = gWgvl){
                        pg = pgN ;
                    }
                    var pgsStepCd= record.get('pgsStepCd');

                    if(pgsStepCd=='PL'){
                    	pg = '';
                    }
                    return pg;
                }}
            ]
        });

        /* [Grid] 패널설정 */
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 1210,
            height: 400,
			autoWidth: true
        });
/*
        var pager = new Rui.ui.LPager({
            gridPanel: grid,
            pageSize: 10
        });

        pager.on('changed', function(e){
            Rui.alert('Page No. ' + e.startRowIndex);
        });

        pager.render();
         */
        grid.render('defaultGrid');



        grid.on('cellClick', function(e) {


            if(e.colId == "tssNm") {
                var pTssCd     = dataSet.getNameValue(e.row, "tssCd");     //과제코드
                var pPgsStepCd = dataSet.getNameValue(e.row, "pgsStepCd"); //진행상태코드
                var pTssSt     = dataSet.getNameValue(e.row, "tssSt");     //과제상태
                var pGrsEvSt   = stringNullChk(dataSet.getNameValue(e.row, "grsEvSt")); //GRS상태

                //진척률
                var progressrateReal = dataSet.getNameValue(e.row, "progressrateReal");
                var progressrate = dataSet.getNameValue(e.row, "progressrate");

                var arrPrg = progressrate.split('/')

                var rWgvl = numberNullChk(arrPrg[0]) ; //실적
                var gWgvl = numberNullChk(arrPrg[1]) ; //목표

                if(rWgvl > gWgvl){
                	progressrate = "S";
                }else if(rWgvl < gWgvl){
                	rWgvl = rWgvl+3;

                	if( rWgvl < gWgvl ){
	                	progressrate = "D";
                	}else{
	                	progressrate = "N";
                	}

                }else if(rWgvl = gWgvl){
                	progressrate = "N";
                }

                var urlParam = "?tssCd="+pTssCd+"&progressrateReal="+progressrateReal+"&progressrate="+progressrate;

                //계획
                if(pPgsStepCd == "PL") {
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssPlnDetail.do?tssCd="+pTssCd+"'/>");
                }
                //진행
                else if(pPgsStepCd == "PG") {
                    if(pTssSt == "102") {
                        //진행_GRS완료_중단
                        if(pGrsEvSt == "D") {
                            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssDcacDetail.do'/>"+urlParam);
                        }
                        //진행_GRS완료_완료
                        else if(pGrsEvSt == "P2") {
                            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssCmplDetail.do'/>"+urlParam);
                        }
                        //진행_GRS완료_변경
                        else {
                            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssAltrDetail.do'/>"+urlParam);
                        }
                    } else {
                        nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssPgsDetail.do'/>"+urlParam);
                    }
                }
                //완료
                else if(pPgsStepCd == "CM") {
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssCmplDetail.do'/>"+urlParam);
                }
                //변경
                else if(pPgsStepCd == "AL") {
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssAltrDetail.do?tssCd="+pTssCd+"'/>");
                }
                //중단
                else if(pPgsStepCd == "DC") {
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssDcacDetail.do'/>"+urlParam);
                }
            }
        });


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
                url: '<c:url value="/prj/tss/gen/retrieveGenTssList.do"/>'
              , params : {
                    wbsCd : document.aform.wbsCd.value                        //과제번호
                  , tssNm : encodeURIComponent(document.aform.tssNm.value)    //과제명
                  , deptName : encodeURIComponent(document.aform.deptName.value)                  //조직
                  , tssStrtDd : tssStrtDd.getValue() //과제기간(시작일)
                  , tssFnhDd : tssFnhDd.getValue()   //과제기간(종료일)
                  , tssSt : tssSt.getValue()                        //상태
//                  , tssSt : document.aform.tssSt.value                        //상태
                  , prjNm : encodeURIComponent(document.aform.prjNm.value)    //프로젝트명
                  , saUserName : encodeURIComponent(document.aform.saUserName.value)    //과제리더명
                  , pgsStepCd : document.aform.pgsStepCd.value                //상태
                }
            });
        };

        /* [버튼] 과제등록 */
        var butTssNew = new Rui.ui.LButton('butTssNew');
        butTssNew.on('click', function() {
            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/gen/genTssPlnDetail.do'/>");
        });


        /* [버튼] 엑셀 */
        var butExcel = new Rui.ui.LButton('butExcel');
        butExcel.on('click', function() {

            if(dataSet.getCount() > 0) {
               /*  var excelColumnModel = columnModel.createExcelColumnModel(false);
                grid.saveExcel(encodeURIComponent('과제관리_일반과제_') + new Date().format('%Y%m%d') + '.xls', {
                    columnModel: excelColumnModel
                }); */

            	var excelColumnModel = new Rui.ui.grid.LColumnModel({
                    gridView: columnModel,
                    columns: [
                    	 { field: 'wbsCd',      label: '과제코드', sortable: true, align:'center', width: 85, renderer: function(value, p, record, row, col) {
                             var stepCd = record.get("pgsStepCd");
                             if(stepCd == "PL") return "SEED-" + value;
                             return value;
                       }}
                     , { field: 'tssNm',        label: '과제명', sortable: true, align:'left', width: 240 , renderer: function(value, p, record, row, col){
                         if(record.get("myTss") == "Y") p.css.push('font-bold');
                         return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                     }}
                     , { field: 'prjNm',        label: '프로젝트명', sortable: true, align:'center', width: 120 }
                     , { field: 'saUserName',   label: '과제리더', sortable: true, align:'center', width: 80 }
                     , { field: 'deptName',     label: '조직', sortable: true, align:'center', width: 100 }
                     , { id: 'G1', label: '과제기간(계획일)' }
                     , { field: 'tssStrtDd',    label: '시작일', groupId: 'G1', sortable: true, align:'center', width: 73 }
                     , { field: 'tssFnhDd',     label: '종료일', groupId: 'G1', sortable: true, align:'center', width: 73 }
                     , { id: 'G2', label: '과제실적일' }
                     , { field: 'cmplNxStrtDd', label: '시작일', groupId: 'G2', sortable: true, align:'center', width: 73 }
                     , { field: 'cmplNxFnhDd',  label: '종료일', groupId: 'G2', sortable: true, align:'center', width: 73 }
                     , { field: 'pgsStepCd',    label: '상태', sortable: true, align:'center', width: 50, editor: pgsStepCd, renderer: function(value, p, record, row, col) {
                         p.editable = false;
                         return value;
                     } }
                     , { field: 'tssSt',        label: '처리상태', sortable: true, align:'center', width: 80, editor: tssSt, renderer: function(value, p, record, row, col) {
                         p.editable = false;
                         return value;
                     } }
                     , { id: 'G3', label: '현재 진척율' }
                     , { id: 'progressrateReal', groupId: 'G3', label: '계획', sortable: true, align:'center', width: 65, renderer :function(value, p, record, row, col) {
                    	 var arrPrg = record.get("progressrateReal").split('/');

                    	 return arrPrg[1];
                     } }
                     , { id: 'progressrateReal1', groupId: 'G3', label: '실적', sortable: true, align:'center', width: 65, renderer :function(value, p, record, row, col) {
                    	 var arrPrg = record.get("progressrateReal").split('/');

                    	 return arrPrg[0];
                     } }

                     , { id: 'pg', label: '진척도', align:'center', width: 70 ,renderer :function(value, p, record, row, col) {

                         var pgN ="달성";
                         var pgS ="초과";
                         var pgD ="미달";

                         var progressrate= record.get('progressrateReal');

                         var arrPrg = progressrate.split('/')

                         var rWgvl = floatNullChk(arrPrg[0]) ; // 실적
                         var gWgvl  = floatNullChk(arrPrg[1]) ; //목표

                         var pg = pgN ;

                         if(rWgvl > gWgvl){
                             pg = pgS ;
                         }else if(rWgvl < gWgvl){
                         	rWgvl = rWgvl+3;

                         	if( rWgvl < gWgvl ){
     	                    	pg = pgD ;
                         	}else{
     	                        pg = pgN ;
                         	}
                         }else if(rWgvl = gWgvl){
                             pg = pgN ;
                         }

                         var pgsStepCd= record.get('pgsStepCd');

                         if(pgsStepCd=='PL'){
                         	pg = '';
                         }
                         return pg;
                     }}
                 ]
             });

		        grid.saveExcel(encodeURIComponent('과제관리_일반과제_') + new Date().format('%Y%m%d') + '.xls', {
		            columnModel: excelColumnModel
		        });








            } else {
                Rui.alert("조회 후 엑셀 다운로드 해주세요.");
            }
        });


        fnSearch();
        disableFields();

        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butTssNew").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butTssNew").hide();
		}
    });
</script>
<script>
//과제리더 팝업 셋팅
/*
function setLeaderInfo(userInfo) {
    saSabunNew.setValue(userInfo.saName);
    document.aform.saSabunName.value = userInfo.saSabun;
}
function setDeptInfo(deptInfo) {
    deptName.setValue(deptInfo.upperDeptNm);
    document.aform.deptCode.value = deptInfo.upperDeptCd;
};
 */
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
            <h2>일반 과제관리</h2>
			<!-- 전체메뉴 -->
            <div class="menu_btn">
               <a href="#">전체메뉴</a>
		    	<div id="tmpMenu" class="allmneu" style="position: absolute;z-index: 999; width:800px; background:  #fff;top:26px;border:  1px solid #ccc;padding: 20px; right:0;">
					<div><input type="button" value="닫기" onclick="hideTmpMenu()"></div>
					<div id="horizontalContainer" style="float: none">
						<span id="m01" style="float: left;margin-right: 20px;"><strong><br>Project<br></strong><u><a href="/iris/prj/main.do">Main</a></u><br><strong><br>연구팀(Project)<br></strong>현황<br>월마감<br><strong><br>GRS<br></strong><u><a href="/iris/prj/grs//listGrsMngInfo.do">GRS관리</a></u><br><strong><br>과제관리<br></strong>일반과제<br>대외협력과제<br>국책과제<br><u><a href="/iris/prj/tss/tctm/tctmTssList.do">기술팀과제</a></u><br>O/I협력과제<br>RFP요청관리<br>결재현황<br><strong><br>M/M관리<br></strong>M/M입력<br>M/M마감<br><strong><br>관리<br></strong>신제품코드매핑<br>표준WBS관리<br>GRS템플릿관리<br>투입예산관리<br>조직코드약어관리<br>일반과제개요/분류관리<br></span>
						<span id="m02" style="float: left;margin-right: 20px;"><strong><br>Technical Service<br></strong><u><a href="/iris/anl/main.do">Main</a></u><br><strong><br>기기분석<br></strong>분석의뢰<br>분석목록<br>자료실<br>안내<br><strong><br>신뢰성시험<br></strong><u><a href="/iris/rlab/rlabRqprList.do">시험의뢰</a></u><br><u><a href="/iris/rlab/rlabRqprList4Chrg.do">시험목록</a></u><br><u><a href="/iris/rlab/lib/retrieveRlabLibList.do">자료실</a></u><br><u><a href="/iris/rlab/gid/rlabSphereInfo.do">안내</a></u><br><strong><br>공간평가<br></strong><u><a href="/iris/space/spaceRqprList.do">평가의뢰</a></u><br><u><a href="/iris/space/spaceRqprList4Chrg.do">평가목록</a></u><br><u><a href="/iris/space/spacePfmcMst.do">성능 Master</a></u><br><u><a href="/iris/space/lib/retrieveSpaceLibList.do">자료실</a></u><br><u><a href="/iris/space/gid/spaceSphereInfo.do">안내</a></u><br><strong><br>통합게시판<br></strong><u><a href="/iris/anl/bbs/retrieveAnlBbsList.do">공지사항</a></u><br><u><a href="/iris/anl/bbs/retrieveAnlQnaList.do">Q&amp;A</a></u><br><strong><br>관리<br></strong>기기분석 시험정보관리<br><u><a href="/iris/rlab/rlabExprList.do">신뢰성 시험정보관리</a></u><br><u><a href="/iris/space/spaceExatList.do">공간평가 시험정보관리</a></u><br><u><a href="/iris/space/spaceEvaluationMgmt.do">공간평가 평가법관리</a></u><br></span>
						<span id="m03" style="float: left;margin-right: 20px;"><strong><br>Instrument<br></strong><strong><br>분석기기<br></strong>보유 기기<br>기기 교육<br><strong><br>신뢰성시험 장비<br></strong><u><a href="/iris/mchn/open/rlabMchn/retrieveMachineList.do">보유 장비</a></u><br><strong><br>공간성능평가 Tool<br></strong>보유 TOOL<br><strong><br>관리<br></strong>분석기기 예약관리<br><u><a href="/iris/mchn/mgmt/retrieveRlabTestEqipPrctMgmtList.do">신뢰성시험장비 예약관리</a></u><br><u><a href="/iris/mchn/mgmt/spaceEvToolUseMgmtList.do">공간평가Tool 사용관리</a></u><br>분석기기 교육관리<br>소모품 관리<br><u><a href="/iris/mchn/mgmt/rlabTestEqipList.do">신뢰성시험 장비관리</a></u><br>분석기기 관리<br>신뢰성시험 장비관리<br><u><a href="/iris/mchn/mgmt/retrieveSpaceEvToolList.do">공간성능평가 Tool관리</a></u><br></span>
						<span id="m04" style="float: left;margin-right: 20px;"><strong><br>Fixed Assets<br></strong><strong><br>고정자산<br></strong>자산관리<br>자산이관목록<br>자산실사<br>자산폐기<br>실사기간관리<br>자산담당자관리<br></span>
						<span id="m05" style="float: left;margin-right: 20px;"><strong><br>Knowledge<br></strong><strong><br>공지/게시판<br></strong>공지사항<br>시장/기술정보<br>교육/세미나<br>학회/컨퍼런스<br>전시회<br>특허<br>표준양식<br>특허정보 리스트<br>안전/환경/보건<br>규정/업무Manual<br>사외전문가<br>연구소주요일정<br><strong><br>Q&amp;A<br></strong>Group R&amp;D<br>일반 Q&amp;A<br><strong><br>연구산출물<br></strong>고분자재료 Lab<br>점착기술 Lab<br>무기소재 Lab<br>코팅기술 Lab<br>연구소  공통<br>LG화학 연구소<br>LG화학 테크센터<br>LG하우시스 연구소<br></span>
						<span id="m05" style="float: left;margin-right: 20px;"></span>
						<span id="m06" style="float: left;margin-right: 20px;"><strong><br>Statistics<br></strong><strong><br>연구과제<br></strong>프로젝트통계<br>일반과제통계<br>대외협력과제통계<br>국책과제통계<br>포트폴리오<br>신제품매출실적<br><strong><br>기기분석<br></strong>분석완료<br>분석 기기사용<br>OPEN 기기사용<br>분석 업무현황<br>사업부 통계<br>담당자 분석통계<br><strong><br>신뢰성시험<br></strong>연도별 통계<br>기간별 통계<br>장비사용 통계<br><strong><br>공간평가<br></strong>통계1<br>통계2<br>통계3<br>통계4<br>통계5<br><strong><br>관리<br></strong>공통코드관리<br></span>
					</div>
				</div>
           	</div>
           	<!-- //전체메뉴 -->
        </div>

        <div class="sub-content">
            <form name="aform" id="aform" method="post">
            <input type="hidden" id="deptCode" value="">
                <div class="search">
                <div class="search-content">
                    <form name="aform" id="aform" method="post">
			            <input type="hidden" id="deptCode" value="">
			                <table>
			                    <colgroup>
                                    <col width="120px">
                                    <col width="400px">
                                    <col width="110px">
                                    <col width="200px">
                                    <col width="*">
                                </colgroup>
			                    <tbody>
			                        <tr>
			                            <th>과제번호</th>
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
			                                <input type="text" id="saUserName" value="">
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
			            </form>
					</div>
            	</div>
	            <div class="titArea">
	                <span class="Ltotal" id="cnt_text">총 : 0 </span>
	                <div class="LblockButton">
	                    <ul class="progress">
	                        <li>진척도</li>
	                        <li><span class="progress_bg01"></span>정상</li>
	                        <li><span class="progress_bg02"></span>단축</li>
	                        <li><span class="progress_bg03"></span>지연&nbsp;&nbsp;&nbsp;<b>( 진척률:실시간, 진척도:전월실적기준 )</b></li>
	                    </ul>
	                    &nbsp;&nbsp;
	                    <button type="button" id="butTssNew" name="itemCreate" class="redBtn">과제등록</button>

	                    <button type="button" id="butExcel" name="butExcel">EXCEL다운로드</button>
	                </div>
	            </div>

           		<div id="defaultGrid"></div>


            <!-- radio check Test -->
            <div>
            	<p style="font-size:20px; margin-bottom:10px;">radio check Test<p>
            	<p>
            		<label class="radio-inline">
                       <input type="radio" name="s_rdo" checked="checked">
                       <ins class="form-control"></ins>
                       <span>Radio</span>
                   </label>
                   <label class="radio-inline">
                       <input type="radio" name="s_rdo">
                       <ins class="form-control"></ins>
                       <span>Radio</span>
                   </label>
                </p>
                <p>
                	<label class="checkbox-inline">
                        <input type="checkbox" id="s_chk01" name="s_chk">
                        <ins class="form-control"></ins>
                        <span>Check1</span>
                    </label>
                    <label class="checkbox-inline">
                        <input type="checkbox" name="s_chk">
                        <ins class="form-control"></ins>
                        <span>Check2</span>
                    </label>
                </p>
            </div>
			<!-- //radio check Test -->
        </div>
    </div>
</body>
</html>