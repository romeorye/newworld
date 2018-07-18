<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: comCodeList.jsp
 * @desc    : 통계 > 공통코드 관리 >공통코드
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.11.16     IRIS05		최초생성
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
var codeRegDialog;


	Rui.onReady(function() {

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

        var delYnCombo = new Rui.ui.form.LCombo({
            rendererField: 'value',
            autoMapping: true,
            listWidth: 30,
            defaultValue: 'N',
			items: [
	                  { code: 'Y', value: 'Y' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                  { code: 'N', value: 'N' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
	               	]
        });
        
		/*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
         dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
             	  { id: 'comCdCd'}
 				, { id: 'comCdNm'}
 				, { id: 'comCdExpl'}
 				, { id: 'comDtlCd'}
 				, { id: 'comDtlNm'}
 				, { id: 'delYn'}
 				, { id: 'frstRgstDt'}
 				, { id: 'frstRgstId'}
 				, { id: 'lastMdfyDt'}
 				, { id: 'lastMdfyId'}
 				, { id: 'comOrd'}
 				, { id: 'comId'}
 				, { id: '_userId'}
 			]
         });

         dataSet.on('load', function(e){
 	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
 	    });

         var columnModel = new Rui.ui.grid.LColumnModel({
             columns: [
         	 	new Rui.ui.grid.LSelectionColumn(),
 					   { field: 'comCdCd' 		, label: '코드구분',  	align:'center', width: 180}
                     , { field: 'comCdNm'   	, label: '코드명', 		align:'left', 	width: 180}
                     , { field: 'comOrd'    	, label: '순서', 		editor: new Rui.ui.form.LNumberBox(), 	align:'center', width: 40}
                     , { field: 'comDtlCd'  	, label: '코드',  		editor: new Rui.ui.form.LTextBox(),  align:'center', width: 80 , renderer: function(value, p, record){
	     	        		if(Rui.isEmpty(record.get("comId"))  ){	//추가일 경우  수정가능
	     	        			 p.editable = true;
	     	        		}else{
	     	        			 p.editable = false;
	     	        		}	
	     	        		return value
	    	        	  }	
	    	          }
                     , { field: 'comDtlNm'      , label: '코드값',  	editor: new Rui.ui.form.LTextBox(), 	align:'left', 	width:180}
                     , { field: 'delYn' 	 	, label: '삭제여부',  	editor: delYnCombo, 	align:'center'}
                     , { field: 'frstRgstDt'   	, label: '등록일',  	align:'center', width: 90}
                     , { field: 'frstRgstId'    , label: '등록자',  	align:'center', width: 80}
                     , { field: 'lastMdfyDt' 	, label: '수정일', 		align:'center', width: 90}
                     , { field: 'lastMdfyId' 	, label: '수정자',  	align:'center', width: 80}
                     , { field: 'comId' 	, hidden:true}
                     , { field: 'comCdExpl' 	, hidden:true}
                     , { field: '_userId' 	, hidden:true}
             ]
         });

         /** default grid **/
         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             width: 1150,
             height: 480
         });

         grid.render('defaultGrid');
         
        //code
 	    var code = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'code',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        emptyValue : '',
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //code name
 	    var codeNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'codeNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        emptyValue : '',
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

        fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/stat/code/retrieveCcomCodeList.do"/>' ,
	            params :{
	            	code 	: code.getValue(), 		// wbsCd
	            	codeNm 	: encodeURIComponent(codeNm.getValue())	//자산명
                }
            });
        }
        
        // 화면로드시 조회
	    fnSearch();

	  	//코드 등록 
     	codeRegDialog = new Rui.ui.LFrameDialog({
	        id: 'codeRegDialog',
	        title: '코드 등록',
	        width:  900,
	        height: 600,
	        modal: true,
	        visible: false
	    });

	  	codeRegDialog.render(document.body);

	  	
	  	 /* [버튼] : 코드 정보 저장  */
	    var butUpdate = new Rui.ui.LButton('butUpdate');
	    
	    butUpdate.on('click', function(){
	    	var dm = new Rui.data.LDataSetManager();
	        dm.on('success', function(e) {      // 업데이트 성공시 
	        	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    		 	
    			if( resultData.records[0].rtnSt == "S"){
    				fnSearch();
    			}
	        });
	     
	        dm.on('failure', function(e) {      // 업데이트 실패시
	        	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
	        });
	     
	        dm.updateDataSet({                            				// 데이터 변경시 호출함수 입니다.
	            url: '<c:url value="/stat/code/saveCodeInfo.do"/>' ,	// 서버측 URL을 기술합니다.
	            dataSets:[dataSet]
	        });
	    });

	    /* [버튼] : 신규 코드 등록 팝업창으로 이동 */
	    var butRgst = new Rui.ui.LButton('butRgst');
	    
		butRgst.on('click', function(){
			codeRegDialog.setUrl('<c:url value="/stat/code/codeRegPop.do"/>');
			codeRegDialog.show(true);
		});

	    /* [버튼] : 자산신규 페이지로 이동 */
	    var butAdd = new Rui.ui.LButton('butAdd');
	    
	    butAdd.on('click', function(){
	    	
	    	if(Rui.isEmpty(code.getValue())  &&   Rui.isEmpty(code.getValue())){
		    	dataSet.newRecord();
	    	}else{
	    		var row = dataSet.newRecord();
	    		var beforeRecord = dataSet.getAt(row-1);
	            var record = dataSet.getAt(row);
	            
	            record.set('comCdCd', beforeRecord.get("comCdCd"));
	            record.set('comCdNm', beforeRecord.get("comCdNm"));
	            record.set('delYn', 'N');
	            record.set('comCdExpl', beforeRecord.get("comCdExpl"));
	            record.set('_userId', '${inputData._userId}');
	    	}
		});

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){
        	if(dataSet.getCount() > 0 ) {
	            var excelColumnModel = columnModel.createExcelColumnModel(false);
	            grid.saveExcel(encodeURIComponent('공통코드_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        });

	});		//end ready


	function fncPopCls(){
		codeRegDialog.cancel(true);
	}

</script>
    </head>
    <body onkeypress="if(event.keyCode==13) {fnSearch();}">
    		<div class="contents">
    			<div class="titleArea">
    				<h2>공통코드 관리</h2>
    		    </div>
    			<div class="sub-content">
					<form name="aform" id="aform" method="post">
					<input type="hidden" id="menuType"  name="menuType" value="IRIFI0101" />

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
    							<th align="right">코드</th>
	   							<td>
	   								<span>
										<input type="text" class="" id="code" >
									</span>
	   							</td>
    							<th align="right">코드명</th>
	    						<td>
	    							<input type="text" class="" id="codeNm" >
	    						</td>
	    						<td rowspan="3" class="t_center">
    								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
    							</td>
    						</tr>
    					</tbody>
    				</table>

    				<div class="titArea">
    					<span class=table_summay_number id="cnt_text"></span>
						<div class="LblockButton">
    						<button type="button" id="butRgst" 		name="butRgst" >신규등록</button>
    						<button type="button" id="butAdd" 		name="butAdd" >추가</button>
    						<button type="button" id="butUpdate" 	name="butUpdate" >저장</button>
    						<button type="button" id="butExcl" 		name="butExcl">EXCEL</button>
    					</div>
    				</div>
    				<div id="defaultGrid"></div>

				</form>

    			</div><!-- //sub-content -->
    		</div><!-- //contents -->
    </body>
    </html>