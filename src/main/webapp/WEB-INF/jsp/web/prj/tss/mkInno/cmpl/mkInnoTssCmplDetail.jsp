<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : mkInnoTssPlnDetail.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2019.09.26  IRIS005      신규생성
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
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">

var callback;
var lvAttcFilId;
var cmplAttcFilId;
var popupRow;;
var tssCd = '${inputData.tssCd}';
var userId = '${inputData._userId}';

	Rui.onReady(function() {
		
		var dm = new Rui.data.LDataSetManager();

		dm.on('load', function(e) {
		});
        
		dm.on('success', function(e) {
			var data = mstDataSet.getReadData(e);
			
			if(Rui.isEmpty(data.records[0].resultMsg) == false) {
                alert(data.records[0].resultMsg);
                
            }
        });
		
		var tabView = new Rui.ui.tab.LTabView({
            tabs: [
                { 
               	  
                  active : true,
               	  label: '개요',
                  id : 'smryInfoDiv'
                },
                { 
                	label: '참여연구원',
                  id : 'mbrInfoDiv'
                }
            ]
        });
       
        tabView.on('canActiveTabChange', function(e){

            switch(e.activeIndex){
            case 0:

                break;

            case 1:
                break;

            default:
                break;
            }
        });

        tabView.on('activeTabChange', function(e){
            switch(e.activeIndex){
            case 0:
                break;

            case 1:
                if(e.isFirst){
                }

                break;

            default:
                break;
            }

        });

        tabView.render('tabView');
		
//=================mbr   div =================================================//
		//참여역할
        rtcRole = new Rui.ui.form.LRadioGroup({
            gridFixed: true,
            autoMapping: true,
            valueField: 'value',
            displayField: 'label',
            items : [
                <c:forEach var="lvTssSt" items="${codeRtcRole}">
                { label: '${lvTssSt.COM_DTL_NM}', name: '${lvTssSt.COM_DTL_NM}', value: '${lvTssSt.COM_DTL_CD}' },
                </c:forEach>
            ]
        });
		
//============================mstDataSet ===============================================================//
		mstDataSet = new Rui.data.LJsonDataSet({
			 id: 'mstDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
             	  { id: 'tssCd' }
             	, { id: 'wbsCd' }
             	, { id: 'prjNm' }
             	, { id: 'deptName' }
             	, { id: 'deptCode' }
             	, { id: 'bizDptCd' }
             	, { id: 'tssNm' }
             	, { id: 'saUserName' }
             	, { id: 'tssStrtDd' }
             	, { id: 'tssFnhDd' }
             	, { id: 'prodGCd' }
             	, { id: 'prodgNm' }
             	, { id: 'saSabunNew' }
             	, { id: 'pgsStepCd' }
             	, { id: 'tssSt' }
             	, { id: 'prjCd'}
             ]
		});
        
		mstDataSet.on('load', function(e) {
			
			if( mstDataSet.getNameValue(0, 'pgsStepCd') == "CM" && ( mstDataSet.getNameValue(0, 'tssSt') =="104" || mstDataSet.getNameValue(0, 'tssSt') == "103"   ) ){
				$("#btnCsusRq").hide();
				$("#butRecordNew").hide();
				$("#btnMbrSave").hide();
				$("#butRecordDel").hide();
			}
		});
//============================smry DataSet ===============================================================//
		smryDataSet = new Rui.data.LJsonDataSet({
			id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	 { id: 'tssCd'}
            	,{ id: 'dvlpGoalTxt'}
            	,{ id: 'sbcTclgTxt'}
            	,{ id: 'cnsu'}
            	,{ id: 'ordn'}
            	,{ id: 'whsn'}
            	,{ id: 'mssp'}
            	,{ id: 'quan'}
            	,{ id: 'qtTxt'}
            	,{ id: 'tssStatF'}
            	,{ id: 'tssStatS'}
            	,{ id: 'tssDfcr'}
            	,{ id: 'ancpSclTxt'}
            	,{ id: 'istlPlTxt'}
            	,{ id: 'rcmCofTxt'}
            	,{ id: 'tssTxt'}
            	,{ id: 'empsReqTxt'}
            	,{ id: 'cooReqTxt'}
            	,{ id: 'attcFilId'}
            	,{ id: 'cmplAttcFilId'}
            ]
		});
		
		smryDataSet.on('load', function(e) {
			smryDataSet.setNameValue(0, 'tssCd', tssCd);
			
			if(!Rui.isEmpty(smryDataSet.getNameValue(0, 'attcFilId')) ){
				lvAttcFilId = smryDataSet.getNameValue(0, 'attcFilId');
				getAttachFileList();
			}
			if(!Rui.isEmpty(smryDataSet.getNameValue(0, 'cmplAttcFilId')) ){
				cmplAttcFilId = smryDataSet.getNameValue(0, 'cmplAttcFilId');
				getAttachFileList1();
			}
		});
		
//============================budgDataSet ===============================================================//
		mbrDataSet = new Rui.data.LJsonDataSet({
			id: 'mbrDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	    { id: 'ptcRsstMbrSn' }                                      //참여연구원일련번호 
                  , { id: 'saSabunNew' }                                        //연구원사번         
                  , { id: 'saUserName' }                                        //연구원이름         
                  , { id: 'deptCode' }                                          //소속               
                  , { id: 'deptName' }                                          //소속               
                  , { id: 'ptcStrtDt', type: 'date', defaultValue: new Date() } //참여시작일         
                  , { id: 'ptcFnhDt', type: 'date' }  //참여종료일         
                  , { id: 'oldStrtDt' } //참여시작일         
                  , { id: 'oldFnhDt' }  //참여종료일         
                  , { id: 'ptcRole', defaultValue: '02' }                       //참여역할           
                  , { id: 'ptcRoleDtl' }                                        //참여역할상세       
                  , { id: 'userId' }                                            //사용자ID
                  , { id: 'tssCd' }                                            //사용자ID
            ]
		});
		mbrDataSet.on('load', function(e) {
			
		});
		
		//그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'saUserName', label: '연구원', sortable: false, align:'center', width: 150, renderer: Rui.util.LRenderer.popupRenderer() }
                , { field: 'deptName', 	label: '소속', sortable: false, align:'left', width: 250 }
                , { field: 'ptcStrtDt', label: '참여시작일', sortable: false, align:'center', width: 120, editor: new Rui.ui.form.LDateBox({id:'ptcStrtDt'}) 
	                , renderer: function(value, p, record) {
	                    if(record.data.ptcStrtDt != null) {
	                        var valDate = Rui.util.LFormat.stringToDate(record.data.ptcStrtDt, {format: '%x'});
	                        return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
	                    }
	                    if(value!="") {
	                        return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
	                    }
	              } }
	             , { field: 'ptcFnhDt', label: '참여종료일', sortable: false, align:'center', width: 120, editor: new Rui.ui.form.LDateBox({id:'ptcFnhDt'}) 
	                , renderer: function(value, p, record) {
	                    if(record.data.ptcStrtDt != null) {
	                        var valDate = Rui.util.LFormat.stringToDate(record.data.ptcFnhDt, {format: '%x'});
	                        return Rui.util.LFormat.dateToString(valDate, {format: '%x (%a)'});
	                    }
	                    if(value!="") {
	                        return Rui.util.LFormat.dateToString(value, {format: '%x (%a)'});
	                    }
	              } } 
                 , { field: 'ptcRole', label: '참여역할', sortable: false, align:'center', width: 150, editor: rtcRole 
                     , renderer: function(v) {
                         if(v == null) {
                             return rtcRole.getCheckedItem().label;
                         } else {
                             if(v == '01') return "과제리더";
                             else if(v == '02') return "연구원";
                         } 
                      }    
                 }
            ]
        });
		
		var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: mbrDataSet,
            width: 600,
            height: 308,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            usePaste: false,
            useRightActionMenu: false
        });
		
		grid.on('popup', function(e) {
	    	popupRow = e.row;
	        openUserSearchDialog(setGridUserInfo, 1, '');
        });
		
        grid.render('defaultGrid');
		
		/* 조회*/
        dm.loadDataSet({
            dataSets: [mstDataSet, smryDataSet, mbrDataSet],
            url: '<c:url value="/prj/tss/mkInno/retrieveMkInnoTssDetail.do"/>',
            params: {
            	tssCd: '${inputData.tssCd}'
            }
        });
        
		
/*******************버튼이벤트 ***************************************************************************************/
			/* mst, smry 저장 */
            fnMstSave = function() {
    			if(Rui.isEmpty( smryDataSet.getNameValue(0, "cmplAttcFilId")  )){
					alert("완료보고서 파일을 첨부하사여야 합니다.");
					return;
    			}        	

    			if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[smryDataSet],
                        url:'<c:url value="/prj/tss/mkInno/updateCmplAttcFilId.do"/>',
                    });
            	}
            };
            
          	//mbr 추가
            var butRecordNew = new Rui.ui.LButton('butRecordNew');
            butRecordNew.on('click', function() {
                var row = mbrDataSet.newRecord();
                var record = mbrDataSet.getAt(row);
                
                record.set("tssCd",  tssCd);
            });
            
            //mbr 삭제
            var butRecordDel = new Rui.ui.LButton('butRecordDel');
            butRecordDel.on('click', function() {                
                Rui.confirm({
                    text: Rui.getMessageManager().get('$.base.msg107'),
                    handlerYes: function() {
                        //실제 DB삭제건이 있는지 확인
                        var dbCallYN = false;
                        var chkRows = mbrDataSet.getMarkedRange().items;
                        for(var i = 0; i < chkRows.length; i++) {
                            if(stringNullChk(chkRows[i].data.ptcRsstMbrSn) != "") {
                                dbCallYN = true;
                                break;
                            }
                        }
                        
                        if(mbrDataSet.getMarkedCount() > 0) {
                        	mbrDataSet.removeMarkedRows();
                        } else {
                            var row = mbrDataSet.getRow();
                            if(row < 0) return;
                            
                            mbrDataSet.removeAt(row);
                        }
                        
                        if(dbCallYN) {
    	                    //삭제된 레코드 외 상태 정상처리
    	                    for(var i = 0; i < mbrDataSet.getCount(); i++) {
    	                    	if(mbrDataSet.getState(i) != 3) mbrDataSet.setState(i, Rui.data.LRecord.STATE_NORMAL);
    	                    }
                        
    	                    dm.updateDataSet({
    	                        url:'<c:url value="/prj/tss/mkInno/deleteMkInnoTssPlnPtcRsstMbr.do"/>',
    	                        dataSets:[mbrDataSet]
    	                    });
                        }
                    },
                    handlerNo: Rui.emptyFn
                });
            });
                    
            /* mbr 저장 */
           fnMbrSave = function(){
                //과제리더 건수 확인
                var rdSnt = 0;
                var rdDt = 0;
                
                for(var i = 0; i < mbrDataSet.getCount(); i++) {
                	mbrDataSet.setNameValue(0, 'userId', userId);
                	mbrDataSet.setNameValue(0, 'tssCd', tssCd);
                	
                	if(mbrDataSet.getNameValue(i, "ptcRole") == "01") rdSnt++;
                	if(!Rui.isEmpty(mbrDataSet.getNameValue(i, "ptcFnhDt"))   )  rdDt++;
                	
                }
                if(rdSnt != 1) {
                    Rui.alert("과제리더는 1명으로 지정해야 합니다.");
                    return;
                }
                if(mbrDataSet.getCount() != rdDt) {
                    Rui.alert("참여 종료일은 필수입니다.");
                    return;
                }
                
                dm.updateDataSet({
                    url:'<c:url value="/prj/tss/mkInno/saveMkInnoMbr.do"/>',
                    dataSets:[mbrDataSet]
                });
            };
            
          	//품의서요청
            fncCsusRq = function(){
            	//품의서 요청 조건 체크
            	
            	if( Rui.isEmpty( smryDataSet.getNameValue(0,'cmplAttcFilId')) ){
            		Rui.alert("완료보고서를 첨부하셔야 합니다.");
            		return;
            	}
            	
            	if(confirm("품의서요청을 하시겠습니까?")) {
            		 nwinsActSubmit(document.aform, "<c:url value='/prj/tss/mkInno/retrieveMkInnoTssPlnCsusRq.do'/>"+"?tssCd="+tssCd+"&userId="+userId+"&appCode=APP00332");
            	}            	
            }


/*=================== 첨부파일 저장======================================== */          
            
        //첨부파일 callback
    	/* [기능] 첨부파일 조회*/
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
        
        /* [기능] 첨부파일 등록 팝업*/
        getAttachFileId = function() {
            if(Rui.isEmpty(cmplAttcFilId)) cmplAttcFilId = "";

            return cmplAttcFilId;
        };

        setAttachFileInfo = function(attachFileList) {
            $('#attchFileView').html('');
            if(attachFileList.length > 0) {
                for(var i = 0; i < attachFileList.length; i++) {
                    $('#attchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

               	lvAttcFilId =  attachFileList[0].data.attcFilId;
               	smryDataSet.setNameValue(0, "attcFilId", lvAttcFilId);
            }
        };

        
      //첨부파일 callback
    	/* [기능] 첨부파일 조회*/
        var attachFileDataSet1 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet1',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });

        attachFileDataSet1.on('load', function(e) {
            getAttachFileInfoList1();
        });
        
        getAttachFileList1 = function() {
            attachFileDataSet1.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                	attcFilId : cmplAttcFilId
                }
            });
        };
        
        getAttachFileInfoList1 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet1.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet1.getAt(i).clone());
            }

            setAttachFileInfo1(attachFileInfoList);
        };
        
        setAttachFileInfo1 = function(attachFileList) {
            $('#attchFileView1').html('');
            if(attachFileList.length > 0) {
                for(var i = 0; i < attachFileList.length; i++) {
                    $('#attchFileView1').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

                cmplAttcFilId =  attachFileList[0].data.attcFilId;
               	smryDataSet.setNameValue(0, "cmplAttcFilId", cmplAttcFilId);
            }
        };

        
        /*첨부파일 다운로드*/
        downloadAttachFile = function(attcFilId, seq) {
        	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
        	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
        	aform.submit();
        };

  
 /*============================================함수 모음==========================================================*/       
      	setGridUserInfo= function(userInfo) {
      		mbrDataSet.setNameValue(popupRow, "saSabunNew", userInfo.saSabun);
      		mbrDataSet.setNameValue(popupRow, "saUserName", userInfo.saName);
      		mbrDataSet.setNameValue(popupRow, "deptCode", userInfo.deptCd);
      		mbrDataSet.setNameValue(popupRow, "deptName", userInfo.deptName);
		}
        

/********************bind ***************************************************************************************/		
      	//폼에 출력 (mstDataSet)
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: mstDataSet,
            bind: true,
            bindInfo: [
                  { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'html' }
                , { id: 'prjCd',      ctrlId: 'prjCd',      value: 'html' }
                , { id: 'prjNm',      ctrlId: 'prjNm',      value: 'html' }
                , { id: 'deptName',   ctrlId: 'deptName',   value: 'html' }
                , { id: 'bizDptCd',   ctrlId: 'bizDptCd',   value: 'html' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'html' }
                , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'html' }
                , { id: 'saSabunNew', ctrlId: 'saSabunNew', value: 'html' }
                , { id: 'saUserName', ctrlId: 'saUserName', value: 'html' }
                , { id: 'tssAttrCd',  ctrlId: 'tssAttrCd',  value: 'html' }
                , { id: 'tssStrtDd',  ctrlId: 'tssStrtDd',  value: 'html' }
                , { id: 'tssFnhDd',   ctrlId: 'tssFnhDd',   value: 'html' }
                , { id: 'prodgNm',    ctrlId: 'prodgNm',    value: 'html' }
                , { id: 'pgsStepNm',  ctrlId: 'pgsStepNm',    value: 'html' }				//과제 단계명
                , { id: 'grsStepNm',  ctrlId: 'grsStepNm',    value: 'html' }				// GRS 단계명
            ]
        });
        
      	//폼에 출력 (smryDataSet)
        var smryBind = new Rui.data.LBind({
            groupId: 'smryInfoDiv',
            dataSet: smryDataSet,
            bind: true,
            bindInfo: [
                  { id: 'dvlpGoalTxt',  ctrlId: 'dvlpGoalTxt',	value: 'html' }
                , { id: 'sbcTclgTxt',   ctrlId: 'sbcTclgTxt',   value: 'html' }
                , { id: 'cnsu',      	ctrlId: 'cnsu',      	value: 'html' }
                , { id: 'ordn',   		ctrlId: 'ordn',   		value: 'html' }
                , { id: 'whsn',   		ctrlId: 'whsn',   		value: 'html' }
                , { id: 'mssp',      	ctrlId: 'mssp',      	value: 'html' }
                , { id: 'quan',      	ctrlId: 'quan',      	value: 'html' }
                , { id: 'qtTxt',      	ctrlId: 'qtTxt',      	value: 'html' }
                , { id: 'tssStatF', 	ctrlId: 'tssStatF', 	value: 'html' }
                , { id: 'tssStatS', 	ctrlId: 'tssStatS', 	value: 'html' }
                , { id: 'tssDfcr',  	ctrlId: 'tssDfcr',  	value: 'html' }
                , { id: 'ancpSclTxt',  	ctrlId: 'ancpSclTxt',  	value: 'html' }
                , { id: 'istlPlTxt',   	ctrlId: 'istlPlTxt',   	value: 'html' }
                , { id: 'rcmCofTxt',    ctrlId: 'rcmCofTxt',    value: 'html' }
                , { id: 'tssTxt',  		ctrlId: 'tssTxt',    	value: 'html' }				
                , { id: 'empsReqTxt',  	ctrlId: 'empsReqTxt',   value: 'html' }			
                , { id: 'cooReqTxt',  	ctrlId: 'cooReqTxt',    value: 'html' }			
            ]
        });
        
        
        
        
	});
</script>

</head>
<body>	
<div class="contents">
	<div class="titleArea">
    	<a class="leftCon" href="#">
	    	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	        <span class="hidden">Toggle 버튼</span>
        </a>
        <h2>제조혁신과제 &gt;&gt; 완료</h2>
	</div>
	<div class="sub-content">
	<form   id="aform" name="aform">		
	<input type="hidden" id="tssCd" name ="tssCd" value= '${inputData.tssCd}'   />
		<div class="titArea mt0">
			<div class="LblockButton">
	           <button type="button" id="btnCsusRq" name="btnCsusRq" onClick="fncCsusRq();">품의서요청</button>
	           <button type="button" id="btnList" name="btnList">목록</button>
	        </div>
		</div>
	<div id="mstFormDiv">
		 <fieldset>
		 	<table class="table table_txt_right">
            	<colgroup>
                	<col style="width: 12%;" />
                 	<col style="width: 38%;" />
                 	<col style="width: 12%;" />
                 	<col style="width: 38%;" />
             	</colgroup>
             	<tbody>
		 			<tr>
                    	<th align="right">프로젝트명</th>
                        <td>
                            <span id="prjNm"></span>
                        </td>
                        <th align="right">조직</th>
                        <td>
                            <span id="deptName"></span>
                        </td>
                    </tr>
                    <tr>
                    	<th align="right">WBSCode / 과제명</th>
                        <td colspan="3">
                        	<span id='wbsCd'></span> / <em class="gab"> <span id='tssNm'></span> 
                        </td>
                    </tr>
                    <tr>
						<th align="right">과제리더</th>
                        <td>
                        	<span id="saUserName"></span>
                        </td>
                        <th align="right">사업부문(Funding기준)</th>
                        <td>
                        	<span id="bizDptNm"></span>
                        </td>
                    </tr>
                    <tr>
                    	<th align="right">제품군</th>
                        <td>
                        	<span id="prodgNm"></span>
                        </td>
                        <th align="right">과제기간</th>
                        <td>
                        	<span id="tssStrtDd"></span><em class="gab"> ~ </em><span id="tssFnhDd"></span>
                        </td>
                    </tr>
                    <tr>
                    	<th align="right">진행단계</th>
                        <td><span id="pgsStepNm"></span></td>
                    	<th align="right">GRS</th>
                        <td><span id="grsStepNm"></span></td>
                    </tr>
		 		</tbody>
		 	</table>	
		 </fieldset>
         </div>
		</form>         
         <br/> 
         <div id="tabView"></div>
         <div id="smryInfoDiv">
         	<table class="table table_txt_right">
				<colgroup>
	                <col style="width: 10%;" />
	                <col style="width: 10%;" />
	                <col style="width: 75%;" />
	                <col style="width: 5%" />
	            </colgroup>
         		<tbody>
         			<tr>
	         			<th rowspan="2">사양</th>
	         			<th>개발목표</th>
	         			<td colspan="2">
	         				<span id="dvlpGoalTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th>주요기술</th>
	         			<td colspan="2">
	         				<span id="sbcTclgTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th rowspan="4">목표일정<br/>(장비성과제시)</th>
	         			<th>품의</th>
	         			<td colspan="2">
	         				<span id="cnsu"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th>발주</th>
	         			<td colspan="2">
	         				<span id="ordn"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th>입고</th>
	         			<td colspan="2">
	         				<span id="whsn"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th>양산</th>
	         			<td colspan="2">
	         				<span id="mssp"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th rowspan="2">기대효과</th>
	         			<th>정량적</th>
	         			<td colspan="2">
	         				<span id="quan"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th>정성적</th>
	         			<td colspan="2">
	         				<span id="qtTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">과제 성격(Ⅰ)</th>
	         			<td colspan="2">
	         				<span id="tssStatF"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">과제 성격(Ⅱ)</th>
	         			<td colspan="2">
	         				<span id="tssStatS"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">과제난이도</th>
	         			<td colspan="2">
	         				<span id="tssDfcr"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">예상투자규모</th>
	         			<td colspan="2">
	         				<span id="ancpSclTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">설치장소</th>
	         			<td colspan="2">
	         				<span id="istlPlTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">추천업체</th>
	         			<td colspan="2">
	         				<span id="rcmCofTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">과제 개요 및 Output Image</th>
	         			<td colspan="2">
	         				<span id="tssTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">중점요청 사항</th>
	         			<td colspan="2">
	         				<span id="empsReqTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">협력요청 사항</th>
	         			<td colspan="2">
	         				<span id="cooReqTxt"></span>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">첨부파일</th>
	         			<td colspan="2" id="attchFileView">&nbsp;</td>
	         		</tr>
	         		<tr>
	         			<th colspan="2">완료보고서</th>
	         			<td id="attchFileView1">&nbsp;</td>
                    	<td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo1, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
	         		</tr>
	         		
         		</tbody>
         	</table>
         	<div class="titArea btn_btm">
	        	<div class="LblockButton">
		            <button type="button" id="btnSave" name="btnSave" onclick="fnMstSave()">저장</button>
	        	</div>
	        </div>	
   
         </div>
         
         <div id="mbrInfoDiv">
        	 <br/>
        	 <div class="titArea">
			    <div class="LblockButton">
			        <button type="button" id="butRecordNew">추가</button>
			        <button type="button" id="btnMbrSave" onclick="fnMbrSave()">저장</button>
			        <button type="button" id="butRecordDel">삭제</button>
			    </div>
			</div>
			<div id="defaultGrid"></div>
         </div>
        </div>
</div>
</body>
</html>
