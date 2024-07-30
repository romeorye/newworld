<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
                 java.util.*,
                 devonframe.util.NullUtil,
                 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id        : anlRqprList4Chrg.jsp
 * @desc    : 분석목록 리스트(담당자용)
 *------------------------------------------------------------------------
 * VER    DATE        AUTHOR        DESCRIPTION
 * ---    -----------    ----------    -----------------------------------------
 * 1.0  2017.08.25  오명철        최초생성
 * ---    -----------    ----------    -----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

    <script type="text/javascript">
     var getAnlRqprList;
     var tmpAcpcStCd = '${inputData.acpcStCd}';

        Rui.onReady(function() {
             /*******************
              * 변수 및 객체 선언
             *******************/
             var anlRqprDataSet = new Rui.data.LJsonDataSet({
                 id: 'anlRqprDataSet',
                 remainRemoved: true,
                 lazyLoad: true,
                 fields: [
                       { id: 'rqprId'}
                     , { id: 'acpcNo' }
                     , { id: 'anlScnNm' }
                     , { id: 'anlNm' }
                     , { id: 'rgstNm' }
                     , { id: 'anlChrgNm' }
                     , { id: 'rqprDt' }
                     , { id: 'acpcDt' }
                     , { id: 'cmplParrDt' }
                     , { id: 'cmplDt' }
                     , { id: 'anlUgyYnNm' }
                     , { id: 'acpcStNm' }
                     , { id: 'smpoCnt' }
                     , { id: 'realRgstNm' }
                 ]
             });

             var anlRqprColumnModel = new Rui.ui.grid.LColumnModel({
                 columns: [
					  { field: 'rqprId',        label: '의뢰ID',        sortable: true,    align:'center',    width: 75 }
					, { field: 'acpcNo',        label: '접수번호',        sortable: true,    align:'center',    width: 80 }
					, { field: 'anlScnNm',        label: '분석구분',        sortable: false,    align:'center',    width: 100 }
					, { field: 'anlNm',        label: '분석명',        sortable: false,    align:'left',    width: 330 }
					, { field: 'smpoCnt',        label: '시료수',        sortable: false,    align:'center',    width: 50 }
					, { field: 'rgstNm',        label: '의뢰자',        sortable: false,    align:'center',    width: 70 }
					, { field: 'anlChrgNm',    label: '담당자',        sortable: false,     align:'center',    width: 70 }
					, { field: 'realRgstNm',    label: '실의뢰자',        sortable: false,     align:'center',    width: 70 }
					, { field: 'rqprDt',        label: '의뢰일',        sortable: true,     align:'center',    width: 80 }
					, { field: 'acpcDt',        label: '접수일',        sortable: true,     align:'center',    width: 80 }
					, { field: 'cmplParrDt',    label: '완료예정일',    sortable: true,     align:'center',    width: 80 }
					, { field: 'cmplDt',        label: '완료일',        sortable: true,     align:'center',    width: 80 }
					, { field: 'anlUgyYnNm',    label: '긴급',        sortable: false,      align:'center',    width: 60 }
					, { field: 'acpcStNm',        label: '상태',        sortable: false,     align:'center',    width: 80 }
                 ]
             });

             var anlRqprGrid = new Rui.ui.grid.LGridPanel({
                 columnModel: anlRqprColumnModel,
                 dataSet: anlRqprDataSet,
                 width: 600,
                 height: 400,
                 autoToEdit: false,
                 autoWidth: true
             });

             anlRqprGrid.render('anlRqprGrid');

             anlRqprDataSet.on('load', function(e) {
                 $("#cnt_text").html('총 ' + anlRqprDataSet.getCount() + '건');
                 // 목록 페이징
                 aCnt =20;
                 paging(anlRqprDataSet,"anlRqprGrid");
               });

            var anlNm = new Rui.ui.form.LTextBox({
                applyTo: 'anlNm',
                placeholder: '검색할 분석명을 입력해주세요.',
                defaultValue: '<c:out value="${inputData.anlNm}"/>',
                emptyValue: '',
                width: 200
            });
           /*
            anlNm.on('blur', function(e) {
                anlNm.setValue(anlNm.getValue().trim());
            }); */
          /*
            anlNm.on('keypress', function(e) {
                if(e.keyCode == 13) {
                    getAnlRqprList();
                }
            });
            */
            var rqprDeptNm = new Rui.ui.form.LTextBox({
                applyTo: 'rqprDeptNm',
                placeholder: '검색할 의뢰팀을 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rqprDeptNm}"/>',
                emptyValue: '',
                editable: false,
                width: 200
            });

            rqprDeptNm.on('focus', function(e) {
                rqprDeptNm.setValue('');
                $('#rqprDeptCd').val('');
            });

            setRqprDeptInfo = function(deptInfo) {
                rqprDeptNm.setValue(deptInfo.deptNm);
                $('#rqprDeptCd').val(deptInfo.deptCd);
            };

            var rgstNm = new Rui.ui.form.LTextBox({
                applyTo: 'rgstNm',
                placeholder: '검색할 의뢰자를 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rgstNm}"/>',
                emptyValue: '',
                width: 200
            });

            /*
            var rgstNm = new Rui.ui.form.LTextBox({
                applyTo: 'rgstNm',
                placeholder: '검색할 의뢰자를 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rgstNm}"/>',
                emptyValue: '',
                editable: false,
                width: 360
            });

            rgstNm.on('focus', function(e) {
                rgstNm.setValue('');
                $('#rgstNm').val('');
            });
           */
            var acpcNo = new Rui.ui.form.LTextBox({
                applyTo: 'acpcNo',
                placeholder: '검색할 접수번호를 입력해주세요.',
                defaultValue: '<c:out value="${inputData.acpcNo}"/>',
                emptyValue: '',
                width: 200
            });
          /*
            acpcNo.on('blur', function(e) {
                acpcNo.setValue(acpcNo.getValue().trim());
            }); */
            /*
            acpcNo.on('keypress', function(e) {
                if(e.keyCode == 13) {
                    getAnlRqprList();
                }
            });
             */
            var fromRqprDt = new Rui.ui.form.LDateBox({
                applyTo: 'fromRqprDt',
                mask: '9999-99-99',
                displayValue: '%Y-%m-%d',
                defaultValue: '<c:out value="${inputData.fromRqprDt}"/>',
                editable: false,
                width: 100,
                dateType: 'string'
            });

            fromRqprDt.on('blur', function(){
                if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromRqprDt.getValue(),"-","")) ) )  {
                    alert('날자형식이 올바르지 않습니다.!!');
                    fromRqprDt.setValue(new Date());
                }

                if( fromRqprDt.getValue() > toRqprDt.getValue() ) {
                    alert('시작일이 종료일보다 클 수 없습니다.!!');
                    fromRqprDt.setValue(toRqprDt.getValue());
                }
            });

            var toRqprDt = new Rui.ui.form.LDateBox({
                applyTo: 'toRqprDt',
                mask: '9999-99-99',
                displayValue: '%Y-%m-%d',
                defaultValue: '<c:out value="${inputData.toRqprDt}"/>',
                editable: false,
                width: 100,
                dateType: 'string'
            });

            toRqprDt.on('blur', function(){
                if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toRqprDt.getValue(),"-","")) ) )  {
                    alert('날자형식이 올바르지 않습니다.!!');
                    toRqprDt.setValue(new Date());
                }

                if( fromRqprDt.getValue() > toRqprDt.getValue() ) {
                    alert('시작일이 종료일보다 클 수 없습니다.!!');
                    fromRqprDt.setValue(toRqprDt.getValue());
                }
            });

            var anlChrgNm = new Rui.ui.form.LTextBox({
                applyTo: 'anlChrgNm',
                placeholder: '검색할 담당자를 입력해주세요.',
                defaultValue: '<c:out value="${inputData.anlChrgNm}"/>',
                emptyValue: '',
                displayField: 'name',
                width: 200,
                valueField: 'userId'
            });

         /*
            var anlChrgNm = new Rui.ui.form.LCombo({
                applyTo: 'anlChrgNm',
                name: 'anlChrgNm',
                emptyText: '전체',
                defaultValue: '<c:out value="${inputData.anlChrgNm}"/>',
                emptyValue: '',
                url: '<c:url value="/anl/getAnlChrgList.do"/>',
                displayField: 'name',
                valueField: 'userId'
            });
            */
            var acpcStCd = new Rui.ui.form.LCombo({
                applyTo: 'acpcStCd',
                name: 'acpcStCd',
                emptyText: '전체',
                defaultValue: '<c:out value="${inputData.acpcStCd}"/>',
                emptyValue: '',
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ACPC_ST_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            acpcStCd.on('load', function(e){

            });

            anlRqprGrid.on('cellClick', function(e) {

                var record = anlRqprDataSet.getAt(e.row);

                $('#rqprId').val(record.data.rqprId);

                nwinsActSubmit(aform, "<c:url value='/anl/anlRqprDetail4Chrg.do'/>");
            });

            /* 분석의뢰 담당자용 리스트 엑셀 다운로드 */
            downloadAnlRqprListExcel = function() {
                // 엑셀 다운로드시 전체 다운로드를 위해 추가
                anlRqprDataSet.clearFilter();
                var excelColumnModel = anlRqprColumnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
                nG.saveExcel(encodeURIComponent('분석목록_') + new Date().format('%Y%m%d') + '.xls');
                // 목록 페이징
                //paging(anlRqprDataSet,"anlRqprGrid");
            };

            /*
            setRgstInfo = function(userInfo) {
                rgstNm.setValue(userInfo.saName);
                $('#rgstNm').val(userInfo.saUser);
            };
           */

            /* 조회 */
            getAnlRqprList = function() {
               anlRqprDataSet.load({
                    url: '<c:url value="/anl/getAnlRqprList.do"/>',
                    params :{
                        anlNm : encodeURIComponent(anlNm.getValue()),
                        fromRqprDt : fromRqprDt.getValue(),
                        toRqprDt : toRqprDt.getValue(),
                        rqprDeptCd : $('#rqprDeptCd').val(),
                        rgstNm : encodeURIComponent(rgstNm.getValue()),
                        anlChrgNm : encodeURIComponent(anlChrgNm.getValue()),
                        acpcNo : encodeURIComponent(acpcNo.getValue()),
//                        acpcStCd : acpcStCd.getValue(),
                        acpcStCd : document.aform.acpcStCd.value,
                        isAnlChrg : 1
                    }
                });
            };

            init = function() {
                var anlNm='${inputData.anlNm}';
                var rqprDeptNm='${inputData.rqprDeptNm}';
                var anlChrgNm='${inputData.anlChrgNm}';
                var rgstNm='${inputData.rgstNm}';
               anlRqprDataSet.load({
                     url: '<c:url value="/anl/getAnlRqprList.do"/>',
                     params :{
                         anlNm : escape(encodeURIComponent(anlNm)),
                         rqprDeptNm : escape(encodeURIComponent(rqprDeptNm)),
                         anlChrgNm : escape(encodeURIComponent(anlChrgNm)),
                         rgstNm : escape(encodeURIComponent(rgstNm)),
                         fromRqprDt : '${inputData.fromRqprDt}',
                         toRqprDt : '${inputData.toRqprDt}',
                         acpcStCd : '${inputData.acpcStCd}'
                     }
                 });
             }

            //getAnlRqprList();

        });

    </script>
    <%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
    </head>
    <body onkeypress="if(event.keyCode==13) {getAnlRqprList();}" onload="init();">
    <form name="aform" id="aform" method="post">
        <input type="hidden" id="rqprDeptCd" name="rqprDeptCd" value="<c:out value="${inputData.rqprDeptCd}"/>"/>
        <input type="hidden" id="rqprId" name="rqprId" value=""/>

           <div class="contents">
               <div class="titleArea">
                   <a class="leftCon" href="#">
                    <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
                    <span class="hidden">Toggle 버튼</span>
                </a>
                   <h2>분석목록</h2>
               </div>

               <div class="sub-content">
                   <div class="search">
                    <div class="search-content">
                        <table>
                               <colgroup>
                                   <col style="width:120px" />
                                <col style="width:300px" />
                                <col style="width:120px" />
                                <col style="width:350px" />
                                <col style="" />
                               </colgroup>
                               <tbody>
                                   <tr>
                                       <th align="right">분석명</th>
                                       <td>
                                           <input type="text" id="anlNm">
                                       </td>
                                       <th align="right">의뢰일자</th>
                                    <td>
                                           <input type="text" id="fromRqprDt"/><em class="gab"> ~ </em>
                                           <input type="text" id="toRqprDt"/>
                                    </td>
                                       <td></td>
                                   </tr>
                                   <tr>
                                       <th align="right">의뢰팀</th>
                                       <td>
                                           <input type="text" id="rqprDeptNm">
                                        <a href="javascript:openDeptSearchDialog(setRqprDeptInfo);" class="icoBtn">검색</a>
                                       </td>
                                       <th align="right">담당자</th>
                                    <td>
                                        <input type="text" id=anlChrgNm>
                                        <!-- <div id="anlChrgNm"></div> -->
                                    </td>
                                    <td class="txt-right">
                                           <a style="cursor: pointer;" onclick="getAnlRqprList();" class="btnL">검색</a>
                                       </td>
                                   </tr>
                                   <tr>
                                       <th align="right">의뢰자</th>
                                       <td>
                                           <input type="text" id="rgstNm">
                                        <!-- <a href="javascript:openUserSearchDialog(setRgstInfo, 1, '', 'anl');" class="icoBtn">검색</a> -->
                                       </td>
                                       <th align="right">상태</th>
                                       <td>
                                           <select id="acpcStCd"></select>
                                        <!-- <div id="acpcStCd"></div> -->
                                       </td>
                                       <td></td>
                                   </tr>
                                   <tr>
                                       <th align="right">접수번호</th>
                                       <td>
                                           <input type="text" id="acpcNo">
                                       </td>
                                       <th align="right"></th>
                                       <td></td>
                                       <td></td>
                                   </tr>
                               </tbody>
                           </table>
                       </div>
                   </div>

                   <div class="titArea">
                       <span class="Ltotal" id="cnt_text">총  0건 </span>
                       <div class="LblockButton">
                           <button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadAnlRqprListExcel()">Excel</button>
                       </div>
                   </div>

                   <div id="anlRqprGrid"></div>

                <div id="anlRqprExcelGrid" style="width:10px;height:10px;visibility:hidden;"></div>

               </div><!-- //sub-content -->
           </div><!-- //contents -->
        </form>
    </body>
</html>