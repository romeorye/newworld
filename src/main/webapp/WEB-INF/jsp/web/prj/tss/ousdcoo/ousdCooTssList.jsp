<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssList.jsp
 * @desc    : 대외협력 과제관리 목록조회 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.14  IRIS04		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script><!-- Lgrid view -->
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>

<style>
.font-bold div{
    font-weight: bold;
}
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
        //wbsCd
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            placeholder: '',
            defaultValue: '<c:out value="${inputData.wbsCd}"/>',
            emptyValue: '',
            width: 200,
            attrs: {
    				maxLength: 11
    			   }
        });
        wbsCd.on('blur', function(e) {
        	wbsCd.setValue(wbsCd.getValue().trim());
        });


        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            placeholder: '',
            defaultValue: '<c:out value="${inputData.tssNm}"/>',
            emptyValue: '',
            width: 200
        });
        tssNm.on('blur', function(e) {
        	tssNm.setValue(tssNm.getValue().trim());
        });

        //과제리더
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            placeholder: '',
            defaultValue: '<c:out value="${inputData.saUserName}"/>',
            emptyValue: '',
            width: 200
        });

        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            placeholder: '',
            defaultValue: '<c:out value="${inputData.deptName}"/>',
            emptyValue: '',
            width: 200
        });
        /*
        saSabunNew = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saSabunNew',
            width: 200,
            editable: false,
            placeholder: '과제리더를 선택해주세요',
            emptyValue: '',
            enterToPopup: true
        });
        tssNm.on('blur', function(e) {
        	saSabunNew.setValue(saSabunNew.getValue().trim());
        });
        saSabunNew.on('popup', function(e){
        	saSabunNew.setValue('');
        	document.aform.saSabunName.value = '';
            openUserSearchDialog(setLeaderInfo, 1, '');
        });
        setLeaderInfo = function(userInfo) {
            saSabunNew.setValue(userInfo.saName);
            document.aform.saSabunName.value = userInfo.saSabun;
        }
	*/
        //조직
        /*
        deptName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'deptName',
            width: 200,
            editable: false,
            placeholder: '조직을 선택해주세요',
            emptyValue: '',
            enterToPopup: true
        });
        deptName.on('blur', function(e) {
        	deptName.setValue(deptName.getValue().trim());
        });
        deptName.on('popup', function(e){
        	deptName.setValue('');
        	document.aform.deptUper.value = '';
        	openDeptSearchDialog(setDeptInfo, 'prj');
        });
        setDeptInfo = function(deptInfo) {
	    	deptName.setValue(deptInfo.upperDeptNm);
	    	aform.deptUper.value = deptInfo.upperDeptCd;
	    };
	*/
        //과제기간 시작일
         tssStrtDd = new Rui.ui.form.LMonthBox({
            applyTo: 'tssStrtDd',
            defaultValue: '<c:out value="${inputData.tssStrtDd}"/>',
            width: 100,
            dateType: 'string'
        });
       /*  tssStrtDd.on('blur', function() {
            if(tssStrtDd.getValue() == "") {
                return;
            }
            if( nwinsReplaceAll(tssStrtDd.getValue(),"-","") != "" &&  !Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(tssStrtDd.getValue(),"-","")))) {
                alert('날짜형식이 올바르지 않습니다.!!');
                tssStrtDd.setValue(new Date());
            }
        }); */

        //과제기간 종료일
        tssFnhDd = new Rui.ui.form.LMonthBox({
            applyTo: 'tssFnhDd',
            defaultValue: '<c:out value="${inputData.tssFnhDd}"/>',
            width: 100,
            dateType: 'string'
        });
       /*  tssFnhDd.on('blur', function() {
            if(tssFnhDd.getValue() == "") {
                return;
            }
            if( nwinsReplaceAll(tssFnhDd.getValue(),"-","") != "" && !Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(tssFnhDd.getValue(),"-","")))) {
                alert('날짜형식이 올바르지 않습니다.!!');
                tssFnhDd.setValue(new Date());
            }
        }); */

        //상태
        tssSt = new Rui.ui.form.LCombo({
            applyTo: 'tssSt',
            name: 'tssSt',
            useEmptyText: true,
            emptyText: '(전체)',
            emptyValue: '',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_ST"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            defaultValue: '<c:out value="${inputData.tssSt}"/>',
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

        //과제명
        prjNm = new Rui.ui.form.LTextBox({
            applyTo: 'prjNm',
            placeholder: '',
            defaultValue: '<c:out value="${inputData.prjNm}"/>',
            emptyValue: '',
            width: 200
        });
        prjNm.on('blur', function(e) {
        	prjNm.setValue(prjNm.getValue().trim());
        });

        //진행상태
        pgsStepCd = new Rui.ui.form.LCombo({
            applyTo: 'pgsStepCd',
            name: 'pgsStepCd',
            useEmptyText: true,
            defaultValue: '<c:out value="${inputData.pgsStepCd}"/>',
            emptyText: '(전체)',
            emptyValue: '',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PGS_STEP_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            autoMapping: true
        });
        pgsStepCd.getDataSet().on('load', function(e) {
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
            	  { id: 'tssCd' }       //과제코드
                , { id: 'wbsCd'}        //WBS코드
                , { id: 'pkWbsCd'}      //WBS코드(PK)
                , { id: 'tssNm'}        //과제명
                , { id: 'prjNm'}        //소속명(프로젝트명)
                , { id: 'saUserName'}   //과제리더
                , { id: 'deptName' }    //조직명
                , { id: 'uperdeptName'} //상위조직명
                , { id: 'tssStrtDd'}    //과제기간시작
                , { id: 'tssFnhDd'}     //과제기간종료
                , { id: 'cmplNxStrtDd'} //과제실적시작
                , { id: 'cmplNxFnhDd'}  //과제실적종료
                , { id: 'tssSt'}        //상태
                , { id: 'progressrate'} //진척율
                , { id: 'frstRgstDt'}   //최종실적등록일
                , { id: 'tssCd'}        //과제코드
                , { id: 'pgsStepCd'}    //진행상태코드
                , { id: 'pgsStepNm'}    //진행상태명
                , { id: 'grsEvSt'}      //GRS상태
                , { id: 'myTss'}
                , { id: 'dcacBStrtDd'} //중단전시작일
                , { id: 'dcacBFnhDd'}  //중단전종료일
                , { id: 'cmplBStrtDd'} //완료전시작일
                , { id: 'cmplBFnhDd'}  //완료전종료일
                , { id: 'rsstExp', defaultValue : 0}           //연구비(원)
                , { id: 'rsstExpConvertMil', defaultValue : 0} //연구비(억원)
                , { id: 'arslExp', defaultValue : 0}           //실적연구비(원)
                , { id: 'arslExpConvertMil', defaultValue : 0} //실적연구비(억원)
                // , { id: 'qgateStepNm'}
            ]
        });

        /* [Grid] 컬럼설정 */
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                 { field: 'wbsCd',        label: '과제코드' , sortable: true, align:'center', width: 100
                	  , renderer: function(value, p, record, row, col) {
                		  var stepCd = record.get("pgsStepCd");
                		  if(stepCd == "PL"){ return "SEED-" + value; }
				          return value;
                    } }
                , { field: 'tssNm',        label: '과제명'   , sortable: true, align:'left', width: 250
                	, renderer: function(value, p, record, row, col){
                        if(record.get("myTss") == "Y") p.css.push('font-bold');
                		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                	}
                  }
                , { field: 'prjNm',        label: '프로젝트명'   , sortable: true, align:'center', width: 200 }
                , { field: 'saUserName',   label: '과제리더' , sortable: true, align:'center', width: 70 }
                , { field: 'deptName',     label: '조직'     , sortable: true, align:'center', width: 110 }
                , { id: 'G1', label: '과제기간(계획일)' }
                , { field: 'tssStrtDd',    label: '시작일', groupId: 'G1', sortable: true, align:'center', width: 90 }
                , { field: 'tssFnhDd',     label: '종료일', groupId: 'G1', sortable: true, align:'center', width: 90 }
                , { id: 'G2', label: '과제실적일' }
                , { field: 'cmplBStrtDd',    label: '시작일', groupId: 'G2', sortable: true, align:'center', width: 80
                	, renderer: function(value, p, record, row, col){
                		if( record.get("pgsStepCd") == "DC" ){
                			return record.get("dcacBStrtDd");
                		}
                		return value;
                	  }
                  }
                , { field: 'cmplBFnhDd',    label: '종료일', groupId: 'G2', sortable: true, align:'center', width: 73
                	, renderer: function(value, p, record, row, col){
                		if( record.get("pgsStepCd") == "DC" ){
                			return record.get("dcacBFnhDd");
                		}
                		return value;
                	  }
                  }

                , { field: 'rsstExpConvertMil',        label: '총연구비<BR>(억원)'   , sortable: true, align:'right', width: 70 }
                , { field: 'arslExpConvertMil',        label: '누적실적<BR>(억원)'   , sortable: true, align:'right', width: 70 }
                , { field: 'pgsStepNm',    label: '상태'     , sortable: true, align:'center', width: 52, editor: pgsStepCd, renderer: function(value, p, record, row, col) {
                        p.editable = false;
                        return value;
                    } }
                , { field: 'tssSt',        label: '처리상태', sortable: true, align:'center', width: 70, editor: tssSt, renderer: function(value, p, record, row, col) {
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

        grid.render('defaultGrid');

         grid.on('cellClick', function(e) {
        	 if(e.colId == "tssNm") {
                var pTssCd     = dataSet.getNameValue(e.row, "tssCd");     //과제코드
                var pPgsStepCd = dataSet.getNameValue(e.row, "pgsStepCd"); //진행상태코드
                var pTssSt     = dataSet.getNameValue(e.row, "tssSt");     //과제상태
                var pGrsEvSt   = dataSet.getNameValue(e.row, "grsEvSt");   //GRS상태
                var pWbsCd     = dataSet.getNameValue(e.row, "wbsCd");     //WBS코드
				
                var urlParam = "?tssCd="+pTssCd+"&wbsCd="+pWbsCd;
                
                //계획
                if(pPgsStepCd == "PL") {
                	console.log('이동 : 계획_상세(수정)');
                	nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssPlnDetail.do'/>"+urlParam);
                	/* nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssPlnDetail.do?tssCd="+pTssCd+"'/>"); */
                }
                //진행
                 else if(pPgsStepCd == "PG") {
                    if(pTssSt == "102" || pTssSt == "301" || pTssSt == "302") {
                        //진행_GRS완료_중단(신규등록)
                        if(pGrsEvSt == "D") {
                        	console.log('이동 : 진행_GRS완료_중단(신규등록)');
                        	nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssDcacDetail.do'/>"+urlParam);
                        	/* nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssDcacDetail.do?tssCd="+pTssCd+"'/>"); */
                        }
                        //진행_GRS완료_완료(신규등록)
                        else if(pGrsEvSt == "G2") {
                        	console.log('이동 : 진행_GRS완료_완료(신규등록)');
                        	nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssCmplDetail.do'/>"+urlParam);
                            /* nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssCmplDetail.do?tssCd="+pTssCd+"'/>"); */
                        }
                        //진행_GRS완료_변경(신규등록)
                        else {
                        	console.log('진행_GRS완료_변경(신규등록)');
                        	nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrDetail.do'/>"+urlParam);
                            /* nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrDetail.do?tssCd="+pTssCd+"'/>"); */
                        }
                    } else {
                    	console.log('이동 : 진행_상세(수정)');
                        nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsDetail.do'/>"+urlParam);
                        /* nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssPgsDetail.do?tssCd="+pTssCd+"'/>"); */
                    }
                }
                //완료(조회 및 수정)
                else if(pPgsStepCd == "CM") {
                	console.log('이동 : 완료(조회 및 수정)');
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssCmplDetail.do'/>"+urlParam);
                    /* nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssCmplDetail.do?tssCd="+pTssCd+"'/>"); */
                }
                //변경(조회 및 수정)
                else if(pPgsStepCd == "AL") {
                	console.log('이동 : 변경(조회 및 수정)');
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrDetail.do'/>"+urlParam);
                    /* nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssAltrDetail.do?tssCd="+pTssCd+"'/>"); */
                }
                //중단(조회 및 수정)
                else if(pPgsStepCd == "DC") {
                	console.log('이동 : 중단(조회 및 수정)');
                    nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssDcacDetail.do'/>"+urlParam);
                    /* nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssDcacDetail.do?tssCd="+pTssCd+"'/>"); */
                }
            }
        	 
        });

        var gridView = grid.getView();

        /** 총 건수 표시 **/
    	dataSet.on('load', function(e){
    		var seatCnt = 0;
    	    var sumOrd = 0;
    	    var sumMoOrd = 0;
    	    var tmp;
    	    var tmpArray;
    		var str = "";

    		document.getElementById("cnt_text").innerHTML = '총: '+ dataSet.getCount() + '건';

    		if( '${inputData._roleId}' == "WORK_IRI_T16" ){
            	deptName.setValue('${inputData._userDeptName}');
            	deptName.disable();
            }

            // 목록 페이징
            paging(dataSet,"defaultGrid");

    	});
        /* [버튼] 조회 */
        fnSearch = function() {
            dataSet.load({
                url: '<c:url value="/prj/tss/ousdcoo/retrieveOusdCooTssList.do"/>'
              , params : {
            	    tssScnCd : 'O'											  //과제구분코드(G, N , O:대외협력)
                  , wbsCd : wbsCd.getValue()                                  //과제코드
                  , tssNm : encodeURIComponent(tssNm.getValue())              //과제명
                  , saUserName : encodeURIComponent(document.aform.saUserName.value)             //과제리더
                  , deptName : encodeURIComponent(document.aform.deptName.value)                  //상위조직코드
                  , tssStrtDd : tssStrtDd.getValue()                          //과제기간(시작일)
				  , tssFnhDd : tssFnhDd.getValue()                            //과제기간(종료일)
                  , tssSt : tssSt.getValue()                                  //상태
                  , prjNm : encodeURIComponent(document.aform.prjNm.value)    //프로젝트명
                  , pgsStepCd : pgsStepCd.getValue() 						  //처리상태
                }
            });
        };

        /* [버튼] 과제등록 */
         var butTssNew = new Rui.ui.LButton('butTssNew');
        butTssNew.on('click', function() {
            nwinsActSubmit(document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssPlnDetail.do'/>");
        });

        /* [버튼] 엑셀 */
         var butExcel = new Rui.ui.LButton('butExcel');
        butExcel.on('click', function() {
			// 엑셀 다운로드시 전체 다운로드를 위해 추가
            dataSet.clearFilter();
            if(dataSet.getCount() > 0) {

            	var excelColumnModel = new Rui.ui.grid.LColumnModel({
                    gridView: gridView,
                    	columns: [
                            { field: 'wbsCd',        label: '과제코드' , sortable: false, align:'center', width: 90
                           	  , renderer: function(value, p, record, row, col) {
                           		  var stepCd = record.get("pgsStepCd");
                           		  if(stepCd == "PL"){ return "SEED-" + value; }
           				          return value;
                               } }
                           , { field: 'tssNm',        label: '과제명'   , sortable: false, align:'left', width: 250
                           	, renderer: function(value, p, record, row, col){
                                   if(record.get("myTss") == "Y") p.css.push('font-bold');
                           		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                           	}
                             }
                           , { field: 'prjNm',        label: '소속명'   , sortable: false, align:'center', width: 160 }
                           , { field: 'saUserName',   label: '과제리더' , sortable: false, align:'center', width: 55 }
                           , { field: 'deptName',     label: '조직'     , sortable: false, align:'center', width: 100 }
                           , { id: 'G1', label: '과제기간(계획일)' }
                           , { field: 'tssStrtDd',    label: '시작일', groupId: 'G1', sortable: false, align:'center', width: 70 }
                           , { field: 'tssFnhDd',     label: '종료일', groupId: 'G1', sortable: false, align:'center', width: 70 }
                           , { id: 'G2', label: '과제실적일' }
                           , { field: 'cmplBStrtDd',    label: '시작일', groupId: 'G2', sortable: false, align:'center', width: 70
                           	, renderer: function(value, p, record, row, col){
                           		if( record.get("pgsStepCd") == "DC" ){
                           			return record.get("dcacBStrtDd");
                           		}
                           		return value;
                           	  }
                             }
                           , { field: 'cmplBFnhDd',    label: '종료일', groupId: 'G2', sortable: false, align:'center', width: 70
                           	, renderer: function(value, p, record, row, col){
                           		if( record.get("pgsStepCd") == "DC" ){
                           			return record.get("dcacBFnhDd");
                           		}
                           		return value;
                           	  }
                             }
                           , { field: 'pgsStepNm',    label: '상태'     , sortable: false, align:'center', width: 50, editor: pgsStepCd, renderer: function(value, p, record, row, col) {
                               p.editable = false;
                               return value;
                              } }
                           , { field: 'tssSt',        label: '처리상태', sortable: false, align:'center', width: 60, editor: tssSt, renderer: function(value, p, record, row, col) {
                               p.editable = false;
                               return value;
                             } }
                           , { field: 'rsstExpConvertMil',        label: '총연구비(억원)'   , sortable: false, align:'right', width: 80 }
                           , { field: 'arslExpConvertMil',        label: '누적실적(억원)'   , sortable: false, align:'right', width: 80 }
                        ]
                });

                var excelColumnModel = excelColumnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('대외협력 과제관리_') + new Date().format('%Y%m%d') + '.xls', {
                    columnModel: excelColumnModel
                });
            } else {
                Rui.alert("조회 후 엑셀 다운로드 해주세요.");
            }
         // 목록 페이징
            paging(dataSet,"defaultGrid");
        });

        // 화면로딩시 조회
        //fnSearch();
        disableFields();

        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
    		$('#butTssNew').hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
    		$('#butTssNew').hide();
    	}


        butTssNew.hide();

        init = function() {
     	   var wbsCd='${inputData.wbsCd}';
     	   var tssNm='${inputData.tssNm}';
     	   var saUserName='${inputData.saUserName}';
     	   var deptName='${inputData.deptName}';
     	   var prjNm='${inputData.prjNm}';
     	   var tssNm='${inputData.tssNm}';
           	dataSet.load({
                 url: '<c:url value="/prj/tss/ousdcoo/retrieveOusdCooTssList.do"/>',
                 params :{
                	 wbsCd : escape(encodeURIComponent(wbsCd)),
                	 tssNm : escape(encodeURIComponent(tssNm)),
                 	saUserName : escape(encodeURIComponent(saUserName)),
                 	deptName : escape(encodeURIComponent(deptName)),
                 	tssStrtDd : '${inputData.tssStrtDd}',
                 	tssFnhDd : '${inputData.tssFnhDd}',
                 	prjNm : escape(encodeURIComponent(prjNm)),
                 	pgsStepCd : '${inputData.pgsStepCd}',
                 	tssSt : '${inputData.tssSt}'
                 }
             });
         }
    });


</script>
<!-- <script type="text/javascript" src="/iris/resource/js/lgHs_common.js"></script> -->
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}" onload="init();">
    <Tag:saymessage />

    <div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>대외협력 과제관리</h2>
		</div>
<%-- 		<%@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>

        <div class="sub-content">
            <form name="aform" id="aform" method="post">
            <input type="hidden" id="deptUper" value="">
            <input type="hidden" id="saSabunName" value="">
            <input type="hidden" id="hWbsCd" value="">

			<div class="search">
				<div class="search-content">
	                <table>
	                    <colgroup>
	                        <col style="width: 120px;" />
	                        <col style="width: 300px;" />
	                        <col style="width: 120px;" />
	                        <col style="width: 300px;" />
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
	                                <input type="text" id="saUserName" value="">
	                            </td>
	                            <th>조직</th>
	                            <td>
	                                <input type="text" id="deptName" value="">
	                            </td>
	                            <td class="txt-right">
	                                <a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
	                            </td>
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
                 <span class="Ltotal" id="cnt_text">총 : 0건</span>
                <div class="LblockButton">
                    <button type="button" id="butTssNew" name="itemCreate" class="redBtn">과제등록</button>
                    <button type="button" id="butExcel" name="butExcel">EXCEL다운로드</button>
                </div>
            </div>

            <div id="defaultGrid"></div>
  		</div><!-- //sub-content -->
  	</div><!-- //contents -->
</body>
</html>