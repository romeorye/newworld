<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoList.jsp
 * @desc    : 고정자산 >  자산폐기
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.13    IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">
var adminChk = "N";

	Rui.onReady(function() {

		/* 권한  */
		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
			adminChk = "Y";
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T04') > -1) {
			adminChk = "Y";
		}


		/** dataSet **/
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
				  { id: 'fxaNm'}
				, { id: 'fxaNo' }
				, { id: 'fxaQty'}
				, { id: 'fxaUtmNm'}
            	, { id: 'wbsCd' }
				, { id: 'prjNm' }
				, { id: 'obtDt' }
				, { id: 'obtPce' }
				, { id: 'attcFilId' }
				, { id: 'seq' }
				, { id: 'crgrNm'}
				, { id: 'dsuDt'}
				, { id: 'fxaInfoId'}
				, { id: 'imgIcon' }
			]
        });

        dataSet.on('load', function(e){
 	       	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
 	    	// 목록 페이징
	    	paging(dataSet,"defaultGrid");
 	    });

        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
        	 	      { field: 'fxaNm'      , label: '자산명',  	sortable: false,	align:'left', width:330}
                    , { field: 'fxaNo'      , label: '자산번호',  	sortable: false,	align:'center', width: 100}
                    , { field: 'fxaQty' 	, label: '수량',  		sortable: false,	align:'center', width: 60}
                    , { field: 'fxaUtmNm'   , label: '단위',  		sortable: false,	align:'center', width: 60}
					, { field: 'wbsCd'      , label: 'WBS 코드',  	sortable: false,	align:'center', width: 80}
                    , { field: 'prjNm'      , label: '프로젝트명', 	sortable: false,	align:'left', width: 270}
                    , { field: 'crgrNm'     , label: '담당자',  	sortable: false,	align:'center', width: 90}
                    , { field: 'obtDt'     	, label: '취득일',  	sortable: false,	align:'center', width: 90}
                    , { field: 'obtPce'     , label: '취득가',  	sortable: false,	align:'left', width: 90,
	                   	 renderer: function(value, p, record){
	      	        		return Rui.util.LFormat.numberFormat(parseInt(value));
	      		        }
	                  }
                    , { field: 'imgIcon' 	, label: '사진',  sortable: false,	align:'center', width: 80,	renderer: function(value, p, record){

                   	 if(record.get('attcFilId') == null ||  record.get('attcFilId') == ""){
		            	 }else{
                   		 return '<button type="button" class="L-grid-button">사진</button>';
		            	 }
	      		        }
	                  }
                    , { field: 'dsuDt'		, label: '자산폐기일', 	sortable: false,	align:'center', width: 75}
            	    , { field: 'fxaInfoId' , hidden : true}
            ]
        });

        /** default grid **/
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 1170,
            height: 400,
            autoWidth: true
        });

        grid.render('defaultGrid');

        grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());
			var column = columnModel.getColumnAt(e.col, true);

			if(dataSet.getRow() > -1) {
				if(column.id == 'imgIcon') {

					if (Rui.isEmpty( record.get("attcFilId"))){
	 					Rui.alert("등록된 이미지가 없습니다.");
	 					return;
					}else{
						var param = "?attcFilId="+ record.get("attcFilId")+"&seq="+record.get("seq");
		   				Rui.getDom('dialogImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
		   				Rui.get('imgDialTitle').html('자산이미지');

		   				imgResize(Rui.getDom('dialogImage'));

		   				imageDialog.clearInvalid();
		   				imageDialog.show(true);
					}

	    	     }else{
	    	    	document.aform.adminChk.value = adminChk;
	  				document.aform.fxaInfoId.value = record.get("fxaInfoId");
	  				document.aform.rtnUrl.value = "/fxa/dsu/retrieveFxaDsuList.do";
	 				document.aform.action="<c:url value="/fxa/anl/retrieveFxaAnlDtl.do"/>";
	 				document.aform.submit();
	    	     }
			}
	 	});

        /* [ 이미지 Dialog] */
     	var imageDialog = new Rui.ui.LDialog({
             applyTo: 'imageDialog',
             width: 800,
             height: 700,
             visible: false,
             postmethod: 'none',
             buttons: [
                 { text:'닫기', isDefault: true, handler: function() {
                     this.cancel(false);
                 } }
             ]
         });
     	imageDialog.hide(true);

     	var imgResize = function(img){
     		var width = img.width;
     	    var height = img.height;

     	   // 가로, 세로 최대 사이즈 설정
     	    var maxWidth = 780;
     	    var maxHeight = 700;
     	    var resizeWidth = 0;
     	    var resizeHeight = 0;

     	// 이미지 비율 구하기
     	    var basisRatio = maxHeight / maxWidth;
     	    var imgRatio = height / width;

     	    if (imgRatio > basisRatio) {
     	    // height가 기준 비율보다 길다.

     	        if (height > maxHeight) {
     	            resizeHeight = maxHeight;
     	            resizeWidth = Math.round((width * resizeHeight) / height);
     	        } else {
     	            resizeWidth = width;
     	            resizeHeight = height;
     	        }

     	    } else if (imgRatio < basisRatio) {
     	    // width가 기준 비율보다 길다.

     	        if (width > maxWidth) {
     	            resizeWidth = maxWidth;
     	            resizeHeight = Math.round((height * resizeWidth) / width);
     	        } else {
     	            resizeWidth = width;
     	            resizeHeight = height;
     	        }

     	    } else {
     	        // 기준 비율과 동일한 경우
     	        resizeWidth = width;
     	        resizeHeight = height;
     	    }
     	// 리사이즈한 크기로 이미지 크기 다시 지정
     	    img.width = resizeWidth;
     	    img.height = resizeHeight;
     	}

		 //WBS 코드
 	    var wbsCd = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'wbsCd',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //프로젝트명
 	    var prjNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'prjNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //자산명
 	    var fxaNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'fxaNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //자산번호
       	var fxaNo = new Rui.ui.form.LNumberBox({
	        applyTo: 'fxaNo',
	        placeholder: '',
	        maxValue: 9999999999,           // 최대값 입력제한 설정
	        minValue: 0,                  // 최소값 입력제한 설정
	        decimalPrecision: 0            // 소수점 자리수 3자리까지 허용
    	});

       //자산폐기일 fr
		var fromDate = new Rui.ui.form.LDateBox({
			applyTo: 'fromDate',
			mask: '9999-99-99',
			displayValue: '%Y-%m-%d',
			defaultValue : '',		// default -1년
			width: 100,
			dateType: 'string'
		});

		fromDate.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromDate.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				fromDate.setValue(new Date());
			}
		});

	 	//자산폐기일 to
		var toDate = new Rui.ui.form.LDateBox({
			applyTo: 'toDate',
			mask: '9999-99-99',
			displayValue: '%Y-%m-%d',
			defaultValue : '',		// default -1년
			width: 100,
			dateType: 'string'
		});

		//담당자명
 	    var crgrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'crgrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

		toDate.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toDate.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				toDate.setValue(new Date());
			}
		});

		fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/dsu/retrieveFxaDsuSearchList.do"/>' ,
	            params :{
	    		    fromDate : nwinsReplaceAll(fromDate.getValue(), "-",""),	// 시공(예정)일 - reqdt, 시공주문일 - ordrdt,
	    		    toDate : nwinsReplaceAll(toDate.getValue(), "-",""),		// 시공(예정)일 - reqdt, 시공주문일 - ordrdt,
	    		    wbsCd : encodeURIComponent(document.aform.wbsCd.value), 		// wbsCd
	    		    fxaNm : encodeURIComponent(document.aform.fxaNm.value),	//자산명
	    		    prjNm : encodeURIComponent(document.aform.prjNm.value),	//project name
	    		    fxaNo : document.aform.fxaNo.value,						// 자산번호
	            	crgrNm : encodeURIComponent(document.aform.crgrNm.value) 		// 담당자명
                }
            });

        }
        // 화면로드시 조회
	    fnSearch();

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){

        	// 엑셀 다운로드시 전체 다운로드를 위해 추가
        	dataSet.clearFilter();

        	if(dataSet.getCount() > 0 ) {
	            var excelColumnModel = columnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('자산폐기_') + new Date().format('%Y%m%d') + '.xls', {
	                columnModel: excelColumnModel
	            });
        	}else{
        		Rui.alert("리스트 건수가 없습니다.");
        		return;
        	}

        	// 목록 페이징
        	paging(dataSet,"defaultGrid");
        });
	});		//end ready
</script>
<!-- <script type="text/javascript" src="/iris/resource/js/lgHs_common.js"></script> -->
 </head>
 <body>
 		<div class="contents">
 			<div class="titleArea">
 				<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
	        	</a>
 				<h2>자산폐기</h2>
 		    </div>
 			<div class="sub-content">

		<form name="aform" id="aform" method="post">
			<input type="hidden" id="menuType"  name="menuType" value="IRIFI0104"/>
			<input type="hidden" id="fxaInfoId"  name="fxaInfoId" />
			<input type="hidden" id="rtnUrl"  name="rtnUrl" />

			<!-- Role -->
			<input type="hidden" id="roleId" name="roleId"  value="<c:out value='${inputData._roleId}'/>">
			<input type="hidden" id="adminChk" name="adminChk" />
				<div class="search">
					<div class="search-content">
		 				<table>
		 					<colgroup>
							<col style="width:120px"/>
							<col style="width:300px"/>
							<col style="width:120px"/>
							<col style="width:200px"/>
							<col style=""/>
						</colgroup>
						<tbody>
						    <tr>
								<th align="right">WBS 코드</th>
								<td>
									<span>
							<input type="text" class="" id="wbsCd" >
						</span>
								</td>
								<th align="right">프로젝트명</th>
								<td>
									<input type="text" class="" id="prjNm" >
								</td>
								<td></td>
							</tr>
						    <tr>
								<th align="right">자산명</th>
								<td>
									<span>
										<input type="text" class="" id="fxaNm" >
									</span>
								</td>
								<th align="right">자산번호</th>
								<td>
									<input type="text" id="fxaNo">
								</td>
								<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
							</tr>
							<tr>
								<th align="right">자산폐기일</th>
								<td>
									<input type="text" id="fromDate" /><em class="gab"> ~ </em>	<input type="text" id="toDate" />
								</td>
								</td>
								<th align="right">담당자</th>
								<td>
									<input type="text"  id="crgrNm">
								</td>
								<td></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<div class="titArea">
			<span class="table_summay_number" id="cnt_text">총 0건</span>
			<div class="LblockButton">
					<button type="button" id="butExcl" name="butExcl">EXCEL</button>
				</div>
			</div>

			<div id="defaultGrid"></div>
	</form>

 			</div><!-- //sub-content -->
<!-- 이미지 -->
	<div id="imageDialog">
		<div class="hd" id="imgDialTitle">이미지</div>
		<div class="bd" id="imgDialContents">
			<img id="dialogImage"/>
		</div>
	</div>
  		</div><!-- //contents -->
 </body>
 </html>

