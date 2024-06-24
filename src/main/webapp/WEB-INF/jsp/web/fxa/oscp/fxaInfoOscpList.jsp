<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id        : fxaInfoOscpList.jsp
 * @desc    : 고정자산 >  사외자산이관
 *------------------------------------------------------------------------
 * VER    DATE        AUTHOR        DESCRIPTION
 * ---    -----------    ----------    -----------------------------------------
 * 1.0  2019.10.16    IRIS05        최초생성
 * ---    -----------    ----------    -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<%-- excel download --%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<script type="text/javascript">
var adminChk ="N";

    Rui.onReady(function() {

        /* 권한  */
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
            adminChk = "ADM";
        }else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T04') > -1) {
            adminChk = "ADM";
        }

        /** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'fxaNm'}
                , { id: 'fxaNo' }
                , { id: 'fxaQty'}
                , { id: 'fxaUtmNm'}
                , { id: 'fxaLoc'}
                , { id: 'bkpPce'}
                , { id: 'oscpRqDt' }
                , { id: 'oscpApprDt' }
                , { id: 'oscpStNm'}
                , { id: 'oscpStCd'}
                , { id: 'fxaInfoId'}
                , { id: 'fxaOscpId'}
            ]
        });

        dataSet.on('load', function(e){
            document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
            // 목록 페이징
            paging(dataSet,"defaultGrid");
        });

        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                       { field: 'fxaNm'      , label: '자산명',          sortable: false,    align:'left', width:300}
                    , { field: 'fxaNo'      , label: '자산번호',      sortable: false,    align:'center', width: 100}
                    , { field: 'fxaQty'     , label: '수량',          sortable: false,    align:'center', width: 40}
                    , { field: 'fxaUtmNm'   , label: '단위',          sortable: false,    align:'center', width: 60}
                    , { field: 'bkpPce'       , label: '장부가',          sortable: false,    align:'center', width: 110, renderer: function(value, p, record){
                         return Rui.util.LFormat.numberFormat(parseInt(value));
                        }
                     }
                    , { field: 'fxaLoc'       , label: '위치',          sortable: false,    align:'center', width: 280}
                    , { field: 'oscpStNm'   , label: '상태',          sortable: false,    align:'center', width: 100}
                    , { field: 'oscpRqDt'   , label: '이관요청일',      sortable: false,    align:'center', width: 100}
                    , { field: 'oscpApprDt' , label: '이관승인일',      sortable: false,    align:'center', width: 100}
                    , { field: 'oscpStCd' , hidden : true}
                    , { field: 'fxaInfoId' , hidden : true}
                    , { field: 'fxaOscpId' , hidden : true}
            ]
        });

        /** default grid **/
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            headerTools: true,
            width: 1200,
            height: 400,
            autoWidth: true
        });

        grid.render('defaultGrid');

        grid.on('cellClick', function(e) {
            var record = dataSet.getAt(dataSet.getRow());

            if(dataSet.getRow() > -1) {
                 document.aform.adminChk.value = adminChk;
                 document.aform.fxaInfoId.value = record.get("fxaInfoId");
                 document.aform.rtnUrl.value = "/fxa/oscp/retrieveFxaOscpList.do";
                document.aform.action="<c:url value="/fxa/anl/retrieveFxaAnlDtl.do"/>";
                document.aform.submit();
            }
         });

        //WBS 코드
         var wbsCd = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
             applyTo: 'wbsCd',                           // 해당 DOM Id 위치에 텍스트박스를 적용
            defaultValue: '<c:out value="${inputData.wbsCd}"/>',
             width: 200,                                    // 텍스트박스 폭을 설정
             placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
             invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
         });

          //프로젝트명
         var prjNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
             applyTo: 'prjNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
            defaultValue: '<c:out value="${inputData.prjNm}"/>',
             width: 200,                                    // 텍스트박스 폭을 설정
             placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
             invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
         });

       //자산명
         var fxaNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
             applyTo: 'fxaNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
             defaultValue: '<c:out value="${inputData.fxaNm}"/>',
             width: 200,                                    // 텍스트박스 폭을 설정
             placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
             invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
         });

        //자산번호 [20240624]숫자처럼 3자리마다 ,가 나타나 그러지않도록 수정함.
        var fxaNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
            applyTo: 'fxaNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
            defaultValue: '<c:out value="${inputData.fxaNo}"/>',
            width: 200,                                    // 텍스트박스 폭을 설정
            placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
            invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
        });

        fnSearch = function() {
            dataSet.load({
                url: '<c:url value="/fxa/oscp/retrieveFxaOscpSearchList.do"/>' ,
                params :{
                    wbsCd : encodeURIComponent(document.aform.wbsCd.value),         // wbsCd
                    prjNm : encodeURIComponent(document.aform.prjNm.value),         // prjCd
                    fxaNm : encodeURIComponent(document.aform.fxaNm.value),    //자산명
                    fxaNo : document.aform.fxaNo.value,                        // 자산번호
                }
            });
        }

        // 화면로드시 조회
        fnSearch();


        /* 엑셀 다운로드 */
        var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){

            // 엑셀 다운로드시 전체 다운로드를 위해 추가
            dataSet.clearFilter();

            if(dataSet.getCount() > 0 ) {
                var excelColumnModel = columnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('자산이관목록_') + new Date().format('%Y%m%d') + '.xls', {
                    columnModel: excelColumnModel
                });
            }else{
                Rui.alert("리스트 건수가 없습니다.");
                return;
            }

            // 목록 페이징
            paging(dataSet,"defaultGrid");
        });




    });        //end ready

</script>
 </head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
         <div class="contents">
             <div class="titleArea">
                 <a class="leftCon" href="#">
                    <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
                    <span class="hidden">Toggle 버튼</span>
                </a>
                 <h2>사외자산 목록</h2>
             </div>


        <form name="aform" id="aform" method="post">
            <input type="hidden" id="menuType"  name="menuType" />
            <input type="hidden" id="fxaInfoId"  name="fxaInfoId" />
            <input type="hidden" id="rtnUrl"  name="rtnUrl" />

            <!-- Role -->
            <input type="hidden" id="roleId" name="roleId"  value="<c:out value='${inputData._roleId}'/>">
            <input type="hidden" id="adminChk" name="adminChk" />

            <div class="sub-content">
                <div class="search">
                    <div class="search-content">
                         <table>
                             <colgroup>
                                 <col style="width:120px;"/>
                            <col style="width:200px;"/>
                            <col style="width:120px;"/>
                            <col style="width:"/>
                            <col style="width:"/>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th align="right">WBS 코드</th>
                                <td>
                                    <span>
                                        <input type="text" class="" id="wbsCd" >
                                    </span>
                                </td>
                                <th align="right">프로젝트명</th>
                                <td>
                                    <span>
                                        <input type="text" class="" id="prjNm" >
                                    </span>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <th align="right">자산명</th>
                                <td>
                                    <span>
                                        <input type="text" class="" id="fxaNm" >
                                    </span>
                                </td>
                                <th align="right">자산번호</th>
                                <td>
                                    <input type="text" class="" id="fxaNo">
                                </td>
                                <td class="txt=right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="titArea">
            <span class="table_summay_number" id="cnt_text"></span>
            <div class="LblockButton">
                    <button type="button" id="butExcl" name="butExcl">EXCEL</button>
                </div>
            </div>

            <div id="defaultGrid"></div>
    </form>

             </div><!-- //sub-content -->

</div><!-- //contents -->
</body>
</html>

