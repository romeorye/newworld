<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: leasHousList.jsp
 * @desc    : 임차주택 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.10.21  IRIS005  	최초생성
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

<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">
var chkListDialog;
var adminChk ="N";
var chkCmplYn='${inputData.chkCmpl}';


	Rui.onReady(function() {
		
		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
			adminChk = "Y";
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T22') > -1) {
			adminChk = "Y";
		}
		
		chkListDialog = new Rui.ui.LFrameDialog({
	        id: 'chkListDialog',
	        title: '임차주택 사전 검토 Checklist',
	        width:  840,
	        height: 600,
	        modal: true,
	        visible: false,
	    });

		chkListDialog.render(document.body);
		
		
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
                 , { field: 'cnttStrDt',	label: '계약시작일',		sortable: false,	align:'center',	width: 120 }
                 , { field: 'cnttEndDt',	label: '계약종료일',		sortable: false,	align:'center',	width: 120 }
                 , { field: 'supAmt',		label: '지원금',			sortable: false,	align:'right',	width: 150 , renderer: function(value, p, record){
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
		
         grid.on('cellClick', function(e) {
         	var record = dataSet.getAt(e.row);
         	$('#leasId').val(record.data.leasId);

         	if( adminChk == "Y"  ){
				if(  record.data.pgsStCd == "RQ" &&  record.data.reqStCd == "RQ" ){
					nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousDtl.do'/>");
				}else if ( record.data.pgsStCd == "PRI"){
					nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousDtlAdmin.do'/>");
				}else if ( record.data.pgsStCd == "CNR"){
					nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousCnrDtlAdmin.do'/>");
				}else if ( record.data.pgsStCd == "CNR" && ( record.data.reqStCd == "APPR" || record.data.reqStCd == "REJ")  ){
					nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousCnrCmpl.do'/>");
				}
				
			}else{
				if(record.data.pgsStCd == "PRI" && record.data.reqStCd == "RQ" ){	//사전검토
					nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousDtl.do'/>");
				}else if( record.data.pgsStCd == "PRI" && ( record.data.reqStCd == "APPR" || record.data.reqStCd == "REJ" ||  record.data.reqStCd == "RQ") ){				//계약검토						
					nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousCnrDtl.do'/>");
				}else if( record.data.pgsStCd == "CNR" && ( record.data.reqStCd == "APPR" || record.data.reqStCd == "REJ" ||  record.data.reqStCd == "RQ") ){			//계약완료
					nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousCnrDtl.do'/>");
				}else if( record.data.pgsStCd == "CNR" && ( record.data.reqStCd == "APPR" || record.data.reqStCd == "REJ") ){			//계약완료
					nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousCnrCmpl.do'/>");
				}
			}
        });
         
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
                  , adminChk : adminChk                        		//요청상태
                }
            });
        }
      	
      	fnSearch();
      	
        fncLeasHousReq = function(){
            if(Rui.isEmpty(chkCmplYn)){
	        	nwinsActSubmit(aform, "<c:url value='/knld/leasHous/leasHousDtl.do'/>");
            }
        }
      	
        fncChkList = function(){
 			chkListDialog.setUrl('<c:url value="/knld/leasHous/chkListPop.do"/>');
 			chkListDialog.show(true);
        }

        /* 쿠키 한루에 팝업창 한번만 띄우기  */ 
        var yourname = getCookie("MyCookie")
		if(yourname != 'adexe'){
			fncChkList();
			//window.open('자식페이지.html','event1','width=345,height=427,left=430,top=0,scrollbars=no,resizable=no');
		}
       
        
	});//onReady 끝


	function getCookie(name){
		var arg = name + "=";
		var alen = arg.length;
		var clen=document.cookie.length;
		var i=0;

		while(i< clen){
			var j = i+alen;
				if(document.cookie.substring(i,j)==arg){
					var end = document.cookie.indexOf(";",j);
					if(end== -1)
						end = document.cookie.length;
						return unescape(document.cookie.substring(j,end));
					}
					i=document.cookie.indexOf(" ",i)+1;
					if (i==0) break;
				}
			return null;
		}

		
	
</script>


</head>
<body>
<form name="aform" id="aform" method="post">
	<input type="hidden" id="pageMode" name="pageMode" value="" />
	<input type="hidden" id="leasId" name="leasId"/>
<div class="contents">
	<div class="titleArea">
 		<a class="leftCon" href="#">
       	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
       	<span class="hidden">Toggle 버튼</span>
       	</a>
 		<h2>임차주택 목록</h2>
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
   							<!-- 
   							<th align="right">계약일자</th>
   							<td>
   								<input type="text" id="supStrDt"/><em class="gab"> ~ </em><input type="text" id="supEndDt" />
   							</td> -->
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
 						<button type="button" id="rgstBtn" name="rgstBtn" onClick="fncLeasHousReq()" >신청</button>
 						<button type="button" id="excelBtn" name="excelBtn">Excel</button>
 					</div>
 				</div>

 				<div id="defaultGrid"></div>

 			</div><!-- //sub-content -->
 		</div><!-- //contents -->
		</form>
    </body>
</html>