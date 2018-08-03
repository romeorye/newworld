<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceEvaluationMgmt.jsp
 * @desc    : 분석의뢰관리 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.02  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 2차 프로젝트
 *************************************************************************
 */
--%>
				 
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

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
            var textBox = new Rui.ui.form.LTextBox({
                emptyValue: ''
            });
            
            
            /* 사업부 데이터셋 */
            var spaceEvBzdvDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvBzdvDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                      { id: 'ctgrCd' }
     				, { id: 'ctgrNm' }
                ]
            });
            /* 제품군 데이터셋 */
            var spaceEvProdClDataSet = new Rui.data.LJsonDataSet({
            	id: 'spaceEvProdClDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                      { id: 'supiCd' }
     				, { id: 'ctgrCd' }
     				, { id: 'ctgrNm' }
                ]
            });
            /* 분류 데이터셋 */
            var spaceEvClDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvClDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'supiCd' }
					, { id: 'ctgrCd' }
					, { id: 'ctgrNm' }
                ]
            });
            /* 제품 데이터셋 */
            var spaceEvProdDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvProdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'supiCd' }
					, { id: 'ctgrCd' }
					, { id: 'ctgrNm' }
                ]
            });
            /* 자재단위평가 데이터셋 */
            var spaceEvMtrlListDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvMtrlListDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'scn' }
					, { id: 'pfmcVal' }
					, { id: 'vldDt' }
					, { id: 'frstRgstDt' }
					, { id: 'vldDt' }
					, { id: 'attcFileId' }
					, { id: 'rem' }
                ]
            });
            
            
            
            //사업부 그리드 컬럼 설정
            var spaceEvBzdvModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'ctgrCd',	label: '코드',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 80 }
                    , { field: 'ctgrNm',	label: '제품군',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                ]
            });
          	
            //제품군 그리드 컬럼 설정
            var spaceEvProdClModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'supiCd',	label: '상위코드',	sortable: false,	editable: true, editor: textBox,	align:'center',	width: 80 }
                    , { field: 'ctgrCd',	label: '코드',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 80 }
                    , { field: 'ctgrNm',	label: '제품군',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                ]
            });
            
          	//분류 그리드 컬럼 설정
            var spaceEvClModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'supiCd',	label: '상위코드',	sortable: false,	editable: true, editor: textBox,	align:'center',	width: 80 }
                    , { field: 'ctgrCd',	label: '코드',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 80 }
                    , { field: 'ctgrNm',	label: '제품군',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                ]
            });
          
          	//제품 그리드 컬럼 설정
            var spaceEvProdModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'supiCd',	label: '상위코드',	sortable: false,	editable: true, editor: textBox,	align:'center',	width: 80 }
                    , { field: 'ctgrCd',	label: '코드',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 80 }
                    , { field: 'ctgrNm',	label: '제품군',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                ]
            });
          	
            //자재단위평가 그리드 컬럼 설정
            var spaceEvMtrlListModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'scn',			label: '구분',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'pfmcVal',		label: '성능값',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'vldDt',			label: '유효일',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'frstRgstDt',	label: '등록일',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'attcFileId',	label: '파일경로',	sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'rem',			label: '비고',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 200 }
                ]
            });
            
          	
          	
            
            //사업부 그리드 패널 설정
            var spaceEvBzdvGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvBzdvModel,
                dataSet: spaceEvBzdvDataSet,
                width: 200,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvBzdvGrid.render('spaceEvBzdvGrid');
            
            //제품군 그리드 패널 설정
            var spaceEvProdClGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvProdClModel,
                dataSet: spaceEvProdClDataSet,
                width: 200,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvProdClGrid.render('spaceEvProdClGrid');
            
            //분류 그리드 패널 설정
            var spaceEvClGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvClModel,
                dataSet: spaceEvClDataSet,
                width: 200,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvClGrid.render('spaceEvClGrid');
            
            //제품 그리드 패널 설정
            var spaceEvProdGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvProdModel,
                dataSet: spaceEvProdDataSet,
                width: 200,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvProdGrid.render('spaceEvProdGrid');
            
            //자재단위평가 그리드 패널 설정
            var spaceEvMtrlListGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvMtrlListModel,
                dataSet: spaceEvMtrlListDataSet,
                width: 600,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvMtrlListGrid.render('spaceEvMtrlListGrid');
            
            
            
            /* 사업부 조회 */
            getSpaceEvBzdvList = function() {
            	spaceEvBzdvDataSet.load({
                    url: '<c:url value="/space/spaceEvBzdvList.do"/>'
                });
            };
            //화면 로딩시 조회
            getSpaceEvBzdvList();
            
            
            
            /* 사업부 그리드 클릭 -> 제품군 조회 */
            spaceEvBzdvGrid.on('cellClick', function(e) {
            	var record = spaceEvBzdvDataSet.getAt(e.row);
            	var supiCd = record.data.ctgrCd;
            	//제품군 조회
            	spaceEvProdClDataSet.load({
                    url: '<c:url value="/space/spaceEvProdClList.do"/>',
                    params :{ supiCd:supiCd }
                });

            	//분류 초기화
            	spaceEvClDataSet.clearData();
				//제품 초기화
            	spaceEvProdDataSet.clearData();
            });
            
            /* 제품군 그리드 클릭 -> 분류 조회 */
            spaceEvProdClGrid.on('cellClick', function(e) {
            	var record = spaceEvProdClDataSet.getAt(e.row);
            	var supiCd = record.data.ctgrCd;
            	spaceEvClDataSet.load({
                    url: '<c:url value="/space/spaceEvClList.do"/>',
                    params :{ supiCd:supiCd }
                });
            	
				//제품 초기화
            	spaceEvProdDataSet.clearData();
            });
            
            
            /* 분류 그리드 클릭 -> 제품 조회 */
            spaceEvClGrid.on('cellClick', function(e) {
            	var record = spaceEvClDataSet.getAt(e.row);
            	var supiCd = record.data.ctgrCd;
            	spaceEvProdDataSet.load({
                    url: '<c:url value="/space/spaceEvProdList.do"/>',
                    params :{ supiCd:supiCd }
                });
            });
            
            
            /* 제품 그리드 클릭 -> 상세목록 조회 */
            spaceEvProdGrid.on('cellClick', function(e) {
            	var record = spaceEvProdDataSet.getAt(e.row);
            	var supiCd = record.data.CTGR_CD;
            	spaceEvMtrlListDataSet.load({
                    url: '<c:url value="/space/spaceEvProdList.do"/>',
                    params :{ supiCd:supiCd }
                });
            });
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="rqprId" name="rqprId" value=""/>
		
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	   				<h2>공간평가 평가법관리</h2>
	   			</div>
	   			
	   			<table style="width:100%;border=0;">
   					<colgroup>
						<col style="width:20%;">
						<col style="width:20%;">
						<col style="width:20%;">
						<col style="width:20%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<td>
				   				<div class="titArea">
				   					<h3>사업부</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep0Btn" name="addStep0Btn" onclick="addStep0();">추가</button>
								   		<button type="button" class="btn"  id="delStep0dBtn" name="delStep0dBtn" onclick="deleteStep0();">삭제</button>
								   		<button type="button" class="btn"  id="saveStep0dBtn" name="saveStep0dBtn" onclick="saveStep0();">저장</button>
				   					</div>
				   				</div>
				   				
				   				<div id="spaceEvBzdvGrid"></div>
				   				
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>제품군</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep1Btn" name="addStep1Btn" onclick="addStep1();">추가</button>
								   		<button type="button" class="btn"  id="delStep1dBtn" name="delStep1dBtn" onclick="deleteStep1();">삭제</button>
								   		<button type="button" class="btn"  id="saveStep1dBtn" name="saveStep1dBtn" onclick="saveStep1();">저장</button>
				   					</div>
				   				</div>
				
				   				<div id="spaceEvProdClGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>분류</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep2Btn" name="addStep2Btn" onclick="addStep2();">추가</button>
								   		<button type="button" class="btn"  id="delStep2dBtn" name="delStep2dBtn" onclick="deleteStep2();">삭제</button>
								   		<button type="button" class="btn"  id="saveStep2dBtn" name="saveStep2dBtn" onclick="saveStep2();">저장</button>
				   					</div>
				   				</div>
				
				   				<div id="spaceEvClGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>제품</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep3Btn" name="addStep3Btn" onclick="addStep3();">추가</button>
								   		<button type="button" class="btn"  id="delStep3dBtn" name="delStep3dBtn" onclick="deleteStep3();">삭제</button>
								   		<button type="button" class="btn"  id="saveStep3dBtn" name="saveStep3dBtn" onclick="saveStep3();">저장</button>
				   					</div>
				   				</div>
				
				   				<div id="spaceEvProdGrid"></div>
   							</td>
   						</tr>
   						<tr>
   							<td colspan="7">
				   				<div class="titArea">
				   					<h3>자재 단위 평가</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep0Btn" name="addStep0Btn" onclick="addStep0();">성적서 등록</button>
								   		<button type="button" class="btn"  id="delStep0dBtn" name="delStep0dBtn" onclick="deleteStep0();">삭제</button>
				   					</div>
				   				</div>
				   				
				   				<div id="spaceEvMtrlListGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>
				
				
				
				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>