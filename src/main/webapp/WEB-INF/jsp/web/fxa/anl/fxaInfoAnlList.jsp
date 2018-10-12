<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoList.jsp
 * @desc    : 고정자산 >  자산관리
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

<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<script type="text/javascript">
var sDeptCd;
var adminChk = "N";
var btnRole = "Y";
var imgWidth;
var imgHeight;

	Rui.onReady(function() {

		var butRgst = new Rui.ui.LButton('butRgst');
		var butMail = new Rui.ui.LButton('butMail');
		var butExcl = new Rui.ui.LButton('butExcl');

		butExcl.hide();
		/* 권한  */
		sDeptCd = '${inputData._userDept}'

		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
			adminChk = "Y";
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T04') > -1) {
			adminChk = "Y";
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
			btnRole = "N";
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
			btnRole = "N";
		}

		if( adminChk == "Y"){
			butRgst.show();
			butMail.show();
		}else{
			butRgst.hide();
			butMail.hide();
		}

		/*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
         dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
             	  { id: 'wbsCd'}
 				, { id: 'prjNm'}
 				, { id: 'fxaNo'}
 				, { id: 'fxaNm'}
 				, { id: 'fxaQty'}
 				, { id: 'fxaUtmNm'}
 				, { id: 'crgrNm'}
 				, { id: 'trsfApprDt'}
 				, { id: 'obtPce'}
 				, { id: 'bkpPce'}
 				, { id: 'imgIcon'}
 				, { id: 'fxaLoc'}
 				, { id: 'tagYn'}
 				, { id: 'rlisDt'}
 				, { id: 'sendMail'}
 				, { id: 'saUserId'}
 				, { id: 'attcFilId'}
 				, { id: 'crgrId'}
 				, { id: 'fxaInfoId'}
 				, { id: 'trsfStCd'}
 				, { id: 'deptCd'}
 				, { id: 'imgFilPath'}
 				, { id: 'attcFilCd'}
 				, { id: 'seq'}
 				, { id: 'trsfYn'}
 			]
         });

         dataSet.on('load', function(e){
 	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
 	    	// 목록 페이징
	    	paging(dataSet,"defaultGrid");
 	    });

         var columnModel = new Rui.ui.grid.LColumnModel({
             columns: [
         	 	new Rui.ui.grid.LSelectionColumn(),
 					   { field: 'wbsCd'      , label: 'WBS 코드',  	sortable: false,	align:'center',/*  width: 60, */  hidden : true}
                     , { field: 'prjNm'      , label: '프로젝트명', sortable: false,	align:'left', 	width: 240}
                     , { field: 'fxaNo'      , label: '자산번호',  	sortable: false,	align:'center', width: 90}
                     , { field: 'fxaNm'      , label: '자산명',  	sortable: false,	align:'left', 	width:260}
                     , { field: 'fxaQty' 	 , label: '수량',  		sortable: false,	align:'center', width: 41}
                     , { field: 'fxaUtmNm'   , label: '단위',  		sortable: false,	align:'center', width: 50}
                     , { field: 'crgrNm'     , label: '담당자',  	sortable: false,	align:'center', width: 70}
                     , { field: 'trsfApprDt' , label: '자산이관일', sortable: false,	align:'center', width: 90}
                     , { field: 'obtPce' 	, label: '취득가',  	sortable: false,	align:'right', 	width: 90,
                    	 renderer: function(value, p, record){
         	        		return Rui.util.LFormat.numberFormat(parseInt(value));
         		        }
                     }
                     , { field: 'bkpPce' 	, label: '장부가',  		sortable: false,	align:'right', width: 90,
                    	 renderer: function(value, p, record){
         	        		return Rui.util.LFormat.numberFormat(parseInt(value));
         		        }
                     }
                     , { field: 'imgIcon' 	, label: '사진',  sortable: false,	align:'center', width: 50,	renderer: function(value, p, record){

                    	 if(record.get('attcFilId') == null ||  record.get('attcFilId') == ""){
 		            	 }else{
                    		 return '<button type="button" class="L-grid-button">사진</button>';
 		            	 }
	      		        }
	                  }
                     , { field: 'fxaLoc' 	, label: '위치',  		sortable: false,	align:'center', width: 90}
                     , { field: 'tagYn' 	, label: '태그',  		sortable: false,	align:'center', width: 30}
                     , { field: 'rlisDt' 	, label: '실사일', 		sortable: false,	align:'center', width: 90}
             	     , { field: 'sendMail'  , hidden : true}
             	     , { field: 'saUserId'  , hidden : true}
             	     , { field: 'crgrId'    , hidden : true}
             	     , { field: 'fxaInfoId' , hidden : true}
             	     , { field: 'trsfStCd' , hidden : true}
             	     , { field: 'imgFilPath' , hidden : true}
             	     , { field: 'attcFilId' , hidden : true}
             	     , { field: 'seq' , hidden : true}
             	     , { field: 'deptCd' , hidden : true}
             	     , { field: 'trsfYn' , hidden : true}
             ]
         });

         /** default grid **/
         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             width: 1200,
             height: 400,
             autoWidth: true
         });

         grid.render('defaultGrid');

         grid.on('cellClick', function(e) {
 			var record = dataSet.getAt(dataSet.getRow());
 			var column = columnModel.getColumnAt(e.col, true);

 			if(column.id == 'selection') {
 				return;
 			}

 			if(dataSet.getRow() > -1) {
 				if(column.id == 'imgIcon') {
 					if( Rui.isEmpty(record.get('attcFilId'))){
 						Rui.alert("등록된 이미지가 없습니다.");
 						return;
 					}

 	    			var param = "?attcFilId="+ record.get("attcFilId")+"&seq="+record.get("seq");

 	   				Rui.getDom('dialogImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
 	   				Rui.get('imgDialTitle').html('자산이미지');
 	   				imgResize(Rui.getDom('dialogImage'));

 	   				imageDialog.clearInvalid();
 	   				imageDialog.show(true);

 	    	    }else{
 	    	    	document.aform.adminChk.value = adminChk;
	 				document.aform.fxaInfoId.value = record.get("fxaInfoId");
	 				document.aform.rtnUrl.value = "/fxa/anl/retrieveFxaAnlList.do";

	 				if(adminChk == "N" && !Rui.isEmpty(record.get("deptCd")) ){
	 					if(record.get("deptCd") == sDeptCd ){
	 						document.aform.adminChk.value = "Y";
	 					}
	 				}
	 				nwinsActSubmit(document.aform, "<c:url value="/fxa/anl/retrieveFxaAnlDtl.do"/>");
 	    	    }
 			}
 	 	});

         /* [ 이미지 Dialog] */
     	var imageDialog = new Rui.ui.LDialog({
             applyTo: 'imageDialog',
             width: 600,
             height: 500,
             visible: true,
             modal: false,
             postmethod: 'none',
             buttons: [
                 { text:'닫기', isDefault: true, handler: function() {
                     this.cancel(false);
                 } }
             ]
         });
     	imageDialog.hide(true);

     	//자산 이관
     	fxaTrsfDialog = new Rui.ui.LFrameDialog({
	        id: 'fxaTrsfDialog',
	        title: '자산이관',
	        width:  800,
	        height: 400,
	        modal: true,
	        visible: false
	    });

     	fxaTrsfDialog.render(document.body);

        //WBS 코드
 	    var wbsCd = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'wbsCd',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        defaultValue: '<c:out value="${inputData.wbsCd}"/>',
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //프로젝트명
 	    var prjNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'prjNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        defaultValue: '<c:out value="${inputData.prjNm}"/>',
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //자산명
 	    var fxaNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'fxaNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        defaultValue: '<c:out value="${inputData.fxaNm}"/>',
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //자산번호
 	    var fxaNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'fxaNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	       defaultValue: '<c:out value="${inputData.fxaNo}"/>',
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //담당자
 	    var crgrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'crgrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	       defaultValue: '<c:out value="${inputData.crgrNm}"/>',
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //자산이관 시작일
		var fromDate = new Rui.ui.form.LDateBox({
			applyTo: 'fromDate',
			mask: '9999-99-99',
			//displayValue: '%Y-%m-%d',
			defaultValue: '<c:out value="${inputData.fromDate}"/>',
			width: 100,
			dateType: 'string'
		});
/*
		fromDate.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromDate.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				fromDate.setValue(new Date());
			}
			if( fromDate.getValue() > toDate.getValue() ) {
				alert('시작일이 종료일보다 클 수 없습니다.!!');
				fromDate.setValue(toDate.getValue());
			}
		});
 */
	 	//자산이관 종료일
		var toDate = new Rui.ui.form.LDateBox({
			applyTo: 'toDate',
			mask: '9999-99-99',
			defaultValue: '<c:out value="${inputData.toDate}"/>',
			//displayValue: '%Y-%m-%d',
			width: 100,
			dateType: 'string'
		});
/*
		toDate.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toDate.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				toDate.setValue(new Date());
			}
			if( fromDate.getValue() > toDate.getValue() ) {
				alert('시작일이 종료일보다 클 수 없습니다.!!');
				toDate.setValue(toDate.getValue());
			}
		});
 */
        fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/anl/retrieveFxaAnlSearchList.do"/>' ,
	            params :{
	    		    fromDate : nwinsReplaceAll(fromDate.getValue(), "-",""),	// 시공(예정)일 - reqdt, 시공주문일 - ordrdt,
	    		    toDate : nwinsReplaceAll(toDate.getValue(), "-",""),		// 시공(예정)일 - reqdt, 시공주문일 - ordrdt,
	    		    wbsCd : document.aform.wbsCd.value, 		// wbsCd
	    		    fxaNm : encodeURIComponent(document.aform.fxaNm.value),	//자산명
	    		    crgrNm : encodeURIComponent(document.aform.crgrNm.value),						// 담당자
	    		    fxaNo : document.aform.fxaNo.value,						// 자산번호
	    		    prjNm : encodeURIComponent(document.aform.prjNm.value)						// 자산번호
                }
            });

        }
        // 화면로드시 조회
	    fnSearch();


	    /* [버튼] : 자산신규 페이지로 이동 */
		butRgst.on('click', function(){
			document.aform.action='<c:url value="/fxa/anl/retrieveFxaAnlUpdate.do"/>';
			document.aform.submit();
		});

		var chkUserId="";
		var chkNm="";
		var chkMailAddr="";

	    /* [버튼] : 메일 페이지로 이동 */
		butMail.on('click', function(){
			if(dataSet.getCount() > 0 ) {
				//체크박스 체크 유무 (1건이상))
				if(dataSet.getMarkedCount() == 0 ){
					Rui.alert("메일을 보낼 자산을 체크해주십시오");
					return;
				}

				// 선택ID 목록 세팅
		 		var chkUserIdList = [];
				var chkUserIds = '';
				for( var i = 0 ; i < dataSet.getCount() ; i++ ){
			    	if(dataSet.isMarked(i)){
			    		chkUserIdList.push(dataSet.getNameValue(i, 'saUserId'));
			    	}
				}
				chkUserIds = chkUserIdList.join(',');
				// 메일다이얼로그 오픈
				openMailDialog(null, chkUserIds);
			}else{
				Rui.alert("리스트가 없습니다.");
				return;
			}
		});

		/* [다이얼로그] 메일발송 */
	    var _mailDialog = new Rui.ui.LFrameDialog({
	        id: 'mailDialog',
	        title: '메일',
	        width: 600,
	        height: 550,
	        modal: true,
	        visible: false,
	        buttons: [
	            { text:'닫기', isDefault: true, handler: function() {
	                this.cancel(false);
	            } }
	        ]
	    });

	    _mailDialog.on('submit', function(e) {
	    	Rui.alert('메일이 발송되었습니다.');
	    });

	    _mailDialog.render(document.body);

		 /* [함수] 메일다이얼로그 오픈 */
		openMailDialog = function(f,userIds) {
			_callback = f;
			_mailDialog.setUrl('<c:url value="/prj/mm/mail/sendMailPopup.do"/>'+'?userIds=' + userIds);
			_mailDialog.show();
		};

	    /* [버튼] : 이관팝업으로 이동 */
		var butTrsf = new Rui.ui.LButton('butTrsf');
		butTrsf.on('click', function(){
			if(dataSet.getCount() > 0 ) {
				//체크박스 체크 유무 (1건만))
				if(dataSet.getMarkedCount() == 0 ){
					Rui.alert("이관할 자산을 체크해주십시오");
					return;
				}
				if(dataSet.getMarkedCount() > 1 ){
					Rui.alert("자산이관은 1개씩만 가능합니다.");
					return;
				}

			    var chkRow;
				//체크된 자산의 상태 체크
				for(var i = 0; i < dataSet.getCount(); i++){
					if(dataSet.isMarked(i)) {
						var record = dataSet.getAt(i);
						chkRow = i;

						if(record.get("trsfStCd") == undefined || record.get("trsfStCd") == "REJ" || record.get("trsfStCd") == "APPR" || record.get("trsfStCd") == "" ){
						}else{
							if(record.get("trsfStCd") == "RQ"){
								if(  record.get("delYn") == "N" ){
									Rui.alert("이관요청중인 자산입니다.");
									return;
								}
							}
						}
					}
			  	}

				//관리자가 아닐경우 자기 부서 자산만 이관 가능
				if( adminChk == "Y" ){

				}else{
					var chkDeptCd = dataSet.getNameValue(chkRow, "deptCd");

					if( sDeptCd == "58171352"   ){
						sDeptCd = "58141801";
					}

					if( chkDeptCd !=  sDeptCd ){
						Rui.alert("소속부서 자산만 이관이 가능합니다.");
						return;
					}
				}

				var params = "?fxaNm="+escape(encodeURIComponent(dataSet.getNameValue(chkRow, "fxaNm")))
						    +"&fxaNo="+dataSet.getNameValue(chkRow, "fxaNo")
						    +"&deptCd="+dataSet.getNameValue(chkRow, "deptCd")
						    +"&crgrId="+dataSet.getNameValue(chkRow, "crgrId")
						    +"&wbsCd="+dataSet.getNameValue(chkRow, "wbsCd")
						    +"&prjNm="+escape(encodeURIComponent(dataSet.getNameValue(chkRow, "prjNm")))
						    +"&crgrNm="+escape(encodeURIComponent(dataSet.getNameValue(chkRow, "crgrNm")))
						    +"&fxaInfoId="+dataSet.getNameValue(chkRow, "fxaInfoId")
						     ;
				fxaTrsfDialog.setUrl('<c:url value="/fxa/anl/retrieveFxaTrsfPop.do"/>'+params);
				fxaTrsfDialog.show(true);
			}
		});

		/* 엑셀 다운로드 */
		var saveExcelBtn = new Rui.ui.LButton('butExcl');
        saveExcelBtn.on('click', function(){

        	// 엑셀 다운로드시 전체 다운로드를 위해 추가
        	dataSet.clearFilter();

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

   		if( btnRole ==  "N" ){
   			$("#butTrsf").hide();
   		}
	});		//end ready

function imgResize(img){
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



</script>
    </head>
    <body onkeypress="if(event.keyCode==13) {fnSearch();}">
    		<div class="contents">
    			<div class="titleArea">
    				<a class="leftCon" href="#">
			        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        	<span class="hidden">Toggle 버튼</span>
		        	</a>
    				<h2>자산관리</h2>
    		    </div>
    			<div class="sub-content">

					<form name="aform" id="aform" method="post">
					<input type="hidden" id="menuType"  name="menuType" value="IRIFI0101" />
					<input type="hidden" id="rtnUrl"  name="rtnUrl" />
					<input type="hidden" id="fxaInfoId"  name="fxaInfoId" />

					<!-- Role -->
					<input type="hidden" id="roleId" name="roleId"  value="<c:out value='${inputData._roleId}'/>">
					<input type="hidden" id="adminChk" name="adminChk" />

					<div class="search">
						<div class="search-content">
		    				<table id="fxain_size">
		    					<colgroup>
		    						<col style="width:100px"/>
		    						<col style="width:170px"/>
		    						<col style="width:100px"/>
		    						<col style="width:270px"/>
		    						<col style="width:70px"/>
		    						<col style="width:170px"/>
		    						<col style=""/>
		    					</colgroup>
		    					<tbody>
		    					    <!-- <tr>
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
			    							<input type="text" class="" id="fxaNo">
			    						</td>
			    						<td></td>
		    						</tr>
		    						<tr>
		    							<th align="right">자산이관일</th>
		    							<td>
		    								<input type="text" id="fromDate" /><em class="gab"> ~ </em>	<input type="text" id="toDate" />
		    							</td>
		    							<th align="right">담당자</th>
			    						<td>
			    							<input type="text" class="" id="crgrNm" >
			    						</td>
			    						<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
		    						</tr> -->


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
			    						<th align="right">자산명</th>
			   							<td>
			   								<span>
												<input type="text" class="" id="fxaNm" >
											</span>
			   							</td>
		    						</tr>
		    						<tr>
		    							<th align="right">자산번호</th>
			    						<td>
			    							<input type="text" class="" id="fxaNo">
			    						</td>
		    							<th align="right">자산이관일</th>
		    							<td>
		    								<input type="text" id="fromDate" /><em class="gab"> ~ </em>	<input type="text" id="toDate" />
		    							</td>
		    							<th align="right">담당자</th>
			    						<td>
			    							<input type="text" class="" id="crgrNm" >
			    						</td>
			    						<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
		    						</tr>
		    					</tbody>
		    				</table>
		    			</div>
    				</div>

    				<div class="titArea">
    					<span class=table_summay_number id="cnt_text"></span>
						<div class="LblockButton">
    						<button type="button" id="butRgst" name="butRgst" >자산신규</button>
    						<button type="button" id="butMail" name="butMail" >메일</button>
    						<button type="button" id="butTrsf" name="butTrsf" >자산이관</button>
    						<button type="button" id="butExcl" name="butExcl">EXCEL</button>
    					</div>
    				</div>
    				<div id="defaultGrid"></div>

				</form>

    			</div><!-- //sub-content -->
    			<!-- 이미지 -->
	<!-- 이미지 -->
	<div id="imageDialog">
		<div class="hd" id="imgDialTitle">이미지</div>
		<div class="bd" id="imgDialContents">
			<img id="dialogImage" />
		</div>
	</div>
    		</div><!-- //contents -->
    </body>
    </html>