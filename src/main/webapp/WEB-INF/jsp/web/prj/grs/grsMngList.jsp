
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id      : grsMngList.jsp
 * @desc    :  GRS 관리
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.28  jih     최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>


<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/grsEv.js"></script>
	<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>

<style>
    .grid-bg-color-sum {
        background-color: rgb(255,204,204);
    }
</style>

<%
    HashMap inputData = (HashMap)request.getAttribute("inputData");
%>
    <!-- 그리드 소스 -->
<script type="text/javascript">

    var todoYN = stringNullChk("${inputData.LOGIN_SYS_CD}") != "" ? true : false;

    Rui.onReady(function() {

    	var resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
                , { id: 'guid' }  //전자결재번호
            ]
        });



        /*******************
         * 그리드 셋팅 START
         *******************/
         listDataSet = new Rui.data.LJsonDataSet({
             id: 'listDataSet',
             focusFirstRow: 0,
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                 { id: 'tssScnCd'},
                 { id: 'tssScnNm'},
                 { id: 'wbsCd'},
                 { id: 'pkWbsCd'},
                 { id: 'tssNm'},
                 { id: 'bizDptCd'},
                 { id: 'bizDptNm'},
                 { id: 'dlbrCrgr'},
                 { id: 'dlbrCrgrNm'},
                 { id: 'tssDd'},
                 { id: 'dlbrParrDt'},
                 { id: 'grsEvSt'},
                 { id: 'pgsStepCd'},
                 { id: 'grsEvStNm'},
                 { id: 'tssSt'},
                 { id: 'tssStNm'},
                 { id: 'isReq'},
                 { id: 'tssCd'},
                 { id: 'tssCdSn'},
                 { id: 'grsEvSn'},
                 { id: 'grsStNm'},
                 { id: 'frstRgstId'}
              ]
         });


         var listColumnModel = new Rui.ui.grid.LColumnModel({
             autoWidth: true,
             columns: [
            	 new Rui.ui.grid.LSelectionColumn(),
                     { field: 'tssScnNm',   label: '과제구분',  align:'center',  width: 65 },
                     { field: 'wbsCd',   label: '과제코드',  align:'center',  width: 70, vMerge: true },
				     { field: 'tssNm',        label: '과제명',       align:'left',      width: 200  , vMerge: true , renderer: function(val, p, record, row, i){
                         return "<a href='javascript:evTssPop("+row+");'><u>" + val + (record.data.isTmp=='1'?' (임)':'')+"<u></a>";
                     } },
                     { field: 'bizDptNm',   label: '프로젝트명',  align:'center',  width: 100 },
                     { field: 'dlbrCrgrNm',   label: '과제담당자',  align:'center',  width: 70},
                     { field: 'tssDd',   label: '과제기간',  align:'center',  width: 100 },
                     { field: 'dlbrParrDt',   label: '심의예정일',  align:'center',  width: 60 },
                     { field: 'grsEvStNm',   label: '심의단계',  align:'center',  width: 65 },
                     { field: 'grsStNm',   label: 'GRS상태',  align:'center',  width: 65 , renderer: function(val, p, record, row, i) {
                             return (val == null) ? "GRS품의완료" : val;
					 }},
                     { field: 'isReq',        label: '관리',       align:'center',      width: 90  , renderer: function(val, p, record, row, i){
                         return ((val==1)?"<input type='button' data='"+record.data.tssCd+"' value='평가' onclick='evTssPop(\""+row+"\")'/>":"")
							 +((record.data.isFirstGrs==1 && val==1)?"<input type='button' data='"+record.data.tssCd+"' value='수정' onclick='modifyTss(\""+row+"\")'/>":"");

                     } }
             ]
         });
        var listGrid = new Rui.ui.grid.LGridPanel({ //masterGrid
            columnModel: listColumnModel,
            dataSet: listDataSet,
            height: 400,
            width: 600,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        listGrid.render('listGrid');

        /* ================================== 상세 시작==============================================*/


        infoDataSet = new Rui.data.LJsonDataSet({
            id: 'infoDataSet',
            fields: [
                { id: 'tssCd'}
                ,{ id: 'wbsCd'}
                ,{ id: 'pkWbsCd'}
                ,{ id: 'pgsStepCd'}
                ,{ id: 'tssSt'}
                ,{ id: 'tssScnCd'}
                ,{ id: 'grsYn'}
                ,{ id: 'tssNm'}
                ,{ id: 'prjCd'}
                ,{ id: 'prjNm'}
                ,{ id: 'bizDptCd'}
                ,{ id: 'prodG'}
                ,{ id: 'saSabunCd'}
                ,{ id: 'saSabunNm'}
                ,{ id: 'tssStrtDd'}
                ,{ id: 'tssFnhDd'}
                ,{ id: 'custSqlt'}
                ,{ id: 'tssAttrCd'}
                ,{ id: 'tssType'}

            ]
        });
        //상세 bind
        InfoBind = new Rui.data.LBind({
            groupId: 'defTssForm',
            dataSet: infoDataSet,
            bind: true,
            bindInfo: [
                { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                ,{ id: 'wbsCd',            ctrlId: 'wbsCd',            value: 'value' }
                ,{ id: 'pkWbsCd',            ctrlId: 'pkWbsCd',            value: 'value' }
                ,{ id: 'pgsStepCd',            ctrlId: 'pgsStepCd',            value: 'value' }
                ,{ id: 'tssSt',            ctrlId: 'tssSt',            value: 'value' }
                ,{ id: 'tssScnCd',            ctrlId: 'tssScnCd',            value: 'value' }
                ,{ id: 'grsYn',            ctrlId: 'grsYn',            value: 'value' }
                ,{ id: 'tssNm',            ctrlId: 'tssNm',            value: 'value' }
                ,{ id: 'prjCd',            ctrlId: 'prjCd',            value: 'value' }
                ,{ id: 'prjNm',            ctrlId: 'prjNm',            value: 'value' }
                ,{ id: 'bizDptCd',            ctrlId: 'bizDptCd',            value: 'value' }
                ,{ id: 'prodG',            ctrlId: 'prodG',            value: 'value' }
                ,{ id: 'saSabunCd',            ctrlId: 'saSabunCd',            value: 'value' }
                ,{ id: 'saSabunNm',            ctrlId: 'saSabunNm',            value: 'value' }
                ,{ id: 'tssStrtDd',            ctrlId: 'tssStrtDd',            value: 'value' }
                ,{ id: 'tssFnhDd',            ctrlId: 'tssFnhDd',            value: 'value' }
                ,{ id: 'custSqlt',            ctrlId: 'custSqlt',            value: 'value' }
                ,{ id: 'tssAttrCd',            ctrlId: 'tssAttrCd',            value: 'value' }
                ,{ id: 'tssType',            ctrlId: 'tssType',            value: 'value' }

            ]
        });


				//평가 상세 Dataset
            evInfoDataSet = new Rui.data.LJsonDataSet({
                    id: 'evInfoDataSet',
                    fields: [
                        { id: 'tssCd' }            //과제코드
                        , { id: 'tssCdSn' }          //과제코드
                        , { id: 'tssScnCd' }          //과제구분
                        , { id: 'userId' }           //로그인ID
                        , { id: 'prjNm' }            //프로젝트명
                        , { id: 'bizDptCd' }         //과제유형
                        , { id: 'bizDptNm' }         //과제유형
                        , { id: 'tssAttrCd' }        //과제속성
                        , { id: 'tssAttrNm' }        //과제속성
                        , { id: 'tssNm' }            //과제명
                        , { id: 'tssDd' }            //과제기간
                        , { id: 'grsEvSt' }          //심의단계
                        , { id: 'grsEvStNm' }        //심의단계
                        , { id: 'grsEvSn' }          //평가표
                        , { id: 'grsEvSnNm' }        //평가표
                        , { id: 'dlbrParrDt' }       //심의예정일
                        , { id: 'dlbrCrgr' }         //심의담당자
                        , { id: 'dlbrCrgrNm' }       //심의담당자
                        , { id: 'evTitl' }           //평가제목
                        , { id: 'cfrnAtdtCdTxt' }    //회의참석자코드
                        , { id: 'cfrnAtdtCdTxtNm' }  //회의참석자코드
                        , { id: 'commTxt' }          //Comments
                        , { id: 'attcFilId' }        //첨부파일
                        , { id: 'tssRoleType' }
                        , { id: 'tssRoleId' }
                        , { id: 'saveYN' }
                        , { id: 'isConfirm' }
                        , { id: 'tssStrtDd' }
                        , { id: 'tssFnhDd' }

                     ]
                });

                 //평가 상세 bind
                evInfoBind = new Rui.data.LBind({
                    groupId: 'evTssForm',
                    dataSet: evInfoDataSet,
                    bind: true,
                    bindInfo: [
                  { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                , { id: 'tssCdSn',          ctrlId: 'tssCdSn',          value: 'value' }
                , { id: 'tssScnCd',          ctrlId: 'tssScnCd',          value: 'value' }
                , { id: 'prjNm',            ctrlId: 'eprjNm',            value: 'value' }
                , { id: 'bizDptNm',         ctrlId: 'ebizDptNm',         value: 'value' }
                , { id: 'tssAttrCd',        ctrlId: 'etssAttrCd',        value: 'value' }
                , { id: 'tssAttrNm',        ctrlId: 'etssAttrNm',        value: 'value' }
                , { id: 'tssNm',            ctrlId: 'etssNm',            value: 'value' }
                , { id: 'tssDd',            ctrlId: 'etssDd',            value: 'value' }
                , { id: 'grsEvSt',          ctrlId: 'egrsEvSt',          value: 'value' }
                , { id: 'grsEvStNm',        ctrlId: 'grsEvStNm',        value: 'value' }
                , { id: 'grsEvSn',          ctrlId: 'grsEvSn',          value: 'value' }
                , { id: 'grsEvSnNm',        ctrlId: 'egrsEvSnNm',        value: 'value' }
                , { id: 'dlbrParrDt',       ctrlId: 'edlbrParrDt',       value: 'value' }
                , { id: 'dlbrCrgr',         ctrlId: 'dlbrCrgr',         value: 'value' }
                , { id: 'dlbrCrgrNm',       ctrlId: 'edlbrCrgrNm',       value: 'value' }
                , { id: 'evTitl',           ctrlId: 'evTitl',           value: 'value' } //평가제목
                , { id: 'cfrnAtdtCdTxt',    ctrlId: 'cfrnAtdtCdTxt',    value: 'value' }//회의참석자서번
                , { id: 'cfrnAtdtCdTxtNm',  ctrlId: 'cfrnAtdtCdTxtNm',  value: 'value' }//회의참석자명
                , { id: 'commTxt',          ctrlId: 'commTxt',          value: 'value' }//Comments
                , { id: 'attcFilId',        ctrlId: 'attcFilId',        value: 'value' }//첨부파일
                    ]
                });
        /* ================================== 상세 종료==============================================*/





                /*******************
                  * Function 및 데이터 처리 START
                *******************/
        /**
            총 건수 표시
        **/
        listDataSet.on('load', function(e){
            var seatCnt = 0;
            var sumOrd = 0;
            var sumMoOrd = 0;
            var tmp;
            var tmpArray;
            var str = "";

            document.getElementById("cnt_text").innerHTML = '총 : '+listDataSet.getCount();
            // 목록 페이징
            paging(listDataSet,"listGrid");

        });
 <%--/*******************************************************************************
  * FUNCTION 명 : init
  * FUNCTION 기능설명 :화면로딩
  *******************************************************************************/--%>
        init = function() {
            listDataSet.load({
                url: '<c:url value="/prj/grs/selectListGrsMngInfo.do"/>',
                params: {
                    tssNm: escape(encodeURIComponent('${inputData.tssNmSch}')) //과제명
                    ,bizDtpCd: '${inputData.bizDtpCd}'
                    ,grsEvSt:'${inputData.grsEvStSch}'
                    ,tssScnCd:'${inputData.tssScnCd}'
                    ,grsSt:'${inputData.grsSt}'
                }
            });
        }

 <%--/*******************************************************************************
  * FUNCTION 명 : fncSearch
  * FUNCTION 기능설명 :검색
  *******************************************************************************/--%>
        /* [버튼] 엑셀 */
        var butExcel = new Rui.ui.LButton('butExcel');
        butExcel.on('click', function() {
            // 엑셀 다운로드시 전체 다운로드를 위해 추가
            listDataSet.clearFilter();
            if(listDataSet.getCount() > 0) {
                /*  var excelColumnModel = columnModel.createExcelColumnModel(false);
                 grid.saveExcel(encodeURIComponent('과제관리_일반과제_') + new Date().format('%Y%m%d') + '.xls', {
                     columnModel: excelColumnModel
                 }); */

                var excelColumnModel = new Rui.ui.grid.LColumnModel({
                    gridView: listColumnModel,
                    columns: [
                        { field: 'tssScnNm',   label: '과제구분',  align:'center',  width: 65 },
                        { field: 'wbsCd',   label: '과제코드',  align:'center',  width: 70 },
                        { field: 'tssNm',        label: '과제명',       align:'left',      width: 200  , renderer: function(val, p, record, row, i){
                                return "<a href='javascript:evTssPop("+row+");'><u>" + val + (record.data.isTmp=='1'?' (임)':'')+"<u></a>";
                            } },
                        { field: 'bizDptNm',   label: '프로젝트명',  align:'center',  width: 100 },
                        { field: 'dlbrCrgrNm',   label: '과제담당자',  align:'center',  width: 70 },
                        { field: 'tssDd',   label: '과제기간',  align:'center',  width: 100 },
                        { field: 'dlbrParrDt',   label: '심의예정일',  align:'center',  width: 60 },
                        { field: 'grsEvStNm',   label: '심의단계',  align:'center',  width: 65 },
                        { field: 'tssStNm',   label: 'GRS상태',  align:'center',  width: 65},
                    ]
                });

                listGrid.saveExcel(encodeURIComponent('GRS관리_') + new Date().format('%Y%m%d') + '.xls', {
                    columnModel: excelColumnModel
                });

            } else {
                Rui.alert("조회 후 엑셀 다운로드 해주세요.");
            }
        });

        fnSearch = function() {

            listDataSet.load({
              url: '<c:url value="/prj/grs/selectListGrsMngInfo.do"/>',
                params: {
//                     tssNm: escape(encodeURIComponent(document.aform.tssNmSch.value)) //과제명
                    tssScnCd : stssScnCd.getValue()
                    ,wbsCd  : swbsCd.getValue()
                    ,tssNm : encodeURIComponent(stssNm.getValue())
                    ,prjNm    : encodeURIComponent(sprjNm.getValue())
                    ,dlbrCrgrNm    : encodeURIComponent(dlbrCrgrNm.getValue())
                    ,tssSt    : sgrsSt.getValue()
                }
            });
        }

        fnSearch();
 <%--/*******************************************************************************
  * FUNCTION 명 : fnExcel
  * FUNCTION 기능설명 :excel 다운로드
  *******************************************************************************/--%>

        fnExcel = function() {
            masterGrid.saveExcel(toUTF8('GRS_심의현황_') + new Date().format('%Y%m%d') + '.xls');
        };

        form = new Rui.ui.form.LForm('defTssForm', {});


      /* 기본정보 등록 팝업 */
      etcTssDialog = new Rui.ui.LDialog({
          applyTo: 'divEtcTss',
          width: 800,
          effect: null,
          // height:600,
          visible: false,
          postmethod: 'none',
          buttons: [
              { text:'Test값', isDefault: true, handler:
                      function () {setDefault();}
              },
              { text:'저장', isDefault: true, handler:
                      function () {
                          var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
                          dm.on('success', function (e) {      // 업데이트 성공시
                              var resultData = resultDataSet.getReadData(e);
                              alert(resultData.records[0].rtnMsg);
                              fnSearch();
                              etcTssDialog.hide();
                          });

                          dm.on('failure', function (e) {      // 업데이트 실패시
                              var resultData = resultDataSet.getReadData(e);
                              alert(resultData.records[0].rtnMsg);
                          });

                          if (fncVaild()) {
                              Rui.confirm({
                                  text: '저장하시겠습니까?',
                                  handlerYes: function () {
                                      dm.updateForm({
                                          url: "<c:url value='/prj/grs/updateGrsMngInfo.do'/>",
                                          form: 'defTssForm'
                                      });
                                  }
                              });
                          }
                      }
              },
              { text:'삭제', isDefault: true, handler:
				  function () {
					  var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
					  dm.on('success', function (e) {
						  var resultData = resultDataSet.getReadData(e);
						  alert(resultData.records[0].rtnMsg);
                          fnSearch();
						  etcTssDialog.hide();
					  });

					  dm.on('failure', function (e) {      // 업데이트 실패시
						  var resultData = resultDataSet.getReadData(e);
						  alert(resultData.records[0].rtnMsg);
					  });

					  if (fncVaild()) {
						  Rui.confirm({
							  text: '삭제하시겠습니까?',
							  handlerYes: function () {
								  dm.updateForm({
									  url: "<c:url value='/prj/grs/deleteGrsMngInfo.do'/>",
									  form: 'defTssForm'
								  });
							  }
						  });
					  }
				  }
              },
              { text:'닫기', isDefault: true, handler:
                function() {
                    this.cancel(false);
                  }
              }
          ]
      });
      /* 평가 팝업 */
        evTssDialog = new Rui.ui.LDialog({
            applyTo: 'divEvTss',
            width: 1210,
            visible: false,
            postmethod: 'none',
            buttons: [
                {
                    text: '임시저장', isDefault: true, handler:
                        function () {
                            var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
                            dm.on('success', function (e) {      // 업데이트 성공시
                                var resultData = resultDataSet.getReadData(e);
                                alert(resultData.records[0].rtnMsg);
                            });

                            dm.on('failure', function (e) {      // 업데이트 실패시
                                var resultData = resultDataSet.getReadData(e);
                                alert(resultData.records[0].rtnMsg);
                            });

                            if (fncVaild()) {
                                Rui.confirm({
                                    text: '임시저장하시겠습니까?',
                                    handlerYes: function () {
                                        var param = jQuery("#evTssForm").serialize().replace(/%/g, '%25');
                                        dm.updateDataSet({
                                            modifiedOnly: false,
                                            url: '<c:url value="/prj/grs/insertTmpGrsEvRsltInfo.do"/>',
                                            dataSets: [gridDataSet, evInfoDataSet],
                                            params: param
                                        });
                                        dm.on('success', function (e) {
                                            evTssDialog.hide();
                                            fnSearch();
                                        });
                                    }
                                });
                            }
                        }
                },
                {
                    text: '평가완료', isDefault: true, handler:
                        function () {
                            var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
                            dm.on('success', function (e) {      // 업데이트 성공시
                                var resultData = resultDataSet.getReadData(e);
                                alert(resultData.records[0].rtnMsg);
                            });

                            dm.on('failure', function (e) {      // 업데이트 실패시
                                var resultData = resultDataSet.getReadData(e);
                                alert(resultData.records[0].rtnMsg);
                            });

                            if (fncVaild()) {
                                Rui.confirm({
                                    text: '평가완료하시겠습니까?<br>완료후에는 수정/삭제가 불가능합니다.',
                                    handlerYes: function () {
                                        var param = jQuery("#evTssForm").serialize().replace(/%/g, '%25');
                                        param += "&tssStrtDd=" + evInfoDataSet.getNameValue(0, "tssStrtDd");
                                        param += "&tssFnhDd=" + evInfoDataSet.getNameValue(0, "tssStrtDd");
                                        param += "&tssAttrCd=" + evInfoDataSet.getNameValue(0, "tssAttrCd");

                                        dm.updateDataSet({
                                            modifiedOnly: false,
                                            url: '<c:url value="/prj/grs/insertGrsEvRsltSave.do"/>',
                                            dataSets: [gridDataSet, evInfoDataSet],
                                            params: param
                                        });
                                        dm.on('success', function (e) {
                                            evTssDialog.hide();
                                            fnSearch();
                                        });

                                    }
                                });
                            }
                        }
                },
                {
                    text: '닫기', isDefault: true, handler:
                        function () {
                            this.cancel(false);
                        }
                }
            ]
        });
            
	    /* 품의 요청 */
		var grsAppr = new Rui.ui.LButton('grsAppr');
		grsAppr.on('click', function(){

			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		       dm.on('success', function (e) {      // 업데이트 성공시
		    	   
		           var resultData = resultDataSet.getReadData(e);

		           var guid = "";
		           
		           guid = resultData.records[0].guid;
		           
		           if(resultData.records[0].rtnSt == 'Y') {
		                var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00332&from=iris&guid='+guid;
		                openWindow(url, 'grsApprPop', 800, 500, 'yes');
		           }
		       });

		       dm.on('failure', function (e) {      // 업데이트 실패시
		           var resultData = resultDataSet.getReadData(e);
		           alert(resultData.records[0].rtnMsg);
		       });


			// 과제 선택 검사
            if(listDataSet.getMarkedCount() == 0 ){
                Rui.alert("품의 요청할 과제를 선택해주십시오");
                return;
            }

            // 품의 가능 과제 검사
            for( var i = 0 ; i < listDataSet.getCount() ; i++ ){
                if(listDataSet.isMarked(i)){
                    var tssSt = listDataSet.getNameValue(i, 'tssSt'); 
                    var tssNm = listDataSet.getNameValue(i, 'tssNm');
                    if(tssSt!="102"){
                        alert("GRS평가완료 과제만 품의 요청이 가능합니다.");
                        return;
                    }
                }
            }
			


            if(confirm('품의 요청을 하시겠습니까?')) {
		       		
		   			if(listDataSet.getCount() > 0 ) {
		   				//체크박스 체크 유무 (1건이상))
		   				// if(listDataSet.getMarkedCount() == 0 ){
		   				// 	Rui.alert("품의 요청할 과제를 선택해주십시오");
		   				// 	return;
		   				// }

		   				// 선택ID 목록 세팅
		   		 		var chkTssCdList = [];
		   				var chkTssCds = '';
		   				for( var i = 0 ; i < listDataSet.getCount() ; i++ ){
		   			    	if(listDataSet.isMarked(i)){
		   			    		//chkWbsCdList.push("'"+listDataSet.getNameValue(i, 'tssCd')+"'");
		   			    		chkTssCdList.push(listDataSet.getNameValue(i, 'tssCd'));
		   			    	}
		   				}
		   				chkTssCds = chkTssCdList.join(',');

		                dm.updateDataSet({
		                    url:'<c:url value="/prj/grs/requestGrsApproval.do"/>',
		                    params: {
		                        tssCds: chkTssCds
		                    }
		                });
		                
		   			}else{
		   				Rui.alert("목록이 없습니다.");
		   				return;
		   			}
		       	}
			
        });
		
    var fncVaild = function(){
    return true;
    }

      /* [함수] 화면초기화 */
      fnOnInit = function(){
        // 다이얼로그 숨김
        etcTssDialog.hide();
      }

      //화면초기화
      fnOnInit();



    makeGrsEvPop();
    makeGrsEvTable();
    <%--/*******************************************************************************
     * 첨부파일
     *******************************************************************************/--%>

     /* [기능] 첨부파일 조회 */
     var attachFileDataSet = new Rui.data.LJsonDataSet({
         id: 'attachFileDataSet',
         remainRemoved: true,
         lazyLoad: true,
         fields: [
               { id: 'attcFilId'}
             , { id: 'seq' }
             , { id: 'filNm' }
             , { id: 'filSize' }
         ]
     });
     attachFileDataSet.on('load', function(e) {
         getAttachFileInfoList();
     });

     getAttachFileList = function() {
         attachFileDataSet.clearData();
         attachFileDataSet.load({
             url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
             params :{
                 attcFilId : lvAttcFilId
             }
         });
     };

     getAttachFileInfoList = function() {
         var attachFileInfoList = [];

         for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
             attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
         }

         setAttachFileInfo(attachFileInfoList);
     };

     getAttachFileId = function() {
         if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

         return lvAttcFilId;
     };
     setAttachFileInfo = function(attachFileList) {
         $('#attchFileView').html('');

         for(var i = 0; i < attachFileList.length; i++) {
             $('#attchFileView').append($('<a/>', {
                 href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                 text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
             })).append('<br/>');
         }

         if(attachFileList.length > 0) {
             lvAttcFilId = attachFileList[0].data.attcFilId;
             evInfoDataSet.setNameValue(0, "attcFilId", lvAttcFilId)
         }
     };

		downloadAttachFile = function(attcFilId, seq) {
		    mstForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
		    mstForm.submit();
     };



        evInfoDataSet.on('load', function (e) {
            var isConfirm = (evInfoDataSet.getNameValue(0, "isConfirm") == "1");
            var isReq = (evInfoDataSet.getNameValue(0, "tssSt") == "101");
            var isFirstGrs = (evInfoDataSet.getNameValue(0, "isFirstGrs") == "1");



			if(isReq){
                $(".first-child:contains('임시저장')").css("display", "block");
                $(".first-child:contains('평가완료')").css("display", "block");
            }else{
                $(".first-child:contains('임시저장')").css("display", "none");
                $(".first-child:contains('평가완료')").css("display", "none");
			}


            if (isConfirm) {
                evTableGrid.setEditable(false);
                setReadonly("evTitl");
                setReadonly("cfrnAtdtCdTxtNm");
                setReadonly("commTxt");
                $("#attchFileMngBtn").hide();

            } else {
                evTableGrid.setEditable(true);
                setEditable("evTitl");
                setEditable("cfrnAtdtCdTxtNm");
                setEditable("commTxt");
                $("#attchFileMngBtn").show();
            }

            // if(isFirstGrs && isReq){
            //    $(".first-child:contains('삭제')").css("display","block");
            // }else{
            //    $(".first-child:contains('삭제')").css("display","none");
            // }


            lvAttcFilId = evInfoDataSet.getNameValue(0, "attcFilId");
            if (!Rui.isEmpty(lvAttcFilId)) {
                $('#attchFileView').html('');
                getAttachFileList();
            }

        });

   }); //onReady END

    function getGrsSt(isReq){
        return isReq=="1"?"GRS요청":"GRS완료";
    }


  function testSubmit() {
    try {
      var obj = form.getValues();
      Rui.log(Rui.dump(obj));
    } catch (e) {
      alert(e);
    }
    return false;
  }

   function addTss(){
	   etcTssDialog.show(true);
	   infoDataSet.clearData();
	   tssCd = "";
	   $("#tssCd").val('');
       setEditable("tssScnCd");
       setEditable("grsYn");
       setEditable("prjNm");
       $(".first-child:contains('삭제')").css("display","none");
   }


   	// 평가 Popup
    function evTssPop(row) {
        tssCd = listDataSet.getAt(row).data.tssCd;
        grsEvSn = listDataSet.getAt(row).data.grsEvSn;
        tssCdSn = listDataSet.getAt(row).data.tssCdSn;
        if (grsEvSn == '0' || grsEvSn == undefined) {
            grsEvSn = '';
            $("#chooseEv").show();
        } else {
            $("#chooseEv").hide();
        }




        evInfoDataSet.clearData();
        grsEvSnNm.setValue('');
        evInfoDataSet.load({
            url: '<c:url value="/prj/grs/selectGrsTssInfo.do"/>',
            params: {
                tssCd: tssCd,
                tssCdSn: tssCdSn
            }
        });



        gridDataSet.load({
            url: '/iris/prj/grs/selectGrsEvRsltInfo.do',
            params: {
                grsEvSn: grsEvSn,
                tssCd: tssCd,
                tssCdSn: tssCdSn
            }
        })
        gridDataSet.on('load', function (e) {

        });

        evTssDialog.show();
    }



   function modifyTss(row){
       tssCd = listDataSet.getAt(row).data.tssCd;
	   etcTssDialog.show(true);

       infoDataSet.clearData();
       infoDataSet.load({
            url: '<c:url value="/prj/grs/selectGrsMngInfo.do"/>',
            params: {
            	tssCd: tssCd
            }
        });

       infoDataSet.on('load', function(e){
           setReadonly("tssScnCd");
           setReadonly("grsYn");
           setReadonly("prjNm");
           $(".first-child:contains('삭제')").css("display","block");
       });

   }

 //평가표 팝업 cbf
   function setGrsEvSnInfo(grsInfo) {
	 $("#evTssForm > #grsEvSn").val(grsInfo.grsEvSn);
	 grsEvSnNm.setValue(grsInfo.evSbcNm);
	 egrsEvSnNm.setValue(grsInfo.evSbcNm);
	 // getGrsEvTableData(grsInfo.grsEvSn, evInfoDataSet.getAt(0).get("tssCd"), '');

       gridDataSet.clearData();
       gridDataSet.load({
           url: '<c:url value="/prj/grs/selectGrsEvRsltInfo.do"/>',
           params: {
               tssCd: tssCd,
               grsEvSn: grsInfo.grsEvSn,
               tssCdSn: tssCdSn
           }
       });
   }


/*
  function test(){
    console.log("test");
    tssScnCd.setValue("개발과제");
    tssScnCd.setSelectedIndex(3);
    console.log(tssScnCd);
  }
 */

</script>
</head>

<!-- <body onload="init();"> -->
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
	          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	          <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>GRS 관리</h2>
		</div>
		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<div class="search">
					<div class="search-content">
		                <table>
					<colgroup>
						<col style="width:120px" />
						<col style="width:220px" />
						<col style="width:120px" />
						<col style="width:400px" />
						<col style="" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">과제구분</th>
							<td><div id="stssScnCd" /></td>
							<th align="right">과제코드</th>
							<td><div id="swbsCd" /></td>
							<td></td>
						</tr>
						<tr>
							<th align="right">과제명</th>
							<td><div id="stssNm" /></td>
							<th align="right">프로젝트명</th>
							<td><div id="sprjNm" /></td>
							<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
						</tr>
						<tr>
							<th align="right">과제담당자</th>
							<td><div id="dlbrCrgrNm" /></td>
							<th align="right">GRS상태</th>
							<td><div id="sgrsSt"/> </td>
						</tr>
					</tbody>
				</table>
				</div>
				</div>
			</form>
			<div class="titArea">
				<span class="Ltotal" id="cnt_text">총 : 0 </span>
				<div class="LblockButton">
					<button type="button" onclick="addTss()">등록</button>
					<button type="button" id="grsAppr" name="grsAppr">품의 요청</button>
					<button type="button" id="butExcel" onclick="javascript:fnExcel()">Excel다운로드</button>
				</div>
			</div>
			<div id="listGrid"></div>
			<!--<div id="masterGrid"></div>-->
			<!-- 과제 기본정보입력 팝업 시작 -->
			<div id="divEtcTss" style="visibility: hidden;">
				<div class="hd">과제기본정보입력</div>
				<div class="bd">
					<!-- <div class="titArea"> -->
					<div class="LblockButton" style="margin-bottom: 10px">
						<!-- <button type="button" id="butEtcTssClear" name="butEtcTssClear">초기화</button> -->
						<!-- <button type="button" id="butEtcTssRgst" name="butEtcTssRgst">저장</button> -->
					</div>
					<!-- </div> -->
					<form name="defTssForm" id="defTssForm" method="post">
						<input type="hidden" name="tssCd" id="tssCd">
						<input type="hidden" name="prjCd" id="prjCd">
						<input type="hidden" name="saSabunCd" id="saSabunCd">
						<input type="hidden" name="deptCode" id="deptCode">
						<table class="table table_txt_right">
							<colgroup>
								<col style="width: 15%;" />
								<col style="width: 30%;" />
								<col style="width: 15%;" />
								<col style="width: 30%;" />
							</colgroup>
							<tbody>
								<tr>
									<th align="right">과제구분</th>
									<td><div id="tssScnCd" /></td>
									<th align="right">GRS(초기(P1))수행여부</th>
									<td><div id="grsYn" /></td>
								</tr>
								<tr>
									<th align="right">과제담당자</th>
									<td><input type="text" id="saSabunNm" /></td>
									<th align="right">사업부</th>
									<td><div id="bizDptCd" /></td>
								</tr>
								<tr>
									<th align="right">프로젝트명<br />(개발부서)
									</th>
									<td colspan="3"><input type="text" id="prjNm" /></td>
								</tr>
								<tr>
									<th align="right">과제명</th>
									<td colspan="3"><input id="tssNm" type="text" style="width: 100%" /></td>
								</tr>
								<tr>
									<th align="right">제품군</th>
									<td><div id="prodG" /></td>
									<th align="right">과제기간</th>
									<td><input type="text" id="tssStrtDd"> <em class="gab"> ~ </em> <input type="text" id="tssFnhDd"></td>
								</tr>
						
								<tr id="displayDiv1">
									<th align="right">고객특성</th>
									<td><div id="custSqlt" /></td>
									<th align="right">과제속성</th>
									<td><div id="tssAttrCd" /></td>
								</tr>
								<tr id="displayDiv2">
									<th align="right">신제품 유형</th>
									<td><div id="tssType" /></td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
			<!-- 과제 기본정보입력 팝업 종료 -->
<!------------------------------------------------------------평가 팝업 시작 ---------------------------------------------------------->
			<div id="divEvTss" style="visibility: hidden;">
				<div class="hd">과제 GRS 평가</div>
				<div class="bd" style="height: 460px;overflow: auto">
					<!-- <div class="titArea"> -->
					<div class="LblockButton" style="margin-bottom: 10px"></div>
					<!-- </div> -->
					<form name="evTssForm" id="evTssForm" method="post">
                        <input type="hidden" id="userIds" name="userIds" value=""/>
                        <input type="hidden" id="cfrnAtdtCdTxt" name="cfrnAtdtCdTxt" value=""/>
                        <input type="hidden" id="attcFilId" name="attcFilId" value=""/>
                        <input type="hidden" id="seq" name="seq" value=""/>
                        <input type="hidden"  name="tssCd" value="${inputData.tssCd}"/>
                        <input type="hidden" id="tssCdSn" name="tssCdSn" value="${inputData.tssCdSn}"/>
                        <!--                    <input type="text" id="cfrnAtdtCdTxtNm" name="cfrnAtdtCdTxtNm" value=""/> -->
                        <input type="hidden" id="grsEvSn" name="grsEvSn" value="${inputData.grsEvSn}"/>
                        <input type="hidden" id="grsEvStSch" name="grsEvStSch" value="${inputData.grsEvStSch}"/>


                        <input type="hidden" id="tssNmSch" name="tssNmSch" value="${inputData.tssNmSch}"/>
                        <input type="hidden" id="bizDtpCd" name="bizDtpCd" value="${inputData.bizDtpCd}"/>
                        <input type="hidden"  name="tssScnCd" value="${inputData.tssScnCd}"/>


                        <input type="hidden" id="dlbrParrDt" name="dlbrParrDt" value=""/>
                        <input type="hidden" id="dlbrCrgr" name="dlbrCrgr" value=""/>

                        <table class="table table_txt_right">
							<colgroup>
								<col style="width: 20%;" />
								<col style="width: 30%;" />
								<col style="width: 20%;" />
								<col style="width: 30%;" />
							</colgroup>
							<tbody>
							<tr>
								<th align="right">프로젝트명</th>
								<td><input type="text" id="eprjNm"/></td>
								<th align="right">과제유형</th>
								<td><input type="text" id="ebizDptNm"/></td>
							</tr>
							<tr>
								<th align="right">과제속성</th>
								<td class="tssLableCss">
									<div id="etssAttrNm"></div>
								</td>
								<th align="right">과제명</th>
								<td><input type="text" id="etssNm"/></td>
							</tr>
							<tr>
								<th align="right">심의단계</th>
								<td class="tssLableCss">
									<div id="egrsEvSt"></div>
								</td>
								<th align="right">평가표</th>
								<td><input type="text" id="egrsEvSnNm"/></td>
							</tr>
							<tr>
								<th align="right">심의예정일</th>
								<td><input type="text" id="edlbrParrDt"/></td>
								<th align="right">심의담당자</th>
								<td><input type="text" id="edlbrCrgrNm"/></td>
							</tr>
							</tbody>
						</table>
						<table class="table table_txt_right">
<%--							<colgroup>
								<col style="width: 20%" />
								<col style="width: 60%" />
								<col style="width: 20%;" />
							</colgroup>--%>
							<tbody>
								<tr>
									<th align="right" width="208">회의 일정/장소</th>
									<td colspan="2"><div id="evTitl" /></td>
								</tr>
								<tr>
									<th align="right">회의 참석자</th>
									<td colspan="2">
										<div class="LblockMarkupCode">
											<div id="cfrnAtdtCdTxtNm"></div>
										</div>
									</td>
								</tr>
								<tr>
									<th align="right">Comment</th>
									<td colspan="2"><div id="commTxt" /></td>
								</tr>
								<tr>
									<th align="right">첨부파일</th>
									<td id="attchFileView" />
									<td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
								</tr>
								<tr id="chooseEv">
									<th align="right">평가표 선택</th>
									<td colspan="2"><div id="grsEvSnNm" /></td>
								</tr>
							</tbody>
						</table>
						<div id="evTableGrid" style="margin-top: 20px"></div>
					</form>
				</div>
			</div>
			<!------------------------------------------------------------평가 팝업 종료 ---------------------------------------------------------->
		</div>
	</div>
</body>
</html>
<script>
	/* 검색 */
	nCombo('stssScnCd', 'TSS_SCN_CD') // 과제구분
	nCombo('sgrsSt', 'GRS_ST') // 과제구분
	nTextBox('swbsCd', 300, '과제코드를 입력해주세요'); // 과제코드
	nTextBox('stssNm', 300, '과제명을 입력해주세요'); // 과제명
	nTextBox('sprjNm', 300, '프로젝트명을 입력해주세요'); // 프로젝트명
	nTextBox('dlbrCrgrNm', 300, '과제담당자명을 입력해주세요'); // 과제명




	/* 등록 */
	nCombo('tssScnCd', 'TSS_SCN_CD') // 과제구분
	nCombo('grsYn', 'COMM_YN') // GRS 수행여부
	nTextBox('tssNm', 620, '과제명을 입력해주세요'); // 과제명
	popProject('prjNm', 'prjCd', 'deptCode', 'prjSearchDialog') // 프로젝트명
	nCombo('bizDptCd', 'BIZ_DPT_CD') // 사업부
	nCombo('prodG', 'PROD_G'); // 제품군
	popSabun('saSabunNm', 'saSabunCd') // 담당자
	nDateBox('tssStrtDd'); // 과제 시작일
	nDateBox('tssFnhDd'); // 과제 종료일
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
	nCombo('tssAttrCd', 'TSS_ATTR_CD'); // 과제속성
	nCombo('tssType', 'TSS_TYPE'); // 신제품 유형

	/* 평가 */
	// 회의 일정/장소
    nTextBox('eprjNm', 300,"",false); // 프로젝트명
    nTextBox('ebizDptNm', 300,"",false); // 과제유형
    nTextBox('etssAttrNm', 300,"",false); // 과제속성
    nTextBox('etssNm', 300,"",false); // 과제명
    nTextBox('egrsEvSt', 300,"",false); // 심의단계

    nTextBox('egrsEvSnNm', 300,"",false); // 평가표
    nTextBox('edlbrParrDt', 300,"",false); // 심의예정일
    nTextBox('edlbrCrgrNm', 300,"",false); // 심의담당자


	nTextBox('evTitl', 580, '회의 일정/장소를 입력해주세요');
	// 회의 참석자
	// nTextBox('cfrnAtdtCdTxtNm', 580, '회의 참석자를  입력해주세요');
    var cfrnAtdtCdTxtNm = new Rui.ui.form.LPopupTextBox({
        applyTo: 'cfrnAtdtCdTxtNm',
        width: 600,
        editable: false,
        placeholder: '회의참석자를 입력해주세요.',
        emptyValue: '',
        enterToPopup: true
    });

    cfrnAtdtCdTxtNm.on('popup', function(e){
        if(todoYN) {
            openUserSearchDialog(setUsersInfo, 10, $('#userIds').val(), null, 600, 400);
        }
        else {
            openUserSearchDialog(setUsersInfo, 10, $('#userIds').val());
        }
    });

	// 연구소 과제의 경우 GRS(초기(P1)) 반드시 수행
    tssScnCd.on('changed', function(e) {
        if($.inArray( e.value, [ "G", "O", "N"])>-1){
            grsYn.setValue('Y');
            setReadonly('grsYn');
		}else{
            setEditable('grsYn');
		}
        
        if($.inArray( e.value, [ "O", "N"])>-1){
        	//document.getElementById("displayDiv1").style.display = "none";
			$('#displayDiv1').css('display', 'none'); 
			$('#displayDiv2').css('display', 'none'); 
		}else{
			$('#displayDiv1').css('display', ''); 
			$('#displayDiv2').css('display', ''); 
			//document.getElementById("displayDiv1").style.display = "block";
		}
        
    });



    setUsersInfo = function(userList) {
        var idList = [];
        var nameList = [];
        var saSabunList = [];

        for(var i=0, size=userList.length; i<size; i++) {
            idList.push(userList[i].saUser);
            nameList.push(userList[i].saName);
            saSabunList.push(userList[i].saSabun);

        }

        cfrnAtdtCdTxtNm.setValue(nameList.join(', '));

        $('#userIds').val(idList);
        $('#cfrnAtdtCdTxt').val(saSabunList);
    };

    function setDefault(){
        //기본값 세팅
        tssScnCd.setSelectedIndex(3);
        grsYn.setSelectedIndex(0);
        tssNm.setValue("개발과제 테스트");
        prjNm.setValue("창호.창호개발연구PJT");

        $("#prjCd").val("PRJ00025");
        $("#deptCode").val("58117903");


        bizDptCd.setSelectedIndex(2);
        prodG.setSelectedIndex(2);

        saSabunNm.setValue("김건휘");
        $("#saSabunCd").val("00207959");
        tssStrtDd.setValue("2018-08-10");
        tssFnhDd.setValue("2019-08-10");
        custSqlt.setSelectedIndex(1);
        tssAttrCd.setSelectedIndex(1);
        tssType.setSelectedIndex(1);
    }



	// Comment
	nTextArea('commTxt', 780, 122, 'Comment를 입력해주세요');
	// 첨부파일
	//attcFilId
	// 평가표 선택
	//nCombo('grsEvSn','TSS_TYPE');
</script>
