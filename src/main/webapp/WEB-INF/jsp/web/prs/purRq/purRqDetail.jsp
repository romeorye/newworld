<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id        : purRqDetail.jsp
 * @desc    : 구매요청시스템 화면
 *------------------------------------------------------------------------
 * VER    DATE        AUTHOR        DESCRIPTION
 * ---    -----------    ----------    -----------------------------------------
 * 1.0  2018.11.22   IRIS005    최초생성
   1.1  2019.2.15   홍상의        수정
   1.2  2019.5.14   IRIS005        전체 리뉴얼
 * ---    -----------    ----------    -----------------------------------------
 * PRS 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="/iris/rui/plugins/ui/grid/LTotalSummary.js"></script>
<title><%=documentTitle%></title>
<style>
 .L-tssLable {
 border: 0px
 }
</style>

<script type="text/javascript">
    var lvAttcFilId;
    var callback;
    var openPrjSearchDialog; //프로젝트 코드 팝업 dialog
    var banfnPrs;
    var bnfpoPrs;
    var nextBnfpoPrs;
    var frm = document.aform;
    var tmpScode;
    var btnEvent;

    Rui.onReady(function() {
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        banfnPrs = '${inputData.banfnPrs}';
        bnfpoPrs = '${inputData.bnfpoPrs}';

        <%-- RESULT DATASET --%>
        resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            fields: [
                  { id: 'cmd' }       //command
                , { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });

        openPrjSearchDialog = new Rui.ui.LFrameDialog({
            id: 'openPrjSearchDialog',
            title: 'Project Code',
            width:  900,
            height: 550,
            modal: true,
            visible: false,
            buttons : [
                { text:'닫기', handler: function() {
                      this.cancel(false);
                  }
                }
            ]
        });

        openPrjSearchDialog.render(document.body);

        /* 구매요청 품목  시작  */
        prItemDataSet = new Rui.data.LJsonDataSet({
            id: 'prItemDataSet',
            remainRemoved: true,
            fields: [
                     { id : 'banfnPrs'} //구매요청번호
                    ,{ id : 'bnfpoPrs'}//구매요청순번
                    ,{ id : 'sCode' }// 품목구분
                    ,{ id : 'txz01' }// 요청품명
                    ,{ id : 'menge' }// 요청수량
                    ,{ id : 'meins' }// 단위
                    ,{ id : 'eeind' }// 납품요청일
                    ,{ id : 'werks' }// 플랜트코드
                    ,{ id : 'ekgrp' }// 구매그룹
                    ,{ id : 'preis' }// 단가
                    ,{ id : 'waers' }//통화
                    //,{ id : 'peinh' }
                    ,{ id : 'sakto' }// 계정코드
                    ,{ id : 'posid' }    // WBS코드
                    ,{ id : 'post1' }    // WBS명
                    ,{ id : 'itemTxt' }// 요청사유
                    ,{ id : 'maker' }
                    ,{ id : 'vendor' }
                    ,{ id : 'catalogno'}
                    ,{ id : 'position'}    // 납품위치
                    ,{ id : 'attcFilId'}    // 첨부파일 Id
                    ,{ id : 'gCheck'  }
                    ,{ id : 'gCheck2' }
                    ,{ id: 'sCodeNm' }     // 품목명
                    ,{ id: 'afnam' }    // 요청자명
                    ,{ id: 'bednr' }    // 요청자 사번
                    ,{ id: 'sCodeSeq' }    //
                ]
        });

        prItemDataSet.on('load', function(e) {
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            Rui.select('.tssLableCss div').removeClass('L-disabled');
        });

        /* 구매요청 리스트 품목  시작  */
        prItemListDataSet = new Rui.data.LJsonDataSet({
            id: 'prItemListDataSet',
            remainRemoved: true,
            fields: [
                  { id: 'knttp' }
                 ,{ id: 'txz01' }
                 ,{ id: 'menge' }
                 ,{ id: 'meins' }
                 ,{ id: 'eeind' }
                 ,{ id: 'totPreis'}
                 ,{ id: 'itemTxt'}
                 ,{ id : 'sCode'}
                 ,{ id : 'afnam'}
                 ,{ id : 'matkl'}
                 ,{ id : 'ekgrp'}
                 ,{ id : 'bednr'}
                 ,{ id : 'preis'}
                 ,{ id : 'waers'}
                 //,{ id : 'peinh'}
                 ,{ id : 'sakto'}
                 ,{ id : 'saktonm'}
                 ,{ id : 'itAnln1'}
                 ,{ id : 'posid'}
                 ,{ id : 'post1'}
                 ,{ id : 'itemTxt'}
                 ,{ id : 'maker'}
                 ,{ id : 'vendor'}
                 ,{ id : 'catalogno'}
                 ,{ id : 'position'}
                 ,{ id : 'usedCode'}
                 ,{ id : 'bizCd'}
                 ,{ id : 'attcFilId'}
                 ,{ id : 'banfnPrs'}
                 ,{ id : 'bnfpoPrs'}
                 ,{ id : 'sCodeSeq'}
                 ,{ id : 'totPreis'}
                 ,{ id : 'nextSeq'}
                ]
        });

        prItemListDataSet.on('load', function(e) {
            sCode.setValue('${inputData.sCodeSeq}');
            werks.setValue('${inputData.werks}');
            meins.setValue('${inputData.meins}');

            if ( prItemListDataSet.getCount() > 0 ){
                btnEvent();
            }

        });

        var itemColumnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                   { field: 'knttp',     label: '품목',         sortable: false,    align:'center',    width: 80 }
                 , { field: 'txz01',     label: '요청품명',     sortable: false,    align:'center',    width: 300 }
                 , { field: 'menge',     label: '요청수량',     sortable: false,    align:'right',    width: 90 ,
                       renderer: function(value, p, record){
                       return Rui.util.LFormat.numberFormat(parseInt(value));
                         }
                       }
                 , { field: 'meins',     label: '단위',         sortable: false,    align:'center',    width: 80 }
                 , { field: 'eeind',     label: '납품요청일', sortable: false,    align:'center',    width: 80 }
                 , { field: 'totPreis',    label: '예상단가',     sortable: false,    align:'right',    width: 80,
                       renderer: function(value, p, record){
                         return Rui.util.LFormat.numberFormat(parseInt(value));
                      }
                   }
                 , { field: 'waers',     label: '통화',         sortable: false,    align:'center',    width: 80}


                 , { field: 'itemTxt',     label: '요청사유',     sortable: false, width: 400, editor: new Rui.ui.form.LTextArea({disabled: true}),
                     renderer: function(val, p, record, row, col) {
                                 return val.replaceAll('\n', '<br/>');
                               }
                   }
                ,{ field : 'sCode', hidden: true}
                ,{ field : 'afnam', hidden: true}
                ,{ field : 'matkl', hidden: true}
                ,{ field : 'ekgrp', hidden: true}
                ,{ field : 'bednr', hidden: true}
                ,{ field : 'preis', hidden: true}
                //,{ field : 'peinh', hidden: true}
                ,{ field : 'sakto', hidden: true}
                ,{ field : 'saktonm',     hidden: true}
                ,{ field : 'itAnln1',     hidden: true}
                ,{ field : 'posid',     hidden: true}
                ,{ field : 'post1',     hidden: true}
                ,{ field : 'maker',     hidden: true}
                ,{ field : 'vendor',     hidden: true}
                ,{ field : 'catalogno', hidden: true}
                ,{ field : 'position',     hidden: true}
                ,{ field : 'usedCode',     hidden: true}
                ,{ field : 'bizCd',     hidden: true}
                ,{ field : 'attcFilId', hidden: true}
                ,{ field : 'banfnPrs',     hidden:true }
                ,{ field : 'bnfpoPrs',     hidden:true }
                ,{ field : 'sCodeSeq',     hidden:true }
            ]
        });

        var purItemGrid = new Rui.ui.grid.LGridPanel({
            columnModel: itemColumnModel,
            dataSet: prItemListDataSet,
            width: 600,
            height: 400,
            autoToEdit: false,
            autoWidth: true
        });

        purItemGrid.render('purItemGridDiv');

        // Grid Click event 처리
        purItemGrid.on('cellClick', function(e) {

            if(!e.colId == "txz01")  return;

            var record = prItemListDataSet.getAt(prItemListDataSet.getRow());

            banfnPrs = record.get("banfnPrs");
            bnfpoPrs = record.get("bnfpoPrs");

            prItemDataSet.setNameValue(0, 'banfnPrs', record.get('banfnPrs'));        //품목구분
            prItemDataSet.setNameValue(0, 'bnfpoPrs', record.get('bnfpoPrs'));        //품목구분
            prItemDataSet.setNameValue(0, 'sCode', record.get('sCodeSeq'));        //품목구분
            prItemDataSet.setNameValue(0, 'posid', record.get('posid'));        //wbs코드
            $('#post1', aform).html(record.get('post1') );                        //wbs명

            var yy = record.get('eeind').substring(0,4);
            var mm = record.get('eeind').substring(4,6);
            var dd = record.get('eeind').substring(6,8);

            prItemDataSet.setNameValue(0, 'eeind', yy+"-"+mm+"-"+dd);        //납품요청일

            position.setValue(record.get('position'));    //납품위치
            ekgrp.setValue(record.get('ekgrp'));        //구매그룹
            itemTxt.setValue(record.get('itemTxt'));    //요청사유
            txz01.setValue(record.get('txz01'));        //요청품명
            itemTxt.setValue(record.get('itemTxt'));    //요청사유
            maker.setValue(record.get('maker'));
            vendor.setValue(record.get('vendor'));
            catalogno.setValue(record.get('catalogno'));
            menge.setValue(record.get('menge'));        //요청수량
            meins.setValue(record.get('meins'));        //단위
            waers.setValue(record.get('waers'));        //통화
            preis.setValue(record.get('preis'));        //단가
            sakto.setValue( record.get('sakto'));
            saktonm.setValue(record.get('saktonm'));
            werks.setValue(record.get('werks'));        //플랜트
            //prItemDataSet.setNameValue(0, 'peinh', record.get('peinh'));
            prItemDataSet.setNameValue(0, 'attcFilId', record.get('attcFilId'));

            lvAttcFilId = record.get('attcFilId');

            if(!Rui.isEmpty(lvAttcFilId)){
                getAttachFileList();
            }

            $("#totPreis").html(   Rui.util.LNumber.toMoney(record.get('totPreis'))     );
        });

          //품목구분
        var sCode = new Rui.ui.form.LCombo({
            applyTo : 'sCode',
            width: 180,
            defaultValue: '<c:out value="${inputData.sCodeSeq}"/>',
            url: '<c:url value="/common/prsCode/retrieveItemGubunInfo.do?tabId=EM"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE'
        });

        /*품목구분관련항목*/
        var purRqScodeDataSet = new Rui.data.LJsonDataSet({
            id: 'purRqScodeDataSet',
            remainRemoved: true,
            fields: [
                  { id: 'ekgrp' }    /* 구매그룹 */
                , { id: 'sakto' }    /* 계정코드 */
                , { id: 'saktonm' } /* 계정명 */
                , { id: 'werks' }     /* 플랜트 */
            ]
        });

          //품목구분이 변경될때 관련항목을 조회하여 변경하여준다(구매그룹, 계정, 계정명)
        sCode.on('changed', function(e) {
            tmpScode = sCode.getValue();

            if( !Rui.isEmpty(sCode.getValue()) ){

                   purRqScodeDataSet.load({
                       url: '<c:url value="/common/prsCode/retrieveScodeInfo.do"/>',
                       params :{
                           sCode : escape(encodeURIComponent(sCode.getValue()))
                       }
                   });

                      purRqScodeDataSet.on('load', function(e) {
                       if(purRqScodeDataSet.getCount() > 0 ) {
                           ekgrp.setValue(purRqScodeDataSet.getNameValue(0, 'ekgrp'));
                           werks.setValue(purRqScodeDataSet.getNameValue(0, 'werks'));
                           sakto.setValue(purRqScodeDataSet.getNameValue(0, 'sakto'));
                           saktonm.setValue(purRqScodeDataSet.getNameValue(0, 'saktonm'));
                       } else {
                           sakto.setValue(purRqScodeDataSet.getNameValue(0, 'sakto'));
                           saktonm.setValue(purRqScodeDataSet.getNameValue(0, 'saktonm'));
                           return;
                       }
                     });
            }
        });

        /* 프로젝트  및 과제 코드  */
        var posid = new Rui.ui.form.LPopupTextBox({
            applyTo: 'posid',
            placeholder: 'WBS코드를 입력해주세요.',
            defaultValue: '',
            emptyValue: '',
            editable: false,
            width: 90
        });

        posid.on('popup', function(e){
            var deptYn = "N";
            prjSearchDialog(setPrsWbsCd, deptYn);
        });

        prjSearchDialog = function(f, deptYn) {
            _callback = f;
            openPrjSearchDialog.setUrl('<c:url value="/prs/purRq/retrieveSrhPrjPop.do"/>');
            openPrjSearchDialog.show();
        };

        //WBS 코드 팝업 세팅
        setPrsWbsCd = function(wbsInfo){
            posid.setValue(wbsInfo.posid);
            $('#post1', aform).html(wbsInfo.post1);
        }

        //납품요청일
        var eeind = new Rui.ui.form.LDateBox({
            applyTo: 'eeind',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue : '',        // default -1년
            width: 100,
            dateType: 'string'
        });

        eeind.on('changed', function(e) {
            var today = Rui.util.LDate.format(new Date(), '%Y-%m-%d');

            if(e.displayValue <= today && e.displayValue != '') {
                alert('납품요청일은 내일 이후부터 입력이 가능합니다.');
                eeind.setValue('');
            }
        });

        //구매요청 사유 및 세부 spec.(400자 이내)
        var itemTxt = new Rui.ui.form.LTextArea({
            applyTo: 'itemTxt',
            placeholder: '구매요청 사유 및 세부 spec.(400자 이내)',
            width: 1100,
            height: 80
        });

          //구매그룹
        var ekgrp = new Rui.ui.form.LCombo({
            applyTo: 'ekgrp',
            width: 200,
            url: '<c:url value="/common/prsCode/retrieveEkgrpInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE'
        });

        //납품위치
        var position = new Rui.ui.form.LCombo({
            applyTo : 'position',
            defaultValue: 'LG사이언스파크 E4',
            width: 180,
                        items: [
                       { code: 'LG사이언스파크 E4', value: 'LG사이언스파크 E4' } // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
                    ]
        });

          //계정
        var sakto = new Rui.ui.form.LTextBox({
            applyTo : 'sakto',
            width: 60,
            dateType: 'string',
            editable: false
        });

        sakto.on('focus', function(e) {
            sakto.blur();
            return;
        });

          //계정명
        var saktonm = new Rui.ui.form.LTextBox({
            applyTo : 'saktonm',
            width: 210,
            dateType: 'string',
            editable: false
        });

        saktonm.on('focus', function(e) {
            saktonm.blur();
            return;
        });

      //플랜트
        var werks = new Rui.ui.form.LCombo({
            applyTo: 'werks',
            width: 120,
            defaultValue: '1010',
            url: '<c:url value="/common/prsCode/retrieveWerksInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE'
        });

        //요청품명
        var txz01 = new Rui.ui.form.LTextBox({                // LTextBox개체를 선언
            applyTo: 'txz01',                               // 해당 DOM Id 위치에 텍스트박스를 적용
            width: 200,                                        // 텍스트박스 폭을 설정
            placeholder: '요청품명',                        // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
            invalidBlur: false                                // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
        });

        //메이커
        var maker = new Rui.ui.form.LTextBox({                // LTextBox개체를 선언
            applyTo: 'maker',                               // 해당 DOM Id 위치에 텍스트박스를 적용
            width: 200,                                        // 텍스트박스 폭을 설정
            placeholder: '제조업체명',                         // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
            invalidBlur: false                                // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
        });

        //벤더
        var vendor = new Rui.ui.form.LTextBox({                // LTextBox개체를 선언
            applyTo: 'vendor',                               // 해당 DOM Id 위치에 텍스트박스를 적용
            width: 200,                                        // 텍스트박스 폭을 설정
            placeholder: '공급업체명',                         // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
            invalidBlur: false                                // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
        });

        //catalog no
        var catalogno = new Rui.ui.form.LTextBox({          // LTextBox개체를 선언
            applyTo: 'catalogno',                           // 해당 DOM Id 위치에 텍스트박스를 적용
            width: 200,                                        // 텍스트박스 폭을 설정
            placeholder: '',                                 // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
            invalidBlur: false                                // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
        });

        //요청 수량
          var menge = new Rui.ui.form.LNumberBox({
            applyTo: 'menge',
            placeholder: '',
            maxValue: 9999999999,                           // 최대값 입력제한 설정
            minValue: 0,                                      // 최소값 입력제한 설정
            width: 90,
            decimalPrecision: 0                                // 소수점 자리수 3자리까지 허용
        });

          menge.on('blur', function(e) {
            setExp();
        });

          //수량 단위
        var meins = new Rui.ui.form.LCombo({
            applyTo: 'meins',
            width: 100,
            defaultValue: 'EA',
            url: '<c:url value="/common/prsCode/retrieveMeinsInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE'
        });

        //예상단가
          var preis = new Rui.ui.form.LNumberBox({
            applyTo: 'preis',
            placeholder: '',
            maxValue: 9999999999,                           // 최대값 입력제한 설정
            minValue: 0,                                      // 최소값 입력제한 설정
            width: 90,
            decimalPrecision: 0                                // 소수점 자리수 3자리까지 허용
        });

          //통화
        var waers = new Rui.ui.form.LCombo({
            applyTo: 'waers',
            width: 100,
            url: '<c:url value="/common/prsCode/retrieveWaersInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE'
        });

          preis.on('blur', function(e) {
            setExp();
        });

          // 예상금액 계산 : 요청수량 * 예산단가
        var setExp = function(){
            var p = preis.getValue();
            var m = menge.getValue();

            var tot = p*m;

            document.getElementById("totPreis").innerHTML = Rui.util.LNumber.toMoney(tot);
        };

        /*====================== 납품요청일 설명 Popup 시작 ========================== */
        /* [ 납품요청일 설명 Dialog] */
        purRqExplainDialog = new Rui.ui.LFrameDialog({
             id: 'purRqExplainDialog',
             title: '납품 요청일 도움말',
             width:  800,
             height: 350,
             modal: true,
             visible: false,
             buttons : [
                 { text:'닫기', handler: function() {
                       this.cancel(false);
                   }
                 }
             ]
        });

        purRqExplainDialog.render(document.body);

        /*[버튼] 납품요청일?*/
        var btnPopupExplain = new Rui.ui.LButton('btnPopupExplain');

        btnPopupExplain.on('click', function() {
            //납품요청일 설명 팝업창
            purRqExplainDialog.setUrl('<c:url value="/prs/popup/purRqDateExplainPop.do"/>');
            purRqExplainDialog.show(true);
        });
        /*====================== 납품요청일 설명 Popup end ================== */

        fnSearch = function() {
            dm.loadDataSet({
                dataSets: [ prItemDataSet, prItemListDataSet ],
                url: '<c:url value="/prs/purRq/retrievePurRqDetailList.do"/>' ,
                params :{
                        banfnPrs  : banfnPrs,
                        bnfpoPrs  : bnfpoPrs
                        }
            });
        }

        fnSearch();

        dm.on('success', function(e) {
            var resultData = resultDataSet.getReadData(e);

            if( resultData.records[0].rtnSt == "S"){
                alert(resultData.records[0].rtnMsg);

                banfnPrs = resultData.records[0].banfnPrs;
                $("#totPreis").html('');
                saktonm.setValue('');
                lvAttcFilId = "";
                $('#attchFileView').html('');

                fnSearch();
            }
        });

        dm.on('failure', function(e) {
            var resultData = resultDataSet.getReadData(e);
               alert(resultData.records[0].rtnMsg);
        });

        /* [버튼] 추가 시작 */
        var btnAddPurRq = new Rui.ui.LButton('btnAddPurRq');
        btnAddPurRq.on('click', function() {
            if(isValidate('추가')) {
                fncSave();
            };
        });

        fncSave = function(){
            if( prItemListDataSet.getCount() == 0  ){
                nextBnfpoPrs = 1;
            }else{
                nextBnfpoPrs = prItemListDataSet.getNameValue(0, 'nextSeq');
            }

            prItemDataSet.setNameValue(0, 'sCode', sCode.getValue() );
            prItemDataSet.setNameValue(0, 'sCodeNm', sCode.getDisplayValue() );
            prItemDataSet.setNameValue(0, 'bnfpoPrs',  nextBnfpoPrs);
            prItemDataSet.setNameValue(0, 'post1', $('#post1').html() );
            prItemDataSet.setNameValue(0, 'sCodeSeq',  sCode.getValue() );
            prItemDataSet.setNameValue(0, 'afnam',  '${inputData._userNm}');   //이름 /
            prItemDataSet.setNameValue(0, 'bednr',  '${inputData._userSabun}');   //사번

            //구매요청 Item 정보 추가
            if(confirm("추가하시겠습니까?")) {
                dm.updateDataSet({
                    url:'<c:url value="/prs/purRq/insertPurRqInfo.do"/>',
                    dataSets:[prItemDataSet],
                    modifiedOnly: false
                });
            }
        };

        /* [버튼] 삭제 시작 */
        var btnDeleteItem = new Rui.ui.LButton('btnDeleteItem');
        btnDeleteItem.on('click', function() {
            if(!Rui.isEmpty( banfnPrs ) && !Rui.isEmpty( bnfpoPrs ) ){
                fncDelete();
            }else{
                alert("삭제할 구매 건을 선택하여 주십시오");
                return;
            }
        });

        fncDelete = function(){
            //구매요청 건 삭제
            if(confirm("삭제하시겠습니까?")) {
                dm.updateDataSet({
                    url:'<c:url value="/prs/purRq/deletePurRqInfo.do"/>',
                    params :{
                            banfnPrs  : banfnPrs,
                            bnfpoPrs  : bnfpoPrs
                            }
                });
            }
        };
        /* [버튼] 삭제 끝 */

        /* [버튼] 수정 시작 */
        var btnModifyItem = new Rui.ui.LButton('btnModifyItem');
        btnModifyItem.on('click', function() {
            if(isValidate('수정')) {
                fncUpdate();
            };
        });

        fncUpdate = function(){
            prItemDataSet.setNameValue(0, 'sCodeNm', sCode.getDisplayValue() );
            prItemDataSet.setNameValue(0, 'post1', $('#post1').html() );
            prItemDataSet.setNameValue(0, 'sCodeSeq', sCode.getValue() );
            prItemDataSet.setNameValue(0, 'afnam',  '${inputData._userNm}');   //이름 /
            prItemDataSet.setNameValue(0, 'bednr',  '${inputData._userSabun}');   //사번

            //구매요청 건 수정
            if(confirm("수정하시겠습니까?")) {
                dm.updateDataSet({
                    url:'<c:url value="/prs/purRq/updatePurRqInfo.do"/>',
                    dataSets:[prItemDataSet],
                    modifiedOnly: false
                });
            }
        };

        /* [버튼] 결재의뢰 시작 */
        var btnReqApproval = new Rui.ui.LButton('btnReqApproval');
        btnReqApproval.on('click', function() {
            if(isApprovalValidate('결재의뢰')) {
                openPrsApprovalDialog(afterApproval, banfnPrs);
            };
        });

        /* 결재의뢰 유효성 검사 */
        isApprovalValidate = function(type) {
            if(prItemListDataSet.getCount() == 0) {
                alert('결재의뢰할 품목이 없습니다.');
                return false;
            }

            var flag = prItemListDataSet.getNameValue(0, 'prsFlag');
            var bnfpo = prItemListDataSet.getNameValue(0, 'bnfpo');

            if( flag == "0" && bnfpo == "0" ){
                return true;
            }else{
                alert("작성건 만 결재요청이 가능합니다.");
                return false;
            }
        };

        function afterApproval() {
                var myForm = document.aform;
             var url = "<c:url value="/prs/purRq/myPurRqList.do"/>";
             myForm.action = url;
             myForm.method = "post";
             myForm.target = "_self";
            myForm.submit();
           };


        btnEvent = function(){
            if( prItemListDataSet.getNameValue(0, 'bnfpo') == "0" && prItemListDataSet.getNameValue(0, 'prsFlag')   == "0"  ){
            }else{
                btnReqApproval.hide();
                btnModifyItem.hide();
                btnDeleteItem.hide();
                btnAddPurRq.hide();

                $("input:text").attr("disabled", "true");
                $("select").attr("disabled", "true");
                $("textarea").attr("disabled", "true");
            }
        };

        // PRS ERP결재 팝업 시작
        // banfnPrs : 구매요청번호
        _prsApprovalDialog = new Rui.ui.LFrameDialog({
            id: '_prsApprovalDialog',
            title: '결재의뢰',
            width: 700,
            height: 600,
            modal: true,
            visible: false
        });

        _prsApprovalDialog.render(document.body);

        openPrsApprovalDialog = function(f, banfnPrs) {
            _callback = f;

            _prsApprovalDialog.setUrl('<c:url value="/prs/popup/prsApprovalPopup.do?banfnPrs="/>' + banfnPrs);
            _prsApprovalDialog.show();
        };

        var vm = new Rui.validate.LValidatorManager({
            validators:[
            { id: 'sCode',        validExp: '품목구분:true' },
            { id: 'posid',        validExp: 'WBS Code:true' },
            { id: 'eeind',        validExp: '납품요청일:true' },
            { id: 'position',    validExp: '납품위치:true' },
            { id: 'ekgrp',        validExp: '구매그룹:true' },
            { id: 'sakto',        validExp: '계정:true' },
            { id: 'txz01',        validExp: '요청품명:true' },
            { id: 'menge',        validExp: '요청수량:true' },
            { id: 'meins',        validExp: '단위:true' },
            { id: 'preis',        validExp: '금액:true' },
            { id: 'waers',        validExp: '통화:true' },
            { id: 'itemTxt',    validExp: '요청사유:false:maxByteLength=1000' }
            ]
        });

        isValidate = function(type) {
            if (vm.validateGroup("aform") == false) {
                alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                return false;
            }
            return true;
        }

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
                   prItemDataSet.setNameValue(0, "attcFilId", lvAttcFilId);
            }
        };

        /*첨부파일 다운로드*/
        downloadAttachFile = function(attcFilId, seq) {
            var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
            aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
            aform.submit();
        };
        //첨부파일 끝

        var bind = new Rui.data.LBind({
             groupId: 'aform',
             dataSet: prItemDataSet,
             bind: true,
             bindInfo: [
             { id: 'sCode',         ctrlId: 'sCode',         value: 'value'     }     // 품목구분
            ,{ id: 'posid',         ctrlId: 'posid',         value: 'value'     }    // WBS코드
            ,{ id: 'eeind',         ctrlId: 'eeind',         value: 'value'     }    // 납품요청일
            ,{ id: 'position',         ctrlId: 'position',     value: 'value'     }     // 납품위치
            ,{ id: 'ekgrp',         ctrlId: 'ekgrp',         value: 'value'     }    // 구매그룹
          // ,{ id: 'sakto',         ctrlId: 'sakto',         value: 'html'     }    // 계정코드
            ,{ id: 'txz01',         ctrlId: 'txz01',         value: 'value'     }    // 요청품명
            ,{ id: 'maker',         ctrlId: 'maker',         value: 'value'     }    // Maker
            ,{ id: 'vendor',         ctrlId: 'vendor',         value: 'value'     }    // Vendor
            ,{ id: 'catalogno',     ctrlId: 'catalogno',     value: 'value'     }    // Catalog No
            ,{ id: 'werks',         ctrlId: 'werks',         value: 'value'     }    // 플랜트코드
            ,{ id: 'menge',         ctrlId: 'menge',         value: 'value'     }    // 요청수량
            ,{ id: 'meins',         ctrlId: 'meins',         value: 'value'     }    // 단위
            ,{ id: 'waers',         ctrlId: 'waers',         value: 'value'     }    // 통화
            ,{ id: 'preis',         ctrlId: 'preis',         value: 'value'     }    // 단가
            ,{ id: 'itemTxt',         ctrlId: 'itemTxt',         value: 'value'     }     // 요청사유
           // ,{ id: 'saktonm',         ctrlId: 'saktonm',         value: 'html'     }     // 계정명
             ]
        });
    });
    //end ready

</script>
</head>
<body>
<div class="contents">
    <div class="titleArea">
        <a class="leftCon" href="#">
            <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
            <span class="hidden">Toggle 버튼</span>
           </a>
        <h2>비용요청(구매) 상세내용</h2>
    </div>

<form id="aform" name ="aform" method="post">
    <input type="hidden" id="tabId" name="tabId" value="<c:out value='${inputData.tabId}'/>">
    <input type="hidden" id="rfpId" name="banfnPrs" value="<c:out value='${inputData.banfnPrs}'/>" />

    <div class="sub-content">
               <div class="titArea mt0" style="margin-bottom:5px !important;">
                   <div class="LblockButton mt0">
                       <button type="button" id="btnPopupExplain" name="btnPopupExplain" >납품요청일?</button>
                   </div>
            </div>
            <table class="table table_txt_right">
                <colgroup>
                    <col width="145px">
                    <col width="305px">
                    <col width="145px">
                    <col width="305px">
                    <col width="145px">
                    <col width="*">
                 </colgroup>
                 <tbody>
                     <tr>
                        <th><span style="color:red;">* </span>품목구분</th>
                        <td>
                            <select id="sCode" name="sCode"></select>
                        </td>
                        <th><span style="color:red;">* </span>WBS Code</th>
                        <td>
                            <input type="text" class="" id="posid" name="posid" value="" >&nbsp;<span id="post1" name="post1"></span>
                        </td>
                        <th><span style="color:red;">* </span>납품요청일</th>
                        <td>
                            <div id="eeind"/>
                        </td>
                    </tr>
                    <tr>
                        <th>성명</th>
                        <td>
                            ${inputData._userNm}
                        </td>
                        <th><span style="color:red;">* </span>납품위치</th>
                        <td>
                            <select id="position" name="position"></select>
                        </td>
                        <th><span style="color:red;">* </span>구매그룹</th>
                        <td>
                            <select id="ekgrp" name="ekgrp"></select>
                        </td>
                    </tr>
                     <tr>
                         <th>요청사유 및 세부스펙<br/>(400자 이내)</th>
                        <td colspan="5">
                            <textarea id="itemTxt" name="itemTxt"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>계정</th>
                        <td class="tssLableCss">
                            <input type="text" id="sakto" name="sakto"/> / <input type="text" id="saktonm" name="saktonm"/>
                        </td>
                        <th align="right">첨부파일</th>
                        <td colspan="2" id="attchFileView">&nbsp;</td>
                        <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prsPolicy', '*')">첨부파일등록</button></td>
                    </tr>
                     <tr>
                        <th><span style="color:red;">* </span>요청품명</th>
                        <td>
                            <input type="text" id="txz01" name="txz01" />
                        </td>
                        <th>Maker</th>
                        <td>
                            <input type="text" id="maker" name="maker" maxlength="35" /> (35자 이내)
                        </td>
                        <th>Vendor</th>
                        <td>
                            <input type="text" id="vendor" name="vendor" maxlength="35" /> (35자 이내)
                        </td>
                    </tr>
                    <tr>
                        <th>Catalog No.</th>
                        <td>
                            <input type="text" id="catalogno" name="catalogno" maxlength="15" /> (15자 이내)
                        </td>
                        <th>플랜트</th>
                        <td>
                            <select id="werks" name="werks"></select>
                        </td>
                        <th>사용용도</th>
                        <td>
                            실험용
                        </td>
                    </tr>
                    <tr>
                        <th><span style="color:red;">* </span>요청 수량</th>
                        <td>
                            <input type="text" id="menge" name="menge" /><select id="meins" name="meins"></select>
                        </td>
                        <th><span style="color:red;">* </span>예상단가</th>
                        <td>
                            <input type="text" id="preis" name="preis" /><select id="waers" name="waers"></select>
                        </td>
                        <th>예상 금액</th>
                        <td>
                            <span id="totPreis"></span>
                        </td>
                    </tr>
                </tbody>

            </table>
</form>
        <div class="titArea">
            <span class="Ltotal" id="cnt_text">총 : 0건 </span>
            <div class="LblockButton">
                <button type="button" id="btnReqApproval" name="btnReqApproval" class="redBtn">결재의뢰</button>
                <button type="button" id="btnDeleteItem" name="btnDeleteItem" >삭제</button>
                <button type="button" id="btnModifyItem" name="btnModifyItem" >수정</button>
                <button type="button" id="btnAddPurRq" name="btnAddPurRq" class="redBtn">추가</button>
            </div>
        </div>

       <div id="purItemGridDiv"></div>

    </div> <!-- //sub-content -->
</div> <!-- //contents -->


</body>
</html>