<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: leasHousMgmtList.jsp
 * @desc    : 임차주택 관리리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.11.20  IRIS005  	최초생성
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
<script type="text/javascript">
//var attchFilRegDialog;
	
	Rui.onReady(function() {
		
		attchFilRegDialog = new Rui.ui.LFrameDialog({
	        id: 'attchFilRegDialog',
	        title: '필수첨부파일 등록',
	        width:  890,
	        height: 340,
	        modal: true,
	        visible: false,
	    });

		attchFilRegDialog.render(document.body);
		
		/*******************
         * 변수 및 객체 선언
         *******************/   
         var dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
					  { id: 'leasId'}		
					, { id: 'empNm' }		//신청자명
					, { id: 'deptNm' }		//부서명
					, { id: 'cnttStrDt' }	//계약시작일
					, { id: 'cnttEndDt' }	//계약종료일
					, { id: 'pgsStNm' }		//진행상태
					, { id: 'reqStNm' }		//요청산태
					, { id: 'reqStCd' }		//계약진행코드
					, { id: 'pgsStCd' }	//요청상태
					, { id: 'supAmt' }		//지원금
             ]
         });
		
         var columnModel = new Rui.ui.grid.LColumnModel({
             columns: [
                   { field: 'empNm',		label: '신청자명',		sortable: true,		align:'center',	width: 200 }
                 , { field: 'deptNm',		label: '부서명',			sortable: false,	align:'center',	width: 300 }
                 , { field: 'cnttStrDt',	label: '계약시작일',		sortable: false,	align:'left',	width: 120 }
                 , { field: 'cnttEndDt',	label: '계약종료일',		sortable: false,	align:'center',	width: 120 }
                 , { field: 'supAmt',		label: '지원금',			sortable: false,	align:'center',	width: 150 , renderer: function(value, p, record){
  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
	        		}
     		 	}
                 , { field: 'pgsStNm',		label: '진행상태',		sortable: false,	align:'center',	width: 120 }
				 , { field: 'reqStNm',		label: '요청상태',		sortable: false, 	align:'center',	width: 120 }
				 , { field: 'leasId',		hidden:true }
				 , { field: 'reqStCd',		hidden:true }
				 , { field: 'pgsStCd',		hidden:true }
             ]
         });

         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             width: 600,
             height: 400,
             autoToEdit: false,
             autoWidth: true
         });
		
         grid.render('defaultGrid');
		
         
       //신청자명
         empNm = new Rui.ui.form.LTextBox({
             applyTo: 'empNm',
             defaultValue: '<c:out value="${inputData.empNm}"/>',
             width: 200
         });
 		
 		//부서명
         deptNm = new Rui.ui.form.LTextBox({
             applyTo: 'deptNm',
             defaultValue: '<c:out value="${inputData.deptNm}"/>',
             width: 200
         });
 		
       	//요청상태
         reqStCd = new Rui.ui.form.LCombo({
             applyTo: 'reqStCd',
             emptyValue: '',
             useEmptyText: true,
             width: 150,
             defaultValue: '<c:out value="${inputData.reqStCd}"/>',
             emptyText: '전체',
             url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=REQ_ST_CD"/>',
             displayField: 'COM_DTL_NM',
             valueField: 'COM_DTL_CD',
             autoMapping: true
         });
 		
       	//진행상태
         pgsStCd = new Rui.ui.form.LCombo({
             applyTo: 'pgsStCd',
             emptyValue: '',
             useEmptyText: true,
             width: 150,
             defaultValue: '<c:out value="${inputData.pgsStCd}"/>',
             emptyText: '전체',
             url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PGS_ST_CD"/>',
             displayField: 'COM_DTL_NM',
             valueField: 'COM_DTL_CD',
             autoMapping: true
         });
         
         
         fnSearch = function() {
         	dataSet.load({
             	url: '<c:url value="/knld/leasHous/retrieveLeasHousSearchList.do"/>',
                 params : {
                 	empNm : encodeURIComponent(document.aform.empNm.value)    //신청자명
                   , deptNm : encodeURIComponent(document.aform.deptNm.value)    //조직
                   , pgsStCd : pgsStCd.getValue()                        		//진행상태
                   , reqStCd : reqStCd.getValue()                        		//요청상태
                   , adminChk : "Y"                        		//요청상태
                 }
             });
         }
       	
       	fnSearch();
         
         
         fncAttchFilReq = function(){
 			//attchFilRegDialog.setUrl('<c:url value="/knld/leasHousMgmt/attchFilReqPop.do"/>');
 			nwinsActSubmit(aform, "<c:url value='/knld/leasHousMgmt/attchFilReqPop.do'/>");
 			//attchFilRegDialog.show(true);
         }
 		
	});

</script>


</head>
<body>
<div class="contents">
<form name="aform" id="aform" method="post">
	<div class="titleArea">
 		<a class="leftCon" href="#">
       	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
       	<span class="hidden">Toggle 버튼</span>
       	</a>
 		<h2>임차주택 관리</h2>
 	</div>
	<div class="sub-content">
		<div class="search">
			<div class="search-content">
   				<table>
   					<colgroup>
   						<col style="width:120px;"/>
   						<col style="width:400px;"/>
   						<col style="width:110px;"/>
   						<col style="width:200px;"/>
   						<col style=";"/>
   					</colgroup>
   					<tbody>
   						<tr>
   						    <th align="right">신청자</th>
    						<td>
   								<input type="text" id="empNm" value="">
    						</td>
   							<th align="right">부서명</th>
   							<td>
   								<input type="text" id="deptNm" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">계약진행상태</th>
   							<td>
   								<select id="pgsStCd" ></select>
   							</td>
   							<th align="right">요청상태</th>
   							<td>
   								<select id="reqStCd" ></select>
   							</td>
   							<td class="txt-right">
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
 						<button type="button" id="rgstBtn" name="rgstBtn" onClick="fncAttchFilReq()" >필수첨부파일 등록</button>
 					</div>
 			</div>
 			<div id="defaultGrid"></div>
	</div>
</form>
</div>
</body>
</html>
