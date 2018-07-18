<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      :natTssStoaIfm.jsp
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

<style>
 .L-tssLable {
 border: 0px
 }
</style>
<script type="text/javascript">
    var lvTssCd    = "${inputData.tssCd}";
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvMstPgsCd = window.parent.gvPgsStepCd; //진행코드
    var lvMstTssSt = window.parent.gvTssSt;     //과제상태
    
    var pageMode = lvMstPgsCd == "PG" && lvMstTssSt == "100" ? "W" : "R";
    
    var dataSet;
    var lvAttcFilId;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //비고
        /* remTxt = new Rui.ui.form.LTextArea({
            applyTo: 'remTxt',
            height: 600,
            width: 1000
        });
         */
        //Form 비활성화 여부
        disableFields = function() {
            if(lvMstTssSt == "104" || lvMstTssSt == "500") btnSave.show();
            else btnSave.hide();
            
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            Rui.select('.tssLableCss div').removeClass('L-disabled');
        }
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //stoa DataSet 설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'stoaDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }  //과제코드
                , { id: 'userId' } //로그인ID
                , { id: 'csusNm' } //품의서명
                , { id: 'remTxt',  } //비고
                , { id: 'tssSt' } //상태
                , { id: 'attcFilId' } //상태
            ]
        });
        dataSet.on('load', function(e) {
        	
        	lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
        	
        	if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();
        	
        	// 에디터 데이터처리
           	setTimeout(function () {
           		var Wec = document.stoaForm.Wec;
    	 		Wec.MIMEEncodeRange = 1;
    	 		Wec.ShowRuler(1,1); 
    	 		Wec.value = dataSet.getNameValue(0, "remTxt");
    	 		Wec.setDirty(false);	// 변경상태 초기화처리
            }, 1000);
        });

        //폼에 출력 
        /* var bind = new Rui.data.LBind({
            groupId: 'stoaFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'remTxt', ctrlId: 'remTxt', value: 'value' }
            ]
        });
         */
        //유효성 설정
        /* var vm = new Rui.validate.LValidatorManager({
            validators: [  
                  { id: 'remTxt', validExp: '비고:true' }
            ]
        }); */
        
        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            Rui.alert(data.records[0].rtVal);
            
            //실패일경우 ds insert모드로 변경
            if(data.records[0].rtCd != "SUCCESS") {
                dataSet.setState(0, 1);
            } 
            else {
                window.parent.btnStoaRq.show();
            }
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
       /*  //목록 
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
         */
        
        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            /* 
        	if(!vm.validateGroup("stoaForm")) {            
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return;
            }
             */
            if(!fncVaild) return ;
             
             if(confirm("저장하시겠습니까?")) {
            	 dataSet.setNameValue(0, "tssCd",  lvTssCd);  //과제코드
	                dataSet.setNameValue(0, "userId", lvUserId); //사용자ID
	                dataSet.setNameValue(0, "tssSt", "500"); //500:정산작성중
	                dataSet.setNameValue(0, "remTxt", document.stoaForm.Wec.MIMEValue); //500:정산작성중
	                
	                dm.updateDataSet({
	                    modifiedOnly: false,
	                    url:'<c:url value="/prj/tss/nat/updateNatTssStoa.do"/>',
	                    dataSets:[dataSet]
	                });
             }
        });

        var fncVaild = function(){
    	    var frm = document.stoaForm;

    	    frm.Wec.CleanupOptions = "msoffice | empty | comment";
    		frm.Wec.value =frm.Wec.CleanupHtml(frm.Wec.value);

    		dataSet.setNameValue(0, 'remTxt', frm.Wec.BodyValue);
    		
    		if( Rui.isEmpty(dataSet.getNameValue(0, 'remTxt')) || dataSet.getNameValue(0, 'remTxt') == "<P>&nbsp;</P>") {
    			alert('내용을 입력하여 주십시요.');
    			frm.Wec.focus();
    			return false;
    		}
    		//frm.remTxt.value = frm.Wec.MIMEValue;
    		//frm.namoHtml.value = frm.Wec.MIMEValue;		// mime value 설정 : cmd에서 decode 통해 파일을 서버에 업로드하고, 파일 경로를 수정하도록 함. 고, 파일 경로를 수정하도록 함.
    		return true;
 		}
        
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
                dataSet.setNameValue(0, "attcFilId", lvAttcFilId);
                initFrameSetHeight();
            }
        };

        downloadAttachFile = function(attcFilId, seq) {
            stoaForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            stoaForm.submit();
        };
        
        /* [기능] 첨부파일 등록 팝업*/
        getAttachFileId = function() {
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

            return lvAttcFilId;
        };

        //최초 데이터 셋팅 
        if(${resultCnt} > 0) {
            console.log("stoa searchData1");
            dataSet.loadData(${result});
        } else {
            dataSet.newRecord();
        }
        
        createNamoEdit('Wec', '100%', 500, 'namoHtml_DIV');
        
        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
		}
        
    });
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("stoaFormDiv");
}); 
</script>
</head>
<body>

<div id="stoaFormDiv">
    <form name="stoaForm" id="stoaForm" method="post" style="padding: 20px 1px 0px 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        <input type="hidden" id="attcFilId" name="attcFilId" value=""/>
        <input type="hidden" id="seq" name="seq" value=""/>
        
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: 850px;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="center">정산내역</th>
					<td colspan="3">
						<div id="namoHtml_DIV"></div>
					</td>
                </tr>
                <tr>
                    <th align="center">첨부파일</th>
                    <td id="attchFileView">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
	<div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnSave" name="btnSave">저장</button>
	        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
	    </div>
	</div>
</div>
</body>
</html>