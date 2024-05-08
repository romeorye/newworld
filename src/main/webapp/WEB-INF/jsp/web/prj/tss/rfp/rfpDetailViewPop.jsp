<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: rfpDetailViewPop.jsp
 * @desc    : RFP 요청서>  RFP 요청서 View
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
        /*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
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
		 	if(!Rui.isEmpty(dataSet.getNameValue(0, 'rfpId'))){
       			var splitCode =dataSet.getNameValue(0, 'colaboTclg').split(",");		
       		
       			for (var idx in splitCode) {
       				if( Rui.isEmpty(splitCode[idx])  ) return;
       				$("input[name=colaboTclg][value="+splitCode[idx]+"]").attr("checked", true);
   			  	}
       	 	} 
        });
		
  	  	//Description of Technology(기술 설명)
	    var descTclg = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'descTclg',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        disabled: true,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	        
	    });
	  	
	    //Expected Applications(예상적용분야)
	    var exptAppl = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'exptAppl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        disabled: true,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	    });

	    //Main Request(목표 스펙, 이슈)
	    var mainReq = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'mainReq',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        disabled: true,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	    });
	    
	    //Bench Marking  Technology(State of the Art)(최신 기술 현황)
	    var benchMarkTclg = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'benchMarkTclg',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        disabled: true,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	    });
	  	
	    //Timeline(일정)
	    var timeline = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'timeline',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        disabled: true,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	    });
	  	
	    //comments
	    var comments = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'comments',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        disabled: true,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	    
	    //Company Name (Optional)
	    var companyNm = new Rui.ui.form.LTextArea({            // LTextBox개체를 선언
	        applyTo: 'companyNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                    // 텍스트박스 폭을 설정
	        height: 100,
	        disabled: true,
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	    
	    fnSearch = function() {
	 	 	dataSet.load({
	 	    		url: '<c:url value="/prj/tss/rfp/retrieveRfpInfo.do"/>',
	 	            params :{
	 	            		rfpId:'${inputData.rfpId}'
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
	        	 {id : 'descTclg', 		ctrlId : 'descTclg',  		value : 'html'}
	        	,{id : 'exptAppl', 		ctrlId : 'exptAppl',  		value : 'html'}
	        	,{id : 'mainReq', 		ctrlId : 'mainReq',  		value : 'html'}
	        	,{id : 'benchMarkTclg', ctrlId : 'benchMarkTclg',  	value : 'html'}
	        	,{id : 'timeline', 		ctrlId : 'timeline',  		value : 'html'}
	        	,{id : 'comments', 		ctrlId : 'comments',  		value : 'html'}
	        	,{id : 'companyNm', 	ctrlId : 'companyNm',  		value : 'html'}
	        ]
	    }); 
	   
	});
</script>
</head>

<body>

<div class="bd">
	<div class="sub-content">
	<form name="aform" id="aform" method="post">
		<table class="table table_txt_right">
			<colgroup>
				<col style="width:15%"/>
				<col style="width:35%"/>
				<col style="width:15%"/>
				<col style="width:35%"/>
			</colgroup>
			<tbody>
				<tr>
					<th>Title(요청 기술명)</th>
					<td colspan="3">
						<c:out value='${result.title}'/>
					</td>
				</tr>
				<tr>
  					<th >RequestDate</th>
  					<td>
						<c:out value='${result.reqDate}'/>
 					</td>
  					<th>ResearchEngineer</th>
  					<td>
  						<c:out value='${result.rsechEngn}'/>
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
  					<th>Main Request<br/>(목표 스펙, 이슈)</th>
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
   						<c:out value='${result.pjtImgView}' escapeXml="false"/>
   					</td>
   				</tr>
			</tbody>	
		</table>
	</form>
	</div>
</div>
</body>
</html>
	


