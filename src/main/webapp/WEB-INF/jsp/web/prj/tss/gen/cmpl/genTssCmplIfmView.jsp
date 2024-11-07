<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssCmplIfm.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.08
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>
<style>
 .L-tssLable {
 border: 0px
 }
</style>
<%
    pageContext.setAttribute("cn", "\n");    //Enter
    pageContext.setAttribute("br", "<br/>");    //Enter
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.cmplTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPgsStepCd = window.parent.gvPgsStepCd;
    var lvPageMode = window.parent.gvPageMode;

    var initFlowYn = (window.parent.initFlowYn) ? window.parent.initFlowYn : ""; //초기유동관리여부
    var initFlowStrtDd = (window.parent.initFlowStrtDd) ? window.parent.initFlowStrtDd : ""; //초기유동관리시작일
    var initFlowFnhDd = (window.parent.initFlowFnhDd) ? window.parent.initFlowFnhDd : ""; //초기유동관리종료일
    
    console.log("[lvTssCd]", lvTssCd);
    console.log("[lvUserId]", lvUserId);
    console.log("[lvTssSt]", lvTssSt);
    console.log("[lvPageMode]", lvPageMode);

    console.log("[initFlowYn]", initFlowYn);
    console.log("[initFlowStrtDd]", initFlowStrtDd);
    console.log("[initFlowFnhDd]", initFlowFnhDd);

    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";

    var dataSet;
    var lvAttcFilId;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        
        //Form 비활성화 여부
        disableFields = function() {
            //버튼여부
            /* btnCsusRq.hide();*/
        }
     
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	 { id: 'tssCd'} 
             	,{ id: 'tssSmryTxt'}
             	,{ id: 'tssSmryDvlpTxt'}
             	,{ id: 'rsstDvlpOucmTxt'}
             	,{ id: 'rsstDvlpOucmCtqTxt'}
             	,{ id: 'rsstDvlpOucmEffTxt'}
             	,{ id: 'pmisTxt'}  
             	,{ id: 'qgate3Dt'}
             	,{ id: 'fwdPlnTxt'}
             	,{ id: 'fnoPlnTxt'}
             	,{ id: 'ancpOtPlnDt'} 
             	,{ id: 'cmplAttcFilId'}     //완료첨부파일
             	//,{ id: 'initFlowAttcFilId'} //초기유동첨부파일
             	,{ id: 'pmisCmplTxt'}
             	,{ id: 'bizPrftProY'}
             	,{ id: 'bizPrftProY1'}  
             	,{ id: 'bizPrftProY2'}  
             	,{ id: 'bizPrftProY3'}  
             	,{ id: 'bizPrftProY4'}
             	,{ id: 'bizPrftProCurY'}
             	,{ id: 'bizPrftProCurY1'}
             	,{ id: 'bizPrftProCurY2'}
             	,{ id: 'bizPrftPlnY'} 
             	,{ id: 'bizPrftPlnY1'} 
             	,{ id: 'bizPrftPlnY2'} 
             	,{ id: 'bizPrftCurY'} 
             	,{ id: 'bizPrftCurY1'} 
             	,{ id: 'bizPrftCurY2'} 
             	,{ id: 'nprodSalsPlnY'} 
             	,{ id: 'nprodSalsPlnY1'} 
             	,{ id: 'nprodSalsPlnY2'} 
             	,{ id: 'nprodSalsPlnY3'} 
             	,{ id: 'nprodSalsPlnY4'} 
             	,{ id: 'nprodSalsCurY'} 
             	,{ id: 'nprodSalsCurY1'} 
             	,{ id: 'nprodSalsCurY2'} 
             	,{ id: 'ptcCpsnY'} 
             	,{ id: 'ptcCpsnY1'} 
             	,{ id: 'ptcCpsnY2'} 
             	,{ id: 'ptcCpsnY3'} 
             	,{ id: 'ptcCpsnY4'} 
             	,{ id: 'ptcCpsnCurY'} 
             	,{ id: 'ptcCpsnCurY1'} 
             	,{ id: 'ptcCpsnCurY2'} 
             	,{ id: 'ptcCpsnCurY3'} 
             	,{ id: 'ptcCpsnCurY4'} 
             	,{ id: 'expArslY'} 
             	,{ id: 'expArslY1'} 
             	,{ id: 'expArslY2'} 
             	,{ id: 'expArslY3'} 
             	,{ id: 'expArslY4'} 
             	,{ id: 'expArslCurY'} 
             	,{ id: 'expArslCurY1'} 
             	,{ id: 'expArslCurY2'} 
             	,{ id: 'expArslCurY3'} 
             	,{ id: 'expArslCurY4'} 
             	,{ id: 'nprodNm'} 
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");
        	
        	disableFields();
        	
        	lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "cmplAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();
            
            spInfo = "";
            spInfo = spInfo + initFlowYn;
            if (initFlowYn == 'Y') {
            	spInfo = spInfo +' / '+initFlowStrtDd +' ~ '+ initFlowFnhDd
            } else {
            	spInfo = (spInfo == '')?spInfo = 'N': spInfo;
            }
            $("#spInitFlowInfo").text(spInfo);
            
        });

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //첨부파일 조회
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

        //첨부파일 등록 팝업
        getAttachFileId = function() {
            return stringNullChk(lvAttcFilId);
        };

        setAttachFileInfo = function(attachFileList) {
            $('#attchFileView').html('');

            for(var i = 0; i < attachFileList.length; i++) {
                $('#attchFileView').append($('<a/>', {
                    href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                    text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                })).append('<br/>');
            }

            if(attachFileList.length > 0) {
                lvAttcFilId = attachFileList[0].data.attcFilId;
                dataSet.setNameValue(0, "attcFilId", lvAttcFilId)
            }
        };

        downloadAttachFile = function(attcFilId, seq) {
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };

        //목록
       /*  var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        }); */
        
        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                 { id: 'tssCd',              ctrlId: 'tssCd',              value: 'value' }
                ,{ id: 'userId',             ctrlId: 'userId',             value: 'value' }
                ,{ id: 'tssSmryTxt'        , ctrlId: 'tssSmryTxt'        , value: 'html'}
                ,{ id: 'tssSmryDvlpTxt'    , ctrlId: 'tssSmryDvlpTxt'    , value: 'html'}
                ,{ id: 'rsstDvlpOucmTxt'   , ctrlId: 'rsstDvlpOucmTxt'   , value: 'html'}
                ,{ id: 'rsstDvlpOucmCtqTxt', ctrlId: 'rsstDvlpOucmCtqTxt', value: 'html'}
                ,{ id: 'rsstDvlpOucmEffTxt', ctrlId: 'rsstDvlpOucmEffTxt', value: 'html'}
                ,{ id: 'pmisTxt'           , ctrlId: 'pmisTxt'           , value: 'html'}
                ,{ id: 'qgate3Dt'          , ctrlId: 'qgate3Dt'          , value: 'html'}
                ,{ id: 'fwdPlnTxt'         , ctrlId: 'fwdPlnTxt'         , value: 'html'}
                ,{ id: 'fnoPlnTxt'         , ctrlId: 'fnoPlnTxt'         , value: 'html'}
                
                ,{ id: 'initFlowYn'        , ctrlId: 'initFlowYn'        , value: 'html'}
                ,{ id: 'initFlowStrtDd'    , ctrlId: 'initFlowStrtDd'    , value: 'html'}
                ,{ id: 'initFlowFnhDd'     , ctrlId: 'initFlowFnhDd'     , value: 'html'}
                
                ,{ id: 'pmisCmplTxt'       , ctrlId: 'pmisCmplTxt'       , value: 'html'}
                ,{ id: 'nprodNm'           , ctrlId: 'nprodNm'           , value: 'html'}
                ,{ id: 'ancpOtPlnDt'       , ctrlId: 'ancpOtPlnDt'       , value: 'html'}
                ,{ id: 'bizPrftProY'       , ctrlId: 'bizPrftProY'       , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftProY1'      , ctrlId: 'bizPrftProY1'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftProY2'      , ctrlId: 'bizPrftProY2'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftProY3'      , ctrlId: 'bizPrftProY3'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftProY4'      , ctrlId: 'bizPrftProY4'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    

                ,{ id: 'bizPrftProCurY'    , ctrlId: 'bizPrftProCurY'    , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftProCurY1'   , ctrlId: 'bizPrftProCurY1'   , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftProCurY2'   , ctrlId: 'bizPrftProCurY2'   , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                
                ,{ id: 'bizPrftPlnY'       , ctrlId: 'bizPrftPlnY'       , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftPlnY1'      , ctrlId: 'bizPrftPlnY1'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftPlnY2'      , ctrlId: 'bizPrftPlnY2'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftCurY'       , ctrlId: 'bizPrftCurY'       , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftCurY1'      , ctrlId: 'bizPrftCurY1'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'bizPrftCurY2'      , ctrlId: 'bizPrftCurY2'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'nprodSalsPlnY'     , ctrlId: 'nprodSalsPlnY'     , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'nprodSalsPlnY1'    , ctrlId: 'nprodSalsPlnY1'    , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'nprodSalsPlnY2'    , ctrlId: 'nprodSalsPlnY2'    , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'nprodSalsPlnY3'    , ctrlId: 'nprodSalsPlnY3'    , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'nprodSalsPlnY4'    , ctrlId: 'nprodSalsPlnY4'    , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'nprodSalsCurY'     , ctrlId: 'nprodSalsCurY'     , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'nprodSalsCurY1'    , ctrlId: 'nprodSalsCurY1'    , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'nprodSalsCurY2'    , ctrlId: 'nprodSalsCurY2'    , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'ptcCpsnY'          , ctrlId: 'ptcCpsnY'          , value: 'html'}
                ,{ id: 'ptcCpsnY1'         , ctrlId: 'ptcCpsnY1'         , value: 'html'}
                ,{ id: 'ptcCpsnY2'         , ctrlId: 'ptcCpsnY2'         , value: 'html'}
                ,{ id: 'ptcCpsnY3'         , ctrlId: 'ptcCpsnY3'         , value: 'html'}
                ,{ id: 'ptcCpsnY4'         , ctrlId: 'ptcCpsnY4'         , value: 'html'}
                ,{ id: 'ptcCpsnCurY'       , ctrlId: 'ptcCpsnCurY'       , value: 'html'}
                ,{ id: 'ptcCpsnCurY1'      , ctrlId: 'ptcCpsnCurY1'      , value: 'html'}
                ,{ id: 'ptcCpsnCurY2'      , ctrlId: 'ptcCpsnCurY2'      , value: 'html'}
                ,{ id: 'ptcCpsnCurY3'      , ctrlId: 'ptcCpsnCurY3'      , value: 'html'}
                ,{ id: 'ptcCpsnCurY4'      , ctrlId: 'ptcCpsnCurY4'      , value: 'html'}
                ,{ id: 'expArslY'          , ctrlId: 'expArslY'          , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslY1'         , ctrlId: 'expArslY1'         , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslY2'         , ctrlId: 'expArslY2'         , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslY3'         , ctrlId: 'expArslY3'         , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslY4'         , ctrlId: 'expArslY4'         , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslCurY'       , ctrlId: 'expArslCurY'       , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslCurY1'      , ctrlId: 'expArslCurY1'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslCurY2'      , ctrlId: 'expArslCurY2'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslCurY3'      , ctrlId: 'expArslCurY3'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'expArslCurY4'      , ctrlId: 'expArslCurY4'      , value: 'html', renderer: function(value) {
                	if ( parseFloat(value) > 0 ){
                    	return Rui.util.LFormat.numberFormat(parseFloat(value));
        			}else{
        				return "";
        			}
                }
            }    
                ,{ id: 'cmplAttcFilId'     , ctrlId: 'cmplAttcFilId'     , value: 'html'}
            ]
        });

        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet.loadData(${result});
        } 
    });


</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("aFormDiv");
});
</script>
</head>
<body>
<div id="aFormDiv">
    <form name="aForm" id="aForm" method="post" style="padding: 20px 1px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->

<table class="table table_txt_right" id="grsDev">
			<colgroup>
				<col style="width: 20%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
			</colgroup>
			<tbody>
				<tr>
	  				<th rowspan="2"></th>
	  				<th class="alignC"  colspan="2">출시년도</th>
	  				<th class="alignC"  colspan="2">출시년도+1</th>
	  				<th class="alignC"  colspan="2">출시년도+2</th>
	  				<th class="alignC"  colspan="2">출시년도+3</th>
	  				<th class="alignC"  colspan="2">출시년도+4</th>
	  			</tr>
	  			<tr>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  			</tr>
	  			<tr id="trNprodSal">
	  				<th>영업이익률(%)</th>
	  				<td class="alignR" ><span id="bizPrftProY" /></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftProCurY" /></td>
	  				<td class="alignR" ><span id="bizPrftProY1"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftProCurY1"/></td>
	  				<td class="alignR" ><span id="bizPrftProY2"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftProCurY2"/></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'></td>
	  			</tr>
	  			<tr id="trbizPrftPln" >
	  				<th>영업이익(억원)</th>
	  				<td class="alignR" ><span id="bizPrftPlnY"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftCurY"/></td>
	  				<td class="alignR" ><span id="bizPrftPlnY1"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftCurY1"/></td>
	  				<td class="alignR" ><span id="bizPrftPlnY2"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="bizPrftCurY2"/></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'></td>
	  			</tr>
	  			<tr id="trNprodSal"  >
	  				<th>매출액(억원)</th>
	  				<td class="alignR" ><span id="nprodSalsPlnY" /></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="nprodSalsCurY" /></td>
	  				<td class="alignR" ><span id="nprodSalsPlnY1"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="nprodSalsCurY1"/></td>
	  				<td class="alignR" ><span id="nprodSalsPlnY2"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="nprodSalsCurY2"/></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'></td>
	  			</tr>
				<tr id="trPtcCpsnHead" >
	  				<th rowspan="2"></th>
	  				<th class="alignC"  colspan="2">과제시작년도</th>
	  				<th class="alignC"  colspan="2">과제시작년도+1</th>
	  				<th class="alignC"  colspan="2">과제시작년도+2</th>
	  				<th class="alignC"  colspan="2">과제시작년도+3</th>
	  				<th class="alignC"  colspan="2">과제시작년도+4</th>
	  			</tr>
	  			<tr>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  			</tr>
	  			<tr id="trPtcCpsn" >
	  				<th>투입인원(M/M)</th>
	  				<td class="alignR" ><span id="ptcCpsnY"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY"/></td>
	  				<td class="alignR" ><span id="ptcCpsnY1"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY1"/></td>
	  				<td class="alignR" ><span id="ptcCpsnY2"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY2"/></td>
	  				<td class="alignR" ><span id="ptcCpsnY3"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY3"/></td>
	  				<td class="alignR" ><span id="ptcCpsnY4"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="ptcCpsnCurY4"/></td>
	  			</tr>
	  			<tr id="trExpArsl" >
	  				<th>투입비용(억원)</th>
	  				<td class="alignR" ><span id="expArslY" /></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY"/></td>
	  				<td class="alignR" ><span id="expArslY1"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY1"/></td>
	  				<td class="alignR" ><span id="expArslY2"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY2"/></td>
	  				<td class="alignR" ><span id="expArslY3"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY3"/></td>
	  				<td class="alignR" ><span id="expArslY4"/></td>
	  				<td class="alignR"  bgcolor='#E6E6E6'><span id="expArslCurY4"/></td>
	  			</tr>
			</tbody>
		</table>
		<table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: *;" />
                <col style="width: 150px;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">과제개요</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right"><span style="color:red;">* </span>연구과제 배경<br/>및 필요성</th>
                                    <td><pre><span id="tssSmryTxt" /></pre></td>
                                </tr>
                                <tr>
                                    <th align="right"><span style="color:red;">* </span>주요 연구 개발 내용</th>
                                    <td><pre><span id="tssSmryDvlpTxt" /></pre></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">연구개발성과</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2" align="right">지적재산권</th>
                                    <th align="right"><span style="color:red;">* </span>지재권 출원현황<br/>(국내/해외)</th>
                                    <td><pre><span id="rsstDvlpOucmTxt" /></pre></td>
                                </tr>
                                <tr>
                                <th align="right"><span style="color:red;">* </span>특허 Risk 검토결과</th>
                                    <td><pre><span id="pmisCmplTxt" name="pmisCmplTxt"></pre></td>
                                </tr>
                                <tr>
                                    <th align="right">목표기술성과</th>
                                    <th align="right">핵심 CTQ/품질 수준<br/>(경쟁사 비교)</th>
                                    <td><pre><span id="rsstDvlpOucmCtqTxt" /></pre></td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">파급효과 및 응용분야</th>
                                    <td><pre><span id="rsstDvlpOucmEffTxt" /></pre></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right" rowspan="2"><span style="color:red;">* </span>사업화 출시 계획</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">신제품명</th>
                                    <td><span id="nprodNm" /></td>
                                </tr>
                                <tr>
                                    <th align="right">예상출시일(계획)</th>
                                    <td><span id="ancpOtPlnDt" /></td>
                                </tr>
                                <tr>
                                    <th align="right">Qgate3(품질평가단계) 패스일자</th>
                                    <td><span id="qgate3Dt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><pre><span id="fwdPlnTxt" /></pre></td>
                </tr>
                <tr>
                    <th align="right"><span style="color:red;">* </span>향후 계획</th>
                    <td colspan="2"><pre><span id="fnoPlnTxt" /></pre></td>
                </tr>
                <tr>
                    <th align="right">초기유동관리여부</th>
                    <td colspan="2">
                    	<span id="spInitFlowInfo" />
                    </td>
                </tr>
                <tr>
                    <th align="right">과제완료보고서 및 기타</th>
                    <td id="attchFileView" colspan="2">&nbsp;</td>
                </tr>
            </tbody>
        </table>
            
    </form>
</div>
<div class="titArea">
    <div class="LblockButton">
       <!--  <button type="button" id="btnSave" name="btnSave">저장</button> -->
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>