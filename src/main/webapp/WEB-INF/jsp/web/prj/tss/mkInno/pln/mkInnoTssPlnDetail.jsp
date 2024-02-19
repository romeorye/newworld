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
var popupRow;;
var tssCd = '${inputData.tssCd}';
var userId = '${inputData._userId}';

	Rui.onReady(function() {
		
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
                , { id: 'cmplTssCd' }  //완료과제코드
            ]
        });

        resultDataSet.on('load', function(e) {
        });
        
		var dm = new Rui.data.LDataSetManager();

		dm.on('load', function(e) {
		});
        
		dm.on('success', function(e) {
			var data = resultDataSet.getReadData(e);
			
			alert( data.records[0].rtnMsg);
			
			if(data.records[0].rtnSt == "S") {
				//mbrDataSet.loadData(mbrDataSet);
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
                	label: '과제멤버',
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
		
//=================mst   div =================================================//
		//프로젝트명
        prjNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'prjNm',
            width: 300,
            editable: false
        });
        prjNm.on('popup', function(e){
            openPrjSearchDialog(setPrjInfo,'');
        });
        
      	//조직코드
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            width: 300
        });
		
        //사업부문(Funding기준)
        bizDptCd = new Rui.ui.form.LCombo({
            applyTo: 'bizDptCd',
            name: 'bizDptCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MK_BIZ_DPT_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        bizDptCd.getDataSet().on('load', function(e) {
            console.log('bizDptCd :: load');
        });

        //WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            width: 100
        });
        
      	//과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            width: 500
        });
      	
      	//과제리더
        saUserName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saUserName',
            width: 150,
            editable: false,
            enterToPopup: true
        });
      	
        saUserName.on('popup', function(e){
            openUserSearchDialog(setLeaderInfo, 1, '');
        });
        
		setLeaderInfo = function(userInfo){
        	dataSet.setNameValue(0, "saSabunNew", userInfo.saSabun);
            dataSet.setNameValue(0, "saUserName", userInfo.saName);
        }
     	// 공통 유저조회 Dialog
        _userSearchDialog.on('cancel', function(e) {
        	try{
        		tabContent0.$('object').css('visibility', 'visible');
        	}catch(e){}
        });
        _userSearchDialog.on('submit', function(e) {
        	try{
        		tabContent0.$('object').css('visibility', 'visible');
        	}catch(e){}
        });
        _userSearchDialog.on('show', function(e) {
        	try{
        		tabContent0.$('object').css('visibility', 'hidden');
        	}catch(e){}
        });
		
      	//과제기간 시작일
        tssStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssStrtDd',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });

        // 과제기간 종료일
        tssFnhDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssFnhDd',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
		
      	//제품군
        prodGCd = new Rui.ui.form.LCombo({
            applyTo: 'prodGCd',
            name: 'prodGCd',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PROD_G"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
      
//=================smry   div =================================================//
		//개발목표
        dvlpGoalTxt = new Rui.ui.form.LTextArea({
            applyTo: 'dvlpGoalTxt',
            height: 100,
            width: 1100
        });
		//개발목표
        sbcTclgTxt = new Rui.ui.form.LTextArea({
            applyTo: 'sbcTclgTxt',
            height: 100,
            width: 1100
        });
		//품의
		cnsu = new Rui.ui.form.LMonthBox({
            applyTo: 'cnsu',
            defaultValue: '<c:out value="${inputData.cnsu}"/>',
            width: 100,
            dateType: 'string'
        });
		//발주
		ordn = new Rui.ui.form.LMonthBox({
            applyTo: 'ordn',
            defaultValue: '<c:out value="${inputData.ordn}"/>',
            width: 100,
            dateType: 'string'
        });
		//입고
		whsn = new Rui.ui.form.LMonthBox({
            applyTo: 'whsn',
            defaultValue: '<c:out value="${inputData.whsn}"/>',
            width: 100,
            dateType: 'string'
        });
		//양산
		mssp = new Rui.ui.form.LMonthBox({
            applyTo: 'mssp',
            defaultValue: '<c:out value="${inputData.whsn}"/>',
            width: 100,
            dateType: 'string'
        });
        
        //정량적
        quan = new Rui.ui.form.LNumberBox({
            applyTo: 'quan',
            defaultValue: 0,
            decimalPrecision: 2,
            width: 200
        });
      	//정성적
        qtTxt = new Rui.ui.form.LTextArea({
            applyTo: 'qtTxt',
            height: 100,
            width: 1100
        });
      	//예상투자규모
        ancpSclTxt = new Rui.ui.form.LNumberBox({
            applyTo: 'ancpSclTxt',
            defaultValue: 0,
            decimalPrecision: 2,
            width: 200
        });
      	//과제성격1
       	tssStatF = new Rui.ui.form.LCombo({
            applyTo: 'tssStatF',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_STAT_F"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
       	tssStatF.getDataSet().on('load', function(e) {
            console.log('tssStatF :: load');
        });
      
      	//과제성격2
       	tssStatS = new Rui.ui.form.LCombo({
            applyTo: 'tssStatS',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_STAT_S"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
       	tssStatS.getDataSet().on('load', function(e) {
            console.log('tssStatS :: load');
        });
      	//과제난이도
       	tssDfcr = new Rui.ui.form.LCombo({
            applyTo: 'tssDfcr',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_DFCR"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
       	tssDfcr.getDataSet().on('load', function(e) {
            console.log('tssDfcr :: load');
        });
      
      	//설치장소
        istlPlTxt = new Rui.ui.form.LTextArea({
            applyTo: 'istlPlTxt',
            height: 100,
            width: 1100
        });
      	//추천업체
        rcmCofTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rcmCofTxt',
            height: 100,
            width: 1100
        });
      	//과제개요 및 Output Image
        tssTxt = new Rui.ui.form.LTextArea({
            applyTo: 'tssTxt',
            height: 100,
            width: 1100
        });
      	//중점요청사항
        empsReqTxt = new Rui.ui.form.LTextArea({
            applyTo: 'empsReqTxt',
            height: 100,
            width: 1100
        });
      	//협력요청사항
        cooReqTxt = new Rui.ui.form.LTextArea({
            applyTo: 'cooReqTxt',
            height: 100,
            width: 1100
        });

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
		
//=================ylt   div =================================================//
      
      //목표년도
        cboGoalY = new Rui.ui.form.LCombo({
            name: 'cboGoalY',
            url: '<c:url value="/prj/tss/gen/retrieveGenTssGoalYy.do"/>',
            displayField: 'goalYy',
            valueField: 'goalYy',
            rendererField: 'goalYy',
            autoMapping: true
        });
        cboGoalY.getDataSet().on('load', function(e) {
            console.log('cboGoalY :: load');
        });
        
        //산출물유형
        cbYldItmType = new Rui.ui.form.LCombo({
            name: 'cbYldItmType',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=YLD_ITM_TYPE_G"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            rendererField: 'value',
            autoMapping: true
        });
        cbYldItmType.getDataSet().on('load', function(e) {
            console.log('cbYldItmType :: load');
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
             	, { id: 'saSabunNew' }
             	, { id: 'pgsStepNm' }
             	, { id: 'grsStepNm' }
             	, { id: 'prjCd'}
             	, { id: 'fcNm'}
             ]
		});
        
		mstDataSet.on('load', function(e) {
			
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
            ]
		});
		
		smryDataSet.on('load', function(e) {
			smryDataSet.setNameValue(0, 'tssCd', tssCd);
			
			if(!Rui.isEmpty(smryDataSet.getNameValue(0, 'attcFilId')) ){
				lvAttcFilId = smryDataSet.getNameValue(0, 'attcFilId');
				getAttachFileList();
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
                , { field: 'saUserName', label: '과제멤버', sortable: false, align:'center', width: 150, renderer: Rui.util.LRenderer.popupRenderer() }
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
                             else if(v == '02') return "과제멤버";
                         } 
                      }    
                 }
                 , { field: 'tssCd', hidden:true }
                 , { field: 'ptcRsstMbrSn', hidden:true }
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
//============================yldDataSet ================================================================//
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
            	if(!vm.validateGroup("smryForm")) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                    return false;
                }
	
				if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[mstDataSet, smryDataSet],
                        url:'<c:url value="/prj/tss/mkInno/saveMkInnoMst.do"/>',
                        modifiedOnly: false
                    });
            	}
            };
            
          	//mbr 추가
			fnMbrAdd = function(){
				var row =  mbrDataSet.newRecord();
                var record = mbrDataSet.getAt(row);
                
                record.set("tssCd",  tssCd);
          	}           
            
			//mbr 삭제
			fnMbrdel = function(){
				var dbCallYN = false;
				
				if( mbrDataSet.getMarkedCount() == 0 ){
					alert("삭제할 목록을 선택하세요");
					return;
				}
				
				if(confirm('삭제하시겠습니까?')) {
					for( var i = 0 ; i < mbrDataSet.getCount(); i++ ){
						if(mbrDataSet.isMarked(i)){
				    		if((mbrDataSet.getNameValue(i, 'ptcRsstMbrSn') != "") ){
				    			dbCallYN = true;
				    		}
				    	}
					}
					
					if(mbrDataSet.getMarkedCount() > 0) {
						mbrDataSet.removeMarkedRows();
	                } else {
	                    var row = mbrDataSet.getRow();
	                    if(row < 0) return;
	                    mbrDataSet.removeAt(row);
	                }

					if( dbCallYN ){
						dm.updateDataSet({
	                        url:'<c:url value="/prj/tss/mkInno/deleteMkInnoTssPtcRsstMbr.do"/>',
	                        dataSets:[mbrDataSet]
	                    });
					}
	            }
          	}    
                    
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
            	if(!vm.validateGroup("smryForm")) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                    return false;
                }
            	
            	if(  mbrDataSet.getCount() == 0   ){
            		alert("참여인원 정보를 등록하세요");
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
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

            return lvAttcFilId;
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
                  { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }
                , { id: 'prjCd',      ctrlId: 'prjCd',      value: 'value' }
                , { id: 'prjNm',      ctrlId: 'prjNm',      value: 'value' }
                , { id: 'deptName',   ctrlId: 'deptName',   value: 'value' }
                , { id: 'bizDptCd',   ctrlId: 'bizDptCd',   value: 'value' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }
                , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'value' }
                , { id: 'saSabunNew', ctrlId: 'saSabunNew', value: 'value' }
                , { id: 'saUserName', ctrlId: 'saUserName', value: 'value' }
                , { id: 'tssAttrCd',  ctrlId: 'tssAttrCd',  value: 'value' }
                , { id: 'tssStrtDd',  ctrlId: 'tssStrtDd',  value: 'value' }
                , { id: 'tssFnhDd',   ctrlId: 'tssFnhDd',   value: 'value' }
                , { id: 'prodGCd',    ctrlId: 'prodGCd',    value: 'value' }
                , { id: 'pgsStepNm',  ctrlId: 'pgsStepNm',  value: 'html' }				//과제 단계명
                , { id: 'fcNm',  	  ctrlId: 'fcNm',       value: 'html' }				// GRS 단계명
            ]
        });
        
      	//폼에 출력 (smryDataSet)
        var smryBind = new Rui.data.LBind({
            groupId: 'smryInfoDiv',
            dataSet: smryDataSet,
            bind: true,
            bindInfo: [
                  { id: 'dvlpGoalTxt',  ctrlId: 'dvlpGoalTxt',	value: 'value' }
                , { id: 'sbcTclgTxt',   ctrlId: 'sbcTclgTxt',   value: 'value' }
                , { id: 'cnsu',      	ctrlId: 'cnsu',      	value: 'value' }
                , { id: 'ordn',   		ctrlId: 'ordn',   		value: 'value' }
                , { id: 'whsn',   		ctrlId: 'whsn',   		value: 'value' }
                , { id: 'mssp',      	ctrlId: 'mssp',      	value: 'value' }
                , { id: 'quan',      	ctrlId: 'quan',      	value: 'value' }
                , { id: 'qtTxt',      	ctrlId: 'qtTxt',      	value: 'value' }
                , { id: 'tssStatF', 	ctrlId: 'tssStatF', 	value: 'value' }
                , { id: 'tssStatS', 	ctrlId: 'tssStatS', 	value: 'value' }
                , { id: 'tssDfcr',  	ctrlId: 'tssDfcr',  	value: 'value' }
                , { id: 'ancpSclTxt',  	ctrlId: 'ancpSclTxt',  	value: 'value' }
                , { id: 'istlPlTxt',   	ctrlId: 'istlPlTxt',   	value: 'value' }
                , { id: 'rcmCofTxt',    ctrlId: 'rcmCofTxt',    value: 'value' }
                , { id: 'tssTxt',  		ctrlId: 'tssTxt',    	value: 'value' }				
                , { id: 'empsReqTxt',  	ctrlId: 'empsReqTxt',   value: 'value' }			
                , { id: 'cooReqTxt',  	ctrlId: 'cooReqTxt',    value: 'value' }			
                , { id: 'attcFilId',  	ctrlId: 'attcFilId',    value: 'value' }			
            ]
        });
        
      	
      //유효성
        vm = new Rui.validate.LValidatorManager({
            validators: [
		          { id: 'dvlpGoalTxt',  validExp: '개발목표:true'}
		        , { id: 'quan',      	validExp: '정량적:true'}
		        , { id: 'tssStatF', 	validExp: '과제성격1:true'}
		        , { id: 'tssStatS', 	validExp: '과제성격2:true'}
		        , { id: 'tssDfcr',  	validExp: '과제난이도:true'}
		        , { id: 'ancpSclTxt',  	validExp: '예상투자규모:true'}
		        , { id: 'istlPlTxt',   	validExp: '설치장소:true'}
		        , { id: 'rcmCofTxt',    validExp: '추천업체:true'}
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
        <h2>제조혁신과제 &gt;&gt; 계획</h2>
	</div>
	<div class="sub-content">
	<form   id="aform" name="aform">		
	<input type="hidden" id="tssCd" name="tssCd" value='${inputData.tssCd}'/>
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
                    	<th align="right">팀명</th>
                        <td>
                            <input type="text" id="prjNm" />
                        </td>
                        <th align="right">조직</th>
                        <td>
                            <input type="text" id="deptName" />
                        </td>
                    </tr>
                    <tr>
                    	<th align="right">WBSCode / 과제명</th>
                        <td colspan="3">
                        	<span id='seed'></span><input type="text" id="wbsCd" /> / <em class="gab"><input type="text" id="tssNm" style="width:900px;padding:0px 5px" />
                        </td>
                    </tr>
                    <tr>
						<th align="right">과제리더</th>
                        <td>
                        	<input type="text" id="saUserName" />
                        </td>
                        <th align="right">사업부문(Funding기준)</th>
                        <td>
                        	<div id="bizDptCd"></div>
                        </td>
                    </tr>
                    <tr>
                    	<th align="right">제품군</th>
                        <td>
                        	<div id="prodGCd" />
                        </td>
                        <th align="right">과제기간</th>
                        <td>
                        	<input type="text" id="tssStrtDd" /><em class="gab"> ~ </em><input type="text" id="tssFnhDd" />
                        </td>
                    </tr>
                    <tr>
                    	<th align="right">진행단계</th>
                        <td><span id="pgsStepNm"></span></td>
                    	<th align="right">공장</th>
                        <td><span id="fcNm"></span></td>
                    </tr>
		 		</tbody>
		 	</table>	
		 </fieldset>
         </div>
</form> 
<from id="smryForm">        
         <br/> 
         <div id="tabView"></div>
         <div id="smryInfoDiv">
         	<table class="table table_txt_right">
				<colgroup>
	                <col style="width:26%;" />
	                <col style="width:24%;" />
	                <col style="width:30%;" />
	                <col style="width:20%;" />
	            </colgroup>
         		<tbody>
         			<tr>
	         			<th rowspan="2">사양</th>
	         			<th><span style="color:red;">* </span>개발목표</th>
	         			<td colspan="2">
	         				<input type="text" id="dvlpGoalTxt"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th>주요기술</th>
	         			<td colspan="2">
	         				<input type="text" id="sbcTclgTxt"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th rowspan="4">목표일정<br/>(장비성과제시)</th>
	         			<th>품의</th>
	         			<td colspan="2">
	         				<input type="text" id="cnsu"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th>발주</th>
	         			<td colspan="2">
	         				<input type="text" id="ordn"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th>입고</th>
	         			<td colspan="2">
	         				<input type="text" id="whsn"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th>양산</th>
	         			<td colspan="2">
	         				<input type="text" id="mssp"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th rowspan="2">기대효과</th>
	         			<th><span style="color:red;">* </span>정량적</th>
	         			<td colspan="2">
	         				<input type="text" id="quan"  /> [억원/년]
	         			</td>
	         		</tr>
         			<tr>
	         			<th>정성적</th>
	         			<td colspan="2">
	         				<input type="text" id="qtTxt"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2"><span style="color:red;">* </span>과제 성격(Ⅰ)</th>
	         			<td colspan="2">
	         				<select  id="tssStatF" ></select>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2"><span style="color:red;">* </span>과제 성격(Ⅱ)</th>
	         			<td colspan="2">
	         				<select  id="tssStatS" ></select>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2"><span style="color:red;">* </span>과제난이도</th>
	         			<td colspan="2">
	         				<select  id="tssDfcr" ></select>
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">예상투자규모</th>
	         			<td colspan="2">
	         				<input type="text" id="ancpSclTxt"  /> [억원/건]
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">설치장소<br/>(장비성과제시)</th>
	         			<td colspan="2">
	         				<input type="text" id="istlPlTxt"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">추천업체<br/>(장비성과제시)</th>
	         			<td colspan="2">
	         				<input type="text" id="rcmCofTxt"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">과제 개요</th>
	         			<td colspan="2">
	         				<input type="text" id="tssTxt"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">중점요청 사항</th>
	         			<td colspan="2">
	         				<input type="text" id="empsReqTxt"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">협력요청 사항</th>
	         			<td colspan="2">
	         				<input type="text" id="cooReqTxt"  />
	         			</td>
	         		</tr>
         			<tr>
	         			<th colspan="2">첨부파일</th>
	         			<td id="attchFileView">&nbsp;</td>
                    	<td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
	         		</tr>
         		</tbody>
         	</table>
         	<div class="titArea btn_btm">
	        	<div class="LblockButton">
		            <button type="button" id="btnSave" name="btnSave" onclick="fnMstSave()">저장</button>
	        	</div>
	        </div>	
    	</div>
</from>         
		<div id="mbrInfoDiv">
        	 <br/>
        	 <div class="titArea">
			    <div class="LblockButton">
			        <button type="button" id="butRecordNew"  onclick="fnMbrAdd()">추가</button>
			        <button type="button" id="btnMbrSave" onclick="fnMbrSave()">저장</button>
			        <button type="button" id="butRecordDel" onclick="fnMbrdel()">삭제</button>
			    </div>
			</div>
			<div id="defaultGrid"></div>
         </div>
	</div>	
</div>
</body>
</html>
