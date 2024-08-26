<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id        : tssItgRdcsList.jsp
 * @desc    :  통결결과
 *------------------------------------------------------------------------
 * VER    DATE        AUTHOR        DESCRIPTION
 * ---    -----------    ----------    -----------------------------------------
 * 1.0  2017.08.28  jih        최초생성
 * ---    -----------    ----------    -----------------------------------------
 * IRIS
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script><!-- Lgrid view -->
<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
<style>
    .grid-bg-color-sum {
        background-color: rgb(255,204,204);
    }
</style>

<%
    HashMap inputData = (HashMap)request.getAttribute("inputData");
%>
    <!-- 그리드 소스 -->
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">
    Rui.onReady(function() {


        /*******************
          * 변수 및 객체 선언 START
        *******************/


        var tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            placeholder: '검색할 과제명을 입력해주세요.',
            defaultValue: '${inputData.tssNm}',
            emptyValue: '',
            width: 500
       });

        var wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            placeholder: '검색할 WBS코드를 입력해주세요.',
            defaultValue: '${inputData.wbsCd}',
            emptyValue: '',
            width: 300
       });

           var tssScnCd = new Rui.ui.form.LCombo({ // 검색용 G : 일반 , O:대외 ,  N: 국책
            applyTo : 'tssScnCd',
            emptyText: '전체',
            emptyValue: '',
            defaultValue: '${inputData.tssScnCd}',
            useEmptyText: true,
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_SCN_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD'
           });

           var aprdocstate = new Rui.ui.form.LCombo({ //
            applyTo : 'aprdocstate',
            emptyText: '전체',
            emptyValue: '',
            defaultValue: '${inputData.aprdocstate}',
            useEmptyText: true,
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=APRDOCSTATE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD'
           });

         approvalUsername = new Rui.ui.form.LTextBox({
            applyTo: 'approvalUsername',
            placeholder: '검색할 과제명을 입력해주세요.',
            defaultValue: '${inputData.approvalUsername}',
            emptyValue: '',
            width: 200
       });

      /*
         approvalUsername = new Rui.ui.form.LPopupTextBox({
            applyTo: 'approvalUsername',
            width: 200,
            editable: false,
            enterToPopup: true
        });
           approvalUsername.on('popup', function(e){
            openUserSearchDialog(setUserInfo, 1, '');
        });
 */
        //과제기간 시작일
        approvalProcessdate = new Rui.ui.form.LDateBox({
            applyTo: 'approvalProcessdate',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            width: 100,
            dateType: 'string'
        });

        /*******************
          * 변수 및 객체 선언 END
        *******************/
        /*******************
         * 그리드 셋팅 START
         *******************/



         var mGridDataSet = new Rui.data.LJsonDataSet({ //masterGrid dataSet
             id: 'mGridDataSet',
             focusFirstRow: 0,
             lazyLoad: true,
             fields: [
                     { id: 'aprdocstate' }, //결재상태코드
                     { id: 'aprdocstateNm' }, //결재상태코드
                     { id: 'approvalUserid' },
                     { id: 'approvalUsername' }, //결재 요청자명
                     { id: 'approvalDeptname' }, //결재 요청자 부서명
                     { id: 'approvalJobtitle' }, //결재 요청자 직위
                     { id: 'approvalProcessdate' } ,  //결재 요청 일자
                      { id: 'approverProcessdate' } ,  //결재 승인일자

                     { id: 'title' } , //결재 제목
                     { id: 'updateDate' }, //승인일자
                     { id: 'wbsCd' },
                     { id: 'tssScnCd' }, //과제구분코드
                     { id: 'tssScnNm' }, //과제구분코드
                     { id: 'pgsStepCd' } ,  //진행단계코드
                     { id: 'pgsStepNm' } ,  //진행단계코드
                     { id: 'tssNosSt' }, //과제차수상태
                     { id: 'tssNm' }, //과제명
                     { id: 'itgRdcsId' } //결재번호
              ]
        });


        var mGridColumnModel = new Rui.ui.grid.LColumnModel({  //masterGrid column
        	autoWidth: true,
            columns: [
                    { field: 'tssScnNm',     label: '과제구분',    align:'center',     width: 120 },
                      { field: 'pgsStepNm',    label: '진행단계',       align:'center',      width: 75  },
                      { field: 'tssNm',          label: '과제명',         align:'left',     width: 380 , renderer: function(value){
                        return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                    }},
                      { field: 'wbsCd',          label: 'WBS 코드',        align:'center',          width: 100 },
                      //{ field: 'title',           label: '결재 제목',   align:'left',     width: 220 },
                      { field: 'approvalProcessdate',   label: '결재 요청 일자',   align:'left',      width: 150 },
                      { field: 'aprdocstateNm',            label: '결재상태코드',    align:'center',      width: 100 },
                      { field: 'approverProcessdate',   label: '결재 승인 일자',   align:'left',      width: 150 },
                      { field: 'approvalUsername',      label: '요청자명',        align:'center',      width: 120 },
                      { field: 'itgRdcsId',   label: '전자결재번호',   align:'center',      width: 100 }

            ]
        });

        var masterGrid = new Rui.ui.grid.LGridPanel({ //masterGrid
            columnModel: mGridColumnModel,
            dataSet: mGridDataSet,
            height: 400,
            width: 540,
            autoToEdit: false,
            autoWidth: true
        });

        masterGrid.render('masterGrid'); //masterGrid render

        /*******************
         * 그리드 셋팅 END
        *******************/

        /*******************
          * Function 및 데이터 처리 START
        *******************/

        /**
            총 건수 표시
        **/
        mGridDataSet.on('load', function(e){
            var seatCnt = 0;
            var sumOrd = 0;
            var sumMoOrd = 0;
            var tmp;
            var tmpArray;
            var str = "";

            document.getElementById("cnt_text").innerHTML = '총: '+mGridDataSet.getCount() + '건';
            // 목록 페이징
            paging(mGridDataSet,"masterGrid");

        });

        masterGrid.on('cellClick', function(e){

            var itgRdcsId = mGridDataSet.getNameValue(e.row, "itgRdcsId");

            var winUrl = "<%=lghausysPath%>/lgchem/approval.front.approval.RetrieveAppTargetCmd.lgc?seq="+itgRdcsId
            var sFeatures = "dialogHeight: 300px; dialogWidth:800px";
            //window.showModalDialog(winUrl, "", sFeatures);
            openWindow(winUrl, 'tssItgRdcs', 800, 300, 'yes');
        });



        <%--/*******************************************************************************
         * FUNCTION 명 : fncSearch
         * FUNCTION 기능설명 :검색
         *******************************************************************************/--%>

        /*  리스트 검색 */
//         var btnSearch = new Rui.ui.LButton('btnSearch');

     //   btnSearch.on('click', function(e) {
          fnSearch = function() {
            mGridDataSet.load({
                url: '<c:url value="/prj/tss/itg/retrieveTssItgRdcsList.do"/>',
//                 params: params
                params: {
                     tssNm: escape(encodeURIComponent(document.aform.tssNm.value)) //과제명
                    ,tssScnCd: tssScnCd.getValue()
                    ,approvalUsername : encodeURIComponent(approvalUsername.getValue())
                    //,approvalUserid: $('#approvalUserid').val()
                    ,approvalProcessdate : approvalProcessdate.getValue()
                    ,aprdocstate :  aprdocstate.getValue()
                    ,wbsCd :  wbsCd.getValue()
                }
            });
        }

          fnSearch();
//         });

        <%--/*******************************************************************************
         * FUNCTION 명 : init
         * FUNCTION 기능설명 :화면로딩
         *******************************************************************************/--%>

        init = function() {
               mGridDataSet.load({
                url: '<c:url value="/prj/tss/itg/retrieveTssItgRdcsList.do"/>',
//                 params: params
                params: {
                    tssNm: escape(encodeURIComponent('${inputData.tssNm}')) //과제명
                    ,tssScnCd: '${inputData.tssScnCd}'
                    ,approvalUserid:'${inputData.approvalUserid}'
                    ,approvalProcessdate:'${inputData.approvalProcessdate}'
                }
            });
        }

        var butExcel = new Rui.ui.LButton('butExcel');
        butExcel.on('click', function(){
    		if (mGridDataSet.getCount()>0) {
        		// 엑셀 다운로드시 전체 다운로드를 위해 추가
        		mGridDataSet.clearFilter();
        		
        		var excelColumnModel = mGridColumnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
				nG.saveExcel(encodeURIComponent('과제통합_결재결과목록_') + new Date().format('%Y%m%d') + '.xls');
             	
				// 목록 페이징
   	    		paging(mGridDataSet,"masterGrid");
    		} else {
    			Rui.alert("조회 후 엑셀 다운로드 해주세요.");
    		}
            
        });
        
        butExcel.hide();
   });



    function setUserInfo(userInfo) {
        approvalUsername.setValue(userInfo.saName);  //userID
        $('#approvalUserid').val(userInfo.saUser);


    }


</script>
<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
</head>

<!-- <body onload="init();"> -->
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
<Tag:saymessage/><!--  sayMessage 사용시 필요 -->
    <div class="contents" >
        <div class="titleArea">
            <a class="leftCon" href="#">
              <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
              <span class="hidden">Toggle 버튼</span>
            </a>
              <h2>과제 통합 결재 결과 목록</h2>
          </div>

        <%-- <%//@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>
           <div class="sub-content">
            <form name="aform" id="aform" method="post">
            <input type=hidden id ="approvalUserid" />
            <div class="search">
                    <div class="search-content">
                        <table>
                       <colgroup>
                           <col style="width:15%;"/>
                           <col style="width:30%;"/>
                           <col style="width:15%;"/>
                           <col style="width:30%;"/>
                           <col style="width:10%;"/>
                       </colgroup>
                       <tbody>
                           <tr>
                               <th align="right">요청자</th>
                               <td>
                                <div id="approvalUsername" name='approvalUsername'></div>
                               </td>
                               <th align="right">요청일</th>
                               <td>
                                   <input type="text" id="approvalProcessdate" />
                               </td>
                               <td></td>
                           </tr>
                           <tr>
                               <th align="right">과제명</th>
                               <td>
                                   <input type="text" id="tssNm" value="">
                               </td>
                               <th align="right">과제구분</th>
                               <td>
                                <div id="tssScnCd"></div>
                               </td>
                               <td class="txt-right">
                                <a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</div>
                            </td>
                           </tr>
                           <tr>
                               <th align="right">WBS코드</th>
                               <td>
                                   <input type="text" id="wbsCd" >
                               </td>
                               <th align="right">결재상태</th>
                               <td>
                                   <select id="aprdocstate" ></select>
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
                    <button type="button" id="butExcel" name="butExcel">EXCEL다운로드</button>
                </div>
            </div>

            <div id="masterGrid"></div>

        </div>
    </div>
</body>
</html>