<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : smryClDetail.jsp
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
<style>
 .L-tssLable {
 border: 0px
 }
</style>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">
    var gvUserId = "${inputData._userId}";
    var dataSet;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //프로젝트명
        prjNm = new Rui.ui.form.LTextBox({
            applyTo: 'prjNm',
            editable: false,
            width: 300
        });

        //조직코드
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            editable: false,
            width: 300
        });

        //발의주체
        ppslMbdNm = new Rui.ui.form.LTextBox({
            applyTo: 'ppslMbdNm',
            editable: false,
            width: 200
        });

        //사업부문(Funding기준)
        bizDptNm = new Rui.ui.form.LTextBox({
            applyTo: 'bizDptNm',
            editable: false,
            width: 200
        });

        //WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            editable: false,
            width: 70
        });

        //과제리더
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            editable: false,
            width: 200
        });

        // 과제속성
        tssAttrNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssAttrNm',
            editable: false,
            width: 200
        });

        //제품군
        prodGNm = new Rui.ui.form.LTextBox({
            applyTo: 'prodGNm',
            editable: false,
            width: 200
        });

        //과제기간 시작일
        tssStrtDd = new Rui.ui.form.LTextBox({
            applyTo: 'tssStrtDd',
            editable: false,
            width: 100
        });

        //과제기간 종료일
        tssFnhDd = new Rui.ui.form.LTextBox({
            applyTo: 'tssFnhDd',
            editable: false,
            width: 100
        });

        //연구분야
        rsstSphe = new Rui.ui.form.LCombo({
            applyTo: 'rsstSphe',
            name: 'rsstSphe',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=RSST_SPHE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });

        //유형
        tssType = new Rui.ui.form.LCombo({
            applyTo: 'tssType',
            name: 'tssType',
            useEmptyText: true,
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_TYPE"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });


        //Form 비활성화 여부
        disableFields = function() {
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            Rui.select('.tssLableCss div').removeClass('L-disabled');
        }


        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'mstDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }       //과제코드
                , { id: 'userId' }      //로그인ID
                , { id: 'prjNm' }       //프로젝트명
                , { id: 'deptName' }    //조직코드
                , { id: 'ppslMbdNm' }   //발의주체
                , { id: 'bizDptNm' }    //과제유형
                , { id: 'wbsCd' }       //WBS Code
                , { id: 'pkWbsCd' }     //WBS Code
                , { id: 'saUserName' }  //과제리더
                , { id: 'tssAttrNm' }   //과제속성
                , { id: 'prodGNm' }     //제품군
                , { id: 'tssStrtDd' }   //과제기간 시작일
                , { id: 'tssFnhDd' }    //과제기간 종료일
                , { id: 'rsstSphe' }    //연구분야
                , { id: 'tssType' }     //유형
                , { id: 'tssNm' }       //과제명
            ]
        });
        dataSet.on('load', function(e) {
            document.getElementById('tssNm').innerHTML = dataSet.getNameValue(0, "tssNm");
        });


        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'prjNm',      ctrlId: 'prjNm',      value: 'value' }
                , { id: 'deptName',   ctrlId: 'deptName',   value: 'value' }
                , { id: 'ppslMbdNm',  ctrlId: 'ppslMbdNm',  value: 'value' }
                , { id: 'bizDptNm',   ctrlId: 'bizDptNm',   value: 'value' }
                , { id: 'wbsCd',      ctrlId: 'wbsCd',      value: 'value' }
                , { id: 'saUserName', ctrlId: 'saUserName', value: 'value' }
                , { id: 'tssAttrNm',  ctrlId: 'tssAttrNm',  value: 'value' }
                , { id: 'tssStrtDd',  ctrlId: 'tssStrtDd',  value: 'value' }
                , { id: 'tssFnhDd',   ctrlId: 'tssFnhDd',   value: 'value' }
                , { id: 'mbrCnt',     ctrlId: 'mbrCnt',     value: 'value' }
                , { id: 'prodGNm',    ctrlId: 'prodGNm',    value: 'value' }
                , { id: 'rsstSphe',   ctrlId: 'rsstSphe',    value: 'value' }
                , { id: 'tssType',    ctrlId: 'tssType',    value: 'value' }
            ]
        });


        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);

            alert(data.records[0].rtVal);

            //실패일경우 ds update모드로 변경
            if(data.records[0].rtCd == "FAIL") {
                dataSet.setState(0, 2);
            }
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            if(!dataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }

            dataSet.setNameValue(0, "userId", gvUserId);

            dm.updateDataSet({
                url:'<c:url value="/prj/mgmt/smryCl/updateSmryCl.do"/>',
                dataSets:[dataSet]
            });
        });


        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(searchForm, "<c:url value='/prj/mgmt/smryCl/smryClList.do'/>");
        });


        //데이터 셋팅
        if(${resultCnt} > 0) {
            dataSet.loadData(${result});
            disableFields();
        }
    });
</script>
</head>
<body>
<form name="searchForm" id="searchForm"  method="post">
	<input type="hidden" name="wbsCd" value="${inputData.wbsCd}"/>
	<input type="hidden" name="tssNm" value="${inputData.tssNm}"/>
	<input type="hidden" name=saSabunNew value="${inputData.saSabunNew}"/>
	<input type="hidden" name=deptName value="${inputData.deptName}"/>
	<input type="hidden" name=prjNm value="${inputData.prjNm}"/>
	<input type="hidden" name=tssStrtDd value="${inputData.tssStrtDd}"/>
	<input type="hidden" name=tssFnhDd value="${inputData.tssFnhDd}"/>
	<input type="hidden" name=tssStrtDd value="${inputData.tssStrtDd}"/>
	<input type="hidden" name=pgsStepCd value="${inputData.pgsStepCd}"/>
	<input type="hidden" name=pageNum value="${inputData.pageNum}"/>
</form>
    <div class="contents">
	    <div class="titleArea">
	    	<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>
	        <h2>연구분야, 유형관리</h2>
	    </div>
        <div class="sub-content">
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
                <input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 14%;" />
                                <col style="width: 36%;" />
                                <col style="width: 15%;" />
                                <col style="" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">프로젝트명</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="prjNm" />
                                    </td>
                                    <th align="right">조직</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="deptName" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">발의주체</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="ppslMbdNm" />
                                    </td>
                                    <th align="right">사업부문(Funding기준)</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="bizDptNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">WBSCode/과제명</th>
                                    <td class="tssLableCss smry_tain" colspan="3">
                                        <input type="text" id="wbsCd" />
                                        <div id="tssNm" style="width:900px;padding:0px 5px">
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제속성</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="tssAttrNm" />
                                    </td>
                                    <th align="right">제품군</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="prodGNm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제리더</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="saUserName" />
                                    </td>
                                    <th align="right">과제기간</th>
                                    <td class="tssLableCss">
                                        <input type="text" id="tssStrtDd" /><em class="gab" style="margin:0 !important; margin-left:-30px !important;"> ~ </em>
                                        <input type="text" id="tssFnhDd" />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">연구분야</th>
                                    <td>
                                        <div id="rsstSphe">
                                    </td>
                                    <th align="right">유형</th>
                                    <td>
                                        <div id="tssType">
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </fieldset>
                </form>
            </div>
            <div class="titArea">
			    <div class="LblockButton">
			        <button type="button" id="btnSave">저장</button>
			        <button type="button" id="btnList">목록</button>
			    </div>
			</div>
        </div>

    </div>
</body>
</html>