<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: rfpReg.jsp
 * @desc    : RFP 요청서>  RFP 요청서 등록 및 수정
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.05.16     IRIS05		최초생성
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
		
        
        /*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             fields: [
            	  {id : 'rfpId'}  
            	 ,{id : 'title'}
            	 ,{id : 'reqDate'}
            	 ,{id : 'rsechEngn'}
            	 ,{id : 'descTclg'}
            	 ,{id : 'exptAppl'}
            	 ,{id : 'mainReq'}
            	 ,{id : 'benchMarkTclg'}
            	 ,{id : 'colaboTclg'}
            	 ,{id : 'timeline'}
            	 ,{id : 'comments'}
            	 ,{id : 'companyNm'}
            	 ,{id : 'pjtImgView'}
            	 ,{id : 'submitYn'}
            	 ,{id : 'rgstEmpNo'}                                                   
 			]
        });
		
        dataSet.on('load', function(e){
        	if(!Rui.isEmpty(dataSet.getNameValue(0, "pjtImgView")) ){
				CrossEditor.SetBodyValue( dataSet.getNameValue(0, "pjtImgView") );
        	}
        
		 	if(!Rui.isEmpty(dataSet.getNameValue(0, 'rfpId'))){
       			var splitCode =dataSet.getNameValue(0, 'colaboTclg').split(",");		
       		
       			for (var idx in splitCode) {
       				if( Rui.isEmpty(splitCode[idx])  ) return;
       				$("input[name=colaboTclg][value="+splitCode[idx]+"]").attr("checked", true);
   			  	}
       	 	} 
		 	
        });
        
      	//title
	    var title = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'title',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 900,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });
		
      	//Research Engineer
	    var rsechEngn = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
  	        applyTo: 'rsechEngn',                           // 해당 DOM Id 위치에 텍스트박스를 적용
  	        width: 400,                                    // 텍스트박스 폭을 설정
  	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
  	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
  	    });
      	
	  	//RequestDate
  	  	var reqDate = new Rui.ui.form.LDateBox({
          applyTo: 'reqDate',
          mask: '9999-99-99',
          width: 400, 
          defaultValue: new Date(),
          dateType: 'string'
      	});
      	
  	  	//Description of Technology(기술 설명)
	    var descTclg = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'descTclg',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	  	
	    //Expected Applications(예상적용분야)
	    var exptAppl = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'exptAppl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	    });

	    //Main Request(목표 스펙, 이슈)
	    var mainReq = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'mainReq',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	    });
	    
	    //Bench Marking  Technology(State of the Art)(최신 기술 현황)
	    var benchMarkTclg = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'benchMarkTclg',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	    });
	  	
	    //Timeline(일정)
	    var timeline = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'timeline',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	    });
	  	
	    //comments
	    var comments = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'comments',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	    
	    //Company Name (Optional)
	    var companyNm = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'companyNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	    /* 
        var colaboTclg = new Rui.ui.form.LCheckBoxGroup({
            applyTo: 'colaboTclg',
            name: 'colaboTclg',
            items: [
                {
                    label: ' Joint development / R&D outsourcing',
                    value: 'JR'
                }, {
                    label: ' Component sourcing',
                    value: 'CS'
                }, {
                    label: ' In- / out licensing',
                    value: 'IO'
                },{
                    label: ' Search for specialist / recruiting',
                    value: 'SS'
                },{
                    label: ' Meeting arrangement',
                    value: 'MA'
                },{
                    label: ' Benchmarking / technology evaluation',
                    value: 'BT'
                }
            ]
        });
	     */
	    fnSearch = function() {
	 	 	dataSet.load({
	 	    		url: '<c:url value="/prj/tss/rfp/retrieveRfpInfo.do"/>',
	 	            params :{
	 	            		rfpId  : '${inputData.rfpId}'
	 	    	          }
	        });
	    }
	    
	    fnSearch();
	    
	    /* [DataSet] bind */
	    bind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: dataSet,
	        bind: true,
	        bindInfo: [
	        	 {id : 'title', 		ctrlId : 'title',  			value : 'value'}
	        	,{id : 'reqDate', 		ctrlId : 'reqDate',  		value : 'value'}
	        	,{id : 'rsechEngn', 	ctrlId : 'rsechEngn',  		value : 'value'}
	        	,{id : 'descTclg', 		ctrlId : 'descTclg',  		value : 'value'}
	        	,{id : 'exptAppl', 		ctrlId : 'exptAppl',  		value : 'value'}
	        	,{id : 'mainReq', 		ctrlId : 'mainReq',  		value : 'value'}
	        	,{id : 'benchMarkTclg', ctrlId : 'benchMarkTclg',  	value : 'value'}
	        	,{id : 'timeline', 		ctrlId : 'timeline',  		value : 'value'}
	        	,{id : 'comments', 		ctrlId : 'comments',  		value : 'value'}
	        	,{id : 'companyNm', 	ctrlId : 'companyNm',  		value : 'value'}
	        	//,{id : 'colaboTclg', 	ctlId : 'colaboTclg',  		value : 'value'}
	        ]
	    }); 
	    
	    fncVaild = function(){
    	    var frm = document.aform;

    		dataSet.setNameValue(0, 'pjtImgView', CrossEditor.GetBodyValue());

			// 에디터 valid
			if( dataSet.getNameValue(0, "pjtImgView") == "<p><br></p>" || dataSet.getNameValue(0, "pjtImgView") == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert("내용을 입력해주십시오.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}
    		// 체크 되어 있는 값 추출
    		var colaboTclgVal = "";
    		
			$("input[name=colaboTclg]:checked").each(function() {
				colaboTclgVal = colaboTclgVal+$(this).val()+",";
			});
			
    		dataSet.setNameValue(0, 'colaboTclg', colaboTclgVal);
	        	
    		return true;
		}
	    
	    /* [버튼] : 저장  */
       	var butSave = new Rui.ui.LButton('butSave');
       	butSave.on('click', function(){
       		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
       		dm.on('success', function(e) {      // 업데이트 성공시
       			var resultData = resultDataSet.getReadData(e);
   	   				alert(resultData.records[0].rtnMsg);
       		 	
       			if( resultData.records[0].rtnSt == "S"){
       				fncRfpList();
       			}
       	    });

       	    dm.on('failure', function(e) {      // 업데이트 실패시
       	    	var resultData = resultDataSet.getReadData(e);
   	   				alert(resultData.records[0].rtnMsg);
       	    });

   			if(fncVaild()){
   				if(confirm("저장 하시겠습니까?")) {
   					dm.updateDataSet({
	   		             dataSets:[dataSet],
	   		             url:"<c:url value='/prj/tss/rfp/saveRfpInfo.do'/>",
	   		             modifiedOnly: false
	   		         });
   				}
   			}
       	});
 
       	/* [버튼] : 삭제  */
       	var butDel = new Rui.ui.LButton('butDel');
       	butDel.on('click', function(){
       		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
       		dm.on('success', function(e) {      // 업데이트 성공시
       			var resultData = resultDataSet.getReadData(e);
   	   			alert(resultData.records[0].rtnMsg);
       		 	
       			if( resultData.records[0].rtnSt == "S"){
       				fncRfpList();
       			}
       	    });

       	    dm.on('failure', function(e) {      // 업데이트 실패시
       	    	var resultData = resultDataSet.getReadData(e);
   	   			alert(resultData.records[0].rtnMsg);
       	    });

       	 	if( Rui.isEmpty(dataSet.getNameValue(0, 'rfpId'))  ){
       	    	Rui.alert("삭제할 데이터가 없습니다.");
       	    	return;
       	    }
       	    
	        if(confirm("삭제하시겠습니까?")) {
	       		dm.updateDataSet({
		             dataSets:[dataSet],
		             url:"<c:url value='/prj/tss/rfp/deleteRfpInfo.do'/>",
		             params : {
		            	rfpId : dataSet.getNameValue(0, 'rfpId')
	   	     	}
		         });
	       	 }
       	});
       	

       	/* [버튼] : 제출하기  */
       	var butSubmit = new Rui.ui.LButton('butSubmit');
       	butSubmit.on('click', function(){
       		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
       		dm.on('success', function(e) {      // 업데이트 성공시
       			var resultData = resultDataSet.getReadData(e);
   	   			Rui.alert(resultData.records[0].rtnMsg);
       		 	
       			if( resultData.records[0].rtnSt == "S"){
       				fncRfpList();
       			}
       	    });

       	    dm.on('failure', function(e) {      // 업데이트 실패시
       	    	var resultData = resultDataSet.getReadData(e);
   	   			Rui.alert(resultData.records[0].rtnMsg);
       	    });
       	    
       	 	if( Rui.isEmpty(dataSet.getNameValue(0, 'rfpId'))  ){
	        	Rui.alert("제출 건이 존재하지 않습니다.");
	        	return;
	        }else{
	        	if(dataSet.getNameValue(0, 'submitYn') == "Y"){
	        		alert("이미 제출된 요청서입니다.");
	        		return;
	        	}
	        }
       	 	
       	 	if(confirm("요청서를 제출시겠습니까?")) {
	       	 	dm.updateDataSet({
		             dataSets:[dataSet],
		             url:"<c:url value='/prj/tss/rfp/submitRfpInfo.do'/>",
		             params : {
		            	rfpId : dataSet.getNameValue(0, 'rfpId')
	   	     	 }
	         });
       	 		
       	 	}
       	});
		
	    /* [버튼] : 목록  */
       	var butList = new Rui.ui.LButton('butList');
       	butList.on('click', function(){
       		fncRfpList();
       	});
       	
       	fncRfpList = function(){
       		$('#searchForm > input[name=title]').val(encodeURIComponent($('#searchForm > input[name=title]').val()));
	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val())); 
	    	
	    	nwinsActSubmit(searchForm, "<c:url value="/prj/tss/rfp/retrieveRfp.do"/>");
       	} 
       	
	});
</script>
<style>
 .search-toggleBtn {display:none;}
 </style>
</head>

<body>
<form name="searchForm" id="searchForm"  method="post">
 	<input type="hidden" name="title" value="${inputData.title}"/>
	<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/> 
</form>
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
          <span class="hidden">Toggle 버튼</span>
		</a>
		<h2>RFP요청서 등록</h2>
	</div>
	<div class="sub-content">
	
		<div class="LblockButton top mt0">
			<button type="button" id="butSave">저장</button>
			<button type="button" id="butDel">삭제</button>
			<button type="button" id="butSubmit">제출하기</button>
			<button type="button" id="butList">목록</button>
		</div>
		
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="rfpId" name="rfpId" value="<c:out value='${inputData.rfpId}'/>" />
		<table class="table table_txt_right">
			<colgroup>
				<col style="width:15%"/>
				<col style="width:35%"/>
				<col style="width:15%"/>
				<col style="width:35%"/>
			</colgroup>
			<tbody>
				<tr>
					<th>Title<br>(요청 기술명)</th>
					<td colspan="3">
						<input type="text"  id="title" >
					</td>
				</tr>
				<tr>
  					<th >RequestDate</th>
  					<td>
						<input type="text" id="reqDate" />
 					</td>
  					<th>ResearchEngineer</th>
  					<td>
						<input type="text"  id="rsechEngn" >
  					</td>
  				</tr>
  				<tr>
   					<th>Description of Technology</th>
   					<td>
   						<textarea id="descTclg"></textarea>
   					</td>
   					<th>Expected Applications<br/>(예상적용분야)</th>
   					<td>
   						<textarea id="exptAppl"></textarea>
   					</td>
   				</tr>
   				<tr>
  					<th>Main Request<br/>(목표 스펙,<br/>이슈)</th>
  					<td>
   						<textarea id="mainReq"></textarea>
  					</td>
  					<th>Bench Marking Technology<br/>(State of the Art)<br/>(최신 기술 현황)</th>
  					<td>
   						<textarea id="benchMarkTclg"></textarea>
  					</td>
  				</tr>
  				<tr>
   					<th>Collaboration Type<br/>(협력방법)</th>
   					<td>
   						<!-- <div id="colaboTclg"></div> -->
   						<input type="checkbox"  name= "colaboTclg"  value = "JR" > Joint development / R&D outsourcing<BR/>
   						<input type="checkbox"  name= "colaboTclg"  value = "CS" > Component sourcing<BR/>
   						<input type="checkbox"  name= "colaboTclg"  value = "IO" > In- / out licensing<BR/>
   						<input type="checkbox"  name= "colaboTclg"  value = "SS" > Search for specialist / recruiting<BR/>
   						<input type="checkbox"  name= "colaboTclg"  value = "MA" > Meeting arrangement<BR/>
   						<input type="checkbox"  name= "colaboTclg"  value = "BT" > Benchmarking / technology evaluation<BR/> 
   					</td>
   					<th>Timeline(일정)</th>
   					<td>
   						<textarea id="timeline"></textarea>
   					</td>
   				</tr>
   				<tr>
   					<th>Comments</th>
   					<td>
   						<textarea id="comments"></textarea>
   					</td>
   					<th>Company Name<br/>(Optional)</th>
   					<td>
   						<textarea id="companyNm"></textarea>
   					</td>
   				</tr>
   				<tr>
   					<th>Output Image & Project Description </th>
   					<td colspan="3">
   						<textarea id="pjtImgView" name="pjtImgView"></textarea>
   						<script type="text/javascript" language="javascript">
							var CrossEditor = new NamoSE('pjtImgView');
							CrossEditor.params.Width = "100%";
							CrossEditor.params.UserLang = "auto";
							
							var uploadPath = "<%=uploadPath%>"; 
							
							CrossEditor.params.ImageSavePath = uploadPath+"/prj";
							CrossEditor.params.FullScreen = false;
							
							CrossEditor.EditorStart();
							
							function OnInitCompleted(e){
								e.editorTarget.SetBodyValue(document.getElementById("pjtImgView").value);
							}
						</script>
   					</td>
   				</tr>
			</tbody>	
		</table>
	</form>
	</div>
</div>
</body>
</html>