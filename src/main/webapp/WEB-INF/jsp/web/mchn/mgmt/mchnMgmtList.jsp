<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlMachineList.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 관리 > 기기관리 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.29     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">
//retrieveMchnMgmtSearchList
var mchnMgmtRegDialog;


	Rui.onReady(function(){
		/* [ 신규기기 등록 Dialog] */
		mchnMgmtRegDialog = new Rui.ui.LFrameDialog({
	        id: 'mchnMgmtRegDialog',
	        title: '분석기기 관리',
	        width:  900,
	        height: 600,
	        modal: true,
	        visible: false
	    });

		mchnMgmtRegDialog.render(document.body);


		var mchnInfoDataSet = new Rui.data.LJsonDataSet({
			id: 'mchnInfoDataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'mchnNm'}
            	 ,{ id: 'mkrNm'}
            	 ,{ id: 'mdlNm'}
            	 ,{ id: 'mchnCrgrNm'}
            	 ,{ id: 'mchnLoc'}
            	 ,{ id: 'mchnInfoId'}
            ]
        });

		mchnInfoDataSet.on('load', function(e){

	    });

		var mchnBind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: mchnInfoDataSet,
		    bind: true,
		    bindInfo: [
		          { id: 'mchnNm', 		ctrlId: 'mchnNm', 		value: 'html' }
		         ,{ id: 'mkrNm', 		ctrlId: 'mkrNm', 		value: 'html' }
		         ,{ id: 'mdlNm', 		ctrlId: 'mdlNm', 		value: 'html' }
		         ,{ id: 'mchnCrgrNm', 	ctrlId: 'mchnCrgrNm', 	value: 'html' }
		         ,{ id: 'mchnLoc', 		ctrlId: 'mchnLoc', 		value: 'html' }
		     ]
		});

		//grid dataset
		var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'mchnMgmtNm'}
            	 ,{ id: 'mgmtDt'}
            	 ,{ id: 'mgmtUfe'}
            	 ,{ id: 'rgstNm'}
            	 ,{ id: 'mchnUsePsblYn'}
            	 ,{ id: 'mchnUsePsblNm'}
            	 ,{ id: 'smrySbc'}
            	 ,{ id: 'rgstDt'}
            	 ,{ id: 'rgstId'}
            	 ,{ id: 'mchnInfoId'}
            	 ,{ id: 'infoMgmtId'}
            	 ,{ id: 'rgstId'}
            	 ,{ id: 'dtlClCd'}
            ]
        });

		dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    });

		 var columnModel = new Rui.ui.grid.LColumnModel({
		     groupMerge: true,
		     columns: [
		        	{ field: 'mchnMgmtNm', 		label:'분류명' , 	sortable: false, align: 'center', width: 120},
		            { field: 'mgmtDt',  		label:'관리일', 	sortable: false, align: 'center', width: 130},
		            { field: 'mgmtUfe',  		label:'비용', 		sortable: false, align: 'right',  width: 140,
                   	 renderer: function(value, p, record){
      	        		return Rui.util.LFormat.numberFormat(parseInt(value));
      		        	}
                  	},
		            { field: 'rgstNm',  		label:'작성자', 	sortable: false, align: 'center', width: 115},
		            { field: 'mchnUsePsblNm', 	label: '상태', 		sortable: false, align: 'center', width: 120},
		            { field: 'smrySbc', 		label: '설명',   	sortable: false, align: 'left',	  width: 550},
		            { field: 'rgstDt', 			label: '등록일',   	sortable: false, align: 'center', width: 150},
		            { field: 'rgstId',  		hidden : true},
		            { field: 'mchnInfoId',  	hidden : true},
		            { field: 'infoMgmtId',  	hidden : true},
		            { field: 'rgstId',  		hidden : true},
		            { field: 'dtlClCd',  		hidden : true}
		        ]
		 });

		var grid = new Rui.ui.grid.LGridPanel({
		    columnModel: columnModel,
		    dataSet: dataSet,
		    width:1150,
		    height: 450,
		    autoWidth : true
		});

		grid.render('mhcnGrid');


	    grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());

			if(dataSet.getRow() > -1) {
				var param = 'infoMgmtId='+record.get("infoMgmtId")
				           +'&mchnInfoId='+record.get("mchnInfoId");

				mchnMgmtRegDialog.setUrl('<c:url value="/mchn/mgmt/retrieveMchnMgmtInfoPop.do?"/>'+param);
				mchnMgmtRegDialog.show(true);
			}
	 	});

	    var mchnInfoId = document.aform.mchnInfoId.value
	    var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    fnSearch = function(){
	    	dm.loadDataSet({
				dataSets: [ dataSet, mchnInfoDataSet],
	        	url: '<c:url value="/mchn/mgmt/retrieveMchnMgmtSearchList.do"/>' ,
	        	params :{
	        			mchnInfoId : mchnInfoId		//기기명
		                }
	         	});
		};

		fnSearch();

		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		          { id: 'mchnMgmtNm', 		ctrlId: 'mchnMgmtNm', 		value: 'value' }
		         ,{ id: 'mgmtDt', 			ctrlId: 'mgmtDt', 		    value: 'value' }
		         ,{ id: 'mgmtUfe', 			ctrlId: 'mgmtUfe', 			value: 'value' }
		         ,{ id: 'rgstNm', 			ctrlId: 'rgstNm', 			value: 'value' }
		         ,{ id: 'mchnUsePsblYn', 	ctrlId: 'mchnUsePsblYn',	value: 'value' }
		         ,{ id: 'smrySbc', 			ctrlId: 'smrySbc', 			value: 'value' }
		         ,{ id: 'rgstDt', 			ctrlId: 'rgstDt', 			value: 'value' }
		         ,{ id: 'rgstId', 			ctrlId: 'rgstId', 			value: 'value' }
		         ,{ id: 'mchnInfoId', 		ctrlId: 'mchnInfoId', 		value: 'value' }
		         ,{ id: 'infoDtlId', 		ctrlId: 'infoDtlId', 		value: 'value' }
		         ,{ id: 'dtlClCd', 			ctrlId: 'dtlClCd', 			value: 'value' }
		     ]
		});

		/* [버튼] : 분석기기 등록팝업 호출 */
    	var butReg = new Rui.ui.LButton('butReg');

    	butReg.on('click', function(){
    		var  param = 'mchnInfoId='+mchnInfoId;
			mchnMgmtRegDialog.setUrl('<c:url value="/mchn/mgmt/retrieveMchnMgmtInfoPop.do?"/>'+param);
			mchnMgmtRegDialog.show(true);
    	});

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){
        	if(dataSet.getCount() > 0 ) {
                grid.saveExcel(encodeURIComponent('기기관리_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        });


      //목록
		var butListlBtn = new Rui.ui.LButton('butList');
		butListlBtn.on('click', function(){
			$('#searchForm > input[name=mchnNm]').val(encodeURIComponent($('#searchForm > input[name=mchnNm]').val()));
    	   	$('#searchForm > input[name=mchnCrgrNm]').val(encodeURIComponent($('#searchForm > input[name=mchnCrgrNm]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/mchn/mgmt/retrieveMachineList.do"/>");
        });

	});		//end ready



</script>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
				<a class="leftCon" href="#">
		          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		          <span class="hidden">Toggle 버튼</span>
				</a>
			<h2>기기관리</h2>
		</div>
		<div class="sub-content">

		<form name="searchForm" id="searchForm">
			<input type="hidden" name="mchnNm" value="${inputData.mchnNm}"/>
			<input type="hidden" name="fxaNo" value="${inputData.fxaNo}"/>
			<input type="hidden" name="mchnClCd" value="${inputData.mchnClCd}"/>
			<input type="hidden" name="opnYn" value="${inputData.opnYn}"/>
			<input type="hidden" name="mchnCrgrNm" value="${inputData.mchnCrgrNm}"/>
			<input type="hidden" name="mchnUsePsblYn" value="${inputData.mchnUsePsblYn}"/>
			<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
	    </form>

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" />
				<input type="hidden" id="mchnCrgrId" name="mchnCrgrId" />
				<input type="hidden" id="infoMgmtId" name="infoMgmtId" />
				<input type="hidden" id="mchnInfoId" name="mchnInfoId"  value="<c:out value='${inputData.mchnInfoId}'/>">
				<div class="titArea mt0">
					<div class="LblockButton">
						<button type="button" id="butList">목록</button>
					</div>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">기기명</th>
							<td colspan=3">
								<span id="mchnNm"></span>
							</td>
						</tr>
						<tr>
							<th align="right">제조사</th>
							<td>
								<span id="mkrNm"></span>
							</td>
							<th align="right">모델명</th>
							<td>
								<span id="mdlNm"></span>
							</td>
						</tr>
						<tr>
							<th align="right">담당자</th>
							<td>
								<span id="mchnCrgrNm"></span>
							</td>
							<th align="right" >위치</th>
							<td>
								<span id="mchnLoc"></span>
							</td>
						</tr>
						</tbody>
				</table>
				<div class="titArea">
					<span class="table_summay_number" id="cnt_text"></span>
					<div class="LblockButton">
						<button type="button" id="butReg">신규관리</button>
						<button type="button" id="butExcl">EXCEL</button>
					</div>
				</div>
				<div id="mhcnGrid"></div>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>
