<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: mkInnoMonClsList.jsp
 * @desc    : 연구팀(Project) > 제조혁신 > 제조혁신월마감 목록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.11.11     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<%-- 그리드 소스 --%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<script type="text/javascript">

var roleCheck = "PER";
var roleUserId = '${inputData._userId}';

		Rui.onReady(function() {
			/*
			* 권한 대상 
			* amdin : 전체, per : 해당 사업부만
			*/
			if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
				roleCheck = "ADM";
			}else if( roleUserId == "gabriel" || roleUserId == "jhkimai" ) {
				roleCheck = "ADM";
			}
		
			/*******************
             * 변수 및 객체 선언
            *******************/
            var dataSet = new Rui.data.LJsonDataSet({
                id: 'dataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                     { id: 'wbsCd'}
                    ,{ id: 'uperDeptNm'}
                    ,{ id: 'tssNm'}
                    ,{ id: 'tssStrtDd'}
                    ,{ id: 'tssFnhDd'}
                    ,{ id: 'saName'}
                    ,{ id: 'toMon'}
                    ,{ id: 'toMonClsNm'}
                    ,{ id: 'beforeMonClsNm'}
                    ,{ id: 'beforeMkStNm'}
                    ,{ id: 'uperDeptCd'}		/*프로젝트 진행여부 Y/N*/
                    ,{ id: 'deptCode'}	/*프로젝트 마지막 마감월*/
                    ,{ id: 'tssCd'}	/*프로젝트 마지막 마감월*/
                    ,{ id: 'deptNm'}	
                ]
            });
		
            dataSet.on('load', function(e){
        		document.getElementById("cnt_text").innerHTML = '총: '+ dataSet.getCount() + ' 건';
        		document.aform.tssCd.value = dataSet.getNameValue(0, 'tssCd');
        		// 목록 페이징
    	    	//paging(dataSet,"mainGrid");

        	});
            
            var columnModel = new Rui.ui.grid.LColumnModel({
                groupMerge: true,
                columns: [
                    { field: 'wbsCd'     , label:'WBS코드' , sortable: false, align: 'center', width: 110}
                    ,{ field: 'deptNm'    , label:'팀명' , sortable: false, align: 'center', width: 230}
                    ,{ field: 'tssNm'     , label:'과제명' , sortable: false, align: 'left', width: 300 , renderer: function(value){
                		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                	}}
                    ,{ id : '과제 기간'}
                    ,{ field: 'tssStrtDd'  , groupId: '과제 기간', hMerge: true,  label:'시작일' , sortable: false, align: 'center', width: 100}
                    ,{ field: 'tssFnhDd'  , groupId: '과제 기간', hMerge: true, label:'종료일' , sortable: false, align: 'center', width: 100}
                    ,{ field: 'saName'   , label:'PL명' , sortable: false, align: 'center', width: 95}
                    ,{ field: 'toMon', label:'마감월' ,sortable: false, align: 'center', width: 95}
                    ,{ field: 'toMonClsNm', label:'마감상태명' , sortable: false, align: 'center', width: 95}
                    ,{ id : '전월마감현황'}
                    ,{ field: 'beforeMonClsNm', groupId: '전월마감현황',  label:'마감상태' , sortable: false, align: 'center', width: 100}
                    ,{ field: 'beforeMkStNm', groupId: '전월마감현황', label:'진척상태' , sortable: false, align: 'center', width: 100}
                    ,{ field: 'tssCd', hidden:true}
                ]
            });

            var grid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: dataSet,
                height: 530,
                scrollerConfig: {
                    scrollbar: 'N'
                },
                autoToEdit: true,
                autoWidth: true
            });

            grid.render('mainGrid');
		
            grid.on('cellClick', function(e) {
				var record = dataSet.getAt(dataSet.getRow());

				if(dataSet.getRow() > -1) {
					if(e.colId == "tssNm") {
						document.aform.tssCd.value = record.get("tssCd");
						
						nwinsActSubmit(document.aform, "<c:url value='/prj/tss/mkInnoMonCls/mkInnoMonClsDetail.do'/>");
					}
				}
            });
            
            fnSearch = function() {
    	    	dataSet.load({
    	            url: '<c:url value="/prj/tss/mkInnoMonCls/retrieveMkInnoMonClsSearchList.do"/>',
    	            params :{
    	    			    roleCheck  : roleCheck
    	    	          }
                });
            }

            fnSearch();
            
            
		})


</script>

</head>
<body>
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
			<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			<span class="hidden">Toggle 버튼</span>
		</a>
		<h2>제조혁신 월마감 목록</h2>
	</div>
	<div class="sub-content">
		<div class="titArea" style="margin-top:0;">
			<span class="table_summay_number" id="cnt_text">총 : 0  건</span>
		</div>
		<form id="aform" name="aform">
			<input type="hidden" id="tssCd" name="tssCd"/>
			<div id="mainGrid"></div>
		</form>
	</div>	
</div>
</body>
</html>