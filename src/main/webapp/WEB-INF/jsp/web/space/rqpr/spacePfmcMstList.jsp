<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spacePfmcMstList.jsp
 * @desc    : 공간평가 성능 마스터 리스트 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.14   		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/tree/rui_tree.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tree/rui_tree.css"/>
<script type="text/javascript" src="<%=ruiPathPlugins%>/data/LDataSetView.js"></script>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>


    <style type="text/css" >

    </style>
	<script type="text/javascript">

		Rui.onReady(function() {
            /*******************
            * 변수 및 객체 선언
            *******************/
            //데이터셋
            //사업부
            var spaceEvBzdvDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvBzdvDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                   { id: 'ctgrCd' }
                 , { id: 'ctgrNm' }
                ]
            });
            //제품군
            var spaceEvProdClDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvProdClDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                   { id: 'ctgrCd' }
                 , { id: 'ctgrNm' }
                ]
            });
            //분류
            var spaceEvClDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvClDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                   { id: 'ctgrCd' }
                 , { id: 'ctgrNm' }
                ]
            });

            //combo
            /*사업부 조회*/

            spaceEvBzdvDataSet.load({
                url: '<c:url value="/space/spaceEvBzdvList.do"/>'
            });

            var cmbCtgr0Cd = new Rui.ui.form.LCombo({
                applyTo: 'cmbCtgr0Cd',
                name: 'cmbCtgr0Cd',
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                dataSet: spaceEvBzdvDataSet,
                displayField: 'ctgrNm',
                valueField: 'ctgrCd'
            });

            cmbCtgr0Cd.on('changed', function(e) {
            	//제품군 초기화
            	spaceEvProdClDataSet.clearData();
            	//분류 초기화
            	spaceEvClDataSet.clearData();
                var selectctgr0Cd = cmbCtgr0Cd.getValue();
                spaceEvProdClDataSet.load({
                	url: '<c:url value="/space/spaceEvProdClList.do"/>',
                    params :{ supiCd:selectctgr0Cd }
                });
            });
            /*사업부 조회 끝*/


            /*제품군 조회*/
            /* spaceEvProdClDataSet.load({
                url: '<c:url value="/space/spaceEvProdClList.do"/>'
            }); */

            var cmbCtgr1Cd = new Rui.ui.form.LCombo({
                applyTo: 'cmbCtgr1Cd',
                name: 'cmbCtgr1Cd',
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                dataSet: spaceEvProdClDataSet,
                displayField: 'ctgrNm',
                valueField: 'ctgrCd'
            });

            cmbCtgr1Cd.on('changed', function(e) {
            	//분류 초기화
            	spaceEvClDataSet.clearData();
                var selectctgr1Cd = cmbCtgr1Cd.getValue();
                spaceEvClDataSet.load({
                	url: '<c:url value="/space/spaceEvClList.do"/>',
                    params :{ supiCd:selectctgr1Cd }
                });
            });
            /*제품군 조회 끝*/

            /*분류 조회*/

            /* spaceEvProdClDataSet.load({
                url: '<c:url value="/space/spaceEvProdClList.do"/>'
            }); */

            var cmbCtgr2Cd = new Rui.ui.form.LCombo({
                applyTo: 'cmbCtgr2Cd',
                name: 'cmbCtgr2Cd',
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                dataSet: spaceEvClDataSet,
                displayField: 'ctgrNm',
                valueField: 'ctgrCd'
            });
            /*제품군 조회 끝*/

            //제품명
	        var txtCtgr3Nm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	            applyTo: 'txtCtgr3Nm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	            width: 200,                                    // 텍스트박스 폭을 설정
	            defaultValue: '<c:out value="${inputData.txtCtgr3Nm}"/>',
	            emptyValue: '',
	            placeholder: ''     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        });
	        txtCtgr3Nm.on('blur', function(e) {
	        	txtCtgr3Nm.setValue(txtCtgr3Nm.getValue().trim());
            });

            /* 제품목록 데이터셋 */
            var spaceEvProdListDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvProdListDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'ctgr0Cd' }
                	, { id: 'ctgr1Cd' }
                	, { id: 'ctgr2Cd' }
                	, { id: 'ctgr3Cd' }
                	, { id: 'ctgr0Nm' }
                	, { id: 'ctgr1Nm' }
                	, { id: 'ctgr2Nm' }
                	, { id: 'ctgr3Nm' }
                ]
            });

            var spaceEvProdColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
					{ field: 'ctgr0Cd',			hidden : true}
					, { field: 'ctgr1Cd',			hidden : true}
					, { field: 'ctgr2Cd',			hidden : true}
					, { field: 'ctgr3Cd',			hidden : true}
                	, { field: 'ctgr0Nm',		label: '사업부',		sortable: false,	editable: false,		align:'left',	width: 327 }
                	, { field: 'ctgr1Nm',		label: '제품군',		sortable: false,	editable: false,		align:'left',	width: 327 }
                	, { field: 'ctgr2Nm',		label: '분류',		sortable: false,	editable: false,		align:'left',	width: 327 }
                	, { field: 'ctgr3Nm',		label: '제품',		sortable: false,	editable: false,		align:'left',	width: 327 }
                ]
            });

            var spaceEvProdGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvProdColumnModel,
                dataSet: spaceEvProdListDataSet,
                width: 810,
                height: 290,
                autoToEdit: true,
                autoWidth: true
            });

            spaceEvProdGrid.render('spaceEvProdGrid');

            /* 제품클릭 성적서 조회 */
            spaceEvProdGrid.on('cellClick', function(e) {
            	//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
            	spaceRqprRsltDataSet.clearData();

            	var record0 = spaceEvProdListDataSet.getAt(spaceEvProdListDataSet.rowPosition);
            	var supiCd0 = record0.data.ctgr0Cd;
            	var supiCd1 = record0.data.ctgr1Cd;
            	var supiCd2 = record0.data.ctgr2Cd;
            	var supiCd3 = record0.data.ctgr3Cd;
            	spaceEvMtrlListDataSet.load({
                    url: '<c:url value="/space/spaceEvMtrlList.do"/>',
                    params :{ supiCd0:supiCd0
                    	     ,supiCd1:supiCd1
                    	     ,supiCd2:supiCd2
                    	     ,supiCd3:supiCd3
                    	    }
                });
            	spaceRqprRsltDataSet.load({
                    url: '<c:url value="/space/spaceRqprRsltList.do"/>',
                    params :{ supiCd0:supiCd0
                    	     ,supiCd1:supiCd1
                    	     ,supiCd2:supiCd2
                    	     ,supiCd3:supiCd3
                    	    }
                });
            });

            /* 자재단위평가 데이터셋 */
            var spaceEvMtrlListDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvMtrlListDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'ctgr0' }
                	, { id: 'ctgr1' }
                	, { id: 'ctgr2' }
                	, { id: 'ctgr3' }
                	, { id: 'prodNm' }
                	, { id: 'scn' }
					, { id: 'pfmcVal' }
					, { id: 'frstRgstDt' }
					, { id: 'strtVldDt' }
					, { id: 'fnhVldDt' }
					, { id: 'ottpYn' }
					, { id: 'attcFilId' }
					, { id: 'rem' }
					, { id: 'evCd' }
                ]
            });

          	//자재단위평가 그리드 컬럼 설정
            var spaceEvMtrlListModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'ctgr0',			hidden : true}
                	, { field: 'ctgr1',			hidden : true}
                	, { field: 'ctgr2',			hidden : true}
                	, { field: 'ctgr3',			hidden : true}
                	, { field: 'prodNm',		hidden : true}
                	, { field: 'evCd',			hidden : true}
                	, { field: 'scn',			label: '구분',		sortable: false,	editable: false, 	align:'center',	width: 200 }
                    , { field: 'pfmcVal',		label: '성능값',		sortable: false,	editable: false, 	align:'center',	width: 180 }
                    , { field: 'frstRgstDt',	label: '등록일',		sortable: false,	editable: false, 	align:'center',	width: 180 }
                    , { field: 'strtVldDt',		label: '유효시작일',		sortable: false,	editable: false, 	align:'center',	width: 170 }
                    , { field: 'fnhVldDt',		label: '유효종료일',		sortable: false,	editable: false, 	align:'center',	width: 170 }
                    , { field: 'ottpYn',		label: '공개여부',		sortable: false,	editable: false, 	align:'center',	width: 170 }
                    , { id: 'attachDownBtn',  label: '첨부',                                          width: 83
                    	,renderer: function(val, p, record, row, i){
  		  	    		  if(!record.get('attcFilId')||record.get('attcFilId').length<1){
  		  	    			  return '';
  		  	    		  }else{
  		  	    			  return '<button type="button"  class="L-grid-button" >다운로드</button>';
  		  	    		  }
  		  	    		 }
                      }
                    , { field: 'rem',			label: '비고',		sortable: false,	editable: false, 	align:'center',	width: 155 }
                    , { field: 'attcFilId',	hidden : true}

                ]
            });

          	//성적서,인증서(자재단위) 그리드 패널 설정
            var spaceEvMtrlListGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvMtrlListModel,
                dataSet: spaceEvMtrlListDataSet,
                width: 600,
                height: 150,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvMtrlListGrid.render('spaceEvMtrlListGrid');

            spaceEvMtrlListGrid.on('cellClick',function(e){
            	if(e.colId=="attachDownBtn"){
            		var recordData=spaceEvMtrlListDataSet.getAt(spaceEvMtrlListDataSet.rowPosition);
            		var attcFilId=recordData.data.attcFilId;
            		var ottpYn=recordData.data.ottpYn;
            		if(!attcFilId||attcFilId.length<1){
            			return;
            		}else{
            			if(ottpYn=='Y'){
	            			var param = "?attcFilId=" + attcFilId;
	             	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
	             	       	document.aform.submit();
            			}else{
            				fncRq();
            			}
            		}
            	}
            });

			//////////////////////////////// 통합성능평가결과서부분/////////////////////////////////
            var spaceRqprRsltDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprRsltDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
					  { id: 'spaceNm' }
					, { id: 'CtrgNames' }
					, { id: 'PrvsNames' }
					, { id: 'cmplDt' }
					, { id: 'ottpYn' }
					, { id: 'rsltAttcFileId' }
					, { id: 'rgstNm' }
					, { id: 'rem' }
					, { id: 'prodId'}
					, { id: 'rqprId'}
					, { id: 'evCtgr0'}
					, { id: 'evCtgr1'}
					, { id: 'evCtgr2'}
					, { id: 'evCtgr3'}
					, { id: 'evCtgr0Nm'}
					, { id: 'evCtgr1Nm'}
					, { id: 'evCtgr2Nm'}
					, { id: 'evCtgr3Nm'}
                ]
            });

            var spaceRqprRsltColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'spaceNm',	label: '제목',		sortable: false,	align:'left',	width: 370 }
                    , { field: 'CtrgNames',			label: '평가카테고리',		sortable: false,	align:'center',	width: 180 }
                    , { field: 'PrvsNames',			label: '평가항목',		sortable: false,	align:'center',	width: 180 }
                    , { field: 'cmplDt',		label: '등록일',		sortable: false,	align:'center',	width: 180 }
                    , { field: 'ottpYn',	label: '공개여부',		sortable: false,	align:'center',	width: 120 }
                    , { id: 'attachDownBtn',  label: '첨부',                                          width: 100
                    	,renderer: function(val, p, record, row, i){
  		  	    		  if(!record.get('rsltAttcFileId')||record.get('rsltAttcFileId').length<1){
  		  	    			  return '';
  		  	    		  }else{
  		  	    			  return '<button type="button"  class="L-grid-button" >다운로드</button>';
  		  	    		  }
  		  	    		 }
                      }
                    , { field: 'rgstNm',	label: '작성자',		sortable: false,	align:'center',	width: 100 }
                    , { field: 'rem',	label: '비고',		sortable: false,	align:'center',	width: 78 }
                    , { field: 'rsltAttcFileId',	hidden : true}
                    , { field: 'prodId'		,	hidden : true}
					, { field: 'rqprId'		,	hidden : true}
					, { field: 'evCtgr0'	,	hidden : true}
					, { field: 'evCtgr1'	,	hidden : true}
					, { field: 'evCtgr2'	,	hidden : true}
					, { field: 'evCtgr3'	,	hidden : true}
					, { field: 'evCtgr0Nm'	,	hidden : true}
					, { field: 'evCtgr1Nm'	,	hidden : true}
					, { field: 'evCtgr2Nm'	,	hidden : true}
					, { field: 'evCtgr3Nm'	,	hidden : true}
                ]
            });

            var spaceRqprRsltGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprRsltColumnModel,
                dataSet: spaceRqprRsltDataSet,
                width: 400,
                height: 150,
                autoToEdit: false,
                autoWidth: true
            });

            spaceRqprRsltGrid.render('spaceRqprRsltGrid');

            spaceRqprRsltGrid.on('cellClick',function(e){
            	if(e.colId=="attachDownBtn"){
            		var recordData=spaceRqprRsltDataSet.getAt(spaceRqprRsltDataSet.rowPosition);
            		var attcFilId=recordData.data.rsltAttcFileId;
            		var ottpYn=recordData.data.ottpYn;
            		if(!attcFilId||attcFilId.length<1){
            			return;
            		}else{
            			if(ottpYn=='Y'){
	            			var param = "?attcFilId=" + attcFilId;
	             	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
	             	       	document.aform.submit();
            			}else{
            				fncRq2();
            			}
            		}
            	}
            });

            /////////////////////////////////////////////////////////////////////////////////////////
            retrieveRequestInfoDialog = new Rui.ui.LFrameDialog({
     	        id: 'retrieveRequestInfoDialog',
     	        title: '조회 요청',
     	        width: 850,
     	        height: 400,
     	        modal: true,
     	        visible: false
     	    });

     	    retrieveRequestInfoDialog.render(document.body);

     	    fncRq = function(){
     	    	var record = spaceEvMtrlListDataSet.getAt(spaceEvMtrlListDataSet.rowPosition);
     	    	var rqDocNm 	= record.data.prodNm + " > 성적서,인증서(자재단위) > "+record.data.scn;
     	    	var rtrvRqDocCd = "SPACE";
     	    	var docNo 		= spaceEvMtrlListDataSet.getNameValue(spaceEvMtrlListDataSet.rowPosition, "attcFilId");
     	    	var pgmPath 	= "Technical Service > 공간평가 > 성능 Master";
     	    	var rgstId 		= '${inputData._userId}';
     	    	var rgstNm 		= '${inputData._userNm}';
     	    	var reUrl 		= '/system/attach/downloadAttachFile.do';

         	   var params = '?rqDocNm=' + escape(encodeURIComponent(rqDocNm))
    					   + '&rtrvRqDocCd=' + rtrvRqDocCd
    					   + '&docNo=' + docNo
    					   + '&pgmPath=' + escape(encodeURIComponent(pgmPath))
    					   + '&rgstId=' + rgstId
    					   + '&docUrl=' + reUrl
    					   + '&rgstNm=' + escape(encodeURIComponent(rgstNm))
    					   ;
     	    	if(Rui.isEmpty(rgstId)){
     	    		Rui.alert("해당내용은 담당자 부재로 관리자에게 문의하세요");
     	    		return ;
     	    	}

	     	    retrieveRequestInfoDialog.setUrl('<c:url value="/knld/rsst/retrieveRequestInfo.do"/>' + params);
		    	retrieveRequestInfoDialog.show();
     	    }

     	   fncRq2 = function(){
    	    	var record = spaceRqprRsltDataSet.getAt(spaceRqprRsltDataSet.rowPosition);
    	    	var rqDocNm 	= record.data.evCtgr0Nm + " > "+record.data.evCtgr1Nm+" > "+record.data.evCtgr2Nm+" > "+record.data.evCtgr3Nm+ " > 통합성능평가 결과서 > "+record.data.spaceNm;
    	    	var rtrvRqDocCd = "SPACE";
    	    	var docNo 		= spaceRqprRsltDataSet.getNameValue(spaceRqprRsltDataSet.rowPosition, "rsltAttcFileId");
    	    	var pgmPath 	= "Technical Service > 공간평가 > 성능 Master";
    	    	var rgstId 		= '${inputData._userId}';
    	    	var rgstNm 		= '${inputData._userNm}';
    	    	var reUrl 		= '/system/attach/downloadAttachFile.do';

        	   var params = '?rqDocNm=' + escape(encodeURIComponent(rqDocNm))
   					   + '&rtrvRqDocCd=' + rtrvRqDocCd
   					   + '&docNo=' + docNo
   					   + '&pgmPath=' + escape(encodeURIComponent(pgmPath))
   					   + '&rgstId=' + rgstId
   					   + '&docUrl=' + reUrl
   					   + '&rgstNm=' + escape(encodeURIComponent(rgstNm))
   					   ;
    	    	if(Rui.isEmpty(rgstId)){
    	    		Rui.alert("해당내용은 담당자 부재로 관리자에게 문의하세요");
    	    		return ;
    	    	}

	     	    retrieveRequestInfoDialog.setUrl('<c:url value="/knld/rsst/retrieveRequestInfo.do"/>' + params);
		    	retrieveRequestInfoDialog.show();
    	    }

            //검색
            getSpaceEvProdList = function() {
            	spaceEvProdListDataSet.load({
                    url: '<c:url value="/space/getSpacePfmcMstList.do"/>',
                    params :{
                    	cmbCtgr0 : document.aform.cmbCtgr0Cd.value
                    	, cmbCtgr1 : document.aform.cmbCtgr1Cd.value
                    	, cmbCtgr2 : document.aform.cmbCtgr2Cd.value
                    	, ctgr3Nm : encodeURIComponent(document.aform.txtCtgr3Nm.value)
                    }
                });
            };

            //이유지 선임 요청으로 화면로딩시 조회 안되게 수정
            //getSpaceEvProdList();


            /* 통합성능평가결과서 리스트 엑셀 다운로드 */
        	downloadSpaceRqprRsltExcel = function() {
        		// 엑셀 다운로드시 전체 다운로드를 위해 추가
				spaceEvProdGrid.saveExcel(encodeURIComponent('통합성능평가결과서_') + new Date().format('%Y%m%d') + '.xls');
            };

            /* 성적서 인증서 리스트 엑셀 다운로드 */
        	downloadSpaceRqprRsltExcel = function() {
        		// 엑셀 다운로드시 전체 다운로드를 위해 추가
				spaceEvMtrlListGrid.saveExcel(encodeURIComponent('성적서,인증서(자재단위)_') + new Date().format('%Y%m%d') + '.xls');
            };


        });

	</script>
    </head>
    <body onkeypress="if(event.keyCode==13) {getSpaceEvProdList();}">
	<form name="aform" id="aform" method="post" onSubmit="return false;">

   		<div class="contents">
			<div class="titleArea">
				<a class="leftCon" href="#">
	        		<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	        		<span class="hidden">Toggle 버튼</span>
        		</a>
				<h2>성능 Master</h2>
			</div>
			<div class="sub-content">
   			<form name="aform" id="aform" method="post">
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" />
					<div class="search">
					<div class="search-content">
   				<table>
   					<tbody>
   						<tr>
   							<td>
   								<select id="cmbCtgr0Cd"></select>
   								<select id="cmbCtgr1Cd"></select>
   								<select id="cmbCtgr2Cd"></select>
   								<input type="text" id="txtCtgr3Nm" />

   							</td>
   							<td class="txt-right">
   							<a style="cursor: pointer;" onclick="getSpaceEvProdList();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
   				</div>

	   			<div class="titArea">
		   			<span class="Ltotal"><h3>제품목록</h3></span>
   				</div>

			    <div id="spaceEvProdGrid"></div>
</form>
   				<div class="titArea">
   					<span class="Ltotal" style="line-height:31px"><h3>통합성능평가결과서</h3> &nbsp;&nbsp;
   					<font color="red">○비밀 문서의 경우, 해당 팀장님의 결재를 받고 별도 다운로드 가능합니다.</font></span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadSpaceRqprRsltExcel()">Excel</button>
   					</div>
   				</div>

			    <div id="spaceRqprRsltGrid"></div>

   				<div class="titArea">
   					<span class="Ltotal"><h3>성적서, 인증서(자재단위)</h3></span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadSpaceRqprRsltExcel()">Excel</button>
   					</div>
   				</div>

			    <div id="spaceEvMtrlListGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>