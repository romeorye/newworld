<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id        : prjMonClsList.jsp
 * @desc    : 연구팀(Project) > 월마감 > 월마감 상세정보
 *------------------------------------------------------------------------
 * VER    DATE        AUTHOR        DESCRIPTION
 * ---    -----------    ----------    -----------------------------------------
 * 1.0  2017.08.18     IRIS05        최초생성
 * ---    -----------    ----------    -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<%-- month Calendar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<%-- toolTip --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LTooltip.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LTooltip.css"/>

<script type="text/javascript">
    var lmbSearchMonth;
    var mboDataSet;
    var clsDataSet;
    var prjDataSet;
    var tssPgsDataSet;
    var clsVm;            // cls 폼 validator manager
    var lcbPgsStatCd;
    var fnoPln;
    var chkPgsYn="Y";

    Rui.onReady(function() {

        /* form setting */
        lmbSearchMonth = new Rui.ui.form.LMonthBox({
            applyTo: 'searchMonth',
            defaultValue: new Date(),
            dateType: 'string',
            width: 100
        });

        prjClsSbc = new Rui.ui.form.LTextArea({
            applyTo: 'prjClsSbc' ,
            placeholder: '' ,
            width: 600 ,
            height: 100 ,
            attrs: {
                maxLength: 2000
                }
        });

        fnoPln = new Rui.ui.form.LTextArea({
            applyTo: 'fnoPln' ,
            placeholder: '' ,
            width: 600 ,
            height: 100 ,
            disabled : true,
            attrs: {
                maxLength: 4000
                }
        });

        /* COMBO : PGS_STAT_CD(진척상태코드) => pgsStatCd */
        lcbPgsStatCd = new Rui.ui.form.LCombo({
            applyTo:'pgsStatCd',
            useEmptyText: true,
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PGS_STAT_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD'
        });

        var gridTooltip = new Rui.ui.LTooltip({
            showmove: true
        });

        /* 프로젝트정보 */
        prjDataSet = new Rui.data.LJsonDataSet({
            id: 'prjDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'prjCd' }       //프로젝트코드
                , { id: 'wbsCd' }       //프로젝트명
                , { id: 'prjNm' }
                , { id: 'plEmpNo' }
                , { id: 'saName' }
                , { id: 'deptCd' }
                , { id: 'deptName' }
                , { id: 'uperdeptName' }
                , { id: 'prjStrDt'  }
                , { id: 'prjEndDt'  }
                , { id: 'prjCpsn'  }
                , { id: 'wbsCdA'}        // WBS코드 약어
                , { id: 'aftPgsSt'}      //전월마감 입력상태
                , { id: 'aftPgsStYn'}      //전월마감 입력상태
                , { id: 'orgWbsCd' }
            ]
        });
        prjDataSet.on('load', function(e){
            var logInSabun = '${input._userSabun}';
            var btnRole = "N";

            if("<c:out value='${input._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
                btnRole = "Y";
            }else if("<c:out value='${input._roleId}'/>".indexOf('WORK_IRI_T03') > -1) {
                btnRole = "Y";
            }else if("<c:out value='${input._roleId}'/>".indexOf('WORK_IRI_T05') > -1) {
                btnRole = "Y";
            }

            if( logInSabun == prjDataSet.getNameValue(0, 'plEmpNo') || btnRole == "Y" ){
                $('#butRgst').show();
            }else{
                $('#butRgst').hide();
            }
        });

        /* [prjDataSet] bind */
        var prjBind = new Rui.data.LBind({
            groupId: 'prjForm',
            dataSet: prjDataSet,
            bind: true,
            bindInfo: [
                // 화면표시 정보
                  { id: 'saName',          ctrlId: 'spnSaName',    value: 'html' }    // SPAN : PL명
                , { id: 'uperdeptName',    ctrlId: 'spnDeptName',  value: 'html' }    // SPAN : 조직명
                , { id: 'wbsCd',           ctrlId: 'spnWbsCd',     value: 'html' }    // SPAN : WBS코드
                , { id: 'prjNm',           ctrlId: 'spnPrjNm',     value: 'html' }    // SPAN : 프로젝트명
                , { id: 'aftPgsSt',        ctrlId: 'aftPgsSt',     value: 'html' }    // SPAN : 전월마감입력정보
                , { id: 'pgsStatCd',       ctrlId: 'pgsStatCd',    value: 'html' }    // SPAN : 전월마감입력정보
            ]
        });

        /* MBO(특성지표) */
        mboDataSet = new Rui.data.LJsonDataSet({
            id: 'mboDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'prjCd'}
                , { id: 'wbsCd'}
                , { id: 'seq'}
                , { id: 'mboGoalYear'}
                , { id: 'mboGoalAltp'}
                , { id: 'mboGoalPrvs'}
                , { id: 'mboGoalL'}
                , { id: 'arlsYearMon'}
                , { id: 'arlsStts'}
                , { id: 'filId'}
                , { id: 'filYn', defaultValue: 'N' } /*파일존재여부*/
            ]
        });

           var mboColumnModel = new Rui.ui.grid.LColumnModel({
               columns: [
                     { field: 'mboGoalYear',    label: '목표년도', sortable: false, align:'center', width: 65 }
                 , { field: 'mboGoalPrvs',    label: '목표항목', sortable: false, align:'left', width: 330
                     , renderer: function(value, p, record){
                         p.tooltipText = value;
                         return value;
                       }
                   }
                   , { field: 'mboGoalAltp',    label: '배점'    , sortable: false, align:'right', width: 60 }
                   , { field: 'mboGoalL',       label: '목표수준', sortable: false, align:'left', width: 350
                       , renderer: function(value, p, record){
                         p.tooltipText = value;
                         return value;
                       }
                   }
                   , { field: 'arlsYearMon',    label: '진척년월', sortable: false, align:'center', width: 60 }
                   , { field: 'arlsStts',       label: '진척현황', sortable: false, align:'left', width: 350
                       , renderer: function(value, p, record){
                         p.tooltipText = value;
                         return value;
                       }
                   }
                   , { field: 'filId',  label: '첨부파일', align:'center', width: 110 ,
                       renderer: function(val, p, record, row, i){
                           var recordFilYn = nullToString(record.data.filYn);
                        var recordFilId = nullToString(record.data.filId);
                        var strBtnFun = "openAttachFileDialog(setMboAttachFileInfo, "+recordFilId+", 'prjPolicy', '*','R')";
                        if(recordFilYn == 'Y'){
                            return '<button type="button" class="L-grid-button L-popup-action" onclick="'+strBtnFun+'">보기</button>';
                        }
                    }
                     }

               ]
           });

          var mboGrid = new Rui.ui.grid.LGridPanel({
              columnModel: mboColumnModel,
              dataSet: mboDataSet,
              width:  600,
              height: 100,
              autoWidth: true,
                viewConfig: {
                tooltip: gridTooltip
            }
          });

          /* 진척도 */
        tssPgsDataSet = new Rui.data.LJsonDataSet({
            id: 'tssPgsDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'wbsCd'}        //과제코드
                , { id: 'tssNm'}        //과제명
                , { id: 'saUserName'}   //과제리더
                , { id: 'deptName'}     //조직
                , { id: 'tssStrtDd'}    //과제기간시작
                , { id: 'tssFnhDd'}     //과제기간종료
                , { id: 'progressrateReal'} //진척율
                , { id: 'progressrate'} //진척율
                , { id: 'pg'}      //상태
                , { id: 'prjCd'}      //상태
                , { id: 'prjClsYymm'}      //상태
                , { id: '_userId'}      //상태
            ]
        });

        /* [Grid] 컬럼설정 */
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                  { field: 'tssNm',        label: '과제명', sortable: true, align:'left', width: 375 }
                , { field: 'saUserName',   label: '과제리더', sortable: true, align:'center', width: 170 }
                , { field: 'deptName',     label: '조직', sortable: true, align:'center', width: 250 }
                , { id: 'G1', label: '과제기간(계획일)' }
                , { field: 'tssStrtDd',    label: '시작일', groupId: 'G1', sortable: true, align:'center', width: 150 }
                , { field: 'tssFnhDd',     label: '종료일', groupId: 'G1', sortable: true, align:'center', width: 150 }
                , { field: 'progressrateReal', label: '진척율<br>(실적/계획)', sortable: true, align:'center', width: 110 }
                , { id: 'pg', label: '진척도', align:'center', width: 120 ,renderer :function(value, p, record, row, col) {

                    var pgN ="달성";
                    var pgS ="초과";
                    var pgD ="미달";

                    var progressrateReal= record.get('progressrateReal');
                    var arrPrg = progressrateReal.split('/')

                    var rWgvl = floatNullChk(arrPrg[0]) ; // 실적
                    var gWgvl  = floatNullChk(arrPrg[1]) ; //목표
                    rWgvl = rWgvl+1;
                    var pg = pgN ;

                    if(rWgvl > gWgvl){
                        pg = pgS ;
                    }else if(rWgvl < gWgvl){
                        rWgvl = rWgvl;

                        if( rWgvl < gWgvl ){
                            pg = pgD ;
                        }else{
                            pg = pgN ;
                        }
                    }else if(rWgvl = gWgvl){
                        pg = pgN ;
                    }

                    var pgsStepCd= record.get('pgsStepCd');

                    if(pgsStepCd=='PL'){
                        pg = '';
                    }
                    return pg;
                }}
            ]
        });

        /* [Grid] 패널설정 */
        var tssPgsGrid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: tssPgsDataSet,
            width: 1150,
            height: 220,
            autoWidth: true
        });

        tssPgsGrid.render('tssPgsGrid');

        tssPgsDataSet.on('load', function(e){

            if (tssPgsDataSet.getCount() > 0 ){
                for(var i=0; i < tssPgsDataSet.getCount(); i++){
                    var pgN ="달성";
                    var pgS ="초과";
                    var pgD ="미달";

                    var progressrateReal= tssPgsDataSet.getNameValue(i, 'progressrateReal');

                    var arrPrg = progressrateReal.split('/')

                    var rWgvl = floatNullChk(arrPrg[0]) ; // 실적
                    var gWgvl  = floatNullChk(arrPrg[1]) ; //목표
                    rWgvl = rWgvl+1;
                    var pg = pgN ;

                    if(rWgvl > gWgvl){
                        pg = pgS ;
                    }else if(rWgvl < gWgvl){
                        rWgvl = rWgvl;

                        if( rWgvl < gWgvl ){
                            pg = pgD ;
                        }else{
                            pg = pgN ;
                        }
                    }else if(rWgvl = gWgvl){
                        pg = pgN ;
                    }

                    if(pg == "미달"){
                        //콤보 cha
                        chkPgsYn = "N";
                    }
                }

                if( chkPgsYn == "Y" ){
                    fncPgsProcess('ON');
                }else{
                    fncPgsProcess('OF');
                }
            }else{
                 if( lcbPgsStatCd.getValue() == "OF"){
                     fnoPln.enable();
                 }else{
                     fnoPln.disable();
                 }
            }
        });

        lcbPgsStatCd.on('changed', function(e){
            if( lcbPgsStatCd.getValue() == "OF"){
                fnoPln.enable();
            }else{
                fnoPln.disable();
            }
        });

        var fncPgsProcess = function(val){
            var pgsStatCd = clsDataSet.getNameValue(0, 'pgsStatCd');
console.log("[pgsStatCd]", pgsStatCd);
            if (!Rui.isEmpty( pgsStatCd )){
                lcbPgsStatCd.setValue( pgsStatCd );
                lcbPgsStatCd.disable();

                if( val == "OF"){
                    fnoPln.enable();
                }else{
                    fnoPln.disable();
                }
            }else{
                lcbPgsStatCd.setValue(val);
                //lcbPgsStatCd.disable(); //[20240806.siseo]진척상태 비활성화 주석후 하단에 조건 체크

                if( val == "OF"){
                    fnoPln.enable();
                    lcbPgsStatCd.disable();
                }else{
                    fnoPln.disable();
                    lcbPgsStatCd.enable();
                }
            }
        }

/* 산출물, 지적재산권 그리드 제거 : 김민정책임 요청 */
        mboGrid.render('mboGrid');
//        pduGrid.render('pduGrid');
//        ptoprptGrid.render('ptoprptGrid');

        /* 진척도 FORM */
        clsDataSet = new Rui.data.LJsonDataSet({
            id: 'clsDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'prjCd'}
                , { id: 'wbsCd'}
                , { id: 'prjClsYn'}     /*마감여부 Y/N*/
                , { id: 'pgsStatCd'}    /*진척상태*/
                , { id: 'prjClsYymm'}   /*마감월 YYYY-MM*/
                , { id: 'prjClsSbc'}    /*마감내용*/
                , { id: 'fnoPln'}    /*지연 및 향후계획*/
                , { id: 'attcFilId'}    /*첨부파일ID*/
            ]
        });

        var clsDtlBind = new Rui.data.LBind({
            groupId: 'clsForm',
            dataSet: clsDataSet,
            bind: true,
            bindInfo: [
                  {id: 'pgsStatCd' ,  ctrlId: 'pgsStatCd',      value: 'value' }
                , {id: 'prjClsSbc',   ctrlId: 'prjClsSbc',      value: 'value' }
                , {id: 'prjCd',       ctrlId: 'hClsPrjCd',      value: 'value' }
                , {id: 'fnoPln',       ctrlId: 'fnoPln',      value: 'value' }
                , {id: 'attcFilId',   ctrlId: 'hfilId',         value: 'value' }

            ]
        });

        /* 진척도 첨부파일 */
        clsAttachDataSet = new Rui.data.LJsonDataSet({
            id: 'clsAttachDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq'}
                , { id: 'filNm'}
                , { id: 'filPath'}
                , { id: 'filSize'}
            ]
        });
        clsAttachDataSet.on('load', function(e) {
            if(!Rui.isEmpty(clsAttachDataSet.getNameValue(0, 'attcFilId'))){
            //if(clsAttachDataSet.getTotalCount() > 0){
                $('#spnClsFilId').text('');

                // 로드시 첨부파일 다운로드 태그표시
                for(var i=0; i<clsAttachDataSet.getCount(); i++) {
                       $('#spnClsFilId').append($('<a/>', {
                           href: 'javascript:downloadAttachFile("' + clsAttachDataSet.getAt(i).get('attcFilId') + '", "' + clsAttachDataSet.getAt(i).get('seq') + '")',
                           text: clsAttachDataSet.getAt(i).get('filNm') + '(' + clsAttachDataSet.getAt(i).get('filSize') + 'byte)'
                       })).append('<br/>');
                }
            }else{
                $('#spnClsFilId').text('');
            }
        });

        <%-- VALIDATOR --%>
        clsVm = new Rui.validate.LValidatorManager({
            validators:[
                  { id: 'pgsStatCd' , validExp:'진척상태:true'}
                , { id: 'prjClsSbc' , validExp:'월마감내용:true'}
                , { id: 'attcFilId' , validExp:'첨부파일:true'}
            ]
        });

        /* [버튼] 목록 */
           var butGoList = new Rui.ui.LButton('butGoList');
           butGoList.on('click', function() {
               nwinsActSubmit(clsForm, "<c:url value='/prj/rsst/retrievePrjClsList.do'/>");
           });

           /* [버튼] 진척도 - 파일업로드 */
           var butClsAttachFileMng = new Rui.ui.LButton('butClsAttachFileMng');
           butClsAttachFileMng.on('click', function() {
               openAttachFileDialog(setClsAttachFileInfo, clsForm.hfilId.value, 'prjPolicy', '*');
           });

           /* [버튼] 저장 */
           var butRgst = new Rui.ui.LButton('butRgst');
           butRgst.on('click', function() {
            var dmRgst = new Rui.data.LDataSetManager({defaultFailureHandler: false});

              // 1. 데이터셋 valid
              if(!clsVm.validateGroup("clsForm") ){
                  alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + clsVm.getMessageList().join(''));
                return;
              }

              if( Rui.isEmpty(clsForm.hfilId.value) ){
                  alert("첨부파일을 등록하셔야 합니다.");
                  return;
              }

//             if(clsDataSet.isUpdated()){
               // 2. 데이터 저장&업데이트
                 Rui.confirm({
                     text: '마감하시겠습니까?',
                     handlerYes: function() {

                         for(var i= 0; i < tssPgsDataSet.getCount(); i++){
                             tssPgsDataSet.setNameValue(i, 'prjClsYymm' ,lmbSearchMonth.getValue() )    ;
                             tssPgsDataSet.setNameValue(i, '_userId' , '${input._userId}')    ;
                         }
                         // 등록처리
                         dmRgst.updateDataSet({
                            modifiedOnly: false,
                            url: "<c:url value='/prj/rsst/insertPrjRsstCls.do'/>",
                            dataSets : [tssPgsDataSet],
                             //form: 'clsForm',
                            params: {
                                 prjCd      : prjForm.hPrjCd.value
                               , wbsCd      : prjForm.hWbsCd.value
                               , attcFilId  : clsForm.hfilId.value
                               , prjClsYymm : lmbSearchMonth.getValue()
                               , hClsPrjCd   : document.clsForm.hClsPrjCd.value
                               , hfilId   : document.clsForm.hfilId.value
                               , hDownFilSeq   : document.clsForm.hDownFilSeq.value
                               , pgsStatCd   : document.clsForm.pgsStatCd.value
                               , prjClsSbc   : document.clsForm.prjClsSbc.value
                               , fnoPln   : document.clsForm.fnoPln.value
                             }
                         });
                     },
                     handlerNo: Rui.emptyFn
                 });


               // 성공시 메시지팝업창 후 재조회
               dmRgst.on('success', function(e) {
                var data = Rui.util.LJson.decode(e.responseText);
                Rui.alert({
                    text: '마감되었습니다.',
                    handler: function() {
                        // 재조회
                        nwinsActSubmit(document.clsForm, "<c:url value='/prj/rsst/retrievePrjClsList.do'/>");
                    }
                });

               });

               // 실패시 메시지팝업창 노출
               dmRgst.on('failure', function(e) {
                   var data = Rui.util.LJson.decode(e.responseText);
                Rui.alert(data[0].records[0].rtnMsg);
               });
           });

           /* 첨부파일 세팅-월마감 */
           setClsAttachFileInfo = function(attachFileList) {
            $('#spnClsFilId').text('');

            if(attachFileList.length > 0){
                clsForm.hfilId.value = attachFileList[0].data.attcFilId;

                // 데이터셋 filId 에도 세팅
                if( clsDataSet.getNameValue(0,"attcFilId") != clsForm.hfilId.value ){
                    clsDataSet.setNameValue(0,"attcFilId", clsForm.hfilId.value);
                }
            }

            for(var i=0; i<attachFileList.length; i++) {
                   $('#spnClsFilId').append($('<a/>', {
                       href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                       text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                   })).append('<br/>');
            }
        };

        /* 첨부파일 세팅 - MBO */
           setMboAttachFileInfo = function(attachFileList) {
        };

        /* 첨부파일 세팅 - 필수산출물 */
//           setPduAttachFileInfo = function(attachFileList) {
//        };

        /* 첨부파일 다운 */
        downloadAttachFile = function(attcFilId, seq) {
            var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
            clsForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
            clsForm.submit();
        };

        /* 첨부파일 조회 */
        getAttachFileId = function() {
            return clsForm.hfilId.value;
        };

        /* 화면초기화 */
        setOnInit = function(){
            var searchMonth = '${input.searchMonth}';
            if(searchMonth != null && searchMonth != ''){
                lmbSearchMonth.setValue(searchMonth);
            }

            // 온로드시 조회
            fnSearch();
        }

        // 화면세팅 실행
        setOnInit();

    });    //end ready


    <%--/*******************************************************************************
     * FUNCTION 명 : fnSearch
     * FUNCTION 기능설명 : 데이터셋 모두 조회(MBO, PDU, CLS, CLS_ATTACH_FILE, PRJ)
     *
     *******************************************************************************/--%>
    function fnSearch(){

        var dm = new Rui.data.LDataSetManager();

        dm.loadDataSet({
            dataSets: [ mboDataSet, clsDataSet, clsAttachDataSet, prjDataSet, tssPgsDataSet ],
            url: '<c:url value="/prj/rsst/retrievePrjClsSearchDtl.do"/>' ,
            params :{
                prjCd       : prjForm.hPrjCd.value
              , wbsCd       : prjForm.hWbsCd.value
              , searchMonth : lmbSearchMonth.getValue()
            }
        });
        
        lcbPgsStatCd.enable(); //[20240806.siseo]진척상태 초기화
    }

    <%--/*******************************************************************************
     * FUNCTION 명 : validation
     * FUNCTION 기능설명 : 입력 폼 점검
     *******************************************************************************/--%>
    function validation(vForm){

        // 1. 기본 RUi Form valid
         var vTestForm = vForm;
         if(clsVm.validateGroup(vTestForm) == false) {
             Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + clsVm.getMessageList().join('<br>') );
             return false;
         }

         //[20240422]정근CH 요청으로 필수체크 막음
         /* if(lcbPgsStatCd.getValue() == "OF" &&  Rui.isEmpty(fnoPln.getValue() ) ){
             Rui.alert("진행상태가 off Track일 경우 지연내역및 향후계획을 입력하셔야 합니다.");
             return false;
         }

         if(lcbPgsStatCd.getValue() == "OF" &&  fnoPln.getValue().length < 100 ){
             Rui.alert("지연내역및 향후계획내용은 100자 이상이여야 합니다. <br/> ( 현재 : "+fnoPln.getValue().length );
             return false;
         } */

         if( prjClsSbc.getValue().length < 100 ){
             Rui.alert("월마감 내용은 100자 이상이여야 합니다. <br/>   ( 현재 : "+prjClsSbc.getValue().length +")" );
             return false;
         }


         var today = Rui.util.LDate.format(new Date(), '%Y%m');
         var sMon = lmbSearchMonth.getValue().replace("-", "");

         if( sMon >  today  ){
             Rui.alert("저장 할 마감월이 잘못되었습니다. ");
             return;
         }

         return true;
     }
</script>

</head>
<body>
<Tag:saymessage /><!--  sayMessage 사용시 필요 -->
<%-- <form name="searchForm" id="searchForm"  method="post">
    <input type="hidden" name=pageNum value="${inputData.pageNum}"/>
</form> --%>
<div class="contents">
    <div class="titleArea">
        <a class="leftCon" href="#">
                <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
                <span class="hidden">Toggle 버튼</span>
            </a>
           <h2>월마감 상세정보</h2>
       </div>

    <div class="sub-content">
        <div class="titArea" style="margin-top:0;">
            <h3>프로젝트 정보</h3>
        </div>
        <form id="prjForm" name="prjForm" method="post">
        <input type="hidden" id="hPrjCd" name="hPrjCd" value="<c:out value='${input.prjCd}'/>"/>
        <input type="hidden" id="hWbsCd" name="hWbsCd" value="<c:out value='${input.wbsCd}'/>"/>
        <div class="search">
            <div class="search-content">
                <table>
                    <colgroup>
                        <col style="width:15%"/>
                        <col style="width:30%"/>
                        <col style="width:15%"/>
                        <col style="width:30%"/>
                        <col style="width:*"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th align="right">WBS 코드</th>
                            <td>
                                <span id="spnWbsCd"></span>
                            </td>
                            <th align="right">프로젝트명</th>
                            <td>
                                <span id="spnPrjNm"></span>
                            </td>
                            <td rowspan="3" class="t_center">
                                 <a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
                             </td>
                        </tr>
                        <tr>
                            <th align="right">PL 명</th>
                            <td><span id="spnSaName"></span></td>
                            <th align="right">조직</th>
                            <td>
                                <span id="spnDeptName"></span>
                            </td>
                        </tr>
                        <tr>
                            <th align="right">기준월</th>
                            <td>
                                <input type="text" id="searchMonth" name="searchMonth"/>
                            </td>
                            <th align="right">전월마감완료</th>
                            <td>
                                <span id="aftPgsSt"></span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        </form>
        <br>


        <div class="titArea" style="margin-top:0;">
            <h3>MBO (특성지표) 계획</h3>
        </div>
        <div id="mboGrid"></div>
        <br>

<!--  산출물, 지적재산권 그리드 제거 : 김민정책임 요청 -->
<!--         <div class="titArea">
            <h3>필수산출물 목록</h3>
        </div>
        <div id="pduGrid"></div>
        <br>

        <div class="titArea">
            <h3>지적재산권목록</h3>
        </div>
        <div id="ptoprptGrid"></div>
        <br> -->

        <div class="titArea">
            <h3>진척도</h3>
        </div>
        <div id="tssPgsGrid"></div>

        <form id="clsForm" name="clsForm" method="post">
        <input type="hidden" id="hClsPrjCd" name="hClsPrjCd" value=""/>
        <input type="hidden" id="hfilId" name="hfilId" value=""/>
        <input type="hidden" id="hDownFilSeq" name="hDownFilSeq" value=""/>
        <input type="hidden" name=pageNum value="${input.pageNum}"/>
        <table class="table table_txt_right mt10">
            <colgroup>
                <col style="width:15%; "/>
                <col style="width:55%; "/>
                <col style="width:*; "/>
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">진척상태</th>
                    <td colspan="2">
                        <div id="pgsStatCd"></select>
                    </td>
                </tr>
                <tr>
                    <th align="right">지연내역 및<br>향후계획</th>
                    <td colspan="2" style="padding:6px;">
                        <textarea id="fnoPln"></textarea>
                    </td>
                </tr>
                <tr>
                    <th align="right">월마감내용<br>(PRJ 총괄)</th>
                    <td colspan="2" style="padding:6px;">
                        <textarea id="prjClsSbc"></textarea>
                    </td>
                </tr>
                <tr>
                    <th align="right">첨부파일</th>
                    <td>
                        <span id="spnClsFilId"></span>
                    </td>
                    <td align="center" style="width:30px ">
                        <button type="button" id="butClsAttachFileMng" name="butClsAttachFileMng">파일업로드</button>
                    </td>
                </tr>
            </tbody>
        </table>
        </form>

        <div class="titArea btn_btm2">
            <div class="LblockButton">
                <button type="button" id="butRgst" name="butRgst" >마감</button>
                <button type="button" id="butGoList" name="butGoList">목록</button>
            </div>
        </div>

    </div><!-- //sub-content -->
</div><!-- //content -->
</body>
</html>