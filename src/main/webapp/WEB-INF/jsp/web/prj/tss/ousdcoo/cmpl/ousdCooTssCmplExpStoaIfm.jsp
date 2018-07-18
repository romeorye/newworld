<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssCmplExpStoaIfm.jsp
 * @desc    : 대외협력과제 > 완료 비용지급실적 탭 화면
              완료 및 완료 후에도 변경가능처리
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.10.29  IRIS04		최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">
	var lvTssCd  = window.parent.cmplTssCd;     //완료 과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd = window.parent.gvPgsStepCd;    //진행코드
    var lvTssSt = window.parent.gvTssSt;        //과제상태
    var lvPageMode = window.parent.gvPageMode;

    var pageMode = "W";							// 완료페이지는 항상 변경가능
//    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" && lvPgsCd == "AL" ? "W" : "R";	
    
    var dataSet;
    var lvPurY;
    var isSearch2 = false; 
    
    var lvRsstExp = 0;							//연구비(원)
    var lvRsstExpConvertMil = 0;				//연구비(억원)
    var lvRsstExpCash = 0;						//연구비(원)
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        
      	//1차현금 지급일
		var ldbYyNosDt1 = new Rui.ui.form.LDateBox({
            applyTo: 'inputYyNosDt1',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
		//2차현금 지급일
		var ldbYyNosDt2 = new Rui.ui.form.LDateBox({
            applyTo: 'inputYyNosDt2',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
		//3차현금 지급일
		var ldbYyNosDt3 = new Rui.ui.form.LDateBox({
            applyTo: 'inputYyNosDt3',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
		//4차현금 지급일
		var ldbYyNosDt4 = new Rui.ui.form.LDateBox({
            applyTo: 'inputYyNosDt4',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });

		//1차현금
	  	var lnbYyNosCash1 = new Rui.ui.form.LNumberBox({
	        applyTo: 'inputYyNosCash1',
	        width  : 100,    
	        maxValue: 999999999999999,
	        minValue: 0,
	        thousandsSeparator: ','
	    });
	    //2차현금
	  	var lnbYyNosCash2 = new Rui.ui.form.LNumberBox({
	        applyTo: 'inputYyNosCash2',
	        width  : 100,    
	        maxValue: 999999999999999,
	        minValue: 0,
	        thousandsSeparator: ','
	    });
		//3차현금
	  	var lnbYyNosCash3 = new Rui.ui.form.LNumberBox({
	        applyTo: 'inputYyNosCash3',
	        width  : 100,    
	        maxValue: 999999999999999,
	        minValue: 0,
	        thousandsSeparator: ','
	    });
		//4차현금
	  	var lnbYyNosCash4 = new Rui.ui.form.LNumberBox({
	        applyTo: 'inputYyNosCash4',
	        width  : 100,    
	        maxValue: 999999999999999,
	        minValue: 0,
	        thousandsSeparator: ','
	    });
        
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
            
           	// datebox hide
           	ldbYyNosDt1.hide();
           	ldbYyNosDt2.hide();
           	ldbYyNosDt3.hide();
           	ldbYyNosDt4.hide();
           	// inputbox hide
           	lnbYyNosCash1.hide();
           	lnbYyNosCash2.hide();
           	lnbYyNosCash3.hide();
           	lnbYyNosCash4.hide();
           	// save btn hide
           	btnSave.hide();
           	
           	// span show
           	Rui.get('spnYyNosDt1').setStyle('display', '');
           	Rui.get('spnYyNosDt2').setStyle('display', '');
           	Rui.get('spnYyNosDt3').setStyle('display', '');
           	Rui.get('spnYyNosDt4').setStyle('display', '');
           	Rui.get('spnYyNosCash1').setStyle('display', '');
           	Rui.get('spnYyNosCash2').setStyle('display', '');
           	Rui.get('spnYyNosCash3').setStyle('display', '');
           	Rui.get('spnYyNosCash4').setStyle('display', '');
        };

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 월별
        dataSet = new Rui.data.LJsonDataSet({
            id: 'expStoaDataSet',
            fields: [
            	{ id: 'tssCd' }            
              , { id: 'ttlCash', defaultValue: 0 }	  /*총액*/
              , { id: 'yyNosCash1' }  /*1차현금*/
              , { id: 'yyNosDt1' }	  /*1차지급일자*/
              , { id: 'yyNosCash2' }  /*2차현금*/
              , { id: 'yyNosDt2' }	  /*2차지급일자*/
              , { id: 'yyNosCash3' }  /*3차현금*/
              , { id: 'yyNosDt3' }	  /*3차지급일자*/
              , { id: 'yyNosCash4' }  /*4차현금*/
              , { id: 'yyNosDt4' }	  /*4차지급일자*/
              , { id: 'rsstExp' }                              /*연구비(원)*/
              , { id: 'rsstExpConvertMil', defaultValue: 0 }   /*연구비(억원)*/
              , { id: 'remainCash'       , defaultValue: 0 }   /*잔액*/
              , { id: 'userId'}
              , { id: 'pgYyNosCash1Yn', defaultValue: 'N' }    /*진행 1차현금입력여부*/ 
 			  , { id: 'pgYyNosCash2Yn', defaultValue: 'N' }    /*진행 2차현금입력여부*/ 
 			  , { id: 'pgYyNosCash3Yn', defaultValue: 'N' }    /*진행 3차현금입력여부*/ 
 			  , { id: 'pgYyNosCash4Yn', defaultValue: 'N' }    /*진행 4차현금입력여부*/ 
            ]
        });
        dataSet.on('load', function(e) {
        	if( dataSet.getCount() > 0 ){
	        	// 진행상태의 입력데이터는 변경불가
	        	
	        	// 모두 입력된 상태이면 저장버튼 hide
	        	if( dataSet.getNameValue(0,"pgYyNosCash1Yn") == "Y" && dataSet.getNameValue(0,"pgYyNosCash2Yn") == "Y" &&
	        		dataSet.getNameValue(0,"pgYyNosCash3Yn") == "Y"	&& dataSet.getNameValue(0,"pgYyNosCash4Yn") == "Y" ){
	        		// save btn hide	
	        		btnSave.hide();
	        	}
	        	if( dataSet.getNameValue(0,"pgYyNosCash1Yn") == "Y" ){
	        		ldbYyNosDt1.hide();
	        		lnbYyNosCash1.hide();
	        		Rui.get('spnYyNosDt1').setStyle('display', '');
	        		Rui.get('spnYyNosCash1').setStyle('display', '');
	        	}
	        	if( dataSet.getNameValue(0,"pgYyNosCash2Yn") == "Y" ){
	        		ldbYyNosDt2.hide();
	        		lnbYyNosCash2.hide();
	        		Rui.get('spnYyNosDt2').setStyle('display', '');
	        		Rui.get('spnYyNosCash2').setStyle('display', '');
	        	}
	        	if( dataSet.getNameValue(0,"pgYyNosCash3Yn") == "Y" ){
	        		ldbYyNosDt3.hide();
	        		lnbYyNosCash3.hide();
	        		Rui.get('spnYyNosDt3').setStyle('display', '');
	        		Rui.get('spnYyNosCash3').setStyle('display', '');
	        	}
	        	if( dataSet.getNameValue(0,"pgYyNosCash4Yn") == "Y" ){
	        		ldbYyNosDt4.hide();
	        		lnbYyNosCash4.hide();
	        		Rui.get('spnYyNosDt4').setStyle('display', '');
	        		Rui.get('spnYyNosCash4').setStyle('display', '');
	        	}
        	}
        });
        dataSet.on('update', function(e) {
        	  // 금액 변경시 잔액 및 합계 다시 계산
        	  if( e.colId == 'yyNosCash1' || e.colId == 'yyNosCash2' || e.colId == 'yyNosCash3' || e.colId == 'yyNosCash4') {
        	        var record = e.record;
        	        var newTtlCash =  numberNullChk(record.get('yyNosCash1')) + numberNullChk(record.get('yyNosCash2')) + numberNullChk(record.get('yyNosCash3')) + numberNullChk(record.get('yyNosCash4'));
        	        var newRemainCash = numberNullChk(record.get('rsstExp')) - newTtlCash;
        	        
         	        if(newRemainCash < 0){
        	        	Rui.alert('잔액을 초과합니다.');
        	        	dataSet.setNameValue(e.row, e.colId , e.beforeValue);
        	        	return false;
        	        } 
        	        
        	        dataSet.setNameValue(e.row,'ttlCash'     , newTtlCash);
        	        dataSet.setNameValue(e.row,'remainCash'  , newRemainCash);
        	        
        	        Rui.get('ttlCash').html( Rui.util.LFormat.numberFormat(parseInt(newTtlCash)) );
        	        Rui.get('remainCash').html( Rui.util.LFormat.numberFormat(parseInt(newRemainCash)) );
        	        bind.rebind();
        	  }
        });
        
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'expStoaFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
            	  { id: 'tssCd' ,              ctrlId: 'tssCd',              value: 'value'}            
                , { id: 'ttlCash' ,            ctrlId: 'ttlCash',            value: 'html'
                	  , renderer: function(value){	return Rui.util.LFormat.numberFormat(parseInt(value)); }
                  }  /*현금합계 총액*/
                , { id: 'yyNosCash1',          ctrlId: 'inputYyNosCash1',      value: 'value' }     /*1차현금*/
                , { id: 'yyNosDt1',            ctrlId: 'inputYyNosDt1',        value: 'value' }	    /*1차지급일자*/
                , { id: 'yyNosCash2',          ctrlId: 'inputYyNosCash2',      value: 'value' }     /*2차현금*/
                , { id: 'yyNosDt2',            ctrlId: 'inputYyNosDt2',        value: 'value' }	    /*2차지급일자*/
                , { id: 'yyNosCash3',          ctrlId: 'inputYyNosCash3',      value: 'value' }     /*3차현금*/
                , { id: 'yyNosDt3',            ctrlId: 'inputYyNosDt3',        value: 'value' }	    /*3차지급일자*/
                , { id: 'yyNosCash4',          ctrlId: 'inputYyNosCash4',      value: 'value' }     /*4차현금*/
                , { id: 'yyNosDt4',             ctrlId: 'inputYyNosDt4',        value: 'value' }	/*4차지급일자*/
                , { id: 'rsstExp',             ctrlId: 'rsstExp',              value: 'html' 
                	, renderer: function(value){	return Rui.util.LFormat.numberFormat(parseInt(value)); }
                  }      /*연구비(원)*/
//                , { id: 'rsstExpConvertMil',   ctrlId: 'rsstExpConvertMil',    value: 'html' }     /*연구비(억원)*/
                , { id: 'remainCash',          ctrlId: 'remainCash',           value: 'html' 
                	  , renderer: function(value){	return Rui.util.LFormat.numberFormat(parseInt(value)); }
                  }      /*잔액*/
                /* read 표시 데이터 바인드*/
                , { id: 'yyNosDt1',            ctrlId: 'spnYyNosDt1',        value: 'html' }	  /*1차지급일자*/
                , { id: 'yyNosDt2',            ctrlId: 'spnYyNosDt2',        value: 'html' }	  /*2차지급일자*/
                , { id: 'yyNosDt3',            ctrlId: 'spnYyNosDt3',        value: 'html' }	  /*3차지급일자*/
                , { id: 'yyNosDt4',            ctrlId: 'spnYyNosDt4',        value: 'html' }	  /*4차지급일자*/
                , { id: 'yyNosCash1',          ctrlId: 'spnYyNosCash1',      value: 'html'
                	, renderer: function(value){	if(stringNullChk(value) != ""){ return Rui.util.LFormat.numberFormat(parseInt(value)); }else{ return value; } }}     /*1차현금*/
                , { id: 'yyNosCash2',          ctrlId: 'spnYyNosCash2',      value: 'html'
                	, renderer: function(value){	if(stringNullChk(value) != ""){return Rui.util.LFormat.numberFormat(parseInt(value)); }else{ return value; } }}     /*2차현금*/
                , { id: 'yyNosCash3',          ctrlId: 'spnYyNosCash3',      value: 'html'
                	, renderer: function(value){	if(stringNullChk(value) != ""){return Rui.util.LFormat.numberFormat(parseInt(value)); }else{ return value; } }}     /*3차현금*/
                , { id: 'yyNosCash4',          ctrlId: 'spnYyNosCash4',      value: 'html'
                	, renderer: function(value){	if(stringNullChk(value) != ""){return Rui.util.LFormat.numberFormat(parseInt(value)); }else{ return value; } }}     /*4차현금*/
            ]
        });

      //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            Rui.alert(data.records[0].rtVal);
            
            if(data.records[0].rtCd == "SUCCESS") {
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet1.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });
        
        //유효성 설정
         var vm = new Rui.validate.LValidatorManager({
            validators: [  
//                  { id: 'tssNm',       validExp: '일정명:true' }
//                 , { id: 'strtDt',   validExp: '과제기간 시작일:true' }
//                 , { id: 'fnhDt',  validExp: '과제기간  종료일:true' }
//                 , { id: 'saSabunNew',   validExp: '담당연구원:true' }
            ]
        });

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
       /*  //목록 
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
        }); */
      	//저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            fnSave();
        });
        
        // valid
        fnValid = function(vm, form){
        	// 1. 기본
/*         	if( vm.validateGroup(form) ) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return true;
			}
        	 */
        	//2. 날짜,금액 체크
        	if( (lnbYyNosCash1.getValue() != "" &&  lnbYyNosCash1.getValue() != null) && 
        		(ldbYyNosDt1.getValue() == "" || ldbYyNosDt1.getValue() == null)      ){
        		Rui.alert("1차 지급일을 입력하세요");
                return true;
        	}
        	if( (lnbYyNosCash2.getValue() != "" &&  lnbYyNosCash2.getValue() != null) && 
            	(ldbYyNosDt2.getValue() == "" || ldbYyNosDt2.getValue() == null)      ){
            	Rui.alert("2차 지급일을 입력하세요");
                return true;
            }
        	if( (lnbYyNosCash3.getValue() != "" &&  lnbYyNosCash3.getValue() != null) && 
               	(ldbYyNosDt3.getValue() == "" || ldbYyNosDt3.getValue() == null)      ){
               	Rui.alert("3차 지급일을 입력하세요");
				return true;
			}
        	if( (lnbYyNosCash4.getValue() != "" &&  lnbYyNosCash4.getValue() != null) && 
                (ldbYyNosDt4.getValue() == "" || ldbYyNosDt4.getValue() == null)      ){
                Rui.alert("4차 지급일을 입력하세요");
    			return true;
    		}
        	
        	return false;
        };
        
        //저장
        fnSave = function() {
        	// valid check
            if( fnValid(vm,"expStoaForm") ) {
	            return;
			}

            if(!dataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }
            
            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {

                    //신규
                    if( stringNullChk(dataSet.getAt(0).get("tssCd")) == "") {
                    	dataSet.setNameValue(0,'tssCd'   , lvTssCd );
                    	dataSet.setNameValue(0,'userId'  , lvUserId );
                    	
                        dm.updateDataSet({
                            modifiedOnly: false,
                            url:'<c:url value="/prj/tss/ousdcoo/insertOusdCooTssCmplExpStoa.do"/>',
                            dataSets:[dataSet]
                        });
                    }
                    //수정
                    else {
                    	dataSet.setNameValue(0,'userId'  , lvUserId );
                        dm.updateDataSet({
                            modifiedOnly: false,
                            url:'<c:url value="/prj/tss/ousdcoo/updateOusdCooTssCmplExpStoa.do"/>',
                            dataSets:[dataSet]
                        });
                    }
                },
                handlerNo: Rui.emptyFn
            });
        };
        
        //데이터 셋팅
        if(${resultCnt} > 0) {
        	lvRsstExp = numberNullChk('<c:out value="${inputData.rsstExp}"/>');
//        	lvRsstExpConvertMil = numberNullChk('<c:out value="${inputData.rsstExpConvertMil}"/>');
        	dataSet.loadData(${result}); 
        } else {
        	lvRsstExp = '<c:out value="${inputData.rsstExp}"/>';
//        	lvRsstExpConvertMil = '<c:out value="${inputData.rsstExpConvertMil}"/>';

            dataSet.newRecord();
            dataSet.setNameValue(0,'ttlCash'           , '0' );					                // 지급금액 총합
            dataSet.setNameValue(0,'rsstExp'           , numberNullChk(lvRsstExp) );		    // 지원금(원)
//            dataSet.setNameValue(0,'rsstExpConvertMil' , parseFloat(lvRsstExpConvertMil) );	// 지원금(억원)
            dataSet.setNameValue(0,'remainCash'        , numberNullChk(lvRsstExp) );	        // 잔액(원)
            
        }
        
        // 화면처리
        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
		}
    });
    
    // 내부 스크롤 제거
    $(window).load(function() {
        initFrameSetHeight();
    });
</script>
</head>
<body>

<div id="expStoaFormDiv">
	<div class="titArea"></div><!-- 공백용 -->

    <form name="expStoaForm" id="expStoaForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        
        <table class="table table_txt_center">
            <colgroup>
                <col style="width: 10%;" />
                <col style="width: 10%;" />
                <col style="width: 15%;" />
                <col style="width: 15%;" />
                <col style="width: 15%;" />
                <col style="width: 15%;" />
                <col style="width: 20%;" />
            </colgroup>
            <tbody>
            	<tr>
            		<th align="center">총계</th>
            		<th align="center" colspan="6">집행실적</th>
            	</tr>
            	<tr>
            		<th align="center">총연구비(원)</th>
            		<th align="center">계획</th>
            		<th align="center">1차</th>
            		<th align="center">2차</th>
            		<th align="center">3차</th>
            		<th align="center">4차</th>
            		<th align="center">잔액</th>
            	</tr>
            	<tr>
            		<td align="center" rowspan="2" style="text-align: center;" ><span id="rsstExp"></span><!-- <span id="rsstExpConvertMil"></span> 억 --></td>
            		<td align="center" style="text-align: center;" >일시</td>
            		<td align="center" style="text-align: center;" ><input type="text" id="inputYyNosDt1"/><span id="spnYyNosDt1" class="readSpn" style="display: none;"></span></td>
            		<td align="center" style="text-align: center;" ><input type="text" id="inputYyNosDt2"/><span id="spnYyNosDt2" class="readSpn" style="display: none;"></span></td>
            		<td align="center" style="text-align: center;" ><input type="text" id="inputYyNosDt3"/><span id="spnYyNosDt3" class="readSpn" style="display: none;"></span></td>
            		<td align="center" style="text-align: center;" ><input type="text" id="inputYyNosDt4"/><span id="spnYyNosDt4" class="readSpn" style="display: none;"></span></td>
            		<td></th>
            	</tr>
            	<tr>
            		<td align="center" style="text-align: center;" >금액</th>
            		<td align="center" style="text-align: center;" ><input type="text" id="inputYyNosCash1"/><span id="spnYyNosCash1" class="readSpn" style="display: none;"></span></td>
            		<td align="center" style="text-align: center;" ><input type="text" id="inputYyNosCash2"/><span id="spnYyNosCash2" class="readSpn" style="display: none;"></span></td>
            		<td align="center" style="text-align: center;" ><input type="text" id="inputYyNosCash3"/><span id="spnYyNosCash3" class="readSpn" style="display: none;"></span></td>
            		<td align="center" style="text-align: center;" ><input type="text" id="inputYyNosCash4"/><span id="spnYyNosCash4" class="readSpn" style="display: none;"></span></td>
            		<td align="center" style="text-align: center;" ><span id="remainCash"></span></td>
            	</tr>
            	<tr>
            		<td align="center" style="text-align: center;" >누적합계</td>
            		<td align="center" style="text-align: center;" >금액</td>
            		<td align="center" style="text-align: center;" colspan="4"><span id="ttlCash"></span></td>
            		<!-- <td><div id=""/></td>
            		<td><div id=""/></td>
            		<td><div id=""/></td> -->
            		<td></th>
            	</tr>
            </tbody>
        </table>
        
    </form>
</div>
<div class="titArea">
    <div class="LblockButton">
    	<button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>

</body>
</html>