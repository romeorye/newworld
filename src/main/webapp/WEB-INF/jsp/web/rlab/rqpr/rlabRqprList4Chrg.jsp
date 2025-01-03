<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprList4Chrg.jsp
 * @desc    : 시험의뢰관리 리스트(담당자용)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.17  정현웅		최초생성
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
	 var getRlabRqprList;
	 var tmpAcpcStCd = '${inputData.rlabAcpcStCd}';

		Rui.onReady(function() {
             /*******************
              * 변수 및 객체 선언
             *******************/
             var rlabRqprDataSet = new Rui.data.LJsonDataSet({
                 id: 'rlabRqprDataSet',
                 remainRemoved: true,
                 lazyLoad: true,
                 fields: [
 					  { id: 'rqprId'}
 					, { id: 'acpcNo' }
 					, { id: 'rlabScnNm' }
 					, { id: 'rlabNm' }
 					, { id: 'rgstNm' }
 					, { id: 'rlabChrgNm' }
 					, { id: 'rqprDt' }
 					, { id: 'acpcDt' }
 					, { id: 'cmplParrDt' }
 					, { id: 'cmplDt' }
 					, { id: 'rlabUgyYnNm' }
 					, { id: 'acpcStNm' }
 					, { id: 'smpoCnt' }
                 ]
             });

             var rlabRqprColumnModel = new Rui.ui.grid.LColumnModel({
                 columns: [
					  { field: 'rqprId',		label: '의뢰ID',		sortable: true,		align:'center',	width: 75 }
					, { field: 'acpcNo',		label: '접수번호',		sortable: true,		align:'center',	width: 80 }
					, { field: 'rlabScnNm',		label: '시험구분',		sortable: true,		align:'center',	width: 105 }
					, { field: 'rlabNm',		label: '시험명',		sortable: false,	align:'left',	width: 340 }
					, { field: 'smpoCnt',		label: '시료수',		sortable: false,	align:'center',	width: 50 }
					, { field: 'rgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
					, { field: 'rlabChrgNm',	label: '담당자',		sortable: false, 	align:'center',	width: 80 }
					, { field: 'rqprDt',		label: '의뢰일',		sortable: true, 	align:'center',	width: 90 }
					, { field: 'acpcDt',		label: '접수일',		sortable: true, 	align:'center',	width: 90 }
					, { field: 'cmplParrDt',	label: '완료예정일',	sortable: true, 	align:'center',	width: 90 }
					, { field: 'cmplDt',		label: '완료일',		sortable: true, 	align:'center',	width: 90 }
					, { field: 'rlabUgyYnNm',	label: '긴급',			sortable: false,  	align:'center',	width: 60 }
					, { field: 'acpcStNm',		label: '상태',			sortable: true, 	align:'center',	width: 90 }
                 ]
             });

             var rlabRqprGrid = new Rui.ui.grid.LGridPanel({
                 columnModel: rlabRqprColumnModel,
                 dataSet: rlabRqprDataSet,
                 width: 600,
                 height: 400,
                 autoToEdit: false,
                 autoWidth: true
             });

             rlabRqprGrid.render('rlabRqprGrid');

			rlabRqprDataSet.on('load', function(e) {
				$("#cnt_text").html('총 ' + rlabRqprDataSet.getCount() + '건');
				// 목록 페이징
				paging(rlabRqprDataSet,"rlabRqprGrid");
			});

            var rlabNm = new Rui.ui.form.LTextBox({
                applyTo: 'rlabNm',
                placeholder: '검색할 시험명을 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rlabNm}"/>',
                emptyValue: '',
                width: 200
            });
          
            var rqprDeptNm = new Rui.ui.form.LTextBox({
                applyTo: 'rqprDeptNm',
                placeholder: '검색할 의뢰팀을 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rqprDeptNm}"/>',
                emptyValue: '',
				editable: false,
                width: 200
            });

            rqprDeptNm.on('focus', function(e) {
            	rqprDeptNm.setValue('');
            	$('#rqprDeptCd').val('');
            });

            setRqprDeptInfo = function(deptInfo) {
    	    	rqprDeptNm.setValue(deptInfo.deptNm);
    	    	$('#rqprDeptCd').val(deptInfo.deptCd);
    	    };

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
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.toRqprDt}"/>',
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

			var rlabChrgNm = new Rui.ui.form.LTextBox({
                applyTo: 'rlabChrgNm',
                placeholder: '검색할 담당자를 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rlabChrgNm}"/>',
                emptyValue: '',
                displayField: 'name',
                width: 200,
                valueField: 'userId'
            });

            var rlabAcpcStCd = new Rui.ui.form.LCombo({
                applyTo: 'rlabAcpcStCd',
                name: 'rlabAcpcStCd',
                emptyText: '(전체)',
                defaultValue: '<c:out value="${inputData.rlabAcpcStCd}"/>',
                emptyValue: '',
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=RLAB_ACPC_ST_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            rlabAcpcStCd.on('load', function(e){

            });

            rlabRqprGrid.on('cellClick', function(e) {

            	var record = rlabRqprDataSet.getAt(e.row);

            	$('#rqprId').val(record.data.rqprId);

            	nwinsActSubmit(aform, "<c:url value='/rlab/rlabRqprDetail4Chrg.do'/>");
            });

            /* 시험의뢰 담당자용 리스트 엑셀 다운로드 */
        	downloadRlabRqprListExcel = function() {
        		if (rlabRqprDataSet.getCount()>0) {
                    rlabRqprDataSet.clearFilter();
    
                    var excelColumnModel = rlabRqprColumnModel.createExcelColumnModel(false);
                    duplicateExcelGrid(excelColumnModel);
                    nG.saveExcel(encodeURIComponent('시험목록_') + new Date().format('%Y%m%d') + '.xls');
    
                    //목록 페이징
                    paging(rlabRqprDataSet,"rlabRqprGrid");
                } else {
                    Rui.alert("조회 후 엑셀 다운로드 해주세요.");
                }
            };

            /* 조회 */
            getRlabRqprList = function() {
        	   rlabRqprDataSet.load({
                    url: '<c:url value="/rlab/getRlabRqprList.do"/>',
                    params :{
                    	rlabNm : encodeURIComponent(rlabNm.getValue()),
            		    fromRqprDt : fromRqprDt.getValue(),
            		    toRqprDt : toRqprDt.getValue(),
            		    rqprDeptCd : $('#rqprDeptCd').val(),
            		    rgstNm : encodeURIComponent(rgstNm.getValue()),
            		    rlabChrgNm : encodeURIComponent(rlabChrgNm.getValue()),
            		    acpcNo : encodeURIComponent(acpcNo.getValue()),
            		    rlabAcpcStCd : document.aform.rlabAcpcStCd.value,
            		    isRlabChrg : 1
                    }
                });
            };

            init = function() {
        	   var rlabNm='${inputData.rlabNm}';
        	   var rqprDeptNm='${inputData.rqprDeptNm}';
        	   var rlabChrgNm='${inputData.rlabChrgNm}';
        	   var rgstNm='${inputData.rgstNm}';
        	   var acpcNo='${inputData.acpcNo}';
        	   rlabRqprDataSet.load({
                    url: '<c:url value="/rlab/getRlabRqprList.do"/>',
                    params :{
                    	rlabNm : escape(encodeURIComponent(rlabNm)),
                    	fromRqprDt : '${inputData.fromRqprDt}',
                    	toRqprDt : '${inputData.toRqprDt}',
                    	rqprDeptNm : escape(encodeURIComponent(rqprDeptNm)),
                    	rlabChrgNm : escape(encodeURIComponent(rlabChrgNm)),
                    	rgstNm : escape(encodeURIComponent(rgstNm)),
                    	rlabAcpcStCd : '${inputData.rlabAcpcStCd}',
                    	acpcNo : escape(encodeURIComponent(acpcNo)),
                    	rqprDeptCd : $('#rqprDeptCd').val(),
                    	isRlabChrg : 1
                    }
                });
            }

        });

	</script>
	<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
    </head>
    <body onkeypress="if(event.keyCode==13) {getRlabRqprList();}" onload="init();">
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="rqprDeptCd" name="rqprDeptCd" value="<c:out value="${inputData.rqprDeptCd}"/>"/>
		<input type="hidden" id="rqprId" name="rqprId" value=""/>

   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
					<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
					<span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>시험목록</h2>
   			</div>

			<div class="sub-content">
   				<div class="search">
					<div class="search-content">
						<table class="rqprlist_sch">
							<colgroup>
								<col style="width:110px" />
								<col style="width:350px" />
								<col style="width:80px" />
								<col style="width:350px" />
								<col style="" />
							</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">시험명</th>
		   							<td class="tdin_w100">
		   								<input type="text" id="rlabNm">
		   							</td>
		   							<th align="right">의뢰일자</th>
		    						<td>
		   								<input type="text" id="fromRqprDt"/><em class="gab"> ~ </em>
		   								<input type="text" id="toRqprDt"/>
		    						</td>
		   							<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">의뢰팀</th>
		   							<td class="tdin_w100">
		   								<input type="text" id="rqprDeptNm">
		                                <a href="javascript:openDeptSearchDialog(setRqprDeptInfo);" class="icoBtn">검색</a>
		   							</td>
		   							<th align="right">담당자</th>
		    						<td class="tdin_w100">
		    							<input type="text" id=rlabChrgNm>
		                                <!-- <div id="rlabChrgNm"></div> -->
		    						</td>
		    						<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getRlabRqprList();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   						<tr>
		   							<th align="right">의뢰자</th>
		   							<td class="tdin_w100">
		   								<input type="text" id="rgstNm">
		                                <!-- <a href="javascript:openUserSearchDialog(setRgstInfo, 1, '', 'rlab');" class="icoBtn">검색</a> -->
		   							</td>
		   							<th align="right">상태</th>
		   							<td>
		   								<select id="rlabAcpcStCd"></select>
		                                <!-- <div id="rlabAcpcStCd"></div> -->
		   							</td>
		   							<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">접수번호</th>
		   							<td class="tdin_w100">
		   								<input type="text" id="acpcNo">
		   							</td>
		   							<th align="right"></th>
		   							<td></td>
		   							<td></td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadRlabRqprListExcel()">Excel</button>
   					</div>
   				</div>

   				<div id="rlabRqprGrid"></div>

				<div id="rlabRqprExcelGrid" style="width:10px;height:10px;visibility:hidden;"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>