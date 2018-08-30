<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceEvaluationMgmt.jsp
 * @desc    : 공간평가 평가법관리 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.02  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 2차 프로젝트
 *************************************************************************
 */
--%>
				 
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">
	var ctgrNm01="";
	var ctgrNm02="";
	var ctgrNm03="";
	var ctgrNm04="";
	var ctgr0="";
	var ctgr1="";
	var ctgr2="";
	var ctgr3="";
		Rui.onReady(function() {
			
            /*******************
             * 변수 및 객체 선언
            *******************/
            var textBox = new Rui.ui.form.LTextBox({
                emptyValue: ''
            });
            
            
            /* 사업부 데이터셋 */
            var spaceEvBzdvDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvBzdvDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                      { id: 'ctgrCd' }
     				, { id: 'ctgrNm' }
                ]
            });
            
            /* 제품군 데이터셋 */
            var spaceEvProdClDataSet = new Rui.data.LJsonDataSet({
            	id: 'spaceEvProdClDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                      { id: 'supiCd' }
     				, { id: 'ctgrCd' }
     				, { id: 'ctgrNm' }
                ]
            });
            
            /* 분류 데이터셋 */
            var spaceEvClDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvClDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'supiCd' }
					, { id: 'ctgrCd' }
					, { id: 'ctgrNm' }
                ]
            });
            
            /* 제품 데이터셋 */
            var spaceEvProdDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvProdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'supiCd' }
					, { id: 'ctgrCd' }
					, { id: 'ctgrNm' }
                ]
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
            
            //사업부 그리드 컬럼 설정
            var spaceEvBzdvModel = new Rui.ui.grid.LColumnModel({
                columns: [
						new Rui.ui.grid.LStateColumn()
                	, { field: 'ctgrCd',	label: '코드',		sortable: false,	editable: false, 	align:'center',	width: 80 }
                    , { field: 'ctgrNm',	label: '제품군',		sortable: false,	editable: true, editor: new Rui.ui.form.LTextBox() ,	align:'center',	width: 200 }
                ]
            });
          	
            //제품군 그리드 컬럼 설정
            var spaceEvProdClModel = new Rui.ui.grid.LColumnModel({
                columns: [
  						new Rui.ui.grid.LStateColumn()
                	, { field: 'supiCd',	label: '상위코드',	sortable: false,	editable: false, 	align:'center',	width: 80 }
                    , { field: 'ctgrCd',	label: '코드',		sortable: false,	editable: false, 	align:'center',	width: 80 }
                    , { field: 'ctgrNm',	label: '제품군',		sortable: false,	editable: true, editor: new Rui.ui.form.LTextBox() ,	align:'center',	width: 200 }
                ]
            });
            
          	//분류 그리드 컬럼 설정
            var spaceEvClModel = new Rui.ui.grid.LColumnModel({
                columns: [
    						new Rui.ui.grid.LStateColumn()
                	, { field: 'supiCd',	label: '상위코드',	sortable: false,	editable: false, 	align:'center',	width: 80 }
                    , { field: 'ctgrCd',	label: '코드',		sortable: false,	editable: false, 	align:'center',	width: 80 }
                    , { field: 'ctgrNm',	label: '제품군',		sortable: false,	editable: true, editor: new Rui.ui.form.LTextBox() ,	align:'center',	width: 200 }
                ]
            });
          
          	//제품 그리드 컬럼 설정
            var spaceEvProdModel = new Rui.ui.grid.LColumnModel({
                columns: [
  						new Rui.ui.grid.LStateColumn()
                	, { field: 'supiCd',	label: '상위코드',	sortable: false,	editable: false, 	align:'center',	width: 80 }
                    , { field: 'ctgrCd',	label: '코드',		sortable: false,	editable: false, 	align:'center',	width: 80 }
                    , { field: 'ctgrNm',	label: '제품군',		sortable: false,	editable: true, editor: new Rui.ui.form.LTextBox() ,	align:'center',	width: 200 }
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
                	, { field: 'evCd',		hidden : true}
                	, { field: 'attcFilId',	hidden : true}
                	, { field: 'scn',			label: '구분',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'pfmcVal',		label: '성능값',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'frstRgstDt',	label: '등록일',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'strtVldDt',		label: '유효시작일',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'fnhVldDt',		label: '유효종료일',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 200 }
                    , { field: 'ottpYn',		label: '공개여부',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 100 }
                    , { id: 'attachDownBtn',  label: '첨부',                                          width: 65
                    	,renderer: function(val, p, record, row, i){
  		  	    		  if(!record.get('attcFilId')||record.get('attcFilId').length<1){
  		  	    			  return '';
  		  	    		  }else{
  		  	    			  return '<button type="button"  class="L-grid-button" >다운로드</button>';
  		  	    		  } 
  		  	    		 }
                      } 
                    , { field: 'rem',			label: '비고',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 200 }
                ]
            });
            /* strBtnFun = function(){
            	alert(1);
            	var record = spaceEvMtrlListDataSet.getAt(spaceEvMtrlListDataSet.rowPosition);
	            var attId = record.data.attcFilId;
            	var param = "?attcFilId=" + attId;
     	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
     	       	document.aform.submit();
            } */
            
            //사업부 그리드 패널 설정
            var spaceEvBzdvGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvBzdvModel,
                dataSet: spaceEvBzdvDataSet,
                width: 200,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvBzdvGrid.render('spaceEvBzdvGrid');
            
            //제품군 그리드 패널 설정
            var spaceEvProdClGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvProdClModel,
                dataSet: spaceEvProdClDataSet,
                width: 200,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvProdClGrid.render('spaceEvProdClGrid');
            
            //분류 그리드 패널 설정
            var spaceEvClGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvClModel,
                dataSet: spaceEvClDataSet,
                width: 200,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvClGrid.render('spaceEvClGrid');
            
            //제품 그리드 패널 설정
            var spaceEvProdGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvProdModel,
                dataSet: spaceEvProdDataSet,
                width: 200,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvProdGrid.render('spaceEvProdGrid');
            
            //자재단위평가 그리드 패널 설정
            var spaceEvMtrlListGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceEvMtrlListModel,
                dataSet: spaceEvMtrlListDataSet,
                width: 600,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });
            spaceEvMtrlListGrid.render('spaceEvMtrlListGrid');
            
            spaceEvMtrlListGrid.on('cellClick',function(e){
            	if(e.colId=="attachDownBtn"){
            		var recordData=spaceEvMtrlListDataSet.getAt(spaceEvMtrlListDataSet.rowPosition);
            		var attcFilId=recordData.data.attcFilId;
            		if(!attcFilId||attcFilId.length<1){
            			return;
            		}else{
            			var param = "?attcFilId=" + attcFilId;
             	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
             	       	document.aform.submit();
            		}         		
            	}
            });
            
            /* 사업부 조회 */
            getSpaceEvBzdvList = function() {
            	spaceEvBzdvDataSet.load({
                    url: '<c:url value="/space/spaceEvBzdvList.do"/>'
                });
            };
            //화면 로딩시 조회
            getSpaceEvBzdvList();
            
            
            
            /* 사업부 그리드 클릭 -> 제품군 조회 */
            spaceEvBzdvGrid.on('cellClick', function(e) {
            	ctgr1List();
            });
            
            
            /* 제품군 그리드 클릭 -> 분류 조회 */
            spaceEvProdClGrid.on('cellClick', function(e) {
            	ctgr2List();
            });
            
            
            /* 분류 그리드 클릭 -> 제품 조회 */
            spaceEvClGrid.on('cellClick', function(e) {
            	ctgr3List();
            });
            
            /* 제품 그리드 클릭 -> 상세목록 조회 */
            spaceEvProdGrid.on('cellClick', function(e) {
            	mtrlList();
            });
            
          	//제품군조회
            ctgr1List = function(){
            	//제품군 초기화
            	spaceEvProdClDataSet.clearData();
            	//분류 초기화
            	spaceEvClDataSet.clearData();
				//제품 초기화
            	spaceEvProdDataSet.clearData();
				//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
            	//var record = spaceEvBzdvDataSet.getAt(e.row);
            	if(spaceEvBzdvDataSet.getState(spaceEvBzdvDataSet.rowPosition)==1){
            		return;	
            	}
            	
            	var record = spaceEvBzdvDataSet.getAt(spaceEvBzdvDataSet.rowPosition);
            	var supiCd = record.data.ctgrCd;
            	ctgrNm01 =record.data.ctgrNm;
            	ctgrNm02 ="";
            	ctgrNm03 ="";
            	ctgrNm04 ="";
            	ctgr0=supiCd;
            	ctgr1="";
            	ctgr2="";
            	ctgr3="";
            	//제품군 조회
            	spaceEvProdClDataSet.load({
                    url: '<c:url value="/space/spaceEvProdClList.do"/>',
                    params :{ supiCd:supiCd }
                });
            	spaceEvMtrlListDataSet.load({
                    url: '<c:url value="/space/spaceEvMtrlList.do"/>',
                    params :{  supiCd0:supiCd 
                    	    }
                });
            }
          	//분류조회
            ctgr2List = function(){
            	//분류 초기화
            	spaceEvClDataSet.clearData();
            	//제품 초기화
            	spaceEvProdDataSet.clearData();
				//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
				
            	var record0 = spaceEvBzdvDataSet.getAt(spaceEvBzdvDataSet.rowPosition);
            	var supiCd0 = record0.data.ctgrCd;
            	var record = spaceEvProdClDataSet.getAt(spaceEvProdClDataSet.rowPosition);
            	var supiCd = record.data.ctgrCd;
            	ctgrNm01 =record0.data.ctgrNm;
            	ctgrNm02 =record.data.ctgrNm;
            	ctgrNm03 ="";
            	ctgrNm04 ="";
            	ctgr0=supiCd0;
            	ctgr1=supiCd;
            	ctgr2="";
            	ctgr3="";
            	if(spaceEvProdClDataSet.getState(spaceEvProdClDataSet.rowPosition)==1){
            		return;	
            	}
            	spaceEvClDataSet.load({
                    url: '<c:url value="/space/spaceEvClList.do"/>',
                    params :{ supiCd:supiCd }
                });
            	spaceEvMtrlListDataSet.load({
                    url: '<c:url value="/space/spaceEvMtrlList.do"/>',
                    params :{  supiCd0:supiCd0
                    	     , supiCd1:supiCd
                    	    }
                });
            }
            //제품조회
            ctgr3List = function(){
            	//제품 초기화
            	spaceEvProdDataSet.clearData();
            	//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
            	
            	var record0 = spaceEvBzdvDataSet.getAt(spaceEvBzdvDataSet.rowPosition);
            	var supiCd0 = record0.data.ctgrCd;
            	var record1 = spaceEvProdClDataSet.getAt(spaceEvProdClDataSet.rowPosition);
            	var supiCd1 = record1.data.ctgrCd;
            	var record = spaceEvClDataSet.getAt(spaceEvClDataSet.rowPosition);
            	var supiCd = record.data.ctgrCd;
            	ctgrNm01 =record0.data.ctgrNm;
            	ctgrNm02 =record1.data.ctgrNm;
            	ctgrNm03 =record.data.ctgrNm;
            	ctgrNm04 ="";
            	ctgr0=supiCd0;
            	ctgr1=supiCd1;
            	ctgr2=supiCd;
            	ctgr3="";
            	
            	if(spaceEvClDataSet.getState(spaceEvClDataSet.rowPosition)==1){
            		return;	
            	}
            	
            	spaceEvProdDataSet.load({
                    url: '<c:url value="/space/spaceEvProdList.do"/>',
                    params :{ supiCd:supiCd }
                });
            	spaceEvMtrlListDataSet.load({
                    url: '<c:url value="/space/spaceEvMtrlList.do"/>',
                    params :{  supiCd0:supiCd0
                    	     , supiCd1:supiCd1
                    	     , supiCd2:supiCd
                    	    }
                });
            }
            
            //성적서조회
            mtrlList = function(){
            	//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
            	
            	var record0 = spaceEvBzdvDataSet.getAt(spaceEvBzdvDataSet.rowPosition);
            	var supiCd0 = record0.data.ctgrCd;
            	var record1 = spaceEvProdClDataSet.getAt(spaceEvProdClDataSet.rowPosition);
            	var supiCd1 = record1.data.ctgrCd;
            	var record2 = spaceEvClDataSet.getAt(spaceEvClDataSet.rowPosition);
            	var supiCd2 = record2.data.ctgrCd;
            	var record3 = spaceEvProdDataSet.getAt(spaceEvProdDataSet.rowPosition);
            	var supiCd3 = record3.data.ctgrCd;
            	ctgrNm01 =record0.data.ctgrNm;
            	ctgrNm02 =record1.data.ctgrNm;
            	ctgrNm03 =record2.data.ctgrNm;
            	ctgrNm04 =record3.data.ctgrNm;
            	ctgr0=supiCd0;
            	ctgr1=supiCd1;
            	ctgr2=supiCd2;
            	ctgr3=supiCd3;
            	if(spaceEvProdDataSet.getState(spaceEvProdDataSet.rowPosition)==1){
            		return;	
            	}
            	spaceEvMtrlListDataSet.load({
                    url: '<c:url value="/space/spaceEvMtrlList.do"/>',
                    params :{ supiCd0:supiCd0
                    	     ,supiCd1:supiCd1
                    	     ,supiCd2:supiCd2
                    	     ,supiCd3:supiCd3
                    	    }
                });
            }
            
            /* 사업부 추가 */
            addStep0 = function() {
            	//제품군 초기화
            	spaceEvProdClDataSet.clearData();
            	//분류 초기화
            	spaceEvClDataSet.clearData();
				//제품 초기화
            	spaceEvProdDataSet.clearData();
				//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
				
            	spaceEvBzdvDataSet.newRecord();
            	
            };
            
            /* 제품군 추가 */
            addStep1 = function() {
            	//분류 초기화
            	spaceEvClDataSet.clearData();
				//제품 초기화
            	spaceEvProdDataSet.clearData();
				//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
				if(spaceEvBzdvDataSet.getValue(spaceEvBzdvDataSet.rowPosition,0)==""||spaceEvBzdvDataSet.getValue(spaceEvBzdvDataSet.rowPosition,0)==undefined){
					alert("먼저 사업부를 선택해 주세요.");
					return;
				}
            	spaceEvProdClDataSet.newRecord();
            	spaceEvProdClDataSet.setValue(spaceEvProdClDataSet.rowPosition,0,spaceEvBzdvDataSet.getValue(spaceEvBzdvDataSet.rowPosition,0));
            };
            
            /* 분류 추가 */
            addStep2 = function() {
				//제품 초기화
            	spaceEvProdDataSet.clearData();
				//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
            	if(spaceEvProdClDataSet.getValue(spaceEvProdClDataSet.rowPosition,1)==""||spaceEvProdClDataSet.getValue(spaceEvProdClDataSet.rowPosition,1)==undefined){
					alert("먼저 제품군를 선택해 주세요.");
					return;
				}
            	spaceEvClDataSet.newRecord();
            	spaceEvClDataSet.setValue(spaceEvClDataSet.rowPosition,0,spaceEvProdClDataSet.getValue(spaceEvProdClDataSet.rowPosition,1));
            };
            
            /* 제품 추가 */
            addStep3 = function() {
				//성적서정보 초기화
            	spaceEvMtrlListDataSet.clearData();
            	if(spaceEvClDataSet.getValue(spaceEvClDataSet.rowPosition,1)==""||spaceEvClDataSet.getValue(spaceEvClDataSet.rowPosition,1)==undefined){
					alert("먼저 분류를 선택해 주세요.");
					return;
				}
            	spaceEvProdDataSet.newRecord();
            	spaceEvProdDataSet.setValue(spaceEvProdDataSet.rowPosition,0,spaceEvClDataSet.getValue(spaceEvClDataSet.rowPosition,1));
            };
            
            //사업부저장
            saveStep0 = function(){
            	//서버전송
                var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('저장했습니다.');
        			//fnList();
        			getSpaceEvBzdvList();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Save Fail");
        	    });
                
            	Rui.confirm({
                    text: '저장하시겠습니까?',
                    handlerYes: function() {
                        dm.updateDataSet({
                            url:'<c:url value="/space/saveSpaceEvCtgr0.do"/>',
                            dataSets:[spaceEvBzdvDataSet]
                        });
                    },
                    handlerNo: Rui.emptyFn
                });
            }

            //제품군저장
            saveStep1 = function(){
            	//서버전송
                var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('저장했습니다.');
        			//fnList();
        			ctgr1List();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Save Fail");
        	    });
            	Rui.confirm({
                    text: '저장하시겠습니까?',
                    handlerYes: function() {
                        dm.updateDataSet({
                            url:'<c:url value="/space/saveSpaceEvCtgr1.do"/>',
                            dataSets:[spaceEvProdClDataSet]
                        });
                    },
                    handlerNo: Rui.emptyFn
                });
            }            
            
          	//분류저장
            saveStep2 = function(){
            	//서버전송
                var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('저장했습니다.');
        			//fnList();
        			ctgr2List();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Save Fail");
        	    });
            	Rui.confirm({
                    text: '저장하시겠습니까?',
                    handlerYes: function() {
                        dm.updateDataSet({
                            url:'<c:url value="/space/saveSpaceEvCtgr2.do"/>',
                            dataSets:[spaceEvClDataSet]
                        });
                    },
                    handlerNo: Rui.emptyFn
                });
            }     

          	//제품저장
            saveStep3 = function(){
            	//서버전송
                var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('저장했습니다.');
        			//fnList();
        			ctgr3List();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Save Fail");
        	    });
            	Rui.confirm({
                    text: '저장하시겠습니까?',
                    handlerYes: function() {
                        dm.updateDataSet({
                            url:'<c:url value="/space/saveSpaceEvCtgr3.do"/>',
                            dataSets:[spaceEvProdDataSet]
                        });
                    },
                    handlerNo: Rui.emptyFn
                });
            }    
          	
            /* 사업부 삭제 */
            deleteStep0 = function() {
            	if(spaceEvBzdvDataSet.getState(spaceEvBzdvDataSet.rowPosition)==1){
            		spaceEvBzdvDataSet.removeAt(spaceEvBzdvDataSet.rowPosition);
            		return;	
            	}
				var delDate = spaceEvBzdvDataSet.getAt(spaceEvBzdvDataSet.rowPosition);
            	
            	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('삭제했습니다.');
        			//fnList();
        			getSpaceEvBzdvList();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Delete Fail");
        	    });

    	   		Rui.confirm({
    	   			text: '삭제하시겠습니까?',
    	   	        handlerYes: function() {
    	           	    dm.updateDataSet({
    	   	        	    url: "<c:url value='/space/deleteSpaceEvCtgr0.do'/>",
    	   	        	    dataSets:[spaceEvBzdvDataSet],
    	   	        	 	params :{ ctgrCd:delDate.data.ctgrCd
		                    	    }
    	   	        	});
    	   	        }
    	   		});
            };
            
            /* 제품군 삭제 */
            deleteStep1 = function() {
            	if(spaceEvProdClDataSet.getState(spaceEvProdClDataSet.rowPosition)==1){
            		spaceEvProdClDataSet.removeAt(spaceEvProdClDataSet.rowPosition);
            		return;	
            	}
				var delDate = spaceEvProdClDataSet.getAt(spaceEvProdClDataSet.rowPosition);
            	
            	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('삭제했습니다.');
        			//fnList();
        			ctgr1List();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Delete Fail");
        	    });

    	   		Rui.confirm({
    	   			text: '삭제하시겠습니까?',
    	   	        handlerYes: function() {
    	           	    dm.updateDataSet({
    	   	        	    url: "<c:url value='/space/deleteSpaceEvCtgr1.do'/>",
    	   	        	    dataSets:[spaceEvProdClDataSet],
    	   	        	 	params :{ supiCd:delDate.data.supiCd
    	   	        	 		     ,ctgrCd:delDate.data.ctgrCd
		                    	    }
    	   	        	});
    	   	        }
    	   		});
            };
            
            /* 분류 삭제 */
            deleteStep2 = function() {
            	if(spaceEvClDataSet.getState(spaceEvClDataSet.rowPosition)==1){
            		spaceEvClDataSet.removeAt(spaceEvClDataSet.rowPosition);
            		return;	
            	}
				var delDate = spaceEvClDataSet.getAt(spaceEvClDataSet.rowPosition);
            	
            	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('삭제했습니다.');
        			//fnList();
        			ctgr2List();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Delete Fail");
        	    });

    	   		Rui.confirm({
    	   			text: '삭제하시겠습니까?',
    	   	        handlerYes: function() {
    	           	    dm.updateDataSet({
    	   	        	    url: "<c:url value='/space/deleteSpaceEvCtgr2.do'/>",
    	   	        	    dataSets:[spaceEvClDataSet],
    	   	        	 	params :{ supiCd:delDate.data.supiCd
    	   	        	 		     ,ctgrCd:delDate.data.ctgrCd
		                    	    }
    	   	        	});
    	   	        }
    	   		});
            };
            
            /* 제품 삭제 */
            deleteStep3 = function() {
            	if(spaceEvProdDataSet.getState(spaceEvProdDataSet.rowPosition)==1){
            		spaceEvProdDataSet.removeAt(spaceEvProdDataSet.rowPosition);
            		return;	
            	}
				var delDate = spaceEvProdDataSet.getAt(spaceEvProdDataSet.rowPosition);
            	
            	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('삭제했습니다.');
        			//fnList();
        			ctgr3List();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Delete Fail");
        	    });

    	   		Rui.confirm({
    	   			text: '삭제하시겠습니까?',
    	   	        handlerYes: function() {
    	           	    dm.updateDataSet({
    	   	        	    url: "<c:url value='/space/deleteSpaceEvCtgr3.do'/>",
    	   	        	    dataSets:[spaceEvProdDataSet],
    	   	        	 	params :{ supiCd:delDate.data.supiCd
    	   	        	 		     ,ctgrCd:delDate.data.ctgrCd
		                    	    }
    	   	        	});
    	   	        }
    	   		});
            };
            
            //성적서 저장후조회
            fnList = function() {
            	var record0 = spaceEvBzdvDataSet.getAt(spaceEvBzdvDataSet.rowPosition);
            	var supiCd0 = record0.data.ctgrCd;
            	var record1 = spaceEvProdClDataSet.getAt(spaceEvProdClDataSet.rowPosition);
            	var supiCd1 = record1.data.ctgrCd;
            	var record2 = spaceEvClDataSet.getAt(spaceEvClDataSet.rowPosition);
            	var supiCd2 = record2.data.ctgrCd;
            	var record3 = spaceEvProdDataSet.getAt(spaceEvProdDataSet.rowPosition);
            	var supiCd3 = record3.data.ctgrCd;
            	
            	spaceEvMtrlListDataSet.load({
                    url: '<c:url value="/space/spaceEvMtrlList.do"/>',
                    params :{ supiCd0:supiCd0
                    	     ,supiCd1:supiCd1
                    	     ,supiCd2:supiCd2
                    	     ,supiCd3:supiCd3
                    	    }
                });
            }
          
            //성적서등록 팝업 저장
            callChildSave = function() {
            	mchnDialog.getFrameWindow().fnSave();
            }
          
         	// 성적서등록 팝업 시작
			mchnDialog = new Rui.ui.LFrameDialog({
		        id: 'mchnDialog',
		        title: '성적서 등록',
		        width:  800,
		        height: 600,
		        modal: true,
		        visible: false,
		        buttons : [
		            { text: '저장', handler: callChildSave, isDefault: true },
		            { text:'닫기', handler: function() {
		              	this.cancel(false);
		              }
		            }
		        ]
		    });

			mchnDialog.render(document.body);

			openMchnSearchDialog = function(f) {
		    	_callback = f;
		    	mchnDialog.setUrl('<c:url value="/space/spaceEvMtrlReqPop.do"/>');
		    	mchnDialog.show();
		    };
		 	// 성적서등록 팝업 끝
		    
		    setMchnInfo = function(mchnInfo) {
				if(anlExprDtlDataSet.findRow('mchnInfoId', mchnInfo.get("mchnInfoId")) > -1) {
					alert('이미 존재합니다.');
					return ;
				}
    	    	
            	var row = anlExprDtlDataSet.newRecord();
            	var record = anlExprDtlDataSet.getAt(row);
            	
            	record.set('exprCd', selectExprCd);
            	record.set('mchnInfoId', mchnInfo.get("mchnInfoId"));
            	record.set('mchnInfoNm', mchnInfo.get("mchnNm"));
            	record.set('mdlNm', mchnInfo.get("mdlNm"));
            	record.set('mkrNm', mchnInfo.get("mkrNm"));
            	record.set('mchnClNm', mchnInfo.get("mchnClNm"));
            	record.set('mchnCrgrNm', mchnInfo.get("mchnCrgrNm"));
            }
            
            //성적서 등록 버튼
            rslrReq = function() {
            	var selectSpaceEvProd = spaceEvProdDataSet.rowPosition;
            	if(!ctgrNm04) {
            		alert('먼저 제품을 선택해 주세요.');
            	} else {
            		openMchnSearchDialog(setMchnInfo);
            	}
            };
            
          //성적서 삭제
            deleteRslr = function() {
            	var record0 = spaceEvBzdvDataSet.getAt(spaceEvBzdvDataSet.rowPosition);
            	var supiCd0 = record0.data.ctgrCd;
            	var record1 = spaceEvProdClDataSet.getAt(spaceEvProdClDataSet.rowPosition);
            	var supiCd1 = record1.data.ctgrCd;
            	var record2 = spaceEvClDataSet.getAt(spaceEvClDataSet.rowPosition);
            	var supiCd2 = record2.data.ctgrCd;
            	var record3 = spaceEvProdDataSet.getAt(spaceEvProdDataSet.rowPosition);
            	var supiCd3 = record3.data.ctgrCd;
            	var selectspaceEvMtrl = spaceEvMtrlListDataSet.rowPosition;
            	if(selectspaceEvMtrl==-1){
            		alert("자재단위평가 목록을 선택해 주세요.");
            		return;
            	}
            	var delDate = spaceEvMtrlListDataSet.getAt(spaceEvMtrlListDataSet.rowPosition);
            	
            	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        		dm.on('success', function(e) {      // 업데이트 성공시
        			alert('삭제했습니다.');
        			fnList();
        	    });

        	    dm.on('failure', function(e) {      // 업데이트 실패시
                    Rui.alert("Delete Fail");
        	    });

    	   		Rui.confirm({
    	   			text: '삭제하시겠습니까?',
    	   	        handlerYes: function() {
    	           	    dm.updateDataSet({
    	   	        	    url: "<c:url value='/space/deleteSpaceEvMtrl.do'/>",
    	   	        	    dataSets:[spaceEvMtrlListDataSet],
    	   	        	 	params :{ supiCd0:supiCd0
		                    	     ,supiCd1:supiCd1
		                    	     ,supiCd2:supiCd2
		                    	     ,supiCd3:supiCd3
		                    	     ,scn:delDate.data.scn
		                    	     ,pfmcVal:delDate.data.pfmcVal
		                    	     ,strtVldDt:delDate.data.strtVldDt
		                    	     ,fnhVldDt:delDate.data.fnhVldDt
		                    	     ,evCd:delDate.data.evCd
		                    	    }
    	   	        	});
    	   	        }
    	   		});
            }
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="rqprId" name="rqprId" value=""/>
		
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	   				<h2>공간평가 평가법관리</h2>
	   			</div>
	   			
	   			<table style="width:100%;border=0;">
   					<colgroup>
						<col style="width:20%;">
						<col style="width:20%;">
						<col style="width:20%;">
						<col style="width:20%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<td>
				   				<div class="titArea">
				   					<h3>사업부</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep0Btn" name="addStep0Btn" onclick="addStep0();">추가</button>
								   		<button type="button" class="btn"  id="delStep0dBtn" name="delStep0dBtn" onclick="deleteStep0();">삭제</button>
								   		<button type="button" class="btn"  id="saveStep0dBtn" name="saveStep0dBtn" onclick="saveStep0();">저장</button>
				   					</div>
				   				</div>
				   				
				   				<div id="spaceEvBzdvGrid"></div>
				   				
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>제품군</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep1Btn" name="addStep1Btn" onclick="addStep1();">추가</button>
								   		<button type="button" class="btn"  id="delStep1dBtn" name="delStep1dBtn" onclick="deleteStep1();">삭제</button>
								   		<button type="button" class="btn"  id="saveStep1dBtn" name="saveStep1dBtn" onclick="saveStep1();">저장</button>
				   					</div>
				   				</div>
				
				   				<div id="spaceEvProdClGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>분류</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep2Btn" name="addStep2Btn" onclick="addStep2();">추가</button>
								   		<button type="button" class="btn"  id="delStep2dBtn" name="delStep2dBtn" onclick="deleteStep2();">삭제</button>
								   		<button type="button" class="btn"  id="saveStep2dBtn" name="saveStep2dBtn" onclick="saveStep2();">저장</button>
				   					</div>
				   				</div>
				
				   				<div id="spaceEvClGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>제품</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addStep3Btn" name="addStep3Btn" onclick="addStep3();">추가</button>
								   		<button type="button" class="btn"  id="delStep3dBtn" name="delStep3dBtn" onclick="deleteStep3();">삭제</button>
								   		<button type="button" class="btn"  id="saveStep3dBtn" name="saveStep3dBtn" onclick="saveStep3();">저장</button>
				   					</div>
				   				</div>
				
				   				<div id="spaceEvProdGrid"></div>
   							</td>
   						</tr>
   						<tr>
   							<td colspan="7">
				   				<div class="titArea">
				   					<h3>자재 단위 평가</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="rslrReqBtn" name="rslrReqBtn" onclick="rslrReq();">성적서 등록</button>
								   		<button type="button" class="btn"  id="delRslrBtn" name="delRslrBtn" onclick="deleteRslr();">삭제</button>
				   					</div>
				   				</div>
				   				
				   				<div id="spaceEvMtrlListGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>
				
				
				
				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>