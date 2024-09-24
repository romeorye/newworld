<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: grsTempList.jsp
 * @desc    :  심의 요청내역
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.28  jih		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>

<style>
    .grid-bg-color-sum {
        background-color: rgb(255,204,204);
    }
</style>

<%
    HashMap inputData = (HashMap)request.getAttribute("inputData");
%>
    <!-- 그리드 소스 -->
<script type="text/javascript">
    Rui.onReady(function() {       


        /*******************
          * 변수 및 객체 선언 START
        *******************/


        var evSbcNm = new Rui.ui.form.LTextBox({
            applyTo: 'evSbcNm',
            placeholder: '검색할 템플릿명을 입력해주세요.',
            defaultValue: '',
            emptyValue: '',
            width: 500
       });
        
        
//         var grsY = new Rui.ui.form.LDateBox({ //검색용 년도
//             applyTo: 'grsY',
//             mask: '9999',
//             displayValue: '%Y',
//             defaultValue: new Date(),
//             width: 100,
//             dateType: 'string'
//         });
        
        
        var grsYCombo = new Rui.ui.form.LCombo({
        	applyTo: 'grsY',
            url: '<c:url value="/prj/tss/gen/retrieveGenTssGoalYy.do"/>',
            displayField: 'goalYy',
            valueField: 'goalYy',
            defaultValue: new Date().getFullYear(),
            rendererField: 'value',
            autoMapping: true
        });
        grsYCombo.getDataSet().on('load', function(e) {
        	  grsYCombo.setValue( new Date().getFullYear());
        });
        

        
        var grsTypeCombo = new Rui.ui.form.LCombo({ // 검색용 유형
			applyTo: 'grsType',
       		emptyText: '(전체)',		
       		emptyValue: '',
       		useEmptyText: true,
			url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=GRS_TYPE"/>',
			displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD'
        });

	   	var useYnCombo = new Rui.ui.form.LCombo({ // 검색용 성태
			applyTo : 'useYn',
			emptyText: '(전체)',		
			emptyValue: '',
			useEmptyText: true,
			url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=comm_YN"/>',
			displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD'
	   	});


	    var textBox = new Rui.ui.form.LTextBox({
            emptyValue: ''
        });
        
        var numberBox = new Rui.ui.form.LNumberBox({
            emptyValue: '',
            minValue: 0,
            maxValue: 99999
        });
	   	
	   	
        /*******************
          * 변수 및 객체 선언 END
        *******************/
        /*******************
         * 그리드 셋팅 START
         *******************/
         var dataSet = new Rui.data.LJsonDataSet({
             id: 'grsDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'grsY' }           	 //년도
                 , { id: 'grsType' }        	 //유형 
                 , { id: 'evSbcNm' }         	 //템플릿명 
                 , { id: 'useYn' }         		 //사용여부 
             ]
         });

         var bind = new Rui.data.LBind({
             groupId: 'LblockDetail01',
             dataSet: dataSet,
             bind: true,
             bindInfo: [
                   { id: 'grsY',            ctrlId: 'grsY',            	value: 'value' }
                 , { id: 'grsType',   		ctrlId: 'grsType',     		value: 'value' }
                 , { id: 'evSbcNm',    		ctrlId: 'evSbcNm',      	value: 'value' }
                 , { id: 'useYn',           ctrlId: 'useYn',         	value: 'value' }
               
             ]
         });
         
         var gridDataSet = new Rui.data.LJsonDataSet({ //listGrid dataSet
 			id: 'gridDataSet',
 			focusFirstRow: 0,
 	        lazyLoad: true,
 	        fields: [
 	                { id: 'grsEvSn'}, 			//GRS 일련번호  
 	                { id: 'grsEvSeq'},          //평가STEP1   
 	                { id: 'evPrvsNm_1'},        //평가항목명1  
 	                { id: 'evPrvsNm_2'},        //평가항목명2  
 	                { id: 'evCrtnNm'},         //평가기준명  
 	                { id: 'evSbcTxt'},          //평가내용     
 	                { id: 'dtlSbcTitl_1'},      //상세내용1    
 	                { id: 'dtlSbcTitl_2'},      //상세내용2    
 	                { id: 'dtlSbcTitl_3'},      //상세내용3    
 	                { id: 'dtlSbcTitl_4'},      //상세내용4    
 	                { id: 'dtlSbcTitl_5'},      //상세내용5    
 	                { id: 'wgvl'},              //가중치     
 	               	{ id: 'grsY'},              //년도        
 	              	{ id: 'grsType'},           //유형        
 	             	{ id: 'evSbcNm'},           //템플릿명     
 	            	{ id: 'useYn'}              //사용여부    
 	                ]
		});
        
        
        var mGridColumnModel = new Rui.ui.grid.LColumnModel({  //listGrid column
            columns: [       
            	   new Rui.ui.grid.LNumberColumn(),
          			{ field: 'evPrvsNm_1',     	label: '평가항목',   sortable: false, align:'center', width: 160 ,editor: textBox		, editable: true },
          			{ field: 'evPrvsNm_2',     	label: '평가항목',   sortable: false, align:'center', width: 160 ,editor: textBox		, editable: true },
          			{ field: 'evCrtnNm',     	label: '평가기준',   sortable: false, align:'center', width: 160 ,editor: textBox		, editable: true },
          			{ field: 'evSbcTxt',     	label: '평가내용',   sortable: false, align:'center', width: 200 ,editor: textBox		, editable: true },
          			{ id: 'G1', label: '평가 기준및 배점' },
          			{ field: 'dtlSbcTitl_1',   groupId: 'G1' , label: '5점',   sortable: false, align:'left', width: 70  ,editor: textBox, editable: true},
          			{ field: 'dtlSbcTitl_2',   groupId: 'G1' , label: '4점',   sortable: false, align:'left', width: 70  ,editor: textBox, editable: true},
          			{ field: 'dtlSbcTitl_3',   groupId: 'G1' , label: '3점',   sortable: false, align:'left', width: 70  ,editor: textBox, editable: true},
          			{ field: 'dtlSbcTitl_4',   groupId: 'G1' , label: '2점',   sortable: false, align:'left', width: 70  ,editor: textBox, editable: true},
          			{ field: 'dtlSbcTitl_5',   groupId: 'G1' , label: '1점',   sortable: false, align:'left', width: 70  ,editor: textBox, editable: true},
          			{ field: 'wgvl',    		label: '가중치',    sortable: false, align:'left', width: 120   ,editor: numberBox, editable: true}
          		   
            ]
        });

        var listGrid = new Rui.ui.grid.LGridPanel({ //listGrid
            columnModel: mGridColumnModel,
            dataSet: gridDataSet,
            height: 450,
            width: 600,             
            autoToEdit: false,
            autoWidth: true
        });

        listGrid.render('listGrid'); //listGrid render

        /*******************
         * 그리드 셋팅 END
        *******************/
        var   validatorManager = new Rui.validate.LValidatorManager({
            validators:[
				{id:'grsY', validExp:'년도:true', fn:function(){
									var sGrsYCombo = grsYCombo.getValue();
									if(sGrsYCombo == null) return false;
									return true;
								}},
			   
                {id:'grsType', 	validExp:'유형:true'},
				{id:'useYn',	validExp:'상태:true'},				
                {id:'evSbcNm', 	validExp:'템플릿명:true&maxByteLength=2000&minByteLength=2'}
               
            ]
        });
        
        var vm1 = new Rui.validate.LValidatorManager({
            validators: [  
                 	{ id: 'evPrvsNm_1',  validExp: '평가항목:true:number&minLength=1&maxLength=1000' }
                  , { id: 'evCrtnNm',    validExp: '평가기준:true:number&minLength=1&maxLength=1000' }
                  , { id: 'evSbcTxt',    validExp: '평가내용:true&minLength=1&maxLength=1000' }
                  , { id: 'wgvl',    	 validExp: '가중치:true:number' }
            ]
        });
        
    
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
        	 var data = dataSet.getReadData(e);
             
             Rui.alert(data.records[0].rtVal);
             
             if(data.records[0].rtCd == "FAIL") {
                 dataSet.setState(0, 1);
             }
             
		});
        
        
        /*******************
          * Function 및 데이터 처리 START
        *******************/
        <%--/*******************************************************************************
         * FUNCTION 명 : grid 추가 
         * FUNCTION 기능설명 : 데이터 추가
         *******************************************************************************/--%>
       
        /* [버튼] 추가 */
        var addBtn = new Rui.ui.LButton('addBtn');
        addBtn.on('click', function() {
            var row = gridDataSet.newRecord();
            var record = gridDataSet.getAt(row);
        });
        
        <%--/*******************************************************************************
         * FUNCTION 명 :  grid 삭제 
         * FUNCTION 기능설명 : data 삭제
         *******************************************************************************/--%>  
     
        /* [버튼] 삭제 */
        var delBtn = new Rui.ui.LButton('delBtn');
        delBtn.on('click', function() {                
            Rui.confirm({
                text: Rui.getMessageManager().get('$.base.msg107'),
                handlerYes: function() {
                    if(gridDataSet.getMarkedCount() > 0) {
                        gridDataSet.removeMarkedRows();
                    } else {
                        var row = gridDataSet.getRow();
                        if(row < 0) return;                        
                        gridDataSet.removeAt(row);
                    }
                    
                  //삭제된 레코드 외 상태 정상처리
                    var delRowCnt = 0;
                    for(var i = 0; i < gridDataSet.getCount(); i++) {
                    	if(gridDataSet.getState(i) == 3) {
                    		delRowCnt++;
                    	}
                    	else {
                    		gridDataSet.setState(i, Rui.data.LRecord.STATE_NORMAL);
                    	}
                    }
                    
                    if(delRowCnt > 0) {
	                    dm.updateDataSet({
	                        url:'<c:url value="/prj/mgmt/grst/deleteGrsTemp.do"/>',
	                        dataSets:[gridDataSet]
	                    });
                    }
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        <%--/*******************************************************************************
         * FUNCTION 명 : 저장 
         * FUNCTION 기능설명 : DB 저장
         *******************************************************************************/--%>
      
        /* [버튼] 저장 */
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
        	 if(!validation()) return false;
        	 
        	 
        	 if(!gridDataSet.isUpdated()) {
                 Rui.alert("평가 항목에 변경된 데이터가 없습니다.");
                 return;
             }
        	 
        	  if(!vm1.validateDataSet(gridDataSet, gridDataSet.getRow())) { 
                  Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm1.getMessageList().join('<br>'));
                  return false;
              }
        	  
        	 var sumWgvl =0;
 	    	//가중치 합 Check	
 	       	 for(var i = 0 ; i < gridDataSet.getCount();  i++) {
 	                var recode = gridDataSet.getAt(i);
 	                sumWgvl = Number(sumWgvl)+ Number(recode.get('wgvl'));
 	           
 	       	 }
 	 
 	    	 if(isNaN(sumWgvl)){
	 	    		Rui.alert("가중치에 데이터가 없습니다.\n\n데이터를 입력해 주세요");
	                return;
 	    	 }else{
	 	       	 if(sumWgvl>100){
	 	       		 Rui.alert("가중치 합이 100을 초과했습니다.\n\n가중치 합이 100되도록 조정해 주세요 ");
	 	       		 return false;
	 	       	 }
	 	       	 if(sumWgvl<100){
	 	       		 Rui.alert("가중치 합이 100을 미만입니다.\n\n가중치 합이 100되도록 조정해 주세요 ");
	 	       		 return false;
	 	       	 }
 	    	 }
            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                	 var param = jQuery("#xform").serialize().replace(/%/g,'%25');
                	 dm.updateDataSet({
                         modifiedOnly: false,
                         url:'<c:url value="/prj/mgmt/grst/insertGrsTempSave.do"/>',
                         dataSets:[gridDataSet],
                 		 params:param
                     });
                 
                },
               handlerNo: Rui.emptyFn
            });
            
            
            
        });
        
       
        
        <%--/*******************************************************************************
        * FUNCTION 명 : 목록이동 
        * FUNCTION 기능설명 : 목록이동
        *******************************************************************************/--%>
   
        
        /* [버튼] 목록 */
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(document.xform, "<c:url value='/prj/mgmt/grst/grsTempList.do'/>");
        });
        
    
        <%--/*******************************************************************************
         * FUNCTION 명 : validation 
         * FUNCTION 기능설명 : 입력값 점검
         *******************************************************************************/--%>
         function validation(){
         	if(!validatorManager.validateGroup($('xform'))){
         		Rui.alert({
         			text: validatorManager.getMessageList().join('<br/>'),
         			width: 380
         		});
         		return false;
         	}
         	return true;
         }
          
     });

    
</script>
</head>

<body>
<Tag:saymessage/><!--  sayMessage 사용시 필요 -->
	<div class="titleArea">
   		<h2>GRS 템플릿 저장</h2>
   	</div>
	<div class="contents" >				
    	<div class="titleArea">
    		<%@ include file="/WEB-INF/jsp/include/navigator.jspf"%>
    	</div>
		<div class="sub-content">	
		<div id="LblockDetail01" class="LblockDetail">
			<form name="xform" id="xform" method="post"> 
				<input type=hidden name='_userId' value='<c:out value="${inputData._userId}"/>'> 
				<input type=hidden name='grsEvSn' id='grsEvSn'/>
				<table class="searchBox">
	   					<colgroup>
	   						<col style="width:15%;"/>
	   						<col style="width:35%;"/>
	   						<col style="width:15%;"/>
	   						<col style="width:35%;"/>
	   					</colgroup>
	   					<tbody>
	   						
	   						<tr>
	   							<th align="right">년도</th>
	   							<td>
	                             <div id="grsY" id='grsY' name='grsY'></div>
	   							</td>
	   							<th align="right">유형</th>
	   							<td>
	                                <div id="grsType"  name='grsType'></div>
	   							</td>
	   							
	   						</tr>
	   						<tr>
	   							<th align="right">템플릿명</th>
	   							<td>
	   								<input type="text" id="evSbcNm" name="evSbcNm">
	   							</td>
	   							<th align="right">상태</th>
	   							<td>
	                                <div id="useYn" name="useYn"></div>
	   							</td>
	   						
	   							
		    					
	   					</tbody>
   				</table>
	    		
			</form>
			</div>		
	    	<div class="titArea">
			    <div class="LblockButton">
			        <button type="button" id="addBtn" name="addBtn">추가</button>
			        <button type="button" id="delBtn" name="delBtn">삭제</button>
			    </div>
			</div>
		
			    <div id="listGrid"></div>
			
		   
            	<div class="titArea">
   					<div class="LblockButton">
   						        <button type="button" id="btnSave" name="btnSave">저장</button>
       							<button type="button" id="btnList" name="btnList">목록</button>
   					</div>
   				</div>	

		</div>		
	</div>
</body>
</html>