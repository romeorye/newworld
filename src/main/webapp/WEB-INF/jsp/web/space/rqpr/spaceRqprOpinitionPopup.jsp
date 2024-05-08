<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlRqprOpinitionPopup.jsp
 * @desc    : 관련평가 의견 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
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

	var opinitionDialog;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = anlRqprOpinitionDataSet.getReadData(e);

                alert(data.records[0].resultMsg);

                if(data.records[0].resultYn == 'Y') {
                	if(data.records[0].event == 'I') {
                		opiSbc.setValue('');
                	}

                	getAnlRqprOpinitionList();
                }
            });

            var textArea = new Rui.ui.form.LTextArea({
                emptyValue: ''
            });

            var opiSbc = new Rui.ui.form.LTextArea({
                applyTo: 'opiSbc',
                placeholder: '의견을 입력해주세요.',
                emptyValue: '',
                width: 537,
                height: 55
            });

            opiSbc.on('blur', function(e) {
            	opiSbc.setValue(opiSbc.getValue().trim());
            });

            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'opiSbc',				validExp: '의견:true:maxByteLength=4000' }
                ]
            });

            var anlRqprOpinitionDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprOpinitionDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'opiId' }
                	, { id: 'rqprId' }
                	, { id: 'rgstId' }
                	, { id: 'rgstNm' }
                	, { id: 'rgstDt' }
					, { id: 'opiSbc' }
                ]
            });

            anlRqprOpinitionDataSet.on('load', function(e) {
            	var cnt = anlRqprOpinitionDataSet.getCount();

            	parent.$("#opinitionCnt").html(cnt == 0 ? '' : '(' + cnt + ')');
   	      	});

            anlRqprOpinitionDataSet.on('canRowPosChange', function(e){
            	if (vm.validateDataSet(anlRqprOpinitionDataSet, anlRqprOpinitionDataSet.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });

            var anlRqprOpinitionColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'rgstNm',		label: '작성자',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'rgstDt',		label: '작성일',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'opiSbc',		label: '의견',		sortable: false,	editable: true, editor: textArea,	align:'left',	width: 618,
                    	renderer: function(val, p, record, row, col) {
                    		return val.replaceAll('\n', '<br/>');
                    } }
                ]
            });

            var anlRqprOpinitionGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprOpinitionColumnModel,
                dataSet: anlRqprOpinitionDataSet,
                width: 780,
                height: 300,
                autoToEdit: true,
                autoWidth: true
            });

            anlRqprOpinitionGrid.on('beforeEdit', function(e) {
            	if(anlRqprOpinitionDataSet.getNameValue(e.row, 'rgstId') != '${inputData._userId}') {
            		return false;
            	}
            });

            anlRqprOpinitionGrid.render('anlRqprOpinitionGrid');


            anlRqprOpinitionGrid.on('cellClick', function(e) {

            	var record = anlRqprOpinitionDataSet.getAt(e.row);
            	openOpinitionDialog(anlRqprOpinitionDataSet.getNameValue(e.row, 'opiId'));
            });

            openOpinitionDialog = function(opiId) {
            	opinitionDialog.setUrl('<c:url value="/anl/openOpinitionPopup.do?opiId="/>' + opiId);
            	opinitionDialog.show();
    	    };

         	// 실험방법 팝업
          	 opinitionDialog = new Rui.ui.LFrameDialog({
          	        id: 'opinitionDialog',
          	        title: '의견상세',
          	        width: 640,
          	        height: 350,
          	        modal: true,
          	        visible: false
          	 });

          	opinitionDialog.render(document.body);

            /* 의견 저장 */
            saveAnlRqprOpinition = function(type) {
            	var pOpiId;
            	var pOpiSbc;

            	if(type == 'I') {
                    if (vm.validateGroup('aform') == false) {
                        alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                        return false;
                    }

                    pOpiId = 0;
                    pOpiSbc = opiSbc.getValue();
            	} else {
            		if(anlRqprOpinitionDataSet.isUpdated() == false) {
            			alert('변경된 내용이 없습니다.');
            			return false;
            		}

                    if (vm.validateDataSet(anlRqprOpinitionDataSet) == false) {
                        alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                        return false;
                    }

                    var row = anlRqprOpinitionDataSet.getRow();

                    pOpiId = anlRqprOpinitionDataSet.getNameValue(row, 'opiId');
                    pOpiSbc = anlRqprOpinitionDataSet.getNameValue(row, 'opiSbc');
            	}

//             	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        url:'<c:url value="/anl/saveAnlRqprOpinition.do"/>',
                        params: {
                            opiId: pOpiId,
                            rqprId: $('#rqprId').val(),
                            opiSbc: encodeURIComponent(pOpiSbc)
                        }
                    });
//             	}
            };

            /* 의견 삭제 */
            deleteAnlRqprOpinition = function() {
            	var row = anlRqprOpinitionDataSet.getRow();

            	if(anlRqprOpinitionDataSet.getNameValue(row, 'rgstId') != '${inputData._userId}') {
            		return false;
            	}

            	if(confirm('삭제 하시겠습니까?')) {
                    dm.updateDataSet({
                        url:'<c:url value="/anl/deleteAnlRqprOpinition.do"/>',
                        params: {
                            opiId: anlRqprOpinitionDataSet.getNameValue(row, 'opiId')
                        }
                    });
            	}
            };

            /* 평가의뢰 의견 리스트 조회 */
            getAnlRqprOpinitionList = function() {
            	anlRqprOpinitionDataSet.load({
                    url: '<c:url value="/anl/getAnlRqprOpinitionList.do"/>',
                    params :{
                    	rqprId : $('#rqprId').val()
                    }
                });
            };

            getAnlRqprOpinitionList();

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="rqprId" name="rqprId" value="${inputData.rqprId}"/>
		<input type="hidden" id="opiSbcDtl" name="opiSbcDtl"/>

   		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:5px 9px 0 9px;">
	   			
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:70%;"/>
   						<col style="width:15%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">의견</th>
   							<td style="padding-top:7px;">
   								<textarea id="opiSbc"></textarea>
   							</td>
   							<td class="t_center">
   								<a style="cursor: pointer;" onclick="saveAnlRqprOpinition('I')" class="btnL">추가</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">의견</span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveAnlRqprOpinitionBtn" name="saveAnlRqprOpinitionBtn" onclick="saveAnlRqprOpinition('U')">저장</button>
   						<button type="button" class="btn"  id="deleteAnlRqprOpinitionBtn" name="deleteAnlRqprOpinitionBtn" onclick="deleteAnlRqprOpinition()">삭제</button>
   					</div>
   				</div>

   				<div id="anlRqprOpinitionGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>