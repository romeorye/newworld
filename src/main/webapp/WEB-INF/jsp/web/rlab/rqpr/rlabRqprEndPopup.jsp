<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprEndPopup.jsp
 * @desc    : 관련시험 반려/시험중단 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.12  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 2차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = parent.rlabRqprDataSet.getReadData(e);

                alert(data.records[0].resultMsg);

                if(data.records[0].resultYn == 'Y') {
                	parent.goRlabRqprList4Chrg();
                	parent.rlabRqprEndDialog.cancel();
                }
            });

            var rson = new Rui.ui.form.LTextArea({
                applyTo: 'rson',
                placeholder: '${inputData.type}사유를 입력해주세요.',
                emptyValue: '',
                width: 387,
                height: 55
            });

            rson.on('blur', function(e) {
            	rson.setValue(rson.getValue().trim());
            });

            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'rson',				validExp: '${inputData.type}사유:true:maxByteLength=1000' }
                ]
            });

            /* 시험의뢰 반려/시험중단 처리 */
            save = function(type) {
                if (vm.validateGroup('aform') == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('${inputData.type} 하시겠습니까?')) {
                    dm.updateDataSet({
                        url:'<c:url value="/rlab/saveRlabRqprEnd.do"/>',
                        params: {
                            rqprId: parent.rlabRqprDataSet.getNameValue(0, 'rqprId'),
                            rson: encodeURIComponent(rson.getValue()),
                            rlabAcpcStCd: '${inputData.type}' == '반려' ? '04' : '05'
                        }
                    });
            	}
            };

            $('#rlabNm').html(parent.rlabRqprDataSet.getNameValue(0, 'rlabNm'));

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="rqprId" name="rqprId" value="${inputData.rqprId}"/>

   		<div class="LblockMainBody">

   			<div class="sub-content">

   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:25%;"/>
   						<col style="width:75%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">시험명</th>
   							<td id="rlabNm"></td>
   						</tr>
   						<tr>
   							<th align="right">${inputData.type}사유</th>
   							<td>
   								<textarea id="rson"></textarea>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save('${inputData.type}')">${inputData.type}</button>
   						<button type="button" class="btn"  id="cancelBtn" name="cancelBtn" onclick="parent.rlabRqprEndDialog.cancel()">취소</button>
   					</div>
   				</div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>