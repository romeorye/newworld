<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMachineLis.jsp
 * @desc    : 분석기기 >  관리 > 소모품관리  >  관리 > 소모품 입출력
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.26     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
%>

<script type="text/javascript">
var fncCgdsAnlList;
var cgdsMgmtDialog;
var dataSet;

	Rui.onReady(function(){

        cgdsMgmtDialog = new Rui.ui.LFrameDialog({
	        id: 'cgdsMgmtDialog',
	        title: '소모품입출력관리',
	        width:  900,
	        height: 500,
	        modal: true,
	        visible: false,
	    });

        cgdsMgmtDialog.render(document.body);

		dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'cgdsNm'}
            	 ,{ id: 'mkrNm'}
            	 ,{ id: 'stkNo'}
            	 ,{ id: 'cgdsLoc'}
            	 ,{ id: 'curIvQty'}
            	 ,{ id: 'prpIvQty'}
            	 ,{ id: 'useUsf'}
            	 ,{ id: 'ivStCd'}
            	 ,{ id: 'attcFilId'}
            	 ,{ id: 'seq'}
            	 ,{ id: 'cgdsId'}
            ]
        });

		dataSet.on('load', function(e){
			if(  dataSet.getNameValue(0, "cgdsId")  == ""){

			}else{
	    		//현재고 색변경
		    	if( dataSet.getNameValue(0, "ivStCd") == "Y" ){
		    		Rui.get("curIvQty").html('');
		    		Rui.get("curIvQty").setStyle('color', "RED");
		    	}

				//이미지
		    	if( dataSet.getNameValue(0, "attcFilId") != "" ){
		    		var param = "?attcFilId="+ dataSet.getNameValue(0, "attcFilId")+"&seq="+dataSet.getNameValue(0, "seq");

		    		Rui.getDom('imgView').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
		    		Rui.getDom('imgView').width = '120';
		    	    Rui.getDom('imgView').height = '120';
		    	}
			}
	    });

		var dataSetList = new Rui.data.LJsonDataSet({
            id: 'dataSetList',
            remainRemoved: true,
            fields: [
            	  { id: 'rgstDt'}
            	 ,{ id: 'whioClNm'}
            	 ,{ id: 'whsnQty'}
            	 ,{ id: 'whotQty'}
            	 ,{ id: 'rgstNm'}
            	 ,{ id: 'cgdsRem'}
            	 ,{ id: 'whioClCd'}
            	 ,{ id: 'cgdsId'}
            	 ,{ id: 'rgstId'}
            	 ,{ id: 'cgdsMgmtId'}
            ]
        });

		dataSetList.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSetList.getCount() + '건';
	    });

		var columnModel = new Rui.ui.grid.LColumnModel({
		     groupMerge: true,
		     columns: [
		        	 { field: 'rgstDt', 	label:'해당일' , 	sortable: false, align: 'center', width: 190}
		            ,{ field: 'whioClNm',  	label:'구분', 		sortable: false, align: 'center', width: 190}
		            ,{ field: 'whsnQty',  	label:'입고수', 	sortable: false, align: 'center', width: 190}
		            ,{ field: 'whotQty',  	label:'출고수', 	sortable: false, align: 'center', width: 190}
		            ,{ field: 'rgstNm', 	label: '처리자', 	sortable: false, align: 'center', width: 190}
		            ,{ field: 'cgdsRem', 	label: '비고',   	sortable: false, align: 'left', width: 375}
		            ,{ field: 'whioClCd',  	hidden : true}
		            ,{ field: 'cgdsId',  	hidden : true}
		            ,{ field: 'rgstId',  	hidden : true}
		            ,{ field: 'cgdsMgmtId', hidden : true}
		        ]
		 });

		var grid = new Rui.ui.grid.LGridPanel({
		    columnModel: columnModel,
		    dataSet: dataSetList,
		    width: 1150,
		    height: 350,
		    autoWidth: true
		});

		grid.render('cgdsGrid');

		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		fnSearch = function() {
			dm.loadDataSet({
				dataSets: [ dataSet, dataSetList],
	        	url: '<c:url value="/mchn/mgmt/retrieveCdgsMgmtInfo.do"/>' ,
        		params :{
        				cgdsId : document.aform.cgdsId.value		//소모품
	                	}
         	});
     	}

		fnSearch();

		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		          { id: 'cgdsNm', 	ctrlId: 'cgdsNm', 	value: 'html'}
		         ,{ id: 'mkrNm', 	ctrlId: 'mkrNm', 	value: 'html'}
		         ,{ id: 'stkNo', 	ctrlId: 'stkNo', 	value: 'html'}
		         ,{ id: 'cgdsLoc', 	ctrlId: 'cgdsLoc', 	value: 'html'}
		         ,{ id: 'curIvQty', ctrlId: 'curIvQty',	value: 'html'}
		         ,{ id: 'prpIvQty', ctrlId: 'prpIvQty',	value: 'html'}
		         ,{ id: 'useUsf', 	ctrlId: 'useUsf', 	value: 'html'}
		     ]
		});
		/* 수정기능 제거    2017. 09.27
		grid.on('cellDblClick', function(e) {
			var record = dataSetList.getAt(dataSetList.getRow());
			if(dataSetList.getRow() > -1) {
				var cgdsId = document.aform.cgdsId.value;
				var param = "?cgdsMgmtId="+record.get("cgdsMgmtId")
						    +"&cgdsId="+record.get("cgdsId")
						    ;
				cgdsMgmtDialog.setUrl('<c:url value="/mchn/mgmt/retrieveCgdsMgmtPop.do"/>'+param);
	    		cgdsMgmtDialog.show(true);
			}
	 	});
		 */

		/* [버튼] : 소모품 입출력 팝업창 이동 */
    	var butReg = new Rui.ui.LButton('butReg');
    	butReg.on('click', function(){
    		var cgdsId = document.aform.cgdsId.value;
			var param = "?cgdsId="+cgdsId;

    		cgdsMgmtDialog.setUrl('<c:url value="/mchn/mgmt/retrieveCgdsMgmtPop.do"/>'+param);
    		cgdsMgmtDialog.show(true);
    	});

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){
        	if(dataSetList.getCount() > 0 ) {
                grid.saveExcel(encodeURIComponent('소모품입출고_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        });

        /* [버튼] : 소모품 목록 이동 */
    	var butList = new Rui.ui.LButton('butList');
    	butList.on('click', function(){
    		fncCgdsAnlList();
    	});

     	//소모품관리 목록 화면으로 이동
	  	fncCgdsAnlList = function(){
	  		$('#searchForm > input[name=cgdsNm]').val(encodeURIComponent($('#searchForm > input[name=cgdsNm]').val()));
    	   	$('#searchForm > input[name=mkrNm]').val(encodeURIComponent($('#searchForm > input[name=mkrNm]').val()));
    	   	$('#searchForm > input[name=cgdCrgrNm]').val(encodeURIComponent($('#searchForm > input[name=cgdCrgrNm]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/mchn/mgmt/retrieveMchnCgdgList.do"/>");
	   	}

	});			//end onReady


</script>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
	          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	          <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>소모품입출력 관리</h2>
		</div>
		<div class="sub-content">

			<form name="searchForm" id="searchForm">
				<input type="hidden" name="cgdsNm" value="${inputData.cgdsNm}"/>
				<input type="hidden" name="mkrNm" value="${inputData.mkrNm}"/>
				<input type="hidden" name="stkNo" value="${inputData.stkNo}"/>
				<input type="hidden" name="cgdCrgrNm" value="${inputData.cgdCrgrNm}"/>
				<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
		    </form>

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" value="IRIED0202"/>
				<input type="hidden" id="cgdsId" name="cgdsId" value="<c:out value='${inputData.cgdsId}'/>">
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 12%" />
						<col style="width: 12%" />
						<col style="width: 30%" />
						<col style="width: 12%" />
						<col style="width:" />
					</colgroup>
					<tbody>
						<tr>
							<td rowspan="4" class="txt-center">
								<img id="imgView"/>
							</td>
							<th align="center">소모품명</th>
							<td>
								<span id="cgdsNm"></span>
							</td>
							<th align="center">제조사</th>
							<td>
								<span id="mkrNm"></span>
							</td>
						</tr>
						<tr>
							<th align="center">Stock No.</th>
							<td>
								<span id="stkNo"></span>
							</td>
							<th align="center">위치</th>
							<td>
								<span id="cgdsLoc"></span>
							</td>
						</tr>
						<tr>
							<th align="center">현재고</th>
							<td>
								<span id="curIvQty"></span>
							</td>
							<th align="center">적정재고</th>
							<td>
								<span id="prpIvQty"></span>
							</td>
						</tr>
						<tr>
							<th align="center">용도</th>
							<td colspan="3">
								<span id="useUsf"></span>
							</td>
						</tr>
						</tbody>
				</table>
				<div class="titArea">
   					<span class="table_summay_number" id="cnt_text"></span>
					<div class="LblockButton">
   						<button type="button" id="butReg">신규</button>
						<button type="button" id="butExcl">EXCEL</button>
						<button type="button" id="butList">목록</button>
   					</div>
   				</div>
				<div id="cgdsGrid"></div>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>