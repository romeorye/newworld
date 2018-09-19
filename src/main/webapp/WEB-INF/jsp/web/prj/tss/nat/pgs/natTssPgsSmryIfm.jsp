<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      :natTssPgsSmryIfm.jsp
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
%>
<style>
 .L-tssLable {
 border: 0px
 }
</style>
<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd    = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt    = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    var lvTssNosSt = stringNullChk(window.parent.gvTssNosSt);

    var pageMode = lvPgsCd == "PG" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";

    var dataSet;
    var lvAttcFilId;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //총수행시작일
        ttlCrroStrtDt = new Rui.ui.form.LTextBox({
            applyTo: 'ttlCrroStrtDt',
            editable: false,
            width: 80
        });

        //총수행종료일
        ttlCrroFnhDt = new Rui.ui.form.LTextBox({
            applyTo: 'ttlCrroFnhDt',
            editable: false,
            width: 80
        });
        
        //1차년도시작일
        strtDt1 = new Rui.ui.form.LTextBox({
            applyTo: 'strtDt1',
            editable: false,
            width: 80
        });

        //1차년도종료일
        fnhDt1 = new Rui.ui.form.LTextBox({
            applyTo: 'fnhDt1',
            editable: false,
            width: 80
        });
        
        //2차년도시작일
        strtDt2 = new Rui.ui.form.LTextBox({
            applyTo: 'strtDt2',
            editable: false,
            width: 80
        });

        //2차년도종료일
        fnhDt2 = new Rui.ui.form.LTextBox({
            applyTo: 'fnhDt2',
            editable: false,
            width: 80
        });
        
        //3차년도시작일
        strtDt3 = new Rui.ui.form.LTextBox({
            applyTo: 'strtDt3',
            editable: false,
            width: 80
        });

        //3차년도종료일
        fnhDt3 = new Rui.ui.form.LTextBox({
            applyTo: 'fnhDt3',
            editable: false,
            width: 80
        });
        
        //4차년도시작일
        strtDt4 = new Rui.ui.form.LTextBox({
            applyTo: 'strtDt4',
            editable: false,
            width: 80
        });

        //4차년도종료일
        fnhDt4 = new Rui.ui.form.LTextBox({
            applyTo: 'fnhDt4',
            editable: false,
            width: 80
        });
        
        //5차년도시작일
        strtDt5 = new Rui.ui.form.LTextBox({
            applyTo: 'strtDt5',
            editable: false,
            width: 80
        });

        //5차년도종료일
        fnhDt5 = new Rui.ui.form.LTextBox({
            applyTo: 'fnhDt5',
            editable: false,
            width: 80
        });

        //기관유형
        cbYldItmType = new Rui.ui.form.LCombo({
            name: 'cbYldItmType',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=INST_TYPE_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            rendererField: 'value',
            autoMapping: true
        });

        //Form 비활성화 여부
        disableFields = function() {
            document.getElementById('attchFileMngBtn').style.display = "none";

            grid2.setEditable(false);

            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            Rui.select('.tssLableCss div').removeClass('L-disabled');
        }



        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //smry DataSet 설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }                //과제코드
                , { id: 'userId' }               //로그인ID
                , { id: 'ttlCrroStrtDt' }        //총수행시작일
                , { id: 'ttlCrroFnhDt' }         //총수행종료일
                , { id: 'smryTxt' }              //개발대상기술 및 제품개요
                , { id: 'attcFilId' }            //첨부파일ID
                , { id: 'tssNosSt' }             //과제차수
                , { id: 'strtDt1' }              //
                , { id: 'fnhDt1' }               //
                , { id: 'strtDt2' }              //
                , { id: 'fnhDt2' }               //
                , { id: 'strtDt3' }              //
                , { id: 'fnhDt3' }               //
                , { id: 'strtDt4' }              //
                , { id: 'fnhDt4' }               //
                , { id: 'strtDt5' }              //
                , { id: 'fnhDt5' }               //
            ]
        });
        dataSet.on('load', function(e) {
            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

            document.getElementById('smryTxt').innerHTML = dataSet.getNameValue(0, "smryTxt");

            smryDataLstSet.load({
                url: '<c:url value="/prj/tss/nat/retrieveNatTssPgsSmryInst.do"/>',
                params :{
                   tssCd :lvTssCd
                }
            });
            
            initFrameSetHeight();
        });

        //smryList DataSet 설정
        smryDataLstSet = new Rui.data.LJsonDataSet({
            id: 'smryInstDataSet',
            remainRemoved: true,
            fields: [
                  { id:'tssCd' }         //과제코드
                , { id:'crroInstSn' }    //수행기관일련번호
                , { id:'instNm' }        //기관명
                , { id:'instTypeCd' }    //기관유형
                , { id:'userId' }        //사용자ID
            ]
        });

        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'smryFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',           ctrlId: 'tssCd',             value: 'value' }
                , { id: 'ttlCrroStrtDt',   ctrlId: 'ttlCrroStrtDt',     value: 'value' }
                , { id: 'ttlCrroFnhDt',    ctrlId: 'ttlCrroFnhDt',      value: 'value' }
                , { id: 'userId',          ctrlId: 'userId',            value: 'value' }
                , { id: 'strtDt1',         ctrlId: 'strtDt1',           value: 'value' }
                , { id: 'fnhDt1',          ctrlId: 'fnhDt1',            value: 'value' }
                , { id: 'strtDt2',         ctrlId: 'strtDt2',           value: 'value' }
                , { id: 'fnhDt2',          ctrlId: 'fnhDt2',            value: 'value' }
                , { id: 'strtDt3',         ctrlId: 'strtDt3',           value: 'value' }
                , { id: 'fnhDt3',          ctrlId: 'fnhDt3',            value: 'value' }
                , { id: 'strtDt4',         ctrlId: 'strtDt4',           value: 'value' }
                , { id: 'fnhDt4',          ctrlId: 'fnhDt4',            value: 'value' }
                , { id: 'strtDt5',         ctrlId: 'strtDt5',           value: 'value' }
                , { id: 'fnhDt5',          ctrlId: 'fnhDt5',            value: 'value' }
            ]
        });

        //그리드
        var columnModel2 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                 new Rui.ui.grid.LNumberColumn()
                  , { field: 'instNm', label: '기관명', sortable: false, align:'center', width: 150 }
                  , { field: 'instTypeCd',  label: '기관유형', sortable: false, align:'center', width: 150, editor: cbYldItmType }
            ]
        });

        //패널설정
        var grid2 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel2,
            dataSet: smryDataLstSet,
            width: 600,
            height: 200,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        grid2.render('defaultGrid');



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
            smryForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            smryForm.submit();
        };


        //목록
       /*  var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
 */

        //최초 데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet.loadData(${result});
        }

        disableFields();
    });
</script>
<script type="text/javascript">
$(window).load(function() {
//     initFrameSetHeight();
});
</script>
</head>
<body>

<div id="smryFormDiv">
    <form name="smryForm" id="smryForm" method="post" style="padding: 20px 1px 0px 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        <input type="hidden" id="attcFilId" name="attcFilId" value=""/>
        <input type="hidden" id="seq" name="seq" value=""/>

        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: 150px;" />
                <col style="width: *;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">총과제수행기간</th>
                    <th align="right">과제기간</th>
                    <td class="tssLableCss">
                        <input type="text" id="ttlCrroStrtDt" /><em class="gab"> ~ </em>
                        <input type="text" id="ttlCrroFnhDt" />
                    </td>
                </tr>
                <tr>
                    <th align="right" rowspan="5">년별수행기간</th>
                    <th align="right">1차년도</th>
                    <td class="tssLableCss">
                        <input type="text" id="strtDt1" /><em class="gab"> ~ </em>
                        <input type="text" id="fnhDt1" />
                    </td>
                </tr>
                <tr>
                    <th align="right">2차년도</th>
                    <td class="tssLableCss">
                        <input type="text" id="strtDt2" /><em class="gab"> ~ </em>
                        <input type="text" id="fnhDt2" />
                    </td>
                </tr>
                <tr>
                    <th align="right">3차년도</th>
                    <td class="tssLableCss">
                        <input type="text" id="strtDt3" /><em class="gab"> ~ </em>
                        <input type="text" id="fnhDt3" />
                    </td>
                </tr>
                <tr>
                    <th align="right">4차년도</th>
                    <td class="tssLableCss">
                        <input type="text" id="strtDt4" /><em class="gab"> ~ </em>
                        <input type="text" id="fnhDt4" />
                    </td>
                </tr>
                <tr>
                    <th align="right">5차년도</th>
                    <td class="tssLableCss">
                        <input type="text" id="strtDt5" /><em class="gab"> ~ </em>
                        <input type="text" id="fnhDt5" />
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="titArea mt10">
	        <h4>수행기관</h4>
		</div>
        <div id="defaultGrid"></div>
        <br/>
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: *;" />
                <col style="width: 150px;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">개발대상기술 및 제품개요</th>
                    <td colspan="2" class="tssLableCss">
                        <div id="smryTxt" />
                    </td>

                </tr>
                <tr>
                    <th align="right">GRS첨부파일<br/>(심의파일, 회의록 필수 첨부)</th>
                    <td id="attchFileView">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
	<!-- <div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnList" name="btnList">목록</button>
	    </div>
	</div> -->
</div>
</body>
</html>