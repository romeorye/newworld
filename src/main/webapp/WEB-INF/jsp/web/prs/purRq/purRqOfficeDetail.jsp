<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purRqDetail.jsp
 * @desc    : 구매요청시스템 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.11.22   김연태		최초생성
 * ---	-----------	----------	-----------------------------------------
 * PRS 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="/iris/rui/plugins/ui/grid/LTotalSummary.js"></script>
<title><%=documentTitle%></title>

<script type="text/javascript">
var lvAttcFilId;
var prjInfoListDialog;	//프로젝트 코드 팝업 dialog
var callback;
var dblClickedRow;
var curRow;

	Rui.onReady(function() {
		var frm = document.aform;
		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		var itemEditable = false;		// item Grid 변경 가능 속성

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
        
        //품목구분
        var sCode = new Rui.ui.form.LCombo({
			applyTo : 'sCode',
			width: 180,
			defaultValue: '<c:out value="${inputData.sCodeSeq}"/>',
			useEmptyText: false,
			url: '<c:url value="/common/prsCode/retrieveItemGubunInfo.do?tabId=${inputData.tabId}"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE',
            autoMapping: true
		});
		
        /*품목구분관련항목*/
        var purRqScodeDataSet = new Rui.data.LJsonDataSet({
            id: 'purRqScodeDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'ekgrp' }	/* 구매그룹 */
            	, { id: 'sakto' }	/* 계정코드 */
            	, { id: 'saktonm' } /* 계정명 */
            	, { id: 'werks' } 	/* 플랜트 */
            	, { id: 'meins' } 	/* 단위 */
            ]
        });
		
		//품목구분이 변경될때 관련항목을 조회하여 변경하여준다(구매그룹, 계정, 계정명) 
		sCode.on('changed', function(e) {
        	var selectedScode = escape(encodeURIComponent(sCode.getValue()));
        	purRqScodeDataSet.load({
                url: '<c:url value="/common/prsCode/retrieveScodeInfo.do"/>',
                params :{
                	sCode : selectedScode
                }
            });
			
       		purRqScodeDataSet.on('load', function(e) {
   				if(purRqScodeDataSet.getCount() > 0 && !itemEditable) {
   					ekgrp.setValue(purRqScodeDataSet.getNameValue(0, 'ekgrp'));
   					werks.setValue(purRqScodeDataSet.getNameValue(0, 'werks'));
   					sakto.setValue(purRqScodeDataSet.getNameValue(0, 'sakto'));
   					saktonm.setValue(purRqScodeDataSet.getNameValue(0, 'saktonm'));
   				} else {
   					sakto.setValue(purRqScodeDataSet.getNameValue(0, 'sakto'));
   					saktonm.setValue(purRqScodeDataSet.getNameValue(0, 'saktonm'));
   					return;
   				};
       		});
		});
		
		/* prject list 팝업 설정*/
        var posid = new Rui.ui.form.LPopupTextBox({
        	applyTo: 'wbsCd',
            placeholder: 'WBS코드를 입력해주세요.',
            defaultValue: '',
            emptyValue: '',
            editable: false,
            width: 90
        });
		
        posid.on('popup', function(e){
        	var deptYn = "N";
        	openWbsCdSearchDialog(setPrsWbsCd, deptYn);
        });
        
		//WBS 코드 팝업 세팅
		function setPrsWbsCd(wbsInfo){
			purRqUserDataSet.setNameValue(0, "wbsCd", wbsInfo.wbsCd);
			$('#wbsCdName', aform).html(wbsInfo.tssNm);
		}
		
		
		//납품요청일
		var eeind = new Rui.ui.form.LDateBox({
			applyTo: 'eeind',
			mask: '9999-99-99',
			displayValue: '%Y-%m-%d',
			defaultValue : '',		// default -1년
			width: 100,
			dateType: 'string'
		});
		
		eeind.on('changed', function(e) {
			var today = Rui.util.LDate.format(new Date(), '%Y-%m-%d');
		    
			if(e.displayValue <= today && e.displayValue != '') {
				alert('납품요청일은 내일 이후부터 입력이 가능합니다.');	
				eeind.setValue('');
			}
		});
		
		//구매요청 사유 및 세부 spec.(400자 이내)
	    var itemTxt = new Rui.ui.form.LTextArea({
            applyTo: 'itemTxt',
            placeholder: '구매요청 사유 및 세부 spec.(400자 이내)',
            width: 1100,
            height: 80
        });
	 
		//구매그룹
		var ekgrp = new Rui.ui.form.LCombo({
            applyTo: 'ekgrp',
            width: 200,
            useEmptyText: false,
            defaultValue: '<c:out value="${inputData.ekgrp}"/>',
            url: '<c:url value="/common/prsCode/retrieveEkgrpInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE',
            autoMapping: true
        });

		//납품위치
        var position = new Rui.ui.form.LCombo({
			applyTo : 'position',
			width: 180,
			useEmptyText: false,
			items: [
	                   { code: 'LG사이언스파크 E4', value: 'LG사이언스파크 E4' } // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                ]
		});
        
		//계정
        var sakto = new Rui.ui.form.LTextBox({
			applyTo : 'sakto',
			width: 60,
			defaultValue: '<c:out value="${inputData.sakto}"/>',
			dateType: 'string',
			editable: false,
			disabled: true
		});

		//계정명
        var saktonm = new Rui.ui.form.LTextBox({
			applyTo : 'saktonm',
			width: 210,
			defaultValue: '<c:out value="${inputData.saktonm}"/>',
			dateType: 'string',
			editable: false,
			disabled: true
		});

  		//플랜트
		var werks = new Rui.ui.form.LCombo({
    	    applyTo: 'werks',
	        width: 120,
    	    useEmptyText: false,
	        defaultValue: '<c:out value="${inputData.werks}"/>',
        	url: '<c:url value="/common/prsCode/retrieveWerksInfo.do"/>',
        	displayField: 'CODE_NM',
	        valueField: 'CODE',
    	    autoMapping: true
    	});
		
		//요청품명
		var txz01 = new Rui.ui.form.LTextBox({            	// LTextBox개체를 선언
    	    applyTo: 'txz01',                           	// 해당 DOM Id 위치에 텍스트박스를 적용
        	width: 200,                                    	// 텍스트박스 폭을 설정
	        placeholder: '요청품명',						// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
    	    invalidBlur: false                            	// [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//메이커
		var maker = new Rui.ui.form.LTextBox({            	// LTextBox개체를 선언
    	    applyTo: 'maker',                           	// 해당 DOM Id 위치에 텍스트박스를 적용
        	width: 200,                                    	// 텍스트박스 폭을 설정
	        placeholder: '제조업체명',     					// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
    	    invalidBlur: false                            	// [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	
		//벤더
		var vendor = new Rui.ui.form.LTextBox({            	// LTextBox개체를 선언
    	    applyTo: 'vendor',                           	// 해당 DOM Id 위치에 텍스트박스를 적용
        	width: 200,                                    	// 텍스트박스 폭을 설정
	        placeholder: '공급업체명',     					// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
    	    invalidBlur: false                            	// [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	
		//catalog no
		var catalogno = new Rui.ui.form.LTextBox({          // LTextBox개체를 선언
    	    applyTo: 'catalogno',                           // 해당 DOM Id 위치에 텍스트박스를 적용
        	width: 200,                                    	// 텍스트박스 폭을 설정
	        placeholder: '',     							// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
    	    invalidBlur: false                            	// [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	
		//요청 수량
	  	var menge = new Rui.ui.form.LNumberBox({
    	    applyTo: 'menge',
        	placeholder: '',
	        maxValue: 9999999999,           				// 최대값 입력제한 설정
    	    minValue: 0,                  					// 최소값 입력제한 설정
        	width: 90,
	        decimalPrecision: 0,            				// 소수점 자리수 3자리까지 허용
    	});
	
	  	menge.on('blur', function(e) {
    	    setExp();
	    });
  	
  		//수량 단위
		var meins = new Rui.ui.form.LCombo({
    	    applyTo: 'meins',
        	width: 100,
	        useEmptyText: false,
	        defaultValue: 'EA',
    	    url: '<c:url value="/common/prsCode/retrieveMeinsInfo.do"/>',
        	displayField: 'CODE_NM',
	        valueField: 'CODE',
    	    autoMapping: true
	    });
  	
		//예상단가
  		var preis = new Rui.ui.form.LNumberBox({
        	applyTo: 'preis',
	        placeholder: '',
    	    maxValue: 9999999999,           				// 최대값 입력제한 설정
        	minValue: 0,                  					// 최소값 입력제한 설정
	        width: 90,
    	    decimalPrecision: 0           	 				// 소수점 자리수 3자리까지 허용
	    });
	
  		preis.on('blur', function(e) {
        	setExp();
	    });
		
		var purRqUserDataSet = new Rui.data.LJsonDataSet({
			id: 'purRqUserDataSet',
			remainRemoved: true,
            lazyLoad: true,
            fields: [
            	 { id : 'banfnPrs'}   
            	,{ id : 'bnfpoPrs'}   
            	,{ id : 'seqNum'}     
            	,{ id : 'sCode'}       /* 품목구분 */ 
            	,{ id : 'banfn'}       
            	,{ id : 'bnfpo'}       
            	,{ id : 'knttp'}       
            	,{ id : 'pstyp'}       
            	,{ id : 'meins'}       /* 단위 */
            	,{ id : 'eeind'}       
            	,{ id : 'afnam'}       
            	,{ id : 'matkl'}       
            	,{ id : 'ekgrp'}       /* 구매그룹 */
            	,{ id : 'bednr'}       
            	,{ id : 'peinh'}       
            	,{ id : 'anlkl'}       
            	,{ id : 'txt50'}       
            	,{ id : 'itemTxt'}       
            	,{ id : 'kostl'}       
            	,{ id : 'posid'}       
            	,{ id : 'post1'}       
            	,{ id : 'prsFlag'}    
            	,{ id : 'bizCd'}      
            	,{ id : 'attcFilId'}	
            	,{ id : 'txz01'}		/* 요청품명 */
		    	,{ id : 'maker'}		/* 메이커 */
		    	,{ id : 'vendor'}		/* 벤더 */
		    	,{ id : 'catalogno'}	/* 카탈로그 NO */
		    	,{ id : 'waers'}		/* 요청단위 콤보 */
		    	,{ id : 'menge'}		/* 요청수량 */
		    	,{ id : 'meins'}		/* 요청단위 */
		    	,{ id : 'preis'}		/* 예상단가 */
		    	,{ id : 'sakto'}		/* 계정코드 */
		    	,{ id : 'saktoNm'}		/* 계정명 */
		    	,{ id : 'usedCode'}		/* */
		    	,{ id : 'werks'}		/* 플랜트 */
		    	,{ id : 'wbsCd'}		/* 프로젝트코드 */
		    	,{ id : 'sCodeSeq'}     /* 품목구분 Seq */ 
            ]
        });

		
		purRqUserDataSet.on('load', function(e){
			purRqUserDataSet.setNameValue(0, 'sakto', '${inputData.sakto}');
			purRqUserDataSet.setNameValue(0, 'bednr', '${inputData._userSabun}');
			purRqUserDataSet.setNameValue(0, 'sCode', '${inputData.sCode}');
			purRqUserDataSet.setNameValue(0, 'sCodeSeq', '${inputData.sCodeSeq}');
			purRqUserDataSet.setNameValue(0, 'ekgrp', '${inputData.ekgrp}');
			purRqUserDataSet.setNameValue(0, 'wbsCd', '${inputData.post1}');
			purRqUserDataSet.setNameValue(0, 'saktoNm', '${inputData.saktonm}');
			purRqUserDataSet.setNameValue(0, 'werks', '${inputData.werks}');
			purRqUserDataSet.setNameValue(0, 'meins', 'EA');
			purRqUserDataSet.setNameValue(0, 'menge', '');
			purRqUserDataSet.setNameValue(0, 'banfnPrs', '${inputData.banfnPrs}');
		});
		
		var bind = new Rui.data.LBind({
		     groupId: 'aform',
		     dataSet: purRqUserDataSet,
		     bind: true,
		     bindInfo: [
		         { id: 'sCodeSeq', 	ctrlId: 'sCode', 	value: 'value' },
		         { id: 'wbsCd', 	ctrlId: 'wbsCd', 	value: 'value' },
		         { id: 'eeind', 	ctrlId: 'eeind', 	value: 'value' },
		         { id: 'position', 	ctrlId: 'position', value: 'value' },
		         { id: 'ekgrp', 	ctrlId: 'ekgrp', 	value: 'value' },
		         { id: 'itemTxt', 	ctrlId: 'itemTxt', 	value: 'value' },
		         { id: 'sakto', 	ctrlId: 'sakto', 	value: 'value' },
		         { id: 'werks', 	ctrlId: 'werks', 	value: 'value' },
		         { id: 'meins', 	ctrlId: 'meins', 	value: 'value' },
		         { id: 'menge', 	ctrlId: 'menge', 	value: 'value' },
		         { id: 'preis', 	ctrlId: 'preis', 	value: 'value' },
		         { id: 'eeind', 	ctrlId: 'eeind', 	value: 'value' },
		         { id: 'banfnPrs', 	ctrlId: 'banfnPrs', value: 'value' },
		         { id: 'saktoNm', 	ctrlId: 'saktoNm', 	value: 'html' }
		     ]
		 });
		
		fnSearch = function() {
			purRqUserDataSet.load({
	 	 		url: '<c:url value="/prs/purRq/retrievePurRqInfo.do"/>', 
	 	        params :{
	 	        	banfnPrs  : '${inputData.banfnPrs}'
	 	    	        }
	        });
	    }

		fnSearch();
		
 		// 예상금액 계산 : 요청수량 * 예산단가
    	var setExp = function(){
			var p = preis.getValue();
			var m = menge.getValue();
			
			var tot = p*m;
			
			document.getElementById("totPreis").innerHTML = Rui.util.LNumber.toMoney(tot);
		}; 
    	
		/**
			구매요청 품목 List 시작
		**/
        var prItemListDataSet = new Rui.data.LJsonDataSet({
            id: 'prItemListDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                //  { id: 'badate' }		// 요청일	1
                 { id: 'sCode' }     	// 요청구분	
                , { id: 'posid' } 		// 프로젝트코드	
                , { id: 'posidnm' } 	// 프로젝트명	
                , { id: 'eeind' } 		// 납품요청일	5
                , { id: 'position' } 	// 납품위치	
                , { id: 'ekgrp' } 		// 구매그룹	
                , { id: 'ekgrpnm' } 	// 구매그룹명	
                , { id: 'sakto' } 		// 계정코드	
                , { id: 'saktonm' } 	// 계정명	10
                , { id: 'txz01' } 		// 요청품명
                , { id: 'maker' } 		// Maker
                , { id: 'vendor' } 		// Vendor
                , { id: 'catalogno' } 	// Catalog No
                , { id: 'werks' } 		// 플랜트코드	15
                , { id: 'werksnm' } 	// 플랜트명
                , { id: 'menge' } 		// 요청수량
                , { id: 'meins' } 		// 단위
                , { id: 'preis' } 		// 단가
                , { id: 'totamt' } 		// 금액	20
                , { id: 'itemTxt' } 	// 요청사유
                , { id: 'attcFiles' } 	// 첨부파일
                , { id: 'attcFileId' } 	// 첨부파일 Id
                , { id: 'banfnPrs' } 	// 구매요청번호
                , { id: 'bnfpoPrs' } 	// 구매요청순번
                , { id: 'seqNum' } 		// Seq No
                , { id: 'sCodeSeq' }    // 요청구분 Seq
            ]
        });		
		
        var itemColumnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                //new Rui.ui.grid.LSelectionColumn()
                //, { field: 'badate', 	label: '요청일', 		sortable: true,	align:'center',	width: 80 }
                 { field: 'sCode', 	label: '요청구분', 		sortable: false,	align:'center',	width: 80 }
                , { field: 'posid', 	label: '프로젝트코드', 	sortable: false,	align:'center',	width: 90 }
                , { field: 'posidnm', 	label: '프로젝트명', 	sortable: false,	align:'left',	width: 300 }
                , { field: 'eeind', 	label: '납품요청일', 	sortable: false,	align:'center',	width: 80 }
                , { field: 'position', 	label: '납품위치', 	 	sortable: false,	align:'center',	width: 130 }
                , { field: 'ekgrp', 	label: '구매그룹', 	 	sortable: false,	align:'center',	width: 80 }
                , { field: 'ekgrpnm', 	label: '구매그룹명', 	sortable: false,	align:'center',	width: 100 }
                , { field: 'sakto', 	label: '계정코드', 	 	sortable: false,	align:'center',	width: 80 }
                , { field: 'saktonm', 	label: '계정명', 	 	sortable: false,	align:'left',	width: 150 }
                , { field: 'txz01', 	label: '요청품명', 	 	sortable: false,	align:'left',	width: 150 }
                , { field: 'maker', 	label: 'Maker', 	 	sortable: false,	align:'left',	width: 150 }
                , { field: 'vendor', 	label: 'Vendor', 	 	sortable: false,	align:'left',	width: 150 }
                , { field: 'catalogno', label: 'Catalog No', 	sortable: false,	align:'left',	width: 150 }
                , { field: 'werks', 	label: '플랜트코드', 	sortable: false,	align:'center',	width: 80 }
                , { field: 'werksnm', 	label: '플랜트명', 	 	sortable: false,	align:'left',	width: 120 }
                , { field: 'menge', 	label: '요청수량', 	 	sortable: false,	align:'right',	width: 90, 
                	renderer: function(value, p){
                				return Rui.util.LNumber.toMoney(value);
                	          }   
                  }
                , { field: 'meins', 	label: '단위', 		 	sortable: false,	align:'center',	width: 80 }
                , { field: 'preis', 	label: '단가', 		 	sortable: false,	align:'right',	width: 90, 
                	renderer: function(value, p) {
                        		return Rui.util.LNumber.toMoney(value);
       	          			  }   
                  }
                , { field: 'totamt', 	label: '금액', 		 	sortable: false,	align:'right',	width: 100,  
                	renderer: function(val, p, record, row, i) {
                     	        return Rui.util.LNumber.toMoney(record.get('menge') * record.get('preis'));
                     	      } 
                  }
                , { field: 'itemTxt', 	label: '요청사유', 	 	sortable: false, width: 200, editor: new Rui.ui.form.LTextArea({disabled: true}), 
                    renderer: function(val, p, record, row, col) {
                    			return val.replaceAll('\n', '<br/>');
                              }
                  }                
                , { field: 'attcFiles', label: '첨부파일', 	 	sortable: false, width: 200,  
                    renderer: function(val, p, record, row, col) {
                    			return val.replaceAll('\n', '<br/>');
                              }
                  }
                , { field: 'attcFileId', 	label: '첨부파일 Id', 	 	sortable: false,	align:'right',	width: 90, hidden:false }
                , { field: 'banfnPrs', 		label: '구매요청번호', 	 	sortable: false,	align:'right',	width: 90, hidden:false }
                , { field: 'bnfpoPrs', 		label: '구매요청순번', 	 	sortable: false,	align:'right',	width: 90, hidden:false }
                , { field: 'seqNum', 		label: 'Seq No', 	 		sortable: false,	align:'right',	width: 90, hidden:false }
                , { field: 'sCodeSeq', 		label: '요청구분 Seq', 		sortable: false,	align:'right',	width: 90, hidden:false }
            ]
        });

        var sumColumns = ['menge', 'totamt'];
        var summary = new Rui.ui.grid.LTotalSummary({gridView: sumColumns, renderSummaryTime: 1});
        
        summary.on('renderTotalCell', summary.renderer({
            label: {
                id: 'werksnm',
                text: '합계'
            }, 
            columns: {
            	menge: { type: 'sum', renderer: 'money' },
            	totamt: { type: 'sum', renderer: 'money' }
            }
        }));        
        
        var purItemGrid = new Rui.ui.grid.LGridPanel({
            columnModel: itemColumnModel,
            dataSet: prItemListDataSet,
            width: 600,
            height: 400,
            autoToEdit: false,
            autoWidth: true,
            viewConfig: {
                plugins: [ summary ]
            }
        });		
        
        purItemGrid.render('purItemGridDiv');
        
        // Grid double Click event 처리
        purItemGrid.on('cellDblClick', function(e) {
        	var dblClickRecord = prItemListDataSet.getAt(e.row);
        	dblClickedRow = e.row;
        	curRow = e.row;
        	changeItemContents(dblClickRecord);
        });
        
        prItemListDataSet.on('load', function(e) {
	    		$("#cnt_text").html('총 ' + prItemListDataSet.getCount() + '건');
	    		// 목록 페이징
	    		aCnt =20;
	    		paging(prItemListDataSet,"purItemGridDiv");
	    });
        
		
		/**
			구매요청 품목 List 끝
		**/

		/**
			납품요청일 설명 Popup 시작
		**/
		/* [ 납품요청일 설명 Dialog] */
		 purRqExplainDialog = new Rui.ui.LFrameDialog({
		     id: 'purRqExplainDialog',
		     title: '납품 요청일 도움말',
		     width:  800,
		     height: 350,
		     modal: true,
		     visible: false,
		     buttons : [
		         { text:'닫기', handler: function() {
		           	this.cancel(false);
		           }
		         }
		     ]
		 });

		 purRqExplainDialog.render(document.body);

		/* [버튼] 납품요청일? */
	    var btnPopupExplain = new Rui.ui.LButton('btnPopupExplain');
		
	    btnPopupExplain.on('click', function() {
			//납품요청일 설명 팝업창	
			purRqExplainDialog.setUrl('<c:url value="/prs/popup/purRqDateExplainPop.do"/>');
			purRqExplainDialog.show(true); 
		});
		/**
		납품요청일 설명 Popup 끝
		**/
		
		 /* [버튼] 추가 시작 */
	    var btnAddPurRq = new Rui.ui.LButton('btnAddPurRq');
		btnAddPurRq.on('click', function() {
			if(isValidate('추가')) {
				document.getElementById("sCodeNm").value = sCode.getDisplayValue();

				fncSave();
				
				if(dblClickedRow != null && dblClickedRow >= 0) return;
                var row = prItemListDataSet.newRecord();
                var record = prItemListDataSet.getAt(row);
                addNewItemList(record);
                clearItemContents();
                curRow = row;
			};
		});
		/* [버튼] 추가 끝 */
		
		 /* [버튼] 초기화 시작 */
	    var btnClearItemContents = new Rui.ui.LButton('btnClearItemContents');
	    btnClearItemContents.on('click', function() {
               clearItemContents();
		});
		/* [버튼] 초기화 끝 */
 
		 /* [버튼] 삭제 시작 */
	    var btnDeleteItem = new Rui.ui.LButton('btnDeleteItem');
	    btnDeleteItem.on('click', function() {
	    	   fncDelete();
		});
		/* [버튼] 삭제 끝 */

		 /* [버튼] 수정 시작 */
	    var btnModifyItem = new Rui.ui.LButton('btnModifyItem');
	    btnModifyItem.on('click', function() {
	    	if(isValidate('수정')) {
	    		fncUpdate();
			   	//if(dblClickedRow != null && dblClickedRow >= 0) {	   
               	//	modifyItemContents(dblClickedRow);
	    		//};
	    	};   	
		});
		/* [버튼] 수정 끝 */

		// 요청품번이 없으며 삭제/수정 버튼을 숨긴다.
	    if('<c:out value="${inputData.bnfpoPrs}"/>' == '') {
	    	btnDeleteItem.hide();
	    	btnModifyItem.hide();
	    }
		
		fncSave = function(){
			//구매요청 Item 정보 추가	 
	    	if( confirm("추가하시겠습니까?") == true ){
	    		dm.updateForm({
	    			url:'<c:url value="/prs/purRq/insertPurRqInfo.do"/>',
	    			form : 'aform',
	    			params: {                                  
	    				wbsCdNm: $('#wbsCdName', aform).html()
	    	        }

	    		});
	    	} 
		}
		
		fncDelete = function(){
			//구매요청 Item 정보 추가	 
	    	if( confirm("삭제하시겠습니까?") == true ){
	    		dm.updateForm({
	    			url:'<c:url value="/prs/purRq/deletePurRqInfo.do"/>',
	    			form : 'aform'
	    		});
	    	} 
		}

		fncUpdate = function(){
			//구매요청 Item 정보 추가	 
	    	if( confirm("수정하시겠습니까?") == true ){
	    		dm.updateForm({
	    			url:'<c:url value="/prs/purRq/updatePurRqInfo.do"/>',
	    			form : 'aform'
	    		});
	    	} 
		}

		dm.on('success', function(e) {
			var resultData = resultDataSet.getReadData(e);
			
			if( resultData.records[0].rtnSt == "S"){
				Rui.alert(resultData.records[0].rtnMsg);
				
				if( resultData.records[0].cmd == "insert" ) {
					document.getElementById("bnfpoPrs").value = resultData.records[0].bnfpoPrs;
					prItemListDataSet.getAt(curRow).set('bnfpoPrs', resultData.records[0].bnfpoPrs);	
				} else if( resultData.records[0].cmd == "delete" ) {
					document.getElementById("bnfpoPrs").value = '';
					prItemListDataSet.removeAt(curRow);
					clearItemContents();
				} else if( resultData.records[0].cmd == "update" ) {
					modifyItemContents(curRow);
				}
			}
        });
        dm.on('failure', function(e) {
        	var resultData = resultDataSet.getReadData(e);
   			Rui.alert(resultData.records[0].rtnMsg);
        });

        /* [기능] 첨부파일 조회*/
        var attachFileDataSet = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet.on('load', function(e) {
            getAttachFileInfoList();
        });
        
        getAttachFileList = function() {
            attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                	attcFilId : lvAttcFilId
                }
            });
        };
        
        getAttachFileInfoList = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }

            setAttachFileInfo(attachFileInfoList);
        };
        
        /* [기능] 첨부파일 등록 팝업*/
        getAttachFileId = function() {
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

            return lvAttcFilId;
        };

        setAttachFileInfo = function(attachFileList) {
        	
            $('#attchFileView').html('');
            if(attachFileList.length > 0) {
                for(var i = 0; i < attachFileList.length; i++) {
                    $('#attchFileView').append($('<a/>', {
                        href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

                if(Rui.isEmpty(lvAttcFilId)) {
                	lvAttcFilId =  attachFileList[0].data.attcFilId;
                	purRqUserDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                	document.getElementById("attcFilId").value = attachFileList[0].data.attcFilId;
                }
            }
        };

        /*첨부파일 다운로드*/
        downloadAttachFile = function(attcFilId, seq) {
            downloadForm.action = '<c:url value="/system/attach/downloadAttachFile.do"/>';
            $('#attcFilId').val(attcFilId);
            $('#seq').val(seq);
            downloadForm.submit();
        };

       	//첨부파일 끝
       	
	    /* 유효성 검사 */
	    isValidate = function(type) {
            if (posid.getValue() == '') {
                alert('Project Code를 선택하여 주세요.');
                return false;
            }

            if (eeind.getValue() == '') {
                alert('납품요청일을 입력하여 주세요.');
                return false;
            }

            if (ekgrp.getDisplayValue() == '') {
                alert('구매그룹을 선택하여 주세요.');
                return false;
            }

            if (txz01.getDisplayValue() == '') {
                alert('요청품명을 입력하여 주세요.');
                return false;
            }
            
            if (werks.getDisplayValue() == '') {
                alert('플랜트를 선택하여 주세요.');
                return false;
            }

            if (menge.getDisplayValue() == '') {
                alert('요청수량 입력하여 주세요.');
                return false;
            }

            if (meins.getDisplayValue() == '') {
                alert('단위를 선택하여 주세요.');
                return false;
            }

            if (preis.getDisplayValue() == '') {
                alert('예상단가를 입력하여 주세요.');
                return false;
            }

            return true;
	    }
       	
       	addNewItemList = function(record) {
            record.set('sCode', 	sCode.getDisplayValue());			// 품묵구분
            record.set('posid', 	posid.getValue()); 					// 프로젝트코드	
            record.set('posidnm', 	$('#wbsCdName', aform).html()); 	// 프로젝트명	
            record.set('eeind', 	eeind.getValue()); 					// 납품요청일	5
            record.set('position', 	position.getValue()); 				// 납품위치	
            record.set('ekgrp', 	ekgrp.getValue()); 					// 구매그룹	
            record.set('ekgrpnm', 	ekgrp.getDisplayValue()); 			// 구매그룹명	
            record.set('sakto', 	sakto.getValue()); 					// 계정코드	
            record.set('saktonm', 	saktonm.getValue()); 				// 계정명	10
            record.set('txz01', 	txz01.getValue()); 				// 요청품명
            record.set('maker', 	maker.getValue()); 					// Maker
            record.set('vendor', 	vendor.getValue()); 				// Vendor
            record.set('catalogno', catalogno.getValue()); 				// Catalog No
            record.set('werks', 	werks.getValue()); 					// 플랜트코드	15
            record.set('werksnm', 	werks.getDisplayValue()); 			// 플랜트명
            record.set('menge', 	menge.getValue()); 					// 요청수량
            record.set('meins', 	meins.getValue()); 					// 단위
            record.set('preis', 	preis.getValue()); 					// 단가
            record.set('itemTxt', 	itemTxt.getValue()); 				// 요청사유
            record.set('attcFiles', $('#attchFileView').html()); 		// 첨부파일
            record.set('attcFileId', getAttachFileId()); 				// 첨부파일 Id
            record.set('sCodeSeq', 	sCode.getValue());					// 품묵구분 Seq
            record.set('banfnPrs', 	document.getElementById("banfnPrs").value);					// 요청번호
            record.set('bnfpoPrs', 	document.getElementById("bnfpoPrs").value);					// 요청품번
            itemEditable = false;
       	}
       	
       	clearItemContents = function() {
            posid.setValue(''); 					// 프로젝트코드	
            $('#wbsCdName', aform).html(''); 		// 프로젝트명	
            eeind.setValue(''); 					// 납품요청일	
            txz01.setValue(''); 					// 요청품명
            maker.setValue(''); 					// Maker
            vendor.setValue(''); 					// Vendor
            catalogno.setValue(''); 				// Catalog No
            menge.setValue(''); 					// 요청수량
            // meins.setValue(''); 					// 단위
            preis.setValue(''); 					// 단가
            document.getElementById("totPreis").innerHTML = '';	// 예상금액
            itemTxt.setValue(''); 					// 요청사유  
            $('#attchFileView').html('');			// 첨부파일
            lvAttcFilId = '';						// 첨부파일 ID 초기화
            document.getElementById("attcFilId").value = '';
            getAttachFileId();						// 첨부파일 ID
            itemEditable = false;
	    	btnDeleteItem.hide();					// 삭제 버튼
	    	btnModifyItem.hide();					// 수정 버튼
	    	btnAddPurRq.show();						// 추가 버튼
	    	document.getElementById("sCodeNm").value = '';	// 품묵구분명
	    	document.getElementById("bnfpoPrs").value = '';	// 요청 품번
            dblClickedRow = -1;
       	}
       	
       	changeItemContents = function(record) {
       		itemEditable = true;
       		sCode.setValue(record.get('sCodeSeq'));					// 품묵구분
            posid.setValue(record.get('posid')); 					// 프로젝트코드	
            $('#wbsCdName', aform).html(record.get('posidnm')); 	// 프로젝트명	
            eeind.setValue(record.get('eeind')); 					// 납품요청일	
            position.setValue(record.get('position')); 				// 납품위치	
            ekgrp.setValue(record.get('ekgrp')); 					// 구매그룹	
            sakto.setValue(record.get('sakto')); 					// 계정코드	
            saktonm.setValue(record.get('saktonm')); 				// 계정명	
            txz01.setValue(record.get('txz01')); 					// 요청품명
            maker.setValue(record.get('maker')); 					// Maker
            vendor.setValue(record.get('vendor')); 					// Vendor
            catalogno.setValue(record.get('catalogno')); 			// Catalog No
            werks.setValue(record.get('werks')); 					// 플랜트코드	
            menge.setValue(record.get('menge')); 					// 요청수량
            meins.setValue(record.get('meins')); 					// 단위
            preis.setValue(record.get('preis')); 					// 단가
            if (record.get('itemTxt') == null) {
            	itemTxt.setValue('');
            } else {
            	itemTxt.setValue(record.get('itemTxt'));
           	}; 	// 요청사유 
           	lvAttcFilId = record.get('attcFileId');
           	getAttachFileList();									// 첨부파일 ID
           	document.getElementById("sCodeNm").value = record.get('sCode');	// 품묵구분명
           	document.getElementById("bnfpoPrs").value = record.get('bnfpoPrs');	// 요청 품번
	    	btnDeleteItem.show();									// 삭제 버튼
	    	btnModifyItem.show();									// 수정 버튼
	    	btnAddPurRq.hide();										// 추가 버튼
            setExp();
       	}
       	
       	modifyItemContents = function(row) {
       		var record = prItemListDataSet.getAt(row);
       		
            record.set('sCode', 	sCode.getDisplayValue());			// 품묵구분
            record.set('posid', 	posid.getValue()); 					// 프로젝트코드	
            record.set('posidnm', 	$('#wbsCdName', aform).html()); 	// 프로젝트명	
            record.set('eeind', 	eeind.getValue()); 					// 납품요청일	5
            record.set('position', 	position.getValue()); 				// 납품위치	
            record.set('ekgrp', 	ekgrp.getValue()); 					// 구매그룹	
            record.set('ekgrpnm', 	ekgrp.getDisplayValue()); 			// 구매그룹명	
            record.set('sakto', 	sakto.getValue()); 					// 계정코드	
            record.set('saktonm', 	saktonm.getValue()); 				// 계정명	10
            record.set('txz01', 	txz01.getValue()); 				// 요청품명
            record.set('maker', 	maker.getValue()); 					// Maker
            record.set('vendor', 	vendor.getValue()); 				// Vendor
            record.set('catalogno', catalogno.getValue()); 				// Catalog No
            record.set('werks', 	werks.getValue()); 					// 플랜트코드	15
            record.set('werksnm', 	werks.getDisplayValue()); 			// 플랜트명
            record.set('menge', 	menge.getValue()); 					// 요청수량
            record.set('meins', 	meins.getValue()); 					// 단위
            record.set('preis', 	preis.getValue()); 					// 단가
            record.set('itemTxt', 	itemTxt.getValue()); 				// 요청사유
            record.set('attcFiles', $('#attchFileView').html()); 		// 첨부파일
            record.set('attcFileId', getAttachFileId()); 				// 첨부파일 Id   
            record.set('sCodeSeq', 	sCode.getValue());					// 품묵구분 Seq
            record.set('bnfpoPrs', 	document.getElementById("bnfpoPrs").value);					// 요청품번
       	}
       	
	});
		
		


</script>

</head>
<body>
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
			<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			<span class="hidden">Toggle 버튼</span>
	   	</a>
	    <h2>비용요청(구매) 상세내용</h2>
    </div>

	<form id="aform" name ="aform">
	<input type="text" id="tabId" name="tabId" value="<c:out value='${inputData.tabId}'/>">  
	<!--input type="text" id="posid" name="posid" /-->  
	<input type="text" id="banfnPrs" name="banfnPrs" value="<c:out value='${inputData.banfnPrs}'/>">
	<input type="text" id="bnfpoPrs" name="bnfpoPrs" value="<c:out value='${inputData.bnfpoPrs}'/>"> 
	<input type="text" id="sCodeNm" name="sCodeNm" />
	<input type="text" id="attcFilId" name="attcFilId" />  
	
	<div class="sub-content">
	   		<div class="titArea mt0" style="margin-bottom:5px !important;">
   				<div class="LblockButton mt0">
   					<button type="button" id="btnPopupExplain" name="btnPopupExplain" >납품요청일?</button>
   				</div>
			</div>
	
			<table class="table table_txt_right">
            	<colgroup>
                	<col width="145px">
                    <col width="305px">
                    <col width="145px">
                    <col width="305px">
                    <col width="145px">
                    <col width="*">
                 </colgroup>
			     <tbody>
			     	<tr>
			        	<th>품목구분</th>
			            <td>
			            	<select id="sCode" name="sCode"></select> 
			            </td>
			            <th>Project Code</th>
			            <td>
							<!--input type="text" class="" id="post1" name="post1" value="" -->
							<input type="text" class="" id=wbsCd name="wbsCd" value="" >&nbsp;<span id="wbsCdName" name="wbsCdName"></span>
			            </td>
			            <th>납품요청일</th>
			            <td>
			            	<div id="eeind"/>
			            </td>
			        </tr>
			        <tr>
			        	<th>성명</th>
			            <td>
			            	${inputData._userNm}
			            </td>
			        	<th>납품위치</th>
			            <td>
			            	<select id="position" name="position"></select>
			            </td>
			            <th>구매그룹</th>
			            <td>
			                <select id="ekgrp" name="ekgrp"></select>
			            </td>
					</tr>
			         <tr>
			         	<th>요청사유 및 세부스펙<br/>(400자 이내)</th>
			            <td colspan="5">
			            	<textarea id="itemTxt" name="itemTxt"></textarea>
			            </td>
					</tr>	
					<tr>
			        	<th>계정</th>
			            <td>
			            	<input type="text" id="sakto" name="sakto"> / <input type="text" id="saktonm" name="saktonm">
			            </td>
	                    <th align="right">첨부파일</th>
	                    <td colspan="2" id="attchFileView">&nbsp;</td>
	                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prsPolicy', '*')">첨부파일등록</button></td>
	                </tr>
				</tbody>
			</table>
			
			
			<table class="table table_txt_right">
            	<colgroup>
                	<col width="145px">
                    <col width="305px">
                    <col width="145px">
                    <col width="305px">
                    <col width="145px">
                    <col width="*">
                 </colgroup>
			     <tbody>
			     	<tr>
			        	<th>요청품명</th>
			            <td>
			            	<input type="text" id="txz01" name="txz01" />
			            </td>
			        	<th>Maker</th>
			            <td>
			            	<input type="text" id="maker" name="maker" maxlength="35" /> (35자 이내)
			            </td>
			        	<th>Vendor</th>
			            <td>
			            	<input type="text" id="vendor" name="vendor" maxlength="35" /> (35자 이내)
			            </td>
			        </tr>
			        <tr>
			        	<th>Catalog No.</th>
			            <td>
			            	<input type="text" id="catalogno" name="catalogno" maxlength="15" /> (15자 이내)
			            </td>
			        	<th>플랜트</th>
			            <td>
			                <select id="werks" name="werks"></select>
			            </td>
			        	<th>사용용도</th>
			            <td>
			            	실험용
			            </td>
					</tr>
			        <tr>
			        	<th>요청 수량</th>
			            <td>
			            	<input type="text" id="menge" name="menge" /> <select id="meins" name="meins"></select>
			            </td>
			        	<th>예상단가</th>
			            <td>
			            	<input type="text" id="preis" name="preis" /> KRW (원화환산) 
			            </td>
			        	<th>예상 금액</th>
			            <td>
			            	<span id="totPreis"></span>
			            </td>
					</tr>
				</tbody>

			</table>
	    <div class="titArea">
	    	<span class="Ltotal" id="cnt_text">총 : 0건 </span>
	    	<div class="LblockButton">
	    	    <button type="button" id="btnClearItemContents" name="btnClearItemContents" >초기화</button>
	    		<button type="button" id="btnDeleteItem" name="btnDeleteItem" >삭제</button>
	    		<button type="button" id="btnModifyItem" name="btnModifyItem" >수정</button>
	    	 	<button type="button" id="btnAddPurRq" name="btnAddPurRq" class="redBtn">추가</button>
	    	</div>
	    </div>
	    
	    <div id="purItemGridDiv"></div> 
	</div> <!-- //sub-content -->
</div> <!-- //contents -->   
		
	<div id="purRqGrid"></div>

</form>
</body>
</html>