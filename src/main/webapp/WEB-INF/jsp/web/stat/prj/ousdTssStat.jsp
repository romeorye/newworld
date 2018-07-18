<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: ousdTssStat.jsp
 * @desc    : 대외협력과제 년도별 통계
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.11.16  
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
				 
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script><!-- Lgrid view -->

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">
        
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
             
            /*******************
             * RUI 변수선언
            *******************/
            /* COMBO : 목표년도 2011년~2030년 => searchYear */
            lcbSearchYear = new Rui.ui.form.LCombo({
            	applyTo: 'cbSearchYear',
           		useEmptyText: true,
               	//emptyText: '선택',
               	//emptyValue: '',
               	useEmptyText: false,
               	defaultValue : new Date().format('%Y'),
               	items: [
               		<c:forEach var="i" begin="0" varStatus="status" end="19">
            			{ value : "${ 2030 - i }" , text : "${ 2030 - i }" } ,
            		</c:forEach>
                ]
            });
            lcbSearchYear.on('changed', function(e){
            	if(lcbSearchYear.getValue() == ''){
            		Rui.alert('년도를 선택해주세요.');
            		lcbSearchYear.setValue(nYear);
            		lcbSearchYear.focus();
            		return false;
            	}
            });
            
            var dataSet = new Rui.data.LJsonDataSet({
                id: 'dataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: false,
                fields: [
                       { id: 'bizDptCd' }   /*과제유형코드*/
         		     , { id: 'bizBptNm' }   /*과제유형명*/
         		     , { id: 'deptCode' }   /*조직코드*/
         			 , { id: 'deptName' }   /*조직명*/
         			 , { id: 'prjCd' }      /*프로젝트코드*/
         			 , { id: 'prjNm' }      /*프로젝트명*/
         			 , { id: 'cnttTypeCd' } /*계약유형코드*/
         			 , { id: 'cnttTypeNm' } /*계약유형명*/
         			 , { id: 'tssCd' }      /*과제코드*/
         			 , { id: 'tssNm' }      /*과제명*/
         			 , { id: 'cooInstCd' }  /*협력기관코드*/ 
         			 , { id: 'cooInstNm' }  /*협력기관명*/
         			 , { id: 'spltNm' }     /*협력기관연구책임자*/
         			 , { id: 'tssStrtDd' }  /*과제시작일자*/
         			 , { id: 'tssFnhDd' }   /*과제종료일자*/
         			 , { id: 'tssDiffMon' } /*과제소요월수(31일단위로 나눠서 소수점2자리표시)*/
         			 , { id: 'wbsCd' }      /*(과제)WBS코드*/
         			 , { id: 'rsstExp' }    /*연구비(원)*/
         			 , { id: 'rsstExpMil' } /*연구비(억원)*/
         			 , { id: 'saSabunNew' } /*과제리더사번*/
         			 , { id: 'saName' }     /*과제리더명*/
         			 , { id: 'strTssStrtDd' }	/*화면표시용 과제시작일자*/
         			 , { id: 'strTssFnhDd' }    /*화면표시용 과제종료일자*/
                ]
            });

            var columnModel = new Rui.ui.grid.LColumnModel({
            	groupMerge: true,
                columns: [
                	  new Rui.ui.grid.LNumberColumn()
                	, { field: 'bizBptNm',        	label: '사업부문<BR>(Funding기준)',	sortable: false,  align:'center', width: 100 }
                	, { field: 'deptName',        	label: '조직',                		sortable: false,  align:'center', width: 100 }
                	, { field: 'prjNm',        		label: '프로젝트명',                	sortable: false,  align:'center', width: 200 }
                	, { field: 'cnttTypeNm',        label: '계약 유형',               	sortable: false,  align:'center', width: 70 }
                	, { field: 'tssNm',        		label: '과제명',               		sortable: false,  align:'left', width: 200 }
                	, { field: 'cooInstNm',        	label: '협력기관명',              	sortable: false,  align:'center', width: 170 }
                	, { field: 'spltNm',        	label: '협력기관<BR>연구책임자',    sortable: false,  align:'center', width: 70 }
                	, { id: 'strTssStrtDd',        		label: '사업기간',                	sortable: false,  align:'center', width: 80 
                		, renderer: function(value, p, record, row, col){
                            var strTssStrtDd = record.get("strTssStrtDd");
                            var strTssFnhDd = record.get("strTssFnhDd");
                    		return strTssStrtDd + '~' + strTssFnhDd ;
                    	}
                	  }
                	, { field: 'tssDiffMon',        label: '소요 기간',               	sortable: false,  align:'right', width: 60 
                		, renderer: function(value, p, record, row, col){
                    		return value + '개월';
                    	}
                	  }
                	, { field: 'wbsCd',        		label: 'WBS 코드',                	sortable: false,  align:'center', width: 60 }
                	, { field: 'rsstExpMil',        label: '연구<BR>(억원)',            sortable: false,  align:'right', width: 40 }
                	, { field: 'saName',        	label: '당사<BR>연구 책임자',       sortable: false,  align:'center', width: 80 }
                ]
            });

            var defaultGrid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: dataSet,
                width: 860,
                height: 600,
                autoToEdit: false,
                autoWidth: true
            });
            
            defaultGrid.render('defaultGrid');
            var defaultGridView = defaultGrid.getView();
            
            /* 조회 */
            fnSearch = function() {
                dataSet.load({
                    url: '<c:url value="/stat/prj/retrieveOusdTssStatList.do"/>',
                    params :{
             		    searchYyyy : lcbSearchYear.getValue()
                    }
                });
            };
            
            dataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + dataSet.getCount() + '건');
   	      	});
            
        	downloadExcel = function() {
        		
        		var excelColumnModel = new Rui.ui.grid.LColumnModel({
                    gridView: defaultGridView,
                    	columns: [
                      	  new Rui.ui.grid.LNumberColumn()
                      	, { field: 'bizBptNm',        	label: '사업부문(Funding기준)',	    sortable: false,  align:'center', width: 130 }
                      	, { field: 'deptName',        	label: '조직',                		sortable: false,  align:'center', width: 100 }
                      	, { field: 'prjNm',        		label: 'Project',                	sortable: false,  align:'center', width: 200 }
                      	, { field: 'cnttTypeNm',        label: '계약 유형',               	sortable: false,  align:'center', width: 70 }
                      	, { field: 'tssNm',        		label: '과제명',               		sortable: false,  align:'left', width: 200 }
                      	, { field: 'cooInstNm',        	label: '협력기관명',              	sortable: false,  align:'center', width: 170 }
                      	, { field: 'spltNm',        	label: '협력기관연구책임자',        sortable: false,  align:'center', width: 100 }
                      	, { id: 'strTssStrtDd',        		label: '사업기간',              sortable: false,  align:'center', width: 80 
                      		, renderer: function(value, p, record, row, col){
                                  var strTssStrtDd = record.get("strTssStrtDd");
                                  var strTssFnhDd = record.get("strTssFnhDd");
                          		return strTssStrtDd + '~' + strTssFnhDd ;
                          	}
                      	  }
                      	, { field: 'tssDiffMon',        label: '소요 기간',               	sortable: false,  align:'right', width: 60 
                      		, renderer: function(value, p, record, row, col){
                          		return value + '개월';
                          	}
                      	  }
                      	, { field: 'wbsCd',        		label: 'WBS 코드',                	sortable: false,  align:'center', width: 60 }
                      	, { field: 'rsstExpMil',        label: '연구(억원)',            sortable: false,  align:'right', width: 60 }
                      	, { field: 'saName',        	label: '당사연구 책임자',       sortable: false,  align:'center', width: 100 }
                        ]
                });

                var excelColumnModel = excelColumnModel.createExcelColumnModel(false);
                defaultGrid.saveExcel(encodeURIComponent('대외협력과제 통계_') + new Date().format('%Y%m%d') + '.xls',{
                    columnModel: excelColumnModel
                });
            };
            
            // 화면로딩시 조회
            fnSearch();
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	   				<h2>대외협력과제</h2>
	   			</div>
	   			
   				<table class="searchBox">
   					<colgroup>
   						<col style="width:10%;"/>
   						<col style="width:35%;"/>
   						<col style="width:10%;"/>
   						<col style="width:35%;"/>
   						<col style="width:10%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">기간</th>
    						<td colspan="3">
   								<select name="cbSearchYear" id="cbSearchYear"></select>
    						</td>
   							<td class="t_center">
   								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				
   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadExcel()">Excel</button>
   					</div>
   				</div>

   				<div id="defaultGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>