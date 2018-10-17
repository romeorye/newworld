<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssPgsIvstDtlPop.jsp
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
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var lvTssCd  = window.parent.lvTssCd;
    var lvUserId = window.parent.lvUserId;
    var lvPgsCd  = window.parent.lvMstPgsCd; //진행코드
    var lvTssSt  = window.parent.lvMstTssSt; //과제상태
    var pageMode = window.parent.pageMode;
    
    var lvAttcFilId;
    var dataSet;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //자산번호
        asstNo = new Rui.ui.form.LTextBox({
            applyTo: 'asstNo',
            width: 120
        });
        
        //구입시기(년차)
        purEra = new Rui.ui.form.LTextBox({
            applyTo: 'purEra',
            width: 120
        });
        
        //자산명
        asstNm = new Rui.ui.form.LTextBox({
            applyTo: 'asstNm',
            width: 370
        });
        
        //수량
        qty = new Rui.ui.form.LNumberBox({
            applyTo: 'qty',
            decimalPrecision: 0,
            maxValue: 99,
            width: 120
        });
        
        //단위
        utm = new Rui.ui.form.LTextBox({
            applyTo: 'utm',
            width: 120
        });
        
        //취득일
        obtDt = new Rui.ui.form.LDateBox({
            applyTo: 'obtDt',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        
        //투자금액
        ivstAmt = new Rui.ui.form.LNumberBox({
            applyTo: 'ivstAmt',
            decimalPrecision: 0,
            maxValue: 999999999999999,
            width: 120
        });
        ivstAmt.on('changed', function() {
            fnGetSubAmt();
        });
        
        //취득가액
        obtAmt = new Rui.ui.form.LNumberBox({
            applyTo: 'obtAmt',
            decimalPrecision: 0,
            maxValue: 999999999999999,
            width: 120
        });
        obtAmt.on('changed', function() {
            fnGetSubAmt();
        });
        
        //차감금액
        subAmt = new Rui.ui.form.LNumberBox({
            applyTo: 'subAmt',
            editable: false,
            width: 120
        });
        
        //Form 비활성화
        disableFields = function() {
            document.getElementById('subAmt').style.border = 0;
            
            if(pageMode == "R") {
	            document.getElementById('attchFileMngBtn').style.display = "none";
            }
            
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            Rui.select('.tssLableCss div').removeClass('L-disabled');
        }
        
        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //dataSet 
        dataSet = new Rui.data.LJsonDataSet({
            id: 'ivstDataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id:'tssCd' }      //과제코드 
                , { id:'userId' }     //사용자ID
                , { id:'ivstIgSn' }   //투자품목일련번호    
                , { id:'asstNo' }     //자산번호    
                , { id:'purEra' }     //구입시기(년차) 
                , { id:'asstNm' }     //자산명 
                , { id:'qty', type: 'number', defaultValue:0 }        //수량 
                , { id:'utm' }        //단위 
                , { id:'obtDt' }      //취득일 
                , { id:'ivstAmt', type: 'number', defaultValue:0 }    //투자금액     
                , { id:'obtAmt', type: 'number', defaultValue:0 }     //취득가액 
                , { id:'subAmt', type: 'number', defaultValue:0 }     //차감금액 
                , { id:'attcFilId' }  //첨부파일 
            ]                         
        });
        dataSet.on('load', function(e) {
            console.log("ivst load dataSet Success");
            
            
            lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "attcFilId"));
            if(stringNullChk(lvAttcFilId) != "") getAttachFileList();
        });
        
        
        //Form 바인드
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'asstNo',  ctrlId: 'asstNo',  value: 'value' }
                , { id: 'purEra',  ctrlId: 'purEra',  value: 'value' }
                , { id: 'asstNm',  ctrlId: 'asstNm',  value: 'value' }
                , { id: 'qty',     ctrlId: 'qty',     value: 'value' }
                , { id: 'utm',     ctrlId: 'utm',     value: 'value' }
                , { id: 'obtDt',   ctrlId: 'obtDt',   value: 'value' }
                , { id: 'ivstAmt', ctrlId: 'ivstAmt', value: 'value' }
                , { id: 'obtAmt',  ctrlId: 'obtAmt',  value: 'value' }
                , { id: 'subAmt',  ctrlId: 'subAmt',  value: 'value' }
            ]
        });
        
        
        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            if(data.records[0].rtCd == "SUCCESS") {
                parent.fnSearch();
                parent.ivstNewDialog.cancel(true);
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });
        
        
        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [  
                  { id:'tssCd',      validExp: '과제코드:false' }
                , { id:'userId',     validExp: '사용자ID:false' }
                , { id:'ivstIgSn',   validExp: '투자품목일련번호:false' }
                , { id:'asstNo',     validExp: '자산번호:true:maxLength=100' }
                , { id:'purEra',     validExp: '구입시기(년차):false:maxLength=100' }
                , { id:'asstNm',     validExp: '자산명:false:maxLength=1000' }
                , { id:'qty',        validExp: '수량:false' }
                , { id:'utm',        validExp: '단위:false:maxLength=100' }
                , { id:'obtDt',      validExp: '취득일:false' }
                , { id:'ivstAmt',    validExp: '투자금액:false' }
                , { id:'obtAmt',     validExp: '취득가액:false' }
                , { id:'subAmt',     validExp: '차감금액:false' }
                , { id:'attcFilId',  validExp: '첨부파일:false' }
            ]
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
        
        //첨부파일 목록 조회
        getAttachFileList = function() {
            attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                    attcFilId : lvAttcFilId
                }
            });
        };
        
        //첨부파일DS List형식으로 변환
        getAttachFileInfoList = function() {
            var attachFileInfoList = [];
            
            for(var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }
            
            setAttachFileInfo(attachFileInfoList);
        };
        
        //첨부파일 Key값 반환
        getAttachFileId = function() {
            return stringNullChk(lvAttcFilId);
        };
        
        //첨부파일 목록 화면에 만들기
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
                dataSet.setNameValue(0, "attcFilId", lvAttcFilId);
            }
        };
        
        //첨부파일 다운로드
        downloadAttachFile = function(attcFilId, seq) {
            ivstDtForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            ivstDtForm.submit();
        };
        
        //저장
        fnSave = function() {
            if(!dataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }
            
            if(!vm.validateGroup("ivstDtForm")) {                    
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return;
            }
            
            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    
                    dataSet.setNameValue(0, "tssCd", lvTssCd);
                    dataSet.setNameValue(0, "userId", lvUserId);
                    
                    dm.updateDataSet({
                        url:'<c:url value="/prj/tss/nat/updateNatTssPgsIvst.do"/>',
                        dataSets:[dataSet]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        }
        
        //삭제 
        fnDelete = function() {
            Rui.confirm({
                text: '삭제하시겠습니까?',
                handlerYes: function() {
                    dataSet.setState(0, Rui.data.LRecord.STATE_DELETE);
                    
                    dm.updateDataSet({
                        url:'<c:url value="/prj/tss/nat/deleteNatTssPgsIvst.do"/>',
                        dataSets:[dataSet]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        }
        
        // 최초 데이터 셋팅 
        if(${resultCnt} > 0) { 
            console.log("ivst searchData1");
            dataSet.loadData(${result}); 
        } else {
            dataSet.newRecord();
        }
        
        
        disableFields();
    });
    
    //차감금액 구하기
    function fnGetSubAmt() {
        var iAmt = ivstAmt.getValue();
        var oAmt = obtAmt.getValue();
        
        subAmt.setValue(iAmt - oAmt);
    }
</script>
</head>
<body>
<div id="aFormDiv">
    <form name="ivstDtForm" id="ivstDtForm" method="post" style="padding:0 1px 0px 0;">
        <div class="LblockMainBody">
	        <table class="table table_txt_right">
	            <colgroup>
	                <col style="width: 120px;" />
	                <col style="width: *" />
	                <col style="width: 120px;" />
	                <col style="width: *" />
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th align="right">자산번호</th>
	                    <td><input type="text" id="asstNo"></td>
	                    <th align="right">구입시기(년차)</th>
	                    <td><input type="text" id="purEra"></td>
	                </tr>
	                <tr>
	                    <th align="right">자산명</th>
	                    <td colspan="3"><input type="text" id="asstNm"></td>
	                </tr>
	                <tr>
	                    <th align="right">수량</th>
	                    <td><input type="text" id="qty"></td>
	                    <th align="right">단위</th>
	                    <td><input type="text" id="utm"></td>
	                </tr>
	                <tr>
	                    <th align="right">취득일</th>
	                    <td><input type="text" id="obtDt"></td>
	                    <th align="right">투자금액</th>
	                    <td><input type="text" id="ivstAmt"></td>
	                </tr>
	                <tr>
	                    <th align="right">취득가액</th>
	                    <td><input type="text" id="obtAmt"></td>
	                    <th align="right">차감금액</th>
	                    <td><input type="text" id="subAmt"></td>
	                </tr>
	                <tr>
	                    <th align="right">첨부파일</th>
	                    <td colspan="2" id="attchFileView">&nbsp;</td>
	                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="window.parent.openIvstAttcDialog()">파일등록</button></td>
	                </tr>
	            </tbody>
	        </table>
        </div>
    </form>
</div>
</body>
</html>