<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprList.jsp
 * @desc    : 분석의뢰관리 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
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
            
            var rlabNm = new Rui.ui.form.LTextBox({
                applyTo: 'rlabNm',
                placeholder: '검색할 분석명을 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rlabNm}"/>',
                emptyValue: '',
                width: 400
            });
            
            rlabNm.on('blur', function(e) {
            	rlabNm.setValue(rlabNm.getValue().trim());
            });
        /*     
            rlabNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getRlabRqprList();
            	}
            });
            
             */
            var rgstNm = new Rui.ui.form.LTextBox({
                applyTo: 'rgstNm',
                placeholder: '검색할 의뢰자를 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rgstNm}"/>',
                emptyValue: '',
                width: 360
            });
          /*   
            rgstNm.on('focus', function(e) {
            	rgstNm.setValue('');
            	$('#rgstNm').val('');
            });
             */
            var acpcNo = new Rui.ui.form.LTextBox({
                applyTo: 'acpcNo',
                placeholder: '검색할 접수번호를 입력해주세요.',
                defaultValue: '<c:out value="${inputData.acpcNo}"/>',
                emptyValue: '',
                width: 400
            });
            
            acpcNo.on('blur', function(e) {
            	acpcNo.setValue(acpcNo.getValue().trim());
            });
          /*   
            acpcNo.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getRlabRqprList();
            	}
            });
           */  
            var fromRqprDt = new Rui.ui.form.LDateBox({
				applyTo: 'fromRqprDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				editable: false,
				width: 100,
				dateType: 'string'
			});

            fromRqprDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromRqprDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
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
				editable: false,
				width: 100,
				dateType: 'string'
			});
			 
			toRqprDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toRqprDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
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
                width: 400
            });
			
			
			/* 
            var rlabChrgNm = new Rui.ui.form.LCombo({
                applyTo: 'rlabChrgNm',
                name: 'rlabChrgNm',
                useEmptyText: true,
                emptyText: '전체',
                defaultValue: '<c:out value="${inputData.rlabChrgNm}"/>',
                emptyValue: '',
                url: '<c:url value="/rlab/getRlabChrgList.do"/>',
                displayField: 'name',
                valueField: 'userId'
            });
            */ 
            var acpcStCd = new Rui.ui.form.LCombo({
                applyTo: 'acpcStCd',
                name: 'acpcStCd',
                useEmptyText: true,
                emptyText: '전체',
                defaultValue: '<c:out value="${inputData.acpcStCd}"/>',
                emptyValue: '',
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ACPC_ST_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
			
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
                      { field: 'acpcNo',		label: '접수번호',	sortable: true,		align:'center',	width: 80 }
                    , { field: 'rlabScnNm',		label: '분석구분',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'rlabNm',		label: '분석명',		sortable: false,	align:'left',	width: 370 }
                    , { field: 'smpoCnt',		label: '시료수',		sortable: false,	align:'center',	width: 50 }
                    , { field: 'rgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 70 }
					, { field: 'rlabChrgNm',	label: '담당자',		sortable: false, 	align:'center',	width: 70 }
					, { field: 'rqprDt',		label: '의뢰일',		sortable: true, 	align:'center',	width: 80 }
					, { field: 'acpcDt',		label: '접수일',		sortable: true, 	align:'center',	width: 80 }
					, { field: 'cmplParrDt',	label: '완료예정일',	sortable: true, 	align:'center',	width: 80 }
                    , { field: 'cmplDt',		label: '완료일',		sortable: true, 	align:'center',	width: 80 }
                    , { field: 'rlabUgyYnNm',	label: '긴급',		sortable: false,  	align:'center',	width: 40 }
					, { field: 'acpcStNm',		label: '상태',		sortable: false, 	align:'center',	width: 80 }
                ]
            });

            var rlabRqprGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprColumnModel,
                dataSet: rlabRqprDataSet,
                width: 600,
                height: 520,
                autoToEdit: false,
                autoWidth: true
            });

            rlabRqprGrid.on('cellClick', function(e) {

            	var record = rlabRqprDataSet.getAt(e.row);
            	
            	$('#rqprId').val(record.data.rqprId);
            	
            	nwinsActSubmit(aform, "<c:url value='/rlab/rlabRqprDetail.do'/>");
            });
            
            rlabRqprGrid.render('rlabRqprGrid');
            
            /* 조회 */
            getRlabRqprList = function() {
            	rlabRqprDataSet.load({
                    url: '<c:url value="/rlab/getRlabRqprList.do"/>',
                    params :{
                    	rlabNm : encodeURIComponent(rlabNm.getValue()),
            		    fromRqprDt : fromRqprDt.getValue(), 
            		    toRqprDt : toRqprDt.getValue(),
            		    rgstNm : encodeURIComponent(rgstNm.getValue()),
            		    rlabChrgNm : encodeURIComponent(rlabChrgNm.getValue()),
            		    acpcNo : encodeURIComponent(acpcNo.getValue()),
            		    acpcStCd : acpcStCd.getValue(),
            		    isRlabChrg : 0
                    }
                });
            };
            
            rlabRqprDataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + rlabRqprDataSet.getCount() + '건');
   	      	});
            
            /* 등록화면 이동 */
            goRlabRqprRgst = function() {
            	nwinsActSubmit(aform, "<c:url value="/rlab/rlabRqprRgst.do"/>");
            };
            
            /* 분석의뢰 리스트 엑셀 다운로드 */
        	downloadRlabRqprListExcel = function() {
                rlabRqprGrid.saveExcel(encodeURIComponent('분석의뢰_') + new Date().format('%Y%m%d') + '.xls');
            };
    		/* 
            setRgstInfo = function(userInfo) {
    	    	rgstNm.setValue(userInfo.saName);
    	    	$('#rgstNm').val(userInfo.saUser);
    	    };
             */
            getRlabRqprList();
			
        });

	</script>
    </head>
    <body onkeypress="if(event.keyCode==13) {getRlabRqprList();}">
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="rqprId" name="rqprId" value=""/>
		
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	   				<h2>분석의뢰</h2>
	   			</div>
	   			
   				<table class="searchBox">
   					<colgroup>
   						<col style="width:10%;"/>
   						<col style="width:40%;"/>
   						<col style="width:10%;"/>
   						<col style="width:30%;"/>
   						<col style="width:10%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">분석명</th>
   							<td>
   								<input type="text" id="rlabNm">
   							</td>
   							<th align="right">의뢰일자</th>
    						<td>
   								<input type="text" id="fromRqprDt"/><em class="gab"> ~ </em>
   								<input type="text" id="toRqprDt"/>
    						</td>
   							<td class="t_center" rowspan="3">
   								<a style="cursor: pointer;" onclick="getRlabRqprList();" class="btnL">검색</a>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">의뢰자</th>
   							<td>
   								<input type="text" id="rgstNm">
                                <!-- <a href="javascript:openUserSearchDialog(setRgstInfo, 1, '', 'rlab');" class="icoBtn">검색</a> -->
   							</td>
   							<th align="right">담당자</th>
    						<td>
    							<input type="text" id="rlabChrgNm">
    						</td>
   						</tr>
   						<tr>
   							<th align="right">접수번호</th>
   							<td>
   								<input type="text" id="acpcNo">
   							</td>
   							<th align="right">상태</th>
   							<td>
                                <div id="acpcStCd"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				
   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="rgstBtn" name="rgstBtn" onclick="goRlabRqprRgst()">등록</button>
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