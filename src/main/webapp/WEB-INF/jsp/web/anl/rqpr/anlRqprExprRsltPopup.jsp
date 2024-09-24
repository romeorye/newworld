<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlRqprExprRsltPopup.jsp
 * @desc    : 실험결과 등록/수정 팝업
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/tree/rui_tree.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tree/rui_tree.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>


    <style type="text/css" >
        #bd {
            height: 300px;
        }
        h3 {
            margin: 0px !important;
            padding-left: 10px !important;
        }
        #contentWrapper, #fieldWrapper, #buttonWrapper{
            float: left;
        }
        #LblockFields {
            padding: 10px;
        }
        #fieldWrapper {
            margin-left: 20px;
            width: 400px;
        }
        #buttonWrapper {
            margin-left: 20px;
            width: 300px;
        }
        #LblockFields div {
            padding: 5px 0;
        }
        #LblockFields input[readonly]{
            background-color: #ddd;
        }

    </style>
	<script type="text/javascript">
		var anlUgyYn;
		
		Rui.onReady(function() {
			anlUgyYn = '${inputData.anlUgyYn}';

			/*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = parent.anlRqprDataSet.getReadData(e);

                alert(data.records[0].resultMsg);

                if(data.records[0].resultYn == 'Y') {
                	parent.callback();

                	if(Rui.isEmpty(data.records[0].rqprExprId)) {
                		anlRqprExprTreeView.setFocusById(anlRqprExprMstTreeDataSet.getNameValue(anlRqprExprMstTreeDataSet.getRow(), 'supiExprCd'));
                		anlRqprExprDataSet.clearData();
                		anlRqprExprDataSet.newRecord();
                	} else {
                    	parent.anlRqprExprRsltDialog.cancel();
                	}
                }
            });

            var smpoQty = new Rui.ui.form.LNumberBox({
            	applyTo: 'smpoQty',
                placeholder: '실험수를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                minValue: 0,
                maxValue: 99999,
                decimalPrecision: 0,
                width: 310
            });

            smpoQty.on('blur', function(e) {
                setExprExp();
            });

            var exprQty = new Rui.ui.form.LNumberBox({
            	applyTo: 'exprQty',
                placeholder: '가동횟수를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                minValue: 0,
                maxValue: 99999,
                decimalPrecision: 0,
                width: 310
            });

            var exprTim = new Rui.ui.form.LNumberBox({
            	applyTo: 'exprTim',
                placeholder: '실험시간을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                minValue: 0,
                maxValue: 99999,
                decimalPrecision: 1,
                width: 310
            });

            exprTim.on('blur', function(e) {
            	if(exprTim.getValue() % 0.5) {
            		alert('0.5시간 단위로 입력해주세요.');
            	}

            	setExprExp();
            });

            var exprStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'exprStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '',
				editable: false,
				width: 100,
				dateType: 'string'
			});

            exprStrtDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(exprStrtDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					exprStrtDt.setValue(new Date());
				}

				if( !Rui.isEmpty(exprFnhDt.getValue()) && exprStrtDt.getValue() > exprFnhDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					exprStrtDt.setValue(exprFnhDt.getValue());
				}
			});

            var exprFnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'exprFnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '',
				editable: false,
				width: 100,
				dateType: 'string'
			});

			exprFnhDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(exprFnhDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					exprFnhDt.setValue(new Date());
				}

				if( !Rui.isEmpty(exprStrtDt.getValue()) && exprStrtDt.getValue() > exprFnhDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					exprStrtDt.setValue(exprFnhDt.getValue());
				}
			});

            var exprWay = new Rui.ui.form.LTextArea({
                applyTo: 'exprWay',
                placeholder: '실험방법을 입력해주세요.',
                emptyValue: '',
                width: 300,
                height: 95
            });

            exprWay.on('blur', function(e) {
            	exprWay.setValue(exprWay.getValue().trim());
            });

            var mchnInfoId = new Rui.ui.form.LCombo({
                applyTo: 'mchnInfoId',
                name: 'mchnInfoId',
                emptyText: '(선택)',
                defaultValue: '',
                emptyValue: '',
                width: 310,
                url: '',
                displayField: 'mchnInfoNm',
                valueField: 'mchnInfoId'
            });

            var vm1 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'mchnInfoId',			validExp: '분석기기:true' },
                { id: 'smpoQty',			validExp: '실험수:true:number' },
                { id: 'exprQty',			validExp: '가동횟수:true:number' },
                { id: 'exprStrtDt',			validExp: '실험기간:true:date=YYYY-MM-DD' },
                { id: 'exprFnhDt',			validExp: '실험기간:true:date=YYYY-MM-DD' },
                { id: 'exprWay',			validExp: '실험방법:true:maxByteLength=4000' }
                ]
            });

            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'mchnInfoId',			validExp: '분석기기:true' },
                { id: 'exprQty',			validExp: '가동횟수:true:number' },
                { id: 'exprTim',			validExp: '실험시간:true:number' },
                { id: 'exprStrtDt',			validExp: '실험기간:true:date=YYYY-MM-DD' },
                { id: 'exprFnhDt',			validExp: '실험기간:true:date=YYYY-MM-DD' },
                { id: 'exprWay',			validExp: '실험방법:true:maxByteLength=4000' }
                ]
            });

            var anlRqprExprMstTreeDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprExprMstTreeDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: -1,
                fields: [
                      { id: 'exprCd', type: 'number' }
                    , { id: 'exprNm' }
                    , { id: 'supiExprCd', type: 'number' }
                    , { id: 'exprCdL', type: 'number' }
                    , { id: 'sopNo' }
                    , { id: 'utmExp', type: 'number' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number' }
                    , { id: 'utmExprTim', type: 'number' }
                    , { id: 'dspNo', type: 'number' }
                ]
            });

            var anlRqprExprTreeView = new Rui.ui.tree.LTreeView({
                id: 'anlRqprExprTreeView',
                dataSet: anlRqprExprMstTreeDataSet,
                fields: {
                    rootValue: 0,
                    parentId: 'supiExprCd',
                    id: 'exprCd',
                    label: 'exprNm',
                    order: 'dspNo'
                },
                defaultOpenDepth: -1,
                width: 250,
                height: 390,
                useAnimation: true
            });

            anlRqprExprTreeView.on('focusChanged', function(e) {
            	var treeRecord = e.newNode.getRecord();
            	//alert(treeRecord.get('exprCd'));
            	if(treeRecord.get('exprCdL') < 4) {
            		return;
            	}

            	var exprCd = treeRecord.get('exprCd');

            	anlRqprExprDataSet.setNameValue(0, 'exprCd', exprCd);
            	anlRqprExprDataSet.setNameValue(0, 'exprNm', treeRecord.get('path'));
        		anlRqprExprDataSet.setNameValue(0, 'sopNo', treeRecord.get('sopNo'));

//             	if(treeRecord.get('expCrtnScnCd') == '1') {
//             		smpoQty.setEditable(true);
//             		exprTim.setEditable(false);
//             		exprTim.setValue(null);
//             	} else {
//             		smpoQty.setEditable(false);
//             		exprTim.setEditable(true);
//             		smpoQty.setValue(null);
//             	}

        		setExprExp();

            	mchnInfoId.setValue('');

            	mchnInfoId.getDataSet().load({
            	    url: '<c:url value="/anl/getAnlExprDtlComboList.do?exprCd="/>' + exprCd
            	});
            });

            anlRqprExprTreeView.render('anlRqprExprTreeView');

            setExprExp = function() {
            	var row = anlRqprExprMstTreeDataSet.getRow();

            	if(row == -1) {
            		return ;
            	}

            	var treeRecord = anlRqprExprMstTreeDataSet.getAt(row);
            	var exprRecord = anlRqprExprDataSet.getAt(0);

            	if(treeRecord.get('expCrtnScnCd') == '1') {
            		var smpoQty = exprRecord.get('smpoQty');

            		if(Rui.isNumber(smpoQty)) {
            			var exprExp = treeRecord.get('utmExp') * smpoQty;
            			
            			if( anlUgyYn == "U"   ){
            				exprExp = exprExp * 2;
            			}
            			
            			exprRecord.set('exprExp', exprExp);
            			exprRecord.set('exprExpView', Rui.util.LNumber.toMoney(exprExp, '') + '원');
            		} else {
            			exprRecord.set('exprExp', null);
            			exprRecord.set('exprExpView', null);
            		}
            	} else {
            		var exprTim = exprRecord.get('exprTim') / treeRecord.get('utmExprTim');

            		if(exprTim > 0) {
            			var exprExp = treeRecord.get('utmExp') * exprTim;

            			if( anlUgyYn == "U"   ){
            				exprExp = exprExp *2;
            			}
            			
            			exprRecord.set('exprExp', exprExp);
            			exprRecord.set('exprExpView', Rui.util.LNumber.toMoney(exprExp, '') + '원');
            		} else {
            			exprRecord.set('exprExp', null);
            			exprRecord.set('exprExpView', null);
            		}
            	}
            };

            var anlRqprExprDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprExprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprExprId', type: 'number' }
                	, { id: 'rqprId', type: 'number', defaultValue: ${inputData.rqprId} }
					, { id: 'exprCd' }
					, { id: 'exprNm' }
					, { id: 'sopNo' }
					, { id: 'mchnInfoId' }
					, { id: 'smpoQty', type: 'number' }
					, { id: 'exprQty', type: 'number' }
					, { id: 'exprTim', type: 'number' }
					, { id: 'exprExp' }
					, { id: 'exprExpView' }
					, { id: 'exprStrtDt' }
					, { id: 'exprFnhDt' }
					, { id: 'exprWay' }
                ]
            });

            anlRqprExprDataSet.on('load', function(e) {
            	if(Rui.isNumber(anlRqprExprDataSet.getNameValue(0, 'rqprExprId'))) {
            		anlRqprExprTreeView.setFocusById(anlRqprExprDataSet.getNameValue(0, 'exprCd'));
            	} else {
            		anlRqprExprDataSet.clearData();
            		anlRqprExprDataSet.newRecord();
            	}
            });

            bind = new Rui.data.LBind({
                groupId: 'fieldWrapper',
                dataSet: anlRqprExprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'exprNm',				ctrlId:'exprNm',			value:'html'},
                    { id: 'sopNo',				ctrlId:'sopNo',				value:'html'},
                    { id: 'mchnInfoId',			ctrlId:'mchnInfoId',		value:'value'},
                    { id: 'smpoQty',			ctrlId:'smpoQty',			value:'value'},
                    { id: 'exprQty',			ctrlId:'exprQty',			value:'value'},
                    { id: 'exprTim',			ctrlId:'exprTim',			value:'value'},
                    { id: 'exprExpView',		ctrlId:'exprExpView',		value:'html'},
                    { id: 'exprStrtDt',			ctrlId:'exprStrtDt',		value:'value'},
                    { id: 'exprFnhDt',			ctrlId:'exprFnhDt',			value:'value'},
                    { id: 'exprWay',			ctrlId:'exprWay',			value:'value'}
                ]
            });

            /* 분석의뢰 실험결과 정보 저장 */
            save = function(type) {
            	var treeRow = anlRqprExprMstTreeDataSet.getRow();
            	var vm = anlRqprExprMstTreeDataSet.getNameValue(treeRow, 'expCrtnScnCd') == '1' ? vm1 : vm2;

                if (vm.validateDataSet(anlRqprExprDataSet, anlRqprExprDataSet.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[anlRqprExprDataSet],
                        url:'<c:url value="/anl/saveAnlRqprExpr.do"/>'
                    });
            	}
            };

	    	dm.loadDataSet({
                dataSets: [anlRqprExprMstTreeDataSet, anlRqprExprDataSet],
                url: '<c:url value="/anl/getAnlRqprExprInfo.do"/>',
                params: {
                    rqprExprId: '${inputData.rqprExprId}'
                }
            });

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">

   		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0; margin-top:-25px;">

   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save('')">저장</button>
   						<button type="button" class="btn"  id="closeBtn" name="closeBtn" onclick="parent.anlRqprExprRsltDialog.cancel()">닫기</button>
   					</div>
   				</div>

			    <div id="bd" class="tree_wrap01">
			        <div class="LblockMarkupCode">
			            <div id="contentWrapper">
			                <div id="anlRqprExprTreeView" class="tree_h"></div>
			            </div>
			            <div id="fieldWrapper">
			   				<table class="table table_txt_right">
			   					<colgroup>
			   						<col style="width:20%;"/>
			   						<col style="width:80%;"/>
			   					</colgroup>
			   					<tbody>
			   						<tr>
			   							<th align="right">실험명</th>
			   							<td><span id="exprNm"/></td>
			   						</tr>
			   						<tr>
			   							<th align="right">SOP No</th>
			   							<td><span id="sopNo"/></td>
			   						</tr>
			   						<tr>
			   							<th align="right">분석기기</th>
			   							<td><div id="mchnInfoId"></div></td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험수</th>
			   							<td><input type="text" id="smpoQty"></td>
			   						</tr>
			   						<tr>
			   							<th align="right">가동횟수</th>
			   							<td><input type="text" id="exprQty"></td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험시간</th>
			   							<td><input type="text" id="exprTim"></td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험수가</th>
			   							<td><span id="exprExpView"/></td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험기간</th>
			   							<td>
			   								<input type="text" id="exprStrtDt"/><em class="gab"> ~ </em>
			   								<input type="text" id="exprFnhDt"/>
			   							</td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험방법</th>
			   							<td>
			   								<textarea id="exprWay"></textarea>
			   							</td>
			   						</tr>
			   					</tbody>
			   				</table>
			            </div>
			        </div>
			    </div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>