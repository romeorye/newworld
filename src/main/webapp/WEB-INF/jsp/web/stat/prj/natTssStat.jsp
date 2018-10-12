<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: natTssStat.jsp
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
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

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


            fnGridNumberFormt = function(value, p, record, row, col) {
                if(stringNullChk(value) == "") value = 0;
                return Rui.util.LFormat.numberFormat(value);
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
                      { id: 'wbsCd' }         //과제번호
                    , { id: 'tssCd' }         //과제코드
                    , { id: 'deptName' }      //조직
                    , { id: 'prjNm' }         //프로젝트명
                    , { id: 'bizNm' }         //사업명
                    , { id: 'supvOpsNm' }     //주관부처
                    , { id: 'tssNm' }         //과제명
//                     , { id: 'tssSmryTxt' }    //과제개요
                    , { id: 'saUserName' }    //과제리더
                    , { id: 'tssStrtDd' }     //과제시작일
                    , { id: 'tssFnhDdPln' }   //과제종료일-계획
                    , { id: 'tssFnhDdArsl' }  //과제종료일-실적
                    , { id: 'tssFnhDdStoa' }  //과제종료일-정산
                    , { id: 'wnedTrmPln' }    //소요기간-계획
                    , { id: 'wnedTrmArsl' }   //소요기간-실적
                    , { id: 'wnedTrmStoa' }   //소요기간-정산
                    , { id: 'pgsStepNm' }     //진행상태
                    , { id: 'tssStNm' }       //상태
                    , { id: 'gvmCash1' }      //1차년도정부출연금-현금
                    , { id: 'gvmAthg1' }      //1차년도민간부담금-현물
                    , { id: 'prvCash1' }      //1차년도정부출연금-현금
                    , { id: 'prvAthg1' }      //1차년도민간부담금-현물
                    , { id: 'gvmCash2' }      //2차년도정부출연금-현금
                    , { id: 'gvmAthg2' }      //2차년도민간부담금-현물
                    , { id: 'prvCash2' }      //2차년도정부출연금-현금
                    , { id: 'prvAthg2' }      //2차년도민간부담금-현물
                    , { id: 'gvmCash3' }      //3차년도정부출연금-현금
                    , { id: 'gvmAthg3' }      //3차년도민간부담금-현물
                    , { id: 'prvCash3' }      //3차년도정부출연금-현금
                    , { id: 'prvAthg3' }      //3차년도민간부담금-현물
                    , { id: 'gvmCash4' }      //4차년도정부출연금-현금
                    , { id: 'gvmAthg4' }      //4차년도민간부담금-현물
                    , { id: 'prvCash4' }      //4차년도정부출연금-현금
                    , { id: 'prvAthg4' }      //4차년도민간부담금-현물
                    , { id: 'gvmCash5' }      //5차년도정부출연금-현금
                    , { id: 'gvmAthg5' }      //5차년도민간부담금-현물
                    , { id: 'prvCash5' }      //5차년도정부출연금-현금
                    , { id: 'prvAthg5' }      //5차년도민간부담금-현물
                    , { id: 'gvmCashSum' }    //정부출연금-현금
                    , { id: 'gvmAthgSum' }    //민간부담금-현물
                    , { id: 'prvCashSum' }    //정부출연금-현금
                    , { id: 'prvAthgSum' }    //민간부담금-현물
                ]
            });

            var columnModel = new Rui.ui.grid.LColumnModel({
            	groupMerge: true,
                columns: [
                      { field: 'wbsCd',           label: '과제번호',        sortable: false,  align:'center', width: 80 }
                    , { field: 'deptName',        label: '조직',            sortable: false,  align:'center', width: 180 }
                    , { field: 'prjNm',           label: '프로젝트명',      sortable: false,  align:'center', width: 180 }
                    , { field: 'bizNm',           label: '사업명',          sortable: false,  align:'left', width: 100 }
                    , { field: 'supvOpsNm',       label: '주관부처',        sortable: false,  align:'left', width: 100 }
                    , { field: 'tssNm',           label: '과제명',          sortable: false,  align:'left', width: 250 }
//                     , { field: 'tssSmryTxt',      label: '과제개요',        sortable: false,  align:'center', width: 100 }
                    , { field: 'saUserName',      label: '과제리더',        sortable: false,  align:'center', width: 80 }
                    , { field: 'tssStrtDd',       label: '과제시작일',      sortable: false,  align:'center', width: 90 }

                    , { id: 'G1', label: '과제종료일' }
                    , { field: 'tssFnhDdPln',     label: '계획', groupId: 'G1', sortable: false,  align:'center', width: 90 }
                    , { field: 'tssFnhDdArsl',    label: '실적', groupId: 'G1', sortable: false,  align:'center', width: 90 }
                    , { field: 'tssFnhDdStoa',    label: '정산', groupId: 'G1', sortable: false,  align:'center', width: 90 }

                    , { id: 'G2', label: '소요기간' }
                    , { field: 'wnedTrmPln',      label: '계획', groupId: 'G2', sortable: false,  align:'center', width: 50 }
                    , { field: 'wnedTrmArsl',     label: '실적', groupId: 'G2', sortable: false,  align:'center', width: 50 }
                    , { field: 'wnedTrmStoa',     label: '정산', groupId: 'G2', sortable: false,  align:'center', width: 50 }

                    , { field: 'pgsStepNm',       label: '진행상태',        sortable: false,  align:'center', width: 80 }
                    , { field: 'tssStNm',         label: '상태',            sortable: false,  align:'center', width: 100 }

                    , { id: 'G3', label: '1차년도 정부출연금(단위:천원)' }
                    , { field: 'gvmAthg1', label: '현물', groupId: 'G3', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'gvmCash1', label: '현금', groupId: 'G3', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G4', label: '1차년도 민간부담금(단위:천원)' }
                    , { field: 'prvAthg1', label: '현물', groupId: 'G4', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'prvCash1', label: '현금', groupId: 'G4', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G5', label: '2차년도 정부출연금(단위:천원)' }
                    , { field: 'gvmAthg2', label: '현물', groupId: 'G5', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'gvmCash2', label: '현금', groupId: 'G5', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G6', label: '2차년도 민간부담금(단위:천원)' }
                    , { field: 'prvAthg2', label: '현물', groupId: 'G6', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'prvCash2', label: '현금', groupId: 'G6', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G7', label: '3차년도 정부출연금(단위:천원)' }
                    , { field: 'gvmAthg3', label: '현물', groupId: 'G7', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'gvmCash3', label: '현금', groupId: 'G7', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G8', label: '3차년도 민간부담금(단위:천원)' }
                    , { field: 'prvAthg3', label: '현물', groupId: 'G8', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'prvCash3', label: '현금', groupId: 'G8', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G9', label: '4차년도 정부출연금(단위:천원)' }
                    , { field: 'gvmAthg4', label: '현물', groupId: 'G9', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'gvmCash4', label: '현금', groupId: 'G9', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G10', label: '4차년도 민간부담금(단위:천원)' }
                    , { field: 'prvAthg4', label: '현물', groupId: 'G10', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'prvCash4', label: '현금', groupId: 'G10', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G11', label: '5차년도 정부출연금(단위:천원)' }
                    , { field: 'gvmAthg5', label: '현물', groupId: 'G11', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'gvmCash5', label: '현금', groupId: 'G11', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G12', label: '5차년도 민간부담금(단위:천원)' }
                    , { field: 'prvAthg5', label: '현물', groupId: 'G12', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'prvCash5', label: '현금', groupId: 'G12', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G13', label: '총 정부출연금(단위:천원)' }
                    , { field: 'gvmAthgSum', label: '현물', groupId: 'G13', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'gvmCashSum', label: '현금', groupId: 'G13', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }

                    , { id: 'G14', label: '총 민간부담금(단위:천원)' }
                    , { field: 'prvAthgSum', label: '현물', groupId: 'G14', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                    , { field: 'prvCashSum', label: '현금', groupId: 'G14', sortable: false,  align:'right', width: 100, renderer: fnGridNumberFormt }
                ]
            });

            var defaultGrid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: dataSet,
                width: 860,
                height: 400,
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


            //유효성
//             vm = new Rui.validate.LValidatorManager({
//                 validators: [
//                     { id: 'condYy', validExp: '년도:false:number&length=4' }
//                 ]
//             });

            /* 조회 */
            fnSearch = function() {
//                 condYy.blur();

//                 if(!vm.validateGroup("aform")) {
//                     Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
//                     return false;
//                 }

                dataSet.load({
                    url: '<c:url value="/stat/prj/retrieveNatTssStatList.do"/>',
                    params :{
                        condYy: lcbSearchYear.getValue() == null ? "" : lcbSearchYear.getValue()
                    }
                });
            };

            dataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + dataSet.getCount() + '건');
   	    	// 목록 페이징
   	    		paging(dataSet,"defaultGrid");
   	      	});

        	downloadExcel = function() {
        		// 엑셀 다운로드시 전체 다운로드를 위해 추가
        		dataSet.clearFilter();
        		defaultGrid.saveExcel(encodeURIComponent('국책과제 통계_') + new Date().format('%Y%m%d') + '.xls');
        		// 목록 페이징
        		paging(dataSet,"defaultGrid");
            };

            fnSearch();

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
	   				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	   				<span class="hidden">Toggle 버튼</span>
   				</a>
   				<h2>국책과제</h2>
   			</div>

	   		<div class="sub-content">
	   			<div class="search">
		   			<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">년도</th>
		    						<td>
		<!--    								<input type="text" id="condYy"/> -->
		   								<select name="condYy" id="condYy"></select>
		   								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>
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