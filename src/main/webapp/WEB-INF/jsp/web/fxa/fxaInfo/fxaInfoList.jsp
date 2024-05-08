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

<%-- excel download --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>

<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
%>

<script type="text/javascript">

	Rui.onReady(function() {
        /*******************
         * 변수 및 객체 선언
         *******************/
         /** dataSet **/
         dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
             	  { id: 'wbsCd' }
 				, { id: 'prjNm' }
 				, { id: 'fxaNo' }
 				, { id: 'fxaNm'}
 				, { id: 'fxaQty'}
 				, { id: 'fxaUtmNm'}
 				, { id: 'crgrNm'}
 				, { id: 'trsfApprDt'}
 				, { id: 'obtPce'}
 				, { id: 'bkpPce'}
 				, { id: 'imgUrl'}
 				, { id: 'fxaLoc'}
 				, { id: 'tagYn'}
 				, { id: 'rlisDt'}
 				, { id: 'prjCd'}
 				, { id: 'attcFilId'}
 				, { id: 'crgrId'}
 				, { id: 'fxaInfoId'}
 			]
         });


         var columnModel = new Rui.ui.grid.LColumnModel({
             columns: [
         	 	new Rui.ui.grid.LSelectionColumn(),
 					   { field: 'wbsCd'      , label: 'WBS 코드',  	sortable: false,	align:'center', width: 100, autoWidth: true}
                     , { field: 'prjNm'      , label: '프로젝트명',  	sortable: false,	align:'center', width: 200, autoWidth: true}
                     , { field: 'fxaNo'      , label: '자산번호',  	sortable: false,	align:'center', width: 90, autoWidth: true}
                     , { field: 'fxaNm'      , label: '자산명',  		sortable: false,	align:'center', width:180, hidden: true}
                     , { field: 'fxaQty' 	, label: '수량',  		sortable: false,	align:'center', width: 30, autoWidth: true}
                     , { field: 'fxaUtmNm'   , label: '단위',  		sortable: false,	align:'center', width: 50, autoWidth: true}
                     , { field: 'crgrNm'     , label: '담당자',  		sortable: false,	align:'center', width: 100, autoWidth: true}
                     , { field: 'trsfApprDt' , label: '자산이관일',  	sortable: false,	align:'center', width: 110, autoWidth: true}
                     , { field: 'obtPce' 	, label: '취득가',  		sortable: false,	align:'center', width: 100,
                    	 renderer: function(value, p, record){
         	        		return Rui.util.LFormat.numberFormat(parseInt(value));
         		        }
                     }
                     , { field: 'bkpPce' 	, label: '장부가',  		sortable: false,	align:'center', width: 100,
                    	 renderer: function(value, p, record){
         	        		return Rui.util.LFormat.numberFormat(parseInt(value));
         		        }
                     }
                     , { field: 'imgUrl' 	, label: '사진',  	}
                     , { field: 'fxaLoc' 	, label: '위치',  		sortable: false,	align:'center', width: 100, autoWidth: true}
                     , { field: 'tagYn' 		, label: '태그',  		sortable: false,	align:'center', width: 30, autoWidth: true}
                     , { field: 'rlisDt' 	, label: '실사일',  		sortable: false,	align:'center', width: 100, autoWidth: true}
             	    , { field: 'prjCd'      , hidden : true}
             	    , { field: 'crgrId'      , hidden : true}
             	    , { field: 'fxaInfoId'  , hidden : true}
             ]
         });

         /** default grid **/
         var grid = new Rui.ui.grid.LGridPanel({
             columnModel: columnModel,
             dataSet: dataSet,
             width: 600,
             height: 300,
             autoToEdit: false,
             autoWidth: true
         });


         grid.render('defaultGrid');

         grid.on('cellClick', function(e) {
 			var record = dataSet.getAt(dataSet.getRow());

 			if(dataSet.getRow() > -1) {
 				if(e.col == 10) {
 					Rui.getDom('dialogImage').src = '<%=newImagePath%>/board_qna/Lighthouse.jpg';
 					Rui.get('imgDialTitle').html('자산이미지');
 		<%-- 			Rui.getDom('dialogImage').src = <%=newImagePath%> + record.get('imgFilPath') + '/' + record.get('imgFilNm'); --%>

 					imageDialog.clearInvalid();
 					imageDialog.show(true);
 		        }else{
	 				document.aform.fxaInfoId.value = record.get("fxaInfoId");
					document.aform.action="<c:url value="/fxa/fxaInfo/retrieveFxaInfoDtl.do"/>";
					document.aform.submit();
 		        }

 			}
 	 	});

         /* [ 이미지 Dialog] */
     	var imageDialog = new Rui.ui.LDialog({
             applyTo: 'imageDialog',
             width: 400,
             height: 400,
             visible: false,
             postmethod: 'none',
             buttons: [
                 { text:'닫기', isDefault: true, handler: function() {
                     this.cancel(false);
                 } }
             ]
         });
     	imageDialog.hide(true);

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
 	    var fxaNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'fxaNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //담당자
 	    var crgrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
 	        applyTo: 'crgrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
 	        width: 200,                                    // 텍스트박스 폭을 설정
 	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
 	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
 	    });

       //자산이관 시작일
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

	 	//자산이관 종료일
		var toDate = new Rui.ui.form.LDateBox({
			applyTo: 'toDate',
			mask: '9999-99-99',
			displayValue: '%Y-%m-%d',
			defaultValue : '',		// default -1년
			width: 100,
			dateType: 'string'
		});

		toDate.on('blur', function(){
			if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toDate.getValue(),"-","")) ) )  {
				alert('날자형식이 올바르지 않습니다.!!');
				toDate.setValue(new Date());
			}
		});

        fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/fxa/fxaInfo/retrieveFxaInfoSearchList.do"/>' ,
	            params :{
	    		    fromDate : nwinsReplaceAll(fromDate.getValue(), "-",""),	// 시공(예정)일 - reqdt, 시공주문일 - ordrdt,
	    		    toDate : nwinsReplaceAll(toDate.getValue(), "-",""),		// 시공(예정)일 - reqdt, 시공주문일 - ordrdt,
	    		    wbsCd : document.aform.wbsCd.value, 		// wbsCd
	    		    fxaNm : encodeURIComponent(document.aform.fxaNm.value),	//자산명
	    		    crgrNm : encodeURIComponent(document.aform.crgrNm.value),						// 담당자
	    		    fxaNo : document.aform.fxaNo.value,						// 자산번호
                }
            });

        }
        // 화면로드시 조회
	    fnSearch();

	});		//end ready





</script>
    </head>
    <body>
    		<div class="contents">
    			<div class="titleArea">
    				<h2>자산관리</h2>
    		    </div>
    			<div class="sub-content">

					<form name="aform" id="aform" method="post">
					<input type="hidden" name="menuType"  name="menuType" />
					<input type="hidden" name="prjCd"  name="prjCd"  />
					<input type="hidden" name="crgrId"  name="crgrId" />
					<input type="hidden" name="fxaInfoId"  name="fxaInfoId" />

    				<table class="searchBox">
    					<colgroup>
    						<col style="width:15%"/>
    						<col style="width:30%"/>
    						<col style="width:15%"/>
    						<col style="width:"/>
    						<col style="width:10%"/>
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
	    						<td rowspan="3" class="t_center">
    								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
    							</td>
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
    						</tr>
    					</tbody>
    				</table>

    				<div class="titArea">
    					<h3></h3>
						<div class="LblockButton">
    						<button type="button" id="butRgst" name="butRgst"  onclick="javascript:fncFxaRgstPage();" >자산신규</button>
    						<button type="button" id="butMail" name="butMail" onclick="javascript:fncMail();">메일</button>
    						<button type="button" id="butTrsf" name="butTrsf" onclick="javascript:fncFxaTrsf();">자산이관</button>
    						<button type="button" id="butExcl" name="butExcl" onclick="javascript:retrieveFxaInfoListExcel();">EXCEL</button>
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
			<img id="dialogImage"/>
		</div>
	</div>
    		</div><!-- //contents -->
    </body>
    </html>