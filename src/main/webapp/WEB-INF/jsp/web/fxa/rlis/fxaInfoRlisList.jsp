<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoRlisList.jsp
 * @desc    : 고정자산 > 자산실사
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.11     IRIS05		최초생성
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
var fxaRlisApprDialog;

	Rui.onReady(function() {
		var adminChk = "PER";
		
		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
			adminChk = "ADM";
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T04') > -1) {
			adminChk = "ADM";
		}

		/** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
				  { id: 'rlisTitl'}
				, { id: 'prjNm'}
            	, { id: 'rlisClNm' }
            	, { id: 'rlisFxaClss'}
            	, { id: 'crgrNm' }
            	, { id: 'fxaRlisCnt' }
            	, { id: 'rlisRqDt' }
            	, { id: 'rlisApprDt' }
            	, { id: 'rlisStNm' }
            	, { id: 'rlisStCd' }
            	, { id: 'crgrId'}
				, { id: 'fxaRlisId'}
            	, { id: 'deptCd' }
            	, { id: 'rlisClCd' }
				, { id: 'rlisTrmNm'}
				, { id: 'itgRdcsId'}
			]
        });

        dataSet.on('load', function(e){
	       	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    });

        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
        	 	      { field: 'rlisTitl'     , label: '실사명',  		sortable: false,	align:'left', width:220}
                    , { field: 'prjNm'    	  , label: '프로젝트명',  	sortable: false,	align:'left', width: 320}
                    , { field: 'rlisClNm'     , label: '실사구분',  	sortable: false,	align:'center', width: 110}
                    , { field: 'rlisFxaClss'  , label: '자산클래스',  	sortable: false,	align:'center', width: 190}
                    , { field: 'crgrNm'       , label: '담당자',  		sortable: false,	align:'center', width: 90}
                    , { field: 'fxaRlisCnt'   , label: '자산갯수',  	sortable: false,	align:'center', width: 62}
                    , { field: 'rlisRqDt'     , label: '실사요청일',  	sortable: false,	align:'center', width: 110}
                    , { field: 'rlisApprDt'   , label: '실사승인일',  	sortable: false,	align:'center', width: 110}
                    , { field: 'rlisStNm'     , label: '상태',  		sortable: false,	align:'center', width: 90}
            	    , { field: 'crgrId'	      , hidden : true}
            	    , { field: 'fxaRlisId'    , hidden : true}
            	    , { field: 'deptCd' 	  , hidden : true}
            	    , { field: 'rlisClCd' 	  , hidden : true}
            	    , { field: 'rlisTrmNm'    , hidden : true}
            	    , { field: 'itgRdcsId'    , hidden : true}
            ]
        });

        var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width : 1050,
	        height: 500,
	        autoWidth: true
	    });

		grid.render('defaultGrid');

		grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());
			if(dataSet.getRow() > -1) {
				if(e.col == 8) {
					var itgRdcsId = record.get("itgRdcsId"); 
					/* 
					if(itgRdcsId =="" || itgRdcsId == undefined ){
						Rui.alert("결재진행상태가 없습니다.");
						return;
					}
					 */
					var url = '<%=lghausysPath%>/lgchem/approval.front.approval.RetrieveAppTargetCmd.lgc?seq='+itgRdcsId;
               		openWindow(url, 'fxaInfoRlisPop', 400, 200, 'yes');
				}else{
					//To_do 화면으로 이동
					var params = "?fxaRlisId="+record.get("fxaRlisId")
				    			 +"&rlisStCd="+record.get("rlisStCd")
							    ;
					//document.aform.action="<c:url value="/fxa/rlis/retrieveFxaRlisTodoList.do"/>"+params;
					document.aform.action="<c:url value="/fxa/rlis/retrieveFxaRlisTodoView.do"/>"+params;
					document.aform.submit(); 
				}
			}
	 	});
		
		//실사명 combo
		var rlisTrmNm = new Rui.ui.form.LTextBox({         // LTextBox개체를 선언
	        applyTo: 'rlisTrmNm',                          // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                 // 텍스트박스 폭을 설정
	        placeholder: '',     						// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                          // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		/* 
		//실사명 combo
		var cbRlisTrmId = new Rui.ui.form.LCombo({
			applyTo : 'rlisTrmId',
			name : 'rlisTrmId',
			width: 200,
			useEmptyText: true,
	           emptyText: '전체',
	        url: '<c:url value="/fxa/rlis/retrieveFxaRlisTitlCombo.do?comCd=MCHN_PRCT_ST"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD',
	     });
		cbRlisTrmId.getDataSet().on('load', function(e) {
           console.log('cbRlisTrmId :: load');
       	});
 */

		//실사구분 combo
		var cbRlisClCd = new Rui.ui.form.LCombo({
			applyTo : 'rlisClCd',
			name : 'rlisClCd',
			width: 200,
	        url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FXA_RLIS_CL_CD"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD',
	     });

		cbRlisClCd.getDataSet().on('load', function(e) {
           console.log('cbRlisClCd :: load');
       	});

		//담당자
		var crgrNm = new Rui.ui.form.LTextBox({         // LTextBox개체를 선언
	        applyTo: 'crgrNm',                          // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                 // 텍스트박스 폭을 설정
	        placeholder: '',     						// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                          // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//프로젝트명
		var prjNm = new Rui.ui.form.LTextBox({         // LTextBox개체를 선언
	        applyTo: 'prjNm',                          // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                 // 텍스트박스 폭을 설정
	        placeholder: '',     						// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                          // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//자산class
		var rlisFxaClss = new Rui.ui.form.LTextBox({         // LTextBox개체를 선언
	        applyTo: 'rlisFxaClss',                          // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 400,                                 // 텍스트박스 폭을 설정
	        placeholder: '',     						// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                          // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/rlis/retrieveFxaRlisSearchList.do"/>',
	            params :{
	            	//rlisTrmId : document.aform.rlisTrmId.value, 	// 실사명
	    		    rlisTrmNm : encodeURIComponent(document.aform.rlisTrmNm.value), 		// 실사명
	            	rlisClCd : cbRlisClCd.getValue(), 	// 실사구분
	    		    prjNm : encodeURIComponent(document.aform.prjNm.value), 		// prjNm
	    		    crgrNm : encodeURIComponent(document.aform.crgrNm.value),						// 담당자
	    		    rlisFxaClss : document.aform.rlisFxaClss.value,						// 자산class
	    		    adminChk : adminChk						// 권한
                }
            });
        }

        // 화면로드시 조회
	    fnSearch();


	    /* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){
        	if(dataSet.getCount() > 0 ) {
	            var excelColumnModel = columnModel.createExcelColumnModel(false);
	            grid.saveExcel(encodeURIComponent('분석기기_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}
        });


        fxaRlisApprDialog = new Rui.ui.LFrameDialog({
	        id: 'fxaRlisApprDialog',
	        title: '결재상태',
	        width:  650,
	        height: 250,
	        modal: true,
	        visible: false
	    });

        fxaRlisApprDialog.render(document.body);



	});		//end ready
	
</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
    		<div class="contents">
    			<div class="titleArea">
    				<a class="leftCon" href="#">
			        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        	<span class="hidden">Toggle 버튼</span>
		        	</a>  
    				<h2>자산실사</h2>
    		    </div>
    			<div class="sub-content">

					<form name="aform" id="aform" method="post">
					<input type="hidden" id="menuType"  name="menuType" />
					<input type="hidden" id="fxaRlisId"  name="fxaRlisId" />
					<input type="hidden" id="fxaInfoId"  name="fxaInfoId" />
					<input type="hidden" id="roleId" name="roleId"  value="<c:out value='${inputData._roleId}'/>">
					
					<div class="search">
						<div class="search-content">
		    				<table id="asset_ta01">
		    					<colgroup>
		    						<col style="width:100px"/>
		    						<col style="width:200px"/>
		    						<col style="width:100px"/>
		    						<col style="width:200px"/>
		    						<col style="width:90px"/>
		    						<col style="width:200px"/>
		    						<col style=""/>
		    					</colgroup>
		    					<tbody>
		    					    <tr>
		    							<th align="right">실사명</th>
			   							<td>
											<input type="text" id="rlisTrmNm" ></input>
			   							</td>
		    							<th align="right">실사구분</th>
			    						<td>
			    							<select id="rlisClCd" ></select>
			    						</td>
			    						<th align="right">담당PJT</th>
			   							<td>
			   								<span>
												<input type="text" class="" id="prjNm" >
											</span>
			   							</td>
			   							<td></td>
		    						</tr>
		    					    <tr>
		    							<th align="right">담당자</th>
			    						<td>
			    							<input type="text" class="" id="crgrNm">
			    						</td>
		    							<th align="right">자산Class</th>
		    							<td>
		    								<input type="text" id="rlisFxaClss" />
		    							</td>
			    						<td colspan="3" class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
		    						</tr>
		    					</tbody>
		    				</table>
	    				</div>
    				</div>

    				<div class="titArea">
    					<span class="table_summay_number" id="cnt_text"></span>
						<div class="LblockButton">
    						<button type="button" id="butExcl" name="butExcl">EXCEL</button>
    					</div>
    				</div>
    				<div id="defaultGrid"></div>

				</form>

    			</div><!-- //sub-content -->
    		</div><!-- //contents -->
    </body>
    </html>