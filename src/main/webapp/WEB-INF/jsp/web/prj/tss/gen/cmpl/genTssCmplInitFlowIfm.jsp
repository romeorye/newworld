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
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvMstPgsCd = window.parent.gvPgsStepCd; //진행코드
    var lvMstTssSt = window.parent.gvTssSt;     //과제상태
    var lvSaSabunNew = window.parent.gvSaSabunNew; //과제리더사번

    var pageMode = lvMstPgsCd == "CM" && lvMstTssSt == "600" ? "W" : "R";

    var dataSet;
    var lvAttcFilId = "";

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //Form 비활성화 여부
        disableFields = function() {
        	if(pageMode == "W" && ("${inputData._roleId}".indexOf("T01")>-1||"${inputData._userSabun}" == lvSaSabunNew)) {
                $('#attchFileMngBtn').show(); 
                btnSave.show();
            } else {
                $('#attchFileMngBtn').hide(); 
                btnSave.hide();
            }

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

        	Wec.SetBodyValue(dataSet.getNameValue(0, "remTxt") );
        });

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
                window.parent.btnInitFlowRq.show();
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
            if(!fncVaild()) return ;

            if(confirm("저장하시겠습니까?")) {
                dataSet.setNameValue(0, "tssCd",  lvTssCd);  //과제코드
                dataSet.setNameValue(0, "userId", lvUserId); //사용자ID
                dataSet.setNameValue(0, "tssSt", "600"); //600:초기유동작성중
                dataSet.setNameValue(0, "remTxt", Wec.GetBodyValue());

                dm.updateDataSet({
                    modifiedOnly: false,
                    url:'<c:url value="/prj/tss/nat/updateNatTssStoa.do"/>',
                    dataSets:[dataSet]
                });
             }
        });

        var fncVaild = function(){
        	var frm = document.stoaForm;

    		dataSet.setNameValue(0, 'remTxt', Wec.GetBodyValue());

    		if( Wec.GetBodyValue() == "<p><br></p>" || Wec.GetBodyValue() == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
    			alert('내용을 입력하여 주십시요.');
				Wec.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}
    		
    		console.log("[lvAttcFilId]", lvAttcFilId);
    		if ( lvAttcFilId == "" ) {
    			alert("첨부파일을 등록하세요.");
    			return false;
    		}

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
        <input type="hidden" name="pageNum" value="${inputData.pageNum}"/>

        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: auto;" />
                <col style="width: 150px;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="center"><span style="color:red;">* </span>초기유동관리내역</th>
					<td colspan="2">
						<div id="namoHtml_DIV">
							<textarea id="remTxt" name="remTxt"></textarea>
							<script>
                                Wec = new NamoSE('remTxt');
                                Wec.params.Width = "100%";
                                Wec.params.UserLang = "auto";
                                Wec.params.Font = fontParam;
                                uploadPath = "<%=uploadPath%>";
                                Wec.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec.params.FullScreen = false;
                                Wec.EditorStart();

                                function OnInitCompleted(e){
	                                e.editorTarget.SetBodyValue(document.getElementById("divWec").value);
	                            }
                            </script>
						</div>
					</td>
                </tr>
                <tr>
                    <th align="center"><span style="color:red;">* </span>첨부파일</th>
                    <td id="attchFileView">&nbsp;</td>
                    <td align="center"><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
	<div class="titArea btn_btm">
	    <div class="LblockButton">
	        <button type="button" id="btnSave" name="btnSave">저장</button>
	        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
	    </div>
	</div>
</div>
</body>
</html>