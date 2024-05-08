<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPgsPtcRsstMbrIfm.jsp
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
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "R") {
                grid.setEditable(false);
            }
        };
        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'mbrDataSet',
            fields: [
                  { id: 'tssCd' }        //과제코드             
                , { id: 'ptcRsstMbrSn' } //참여연구원일련번호 
                , { id: 'saSabunNew' }   //연구원사번         
                , { id: 'saUserName' }   //연구원이름         
                , { id: 'deptCode' }     //소속               
                , { id: 'deptName' }     //소속               
                , { id: 'ptcStrtDt' }    //참여시작일         
                , { id: 'ptcFnhDt' }     //참여종료일         
                , { id: 'oldStrtDt' }    //참여시작일         
                , { id: 'oldFnhDt' }     //참여종료일         
                , { id: 'ptcRoleNm' }    //참여역할           
                , { id: 'ptcRoleDtl' }   //참여역할상세       
                , { id: 'userId' }       //사용자ID
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
                , { field: 'saUserName', label: '연구원', sortable: false, align:'center', width: 150 }
                , { field: 'deptName', label: '소속', sortable: false, align:'left', width: 250 }
                , { field: 'ptcStrtDt', label: '참여시작일', sortable: false, align:'center', width: 120 }
                , { field: 'ptcFnhDt', label: '참여종료일', sortable: false, align:'center', width: 120 }
                , { field: 'ptcRoleNm', label: '참여역할', sortable: false, align:'center', width: 150 }
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
        grid.render('defaultGrid');
        
        
        
        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //목록 
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        }); */
        
        
        //최초 데이터 셋팅 
        if(${resultCnt} > 0) { 
            console.log("mbr searchData1");
            dataSet.loadData(${result}); 
        } else {
            console.log("mst searchData2");
            dataSet.newRecord();
        }
    });
</script>
<script>
$(window).load(function() {
    initFrameSetHeight();
}); 
</script>
</head>
<body style="overflow: hidden">
<div class="titArea">
    <div class="LblockButton">
    </div>
</div>
<div id="mbrFormDiv">
    <form name="mbrForm" id="mbrForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
    </form>
    <div><span style="color:red; font-weight:bold" >참여 연구원 변경 시, 연구원 History 관리를 위해 참여 시작일과 종료일을 수정하시길 바랍니다. (연구원 삭제 하지 말 것)</span></div></br>
    <div id="defaultGrid"></div>
</div>
<!-- <div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnList" name="btnList">목록</button>
    </div>
</div> -->
</body>
</html>