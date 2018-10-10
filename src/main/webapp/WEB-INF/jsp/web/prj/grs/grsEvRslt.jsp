<%@ page language="java" pageEncoding="utf-8"
    contentType="text/html; charset=utf-8"%>
<%@ page
    import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ page import="iris.web.prj.tss.tctm.TctmUrl" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : grsEvRslt.jsp
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<%
    response.setHeader("Pragma", "No-cache");
			response.setDateHeader("Expires", 0);
			response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">
    var gvTssCd  = "";
    var gvUserId = "${inputData._userId}"; 
    var gvTssSt  = ""; 
    var lvGrsEvSt;
    var lvPgsStepCd;
    var lvTssAttrCd;
    var lvTssScnCd;
    var lvItgSrch;
    var dataSet;
    var cboGrsEvSt;

    Rui.onReady(function() {
        var isInsert = false;
        var form = new Rui.ui.form.LForm('mstForm');
        
        /* [입력폼] */
        //프로젝트명
        prjNm = new Rui.ui.form.LTextBox({
            applyTo: 'prjNm',
            editable: false,
            width: 300
        });
        
        //과제유형
        bizDptNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizDptNm',
            editable: false,
            width: 300
        });
        
        //과제속성
        tssAttrCd = new Rui.ui.form.LCombo({
            applyTo: 'tssAttrCd',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_ATTR_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        
        //과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            editable: false,
            width: 300
        });
        
        //심의단계
        cboGrsEvSt = new Rui.ui.form.LCombo({
            applyTo: 'grsEvSt',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=GRS_EV_ST"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 100
        });
        cboGrsEvSt.on('blur', function(e) {
            //진행중일때 초기상태 선택 불가
            if(lvPgsStepCd == "PG" && cboGrsEvSt.getValue() == "P1") {
                Rui.alert("진행중일때 초기 단계는 선택 불가입니다.");
                cboGrsEvSt.setValue("");
                return;
            }

            if(lvTssScnCd=="D" && cboGrsEvSt.getValue() == "M") {
                Rui.alert("기술팀과제는  변경GRS는 선택 불가입니다.");
                cboGrsEvSt.setValue("");
                return;
            }
            return;
        });
        
        //평가표
        grsEvSnNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'grsEvSnNm',
            width: 300,
            editable: false,
            placeholder: '',
            emptyValue: '',
            enterToPopup: true
        });
        grsEvSnNm.on('popup', function(e){
            openGrsEvSnDialog();
        });
        
        //심의예정일
        dlbrParrDt = new Rui.ui.form.LDateBox({
            applyTo: 'dlbrParrDt',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        
        //심의담당자
        dlbrCrgrNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'dlbrCrgrNm',
            width: 100,
            editable: false,
            placeholder: '',
            emptyValue: '',
            enterToPopup: true
        });
        dlbrCrgrNm.on('popup', function(e){
            openGrsUserSearchDialog(setUserInfo, 1, ''); //심의담당자
        });
        
        
        openGrsUserSearchDialog = function(f,  userIds) {
            _callback = f;
            _userSearchDialog.setUrl('<c:url value="/com/tss/grsUserSearchPopup.do?cnt=1&userIds="/>');
            _userSearchDialog.show();
        };
        
        //Form 비활성화 여부
        disableFields = function() {
            //PL:계획
            if(lvPgsStepCd == "PL" || lvPgsStepCd == "CM") {
                cboGrsEvSt.disable();
                
                document.getElementById('grsEvSt').style.border = 0;
            }
        
            prjNm.setEditable(false);
            bizDptNm.setEditable(false);
            tssAttrCd.disable();
            tssNm.setEditable(false);

            document.getElementById('prjNm').style.border = 0;
            document.getElementById('bizDptNm').style.border = 0;
            document.getElementById('tssAttrCd').style.border = 0;
            document.getElementById('tssNm').style.border = 0;
            
            Rui.select('.tssLableCss div').removeClass('L-disabled');
            
            //제목설정
            var pTitle;
            if(lvTssScnCd == "G") pTitle = "일반과제 >> ";
            else if(lvTssScnCd == "N") pTitle = "국책과제 >> ";
            else if(lvTssScnCd == "O") pTitle = "대외협력과제 >> ";
            else if(lvTssScnCd == "D") pTitle = "기술팀과제 >> ";

            var pStep;
            if(lvPgsStepCd == "PL") pStep = "계획";
            else if(lvPgsStepCd == "PG") pStep = "진행";
            else if(lvPgsStepCd == "AL") pStep = "변경";
            else if(lvPgsStepCd == "CM") pStep = "완료";
            else if(lvPgsStepCd == "DC") pStep = "중단";
            
            document.getElementById('bodyTitle').innerHTML = pTitle + pStep + " >> GRS요청";
            
            if(lvItgSrch == "Y") {
                $(".titArea").hide();
                $(".titleArea").hide();

                dlbrParrDt.setEditable(false);
                cboGrsEvSt.disable();
                
                document.getElementById('bodyTitle').innerHTML = "";
                document.getElementById('grsEvSt').style.border = 0;
                
                $('#grsEvSnNm').attr('style', "border-color:white;");
                $('#grsEvSnNm > a').attr('style', "display:none;");
                $('#dlbrParrDt').attr('style', "border-color:white;");
                $('#dlbrParrDt > a').attr('style', "display:none;");
                $('#dlbrCrgrNm').attr('style', "border-color:white;");
                $('#dlbrCrgrNm > a').attr('style', "display:none;");
            }
        }
        
        
        /* [DataSet] 설정 */
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }         //과제코드
                , { id: 'userId' }        //로그인ID
                , { id: 'prjCd' }         //프로젝트코드
                , { id: 'prjNm' }         //프로젝트명
                , { id: 'bizDptCd' }      //과제유형코드
                , { id: 'bizDptNm' }      //과제유형명
                , { id: 'tssAttrCd' }     //과제속성코드
                , { id: 'tssNm' }         //과제명
                , { id: 'grsEvSt' }       //GRS상태
                , { id: 'grsEvSn' }       //GRS평가표
                , { id: 'grsEvSnNm' }     //GRS평가표명
                , { id: 'dlbrParrDt' }    //심의예정일
                , { id: 'dlbrCrgr' }      //심의담당자
                , { id: 'dlbrCrgrNm' }    //심의담당자명
                , { id: 'dlbrCrgrId' }    //심의담당자명
                , { id: 'pgsStepCd' }     //진행단계코드
                , { id: 'tssScnCd' }      //과제구분코드
                , { id: 'tssSt' }         //과제상태코드
                , { id: 'tssCdSn' }
                , { id: 'reqSabun' }      //요청자사번
                , { id: 'mailTitl' }      //
                , { id: 'phNm' }      //
                , { id: 'itgSrch' }       //
                , { id: 'attcFilId' }     //
            ]
        });
        dataSet.on('load', function(e) {
            gvTssCd = dataSet.getNameValue(0, "tssCd");
            lvPgsStepCd = dataSet.getNameValue(0, "pgsStepCd"); //진행단계
            lvTssScnCd  = dataSet.getNameValue(0, "tssScnCd");
            lvItgSrch   = dataSet.getNameValue(0, "itgSrch");
            
            //과제속성
            lvTssAttrCd = stringNullChk(dataSet.getNameValue(0, "tssAttrCd"));
            lvTssAttrCd = lvTssAttrCd == "" ? "01" : lvTssAttrCd;
            tssAttrCd.setValue(lvTssAttrCd);
            dataSet.setNameValue(0, "tssAttrCd", lvTssAttrCd);
            
            //심의단계
            lvGrsEvSt = dataSet.getNameValue(0, "grsEvSt");
            if(stringNullChk(lvGrsEvSt) == "") {
                if(lvPgsStepCd == "PL") lvGrsEvSt = "P1";     //PL:계획, P1:초기
                else if(lvPgsStepCd == "CM") lvGrsEvSt = "P2"; //CM:종료
            }
            cboGrsEvSt.setValue(lvGrsEvSt);
            dataSet.setNameValue(0, "grsEvSt", lvGrsEvSt);
            
            //진행단계에 따른 form 활성화
            disableFields();
            
            if(lvItgSrch == "Y") getAttachFileList();
        });
        
        
        /* [DataSet] 유효성 설정 */
        var vm = new Rui.validate.LValidatorManager({
            validators: [  
                  { id: 'grsEvSnNm',  validExp: '평가표:true' }
                , { id: 'dlbrParrDt', validExp: '심의예정일:true' }
                , { id: 'dlbrCrgrNm', validExp: '심의담당자:true' }
                , { id: 'grsEvSt',    validExp: '심의단계:true' }
            ]
        });
        
        
        /* [DataSet] 폼에 출력 */
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',      ctrlId: 'tssCd',      value: 'value' }
                , { id: 'prjNm',      ctrlId: 'prjNm',      value: 'value' }
                , { id: 'bizDptNm',   ctrlId: 'bizDptNm',   value: 'value' }
                , { id: 'tssAttrCd',  ctrlId: 'tssAttrCd',  value: 'value' }
                , { id: 'tssNm',      ctrlId: 'tssNm',      value: 'value' }
                , { id: 'grsEvSt',    ctrlId: 'grsEvSt',    value: 'value' }
                , { id: 'grsEvSnNm',  ctrlId: 'grsEvSnNm',  value: 'value' }
                , { id: 'dlbrParrDt', ctrlId: 'dlbrParrDt', value: 'value' }
                , { id: 'dlbrCrgrNm', ctrlId: 'dlbrCrgrNm', value: 'value' }
            ]
        });
        
        /* [DataSet] 서버전송용 */
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            Rui.alert(data.records[0].rtVal);

            if(data.records[0].rtCd == "FAIL") {
                dataSet.setState(0, 1);
            } 
            else {
                dataSet.setNameValue(0, "tssCdSn", data.records[0].tssCdSn);
                btnList.click();
            }
        });

        //팝업: 평가표
        grsEvSnDialog = new Rui.ui.LFrameDialog({
            id: 'grsEvSnDialog', 
            title: 'GRS 평가항목선택',
            width: 800,
            height: 500,
            modal: true,
            visible: false
        });
        
        grsEvSnDialog.render(document.body);
    
        openGrsEvSnDialog = function() {
            grsEvSnDialog.setUrl('<c:url value="/prj/grs/grsEvStdPop.do?tssCd="/>' + gvTssCd + '&userId=' + gvUserId);
            grsEvSnDialog.show();
        };
        
        //팝업: 상세내용
        grsEvDtlDialog = new Rui.ui.LFrameDialog({
            id: 'grsEvSnDialog', 
            title: 'GRS 평가항목',
            width: 1200,
            height: 430,
            modal: true,
            visible: false
        });
        
        grsEvDtlDialog.render(document.body);
    
        openGrsEvDtlDialog = function(grsEvSn) {
            grsEvDtlDialog.setUrl('<c:url value="/prj/grs/grsEvStdDtlPop.do?grsEvSn="/>' + grsEvSn);
            grsEvDtlDialog.show();
        };
        
        //기능: 평가의뢰
        var btnEvAsk = new Rui.ui.LButton('btnEvAsk');
       
        btnEvAsk.on('click', function() {       
            if(!vm.validateGroup("mstForm")) {            
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return;
            }
            
            Rui.confirm({
                text: '평가의뢰 하시겠습니까?',
                handlerYes: function() {
                    dataSet.setNameValue(0, "userId",   gvUserId);
                    dataSet.setNameValue(0, "tssSt",    "101"); //101:GRS요청
                    dataSet.setNameValue(0, "reqSabun", "${inputData._userSabun}"); //요청자사번
		            dataSet.setNameValue(0, 'mailTitl', "IRIS GRS심의 요청메일입니다");
		            dataSet.setNameValue(0, 'phNm', cboGrsEvSt.getDisplayValue() );
                    
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/grs/updateGrsEvRslt.do"/>',
                        dataSets:[dataSet]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        });
        
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
                    attcFilId : dataSet.getNameValue(0, "attcFilId")
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
        };

        downloadAttachFile = function(attcFilId, seq) {
            mstForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            mstForm.submit();
        };
        
        
        //기능: 목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function () {
            //일반과제
            if (lvTssScnCd == "G") {
                nwinsActSubmit(window.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
            } else if (lvTssScnCd == "N") {
                //국책과제
                nwinsActSubmit(window.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
            } else if (lvTssScnCd == "O") {
                //대외협력과제
                nwinsActSubmit(window.document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
            } else if (lvTssScnCd == "D") {
                // 기술팀 과제
                nwinsActSubmit(window.document.mstForm, "<%=request.getContextPath()+TctmUrl.doList%>");
            }
        });
        
        dataSet.loadData(${result});
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnEvAsk").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnEvAsk").hide();
		}
    });
</script>
<script type="text/javascript">
//평가표 팝업 셋팅
function setGrsEvSnInfo(grsInfo) {
    dataSet.setNameValue(0, "grsEvSn", grsInfo.grsEvSn);   //평가표코드
    dataSet.setNameValue(0, "grsEvSnNm", grsInfo.evSbcNm); //평가명
}
//심의담당자 팝업 셋팅
function setUserInfo(userInfo) {
    dataSet.setNameValue(0, "dlbrCrgr", userInfo.saSabun);  //담당자사번
    dataSet.setNameValue(0, "dlbrCrgrId", userInfo.saUser);  //담당자id
    dataSet.setNameValue(0, "dlbrCrgrNm", userInfo.saName); //담당자명
}
</script>

</head>
<body>
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
	    <div class="titleArea">
	    	<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>  
	        <h2 id="bodyTitle"></h2>
	    </div>

        <div class="sub-content">
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
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
                                    <td><input type="text"
                                        id="prjNm" /></td>
                                    <th align="right">과제유형</th>
                                    <td><input type="text"
                                        id="bizDptNm" /></td>
                                </tr>
                                <tr>
                                    <th align="right">과제속성</th>
                                    <td class="tssLableCss">
                                        <div id="tssAttrCd"></div>
                                    </td>
                                    <th align="right">과제명</th>
                                    <td><input type="text"
                                        id="tssNm" /></td>
                                </tr>
                                <tr>
                                    <th align="right">심의단계</th>
                                    <td class="tssLableCss">
                                        <div id="grsEvSt"></div>
                                    </td>
                                    <th align="right">평가표</th>
                                    <td><input type="text"
                                        id="grsEvSnNm" /></td>
                                </tr>
                                <tr>
                                    <th align="right">심의예정일</th>
                                    <td><input type="text"
                                        id="dlbrParrDt" /></td>
                                    <th align="right">심의담당자</th>
                                    <td><input type="text"
                                        id="dlbrCrgrNm" /></td>
                                </tr>
                                <c:choose>  
                                    <c:when test="${itgSrch eq 'Y'}">
		                                <tr>
		                                    <th align="right">첨부파일</th>
		                                    <td colspan="3" id="attchFileView">&nbsp;</td>
		                                </tr>
                                    </c:when>
                                </c:choose>
                            </tbody>
                        </table>
                    </fieldset>
                </form>
            </div>
            <div class="titArea">
                <div class="LblockButton">
                    <button type="button" id="btnEvAsk" name="btnEvAsk">평가의뢰</button>
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>