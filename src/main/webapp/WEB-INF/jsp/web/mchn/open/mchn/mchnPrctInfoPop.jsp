<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: mchnInfoSavePop.jsp
 * @desc    : 분석기기 > open기기 > 보유기기 > 보유기기 신규및 수정팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.25     IRIS05		최초생성
 * 1.1  2019.06.04   IRIS05        renewal   
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<style>
	div.L-combo-list-wrapper-nobg {max-height: 150px;}
</style>

<script type="text/javascript">
var mchnPrctInfoDialog;
var chkCcs;
var mailTitl ="보유기기 예약신청";
var mchnPrctId;

	Rui.onReady(function(){
		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		
		mchnPrctId = '${inputData.mchnPrctId}';
		
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
	    var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        fields: [
            		  { id: 'prctTitl'}
		           	 ,{ id: 'mchnHanNm'}
		           	 ,{ id: 'mchnEnNm'}
		           	 ,{ id: 'rgstNm'}
		           	 ,{ id: 'rgstId'}
		           	 ,{ id: 'teamNm'}
		           	 ,{ id: 'smpoNm'}
		           	 ,{ id: 'smpoQty'}
		           	 ,{ id: 'prctDt'}
		           	 ,{ id: 'prctFromTim'}
		           	 ,{ id: 'prctToTim'}
		           	 ,{ id: 'prctFromHH'}
		           	 ,{ id: 'prctFrommm'}
		           	 ,{ id: 'prctToHH'}
		           	 ,{ id: 'prctTomm'}
		           	// ,{ id: 'rgstDt'}
		           	 ,{ id: 'ccsDt'}
		           	 ,{ id: 'eduStNm'}
		           	 ,{ id: 'eduStCd'}
		           	 ,{ id: 'dtlSbc'}
		           	 ,{ id: 'eduStCd'}
		           	 ,{ id: 'userSabun'}
		           	 ,{ id: 'crgrMail'}
		           	 ,{ id: 'crgrNm'}
		           	 ,{ id: 'mchnPrctId'}
		           	 ,{ id: 'mchnUfe'}
		           	 ,{ id: 'prctScnNm'}
		           	 ,{ id: 'prctScnCd'}
		           	 ,{ id: 'mchnUfeClCd'}
		           	 ,{ id: 'mchnInfoId'}
		            ]
	    });
		
	    dataSet.on('load', function(e){
	    	var eduStnmHtml = "";

	    	if(Rui.isEmpty( mchnPrctId )){
	    		var tmpDt = '${inputData.year}'+"-"+pad('${inputData.mm}')+"-"+pad('${inputData.day}');

	    		dataSet.setNameValue(0, 'prctDt', tmpDt);
	    		dataSet.setNameValue(0, 'prctFromHH' , "00");
	    		dataSet.setNameValue(0, 'prctFrommm' , "00");
	    		dataSet.setNameValue(0, 'prctToHH' , "00");
	    		dataSet.setNameValue(0, 'prctTomm' , "00");
	    		dataSet.setNameValue(0, 'rgstId' , '${inputData._userSabun}');
	    		dataSet.setNameValue(0, 'rgstNm' , '${inputData._userNm}');
	    		dataSet.setNameValue(0, 'teamNm' , '${inputData._userDeptName}');
	    	}
	    	
	    	chkCcs = dataSet.getNameValue(0, "eduStCd");
    		
	    	if ( !Rui.isEmpty( chkCcs  )   ){
	    		if(chkCcs == "RQ" ){
					eduStnmHtml =  dataSet.getNameValue(0, 'eduStNm');
				}else if(chkCcs == "CCS"   ){
					eduStnmHtml =  dataSet.getNameValue(0, 'eduStNm')+ "( 수료일 : "+dataSet.getNameValue(0, 'ccsDt')+" )";
				}else if(chkCcs == "NCPE"   ){
					eduStnmHtml =  dataSet.getNameValue(0, 'eduStNm')+ "( 미수료일 : "+dataSet.getNameValue(0, 'ccsDt')+" )";
				}
	    	}
    		
    		Rui.get("eduStNm").html(eduStnmHtml);
	    	
    		btnEvent(dataSet.getNameValue(0, 'prctScnCd'));
    		
	    	if( dataSet.getNameValue(0, 'rgstId') != '${inputData._userSabun}'){
	    		butdel.hide();
	    	}
	    	
	    	CrossEditor.SetBodyValue( dataSet.getNameValue(0, "dtlSbc") );
	    });
	    
	  //신청명 
		var prctTitl = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'prctTitl',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		//시료명 
		var smpoNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'smpoNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		//시료수
		var smpoQty = new Rui.ui.form.LNumberBox({            // LTextBox개체를 선언
	        applyTo: 'smpoQty',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		//예약일
		var prctDt = new Rui.ui.form.LDateBox({
             applyTo: 'prctDt',
             mask: '9999-99-99',
             displayValue: '%Y-%m-%d',
             dateType: 'string'
        });

		//예약시작일시
		var prctFromHH = new Rui.ui.form.LCombo({
		 	applyTo : 'prctFromHH',
		 	dateType: 'string',
			listPosition: 'up',
		    emptyText: ''
		});
		//예약시작일시분
		var prctFrommm = new Rui.ui.form.LCombo({
		 	applyTo : 'prctFrommm',
		 	dateType: 'string',
			listPosition: 'up',
		    emptyText: ''
		});
		//예약시작일시
		var prctToHH = new Rui.ui.form.LCombo({
		 	applyTo : 'prctToHH',
		 	dateType: 'string',
			listPosition: 'up',
		    emptyText: ''
		});
		//예약시작일시분
		var prctTomm = new Rui.ui.form.LCombo({
		 	applyTo : 'prctTomm',
		 	dateType: 'string',
			listPosition: 'up',
		    emptyText: ''
		});
		
		fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/mchn/open/mchn/retrieveMchnPrctInfo.do"/>',
				params :{
					 mchnPrctId  : mchnPrctId	//기기예약번호
					,mchnInfoId  : '${inputData.mchnInfoId}'	//기기번호
	                }
			});
		}

		fnSearch();
		
		var btnEvent = function(cd){
			if( cd == "APPR"){
	    		butSave.hide();
	    	    
	    		$("input:text").attr("disabled", "true");
           		$("select").attr("disabled", "true");
           		//$("textarea").attr("disabled", "true");
			}
		} 
		
		dm.on('success', function(e) {      // 업데이트 성공시
			var resultData = resultDataSet.getReadData(e);
			
		    alert(resultData.records[0].rtnMsg);
			
			var mchnPId = '${inputData.mchnPrctId}';
			var mchnId = '${inputData.mchnInfoId}';
			
			if( resultData.records[0].rtnSt == "S"){
				parent.fncMchnDtl( mchnPId , mchnId, 'PRCT');
				parent.fncPopCls();
			}
		});
		
		dm.on('failure', function(e) {      // 업데이트 실패시
	    	var resultData = resultDataSet.getReadData(e);
	    	alert(resultData.records[0].rtnMsg);
	    });
		
		/* [버튼] : 보유기기 예약 저장 및 수정 */
    	var butSave = new Rui.ui.LButton('butSave');
    	butSave.on('click', function(){
    		
    		var mchnUfe = dataSet.getNameValue(0, 'mchnUfe');
    		
    		if( dataSet.getNameValue(0, 'mchnUfeClCd') == "SMPO" ){
    			dataSet.setNameValue(0, 'mchnUfe',  mchnUfe * smpoQty.getValue()   ) ;
    		}else{
    			
    			 var frH = parseInt(prctFromHH.getValue());	
    			 var frT = parseInt(prctFrommm.getValue());	
    		  	
    			 var toH = parseInt(prctToHH.getValue());	
    			 var toT = parseInt(prctTomm.getValue());	
    		  	
    			 var frMm = frH *60 + frT;
    			 var toMm = toH *60 + toT;
    			 var totT = toMm - frMm;
    	
    			 var ac = mchnUfe / 60;
    			 
    			 var won = Math.floor(totT * ac /10) *10
    			 
    			 dataSet.setNameValue(0, 'mchnUfe',  won ) ;
    		}
    		
    		if(isValidate("예약신청")){
				if(confirm("예약신청 하시겠습니까?")) {
					dataSet.getNameValue(0, CrossEditor.GetBodyValue());
					
					dm.updateDataSet({
	                    url:'<c:url value='/mchn/open/mchn/saveMchnPrctInfo.do'/>',
	                    dataSets:[dataSet],
	                    modifiedOnly: false,
	                    params : {
	   	        	    	 mailTitl : mailTitl				//mail title
	   	        	    }
	                });
				}
			}
    		
    	});
    	
    	/* [버튼] : 보유기기예약 삭제 */
    	var butdel = new Rui.ui.LButton('butdel');
    	butdel.on('click', function(){
	   		if(Rui.isEmpty(mchnPrctId)){
	   			alert("삭제할 예약건이 없습니다.");
	   			return;
	   		}
    		
			if(confirm("기기예약을 삭제하시겠습니까?")) {
				dm.updateDataSet({
                    url:'<c:url value='/mchn/open/mchn/deleteMchnPrctInfo.do'/>',
                    params : {
	        	    	mchnPrctId : mchnPrctId			//mail title
	        	    }
                });
			}	
    	});
    	
    	//분석기기 예약 팝업창 닫기
		var butCls = new Rui.ui.LButton('butCls');
		butCls.on('click', function(){
			parent.fncPopCls();
        });
    	
		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		          { id: 'prctTitl', 	ctrlId: 'prctTitl', 	value: 'value'}
		         ,{ id: 'mchnHanNm', 	ctrlId: 'mchnHanNm', 	value: 'html' }
		         ,{ id: 'mchnEnNm', 	ctrlId: 'mchnEnNm', 	value: 'html' }
		         ,{ id: 'rgstNm', 		ctrlId: 'rgstNm', 		value: 'html' }
		         ,{ id: 'teamNm', 		ctrlId: 'teamNm', 		value: 'html' }
		         ,{ id: 'smpoNm', 		ctrlId: 'smpoNm', 		value: 'value'}
		         ,{ id: 'smpoQty', 		ctrlId: 'smpoQty', 		value: 'value'}
		         ,{ id: 'prctDt', 		ctrlId: 'prctDt', 		value: 'value'}
		         ,{ id: 'prctFromTim', 	ctrlId: 'prctFromTim', 	value: 'value'}
		         ,{ id: 'prctToTim', 	ctrlId: 'prctToTim', 	value: 'value'}
		         ,{ id: 'prctFromHH', 	ctrlId: 'prctFromHH', 	value: 'value'}
		         ,{ id: 'prctFrommm', 	ctrlId: 'prctFrommm', 	value: 'value'}
		         ,{ id: 'prctToHH', 	ctrlId: 'prctToHH', 	value: 'value'}
		         ,{ id: 'prctTomm', 	ctrlId: 'prctTomm',		value: 'value'}
		         ,{ id: 'dtlSbc', 		ctrlId: 'dtlSbc', 		value: 'value'}
		         ,{ id: 'prctScnNm', 	ctrlId: 'prctScnNm', 	value: 'html' }
		        // ,{ id: 'ccsDt', 		ctrlId: 'ccsDt', 		value: 'html' }
		        // ,{ id: 'rgstDt', 		ctrlId: 'rgstDt', 		value: 'value'}
		        // ,{ id: 'eduStNm', 		ctrlId: 'eduStNm', 		value: 'html' }
		        // ,{ id: 'mchnUfe', 		ctrlId: 'mchnUfe', 		value: 'value'}
		        // ,{ id: 'mchnUfeClCd', 	ctrlId: 'mchnUfeClCd', 	value: 'value'}
		     ]
		});
		
		var vm = new Rui.validate.LValidatorManager({
            validators:[
             { id: 'prctTitl',		validExp: '신청제목:true'}
            ,{ id: 'smpoNm',		validExp: '시료명:true' }
            ,{ id: 'smpoQty',		validExp: '시료수:true' }
            ,{ id: 'prctDt',		validExp: '예약일:true' }
            ,{ id: 'prctFromHH',	validExp: '시작시간:true'}
            ,{ id: 'prctFrommm',	validExp: '시작 분:true' }
            ,{ id: 'prctToHH',		validExp: '종료시간:true'}
            ,{ id: 'prctTomm',		validExp: '종료분:true' }
            ]
        });
		
		isValidate = function(type) {
            if (vm.validateGroup("aform") == false) {
                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                return false;
            }
        /*     운영반영시 주석제거
            if( chkCcs != "CCS" ){
				alert("교육수료후에 예약이 가능합니다.");
    			return false;
			}
          */   
            if( Rui.isEmpty(dataSet.getNameValue(0, 'mchnInfoId'))  ){
            	alert("기기정보가 없습니다. 관리자에게 문의해주세요");
            	return false;
            }

            var frt = Number(prctFromHH.getValue()+prctFrommm.getValue());
			var tot = Number(prctToHH.getValue()+prctTomm.getValue());
			
			if(frt >  tot ){
				alert("예약종료시간이 시작시간보다 작을 수 없습니다.")
				return false;
			}
			
			dataSet.setNameValue(0, 'prctFromTim', prctFromHH.getValue()+":"+prctFrommm.getValue()    );
			dataSet.setNameValue(0, 'prctToTim',   prctToHH.getValue()+":"+prctTomm.getValue()  );
			dataSet.setNameValue(0, 'dtlSbc',  CrossEditor.GetBodyValue() );
			/* 
			// 에디터 valid
			if( dataSet.getNameValue(0, 'dtlSbc') == "<p><br></p>" || dataSet.getNameValue(0, 'dtlSbc') == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert('내용을 입력하여 주십시요.');
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}
             */
            return true;
	    }
		
	});	
	
</script>
</head>
<body>
<div class="bd">
		<div class="sub-content" style="padding-top:0;">
			<form name="aform" id="aform" method="post">
			<%-- 	<input type="hidden" id="menuType" name="menuType" /> --%>
				<div class="titArea mt0">
					<span class="table_summay_number">교육 수료시 예약신청이 가능합니다.</span>
					<div class="LblockButton">
						<button type="button" id="butSave">저장</button>
						<button type="button" id="butdel">삭제</button>
						<button type="button" id="butCls">닫기</button>
					</div>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>신청제목</th>
							<td colspan="3">
								<input type="text" id="prctTitl" />
							</td>
						</tr>
						<tr>
							<th align="right">기기명</th>
							<td>
								<span id="mchnHanNm"></span>(<span id="mchnEnNm"></span>)
							</td>
							<th align="right">신청자(팀)</th>
							<td>
								<span id="rgstNm"></span>(<span id="teamNm"></span>)
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>시료명</th>
							<td>
								<input type="text" id="smpoNm" />
							</td>
							<th align="right"><span style="color:red;">*  </span>시료수</th>
							<td>
								<input type="text" id="smpoQty" />
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>예약일시</th>
							<td colspan="3">
								<input type="text" id="prctDt" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<select id="prctFromHH">
									<option value="00">00</option>
   									<option value="01">01</option>
   									<option value="02">02</option>
   									<option value="03">03</option>
   									<option value="04">04</option>
   									<option value="05">05</option>
   									<option value="06">06</option>
   									<option value="07">07</option>
   									<option value="08">08</option>
   									<option value="09">09</option>
   									<option value="10">10</option>
   									<option value="11">11</option>
   									<option value="12">12</option>
   									<option value="13">13</option>
   									<option value="14">14</option>
   									<option value="15">15</option>
   									<option value="16">16</option>
   									<option value="17">17</option>
   									<option value="18">18</option>
   									<option value="19">19</option>
   									<option value="20">20</option>
   									<option value="21">21</option>
   									<option value="22">22</option>
   									<option value="23">23</option>
								</select> :
								<select id="prctFrommm">
									<option value="00">00</option>
   									<option value="30">30</option>
								</select>
								<select id="prctToHH">
									<option value="00">00</option>
   									<option value="01">01</option>
   									<option value="02">02</option>
   									<option value="03">03</option>
   									<option value="04">04</option>
   									<option value="05">05</option>
   									<option value="06">06</option>
   									<option value="07">07</option>
   									<option value="08">08</option>
   									<option value="09">09</option>
   									<option value="10">10</option>
   									<option value="11">11</option>
   									<option value="12">12</option>
   									<option value="13">13</option>
   									<option value="14">14</option>
   									<option value="15">15</option>
   									<option value="16">16</option>
   									<option value="17">17</option>
   									<option value="18">18</option>
   									<option value="19">19</option>
   									<option value="20">20</option>
   									<option value="21">21</option>
   									<option value="22">22</option>
   									<option value="23">23</option>
								</select> :
								<select id="prctTomm">
									<option value="00">00</option>
   									<option value="30">30</option>
								</select>
							</td>
						</tr>
						<tr>
							<th align="right">교육여부</th>
							<td >
								<span id="eduStNm">
							</td>
							<th align="right">승인상태</th>
							<td >
								<span id="prctScnNm">
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<textarea id="dtlSbc" name="dtlSbc"></textarea>
   								 <script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('dtlSbc');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										CrossEditor.params.Font = fontParam;
										
										var uploadPath = "<%=uploadPath%>"; 
										
										CrossEditor.params.ImageSavePath = uploadPath+"/mchn";
										CrossEditor.params.FullScreen = false;
										
										CrossEditor.EditorStart();
										
										function OnInitCompleted(e){
											e.editorTarget.SetBodyValue(document.getElementById("dtlSbc").value);
										}
									</script>
							</td>
						</tr>
						
						</tbody>
				</table>
			</form>
		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>