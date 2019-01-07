<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: myPurRqList.jsp
 * @desc    : 나의 구매요청 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.12.09  홍상의		최초생성
 * ---	-----------	----------	-----------------------------------------
 * 
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

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
			
             /* 작성일 */
             var fromRegDt = new Rui.ui.form.LDateBox({
 				applyTo: 'fromRegDt',
 				mask: '9999-99-99',
 				defaultValue: '<c:out value="${inputData.fromRegDt}"/>',
 				displayValue: '%Y-%m-%d',
 				editable: false,
 				width: 100,
 				dateType: 'string'
 			});

             fromRegDt.on('blur', function(){
 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromRegDt.getValue(),"-","")) ) )  {
 					alert('날자형식이 올바르지 않습니다.!!');
 					fromRegDt.setValue(new Date());
 				}
 			});

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
     			posid.setValue(wbsInfo.wbsCd);
     			$('#wbsCdName', aform).html(wbsInfo.tssNm);
     		}
     		 
     		/* 납품요청일 */
            var fromPurRqDt = new Rui.ui.form.LDateBox({
 				applyTo: 'fromPurRqDt',
 				mask: '9999-99-99',
 				defaultValue: '<c:out value="${inputData.fromPurRqDt}"/>',
 				displayValue: '%Y-%m-%d',
 				editable: false,
 				width: 100,
 				dateType: 'string'
 			});

            fromPurRqDt.on('blur', function(){
 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromPurRqDt.getValue(),"-","")) ) )  {
 					alert('날자형식이 올바르지 않습니다.!!');
 					fromPurRqDt.setValue(new Date());
 				}
 			});

             var toPurRqDt = new Rui.ui.form.LDateBox({
 				applyTo: 'toPurRqDt',
 				mask: '9999-99-99',
 				defaultValue: '<c:out value="${inputData.toPurRqDt}"/>',
 				displayValue: '%Y-%m-%d',
 				editable: false,
 				width: 100,
 				dateType: 'string'
 			});

             toPurRqDt.on('blur', function(){
 				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toPurRqDt.getValue(),"-","")) ) )  {
 					alert('날자형식이 올바르지 않습니다.!!');
 					toPurRqDt.setValue(new Date());
 				}

 				if( fromPurRqDt.getValue() > toPurRqDt.getValue() ) {
 					alert('시작일이 종료일보다 클 수 없습니다.!!');
 					fromPurRqDt.setValue(toPurRqDt.getValue());
 				}
 			});
             
             
     		/* 요청품명 */
 			var itemnm = new Rui.ui.form.LTextBox({
                applyTo: 'itemnm',
                placeholder: '요청품명을 입력해주세요.',
                defaultValue: '<c:out value="${inputData.itemnm}"/>',
                emptyValue: '',
                width: 400
            });

 			itemnm.on('blur', function(e) {
 				itemnm.setValue(itemnm.getValue().trim());
            });

 			/* 구매그룹 */
 			var ekgrp = new Rui.ui.form.LCombo({
 	            applyTo: 'ekgrp',
 	            width: 200,
 	            useEmptyText: true,
 	            emptyText: '전체',
 	            defaultValue: '<c:out value="${inputData.ekgrp}"/>',
 	            url: '<c:url value="/common/prsCode/retrieveEkgrpInfo.do"/>',
 	            displayField: 'CODE_NM',
 	            valueField: 'CODE',
 	            autoMapping: true
 	        });
 			
 			/* 상태 */ 
 			var prsFlag = new Rui.ui.form.LCombo({
 	            applyTo: 'prsFlag',
 	            width: 200,
 	            useEmptyText: true,
 	            emptyText: '전체',
 	            items : [
 	            	{ value : '0', text : '작성중' },
 	            	{ value : '1', text : '구매진행중' },
 	            	{ value : 'S', text : '구매완료' },
 	            	{ value : '2', text : '반려' },
 	            	{ value : 'E', text : 'ERP전송에러' }
 	            ],
 	            autoMapping: true
 	        });
 			
 			/**
			구매요청 품목 List 시작
			**/
        var prItemListDataSet = new Rui.data.LJsonDataSet({
            id: 'prItemListDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'badate' }		// 작성일	1
                , { id: 'sCode' }     	// 요청구분	
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
        	/* freezeColumnId: 'posid', */
            columns: [
                  new Rui.ui.grid.LSelectionColumn({selectionType: 'radio'})
                , { field: 'badate', 	label: '작성일', 		sortable: false,	align:'center',	width: 80 }
                , { field: 'sCode', 	label: '요청구분', 		sortable: false,	align:'center',	width: 80 }
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
                , { field: 'attcFiles', label: '첨부파일', 	 	sortable: false, width: 200, hidden:true,  
                    renderer: function(val, p, record, row, col) {
                    			return val.replaceAll('\n', '<br/>');
                              }
                  }
                , { field: 'attcFileId', 	label: '첨부파일 Id', 	 	sortable: false,	align:'right',	width: 90, hidden:true }
                , { field: 'banfnPrs', 		label: '구매요청번호', 	 	sortable: false,	align:'right',	width: 90, hidden:false }
                , { field: 'bnfpoPrs', 		label: '구매요청순번', 	 	sortable: false,	align:'right',	width: 90, hidden:false }
                , { field: 'seqNum', 		label: 'Seq No', 	 		sortable: false,	align:'right',	width: 90, hidden:false }
                , { field: 'sCodeSeq', 		label: '요청구분 Seq', 		sortable: false,	align:'right',	width: 90, hidden:true }
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

        /* 조회 */
        getMyPurRqList = function() {
        	prItemListDataSet.load({
            url: '<c:url value="/prs/purRq/myPurRqList.do"/>',
             params :{
               		fromRegDt : fromRegDt.getValue(),
               		toRegDt : toRegDt.getValue(),
               		wbsCd : posid.getValue(),
               		fromPurRqDt : fromPurRqDt.getValue(),
               		toPurRqDt : toPurRqDt.getValue(),
               		itemnm : escape(encodeURIComponent(itemnm.getValue())),
               		ekgrp : ekgrp.getValue(),
               		prsFlag : prsFlag.getValue()
               		}
            });
        };

        prItemListDataSet.on('load', function(e) {
    		$("#cnt_text").html('총 ' + prItemListDataSet.getCount() + '건');
     		// 목록 페이징
  	    	aCnt =20;
    		paging(prItemListDataSet,"purItemGrid");
      	});
     });
	</script>
	<%-- <script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script> --%>
    </head>
    <body onkeypress="if(event.keyCode==13) {getMyPurRqList();}" onload="init();">
	<form name="aform" id="aform" method="post">
   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
   				<h2>My 구매요청 내역</h2>
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
		   								<input type="text" id="fromRegDt"/><em class="gab"> ~ </em>
		   								<input type="text" id="toRegDt"/>
		    						</td>
		   							<th align="right">WBS요소(Project Code)</th>
		    						<td class="tdin_w100">
		    							<input type="text" class="" id=wbsCd name="wbsCd" value="" >&nbsp;<span id="wbsCdName" name="wbsCdName"></span>
		    						</td>
		   							<td></td>
		   						</tr>
		   						<tr>
		   							<th align="right">납품요청일</th>
		    						<td>
		   								<input type="text" id="fromPurRqDt"/><em class="gab"> ~ </em>
		   								<input type="text" id="toPurRqDt"/>
		    						</td>
		   							<th align="right">요청품명</th>
		   							<td class="tdin_w100">
		   								<input type="text" id="itemnm" name="itemnm" />
		   							</td>
		    						<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getMyPurRqList();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   						<tr>
		   							<th align="right">구매담당</th>
		   							<td class="tdin_w100">
		   								<select id="ekgrp" name="ekgrp"></select>
		   							</td>
		   							<th align="right">상태</th>
		   							<td>
		                                <div id="prsFlag"></div>
		   							</td>
		   							<td></td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="rgstBtn" name="rgstBtn" onclick="goAnlRqprRgst()">수정</button>
   					</div>
   				</div>

   				<div id="purItemGridDiv"></div>
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>