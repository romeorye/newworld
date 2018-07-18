<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: genTssStat.jsp
 * @desc    : 
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
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
//             condYy = new Rui.ui.form.LTextBox({
//                 applyTo: 'condYy',
//                 width: 120
//             });
            
            
            lcbSearchYear = new Rui.ui.form.LCombo({
                applyTo: 'condYy',
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
            
            
            fnNprodSalsPlnY = function(value, p, record, row, col) {
                if(stringNullChk(value) == "") value = 0;
                value = (value / 100000000).toFixed(6);
                return Rui.util.LFormat.numberFormat(Math.round(value * 100) / 100);
            };
            
            
            fnGridNumberFormt = function(value, p, record, row, col) {
                if(stringNullChk(value) == "") value = 0;
                
                
                return Rui.util.LFormat.numberFormat(value.toFixed(1));
            };
            
            
            //Form 비활성화
            disableFields = function() {
                defaultGrid.setEditable(false);
            };
             
			
            /*******************
             * 변수 및 객체 선언
            *******************/
            var dataSet = new Rui.data.LJsonDataSet({
                id: 'dataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: false,
                fields: [
                      { id: 'wbsCd' }            //WBS Code
                    , { id: 'tssCd' }            //과제코드
                    , { id: 'deptName' }         //조직명
                    , { id: 'prjNm' }            //소속명(프로젝트명)
                    , { id: 'bizDptCd' }         //사업부문(Funding기준)
                    , { id: 'tssAttrCd' }        //과제속성
                    , { id: 'prodG' }            //제품군
                    , { id: 'ppslMbdCd' }        //발의주체
                    , { id: 'tssNm' }            //과제명
                    , { id: 'rsstSphe' }         //연구분야
                    , { id: 'tssType' }          //과제유형
                    , { id: 'saUserName' }       //과제리더명
                    , { id: 'tssStrtDd' }        //과제기간시작
                    , { id: 'tssFnhDdPln' }      //과제종료일-계획
                    , { id: 'tssFnhDdArsl' }     //과제종료일-실적
                    , { id: 'wnedTrmPln' }       //소요기간-계획
                    , { id: 'wnedTrmArsl' }      //소요기간-실적
                    , { id: 'ctyOtPlnY' }        //상품출시년도
                    , { id: 'ctyOtPlnM' }        //상품출시월
                    , { id: 'tssStNm' }          //상태명
                    , { id: 'pgsStepNm' }        //진행상태명
                    , { id: 'ancpOtPlnDt' }      //예상출시계획일
                    , { id: 'qgate3Dt' }         //Q-gate일자
                    , { id: 'dcacRsonTxt' }      //중단사유
                    , { id: 'nprodSalsPlnY',  type: 'number', defaultValue:0 }    //매출계획Y
                    , { id: 'nprodSalsPlnY1',  type: 'number', defaultValue:0 }   //매출계획Y1
                    , { id: 'nprodSalsPlnY2',  type: 'number', defaultValue:0 }   //매출계획Y2
                    , { id: 'nprodSalsPlnY3',  type: 'number', defaultValue:0 }   //매출계획Y3
                    , { id: 'nprodSalsPlnY4',  type: 'number', defaultValue:0 }   //매출계획Y4
                    , { id: 'nprodSalsPlnSum',  type: 'number', defaultValue:0 }  //5년평균
                    , { id: 'yYPlnExp',  type: 'number', defaultValue:0 }         //비용Y년-계획
                    , { id: 'yYArslExp',  type: 'number', defaultValue:0 }        //비용Y년-실적
                    , { id: 'allPlnExp',  type: 'number', defaultValue:0 }        //비용총합-계획
                    , { id: 'allArslExp',  type: 'number', defaultValue:0 }       //비용총합-실적
                    , { id: 'mbrCntPln',  type: 'number', defaultValue:0 }        //투입인원Y년-계획
                    , { id: 'mbrCntArsl',  type: 'number', defaultValue:0 }       //투입인원Y년-실적

                ]
            });

            var columnModel = new Rui.ui.grid.LColumnModel({
            	groupMerge: true,
                columns: [
                      { field: 'wbsCd',           label: '과제코드',              sortable: true,  align:'center', width: 80 }
                    , { field: 'deptName',        label: '조직',                  sortable: true,  align:'left', width: 140 }
                    , { field: 'prjNm',           label: '프로젝트명',            sortable: true,  align:'left', width: 140 }
                    , { field: 'bizDptCd',        label: '사업부문<br>(Funding기준)', sortable: false,  align:'left', width: 110 }
                    , { field: 'tssAttrCd',       label: '과제속성',              sortable: false,  align:'center', width: 70 }
                    , { field: 'prodG',           label: '제품군',                sortable: false,  align:'left', width: 80 }
                    , { field: 'ppslMbdCd',       label: '발의주체',              sortable: false,  align:'center', width: 80 }
                    , { field: 'tssNm',           label: '과제명',                sortable: false,  align:'left', width: 250 }
                    , { field: 'rsstSphe',        label: '연구분야',              sortable: false,  align:'center', width: 100 }
                    , { field: 'tssType',         label: '과제유형',              sortable: false,  align:'center', width: 100 }
                    , { field: 'saUserName',      label: '과제리더',              sortable: false,  align:'center', width: 70 }
                    , { field: 'tssStrtDd',       label: '과제시작일',            sortable: false,  align:'center', width: 80 }
                    
                    , { id: 'G1', label: '과제종료일' }
                    , { field: 'tssFnhDdPln',     label: '계획', groupId: 'G1', sortable: false,  align:'center', width: 80 }
                    , { field: 'tssFnhDdArsl',    label: '실적', groupId: 'G1', sortable: false,  align:'center', width: 80 }
                    
                    , { id: 'G2', label: '소요기간' }
                    , { field: 'wnedTrmPln',      label: '계획', groupId: 'G2', sortable: false,  align:'center', width: 40 }
                    , { field: 'wnedTrmArsl',     label: '실적', groupId: 'G2', sortable: false,  align:'center', width: 40 }
                    
                    , { id: 'G3', label: '상품출시 (계획)' }
                    , { field: 'ctyOtPlnY',       label: '년도', groupId: 'G3', sortable: false,  align:'center', width: 40 }
                    , { field: 'ctyOtPlnM',       label: '월',   groupId: 'G3', sortable: false,  align:'center', width: 40 }
                    
                    , { field: 'pgsStepNm',       label: '상태',         sortable: false,  align:'center', width: 60 }
                    , { field: 'tssStNm',         label: '처리상태',     sortable: false,  align:'center', width: 80 }
                    , { field: 'ancpOtPlnDt',     label: '예상출시계획', sortable: false,  align:'center', width: 90 }
                    , { field: 'qgate3Dt',        label: 'Q-gate일자',   sortable: false,  align:'center', width: 90 }
                    , { field: 'dcacRsonTxt',     label: '중단사유',     sortable: false,  align:'left', width: 200 }
                    
                    , { id: 'G4', label: '매출 계획(단위:억원)' }
                    , { field: 'nprodSalsPlnY',   label: 'Y',  groupId: 'G4', sortable: false,  align:'right', width: 50, renderer: fnNprodSalsPlnY }
                    , { field: 'nprodSalsPlnY1',  label: 'Y+1', groupId: 'G4', sortable: false,  align:'right', width: 50, renderer: fnNprodSalsPlnY }
                    , { field: 'nprodSalsPlnY2',  label: 'Y+2', groupId: 'G4', sortable: false,  align:'right', width: 50, renderer: fnNprodSalsPlnY }
                    , { field: 'nprodSalsPlnY3',  label: 'Y+3', groupId: 'G4', sortable: false,  align:'right', width: 50, renderer: fnNprodSalsPlnY }
                    , { field: 'nprodSalsPlnY4',  label: 'Y+4', groupId: 'G4', sortable: false,  align:'right', width: 50, renderer: fnNprodSalsPlnY }
                    
                    , { field: 'nprodSalsPlnSum', label: '5년평균', sortable: false,  align:'right', width: 70, renderer: function(value, p, record, row, col) {
                        var cnt = 0;
                        var nprodSalsPlnY = record.data.nprodSalsPlnY;
                        var nprodSalsPlnY1 = record.data.nprodSalsPlnY1;
                        var nprodSalsPlnY2 = record.data.nprodSalsPlnY2;
                        var nprodSalsPlnY3 = record.data.nprodSalsPlnY3;
                        var nprodSalsPlnY4 = record.data.nprodSalsPlnY4;
                        
                        if(nprodSalsPlnY > 0) cnt++;
                        if(nprodSalsPlnY1 > 0) cnt++;
                        if(nprodSalsPlnY2 > 0) cnt++;
                        if(nprodSalsPlnY3 > 0) cnt++;
                        if(nprodSalsPlnY4 > 0) cnt++;
                        if(cnt == 0) cnt++;
                        
                        value = (nprodSalsPlnY + nprodSalsPlnY1 + nprodSalsPlnY2 + nprodSalsPlnY3 + nprodSalsPlnY4) / cnt / 100000000.00;
                        value = (value * 100) / 100;
                        
                        return Rui.util.LFormat.numberFormat(value.toFixed(1));
                    }}
                    
                    , { id: 'G5', label: '비용(Y년)(단위:억원)' }
                    , { field: 'yYPlnExp',        label: '계획', groupId: 'G5', sortable: false,  align:'right', width: 80, renderer: fnGridNumberFormt }
                    , { field: 'yYArslExp',       label: '실적', groupId: 'G5', sortable: false,  align:'right', width: 80, renderer: fnGridNumberFormt }
                    
                    , { id: 'G6', label: '비용(총합)(단위:억원)' }
                    , { field: 'allPlnExp',       label: '계획', groupId: 'G6', sortable: false,  align:'right', width: 80, renderer: fnGridNumberFormt }
                    , { field: 'allArslExp',      label: '실적', groupId: 'G6', sortable: false,  align:'right', width: 80, renderer: fnGridNumberFormt }
                    
                    , { id: 'G7', label: '투입인원(Y년)' }
                    , { field: 'mbrCntPln',       label: '계획', groupId: 'G7', sortable: false,  align:'center', width: 60 }
                    , { field: 'mbrCntArsl',      label: '실적', groupId: 'G7', sortable: false,  align:'center', width: 60 }
                ]
            });

            var defaultGrid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: dataSet,
                width: 860,
                height: 590,
                autoToEdit: true,
                clickToEdit: true,
                enterToEdit: true,
                autoWidth: true,
                autoHeight: true,
                multiLineEditor: true,
                usePasteCellEvent: true,
                useRightActionMenu: false
            });
            
            defaultGrid.render('defaultGrid');

            /* 조회 */
            fnSearch = function() {
                dataSet.load({
                    url: '<c:url value="/stat/prj/retrieveGenTssStatList.do"/>',
                    params :{
                        condYy: lcbSearchYear.getValue() == null ? "" : lcbSearchYear.getValue()
                    }
                });
            };
            
            dataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + dataSet.getCount() + '건');
   	      	});
            
            
        	downloadExcel = function() {
        		defaultGrid.saveExcel(encodeURIComponent('일반과제 통계_') + new Date().format('%Y%m%d') + '.xls');
            };
            
            
            fnSearch();
            disableFields();
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
   		<div class="contents">
   			<div class="sub-content">
	   			<div class="titleArea">
	   				<h2>일반과제</h2>
	   			</div>
   				<table class="searchBox">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:75%;"/>
   						<col style="width:10%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">년도</th>
    						<td>
<!--    								<input type="text" id="condYy"/> -->
   								<select name="condYy" id="condYy"></select>
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