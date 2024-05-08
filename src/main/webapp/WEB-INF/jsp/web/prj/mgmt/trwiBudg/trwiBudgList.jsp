<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : trwiBudgList.jsp
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
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">
    var dataSet;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/


        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/



        //산출물DS
        dataSet = new Rui.data.LJsonDataSet({
            id: 'DataSet',
            fields: [
                  { id:'yy' }      //년도
                , { id:'totMmExp' } 		//총1인당비용

            ]
        });

        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                 new Rui.ui.grid.LNumberColumn()
                  , { field: 'yy', label: '년도', sortable: false, align:'center', width: 100, renderer: function(value){
              		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
              		}
                 }
                  , { field: 'totMmExp',label: '총1인당비용',  sortable: false, align:'right', width: 170, renderer: function(value){
              		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
              		}

       		    }
            ]
        });

    /**
    	총 건수 표시
    **/
    dataSet.on('load', function(e){
	    	var seatCnt = 0;
	        var sumOrd = 0;
	        var sumMoOrd = 0;
	        var tmp;
	        var tmpArray;
			var str = "";
	    	document.getElementById("cnt_text").innerHTML = '총: '+dataSet.getCount();
	    	// 목록 페이징
	    	paging(dataSet,"Grid");
	    });


        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 600,
            height: 530,
            autoWidth: true,
            autoHeight: false,
            useRightActionMenu: false
        });

        grid.render('Grid');



        grid.on('cellClick', function(e){
        	  var record = dataSet.getAt(dataSet.getRow());
        	  popupDialog('' , record.get("yy"));
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/

        <%--/*******************************************************************************
         * FUNCTION 명 : popupDialog
         * FUNCTION 기능설명 : 1인당총비용 등록
         *******************************************************************************/--%>



    	var butBudgPopup = new Rui.ui.LButton('butBudgPopup');
    	butBudgPopup.on('click', function() {
    		popupDialog();
    	 });

    	_popupDialog = new Rui.ui.LFrameDialog({
 	        id: '_popupDialog',
 	        title: '1인당 총 비용등록',
 	        width: 400,
 	        height:650,
 	        modal: true,
 	        visible: false,
 	     	buttons : [
	            { text:'닫기', handler: function() {
	              	this.cancel(false);
	              	fnSearch();
	              }
	            }]
 	    });

    	_popupDialog.render(document.body);

    	popupDialog = function(f,  yy) {
	    	_callback = f;
		        _popupDialog.setUrl('<c:url value="/prj/mgmt/trwiBudg/trwiBudgDtlPopup.do?yy="/>'+yy);
		        _popupDialog.show();
	    };
	    <%--/*******************************************************************************
         * FUNCTION 명 : fnSearch
         * FUNCTION 기능설명 : 조회
         *******************************************************************************/--%>

	     var fnSearch = function(){
	        dataSet.load({
	            url: "<c:url value='/prj/mgmt/trwiBudg/retrieveTrwiBudgList.do'/>"
	          , params : {
	//                 yy : budgYY.getValue()
	            }
	        });
	     }
	     fnSearch();
    });
</script>

</head>
<body id="LblockBody">

<div class="contents" >
	<div class="titleArea">
		<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
		<h2>투입예산관리</h2>
	</div>

	<div class="sub-content">
	    <!-- 컨텐츠 영역 -->


	    	<span class="Ltotal" id="cnt_text">총 : 0 </span>
	    	<div class="LblockButton">
	    	 <button type="button" id="butBudgPopup" class="redBtn"  name="butBudgPopup">1인당 총 비용등록</button>
	        </div>
		<div id="Grid"  style="margin-top:20px"></div>
	</div>


</div>

</body>
</html>