<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: prjMonClsList.jsp
 * @desc    : 연구팀(Project) > 월마감 > 월마감 목록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.18     IRIS05		최초생성
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
	<script type="text/javascript">

	var roleCheck = "PER";
	
		Rui.onReady(function() {
	
			if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
				roleCheck = "ADM";
			}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T03') > -1) {
				roleCheck = "ADM";
			}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
				roleCheck = "ADM";
			}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
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
                    { id: 'wbsCd' },
                    { id: 'deptNm' },
                    { id: 'prjNm' },
                    { id: 'prjStrDt' },
                    { id: 'prjEndDt' },
                    { id: 'pgsStatCd' },
                    { id: 'pgsStatNm' },
                    { id: 'plEmpNm' },
                    { id: 'prjClsYymm' },
                    { id: 'prjClsYnNm' },
                    { id: 'prjCd' },
                    { id: 'prjPgsYn' },		/*프로젝트 진행여부 Y/N*/
                    { id: 'befprjClsYymm' },	/*프로젝트 마지막 마감월*/
                    { id: 'befpgsStatNm' },	/*프로젝트 마지막 마감월*/
                    { id: 'lastClsYymm' }	/*프로젝트 마지막 마감월*/
                ]
            });
		
            var columnModel = new Rui.ui.grid.LColumnModel({
                groupMerge: true,
                columns: [
                    { field: 'wbsCd'     , label:'WBS코드' , sortable: false, align: 'center', width: 100},
                    { field: 'deptNm'    , label:'부서명' , sortable: false, align: 'center', width: 200},
                    { field: 'prjNm'     , label:'프로젝트명' , sortable: false, align: 'left', width: 250, renderer: function(value){
                		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
                	}},
                    { id : '프로젝트 기간'},
                    { field: 'prjStrDt'  , groupId: '프로젝트 기간', hMerge: true,  label:'시작일' , sortable: false, align: 'center', width: 90},
                    { field: 'prjEndDt'  , groupId: '프로젝트 기간', hMerge: true, label:'종료일' , sortable: false, align: 'center', width: 90},
                   // { field: 'pgsStatNm' , label:'진척상태' , sortable: false, align: 'center', width: 100},
                    { field: 'plEmpNm'   , label:'PL명' , sortable: false, align: 'center', width: 80},
                    { field: 'prjClsYymm', label:'마감월' ,sortable: false, align: 'center', width: 80},
                    { field: 'prjClsYnNm', label:'마감상태명' , sortable: false, align: 'center', width: 80},
                    { id : '전월마감현황'},
                    { field: 'befprjClsYymm', groupId: '전월마감현황',  label:'마감상태' , sortable: false, align: 'center', width: 90},
                    { field: 'befpgsStatNm', groupId: '전월마감현황', label:'진척상태' , sortable: false, align: 'center', width: 90},
                    { field: 'prjCd',  hidden : true}
                ]
            });

            var grid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: dataSet,
                height: 630,
                scrollerConfig: {
                    scrollbar: 'N'
                },
                autoToEdit: true,
                autoWidth: true
            });
            
            grid.render('mainGrid');
            
            fnSearch = function() {
    	    	dataSet.load({
    	            url: '<c:url value="/prj/rsst/retrievePrjClsSearchList.do"/>',
    	            params :{
    	    			    roleCheck  : roleCheck
    	    	          }
                });
                
            }
            
            fnSearch();
            
            grid.on('cellClick', function(e) {
				var record = dataSet.getAt(dataSet.getRow());
            	
				if(dataSet.getRow() > -1) {
					if(e.colId == "prjNm") {
						fncPrjClsDetail(record);
					}
				}
            	
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
        	
        		document.getElementById("cnt_text").innerHTML = '총: '+ dataSet.getCount();

        	});
            
            
            
	});
	
	 function fncPrjClsDetail(evt){
    	var recode = evt;
    	var frm = document.aform;
    	var strSearchMonth = nullToString(recode.get("prjClsYymm"));
    	
    	// 종료된 프로젝트의 경우 최종마감월 세팅
    	var prjPgsYn = nullToString(recode.get("prjPgsYn"));
    	var lastClsYymm = nullToString(recode.get("lastClsYymm"));
    	if( prjPgsYn == 'N' && lastClsYymm != '' ){
    		strSearchMonth = lastClsYymm;
		}
    	
    	frm.prjCd.value = recode.get("prjCd");
    	frm.wbsCd.value = recode.get("wbsCd");
    	frm.searchMonth.value = strSearchMonth;
    	frm.action = "<c:url value='/prj/rsst/retrievePrjRsstClsDtl.do'/>";
    	frm.submit();
    }  	
	
		
</script>
		
</head>
<body>
    <body>
   		<div class="contents">
   		
			<div class="titleArea">
				<h2>월마감 목록</h2>
		    </div>
		    
	       	<div class="sub-content">
	       		<div class="titArea">
		       		<span class="table_summay_number" id="cnt_text">총 : 0 </span>
	       		</div>
				<form id="aform" name="aform" method="post">
					<input type="hidden" id="prjCd"  name="prjCd" />
					<input type="hidden" id="wbsCd"  name="wbsCd" />
					<input type="hidden" id="searchMonth"  name="searchMonth" />
					
					<div id="mainGrid"></div>
				</form>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
	</body>
</html>