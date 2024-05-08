<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssPgsPtcRsstMbrIfm.jsp
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
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd    = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt    = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = lvPgsCd == "PG" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";

    var dataSet;
    var popupRow;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //참여역할
        var rtcRole = new Rui.ui.form.LRadioGroup({
            gridFixed: true,
            autoMapping: true,
            valueField: 'value',
            displayField: 'label',
            items : [
                <c:forEach var="lvTssSt" items="${codeRtcRole}">
                { label: '${lvTssSt.COM_DTL_NM}', name: '${lvTssSt.COM_DTL_NM}', value: '${lvTssSt.COM_DTL_CD}' },
                </c:forEach>
            ]
        });
        
        
        //Form 비활성화
        disableFields = function() {
//             if(pageMode == "W") return;

            grid.setEditable(false);
        };
        
        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'mbrDataSet',
            remainRemoved: true, //삭제시 삭제건으로 처리하지 않고 state만 바꾼다.
            lazyLoad: true, //대량건의 데이터를 로딩할 경우 timer로 처리하여 ie에서 스크립트 로딩 메시지가 출력하지 않게 한다.
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id: 'tssCd' }                                             //과제코드             
                , { id: 'ptcRsstMbrSn' }                                      //참여연구원일련번호 
                , { id: 'saSabunNew' }                                        //연구원사번         
                , { id: 'saUserName' }                                        //연구원이름         
                , { id: 'deptCode' }                                          //소속               
                , { id: 'deptName' }                                          //소속               
                , { id: 'ptcStrtDt', type: 'date', defaultValue: new Date() } //참여시작일         
                , { id: 'ptcFnhDt', type: 'date', defaultValue: new Date() }  //참여종료일         
                , { id: 'ptcRole', defaultValue: '02' }                       //참여역할           
                , { id: 'ptcRoleDtl' }                                        //참여역할상세       
                , { id: 'userId' }                                            //사용자ID
            ]
        });
        dataSet.on('load', function(e) {
            console.log("mbr load DataSet Success");
        });
        
        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { field: 'saUserName', label: '연구원', sortable: false, align:'center', width: 150, renderer: Rui.util.LRenderer.popupRenderer() }
                , { field: 'deptName', label: '소속', sortable: false, align:'left', width: 250 }
                , { field: 'ptcStrtDt', label: '참여기간', sortable: false, align:'center', width: 120, editor: new Rui.ui.form.LDateBox({id:'ptcStrtDt'}) 
                    , renderer: function(value, p, record) {
                        if(record.data.ptcStrtDt != null) {
                            var valDate = Rui.util.LFormat.stringToDate(record.data.ptcStrtDt, {format: '%x'});
                            return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
                        }
                        if(value!="") {
                            return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
                        }
                  } }
                , { field: 'ptcFnhDt', label: '참여기간', sortable: false, align:'center', width: 120, editor: new Rui.ui.form.LDateBox({id:'ptcFnhDt'}) 
                    , renderer: function(value, p, record) {
                        if(record.data.ptcStrtDt != null) {
                            var valDate = Rui.util.LFormat.stringToDate(record.data.ptcFnhDt, {format: '%x'});
                            return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
                        }
                        if(value!="") {
                            return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
                        }
                  } }
                , { field: 'ptcRole', label: '참여역할', sortable: false, align:'center', width: 150, editor: rtcRole 
                    , renderer: function(v) {
                        if(v == null) {
                            return rtcRole.getCheckedItem().label;
                        } else {
                            if(v == '01') return "과제리더";
                            else if(v == '02') return "연구원";
                        } 
                     }    
                }
            ]
        });
        
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 308,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });
        grid.on('popup', function(e) {
//             if(pageMode == "R") return;
//             popupRow = e.row;
//             openUserSearchDialog(setGridUserInfo, 1, '');
        });
        grid.render('defaultGrid');

        
        
        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //조회
        fnSearch = function() {
            dataSet.load({ 
                url: "<c:url value='/prj/tss/nat/retrieveNatTssPgsWBS.do'/>"
              , params : {
                    tssCd : lvTssCd
                }
            });
        };
        
        //목록
       /*  var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        }); */
        
        //데이터 셋팅
        if(${resultCnt} > 0) { 
            console.log("mbr searchData1");
            dataSet.loadData(${result}); 
        } else {
            console.log("mbr searchData2");
        }
        
        
        disableFields();
    });
</script>
<script>
//연구원팝업 셋팅
function setGridUserInfo(userInfo) {
    dataSet.setNameValue(popupRow, "saSabunNew", userInfo.saSabun);
    dataSet.setNameValue(popupRow, "saUserName", userInfo.saName);
    dataSet.setNameValue(popupRow, "deptCode", userInfo.deptCd);
    dataSet.setNameValue(popupRow, "deptName", userInfo.deptName);
}
$(window).load(function() {
    initFrameSetHeight();
}); 
</script>
</head>
<body>
<br/>
<div id="mbrFormDiv">
    <form name="mbrForm" id="mbrForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
    </form>
    <div id="defaultGrid"></div>
</div>
<!-- <div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnList" name="btnList">목록</button>
    </div>
</div> -->
</body>
</html>