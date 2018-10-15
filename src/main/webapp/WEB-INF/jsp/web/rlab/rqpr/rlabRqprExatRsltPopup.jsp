<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprExatRsltPopup.jsp
 * @desc    : 실험결과 등록/수정 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.06  정현웅		최초생성
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
                	parent.callback();

                	if(Rui.isEmpty(data.records[0].rqprExatId)) {
                		rlabRqprExatTreeView.setFocusById(rlabRqprExatMstTreeDataSet.getNameValue(rlabRqprExatMstTreeDataSet.getRow(), 'supiExatCd'));
                		rlabRqprExatDataSet.clearData();
                		rlabRqprExatDataSet.newRecord();
                	} else {
                    	parent.rlabRqprExatRsltDialog.cancel();
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
                setExatExp();
            });

            var exatQty = new Rui.ui.form.LNumberBox({
            	applyTo: 'exatQty',
                placeholder: '가동횟수를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                minValue: 0,
                maxValue: 99999,
                decimalPrecision: 0,
                width: 310
            });

            var exatTim = new Rui.ui.form.LNumberBox({
            	applyTo: 'exatTim',
                placeholder: '실험시간을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                minValue: 0,
                maxValue: 99999,
                decimalPrecision: 1,
                width: 310
            });

            exatTim.on('blur', function(e) {
            	if(exatTim.getValue() % 0.5) {
            		alert('0.5시간 단위로 입력해주세요.');
            	}

            	setExatExp();
            });

            var exatStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'exatStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '',
				editable: false,
				width: 100,
				dateType: 'string'
			});

            exatStrtDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(exatStrtDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					exatStrtDt.setValue(new Date());
				}

				if( !Rui.isEmpty(exatFnhDt.getValue()) && exatStrtDt.getValue() > exatFnhDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					exatStrtDt.setValue(exatFnhDt.getValue());
				}
			});

            var exatFnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'exatFnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '',
				editable: false,
				width: 100,
				dateType: 'string'
			});

			exatFnhDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(exatFnhDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					exatFnhDt.setValue(new Date());
				}

				if( !Rui.isEmpty(exatStrtDt.getValue()) && exatStrtDt.getValue() > exatFnhDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					exatStrtDt.setValue(exatFnhDt.getValue());
				}
			});

            var exatWay = new Rui.ui.form.LTextArea({
                applyTo: 'exatWay',
                placeholder: '실험방법을 입력해주세요.',
                emptyValue: '',
                width: 300,
                height: 95
            });

            exatWay.on('blur', function(e) {
            	exatWay.setValue(exatWay.getValue().trim());
            });

            var mchnInfoId = new Rui.ui.form.LCombo({
                applyTo: 'mchnInfoId',
                name: 'mchnInfoId',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 310,
                url: '',
                displayField: 'mchnInfoNm',
                valueField: 'mchnInfoId'
            });

            var vm1 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'mchnInfoId',			validExp: '시험장비:true' },
                { id: 'smpoQty',			validExp: '실험수:true:number' },
                { id: 'exatQty',			validExp: '가동횟수:true:number' },
                { id: 'exatStrtDt',			validExp: '실험기간:true:date=YYYY-MM-DD' },
                { id: 'exatFnhDt',			validExp: '실험기간:true:date=YYYY-MM-DD' },
                { id: 'exatWay',			validExp: '실험방법:true:maxByteLength=4000' }
                ]
            });

            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'mchnInfoId',			validExp: '시험장비:true' },
                { id: 'exatQty',			validExp: '가동횟수:true:number' },
                { id: 'exatTim',			validExp: '실험시간:true:number' },
                { id: 'exatStrtDt',			validExp: '실험기간:true:date=YYYY-MM-DD' },
                { id: 'exatFnhDt',			validExp: '실험기간:true:date=YYYY-MM-DD' },
                { id: 'exatWay',			validExp: '실험방법:true:maxByteLength=4000' }
                ]
            });

            var rlabRqprExatMstTreeDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprExatMstTreeDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: -1,
                fields: [
                      { id: 'exatCd', type: 'number' }
                    , { id: 'exatNm' }
                    , { id: 'supiExatCd', type: 'number' }
                    , { id: 'exatCdL', type: 'number' }
                    , { id: 'sopNo' }
                    , { id: 'utmExp', type: 'number' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number' }
                    , { id: 'utmExatTim', type: 'number' }
                    , { id: 'dspNo', type: 'number' }
                ]
            });

            var rlabRqprExatTreeView = new Rui.ui.tree.LTreeView({
                id: 'rlabRqprExatTreeView',
                dataSet: rlabRqprExatMstTreeDataSet,
                fields: {
                    rootValue: 0,
                    parentId: 'supiExatCd',
                    id: 'exatCd',
                    label: 'exatNm',
                    order: 'dspNo'
                },
                defaultOpenDepth: -1,
                width: 250,
                height: 390,
                useAnimation: true
            });

            rlabRqprExatTreeView.on('focusChanged', function(e) {
            	var treeRecord = e.newNode.getRecord();
            	//alert(treeRecord.get('exatCd'));
            	if(treeRecord.get('exatCdL') < 2) {
            		return;
            	}

            	var exatCd = treeRecord.get('exatCd');

            	rlabRqprExatDataSet.setNameValue(0, 'exatCd', exatCd);
            	rlabRqprExatDataSet.setNameValue(0, 'exatNm', treeRecord.get('path'));
        		rlabRqprExatDataSet.setNameValue(0, 'sopNo', treeRecord.get('sopNo'));

//             	if(treeRecord.get('expCrtnScnCd') == '1') {
//             		smpoQty.setEditable(true);
//             		exatTim.setEditable(false);
//             		exatTim.setValue(null);
//             	} else {
//             		smpoQty.setEditable(false);
//             		exatTim.setEditable(true);
//             		smpoQty.setValue(null);
//             	}

        		setExatExp();

            	mchnInfoId.setValue('');

            	mchnInfoId.getDataSet().load({
            	    url: '<c:url value="/rlab/getRlabExatDtlComboList.do?exatCd="/>' + exatCd
            	});
            });

            rlabRqprExatTreeView.render('rlabRqprExatTreeView');

            setExatExp = function() {
            	var row = rlabRqprExatMstTreeDataSet.getRow();

            	if(row == -1) {
            		return ;
            	}

            	var treeRecord = rlabRqprExatMstTreeDataSet.getAt(row);
            	var exatRecord = rlabRqprExatDataSet.getAt(0);

            	if(treeRecord.get('expCrtnScnCd') == '1') {
            		var smpoQty = exatRecord.get('smpoQty');

            		if(Rui.isNumber(smpoQty)) {
            			var exatExp = treeRecord.get('utmExp') * smpoQty;

            			exatRecord.set('exatExp', exatExp);
            			exatRecord.set('exatExpView', Rui.util.LNumber.toMoney(exatExp, '') + '원');
            		} else {
            			exatRecord.set('exatExp', null);
            			exatRecord.set('exatExpView', null);
            		}
            	} else {
            		var exatTim = exatRecord.get('exatTim') / treeRecord.get('utmExatTim');

            		if(exatTim > 0) {
            			var exatExp = treeRecord.get('utmExp') * exatTim;

            			exatRecord.set('exatExp', exatExp);
            			exatRecord.set('exatExpView', Rui.util.LNumber.toMoney(exatExp, '') + '원');
            		} else {
            			exatRecord.set('exatExp', null);
            			exatRecord.set('exatExpView', null);
            		}
            	}
            };

            var rlabRqprExatDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprExatDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprExatId', type: 'number' }
                	, { id: 'rqprId', type: 'number', defaultValue: ${inputData.rqprId} }
					, { id: 'exatCd' }
					, { id: 'exatNm' }
					, { id: 'sopNo' }
					, { id: 'mchnInfoId' }
					, { id: 'smpoQty', type: 'number' }
					, { id: 'exatQty', type: 'number' }
					, { id: 'exatTim', type: 'number' }
					, { id: 'exatExp' }
					, { id: 'exatExpView' }
					, { id: 'exatStrtDt' }
					, { id: 'exatFnhDt' }
					, { id: 'exatWay' }
                ]
            });

            rlabRqprExatDataSet.on('load', function(e) {
            	if(Rui.isNumber(rlabRqprExatDataSet.getNameValue(0, 'rqprExatId'))) {
            		rlabRqprExatTreeView.setFocusById(rlabRqprExatDataSet.getNameValue(0, 'exatCd'));
            	} else {
            		rlabRqprExatDataSet.clearData();
            		rlabRqprExatDataSet.newRecord();
            	}
            });

            bind = new Rui.data.LBind({
                groupId: 'fieldWrapper',
                dataSet: rlabRqprExatDataSet,
                bind: true,
                bindInfo: [
                    { id: 'exatNm',				ctrlId:'exatNm',			value:'html'},
                    { id: 'sopNo',				ctrlId:'sopNo',				value:'html'},
                    { id: 'mchnInfoId',			ctrlId:'mchnInfoId',		value:'value'},
                    { id: 'smpoQty',			ctrlId:'smpoQty',			value:'value'},
                    { id: 'exatQty',			ctrlId:'exatQty',			value:'value'},
                    { id: 'exatTim',			ctrlId:'exatTim',			value:'value'},
                    { id: 'exatExpView',		ctrlId:'exatExpView',		value:'html'},
                    { id: 'exatStrtDt',			ctrlId:'exatStrtDt',		value:'value'},
                    { id: 'exatFnhDt',			ctrlId:'exatFnhDt',			value:'value'},
                    { id: 'exatWay',			ctrlId:'exatWay',			value:'value'}
                ]
            });

            /* 시험의뢰 실험결과 정보 저장 */
            save = function(type) {
            	var treeRow = rlabRqprExatMstTreeDataSet.getRow();
            	var vm = rlabRqprExatMstTreeDataSet.getNameValue(treeRow, 'expCrtnScnCd') == '1' ? vm1 : vm2;

                if (vm.validateDataSet(rlabRqprExatDataSet, rlabRqprExatDataSet.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[rlabRqprExatDataSet],
                        url:'<c:url value="/rlab/saveRlabRqprExat.do"/>'
                    });
            	}
            };

	    	dm.loadDataSet({
                dataSets: [rlabRqprExatMstTreeDataSet, rlabRqprExatDataSet],
                url: '<c:url value="/rlab/getRlabRqprExatInfo.do"/>',
                params: {
                    rqprExatId: '${inputData.rqprExatId}'
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
   						<button type="button" class="btn"  id="closeBtn" name="closeBtn" onclick="parent.rlabRqprExatRsltDialog.cancel()">닫기</button>
   					</div>
   				</div>

			    <div id="bd" class="tree_wrap01">
			        <div class="LblockMarkupCode">
			            <div id="contentWrapper">
			                <div id="rlabRqprExatTreeView"></div>
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
			   							<td><span id="exatNm"/></td>
			   						</tr>
			   						<tr>
			   							<th align="right">시험장비</th>
			   							<td><div id="mchnInfoId"></div></td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험수</th>
			   							<td><input type="text" id="smpoQty"></td>
			   						</tr>
			   						<tr>
			   							<th align="right">가동횟수</th>
			   							<td><input type="text" id="exatQty"></td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험시간</th>
			   							<td><input type="text" id="exatTim"></td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험수가</th>
			   							<td><span id="exatExpView"/></td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험기간</th>
			   							<td>
			   								<input type="text" id="exatStrtDt"/><em class="gab"> ~ </em>
			   								<input type="text" id="exatFnhDt"/>
			   							</td>
			   						</tr>
			   						<tr>
			   							<th align="right">실험방법</th>
			   							<td>
			   								<textarea id="exatWay"></textarea>
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