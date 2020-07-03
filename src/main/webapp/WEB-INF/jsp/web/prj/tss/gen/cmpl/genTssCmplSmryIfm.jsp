<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssCmplSmryIfm.jsp
 * @desc    : 
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2020.04.14
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
<style>
 .L-tssLable {
 border: 0px
 }
</style>
<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd    = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt    = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = lvPgsCd == "PG" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var lvAttcFilId;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //요약개요
        smrSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrSmryTxt',
            height: 100,
            width: 600
        });
        
        //요약목표
        smrGoalTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrGoalTxt',
            height: 100,
            width: 600
        });
      
        //시장규모
        mrktSclTxt = new Rui.ui.form.LTextArea({
            applyTo: 'mrktSclTxt',
            editable: false,
            height: 100,
            width: 600
        });
       
        //지적재산권 결과 통보
        pmisTxt = new Rui.ui.form.LTextArea({
            applyTo: 'pmisTxt',
            editable: false,
            height: 100,
            width: 600
        });
      
        //상품출시(계획)
        ctyOtPlnM = new Rui.ui.form.LTextBox({
            applyTo: 'ctyOtPlnM',
            editable: false,
            width: 120
        });
        
        //영업이익율Y
        bizPrftProY = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY',
            decimalPrecision: 2,
            width: 120
        });
        
        //영업이익율Y+1
        bizPrftProY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY1',
            decimalPrecision: 2,
            width: 120
        });
        
        //영업이익율Y+2
        bizPrftProY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY2',
            decimalPrecision: 2,
            width: 120
        });
        
        //영업이익율Y+3
        bizPrftProY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY3',
            decimalPrecision: 2,
            width: 120
        });
        
        //영업이익율Y+4
        bizPrftProY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProY4',
            decimalPrecision: 2,
            width: 120
        });
        
        //신제품매출계획Y
        nprodSalsPlnY = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY',
            decimalPrecision: 2,
            editable: false,
            width: 120
        });
        
        //신제품매출계획Y+1
        nprodSalsPlnY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY1',
            decimalPrecision: 2,
            editable: false,
            width: 120
        });
        
        //신제품매출계획Y+2
        nprodSalsPlnY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY2',
            decimalPrecision: 2,
            editable: false,
            width: 120
        });
        
        //신제품매출계획Y+3
        nprodSalsPlnY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY3',
            decimalPrecision: 2,
            editable: false,
            width: 120
        });
        
        //신제품매출계획Y+4
        nprodSalsPlnY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsPlnY4',
            decimalPrecision: 2,
            editable: false,
            width: 120
        });
        
        //투입인원(M/M)Y
        ptcCpsnY = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY',
            editable: false,
            width: 120
        });
        
        //투입인원(M/M)Y+1
        ptcCpsnY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY1',
            editable: false,
            width: 120
        });
        
        //투입인원(M/M)Y+2
        ptcCpsnY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY2',
            editable: false,
            width: 120
        });
        
        //투입인원(M/M)Y+3
        ptcCpsnY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY3',
            editable: false,
            width: 120
        });
        
        //투입인원(M/M)Y+4
        ptcCpsnY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnY4',
            editable: false,
            width: 120
        });
        
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "R") {
            }
            
            //css적용
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
        };
      

        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
	            	 { id: 'tssCd'} 
	            	,{ id: 'smrSmryTxt'} 
	            	,{ id: 'smrGoalTxt'} 
	            	,{ id: 'smryNTxt'} 
	            	,{ id: 'smryATxt'} 
	            	,{ id: 'smryBTxt'} 
	            	,{ id: 'smryCTxt'} 
	            	,{ id: 'smryDTxt'} 
	            	,{ id: 'mrktSclTxt'} 
	            	,{ id: 'ctyOtPlnM'} 
	            	,{ id: 'bizPrftPro'}
	            	,{ id: 'bizPrftProY1'}  
	            	,{ id: 'bizPrftProY2'}  
	            	,{ id: 'bizPrftProY3'}  
	            	,{ id: 'bizPrftProY4'}  
	            	,{ id: 'bizPrftPlnY'} 
	            	,{ id: 'bizPrftPlnY1'} 
	            	,{ id: 'bizPrftPlnY2'} 
	            	,{ id: 'bizPrftCurY'} 
	            	,{ id: 'bizPrftCurY1'} 
	            	,{ id: 'bizPrftCurY2'} 
	            	,{ id: 'nprodSalsPlnY '} 
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
	            	,{ id: 'attcFilId'} 
	            	,{ id: 'pmisTxt'} 
                    ,{ id: 'userId'}           //로그인ID
            ]
        });
        
        dataSet.on('update', function(e) {
            console.log("smry c:"+e.colId+", v:"+e.value);
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");
            
            tabViewS.selectTab(0);
            
            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();
           /*  
            var dsNprodSalsPlnY  = (dataSet.getNameValue(0, "nprodSalsPlnY")  / 1000000).toFixed(6);
            var dsNprodSalsPlnY1 = (dataSet.getNameValue(0, "nprodSalsPlnY1") / 1000000).toFixed(6);
            var dsNprodSalsPlnY2 = (dataSet.getNameValue(0, "nprodSalsPlnY2") / 1000000).toFixed(6);
            var dsNprodSalsPlnY3 = (dataSet.getNameValue(0, "nprodSalsPlnY3") / 1000000).toFixed(6);
            var dsNprodSalsPlnY4 = (dataSet.getNameValue(0, "nprodSalsPlnY4") / 1000000).toFixed(6);
            
            nprodSalsPlnY.setValue(dsNprodSalsPlnY);
            nprodSalsPlnY1.setValue(dsNprodSalsPlnY1);
            nprodSalsPlnY2.setValue(dsNprodSalsPlnY2);
            nprodSalsPlnY3.setValue(dsNprodSalsPlnY3);
            nprodSalsPlnY4.setValue(dsNprodSalsPlnY4);
            
            fnGetYAvg(); */
        });
        
        
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'smryFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
	            	 { id: 'tssCd'            , ctrlId: 'tssCd'           , value= 'html'}
	            	,{ id: 'smrSmryTxt'       , ctrlId: 'smrSmryTxt'      , value= 'html'}
	            	,{ id: 'smrGoalTxt'       , ctrlId: 'smrGoalTxt'      , value= 'html'}
	            	,{ id: 'smryNTxt'         , ctrlId: 'smryNTxt'        , value= 'html'}
	            	,{ id: 'smryATxt'         , ctrlId: 'smryATxt'        , value= 'html'}
	            	,{ id: 'smryBTxt'         , ctrlId: 'smryBTxt'        , value= 'html'}
	            	,{ id: 'smryCTxt'         , ctrlId: 'smryCTxt'        , value= 'html'}
	            	,{ id: 'smryDTxt'         , ctrlId: 'smryDTxt'        , value= 'html'}
	            	,{ id: 'mrktSclTxt'       , ctrlId: 'mrktSclTxt'      , value= 'html'}
	            	,{ id: 'ctyOtPlnM'        , ctrlId: 'ctyOtPlnM'       , value= 'html'}
	            	,{ id: 'bizPrftPro'       , ctrlId: 'bizPrftPro'      , value= 'html'}
	            	,{ id: 'bizPrftProY1'     , ctrlId: 'bizPrftProY1'    , value= 'html'}
	            	,{ id: 'bizPrftProY2'     , ctrlId: 'bizPrftProY2'    , value= 'html'}
	            	,{ id: 'bizPrftProY3'     , ctrlId: 'bizPrftProY3'    , value= 'html'}
	            	,{ id: 'bizPrftProY4'     , ctrlId: 'bizPrftProY4'    , value= 'html'}
	            	,{ id: 'bizPrftPlnY'      , ctrlId: 'bizPrftPlnY'     , value= 'html'}
	            	,{ id: 'bizPrftPlnY1'     , ctrlId: 'bizPrftPlnY1'    , value= 'html'}
	            	,{ id: 'bizPrftPlnY2'     , ctrlId: 'bizPrftPlnY2'    , value= 'html'}
	            	,{ id: 'bizPrftCurY'      , ctrlId: 'bizPrftCurY'     , value= 'html'}
	            	,{ id: 'bizPrftCurY1'     , ctrlId: 'bizPrftCurY1'    , value= 'html'}
	            	,{ id: 'bizPrftCurY2'     , ctrlId: 'bizPrftCurY2'    , value= 'html'}
	            	,{ id: 'nprodSalsPlnY '   , ctrlId: 'nprodSalsPlnY '  , value= 'html'}
	            	,{ id: 'nprodSalsPlnY1'   , ctrlId: 'nprodSalsPlnY1'  , value= 'html'}
	            	,{ id: 'nprodSalsPlnY2'   , ctrlId: 'nprodSalsPlnY2'  , value= 'html'}
	            	,{ id: 'nprodSalsPlnY3'   , ctrlId: 'nprodSalsPlnY3'  , value= 'html'}
	            	,{ id: 'nprodSalsPlnY4'   , ctrlId: 'nprodSalsPlnY4'  , value= 'html'}
	            	,{ id: 'nprodSalsCurY'    , ctrlId: 'nprodSalsCurY'   , value= 'html'}
	            	,{ id: 'nprodSalsCurY1'   , ctrlId: 'nprodSalsCurY1'  , value= 'html'}
	            	,{ id: 'nprodSalsCurY2'   , ctrlId: 'nprodSalsCurY2'  , value= 'html'}
	            	,{ id: 'ptcCpsnY'         , ctrlId: 'ptcCpsnY'        , value= 'html'}
	            	,{ id: 'ptcCpsnY1'        , ctrlId: 'ptcCpsnY1'       , value= 'html'}
	            	,{ id: 'ptcCpsnY2'        , ctrlId: 'ptcCpsnY2'       , value= 'html'}
	            	,{ id: 'ptcCpsnY3'        , ctrlId: 'ptcCpsnY3'       , value= 'html'}
	            	,{ id: 'ptcCpsnY4'        , ctrlId: 'ptcCpsnY4'       , value= 'html'}
	            	,{ id: 'ptcCpsnCurY'      , ctrlId: 'ptcCpsnCurY'     , value= 'html'}
	            	,{ id: 'ptcCpsnCurY1'     , ctrlId: 'ptcCpsnCurY1'    , value= 'html'}
	            	,{ id: 'ptcCpsnCurY2'     , ctrlId: 'ptcCpsnCurY2'    , value= 'html'}
	            	,{ id: 'ptcCpsnCurY3'     , ctrlId: 'ptcCpsnCurY3'    , value= 'html'}
	            	,{ id: 'ptcCpsnCurY4'     , ctrlId: 'ptcCpsnCurY4'    , value= 'html'}
	            	,{ id: 'expArslY'         , ctrlId: 'expArslY'        , value= 'html'}
	            	,{ id: 'expArslY1'        , ctrlId: 'expArslY1'       , value= 'html'}
	            	,{ id: 'expArslY2'        , ctrlId: 'expArslY2'       , value= 'html'}
	            	,{ id: 'expArslY3'        , ctrlId: 'expArslY3'       , value= 'html'}
	            	,{ id: 'expArslY4'        , ctrlId: 'expArslY4'       , value= 'html'}
	            	,{ id: 'expArslCurY'      , ctrlId: 'expArslCurY'     , value= 'html'}
	            	,{ id: 'expArslCurY1'     , ctrlId: 'expArslCurY1'    , value= 'html'}
	            	,{ id: 'expArslCurY2'     , ctrlId: 'expArslCurY2'    , value= 'html'}
	            	,{ id: 'expArslCurY3'     , ctrlId: 'expArslCurY3'    , value= 'html'}
	            	,{ id: 'expArslCurY4'     , ctrlId: 'expArslCurY4'    , value= 'html'}
	            	,{ id: 'attcFilId'        , ctrlId: 'attcFilId'       , value= 'html'}
	            	,{ id: 'pmisTxt'          , ctrlId: 'pmisTxt'         , value= 'html'}
            ]
        });
        
        tabViewS = new Rui.ui.tab.LTabView({
            tabs: [
                {label: 'Needs', content: ''}, 
                {label: 'Approach', content: ''}, 
                {label: 'Benefit', content: ''}, 
                {label: 'Competition', content: ''}, 
                {label: 'Deliverables ', content: ''}
            ]
        });
        
        tabViewS.on('activeTabChange', function(e) {
            var index = e.activeIndex;
            var pSmryTxt = "";
            
            if(index == 0) {
                if(e.isFirst) {
                    pSmryTxt = dataSet.getNameValue(0, "smryNTxt") + "<br/>";    
                } else {
                    pSmryTxt = dataSet.getNameValue(0, "smryNTxt");
                }
            }
            else if(index == 1) {
                pSmryTxt = dataSet.getNameValue(0, "smryATxt");
            }
            else if(index == 2) {
                pSmryTxt = dataSet.getNameValue(0, "smryBTxt");
            }
            else if(index == 3) {
                pSmryTxt = dataSet.getNameValue(0, "smryCTxt");
            }
            else if(index == 4) {
                pSmryTxt = dataSet.getNameValue(0, "smryDTxt");
            }
            
            document.getElementById('smryTxt').innerHTML = pSmryTxt;
            
            initFrameSetHeight("smryFormDiv");
        });
        
        tabViewS.render('tabViewS');
        
        
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
            smryForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            smryForm.submit();
        };

        
        //목록 
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
         */
        
        //데이터 셋팅 
        if(${resultCnt} > 0) { 
            console.log("smry searchData1");
            dataSet.loadData(${result}); 
        } else {
            console.log("smry searchData2");
            dataSet.newRecord();
        }
        
        
        disableFields();
    });
    
    //평균구하기
    function fnGetYAvg() {
        /*
        var y  = 0;
        var y1 = 0;
        var y2 = 0;
        var y3 = 0;
        var y4 = 0;
        
        var cnt  = 0;
        var yAvg = 0;
        
        //신제품 매출계획(단위:억원)
        cnt  = 0;
        yAvg = 0;
        
        nprodSalsPlnY.setValue((dataSet.getNameValue(0, "nprodSalsPlnY")    / 100000000).toFixed(2));
        nprodSalsPlnY1.setValue((dataSet.getNameValue(0, "nprodSalsPlnY1")  / 100000000).toFixed(2));
        nprodSalsPlnY2.setValue((dataSet.getNameValue(0, "nprodSalsPlnY2")  / 100000000).toFixed(2));
        nprodSalsPlnY3.setValue((dataSet.getNameValue(0, "nprodSalsPlnY3")  / 100000000).toFixed(2));
        nprodSalsPlnY4.setValue((dataSet.getNameValue(0, "nprodSalsPlnY4")  / 100000000).toFixed(2));
        
        y  = nprodSalsPlnY.getValue();
        y1 = nprodSalsPlnY1.getValue();
        y2 = nprodSalsPlnY2.getValue();
        y3 = nprodSalsPlnY3.getValue();
        y4 = nprodSalsPlnY4.getValue();
        
        if(y > 0) cnt++;
        if(y1 > 0) cnt++;
        if(y2 > 0) cnt++;
        if(y3 > 0) cnt++;
        if(y4 > 0) cnt++;
        
        if(cnt == 0) cnt++;

        yAvg = (y + y1 + y2 + y3 + y4) / cnt;

        nprodSalsPlnYAvg.setValue(yAvg);

        //투입인원(M/M)
        cnt  = 0;
        yAvg = 0;
        
        ptcCpsnY.setValue(dataSet.getNameValue(0, "ptcCpsnY"));  
        ptcCpsnY1.setValue(dataSet.getNameValue(0, "ptcCpsnY1"));
        ptcCpsnY2.setValue(dataSet.getNameValue(0, "ptcCpsnY2"));
        ptcCpsnY3.setValue(dataSet.getNameValue(0, "ptcCpsnY3"));
        ptcCpsnY4.setValue(dataSet.getNameValue(0, "ptcCpsnY4"));
        
        y  = ptcCpsnY.getValue();
        y1 = ptcCpsnY1.getValue();
        y2 = ptcCpsnY2.getValue();
        y3 = ptcCpsnY3.getValue();
        y4 = ptcCpsnY4.getValue();

        if(y > 0) cnt++;
        if(y1 > 0) cnt++;
        if(y2 > 0) cnt++;
        if(y3 > 0) cnt++;
        if(y4 > 0) cnt++;
        
        if(cnt == 0) cnt++;

        yAvg = (y + y1 + y2 + y3 + y4) / cnt;
        
        ptcCpsnYAvg.setValue(yAvg.toFixed(2));

        //영업이익율(%)
        cnt  = 0;
        yAvg = 0;
        
        bizPrftProY.setValue(dataSet.getNameValue(0, "bizPrftProY"));  
        bizPrftProY1.setValue(dataSet.getNameValue(0, "bizPrftProY1"));
        bizPrftProY2.setValue(dataSet.getNameValue(0, "bizPrftProY2"));
        bizPrftProY3.setValue(dataSet.getNameValue(0, "bizPrftProY3"));
        bizPrftProY4.setValue(dataSet.getNameValue(0, "bizPrftProY4"));
        
        y  = bizPrftProY.getValue();
        y1 = bizPrftProY1.getValue();
        y2 = bizPrftProY2.getValue();
        y3 = bizPrftProY3.getValue();
        y4 = bizPrftProY4.getValue();

        if(y > 0) cnt++;
        if(y1 > 0) cnt++;
        if(y2 > 0) cnt++;
        if(y3 > 0) cnt++;
        if(y4 > 0) cnt++;
        
        if(cnt == 0) cnt++;

        yAvg = (y + y1 + y2 + y3 + y4) / cnt;

        bizPrftProYAvg.setValue(yAvg); */
    }
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("smryFormDiv");
}); 
function initFrameSetHeight2(pId) {
	var pageHeight;
	
	if(stringNullChk(pId) != "") {
	    pageHeight = $("#"+pId).height();
	} else {
	    var body = document.body;
	    var html = document.documentElement;
	
	    pageHeight = Math.max( body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight );
	}
	
	var fId = window.frameElement.id;
	
	//$(fId, window.parent.document).attr('height', pageHeight+'px');
	window.parent.document.getElementById(fId).height = pageHeight+'px';
}
</script>
</head>
<body style="overflow: hidden">
<div id="smryFormDiv">
    <form name="smryForm" id="smryForm" method="post" style="padding: 20px 10px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        
        <table class="table table_txt_right">
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
                    <th align="right">Summary 개요</th>
                    <td class="tssLableCss space_tain" colspan="10"><input type="text" id="smrSmryTxt" name="smrSmryTxt" /></td>
                </tr>
                <tr>
                    <th align="right">Summary 목표</th>
                    <td class="tssLableCss space_tain" colspan="10"><input type="text" id="smrGoalTxt" name="smrGoalTxt" /></td>
                </tr>
                <tr>
                    <th align="right" rowspan="2"> 개요 상세</th>
                    <td colspan="10" class="space_tain">
                        <div id="tabViewS" />
                    </td>
                </tr>
                <tr>
                    <td colspan="10">
	                    <div id="smryTxt" />
                    </td>
                </tr>
                <tr>
                    <th align="right">시장규모</th>
                    <td class="tssLableCss space_tain" colspan="10"><span id="mrktSclTxt" /></td>
                </tr>
                <tr>
                    <th align="right">상품출시(계획)</th>
                    <td class="tssLableCss" colspan="10"><span id="ctyOtPlnM" /></td>
                </tr>
                <tr>
                    <th rowspan="2">영업이익율(%)</th>
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
                <tr>
                    <td class="tssLableCss"><span id="bizPrftProY" name="bizPrftProY"></td>
                    <td class="tssLableCss"><span id="bizPrftProY1" name="bizPrftProY1"></td>
                    <td class="tssLableCss"><span id="bizPrftProY2" name="bizPrftProY2"></td>
                    <td class="tssLableCss"><span id="bizPrftProY3" name="bizPrftProY3"></td>
                    <td class="tssLableCss"><span id="bizPrftProY4" name="bizPrftProY4"></td>
                </tr>
                 <tr id="trbizPrftPlnHead">
                    <th rowspan="2">영업이익(억원)</th>
                    <th class="alignC">출시년도</th>
                    <th class="alignC">출시년도+1</th>
                    <th class="alignC">출시년도+2</th>
                    <th class="alignC">출시년도+3</th>
                    <th class="alignC">출시년도+4</th>
                </tr>
                <tr id="trbizPrftPln">
                    <td><span id="bizPrftPlnY" name="bizPrftPlnY"></td>
                    <td><span id="bizPrftPlnY1" name="bizPrftPlnY1"></td>
                    <td><span id="bizPrftPlnY2" name="bizPrftPlnY2"></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr  id="trNprodSalHead" style="display:none;">
                    <th rowspan="2">신제품 매출계획(단위:억원)</th>
                    <th class="alignC">출시년도</th>
                    <th class="alignC">출시년도+1</th>
                    <th class="alignC">출시년도+2</th>
                    <th class="alignC">출시년도+3</th>
                    <th class="alignC">출시년도+4</th>
                </tr>
                <tr>
                    <td class="tssLableCss"><input type="text" id="nprodSalsPlnY" name="nprodSalsPlnY"></td>
                    <td class="tssLableCss"><input type="text" id="nprodSalsPlnY1" name="nprodSalsPlnY1"></td>
                    <td class="tssLableCss"><input type="text" id="nprodSalsPlnY2" name="nprodSalsPlnY2"></td>
                    <td class="tssLableCss"><input type="text" id="nprodSalsPlnY3" name="nprodSalsPlnY3"></td>
                    <td class="tssLableCss"><input type="text" id="nprodSalsPlnY4" name="nprodSalsPlnY4"></td>
                </tr>
                <tr>
                    <th rowspan="2">투입인원(M/M)</th>
                    <th class="alignC">Y</th>
                    <th class="alignC">Y+1</th>
                    <th class="alignC">Y+2</th>
                    <th class="alignC">Y+3</th>
                    <th class="alignC">Y+4</th>
                </tr>
                <tr>
                    <td class="tssLableCss"><span id="ptcCpsnY" name="ptcCpsnY"></td>
                    <td class="tssLableCss"><span id="ptcCpsnY1" name="ptcCpsnY1"></td>
                    <td class="tssLableCss"><span id="ptcCpsnY2" name="ptcCpsnY2"></td>
                    <td class="tssLableCss"><span id="ptcCpsnY3" name="ptcCpsnY3"></td>
                    <td class="tssLableCss"><span id="ptcCpsnY4" name="ptcCpsnY4"></td>
                </tr>
                <tr id="trPtcCpsnHead" style="display:none;">
	  				<th rowspan="2"></th>
	  				<th class="alignC"  colspan="2">과제시작년도</th>
	  				<th class="alignC"  colspan="2">과제시작년도+1</th>
	  				<th class="alignC"  colspan="2">과제시작년도+2</th>
	  				<th class="alignC"  colspan="2">과제시작년도+3</th>
	  				<th class="alignC"  colspan="2">과제시작년도+4</th>
	  			</tr>
	  			<tr>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">실적</th>
	  			</tr>
	  			<tr id="trPtcCpsn" style="display:none;">
	  				<th>투입인원(명)</th>
	  				<td><span id="ptcCpsnY"/></td>
	  				<td><span id="ptcCpsnCurY"/></td>
	  				<td><span id="ptcCpsnY1"/></td>
	  				<td><span id="ptcCpsnCurY1"/></td>
	  				<td><span id="ptcCpsnY2"/></td>
	  				<td><span id="ptcCpsnCurY2"/></td>
	  				<td><span id="ptcCpsnY3"/></td>
	  				<td><span id="ptcCpsnCurY3"/></td>
	  				<td><span id="ptcCpsnY4"/></td>
	  				<td><span id="ptcCpsnCurY4"/></td>
	  			</tr>
	  			<tr id="trExpArsl" style="display:none;">
	  				<th>투입비용(억원)</th>
	  				<td><span id="expArslY" /></td>
	  				<td><span id="expArslCurY"/></td>
	  				<td><span id="expArslY1"/></td>
	  				<td><span id="expArslCurY1"/></td>
	  				<td><span id="expArslY2"/></td>
	  				<td><span id="expArslCurY2"/></td>
	  				<td><span id="expArslY3"/></td>
	  				<td><span id="expArslCurY3"/></td>
	  				<td><span id="expArslY4"/></td>
	  				<td><span id="expArslCurY4"/></td>
	  			</tr>
                <tr>
                    <th align="right">지적재산팀 검토의견</th>
                    <td colspan="5" class="space_tain"><span id="pmisTxt" name="pmisTxt" /></td>
                </tr>
                <tr>
                    <th align="right">GRS심의파일<br/>(심의파일, 회의록 필수 첨부)</th>
                    <td class="tssLableCss" colspan="5" id="attchFileView">&nbsp;</td>
                </tr>
            </tbody>
        </table>
    </form>
	<!-- <div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnList" name="btnList">목록</button>
	    </div>
	</div> -->
</div>
</body>
</html>