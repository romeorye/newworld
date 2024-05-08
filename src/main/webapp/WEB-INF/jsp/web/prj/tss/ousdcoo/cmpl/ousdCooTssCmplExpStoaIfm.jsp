<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssCmplExpStoaIfm.jsp
 * @desc    : 대외협력과제 > 완료 비용지급실적 탭 화면
              완료 및 완료 후에도 변경가능처리
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.10.29  IRIS04		최초생성
 * 1.1  2019.08.22  IRIS05		최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">

	Rui.onReady(function() {
    	//구매년도
        var yyyy = new Rui.ui.form.LCombo({
        	applyTo: 'yyyy',
            rendererField: 'text',
            autoMapping: true,
            useEmptyText:false,
            items:[
            	<c:forEach var="purYy" items="${purYy}">
            	{ value: '${purYy.yyyy}', text: '${purYy.yyyy}'},
                </c:forEach>
            ]
        });
        yyyy.getDataSet().on('load', function(e) {
        	lvPurY = yyyy.getValue();
        });
        yyyy.on('changed', function(e) {
        	fn_search();
        });
        
        //DataSet 월별
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            fields: [
            	    { id:'wbsCd' }
            	    , { id:'mm1', type:'number'}
                    , { id:'mm2', type:'number'}
                    , { id:'mm3', type:'number'}
                    , { id:'mm4', type:'number'}
                    , { id:'mm5', type:'number'}
                    , { id:'mm6', type:'number'}
                    , { id:'mm7', type:'number'}
                    , { id:'mm8', type:'number'}
                    , { id:'mm9', type:'number'}
                    , { id:'mm10', type:'number'}
                    , { id:'mm11', type:'number'}
                    , { id:'mm12', type:'number'}
                    , { id:'totSum', type:'number'}
            ]
        });
        dataSet.on('load', function(e) {
        	
        });
        
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                   { field: 'wbsCd', label: 'WBS코드', sortable: false, align:'center', width: 110}
                   , { field: 'mm1', label: '1월', sortable: false, align:'right', width: 85}
                   , { field: 'mm2', label: '2월', sortable: false, align:'right', width: 85}
                   , { field: 'mm3', label: '3월', sortable: false, align:'right', width: 85 }
                   , { field: 'mm4', label: '4월', sortable: false, align:'right', width: 85}
                   , { field: 'mm5', label: '5월', sortable: false, align:'right', width: 85}
                   , { field: 'mm6', label: '6월', sortable: false, align:'right', width: 85}
                   , { field: 'mm7', label: '7월', sortable: false, align:'right', width: 85}
                   , { field: 'mm8', label: '8월', sortable: false, align:'right', width: 85}
                   , { field: 'mm9', label: '9월', sortable: false, align:'right', width: 85 }
                   , { field: 'mm10', label: '10월', sortable: false, align:'right', width: 85}
                   , { field: 'mm11', label: '11월', sortable: false, align:'right', width: 85 }
                   , { field: 'mm12', label: '12월', sortable: false, align:'right', width: 85}
                   , { field: 'totSum', label: '합계', sortable: false, align:'right', width: 110}
            ]
        });
       
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 1260,
            height: 400,
            useRightActionMenu: false
        });

        grid.render('tbMmGrid');
        
        
      //조회
        fn_search = function() {
       		dataSet.load({
                   url: "<c:url value='/prj/tss/ousdcoo/retrieveOusdCooTssPgsExpStoa.do'/>"
                 , params : {
                        wbsCd : '${inputData.wbsCd}'
                      , searchYear: yyyy.getValue()
                   }
               });
       	}
        
        fn_search();
    
    });
    
    // 내부 스크롤 제거
    $(window).load(function() {
        initFrameSetHeight();
    });
</script>
</head>
<body>
<form name="tbForm" id="tbForm" method="post">
	<input type="hidden" id="wbsCd"  name="wbsCd"  value=""> <!-- 과제코드 -->

	<div class="titArea">
	    <div class="LblockButton">
	    	<div id="yyyy"></div>
	    	<label>단위:백만원</label>
	    </div>
	</div>

	<div id="tbMmGrid"></div>
	
</form>

</body>
</html>