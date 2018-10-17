<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssPgsCrdDtlPop.jsp
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
        //성명
        saUserName = new Rui.ui.form.LPopupTextBox({
            applyTo: 'saUserName',
            width: 120,
            editable: false,
            enterToPopup: true
        });
        saUserName.on('popup', function(e) {
            parent.openSaUser();
        });
        
        //직급
        saJobxName = new Rui.ui.form.LTextBox({
            applyTo: 'saJobxName',
            editable: false,
            width: 120
        });
        
        //반납일
        rtrnDt = new Rui.ui.form.LDateBox({
            applyTo: 'rtrnDt',
            mask: '9999-99-99',
            width: 100,
            listPosition: 'down',
            dateType: 'string'
        });
        
        //카드사
        cdcdNm = new Rui.ui.form.LTextBox({
            applyTo: 'cdcdNm',
            width: 120
        });
        
        //카드번호1
        cdcdNo1 = new Rui.ui.form.LTextBox({
            applyTo: 'cdcdNo1',
            mask:'9999',
            maskPlaceholder:'',
            width: 50
        });
        
        //카드번호2
        cdcdNo2 = new Rui.ui.form.LTextBox({
            applyTo: 'cdcdNo2',
            mask:'9999',
            maskPlaceholder:'',
            type: 'password',
            width: 70
        });
        
        //카드번호3
        cdcdNo3 = new Rui.ui.form.LTextBox({
            applyTo: 'cdcdNo3',
            mask:'9999',
            maskPlaceholder:'',
            type: 'password',
            width: 70
        });
        
        //카드번호4
        cdcdNo4 = new Rui.ui.form.LTextBox({
            applyTo: 'cdcdNo4',
            mask:'9999',
            maskPlaceholder:'',
            width: 50
        });
        
        //발급년월
        iYymm = new Rui.ui.form.LMonthBox({
            applyTo: 'iYymm',
            mask: '9999-99',
            displayValue: '%Y-%m',
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
        
        //비고
        remTxt = new Rui.ui.form.LTextArea({
            applyTo: 'remTxt',
            height: 100,
            width: 350
        });
        
        //Form 비활성화
        disableFields = function() {
            document.getElementById('saJobxName').style.border = 0;
        }
        
        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //dataSet 
        dataSet = new Rui.data.LJsonDataSet({
            id: 'crdDataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id: 'tssCd' }          //과제코드 
                , { id: 'userId' }         //사용자ID
                , { id: 'rsstExpCdcdSn', type: 'number', defaultValue:0 }  //연구비카드일련번호
                , { id: 'saSabunNew' }     //사번
                , { id: 'deptCode' }       //소속
                , { id: 'saFunc' }         //직급
                , { id: 'rtrnDt' }         //반납일
                , { id: 'cdcdNm' }         //카드사
                , { id: 'cdcdNo' }         //카드번호
                , { id: 'cdcdNo1' }        //카드번호1
                , { id: 'cdcdNo2' }        //카드번호2
                , { id: 'cdcdNo3' }        //카드번호3
                , { id: 'cdcdNo4' }        //카드번호4
                , { id: 'iYymm' }          //발급년월
                , { id: 'ivstAmt', type: 'number', defaultValue:0 }        //투자금액
                , { id: 'remTxt' }         //비고
                , { id: 'saUserName' }     //사용자명
                , { id: 'saJobxName' }     //직급
            ]                         
        });
        dataSet.on('load', function(e) {
            console.log("crd load dataSet Success");
        });
        
        
        //Form 바인드
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'saUserName', ctrlId: 'saUserName', value: 'value' }
                , { id: 'saJobxName', ctrlId: 'saJobxName', value: 'value' }
                , { id: 'rtrnDt',     ctrlId: 'rtrnDt',     value: 'value' }
                , { id: 'cdcdNm',     ctrlId: 'cdcdNm',     value: 'value' }
                , { id: 'cdcdNo1',    ctrlId: 'cdcdNo1',    value: 'value' }
                , { id: 'cdcdNo2',    ctrlId: 'cdcdNo2',    value: 'value' }
                , { id: 'cdcdNo3',    ctrlId: 'cdcdNo3',    value: 'value' }
                , { id: 'cdcdNo4',    ctrlId: 'cdcdNo4',    value: 'value' }
                , { id: 'iYymm',      ctrlId: 'iYymm',      value: 'value' }
                , { id: 'ivstAmt',    ctrlId: 'ivstAmt',    value: 'value' }
                , { id: 'remTxt',     ctrlId: 'remTxt',     value: 'value' } 
            ]
        });
        
        
        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            if(data.records[0].rtCd == "SUCCESS") {
                parent.fnSearch();
                parent.crdNewDialog.cancel(true);
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });
        
        
        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [  
                  { id: 'tssCd',             validExp: '과제코드:false' }
                , { id: 'userId',            validExp: '사용자ID:false' }
                , { id: 'rsstExpCdcdSn',     validExp: '연구비카드일련번호:false' }
                , { id: 'saSabunNew',        validExp: '사번:false' }
                , { id: 'deptCode',          validExp: '소속:false' }
                , { id: 'saFunc',            validExp: '직급:false' }
                , { id: 'rtrnDt',            validExp: '반납일:false' }
                , { id: 'cdcdNm',            validExp: '카드사:false:maxLength=100' }
                , { id: 'cdcdNo',            validExp: '카드번호:false' }
                , { id: 'cdcdNo1',           validExp: '카드번호1:false' }
                , { id: 'cdcdNo2',           validExp: '카드번호2:false' }
                , { id: 'cdcdNo3',           validExp: '카드번호3:false' }
                , { id: 'cdcdNo4',           validExp: '카드번호4:false' }
                , { id: 'iYymm',             validExp: '발급년월:false' }
                , { id: 'ivstAmt',           validExp: '투자금액:false' }
                , { id: 'remTxt',            validExp: '비고:false' }
                , { id: 'saUserName',        validExp: '사용자명:true' }
                , { id: 'saJobxName',        validExp: '직급:false' }
            ]
        });
        
        
        
        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //저장
        fnSave = function() {
            if(!dataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }
            
            if(!vm.validateGroup("crdDtForm")) {                    
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return;
            }
            
            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    dataSet.setNameValue(0, "tssCd",  lvTssCd);
                    dataSet.setNameValue(0, "userId", lvUserId);
                    dataSet.setNameValue(0, "cdcdNo", cdcdNo1.getValue().toString() + "-" + cdcdNo2.getValue().toString() + "-" 
                            + cdcdNo3.getValue().toString() + "-" + cdcdNo4.getValue().toString());
                    
                    dm.updateDataSet({
                        url:'<c:url value="/prj/tss/nat/updateNatTssPgsCrd.do"/>',
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
                        url:'<c:url value="/prj/tss/nat/deleteNatTssPgsCrd.do"/>',
                        dataSets:[dataSet]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        }
        
        // 최초 데이터 셋팅 
        if(${resultCnt} > 0) { 
            console.log("crd searchData1");
            dataSet.loadData(${result}); 
        } else {
            dataSet.newRecord();
        }
        
        disableFields();
    });
</script>
<script type="text/javascript">
//과제리더 팝업 셋팅
function setLeaderInfo(userInfo) {
    dataSet.setNameValue(0, "saSabunNew", userInfo.saSabun);
    dataSet.setNameValue(0, "saUserName", userInfo.saName);
    dataSet.setNameValue(0, "saJobxName", userInfo.saJobxName);
}
</script>
</head>
<body>
<div id="aFormDiv">
    <form name="crdDtForm" id="crdDtForm" method="post" style="padding: 20px 1px 0px 0;">
        <div class="LblockMainBody" style="margin-top:-25px;">
	        <table class="table table_txt_right">
	            <colgroup>
	                <col style="width: 120px;" />
	                <col style="width: *" />
	                <col style="width: 120px;" />
	                <col style="width: *" />
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th align="right">성명</th>
	                    <td><input type="text" id="saUserName"></td>
	                    <th align="right">직급</th>
	                    <td><input type="text" id="saJobxName"></td>
	                </tr>
	                <tr>
	                    <th align="right">반납일</th>
	                    <td><input type="text" id="rtrnDt"></td>
	                    <th align="right">카드사</th>
	                    <td><input type="text" id="cdcdNm"></td>
	                </tr>
	                <tr>
	                    <th align="right">카드번호</th>
	                    <td colspan="3">
	                        <input type="text" id="cdcdNo1">
	                        <input type="text" id="cdcdNo2">
	                        <input type="text" id="cdcdNo3">
	                        <input type="text" id="cdcdNo4">
	                    </td>
	                </tr>
	                <tr>
	                    <th align="right">발급년월</th>
	                    <td><input type="text" id="iYymm"></td>
	                    <th align="right">투자금액</th>
	                    <td><input type="text" id="ivstAmt"></td>
	                </tr>
	                <tr>
	                    <th align="right">비고</th>
	                    <td colspan="3"><input type="text" id="remTxt"></td>
	                </tr>
	            </tbody>
	        </table>
        </div>
    </form>
</div>
</body>
</html>