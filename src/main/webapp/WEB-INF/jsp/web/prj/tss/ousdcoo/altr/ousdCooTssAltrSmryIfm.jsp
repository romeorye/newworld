<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssAltrSmryIfm.jsp
 * @desc    : 대외협력과제 - 변경 > 개요 탭 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.18  IRIS04		최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>

<script type="text/javascript">
    var lvTssCd  = window.parent.gvTssCd;
    var lvUserId = window.parent.gvUserId;
    var lvTssSt  = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "102" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var lvAttcFilId;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/ 
        //연구비(억원)
        rsstExp = new Rui.ui.form.LNumberBox({
            applyTo: 'rsstExp',
            width: 200
        });
        
        //계약유형
        cnttTypeCd = new Rui.ui.form.LCombo({
            applyTo: 'cnttTypeCd',
            name: 'cnttTypeCd',
            useEmptyText: true,
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=CNTT_TYPE_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        
        //독점권
        monoCd = new Rui.ui.form.LCombo({
            applyTo: 'monoCd',
            name: 'monoCd',
            useEmptyText: true,
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=COMM_YN_T"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
      
        //연구비 지급조건
        rsstExpFnshCnd = new Rui.ui.form.LTextArea({
            applyTo: 'rsstExpFnshCnd',
            height: 100,
            width: 600
        });
      
        //법무팀 검토결과
        rvwRsltTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rvwRsltTxt',
            height: 100,
            width: 600
        });

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
            
//            document.getElementById('nprodSalsPlnYAvg').style.border = 0;
//            document.getElementById('ptcCpsnYAvg').style.border = 0;
            
            document.getElementById('attchFileMngBtn').style.display = "none";
            btnSave.hide();
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
            	  { id: 'tssCd' }             /*과제코드*/
           		, { id: 'oucmPlnTxt' }        /*목표기술 성과 계획*/
           		, { id: 'rsstExp' }           /*연구비*/
           		, { id: 'cnttTypeCd' }        /*계약유형코드*/
           		, { id: 'monoCd' }            /*독점권코드*/
           		, { id: 'rsstExpFnshCnd' }    /*연구비 지급조건*/
           		, { id: 'rvwRsltTxt' }        /*법무팀 검토결과*/
           		, { id: 'surrNcssTxt' }       /*연구과제 배경 및 필요성*/
           		, { id: 'sbcSmryTxt' }        /*주요 연구개발 내용 요약*/
           		, { id: 'sttsTxt' }           /*지재권 출원현황*/
           		, { id: 'ctqTxt' }            /*핵심 CTQ/ 품질 수준*/
           		, { id: 'effSpheTxt' }        /*파급효과 및 응용분야*/
           		, { id: 'fnoPlnTxt' }         /*결론 및 향후 계획*/
           		, { id: 'altrRson' }          /*변경사유*/
           		, { id: 'addRson' }           /*추가사유*/
           		, { id: 'dcacRson' }          /*중단사유*/
           		, { id: 'attcFilId' }         /*첨부파일ID*/
           		, { id: 'rsstExpConvertMil', defaultValue: 0 } /*연구비(억원)*/
           		, { id: 'userId' }
            ]
        });
        dataSet.on('load', function(e) {
            
        	Wec0.SetBodyValue( dataSet.getNameValue(0, "surrNcssTxt") );
            Wec1.SetBodyValue( dataSet.getNameValue(0, "sbcSmryTxt") );
            Wec2.SetBodyValue( dataSet.getNameValue(0, "oucmPlnTxt") );

            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();
            
            tabViewS.selectTab(0);
        });
        
        //Form 바인드
        var bind = new Rui.data.LBind({
            groupId: 'smryFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',              ctrlId: 'tssCd',           value: 'value' }
//                , { id: 'oucmPlnTxt',         ctrlId: 'oucmPlnTxt',      value: 'value' }
                , { id: 'rsstExpConvertMil',  ctrlId: 'rsstExp',         value: 'value' }
                , { id: 'cnttTypeCd',         ctrlId: 'cnttTypeCd',      value: 'value' }
                , { id: 'monoCd',             ctrlId: 'monoCd',          value: 'value' }
                , { id: 'rsstExpFnshCnd',     ctrlId: 'rsstExpFnshCnd',  value: 'value' }
                , { id: 'rvwRsltTxt',         ctrlId: 'rvwRsltTxt',      value: 'value' }
//                , { id: 'surrNcssTxt',        ctrlId: 'surrNcssTxt',     value: 'value' }
//                , { id: 'sbcSmryTxt',         ctrlId: 'sbcSmryTxt',      value: 'value' }
                , { id: 'sttsTxt',            ctrlId: 'sttsTxt',         value: 'value' }
                , { id: 'ctqTxt',             ctrlId: 'ctqTxt',          value: 'value' }
                , { id: 'effSpheTxt',         ctrlId: 'effSpheTxt',      value: 'value' }
                , { id: 'fnoPlnTxt',          ctrlId: 'fnoPlnTxt',       value: 'value' }
                , { id: 'altrRson',           ctrlId: 'altrRson',        value: 'value' }
                , { id: 'addRson',            ctrlId: 'addRson',         value: 'value' }
                , { id: 'dcacRson',           ctrlId: 'dcacRson',        value: 'value' }
                , { id: 'attcFilId',          ctrlId: 'attcFilId',       value: 'value' }
                , { id: 'userId',             ctrlId: 'userId',          value: 'value' }
            ]
        });
        
     	// 개요 에디터 탭
        tabViewS = new Rui.ui.tab.LTabView({
            tabs: [
                {
                	label: '연구과제배경 및 필요성',
                    content: ''
                }, {
                    label: '주요 연구개발 내용 요약',
                    content: ''
                }, {
                    label: '목표기술 성과 계획',
                    content: ''
                }
            ]
        });
        
        tabViewS.on('activeTabChange', function(e){
        	var index = e.activeIndex;
        	
        	if( index == 0 ){
	    		document.getElementById("divWec0").style.display = "block";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "none";	
	    	
	    	}else if( index == 1 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "block";	
	    		document.getElementById("divWec2").style.display = "none";		
	    	
	    	}else if( index == 2 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "block";	
	    	}
        	
		});
        
        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            alert(data.records[0].rtVal);
            
            if(data.records[0].rtCd == "SUCCESS") {
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet1.getReadData(e);
            alert(data.records[0].rtVal);
        });

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/

        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
        	var frm = document.smryForm;
        	
        	var rsstExpCash = numberNullChk(rsstExp.getValue()) * 100000000;
        	dataSet.setNameValue(0, "rsstExp" , rsstExpCash );
        	
        	// 에디터 데이터 처리    	
        	frm.surrNcssTxt.value =  Wec0.GetBodyValue();
            frm.sbcSmryTxt.value  =  Wec1.GetBodyValue();
            frm.oucmPlnTxt.value  =  Wec2.GetBodyValue();
            
            dataSet.setNameValue(0, "surrNcssTxt", Wec0.GetBodyValue() );
            dataSet.setNameValue(0, "sbcSmryTxt" , Wec1.GetBodyValue() );
            dataSet.setNameValue(0, "oucmPlnTxt" , Wec2.GetBodyValue() );
            
            if(  dataSet.getNameValue(0, "surrNcssTxt") == "<p><br></p>" || dataSet.getNameValue(0, "surrNcssTxt") == "") {
                alert("연구과제배경 및 필요성 은 필수입력입니다.");
                return false;
            }
            if(  dataSet.getNameValue(0, "sbcSmryTxt") == "<p><br></p>" || dataSet.getNameValue(0, "sbcSmryTxt") == "") {
                alert("주요 연구개발 내용 요약 은 필수입력입니다.");
                return false;
            }
            if(  dataSet.getNameValue(0, "oucmPlnTxt") == "<p><br></p>" || dataSet.getNameValue(0, "oucmPlnTxt") == "") {
                alert("목표기술 성과 계획 은 필수입력입니다.");
                return false;
            }
            
            window.parent.fnSave2();
        });
/* 
        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {    
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
        });
         */
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
                url: "<c:url value='/system/attach/getAttachFileList.do'/>" ,
                params :{
                    attcFilId : lvAttcFilId
                },
                sync : true
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
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";
            
            return lvAttcFilId;
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
        
        tabViewS.render('tabViewS');

        //최초 데이터 셋팅
        var resultCnt = Number('<c:out value="${resultCnt}"/>');
        if(resultCnt > 0) { 
            dataSet.loadData( ${result} ); 
        } else {
            dataSet.newRecord();
            tabViewS.selectTab(0);
        }
        
        //버튼 비활성화 셋팅
        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
        	document.getElementById('attchFileMngBtn').style.display = "none";
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
        	document.getElementById('attchFileMngBtn').style.display = "none";
		}
        
    });
    
    // 내부 스크롤 제거
    $(window).load(function() {
    	setTimeout(function () {
        	initFrameSetHeight();
    	}, 1500);
    });

</script>
<script type="text/javascript">

</script>

</head>
<body>
<div id="smryFormDiv">

    <form name="smryForm" id="smryForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value="">  <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value="">  <!-- 사용자ID -->
        <input type="hidden" id="surrNcssTxt" name="surrNcssTxt"> <!-- 연구과제배경 및 필요성 -->
        <input type="hidden" id="sbcSmryTxt" name="sbcSmryTxt">   <!-- 주요 연구개발 내용 요약 -->
        <input type="hidden" id="oucmPlnTxt" name="oucmPlnTxt">   <!-- 목표기술 성과 계획 -->
        
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 15%;" />
                <col style="width: 35%;" />
                <col style="width: 15%;" />
                <col style="width: 25%;" />
                <col style="width: 10%;" />
            </colgroup>
            <tbody>  
                <tr>
                	<th align="right" rowspan="2">개요 상세</th>
                    <td colspan="4">
                    	<div id="tabViewS"></div>
					</td>
                </tr>
                <tr>
                    <td colspan="4">
						<div id="divWec0">
							<script>
                                Wec0 = new NamoSE('divWec0');
                                Wec0.params.Width = "100%";
                                Wec0.params.UserLang = "auto";
                                Wec0.params.Font = fontParam;
                                
                                uploadPath = "<%=uploadPath%>";
                                Wec0.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec0.params.FullScreen = false;
                                Wec0.EditorStart();

                            </script>
						</div>
                		<div id="divWec1" style="display:none">
                			<script>
                                Wec1 = new NamoSE('divWec1');
                                Wec1.params.Width = "100%";
                                Wec1.params.UserLang = "auto";
                                Wec1.params.Font = fontParam;
                                uploadPath = "<%=uploadPath%>";
                                Wec1.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec1.params.FullScreen = false;
                                Wec1.EditorStart();

                            </script>
                        </div>
                		<div id="divWec2" style="display:none">
                			<script>
                                Wec2 = new NamoSE('divWec2');
                                Wec2.params.Width = "100%";
                                Wec2.params.UserLang = "auto";
                                Wec2.params.Font = fontParam;
                                uploadPath = "<%=uploadPath%>";
                                Wec2.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec2.params.FullScreen = false;
                                Wec2.EditorStart();
                            </script>
                            <script type="text/javascript" language="javascript">
	                            function OnInitCompleted(e){
	                                e.editorTarget.SetBodyValue(document.getElementById("divWec0").value);
	                                e.editorTarget.SetBodyValue(document.getElementById("divWec1").value);
	                                e.editorTarget.SetBodyValue(document.getElementById("divWec2").value);
	                            }
	                        </script>       
                		</div>
					</td>
                </tr>
                <tr>
                    <th align="right">연구비 (억원)</th>
                    <td><input type="text" id="rsstExp" name="rsstExp"></td>
                    <th align="right">계약유형</th>
                    <td colspan="2"><div id="cnttTypeCd" name="cnttTypeCd"></div></td>
                </tr>
                <tr>
                    <th align="right">독점권</th>
                    <td colspan="4"><div id="monoCd" name="monoCd"></div></td>
                </tr>
                <tr>
                    <th align="right">연구비 지급조건</th>
                    <td colspan="4"><textarea id="rsstExpFnshCnd" name="rsstExpFnshCnd"></textarea></td>
                </tr>
                <tr>
                     <th align="right">법무팀 검토결과</th>
                    <td colspan="4"><textarea id="rvwRsltTxt" name="rvwRsltTxt"></textarea></td>
                </tr>
                <tr>
                    <th align="right">첨부파일</th>
                    <td colspan="3" id="attchFileView" style="width:160px;">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
<div class="titArea btn_btm">
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>