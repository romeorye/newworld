<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: opnInnoView.jsp
 * @desc    : 연구팀 > 과제 >   Open Innovation 협력과제 view
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.01.16     IRIS05		최초생성
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

<script type="text/javascript">

	Rui.onReady(function() {
		/*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
         dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
            	   { id: 'opnInnoId'}		
            	 , { id: 'tssNm'}		
            	 , { id: 'prjNm'}		
            	 , { id: 'tssEmpNm'}	
            	 , { id: 'tssStrDt'}	
            	 , { id: 'tssEndDt'}	
            	 , { id: 'deptNm'}	
            	 , { id: 'abrdInstNm'}	
            	 , { id: 'abrdCrgrNm'}	
            	 , { id: 'ousdInstNm'}
            	 , { id: 'oustCrgrNm'}	
            	 , { id: 'pgsStepCd'}	
            	 , { id: 'tssPgsTxt'}	
            	 , { id: 'tssFnoPlnTxt'}
            	 , { id: 'rem'}		
            	 , { id: 'attcFilId'}                                                                         

 			]
         });
		
         dataSet.on('load', function(e){
 	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
 	     });
		
         var columnModel = new Rui.ui.grid.LColumnModel({
             groupMerge: true,
             columns: [
            	 new Rui.ui.grid.LNumberColumn(),
                 { id : '해외기술센터'},
                 { field: 'abrdInstNm',     groupId: '해외기술센터' , label:'기관명' , sortable: false, align: 'center', width: 200},
                 { field: 'abrdCrgrNm',    	groupId: '해외기술센터',  label:'담당자' , sortable: false, align: 'center', width: 100},
                 { field: 'tssNm', 			label:'과제명' 	, sortable: false, align: 'left', width: 250, renderer: function(value){
             		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
             	 }},
                 { id : '과제현황'},
                 { field: 'tssPgsTxt'  , 	groupId: '과제현황', hMerge: true,  label:'현진행상황' , sortable: false, align: 'center', width: 150},
                 { field: 'tssFnoPlnTxt', 	groupId: '과제현황', hMerge: true, 	label:'향후계획' , sortable: false, align: 'center', width: 150},
                 { id : '외부협력기관'},
                 { field: 'ousdInstNm'  , groupId: '외부협력기관', hMerge: true,  label:'기관명' , sortable: false, align: 'center', width: 150},
                 { field: 'oustCrgrNm'  , groupId: '외부협력기관', hMerge: true, label:'담당자' , sortable: false, align: 'center', width: 150},
                 { id : '하우시스'},
                 { field: 'prjNm'  , 	groupId: '하우시스', hMerge: true, label:'관련PJT' , sortable: false, align: 'center', width: 150},
                 { field: 'tssEmpNm', 	groupId: '하우시스', hMerge: true, label:'과제리더' , sortable: false, align: 'center', width: 80},
                 { field: 'deptNm', 	groupId: '하우시스', hMerge: true, label:'조직' , sortable: false, align: 'center', width: 150},
                 { id : '과제기간(계획일)'},
                 { field: 'tssStrDt'  , groupId: '과제기간(계획일)', hMerge: true, label:'시작일' , sortable: false, align: 'center', width: 100},
                 { field: 'tssEndDt'  , groupId: '과제기간(계획일)', hMerge: true, label:'종료일' , sortable: false, align: 'center', width: 100},
                 { field: 'opnInnoId',  hidden : true}
             ]
         });
		
         
         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             height: 630,
             width : 1200
         });
         
        grid.render('opnInnoGrid');
         
        grid.on('cellClick', function(e) {
 			var record = dataSet.getAt(dataSet.getRow());
 			var column = columnModel.getColumnAt(e.col, true);
 			
 			if(dataSet.getRow() > -1) {
 	    	   	document.aform.opnInnoId.value = opnInnoId;
	 			nwinsActSubmit(document.aform, "<c:url value="/prj/opnInno/retrieveOpnInnoDetail.do"/>");
 			}
 	 	});
        
       //과제명
  	    var tssNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'tssNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        defaultValue: '<c:out value="${inputData.tssNm}"/>',
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });
       
       //기관명
  	    var ousdInstNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'ousdInstNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 200,                                    // 텍스트박스 폭을 설정
  	        defaultValue: '<c:out value="${inputData.ousdInstNm}"/>',
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });
       
        fnSearch = function() {
 	    	dataSet.load({
 	            url: '<c:url value="/prj/opnInno/retrieveOpnInnoSearchList.do"/>',
 	            params :{
 	            	 tssNm  : encodeURIComponent(document.aform.tssNm.value)
 	            	,ousdInstNm : encodeURIComponent(document.aform.ousdInstNm.value)
 	    	          }
             });
        }
         
        fnSearch();
		
	});
	
</script>
</head>

<body onkeypress="if(event.keyCode==13) {fnSearch();}">	
	<div class="contents">
		<div class="titleArea">
  			<h2>Open Innovation 협력과제 관리</h2>
  	    </div>
  		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="opnInnoId" name="opnInnoId" />
				<!-- Role
				<input type="hidden" id="roleId" name="roleId"  value="<c:out value='${inputData._roleId}'/>">
				<input type="hidden" id="adminChk" name="adminChk" />
 -->	
  				<table class="searchBox">
  					<colgroup>
  						<col style="width:15%"/>
  						<col style="width:30%"/>
  						<col style="width:15%"/>
  						<col style="width:"/>
  						<col style="width:10%"/>
  					</colgroup>
  					<tbody>
  					    <tr>
  							<th align="right">과제명</th>
  							<td>
  								<span>
								<input type="text"  id="tssNm" >
							</span>
  							</td>
  							<th align="right">기관명</th>
   						<td>
   							<input type="text"  id="ousdInstNm" >
   						</td>
   						<td  class="t_center">
  								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
  							</td>
  						</tr>
  					</tbody>
  				</table>

  				<div class="titArea">
  					<span class=table_summay_number id="cnt_text"></span>
				<div class="LblockButton">
  						<button type="button" id="butRgst" name="butRgst" >신규</button>
  						<button type="button" id="butExcl" name="butExcl">EXCEL</button>
  					</div>
  				</div>
  				<div id="opnInnoGrid"></div>

			</form>
		</div>
	</div>	
</body>
</html>