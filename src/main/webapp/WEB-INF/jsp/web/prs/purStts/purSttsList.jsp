<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purSttsList.jsp
 * @desc    : 구매요청현황 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.05.03   김연태		최초생성
 * ---	-----------	----------	-----------------------------------------
 * PRS 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

<script type="text/javascript">
var frm = document.aform;
var adminChk = "N";

	Rui.onReady(function() {
		/*******************
         * 변수 및 객체 선언
         *******************/
		/* WBS 코드 */
 		var posid = new Rui.ui.form.LTextBox({
             applyTo: 'posid',
             placeholder: '',
             defaultValue: '<c:out value="${inputData.posid}"/>',
             emptyValue: '',
             width: 200
         });
         
        /* 작성일 시작일 */
        var fromRegDt = new Rui.ui.form.LDateBox({
				applyTo: 'fromRegDt',
				mask: '9999-99-99',
				defaultValue: '<c:out value="${inputData.fromRegDt}"/>',
				displayValue: '%Y-%m-%d',
				editable: false,
				width: 200,
				dateType: 'string'
		});

        fromRegDt.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromRegDt.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				fromRegDt.setValue(new Date());
			}
		});

        /* 작성일 종료일 */
        var toRegDt = new Rui.ui.form.LDateBox({
			applyTo: 'toRegDt',
			mask: '9999-99-99',
			defaultValue: '<c:out value="${inputData.toRegDt}"/>',
			displayValue: '%Y-%m-%d',
			editable: false,
			width: 100,
			dateType: 'string'
		});

        toRegDt.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toRegDt.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				toRegDt.setValue(new Date());
			}

			if( fromRegDt.getValue() > toRegDt.getValue() ) {
				alert('시작일이 종료일보다 클 수 없습니다.!!');
				fromRegDt.setValue(toRegDt.getValue());
			}
		});
		
        /* 요청품명 */
		var txz01 = new Rui.ui.form.LTextBox({
            applyTo: 'txz01',
            placeholder: '요청품명을 입력해주세요.',
            defaultValue: '<c:out value="${inputData.txz01}"/>',
            emptyValue: '',
            width: 400
        });

		txz01.on('blur', function(e) {
			txz01.setValue(txz01.getValue().trim());
        });
		
		
		/* 구매그룹 */
		var ekgrp = new Rui.ui.form.LCombo({
            applyTo: 'ekgrp',
            width: 200,
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/prsCode/retrieveEkgrpInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE'
        });
			
		/* 상태 
		var prsFlag = new Rui.ui.form.LCombo({
            applyTo: 'prsFlag',
            width: 100,
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/prsCode/retrievePrsFlagInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE'
        });
 */

		/**
		구매요청 품목 List 시작
		**/
	    var prItemListDataSet = new Rui.data.LJsonDataSet({
	        id: 'prItemListDataSet',
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
	              { id: 'badate' }		// 작성일	
	            , { id: 'sCode' }     	// 요청구분	
	            , { id: 'posid' } 		// 프로젝트코드	
	            , { id: 'posidnm' } 	// 프로젝트명	
	            , { id: 'eeind' } 		// 납품요청일	
	            , { id: 'position' } 	// 납품위치	
	            , { id: 'ekgrp' } 		// 구매그룹	
	            , { id: 'ekgrpnm' } 	// 구매그룹명	
	            , { id: 'sakto' } 		// 계정코드	
	            , { id: 'saktonm' } 	// 계정명	
	            , { id: 'txz01' } 		// 요청품명
	            , { id: 'maker' } 		// Maker
	            , { id: 'vendor' } 		// Vendor
	            , { id: 'catalogno' } 	// Catalog No
	            , { id: 'werks' } 		// 플랜트코드	
	            , { id: 'werksnm' } 	// 플랜트명
	            , { id: 'menge' } 		// 요청수량
	            , { id: 'meins' } 		// 단위
	            , { id: 'preis' } 		// 단가
	            , { id: 'totamt' } 		// 금액	20
	            , { id: 'itemTxt' } 	// 요청사유
	            , { id: 'attcFiles' } 	// 첨부파일
	            , { id: 'attcFilId' } 	// 첨부파일 Id
	            , { id: 'prsFlag'}		// 상태코드
	            , { id: 'prsNm'}		// 상태명
	            , { id: 'message'}		// Message
	            , { id: 'banfnPrs' } 	// 구매요청번호
	            , { id: 'bnfpoPrs' } 	// 구매요청순번
	            , { id: 'seqNum' } 		// Seq No
	            , { id: 'helpSeqnum' }  // 요청구분 Seq
	            , { id: 'tabid' } 	   	// TAB ID
	            , { id: 'banfn' } 		// ERP 구매요청번호
	            , { id: 'bnfpo' } 		// ERP 구매요청품목번호
	            , { id: 'badat' }		// PR 생성일
	    		, { id: 'apr4Date' }	// PR 결제일	
				, { id: 'rejeDate' }	// PR 결제기각일	
				, { id: 'ebeln' }		// PO 번호	
				, { id: 'ebelp' }		// PO 품번	
				, { id: 'bedat' }		// PO 생성일	
				, { id: 'poMenge' }		// PO 수량
				, { id: 'poMeins' }		// PO 단위
				, { id: 'netwr' }		// PO 금액	
				, { id: 'waers' }		// PO 통화	
				, { id: 'name1' }		// Vendor	
				, { id: 'grBudat' }		// 입고일
				, { id: 'grMenge' }		// 입고수량
				, { id: 'piBudat' }	    // 송장일            
				, { id: 'afnam' }	    // 요청자            
	        ]
	    });		
		
	    var itemColumnModel = new Rui.ui.grid.LColumnModel({
	    	/* freezeColumnId: 'posid', */
	        columns: [
	              { field: 'eeind', 	label: '납품요청일', 	sortable: false,	align:'center',	width: 80 }
	            , { field: 'txz01', 	label: '요청품명', 	 	sortable: false,	align:'left',	width: 200 }
	            , { field: 'menge', 	label: '요청수량', 	 	sortable: false,	align:'right',	width: 70, 
	            	renderer: function(value, p){
	            				return Rui.util.LNumber.toMoney(value);
	            	          }   
	              }
	            , { field: 'meins', 	label: '단위', 		 	sortable: false,	align:'center',	width: 70 }
	            , { field: 'preis', 	label: '단가', 		 	sortable: false,	align:'right',	width: 80, 
	            	renderer: function(value, p) {
	                    		return Rui.util.LNumber.toMoney(value);
	   	          			  }   
	              }
	            , { field: 'totamt', 	label: '금액', 		 	sortable: false,	align:'right',	width: 90,  
	            	renderer: function(val, p, record, row, i) {
	                 	        return Rui.util.LNumber.toMoney(record.get('menge') * record.get('preis'));
	                 	      } 
	              }
	            , { field: 'badate', 	label: '작성일', 		sortable: false,	align:'center',	width: 80 }
	            , { field: 'posid', 	label: '프로젝트코드', 	sortable: false,	align:'center',	width: 90 }
		        , { field: 'banfn', 	label: 'PR번호', 		 	sortable: false,	align:'center',	width: 90}
		        , { field: 'bnfpo', 	label: 'PR품번',	 	 	sortable: false,	align:'center',	width: 70}
	            , { field: 'ekgrpnm', 	label: '구매담당', 	sortable: false,	align:'center',	width: 100 }
	            , { field: 'afnam', 	label: '구매요청자', 	 		sortable: false,	align:'center',	width: 80 }
	            , { field: 'prsNm', 	label: '구매단계', 	 		sortable: false,	align:'center',	width: 100 }
	            , { field: 'sCode', 	label: '요청구분', 		sortable: false,	align:'center',	width: 80 }
	            , { field: 'position', 	label: '납품위치', 	 	sortable: false,	align:'center',	width: 130 }
	            , { field: 'posidnm', 	label: '프로젝트명', 	sortable: false,	align:'left',	width: 150 }
	            //, { field: 'ekgrp', 	label: '구매그룹', 	 	sortable: false,	align:'center',	width: 80 }
	            , { field: 'sakto', 	label: '계정코드', 	 	sortable: false,	align:'center',	width: 80 }
	            , { field: 'saktonm', 	label: '계정명', 	 	sortable: false,	align:'left',	width: 150 }
	            , { field: 'maker', 	label: 'Maker', 	 	sortable: false,	align:'left',	width: 150 }
	            , { field: 'vendor', 	label: 'Vendor', 	 	sortable: false,	align:'left',	width: 150 }
	            , { field: 'catalogno', label: 'Catalog No', 	sortable: false,	align:'left',	width: 150 }
	            //, { field: 'werks', 	label: '플랜트코드', 	sortable: false,	align:'center',	width: 80 }
	            , { field: 'werksnm', 	label: '플랜트명', 	 	sortable: false,	align:'left',	width: 100 }
	            
	           /* 
	            , { field: 'itemTxt', 	label: '요청사유', 	 	sortable: false, width: 200, editor: new Rui.ui.form.LTextArea({disabled: true}), 
	                renderer: function(val, p, record, row, col) {
	                			return val.replaceAll('\n', '<br/>');
	                          }
	              }                
	            
	            , { field: 'attcFiles', label: '첨부파일', 	 	sortable: false, width: 200, hidden:false,  
	                renderer: function(val, p, record, row, col) {
	                			return val.replaceAll('\n', '<br/>').replaceAll('|||','<br/>');
	                          }
	              }
	             */
	            , { field: 'prsFlag', 		label: '상태', 	 		hidden:true  }
	            , { field: 'message', 		label: '비고',	 	 	sortable: false,	align:'left',	width: 250 }
	            , { field: 'grBudat', 		label: '입고일',	 	 	sortable: false,	align:'center',	width: 90 }						// 입고일
				, { field: 'grMenge', 		label: '입고수량',	 	sortable: false,	align:'right',	width: 90,
	            	renderer: function(value, p) {
	            				if(value == "" || null == value) { value = 0}
						  		return Rui.util.LNumber.toMoney(value);
	  						}   
				  }						// 입고수량
	            , { field: 'badat', 		label: 'PR생성일',	 	hidden:true }		// PR 생성일
	    		, { field: 'apr4Date', 		label: 'PR결제일',	 	 	sortable: false,	align:'center',	width: 90 }						// PR 결제일	
				, { field: 'rejeDate', 		label: 'PR결제기각일',   hidden:true }		// PR 결제기각일	
				, { field: 'ebeln', 		label: 'PO번호',	 	 	sortable: false,	align:'center',	width: 90 }						// PO 번호	
				, { field: 'ebelp', 		label: 'PO품번',	 	 	sortable: false,	align:'center',	width: 90 }						// PO 품번	
				, { field: 'bedat', 		label: 'PO생성일',	 	hidden:true }		// PO 생성일	
				, { field: 'poMenge', 		label: 'PO수량',	 	 	sortable: false,	align:'right',	width: 90,
	            	renderer: function(value, p) {
	            				if(value == "" || null == value) { value = 0}
	            				return Rui.util.LNumber.toMoney(value);
	   			  			}   
				  }						// PO 수량
				, { field: 'poMeins', 		label: 'PO단위',	 	 	sortable: false,	align:'center',	width: 90 }						// PO 단위
				, { field: 'netwr', 		label: 'PO금액',	 	 	hidden:true,
	            	renderer: function(value, p) {
	            				if(value == "" || null == value) { value = 0}
	    						return Rui.util.LNumber.toMoney(value);
			  				}   
				  }		// PO 금액	
				, { field: 'waers', 		label: 'PO통화',	 	 	hidden:true }		// PO 통화	
				, { field: 'name1', 		label: 'Vendor',	 	hidden:true }		// Vendor	
				, { field: 'piBudat', 		label: '송장일',	 	 	sortable: false,	align:'center',	width: 90, hidden:true }	    // 송장일            
	            , { field: 'attcFilId', 	label: '첨부파일 Id', 	 	sortable: false,	align:'right',	width: 90, hidden:true }
	            , { field: 'banfnPrs', 		label: '구매요청번호', 	 	sortable: false,	align:'right',	width: 90, hidden:true }
	            , { field: 'bnfpoPrs', 		label: '구매요청순번', 	 	sortable: false,	align:'right',	width: 90, hidden:true }
	            , { field: 'seqNum', 		label: 'Seq No', 	 		sortable: false,	align:'right',	width: 90, hidden:true }
	            , { field: 'helpSeqnum', 	label: '요청구분 Seq', 		sortable: false,	align:'right',	width: 90, hidden:true }
	            , { field: 'tabid', 		label: 'TAB ID', 			sortable: false,	align:'right',	width: 90, hidden:true }
	        ]
	    });
				
	    var purItemGrid = new Rui.ui.grid.LGridPanel({
	        columnModel: itemColumnModel,
	        dataSet: prItemListDataSet,
	        width: 600,
	        height: 400,
	        autoToEdit: false,
	        autoWidth: true
	    });		
	    
	    purItemGrid.render('purItemGridDiv');
		
	    purItemGrid.on('cellClick', function(e) {
			var record = prItemListDataSet.getAt(prItemListDataSet.getRow());
	       	var linkUrl;
	       	
	       	document.aform.banfnPrs.value = record.get("banfnPrs");
	       	
     	    if( record.get("tabid") == "EM" ){
     	    	linkUrl = "<c:url value='/prs/purRq/purRqDetail.do'/>";
	       	}else if( record.get("tabid") == "EF"  ){
	       		linkUrl = "<c:url value='/prs/purRq/purRqLabEquipDetail.do'/>";
	       	}else if( record.get("tabid") == "CR"  ){
	       		linkUrl = "<c:url value='/prs/purRq/purRqWorkDetail.do'/>";
	       	}else if( record.get("tabid") == "OM"  ){
	       		linkUrl = "<c:url value='/prs/purRq/purRqOfficeDetail.do'/>";
	       	}
	       	
	       	nwinsActSubmit(document.aform, linkUrl);
        });   
        
        /* 조회 */
        fnSearch = function() {
        	prItemListDataSet.load({
            url: '<c:url value="/prs/purStts/purSttsSearchList.do"/>',
            params :{
               		fromRegDt : fromRegDt.getValue(),
               		toRegDt : toRegDt.getValue(),
               		posid :  posid.getValue(),
               		txz01 : encodeURIComponent(txz01.getValue()),
               		ekgrp : ekgrp.getValue(),
               		//prsFlag : prsFlag.getValue(),
               		adminChk : "Y"
               		}
            });
        };
		
        fnSearch();


	});
</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
<form name="aform" id="aform" method="post">
<input type="hidden" id="banfnPrs" name="banfnPrs" />

<div class="contents">
	<div class="titleArea">
  		<a class="leftCon" href="#"><img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
  		<span class="hidden">Toggle 버튼</span></a>
  			<h2>구매요청현황</h2>
  	</div>

   	<div class="sub-content">
   		<div class="search">
			<div class="search-content">
  				<table class="myPurRqlist_sch">
   					<colgroup>
   						<col style="width:110px" />
						<col style="width:350px" />
						<col style="width:150px" />
						<col style="width:350px" />
						<col style="" />
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">작성일</th>
    						<td>
   								<input type="text" id="fromRegDt"/><em class="gab"> ~ </em><input type="text" id="toRegDt"/>
    						</td>
   							<th align="right">Project Code</th>
    						<td class="tdin_w100">
    							<input type="text" id=posid name="posid" />
    						</td>
   							<td></td>
   						</tr>
   						<tr>
   							<th align="right">구매그룹</th>
   							<td class="tdin_w100">
   								<select id="ekgrp" name="ekgrp"></select>
   							</td>
   							<th align="right">요청품명</th>
   							<td class="tdin_w100">
   								<input type="text" id="txz01" name="txz01" />
   							</td>
   							<!-- 
   							<th align="right">상태</th>
   							<td>
                                <div id="prsFlag"></div>
   							</td>
   							 -->
   							<td class="txt-right">
   								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>
  				</div>
 				</div>

 				<div class="titArea">
 					<span class="Ltotal" id="cnt_text">총  0건 </span>
 				</div>
 				<div id="purItemGridDiv"></div>
 			</div><!-- //sub-content -->
  		</div><!-- //contents -->
		</form>
    </body>
</html>