<%@ page pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id      : grsMngList.jsp
 * @desc    :  GRS 관리
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2020.02.28   IRIS005     최초생성
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<script type="text/javascript">

//과제 등록 팝업
var tssRegPopDialog;
var tssUpdatePopDialog;
//grs 평가 팝업
var grsPopupDialog;
var roleId = '${inputData._roleId}';
var roleCheck ="N";
var loginSabun = '${inputData._userSabun}';
var grsUserChk = '${inputData.grsUserChk}';


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


        /* [ 제조혁신과제 등록 Dialog] */
        tssRegPopDialog = new Rui.ui.LFrameDialog({
            id: 'tssRegPopDialog',
            title: '신규과제 기본정보 등록',
            width:  890,
            height: 530,
            modal: true,
            visible: false,
        });

        tssRegPopDialog.render(document.body);

        /* [ 제조혁신과제 등록 Dialog] */
        tssUpdatePopDialog = new Rui.ui.LFrameDialog({
            id: 'tssUpdatePopDialog',
            title: '과제정보 수정 ',
            width:  890,
            height: 530,
            modal: true,
            visible: false,
        });

        tssUpdatePopDialog.render(document.body);


        /* [ GRS평가 등록 Dialog] */
        grsPopupDialog = new Rui.ui.LFrameDialog({
            id: 'grsPopupDialog',
            title: 'GRS평가 등록',
            width:  1215,
            height: 740,
            modal: true,
            visible: false,
        });

        grsPopupDialog.render(document.body);

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
                 { id: 'prjNm'},
                 { id: 'leaderCd'},
                 { id: 'leaderNm'},
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
                 { id: 'grsStCd'},
                 { id: 'frstRgstId'},
                 { id: 'dropYn'},
                 { id: 'evResult'},
                 { id: 'guid'},
                 { id: 'fcCd'},
                 { id: 'tssTypeNm'}
              ]
         });

         listDataSet.on('load', function(e) {
             document.getElementById("cnt_text").innerHTML = '총: '+ listDataSet.getCount() + '건';
             paging(listDataSet,"listGrid");

                 if(  (roleId.indexOf("WORK_IRI_T01") > -1            //시스템관리자
                    || roleId.indexOf("WORK_IRI_T03") > -1        //과제담당자

                    || roleId.indexOf("WORK_IRI_T08") > -1        //창호재GRS
                    || roleId.indexOf("WORK_IRI_T09") > -1        //장식재GRS
                    || roleId.indexOf("WORK_IRI_T10") > -1        //ALGRS
                    || roleId.indexOf("WORK_IRI_T11") > -1        //표면소재GRS
                    || roleId.indexOf("WORK_IRI_T12") > -1        //고기능소재GRS
                    || roleId.indexOf("WORK_IRI_T13") > -1        //자동차GRS
                    || roleId.indexOf("WORK_IRI_T14") > -1        //법인GRS
                    || roleId.indexOf("WORK_IRI_T25") > -1        //인테리어GRS
                    ) ||  grsUserChk == "Y"
                ){
                         roleCheck ="Y";
                         $("#butTssNew").show();
                          $("#butAppr").show();
                }else{
                    if ( grsUserChk == "Y" || (loginSabun =="00206548" || loginSabun =="00206494" || loginSabun =="00209071" || loginSabun =="00206740" ||  loginSabun =="00207772" ||  loginSabun =="00206461")){
                         $("#butTssNew").show();
                          $("#butAppr").show();
                     }else{
                        $("#butTssNew").hide();
                          $("#butAppr").hide();
                     }
                }
         });

         appDataSet = new Rui.data.LJsonDataSet({
             id: 'appDataSet',
             focusFirstRow: 0,
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                 { id: 'tssCd'},
                 { id: 'tssCdSn'},
                 { id: 'grsEvSt'}
              ]
         });

         var listColumnModel = new Rui.ui.grid.LColumnModel({
             autoWidth: true,
             columns: [
                 new Rui.ui.grid.LSelectionColumn(),
                     { field: 'tssScnNm',   label: '과제구분',  align:'center',  width: 65 },
                     { field: 'wbsCd',       label: '과제코드',  align:'center',  width: 60, vMerge: true },
                     { field: 'tssNm',      label: '과제명',       align:'left',      width: 200  , vMerge: true , renderer: function(val, p, record, row, i){
                         return "<a href='javascript:fncTssPop("+row+");'><u>" + val +"<u></a>";
                     } },
                     { field: 'tssTypeNm',      label: '등급',  align:'center',  width: 60 },
                     { field: 'prjNm',   label: '프로젝트명',  align:'center',  width: 120 },
                     { field: 'leaderNm',   label: '과제리더',  align:'center',  width: 60},
                     { field: 'dlbrCrgrNm',   label: '심의담당자',  align:'center',  width: 60},
                     { field: 'tssDd',   label: '과제기간',  align:'center',  width: 140 },
                     { field: 'grsEvStNm',   label: '심의단계',  align:'center',  width: 55 },
                     { field: 'grsStNm',   label: 'GRS상태',  align:'center',  width: 65 },
                     { field: 'evResult',   label: '평가결과',  align:'center',  width: 60 },
                     { field: 'isReq',        label: '관리',       align:'center',      width: 60  , renderer: function(val, p, record, row, i){
                         return ("<input type='button' data='"+record.data.tssCd+"' value='평가' onclick='fncGrsReqPop(\""+row+"\")'/>")
                     } },
                     { field: 'tssScnCd', hidden:true }
                     ,{ field: 'fcCd', hidden:true }
                     ,{ field: 'bizDptCd', hidden:true }
                     ,{ field: 'pgsStepCd', hidden:true }
                     ,{ field: 'grsEvSt', hidden:true }
                     ,{ field: 'grsStCd', hidden:true }
                     ,{ field: 'tssCd', hidden:true }
                     ,{ field: 'tssCdSn', hidden:true }
             ]
         });

         var listGrid = new Rui.ui.grid.LGridPanel({ //masterGrid
            columnModel: listColumnModel,
            dataSet: listDataSet,
            height: 450,
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

        //과제구분
        tssScnCd = new Rui.ui.form.LCombo({
            applyTo: 'tssScnCd',
            name: 'tssScnCd',
            emptyValue: '',
            useEmptyText: true,
            defaultValue: '<c:out value="${inputData.tssScnCd}"/>',
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_SCN_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            autoMapping: true
        });
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
        //프로젝트명
        prjNm = new Rui.ui.form.LTextBox({
            applyTo: 'prjNm',
            defaultValue: '<c:out value="${inputData.prjNm}"/>',
            width: 200
        });
        //과제리더
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            defaultValue: '<c:out value="${inputData.saUserName}"/>',
            width: 200
        });
        //GRS상태
        grsStCd = new Rui.ui.form.LCombo({
            applyTo: 'grsStCd',
            name: 'grsStCd',
            emptyValue: '',
            useEmptyText: true,
            defaultValue: '<c:out value="${inputData.grsStCd}"/>',
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=GRS_ST"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            autoMapping: true
           });

           fnSearch = function(){
            listDataSet.load({
                url: '<c:url value="/prj/grs/selectListGrsMngInfo.do"/>'
               ,params: {
                       tssScnCd:  tssScnCd.getValue()
                      ,wbsCd: wbsCd.getValue()
                      ,tssNm: escape(encodeURIComponent(tssNm.getValue()) ) //과제명
                      ,prjNm:  escape(encodeURIComponent(prjNm.getValue() ))
                      ,saUserName: escape(encodeURIComponent(saUserName.getValue() ))
                      ,grsStCd:  grsStCd.getValue()

                      }
            });
         };

         fnSearch()

        //신규과제 등록 팝업창
         fncTssRegPop = function(row){
             tssRegPopDialog.setUrl('<c:url value="/prj/grs/tssRegPop.do"/>');
             tssRegPopDialog.show(true);
         };

         fncTssPop = function(row){
             var recode = listDataSet.getAt(row);
              var param = "?tssCd="+recode.get("tssCd");

              if (  recode.get("grsEvSt") == "M" && recode.get("grsStCd") == "101"  ){
                 tssUpdatePopDialog.setUrl('<c:url value="/prj/grs/tssUpdatePop.do"/>'+param);
                 tssUpdatePopDialog.show(true);
              }else{
                tssRegPopDialog.setUrl('<c:url value="/prj/grs/tssRegPop.do"/>'+param);
                 tssRegPopDialog.show(true);
              }
         }

          //GRS평가등록 팝업창
        fncGrsReqPop = function(row){
            var recode = listDataSet.getAt(row);
            var param = "?tssCd="+recode.get("tssCd")+"&tssCdSn="+recode.get("tssCdSn")+"&grsEvSn="+recode.get("grsEvSn")+"&grsStCd="+recode.get("grsStCd")+"&grsEvSt="+recode.get("grsEvSt")+"&roleCheck="+roleCheck;

            if( roleId.indexOf("WORK_IRI_T01") > -1    || roleId.indexOf("WORK_IRI_T03") > -1  || roleId.indexOf("WORK_IRI_T15") > -1      ){

               }else{
                   /*
                   if ( loginSabun != listDataSet.getNameValue(row, 'dlbrCrgr')  ){
                          alert("GRS평가는 심의담당자만 가능합니다.");
                          return;
                      }
                   */
               }

            //평가요청 화면
            grsPopupDialog.setUrl('<c:url value="/prj/grs/grsRegPop.do"/>'+param);
               grsPopupDialog.show(true);
        };

          //GRS품의
        fncGrsAppr = function(){
            var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

            dm.on('success', function (e) {      // 업데이트 성공시
                var resultData = resultDataSet.getReadData(e);
                var guid = "";
                guid = resultData.records[0].guid;

                if(resultData.records[0].rtnSt == 'Y') {
                       <%--
                       var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00382&from=iris&guid='+guid;
                         openWindow(url, 'grsApprPop', 800, 500, 'yes');
                    //if( listDataSet.getNameValue(tssScnCd               ){

                         }else{  //기술팀 GRS 품의
                         var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00393&from=iris&guid=='+guid;
                        openWindow(url, 'grsApprPop', 800, 500, 'yes');
                    }
                   --%>

                       var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00382&from=iris&guid='+guid;
                       openWindow(url, 'grsApprPop', 800, 500, 'yes');
                   }
               });

               dm.on('failure', function (e) {      // 업데이트 실패시
                   var resultData = resultDataSet.getReadData(e);
                   alert(resultData.records[0].rtnMsg);
               });

                // 품의 가능 과제 검사
                for( var i = 0 ; i < listDataSet.getCount() ; i++ ){
                    if(listDataSet.isMarked(i)){
                        if ( listDataSet.getNameValue(i, 'tssScnCd') == "G" || listDataSet.getNameValue(i, 'tssScnCd') == "D" ){
                            alert("연구팀과제, 기술팀과제는 GRS품의 제외대상입니다.");
                            return;
                        }

                        if(listDataSet.getNameValue(i, 'grsStCd') !="102"){
                            alert("GRS평가완료 과제만 품의 요청이 가능합니다.");
                            return;
                        }
                    }
                }

                if(listDataSet.getMarkedCount() == 0 ){
                    Rui.alert("품의 요청할 과제를 선택해주십시오");
                    return;
                }else{
                    for( var i = 0 ; i < listDataSet.getCount() ; i++ ){
                        if(listDataSet.isMarked(i)){
                            var row = appDataSet.newRecord();
                            var record = appDataSet.getAt(row);

                            record.set("tssCd", listDataSet.getNameValue(i, 'tssCd') );
                            record.set("tssCdSn", listDataSet.getNameValue(i, 'tssCdSn') );
                            record.set("grsEvSt", listDataSet.getNameValue(i, 'grsEvSt') );
                        }
                    }
                }

                if(confirm('품의 요청을 하시겠습니까?')) {
                    if(listDataSet.getCount() > 0 ) {
                        var tssCdList = [];

                        for( var i = 0 ; i < listDataSet.getCount() ; i++ ){
                               if(listDataSet.isMarked(i)){
                                   tssCdList.push(listDataSet.getNameValue(i, 'tssCd'));
                               }
                           }
                           var tssCds = tssCdList.join(',');

                           dm.updateDataSet({
                            url:'<c:url value="/prj/grs/requestGrsApproval.do"/>',
                            dataSets : [appDataSet],
                            params: {
                                tssCds: tssCds
                            }
                        });
                    }
                }
        };



        /* 분석의뢰 리스트 엑셀 다운로드 */
        fncExcelDownLoad = function() {
            // 엑셀 다운로드시 전체 다운로드를 위해 추가
            listDataSet.clearFilter();
            var dataSet2 = listDataSet.clone('listDataSet');

            /* [Grid] 엑셀 */
            var grid2 = new Rui.ui.grid.LGridPanel({
                columnModel: listColumnModel,
                dataSet: dataSet2,
                width: 0,
                height: 0
            });

            grid2.render('defaultGrid2');
             // 목록 페이징
            paging(listDataSet,"listGrid");

            // 목록 페이징
            if(listDataSet.getCount() > 0) {

                var excelColumnModel = new Rui.ui.grid.LColumnModel({
                    gridView: listColumnModel,
                    columns: [
                         { field: 'tssScnNm',        label: '과제구분', sortable: true, align:'center', width: 120 }
                        ,{ field: 'wbsCd',      label: '과제코드', sortable: true, align:'center', width: 85}
                     , { field: 'tssNm',        label: '과제명', sortable: true, align:'left', width: 240 }
                     , { field: 'tssTypeNm',        label: '등급', sortable: true, align:'left', width: 80 }
                     , { field: 'prjNm',        label: '프로젝트명', sortable: true, align:'center', width: 120 }
                     , { field: 'leaderNm',   label: '과제리더', sortable: true, align:'center', width: 80 }
                     , { field: 'dlbrCrgrNm',     label: '심의담당자', sortable: true, align:'center', width: 100 }
                     //, { id: 'G1', label: '과제기간(계획일)' }
                     , { field: 'tssDd',    label: '과제기간', sortable: true, align:'center', width: 200 }
                     , { field: 'grsEvStNm',    label: '심의단계', sortable: true, align:'center', width: 70 }
                     , { field: 'grsStNm',        label: 'GRS상태', sortable: true, align:'center', width: 100}
                     , { field: 'evResult', label: '평가결과',  sortable: true, align:'center', width: 117 }
                 ]
                 });
                duplicateExcelGrid(excelColumnModel);

                nG.saveExcel(encodeURIComponent('GRS관리_') + new Date().format('%Y%m%d') + '.xls',{
                    columnModel: excelColumnModel
                });
            }else {
                Rui.alert("조회 후 엑셀 다운로드 해주세요.");
            }
        };

    });
</script>



</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
<Tag:saymessage />
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
        <input type="hidden" id="deptCode" value="">
            <div class="search">
            <div class="search-content">
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
                           <th>과제구분</th>
                           <td>
                               <select id="tssScnCd"></select>
                           </td>
                           <th>과제코드</th>
                           <td>
                               <input type="text" id="wbsCd">
                           </td>
                           <td></td>
                       </tr>
                       <tr>
                           <th>과제명</th>
                           <td>
                               <input type="text" id="tssNm">
                           </td>
                           <th>프로젝트명</th>
                           <td>
                               <input type="text" id="prjNm">
                           </td>
                        <td class="txt-right">
                            <a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
                        </td>
                       </tr>
                       <tr>
                           <th>과제리더</th>
                           <td>
                               <input type="text" id="saUserName" >
                           </td>
                           <th>GRS상태</th>
                           <td>
                               <select id="grsStCd"></select>
                           </td>
                           <td></td>
                       </tr>
                   </tbody>
               </table>
           </form>
            </div>
            </div>
        </form>
            <div class="titArea">
                    <span class="Ltotal" id="cnt_text">총 : 0건 </span>
                    <div class="LblockButton">
                        <button type="button" id="butTssNew" class="redBtn" onClick="fncTssRegPop();">신규과제등록</button>
                        <button type="button" id="butAppr"  onClick="fncGrsAppr();">품의요청</button>
                        <button type="button" id="butExcel" name="butExcel" onclick="fncExcelDownLoad();">EXCEL다운로드</button>
                    </div>
                </div>
                <div id="listGrid"></div>
                <div style="display:none" id="defaultGrid2"></div>
    </div>
</div>


</body>
</html>