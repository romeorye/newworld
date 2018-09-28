<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: mchnEduAnlRgstList.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 관리 > 수료및 미수료 정보 업데이트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">
//var mailContents;	//메일 문구
var mailTitl = "기기교육 결과 메일입니다.";	//메일제목
var excelDataSet;

	Rui.onReady(function(){
		<%-- RESULT DATASET --%>
        resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
		
		var eduPttStBtn = new Rui.ui.LButton('eduPttSt');
		eduPttStBtn.on('click', function(){

        });

		var eduPttStNm = document.aform.eduPttStNm.value;
		
		
		/* mchn info dataSet*/
		var mchnInfoDataSet = new Rui.data.LJsonDataSet({
	        id: 'mchnInfoDataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
        		 {id: 'eduPttStNm'}    
        		,{id: 'eduScnNm'}      
        		,{id: 'eduNm'}         
        		,{id: 'mchnNm'}        
        		,{id: 'pttFromDt'}     
        		,{id: 'pttToDt'}       
        		,{id: 'pttCpsn'}       
        		,{id: 'ivttCpsn'}      
        		,{id: 'eduDt'}         
        		,{id: 'eduToTim'}      
        		,{id: 'eduPl'}         
        		,{id: 'eduPttSt'}      
        		,{id: 'eduCrgrNm'}     
        		,{id: 'dtlSbc'}     
        		,{id: 'eduCrgrId'}     
        		,{id: 'mchnEduId'}     
        		,{id: 'eduScnCd'}     
        		 ]
	    });
		
		mchnInfoDataSet.on('load', function(e){
			
			
	    });
		 
		/* [DataSet] bind */
	    var mchnInfoBind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: mchnInfoDataSet,
	        bind: true,
	        bindInfo: [
	              {id: 'eduPttStNm',	ctrlId: 'eduPttStNm',	value: 'html' }
	            , {id: 'eduCrgrNm',		ctrlId: 'eduCrgrNm',	value: 'html' }
		    	, {id: 'eduScnNm',      ctrlId: 'eduScnNm',     value: 'html' }
		    	, {id: 'eduNm',       	ctrlId: 'eduNm',      	value: 'html' }
		    	, {id: 'mchnNm',     	ctrlId: 'mchnNm',      	value: 'html' }
		    	, {id: 'pttFromDt',     ctrlId: 'pttFromDt',    value: 'html' }
		    	, {id: 'pttToDt',       ctrlId: 'pttToDt',      value: 'html' }
		    	, {id: 'pttCpsn',      	ctrlId: 'pttCpsn',      value: 'html' }
		    	, {id: 'ivttCpsn',      ctrlId: 'ivttCpsn',     value: 'html' }
		    	, {id: 'eduDt',     	ctrlId: 'eduDt',      	value: 'html' }
		    	, {id: 'eduToTim',      ctrlId: 'eduToTim',     value: 'html' }
		    	, {id: 'eduPl',    		ctrlId: 'eduPl',      	value: 'html' }
		    	, {id: 'eduPttSt',    	ctrlId: 'eduPttSt',    	value: 'html' }
	        ]
	    });
		
		
		/* grid */
		var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
        		 {id: 'rgstNm'}           	//이름
        		,{id: 'rgstId'}           	//id
        		,{id: 'rgstTeam'}           	//팀
        		,{id: 'rgstJobx'}          //직급
        		,{id: 'rgstDt'}              //신청일
        		,{id: 'ccsDt'}            //수료일
        		,{id: 'eduStNm'}          //상태
        		,{id: 'ccsTrtmNm'}          //처리자
        		,{id: 'saMail'}          //수신자 메일
        		,{id: 'eduCrgrId'}          //등록자 id
        		,{id: 'eduDtlId'}          //교육신청관리 id
        		,{id: 'mchnInfoId'}          //기기id
        		 ]
	    });
		
		dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    });
		
		var columnModel = new Rui.ui.grid.LColumnModel({
	        groupMerge: true,
	        columns: [
	        	new Rui.ui.grid.LSelectionColumn()
	        	,{field: 'rgstNm'     	,label:'이름' ,    	sortable: false, align: 'center', width: 150}
	        	,{field: 'rgstId'		,label:'id' ,      	sortable: false, align: 'center', width: 160}
	        	,{field: 'rgstTeam'     ,label:'팀'   ,    	sortable: false, align: 'center', width: 364}
	        	,{field: 'rgstJobx'     ,label:'직급' ,     sortable: false, align: 'center', width: 110}
	        	,{field: 'rgstDt'       ,label:'신청일' ,   sortable: false, align: 'center', width: 130}
	        	,{field: 'ccsDt'        ,label:'수료일' ,   sortable: false, align: 'center', width: 130}
	        	,{field: 'eduStNm'      ,label:'상태',		sortable: false, align: 'center', width: 110}
	        	,{field: 'ccsTrtmNm'    ,label:'처리자',	sortable: false, align: 'center', width: 120}
	        	,{field: 'saMail'     	,hidden : true}
	        	,{field: 'eduCrgrId'    ,hidden : true}
	        	,{field: 'eduDtlId'     ,hidden : true}
	        	,{field: 'mchnInfoId'   ,hidden : true}
	        ]
	    });

		var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width:1150,
	        height: 440,
	        autoWidth : true
	    });

		grid.render('mhcnGrid'); 
		
		/* grid  전체 엑셀다운로드용*/
		excelDataSet = new Rui.data.LJsonDataSet({
	        id: 'excelDataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
        		 {id: 'rgstNm'}           	//이름
        		,{id: 'rgstId'}           	//id
        		,{id: 'rgstTeam'}           	//팀
        		,{id: 'rgstJobx'}          //직급
        		,{id: 'rgstDt'}              //신청일
        		,{id: 'ccsDt'}            //수료일
        		,{id: 'eduStNm'}          //상태
        		,{id: 'ccsTrtmNm'}          //처리자
        		,{id: 'eduCrgrId'}          //등록자 id
        		,{id: 'eduDtlId'}          //교육신청관리 id
        		 ]
	    });

		var exelColumnModel = new Rui.ui.grid.LColumnModel({
	        columns: [
	        	 {field: 'rgstNm'     	,label:'이름'   ,  	sortable: false, align: 'center', width: 80}
	        	,{field: 'rgstId'		,label:'id' ,      	sortable: false, align: 'center', width: 120}
	        	,{field: 'rgstTeam'     ,label:'팀'   ,    	sortable: false, align: 'center', width: 180}
	        	,{field: 'rgstJobx'     ,label:'직급' ,    	sortable: false, align: 'center', width: 100}
	        	,{field: 'rgstDt'       ,label:'신청일' ,  	sortable: false, align: 'center', width: 80}
	        	,{field: 'ccsDt'        ,label:'수료일' ,  	sortable: false, align: 'center', width: 80}
	        	,{field: 'eduStNm'      ,label:'상태',		sortable: false, align: 'center', width: 80}
	        	,{field: 'ccsTrtmNm'    ,label:'처리자',	sortable: false, align: 'center', width: 80}
	        	,{field: 'eduCrgrId'    ,hidden : true}
	        	,{field: 'eduDtlId'     ,hidden : true}
	        ]
	    });

		var excelGrid = new Rui.ui.grid.LGridPanel({
	        columnModel: exelColumnModel,
	        dataSet: excelDataSet
	    });
		excelGrid.render('excelGrid');
		
 		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		
 		fnSearch = function(){
			dm.loadDataSet({
				dataSets: [ dataSet, mchnInfoDataSet, excelDataSet],
				url: '<c:url value="/mchn/open/eduAnl/retrieveMchnEduAnlRgstInfo.do"/>',
				params :{
					mchnEduId  : document.aform.mchnEduId.value,	//교육명
					mchnInfoId  : document.aform.mchnInfoId.value	//기기명
	                }
			});
		}

		fnSearch();

		var chkDtlId="";
	    var chkRecMailAddr="";
	    var chkRgstNm="";
	    
		//수료
		var butCcslBtn = new Rui.ui.LButton('butCcs');
		butCcslBtn.on('click', function(){
			var eduStCd = 'CCS';
        	fncSaveMchnEduAnl(eduStCd);
        });

		//미수료
		var butNcpelBtn = new Rui.ui.LButton('butNcpe');
		butNcpelBtn.on('click', function(){
			var eduStCd = 'NCPE';
	        fncSaveMchnEduAnl(eduStCd);
        });


		//수료, 미수로 저장
		var fncSaveMchnEduAnl = function(cd){
			chkDtlId="";
		    chkRecMailAddr="";
		    chkRgstNm = "";
		    
		    var confirmMsg;
		    var eMsg;
		    
		    if( cd == "CCS" ){
		    	confirmMsg= "수료처리를 하시겠습니까?";
		    	eMsg = "수료할 목록을 선택해 주십시오"; 		
		    }else{
		    	confirmMsg= "미수료처리를 하시겠습니까?";
		    	eMsg = "미수료할 목록을 선택해 주십시오"; 		
		    }
		    
		    dm.on('success', function(e) {      // 승인 성공시
				var resultData = resultDataSet.getReadData(e);
				Rui.alert(resultData.records[0].rtnMsg);
				
    			if( resultData.records[0].rtnSt == "S"){
		    		fnSearch();
	    		}
    	    });
    	    dm.on('failure', function(e) {      // 승인 실패시
    	    	Rui.alert(resultData.records[0].rtnMsg);
    	    });
    	    
			if(dataSet.getMarkedCount() > 0) {
				for(var i = 0; i < dataSet.getCount(); i++){
					if(dataSet.isMarked(i)) {
						var record = dataSet.getAt(i);
						/* 
						if(record.get("eduStCd") != "RQ"){
							Rui.alert("수료 및 미수건이 있습니다.");
							return;
						}
						 */
						chkDtlId = chkDtlId+String(record.get("eduDtlId"))+',';
						chkRecMailAddr = chkRecMailAddr+String(record.get("saMail"))+',';
						chkRgstNm = chkRgstNm+String(record.get("rgstNm"))+',';
					}
			  	}

				Rui.confirm({
        			text: confirmMsg,
        	        handlerYes: function() {
        	    	    dm.updateDataSet({
        	        	    url: "<c:url value='/mchn/open/eduAnl/updateEduDetailInfo.do'/>"
        	        	  ,	params: {                                 // 업데이트시 조건 파라메터를 기술합니다.
        	        		  		eduStCd : cd
        	      	    		   ,chkDtlId : chkDtlId
        	      	    		   ,chkRecMailAddr : chkRecMailAddr
        	      	    		   ,mailTitl : mailTitl
        	      	    		   ,eduNm : mchnInfoDataSet.getNameValue(0, "eduNm") 
        	  	    		       ,eduCrgrNm :mchnInfoDataSet.getNameValue(0, "eduCrgrNm")
        	  	    		       ,chkRgstNm :  chkRgstNm
        	  	    		       ,menuType : document.aform.menuType.value
        	        	            }
        	        	});
        	        }
        		});
            }else{
            	Rui.alert("처리할 건수가 없습니다.");
            	return;
            } 
		}

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){
        	if(dataSet.getCount() > 0 ) {
	            var excelColumnModel = columnModel.createExcelColumnModel(false);
	            grid.saveExcel(encodeURIComponent('기기관리_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        });

		/* 엑셀 다운로드 */
		var saveAllExcelBtn = new Rui.ui.LButton('butAllExcl');
		saveAllExcelBtn.on('click', function(){
        	if(excelDataSet.getCount() > 0 ) {
	            var excelAllColumnModel = exelColumnModel.createExcelColumnModel(false);
	            excelGrid.saveExcel(encodeURIComponent('기기관리전체_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelAllColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        });

		//분석기기 목록 화면으로 이동
		var butListlBtn = new Rui.ui.LButton('butList');
		butListlBtn.on('click', function(){
			$('#searchForm > input[name=eduNm]').val(encodeURIComponent($('#searchForm > input[name=eduNm]').val()));
			$('#searchForm > input[name=mchnNm]').val(encodeURIComponent($('#searchForm > input[name=mchnNm]').val()));
			
			nwinsActSubmit(searchForm, "<c:url value="/mchn/open/eduAnl/retrieveEduAdmListList.do"/>");	
        });


	});  //end ready

</script>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
			<h2>교육신청관리</h2>
		</div>
		<div class="sub-content">
		
		<form name="searchForm" id="searchForm">
			<input type="hidden" name="eduNm" value="${inputData.eduNm}"/>
			<input type="hidden" name="mchnNm" value="${inputData.mchnNm}"/>
			<input type="hidden" name="eduScnCd" value="${inputData.eduScnCd}"/>
			<input type="hidden" name="pttYn" value="${inputData.pttYn}"/>
	    </form>
	    
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" value="IRIDE0105"/>
				<input type="hidden" id="mchnCrgrId" name="mchnCrgrId" />
				<input type="hidden" id="infoMgmtId" name="infoMgmtId" />
				<input type="hidden" id="eduPttStNm" name="eduPttStNm" />
				<input type="hidden" id="mchnInfoId" name="mchnInfoId"  value="<c:out value='${inputData.mchnInfoId}'/>">
				<input type="hidden" id="mchnEduId" name="mchnEduId"  value="<c:out value='${inputData.mchnEduId}'/>">

				<div class="LblockButton top">
					<button type="button" id="butList">목록</button>
				</div>
				
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tr>
							<th align="right">교육명</th>
							<td colspan="3">
								<div id="eduPttSt"></div>
								[<span id="eduScnNm"></span>]<span id="eduNm"></span>
							</td>
						</tr>
						<tr>
							<th align="right">분석기기</th>
							<td>
								<span id="mchnNm"></span>
							</td>
							<th align="right">담당자</th>
							<td>
								<span id="eduCrgrNm"></span>
							</td>
						</tr>
						<tr>
							<th align="right">신청기간</th>
							<td>
								<span id="pttFromDt"></span><span id="pttToDt"></span>
							</td>
							<th align="right">모집인원</th>
							<td>
								신청 : <span id="pttCpsn"></span> /  정원 : <span id="ivttCpsn"></span>
							</td>
						</tr>
						<tr>
							<th align="right">교육일시</th>
							<td>
								<span id="eduDt"></span> <span id="eduFromTim"></span>시 ~ <span id="eduToTim"></span>시
							</td>
							<th align="right">교육장소</th>
							<td>
								<span id="eduPl"></span>
							</td>
						</tr>
						</tbody>
				</table>
				<div class="titArea">
					<span class="table_summay_number" id="cnt_text" vAlign="bottom"></span>
					<div class="LblockButton">
						<button type="button" id="butCcs">수료</button>
						<button type="button" id="butNcpe">미수료</button>
						<button type="button" id="butExcl">EXCEL</button>
						<button type="button" id="butAllExcl">전체EXCEL</button>
					</div>
				</div>
				 <div id="mhcnGrid"></div>
				 <div id="excelGrid"></div>
			</form>
		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>