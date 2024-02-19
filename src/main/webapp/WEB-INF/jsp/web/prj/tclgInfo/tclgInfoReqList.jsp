<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: tclgInfoReqList.jsp
 * @desc    : 기술정보요청 관리 >  기술정보요청 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.02.12   IRIS05		최초생성
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
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<script type="text/javascript">
var adminYn = "N";
var tclgInfoReqDialog;


	Rui.onReady(function() {
		
		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
			adminYn ="Y";
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T03') > -1) {
			adminYn ="Y";
		}
		
		 //기술정보요청 등록
     	tclgInfoReqDialog = new Rui.ui.LFrameDialog({
	        id: 'tclgInfoReqDialog',
	        title: '기술정보요청 등록',
	        width:  700,
	        height: 400,
	        modal: true,
	        visible: false
	    });

     	tclgInfoReqDialog.render(document.body);
		
		dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
           	   { id: 'tclgRqId'}
           	 , { id: 'prjNm'}
           	 , { id: 'rgstNm'}
           	 , { id: 'rgstDt'}
           	 , { id: 'attcFilId'}
			]
        });

        dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    	// 목록 페이징
	    	paging(dataSet,"tclgInfoGrid");
	     });
        
        var columnModel = new Rui.ui.grid.LColumnModel({
            groupMerge: true,
            columns: [
           	    { field: 'prjNm',  		label:'프로젝트명' , 	sortable: false, align: 'left', width: 500},
                { field: 'rgstNm',  	label:'등록자' , 		sortable: false, align: 'center', width: 258},
                { field: 'rgstDt',   	label:'등록일', 			sortable: false, align: 'center', width: 258},
                { field: 'attcFilId',   	hidden : true},
                { field: 'tclgRqId',  		hidden : true}
            ]
        });

		
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            height: 400,
            width : 1150
        });

    	grid.render('tclgInfoGrid');

    	
    	grid.on('cellClick', function(e) {
 			var record = dataSet.getAt(dataSet.getRow());
 			tclgInfoReqDialog.setUrl('<c:url value="/prj/tclgInfo/tclgInfoDetailPop.do"/>'+'?tclgRqId='+record.get("tclgRqId")+'&attcFilId='+record.get("attcFilId") );
			tclgInfoReqDialog.show(true);
 	 	});
    	
    	
      	//과제명
 	    var prjNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'prjNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        defaultValue: '<c:out value="${inputData.prjNm}"/>',
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

      	//등록자
 	    var rgstNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'rgstNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        defaultValue: '<c:out value="${inputData.rgstNm}"/>',
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });
		
 	   var butRgst = new Rui.ui.LButton('butRgst');

		butRgst.on('click', function(){
			tclgInfoReqDialog.setUrl('<c:url value="/prj/tclgInfo/tclgInfoReqPop.do"/>');
			tclgInfoReqDialog.show(true);
		});

      	fnSearch = function() {
      		dataSet.load({
 	            url: '<c:url value="/prj/tclgInfo/retrieveTclgInfoRqSearchList.do"/>',
 	            params :{
 	            	  prjNm  : encodeURIComponent(document.aform.prjNm.value)
 	            	 ,rgstNm : encodeURIComponent(document.aform.rgstNm.value)
 	            	 ,adminYn : adminYn
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
		<a class="leftCon" href="#">
	          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	          <span class="hidden">Toggle 버튼</span>
			</a>
		<h2>기술정보 요청서 목록</h2>
    </div>
  	<div class="sub-content">
			<form name="aform" id="aform" method="post">
			<input type="hidden" id="prjCd"  	name="prjCd" value="<c:out value='${inputData.prjCd}'/>"/>
			<input type="hidden" id="wbsCd"  	name="wbsCd" value="<c:out value='${inputData.wbsCd}'/>"/>
			<input type="hidden" id="deptCd"  	name="deptCd" value="<c:out value='${inputData.deptCd}'/>"/>
			<input type="hidden" id="roleId" 	name="roleId"  value="<c:out value='${inputData._roleId}'/>">

  				<div class="search">
					<div class="search-content">
		                <table>
		  					<colgroup>
		  						<col style="width:120px" />
								<col style="width:200px" />
								<col style="width:120px" />
								<col style="width:400px" />
								<col style="" />
		  					</colgroup>
		  					<tbody>
		  					    <tr>
		  							<th align="right">프로젝트명</th>
		  							<td>
										<input type="text"  id="prjNm" >
		  							</td>
		  							<th align="right">등록자</th>
			   						<td>
			   							<input type="text" id="rgstNm" >
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
  					<span class=table_summay_number id="cnt_text"></span>
					<div class="LblockButton">
  						<button type="button" id="butRgst" name="butRgst" >신규</button>
  					</div>
  				</div>
  				<div id="tclgInfoGrid"></div>
		</form>
  		</div><!-- //sub-content -->
  		
</div><!-- //contents -->
  
        
</body>
</html>