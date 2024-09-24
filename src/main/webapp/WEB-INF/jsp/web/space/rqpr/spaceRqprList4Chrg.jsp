<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceRqprList4Chrg.jsp
 * @desc    : 평가의뢰관리 리스트(담당자용)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.28  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 2차 프로젝트
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
	 var getSpaceRqprList;
	 var tmpAcpcStCd = '${inputData.spaceAcpcStCd}';

		Rui.onReady(function() {
             /*******************
              * 변수 및 객체 선언
             *******************/
             /***** 제품군(사업부) *****/
             var spaceEvBzdvDataSet = new Rui.data.LJsonDataSet({
                 id: 'spaceEvBzdvDataSet',
                 remainRemoved: true,
                 lazyLoad: true,
                 fields: [
                    { id: 'ctgrCd' }
                  , { id: 'ctgrNm' }
                 ]
             });
             spaceEvBzdvDataSet.load({
                 url: '<c:url value="/space/spaceEvBzdvList.do"/>'
             });

             var cmbCtgr0Cd = new Rui.ui.form.LCombo({
                 applyTo: 'cmbCtgr0Cd',
                 name: 'cmbCtgr0Cd',
                 emptyText: '사업부 선택',
                 defaultValue: '',
                 emptyValue: '',
                 width: 200,
                 dataSet: spaceEvBzdvDataSet,
                 displayField: 'ctgrNm',
                 valueField: 'ctgrCd'
             });

             /***** 의뢰일자 *****/
             var fromRqprDt = new Rui.ui.form.LDateBox({
  				applyTo: 'fromRqprDt',
  				mask: '9999-99-99',
  				displayValue: '%Y-%m-%d',
  				defaultValue: '<c:out value="${inputData.fromRqprDt}"/>',
  				editable: false,
  				width: 100,
  				dateType: 'string'
  			});

             fromRqprDt.on('blur', function(){
  				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromRqprDt.getValue(),"-","")) ) )  {
  					alert('날짜형식이 올바르지 않습니다.!!');
  					fromRqprDt.setValue(new Date());
  				}
  				if( fromRqprDt.getValue() > toRqprDt.getValue() ) {
  					alert('시작일이 종료일보다 클 수 없습니다.!!');
  					fromRqprDt.setValue(toRqprDt.getValue());
  				}
  			});

             var toRqprDt = new Rui.ui.form.LDateBox({
  				applyTo: 'toRqprDt',
  				mask: '9999-99-99',
  				defaultValue: '<c:out value="${inputData.toRqprDt}"/>',
  				displayValue: '%Y-%m-%d',
  				editable: false,
  				width: 100,
  				dateType: 'string'
  			});

  			toRqprDt.on('blur', function(){
  				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toRqprDt.getValue(),"-","")) ) )  {
  					alert('날짜형식이 올바르지 않습니다.!!');
  					toRqprDt.setValue(new Date());
  				}

  				if( fromRqprDt.getValue() > toRqprDt.getValue() ) {
  					alert('시작일이 종료일보다 클 수 없습니다.!!');
  					fromRqprDt.setValue(toRqprDt.getValue());
  				}
  			});
/* 
  			var rgstNm = new Rui.ui.form.LTextBox({
                 applyTo: 'wbsCd',
                 placeholder: 'WBS코드를 입력해주세요.',
                 defaultValue: '<c:out value="${inputData.wbsCd}"/>',
                 emptyValue: '',
                 width: 400
             });
 */
             var spaceNm = new Rui.ui.form.LTextBox({
                 applyTo: 'spaceNm',
                 placeholder: '검색할 평가명을 입력해주세요.',
                 defaultValue: '<c:out value="${inputData.spaceNm}"/>',
                 emptyValue: '',
                 width: 400
             });

             spaceNm.on('blur', function(e) {
             	spaceNm.setValue(spaceNm.getValue().trim());
             });

             var rgstNm = new Rui.ui.form.LTextBox({
                 applyTo: 'rgstNm',
                 placeholder: '검색할 의뢰자를 입력해주세요.',
                 defaultValue: '<c:out value="${inputData.rgstNm}"/>',
                 emptyValue: '',
                 width: 200
             });

             var acpcNo = new Rui.ui.form.LTextBox({
                 applyTo: 'acpcNo',
                 placeholder: '의뢰ID 또는 접수번호를 입력해주세요.',
                 defaultValue: '<c:out value="${inputData.acpcNo}"/>',
                 emptyValue: '',
                 width: 200
             });
             acpcNo.on('blur', function(e) {
             	acpcNo.setValue(acpcNo.getValue().trim());
             });

 			var spaceChrgNm = new Rui.ui.form.LTextBox({
                 applyTo: 'spaceChrgNm',
                 placeholder: '검색할 담당자를 입력해주세요.',
                 defaultValue: '<c:out value="${inputData.spaceChrgNm}"/>',
                 emptyValue: '',
                 width: 200
             });

             var spaceAcpcStCd = new Rui.ui.form.LCombo({
                 applyTo: 'spaceAcpcStCd',
                 name: 'spaceAcpcStCd',
                 useEmptyText: true,
                 emptyText: '(전체)',
                 defaultValue: '<c:out value="${inputData.spaceAcpcStCd}"/>',
                 emptyValue: '',
                 url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=SPACE_ACPC_ST_CD"/>',
                 displayField: 'COM_DTL_NM',
                 valueField: 'COM_DTL_CD'
             });

             /*******************
              * 변수 및 객체 선언
             *******************/
 			var spaceRqprDataSet = new Rui.data.LJsonDataSet({
                 id: 'spaceRqprDataSet',
                 remainRemoved: true,
                 lazyLoad: true,
                 fields: [
 					  { id: 'rqprId'		}
 					, { id: 'acpcNo',		}
 					, { id: 'spaceScnNm',	}
 					, { id: 'spaceNm',		}
 					, { id: 'CtrgNames',	}
 					, { id: 'PrvsNames',	}
 					, { id: 'rgstNm',		}
 					, { id: 'CrgrNames',	}
 					, { id: 'rqprDt',		}
 					, { id: 'cmplDt',		}
 					, { id: 'spaceUgyYnNm',	}
 					, { id: 'oppbScpCd',	}
 					, { id: 'acpcStNm',		}
                 ]
             });

             var spaceRqprColumnModel = new Rui.ui.grid.LColumnModel({
                 columns: [
					  { field: 'rqprId',		label: '의뢰ID',			sortable: true,		align:'center',	width: 80 }
					, { field: 'acpcNo',		label: '접수번호',		sortable: true,		align:'center',	width: 90 }
 					, { field: 'spaceScnNm',	label: '평가구분',		sortable: false,	align:'center',	width: 80 }
 					, { field: 'spaceNm',		label: '평가명',			sortable: false,	align:'left',	width: 350 }
 					, { field: 'CtrgNames',		label: '평가카테고리',	sortable: false,	align:'center',	width: 110 }
 					, { field: 'PrvsNames',		label: '평가항목',		sortable: false,	align:'center',	width: 90 }
 					, { field: 'rgstNm',		label: '의뢰자',			sortable: false,	align:'center',	width: 70 }
 					, { field: 'CrgrNames',		label: '담당자',			sortable: false,	align:'center',	width: 90 }
 					, { field: 'rqprDt',		label: '의뢰일',			sortable: true,		align:'center',	width: 80 }
 					, { field: 'cmplDt',		label: '완료일',			sortable: true,		align:'center',	width: 80 }
 					, { field: 'spaceUgyYnNm',	label: '긴급',			sortable: false,	align:'center',	width: 60 }
 					, { field: 'oppbScpCd',		label: '비밀',			sortable: true,		align:'center',	width: 60 }
 					, { field: 'acpcStNm',		label: '상태',			sortable: false,	align:'center',	width: 80 }
            		]
             });

             var spaceRqprGrid = new Rui.ui.grid.LGridPanel({
                 columnModel: spaceRqprColumnModel,
                 dataSet: spaceRqprDataSet,
                 width: 600,
                 height: 400,
                 autoToEdit: false,
                 autoWidth: true
             });

            spaceRqprGrid.on('cellClick', function(e) {

            	var record = spaceRqprDataSet.getAt(e.row);

            	$('#rqprId').val(record.data.rqprId);

            	nwinsActSubmit(aform, "<c:url value='/space/spaceRqprDetail4Chrg.do'/>");
            });

            spaceRqprGrid.render('spaceRqprGrid');

            /* 평가의뢰 담당자용 리스트 엑셀 다운로드 */
        	downloadSpaceRqprListExcel = function() {
            	if (spaceRqprDataSet.getCount()>0) {
					// 엑셀 다운로드시 전체 다운로드를 위해 추가
					spaceRqprDataSet.clearFilter();
					
					var excelColumnModel = spaceRqprColumnModel.createExcelColumnModel(false);
					duplicateExcelGrid(excelColumnModel);
					nG.saveExcel(encodeURIComponent('평가목록_') + new Date().format('%Y%m%d') + '.xls');
					
					// 목록 페이징
					paging(spaceRqprDataSet,"spaceRqprGrid");
            	} else {
            		Rui.alert("조회 후 엑셀 다운로드 해주세요.");
            	}
            };

            /* 조회 */
            getSpaceRqprList = function() {
        	   spaceRqprDataSet.load({
                    url: '<c:url value="/space/getSpaceRqprList.do"/>',
                    params :{
                    	spaceNm : encodeURIComponent(spaceNm.getValue()),
            		    fromRqprDt : fromRqprDt.getValue(),
            		    toRqprDt : toRqprDt.getValue(),
            		    rqprDeptCd : $('#rqprDeptCd').val(),
            		    rgstNm : encodeURIComponent(rgstNm.getValue()),
            		    spaceChrgNm : encodeURIComponent(spaceChrgNm.getValue()),
            		    acpcNo : encodeURIComponent(acpcNo.getValue()),
//            		    spaceAcpcStCd : spaceAcpcStCd.getValue(),
            		    spaceAcpcStCd : document.aform.spaceAcpcStCd.value,
            		    isSpaceChrg : 1
                    }
                });
            };
            spaceRqprDataSet.on('load', function(e) {
				$("#cnt_text").html('총 ' + spaceRqprDataSet.getCount() + '건');
				// 목록 페이징
				paging(spaceRqprDataSet,"spaceRqprGrid");
   	      	});
            //getSpaceRqprList();
            init = function() {
        	   //var wbsCd='${inputData.wbsCd}';
        	   var rgstNm='${inputData.rgstNm}';
        	   var spaceNm='${inputData.spaceNm}';
        	   var spaceChrgNm='${inputData.spaceChrgNm}';
        	   var acpcNo='${inputData.acpcNo}';
        	   spaceRqprDataSet.load({
                    url: '<c:url value="/space/getSpaceRqprList.do"/>',
                    params :{
                    	cmbCtgr0Cd : '${inputData.cmbCtgr0Cd}',
                    	fromRqprDt : '${inputData.fromRqprDt}',
                    	toRqprDt : '${inputData.toRqprDt}',
                    	//wbsCd : escape(encodeURIComponent(wbsCd)),
                    	rgstNm : escape(encodeURIComponent(rgstNm)),
                    	spaceNm : escape(encodeURIComponent(spaceNm)),
                    	spaceChrgNm : escape(encodeURIComponent(spaceChrgNm)),
                    	acpcNo : escape(encodeURIComponent(acpcNo)),
                    	rqprDeptCd : $('#rqprDeptCd').val(),
                    	spaceAcpcStCd : '${inputData.spaceAcpcStCd}',
                    	isSpaceChrg : 1
                    }
                });
            }

        });

	</script>
	<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
    </head>
    <body onkeypress="if(event.keyCode==13) {getSpaceRqprList();}" onload="init();">
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="rqprDeptCd" name="rqprDeptCd" value="<c:out value="${inputData.rqprDeptCd}"/>"/>
		<input type="hidden" id="rqprId" name="rqprId" value=""/>

   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
					<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
					<span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>평가목록</h2>
   			</div>
			<div class="sub-content">
				<div class="search">
					<div class="search-content">
		   				<table class="rqprlist_sch">
		   					<colgroup>
		   						<col style="width:110px;"/>
		   						<col style="width:350px;"/>
		   						<col style="width:80px;"/>
		   						<col style="width:350px;"/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">제품군</th>
		   							<td>
		   								<select id="cmbCtgr0Cd"></select>
		   							</td>
		   							<th align="right">의뢰일자</th>
		    						<td>
		   								<input type="text" id="fromRqprDt"/><em class="gab"> ~ </em>
		   								<input type="text" id="toRqprDt"/>
		    						</td>
		   							<td></td>
		   						</tr>

		   						<tr>
		   							<th align="right">접수번호</th>
		   							<td class="tdin_w100">
		   								<input type="text" id="acpcNo">
		   							</td>
		   							<th align="right">의뢰자</th>
		    						<td class="tdin_w100">
		    							<input type="text" id="rgstNm">
		    						</td>
		    						<td class="t_center" rowspan="4">
		   								<a style="cursor: pointer;" onclick="getSpaceRqprList();" class="btnL">검색</a>
		   							</td>
		   						</tr>

		   						<tr>
		   							<th align="right">평가명</th>
		   							<td class="tdin_w100">
		   								<input type="text" id="spaceNm">
		   							</td>
		   							<th align="right">담당자</th>
		    						<td class="tdin_w100">
		    							<input type="text" id="spaceChrgNm">
		    						</td>
		    						<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">상태</th>
		   							<td>
		                                <div id="spaceAcpcStCd"></div>
		   							</td>
		   							<td></td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadSpaceRqprListExcel()">Excel</button>
   					</div>
   				</div>

   				<div id="spaceRqprGrid"></div>

				<div id="spaceRqprExcelGrid" style="width:10px;height:10px;visibility:hidden;"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>