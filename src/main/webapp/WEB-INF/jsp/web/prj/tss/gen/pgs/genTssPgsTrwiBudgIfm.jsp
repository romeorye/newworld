<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPgsTrwiBudgIfm.jsp
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
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFrameDialog.css" />
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.css" />
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
    var lvWbsCd    = window.parent.gvWbsCd;
    
    var pageMode = lvPgsCd == "PG" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";

    var dataSet;
    var lvPurY;
    var isSearch2 = false;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //구매년도
        var cboPurY = new Rui.ui.form.LCombo({
        	applyTo: 'purY',
            name: 'cboPurY',
            rendererField: 'text',
            autoMapping: true,
            useEmptyText:false,
            items:[
            	<c:forEach var="purYy" items="${purYy}">
            	{ value: '${purYy.tssYy}', text: '${purYy.tssYy}'},
                </c:forEach>
            ]
        });
        cboPurY.getDataSet().on('load', function(e) {
        	lvPurY = cboPurY.getValue();
        });
        cboPurY.on('changed', function(e) {
        	fn_search();
        });

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "R") {
            }
        };



        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 월별
        dataSet1 = new Rui.data.LJsonDataSet({
            id: 'tbMmDataSet',
            fields: [
                  { id:'totTitle' }
                , { id:'expScnNm' }
                , { id:'01', type:'number' }
                , { id:'02', type:'number' }
                , { id:'03', type:'number' }
                , { id:'04', type:'number' }
                , { id:'05', type:'number' }
                , { id:'06', type:'number' }
                , { id:'07', type:'number' }
                , { id:'08', type:'number' }
                , { id:'09', type:'number' }
                , { id:'10', type:'number' }
                , { id:'11', type:'number' }
                , { id:'12', type:'number' }
                , { id:'totSum', type:'number' }
            ]
        });
        dataSet1.on('load', function(e) {
            console.log("tb load DataSet Success");
        });


        //그리드 월별
        var columnModel1 = new Rui.ui.grid.LColumnModel({
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { id: 'G1', label: '계정' }
                , { field: 'totTitle', label: '구분1', groupId: 'G1', sortable: false, align:'center', width: 190, vMerge: true, hMerge: true }
                , { field: 'expScnNm', label: '구분2', groupId: 'G1', sortable: false, align:'left', width: 190, vMerge: true, hMerge: true }
                , { field: '01', label: '1월', sortable: false, align:'right', width: 65 }
                , { field: '02', label: '2월', sortable: false, align:'right', width: 65 }
                , { field: '03', label: '3월', sortable: false, align:'right', width: 65 }
                , { field: '04', label: '4월', sortable: false, align:'right', width: 65 }
                , { field: '05', label: '5월', sortable: false, align:'right', width: 65 }
                , { field: '06', label: '6월', sortable: false, align:'right', width: 65 }
                , { field: '07', label: '7월', sortable: false, align:'right', width: 65 }
                , { field: '08', label: '8월', sortable: false, align:'right', width: 65 }
                , { field: '09', label: '9월', sortable: false, align:'right', width: 65 }
                , { field: '10', label: '10월', sortable: false, align:'right', width: 65 }
                , { field: '11', label: '11월', sortable: false, align:'right', width: 65 }
                , { field: '12', label: '12월', sortable: false, align:'right', width: 65 }
                , { field: 'totSum', label: '합계', sortable: false, align:'right', width: 110 }
            ]
        });

        var grid1 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel1,
            dataSet: dataSet1,
            width: 600,
            height: 900,
            autoToEdit: true,
            multiLineEditor: true,
            useRightActionMenu: false,
            autoWidth: true
        });

        grid1.render('tbMmGrid');


        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //조회
        fn_search = function() {

        		dataSet1.load({
                    url: "<c:url value='/prj/tss/gen/retrieveGenTssPgsTrwiBudg.do'/>"
                  , params : {
                         tssCd: lvPgsCd == "AL" ? window.parent.gvPgTssCd : lvTssCd
                       , userId: lvUserId
                       , wbsCd: lvWbsCd
                       , yyyy: cboPurY.getValue()
                    }
                });
        };


        //목록
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
         */

        //최초 조회
        fn_search();
    });
</script>
<script>
$(window).load(function() {
    initFrameSetHeight();
});
</script>
</head>
<body>
<form name="tbForm" id="tbForm" method="post">
	<input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
	<input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->

	<div class="titArea">
	    <div class="LblockButton">
	    	<div id="purY"></div>
	    	<label>단위:억원</label>
	    </div>
	</div>

	<div id="tbMmGrid"></div>

<!-- 	<div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnList" name="btnList">목록</button>
	    </div>
	</div> -->
</form>
</body>
</html>