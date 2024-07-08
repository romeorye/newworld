<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id        : comCodeList.jsp
 * @desc    : 통계 > 공통코드 관리 >공통코드
 *------------------------------------------------------------------------
 * VER    DATE        AUTHOR        DESCRIPTION
 * ---    -----------    ----------    -----------------------------------------
 * 1.0  2017.11.16     IRIS05        최초생성
 * ---    -----------    ----------    -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<title><%=documentTitle%></title>

<script type="text/javascript">
var codeRegDialog;


    Rui.onReady(function() {

        <%-- RESULT DATASET --%>
        resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });

        var delYnCombo = new Rui.ui.form.LCombo({
            rendererField: 'value',
            autoMapping: true,
            listWidth: 30,
            defaultValue: 'N',
            items: [
                      { code: 'Y', value: 'Y' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
                      { code: 'N', value: 'N' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
                       ]
        });

        /*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
         dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'comCdCd'}
                 , { id: 'comCdNm'}
                 , { id: 'comCdExpl'}
                 , { id: 'comDtlCd'}
                 , { id: 'comDtlNm'}
                 , { id: 'delYn'}
                 //, { id: 'frstRgstDt'}
                 //, { id: 'frstRgstId'}
                 , { id: 'lastMdfyDt'}
                 , { id: 'lastMdfyId'}
                 , { id: 'batchExecDt'}
                 , { id: 'comOrd'}
                 , { id: 'comId'}
                 , { id: '_userId'}
             ]
         });

         dataSet.on('load', function(e){
             document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
         // 목록 페이징
             paging(dataSet,"defaultGrid");
         });

         var columnModel = new Rui.ui.grid.LColumnModel({
             columns: [
                  new Rui.ui.grid.LSelectionColumn(),
                       { field: 'comCdCd'       , label: '코드구분',      align:'left', width: 155}
                     , { field: 'comCdNm'       , label: '코드명',       align:'left',     width: 200}
                     , { field: 'comCdExpl'     , label: '코드설명',      editor: new Rui.ui.form.LTextBox(), align:'left',     width: 200}
                     , { field: 'comOrd'        , label: '순서',         editor: new Rui.ui.form.LNumberBox(),     align:'center', width: 80}
                     , { field: 'comDtlCd'      , label: '상세코드',      editor: new Rui.ui.form.LTextBox(),  align:'center', width: 80 , renderer: function(value, p, record){
                             if(Rui.isEmpty(record.get("comId"))  ){    //추가일 경우  수정가능
                                  p.editable = true;
                             }else{
                                  p.editable = false;
                             }
                             return value
                          }
                      }
                     , { field: 'comDtlNm'       , label: '상세코드값',    editor: new Rui.ui.form.LTextBox(),     align:'left',     width:200}
                     , { field: 'delYn'          , label: '삭제여부',     editor: delYnCombo,     align:'center',     width:80}
                     , { field: 'lastMdfyId'     , label: '수정자ID',       align:'center', width: 100}
                     , { field: 'lastMdfyDt'     , label: '수정일',       align:'center', width: 100}
                     , { field: 'batchExecDt'    , label: '배치실행일',    align:'center'}
                     //, { field: 'frstRgstDt'     , hidden:true}
                     //, { field: 'frstRgstId'     , hidden:true}
                     , { field: 'comId'     , hidden:true}
                     , { field: '_userId'     , hidden:true}
             ]
         });

         /** default grid **/
         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             width: 1150,
             height: 400,
             autoWidth: true

         });

         grid.render('defaultGrid');

        //code
         var code = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
             applyTo: 'code',                             // 해당 DOM Id 위치에 텍스트박스를 적용
             emptyValue : '',
             width: 200,                                    // 텍스트박스 폭을 설정
             placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
             invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
         });

         //code name
         var codeNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
             applyTo: 'codeNm',                             // 해당 DOM Id 위치에 텍스트박스를 적용
             emptyValue : '',
             width: 200,                                    // 텍스트박스 폭을 설정
             placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
             invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
         });

         //code dtl code
         var codeDCd = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
             applyTo: 'codeDCd',                             // 해당 DOM Id 위치에 텍스트박스를 적용
             emptyValue : '',
             width: 200,                                    // 텍스트박스 폭을 설정
             placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
             invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
         });

         //code dtl name
         var codeDNm = new Rui.ui.form.LTextBox({          // LTextBox개체를 선언
             applyTo: 'codeDNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
             emptyValue : '',
             width: 200,                                   // 텍스트박스 폭을 설정
             placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
             invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
         });

         // 마감 여부 combo
         var selDelYn = new Rui.ui.form.LCombo({
             applyTo : 'selDelYn',
             name : 'selDelYn',
             //defaultValue: '<c:out value="${inputData.selDelYn}"/>',
             emptyValue : '',
             emptyText: '선택하세요',
                 items: [
                       { text: 'Y', value: 'Y' }
                     , { text: 'N', value: 'N' }
                     ]
         });

         fnSearch = function() {
             dataSet.load({
                 url: '<c:url value="/stat/code/retrieveCcomCodeList.do"/>' ,
                 params :{
                       code    : code.getValue()                          //IRIS_ADM_COM_CD.COM_CD_CD
                     , codeNm  : encodeURIComponent(codeNm.getValue())    //IRIS_ADM_COM_CD.COM_CD_NM
                     , codeDCd : codeDCd.getValue()                       //IRIS_ADM_COM_CD.COM_DTL_CD
                     , codeDNm : encodeURIComponent(codeDNm.getValue())   //IRIS_ADM_COM_CD.COM_DTL_NM
                     , delYn   : selDelYn.getValue()                      //IRIS_ADM_COM_CD.DEL_YN
                 }
             });
         }

        // 화면로드시 조회 [20240624.siseo]속도가 느려  주석처리
        //fnSearch();

        //코드 등록
        codeRegDialog = new Rui.ui.LFrameDialog({
            id: 'codeRegDialog',
            title: '코드 등록',
            width:  900,
            height: 600,
            modal: true,
            visible: false
        });

        codeRegDialog.render(document.body);


        /* [버튼] : 코드 정보 저장  */
        var butUpdate = new Rui.ui.LButton('butUpdate');

        butUpdate.on('click', function(){
            if(confirm("저장 하시겠습니까?")){
                var dm = new Rui.data.LDataSetManager();
                dm.on('success', function(e) {      // 업데이트 성공시
                    var resultData = resultDataSet.getReadData(e);
                       Rui.alert(resultData.records[0].rtnMsg);

                    if( resultData.records[0].rtnSt == "S"){
                        fnSearch();
                    }
                });

                dm.on('failure', function(e) {      // 업데이트 실패시
                    var resultData = resultDataSet.getReadData(e);
                       Rui.alert(resultData.records[0].rtnMsg);
                });

                dm.updateDataSet({                                            // 데이터 변경시 호출함수 입니다.
                    url: '<c:url value="/stat/code/saveCodeInfo.do"/>' ,    // 서버측 URL을 기술합니다.
                    dataSets:[dataSet]
                });
            }
        });

        /* [버튼] : 신규 코드 등록 팝업창으로 이동 */
        var butRgst = new Rui.ui.LButton('butRgst');

        butRgst.on('click', function(){
            codeRegDialog.setUrl('<c:url value="/stat/code/codeRegPop.do"/>');
            codeRegDialog.show(true);
        });

        /* [버튼] : 자산신규 페이지로 이동 */
        var butAdd = new Rui.ui.LButton('butAdd');

        butAdd.on('click', function(){

            if(Rui.isEmpty(code.getValue())  &&   Rui.isEmpty(code.getValue())){
                dataSet.newRecord();
            }else{
                var row = dataSet.newRecord();
                var beforeRecord = dataSet.getAt(row-1);
                var record = dataSet.getAt(row);

                record.set('comCdCd', beforeRecord.get("comCdCd"));
                record.set('comCdNm', beforeRecord.get("comCdNm"));
                record.set('delYn', 'N');
                record.set('comCdExpl', beforeRecord.get("comCdExpl"));
                record.set('_userId', '${inputData._userId}');
            }
        });

        /* 엑셀 다운로드 */
        var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){
            // 엑셀 다운로드시 전체 다운로드를 위해 추가
            dataSet.clearFilter();
            if(dataSet.getCount() > 0 ) {
                var excelColumnModel = columnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('공통코드_') + new Date().format('%Y%m%d') + '.xls', {
                    columnModel: excelColumnModel
                });
            }else{
                Rui.alert("리스트 건수가 없습니다.");
                return;
            }
            // 목록 페이징
            paging(dataSet,"defaultGrid");
        });

        /* [버튼] : 공통코드 cache refresh  */
        var butCodeRefresh = new Rui.ui.LButton('butCodeRefresh');
        butCodeRefresh.on('click', function(){
            if(confirm("codeCache refresh 하시겠습니까?")){
                var popUrl = '<c:url value="/common/code/refresh.do"/>';
                var popupOption = "";
                goRefreshPop(popUrl, popupOption);
            }
        });

        /* [버튼] : sql refresh  */
        var butSqlRefresh = new Rui.ui.LButton('butSqlRefresh');
        butSqlRefresh.on('click', function(){
            if(confirm("xmlQuery refresh 하시겠습니까?")){
                var popUrl = '<c:url value="/sm/manager/refresh.do?beanName=commonDao&beanXmlFile=/WEB-INF/classes/spring/context-mybatis.xml"/>';
                var popupOption = "";
                goRefreshPop(popUrl, popupOption);
            }
        });

        /* [버튼] : sql refresh  */
        var butBatchExec = new Rui.ui.LButton('butBatchExec');
        butBatchExec.on('click', function(){
            if(confirm("tssStCopyBatch(과제 상태 반영 배치) 수동실행 하시겠습니까?")){
                var popUrl = '<c:url value="/system/batch/tssStCopyBatch.do"/>';
                var popupOption = "";
                goRefreshPop(popUrl, popupOption);
            }
        });

    });        //end ready

    function goRefreshPop(popUrl, popupOption){
        if (popupOption == "" || popupOption.length == 0 ) {
            popupOption = "width=300, height=200, top=200, left=400";
        }
        window.open(popUrl, "", popupOption);
    }

    function fncPopCls(){
        codeRegDialog.cancel(true);
    }

</script>
    </head>
    <body onkeypress="if(event.keyCode==13) {fnSearch();}">
            <div class="contents">
                <div class="titleArea">
                    <a class="leftCon" href="#">
                           <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
                           <span class="hidden">Toggle 버튼</span>
                       </a>
                    <h2>공통코드 관리</h2>
                </div>
                <div class="sub-content">
                    <div class="search">
                           <div class="search-content">
                        <form name="aform" id="aform" method="post">
                        <input type="hidden" id="menuType"  name="menuType" value="IRIFI0101" />

                        <table>
                            <colgroup>
                                <col style="width:120px"/>
                                <col style="width:280px"/>
                                <col style="width:80px"/>
                                <col style="width:280px"/>
                                <col style="width:80px"/>
                                <col style="width:280px"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">코드구분</th>
                                       <td>
                                           <span>
                                            <input type="text" class="" id="code" >
                                        </span>
                                       </td>
                                    <th align="right">코드명</th>
                                    <td>
                                        <input type="text" class="" id="codeNm" >
                                    </td>
                                    <th align="right">삭제여부</th>
                                    <td>
                                        <select id="selDelYn">전체</select>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">상세코드</th>
                                    <td>
                                        <input type="text" class="" id="codeDCd" >
                                    </td>

                                    <th align="right">상세코드값</th>
                                    <td>
                                        <input type="text" class="" id="codeDNm" >
                                    </td>
                                    <td class="txt-right" colspan="2">
                                        <input style="cursor: pointer;" type="reset" value='초기화'>
                                        <a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </div>
                    <div class="titArea">
                        <span class=table_summay_number id="cnt_text"></span>
                        <div class="LblockButton">
                            <button type="button" id="butCodeRefresh"  name="butCodeRefresh" class="redBtn">Cache Refresh</button>
                            <button type="button" id="butSqlRefresh"   name="butSqlRefresh" class="redBtn">Xml Refresh</button>
                            &nbsp;&nbsp;
                            <button type="button" id="butBatchExec"   name="butBatchExec"><b>tssStCopyBatch</b></button>
                            &nbsp;&nbsp;
                            <button type="button" id="butRgst"         name="butRgst" >신규등록</button>
                            <button type="button" id="butRgst"         name="butRgst" >신규등록</button>
                            <button type="button" id="butAdd"          name="butAdd" >추가</button>
                            <button type="button" id="butUpdate"       name="butUpdate" >저장</button>
                            <button type="button" id="butExcl"         name="butExcl">EXCEL</button>
                        </div>
                    </div>
                    <div id="defaultGrid"></div>

                </form>

                </div><!-- //sub-content -->
            </div><!-- //contents -->
    </body>
    </html>



