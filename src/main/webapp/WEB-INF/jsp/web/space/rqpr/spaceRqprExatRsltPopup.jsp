<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceRqprExatRsltPopup.jsp
 * @desc    : 실험결과 등록/수정 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.04  정현웅		최초생성
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
                var data = parent.spaceRqprDataSet.getReadData(e);

                if(data.records[0].resultYn == 'Y') {
                	parent.callback();

                	if(Rui.isEmpty(data.records[0].rqprExatId)) {
                		spaceRqprExatTreeView.setFocusById(spaceRqprExatMstTreeDataSet.getNameValue(spaceRqprExatMstTreeDataSet.getRow(), 'supiExatCd'));
                		spaceRqprExatDataSet.clearData();
                		spaceRqprExatDataSet.newRecord();
                	} else {
                    	parent.spaceRqprExatRsltDialog.cancel();
                	}
                }
            });


            /*사용안함
            	var exatMdul = new Rui.ui.form.LTextBox({
            	applyTo: 'exatMdul',
                placeholder: 'Sketch up, TRENFLOW(직접입력) ',
                defaultValue: '',
                emptyValue: '',
                width: 310
            }); */

            var exatCaseQty = new Rui.ui.form.LNumberBox({
            	applyTo: 'exatCaseQty',
                placeholder: '평가케이스 수를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                minValue: 0,
                maxValue: 99999,
                decimalPrecision: 0,
                width: 310
            });

            var exatDct = new Rui.ui.form.LNumberBox({
            	applyTo: 'exatDct',
                placeholder: '평가일수을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                minValue: 0,
                maxValue: 99999,
                decimalPrecision: 0,
                width: 310
            });

            exatDct.on('blur', function(e) {
            	if(exatDct.getValue() % 1) {
            		alert('1일 단위로 입력해주세요.');
            		return;
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
                placeholder: '평가방법을 입력해주세요.',
                emptyValue: '',
                width: 300,
                height: 135
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
                { id: 'mchnInfoId',			validExp: '평가기기:true' },
                { id: 'exatDct',			validExp: '평가일자:true:number' },
                { id: 'exatCaseQty',		validExp: '평가케이스수:true:number' },
                { id: 'exatStrtDt',			validExp: '평가기간:true:date=YYYY-MM-DD' },
                { id: 'exatFnhDt',			validExp: '평가기간:true:date=YYYY-MM-DD' },
                { id: 'exatWay',			validExp: '실험방법:true:maxByteLength=4000' }
                ]
            });

            var spaceRqprExatMstTreeDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprExatMstTreeDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: -1,
                fields: [
                      { id: 'exatCd', type: 'number' }
                    , { id: 'exatNm' }
                    , { id: 'supiExatCd', type: 'number' }
                    , { id: 'exatCdL', type: 'number' }
                    , { id: 'utmExp', type: 'number' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number' }	//단위평가수량
                    , { id: 'utmExatTim', type: 'number' } //평가일수
                    , { id: 'dspNo', type: 'number' }
                ]
            });

            var spaceRqprExatTreeView = new Rui.ui.tree.LTreeView({
                id: 'spaceRqprExatTreeView',
                dataSet: spaceRqprExatMstTreeDataSet,
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

            spaceRqprExatTreeView.on('focusChanged', function(e) {

            	var treeRecord = e.newNode.getRecord();
            	if(treeRecord.get('exatCdL') < 2) {
            		return;
            	}

            	var exatCd = treeRecord.get('exatCd');

            	spaceRqprExatDataSet.setNameValue(0, 'exatCd', exatCd);
            	spaceRqprExatDataSet.setNameValue(0, 'exatNm', treeRecord.get('path'));
        		setExatExp();

            	mchnInfoId.setValue('');

            	mchnInfoId.getDataSet().load({
            	    url: '<c:url value="/space/getSpaceExatDtlComboList.do?exatCd="/>' + exatCd
            	});
            });

            spaceRqprExatTreeView.render('spaceRqprExatTreeView');

            /*수가 계산*/
            setExatExp = function() {
            	var row = spaceRqprExatMstTreeDataSet.getRow();

            	if(row == -1) {
            		return ;
            	}

            	var treeRecord = spaceRqprExatMstTreeDataSet.getAt(row);
            	var exatRecord = spaceRqprExatDataSet.getAt(0);

            	if(treeRecord.get('expCrtnScnCd') == '1') {
            		var exatDct = exatRecord.get('exatDct');

            		if(Rui.isNumber(exatDct)) {

            			var utmExp = treeRecord.get('utmExp');
            			if( utmExp == null || utmExp == "" ) utmExp = 0;

            			var exatExp = utmExp * exatDct;

            			exatRecord.set('exatExp', exatExp);
            			exatRecord.set('exatExpView', Rui.util.LNumber.toMoney(exatExp, '') + '원');
            		} else {
            			exatRecord.set('exatExp', null);
            			exatRecord.set('exatExpView', null);
            		}
            	}
            };

            var spaceRqprExatDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprExatDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprExatId', type: 'number' }
                	, { id: 'rqprId', type: 'number', defaultValue: ${inputData.rqprId} }
					, { id: 'exatCd' }
					, { id: 'exatNm' }
					/* , { id: 'exatMdul' } */
					, { id: 'mchnInfoId' }
					, { id: 'exatCaseQty', type: 'number' }
					, { id: 'exatDct', type: 'number' }
					, { id: 'exatExp' }
					, { id: 'exatExpView' }
					, { id: 'exatStrtDt' }
					, { id: 'exatFnhDt' }
					, { id: 'exatWay' }
                ]
            });

            spaceRqprExatDataSet.on('load', function(e) {
            	//alert( spaceRqprExatDataSet.getNameValue(0, 'rqprExatId') );
            	if(Rui.isNumber(spaceRqprExatDataSet.getNameValue(0, 'rqprExatId'))) {
            		spaceRqprExatTreeView.setFocusById(spaceRqprExatDataSet.getNameValue(0, 'exatCd'));
            	} else {
            		spaceRqprExatDataSet.clearData();
            		spaceRqprExatDataSet.newRecord();
            	}
            });

            bind = new Rui.data.LBind({
                groupId: 'fieldWrapper',
                dataSet: spaceRqprExatDataSet,
                bind: true,
                bindInfo: [
                    { id: 'exatNm',				ctrlId:'exatNm',			value:'html'},
                    /* { id: 'exatMdul',			ctrlId:'exatMdul',			value:'value'}, */
                    { id: 'mchnInfoId',			ctrlId:'mchnInfoId',		value:'value'},
                    { id: 'exatCaseQty',		ctrlId:'exatCaseQty',		value:'value'},
                    { id: 'exatDct',			ctrlId:'exatDct',			value:'value'},
                    { id: 'exatExpView',		ctrlId:'exatExpView',		value:'html'},
                    { id: 'exatStrtDt',			ctrlId:'exatStrtDt',		value:'value'},
                    { id: 'exatFnhDt',			ctrlId:'exatFnhDt',			value:'value'},
                    { id: 'exatWay',			ctrlId:'exatWay',			value:'value'}
                ]
            });

            /* 평가의뢰 실험결과 정보 저장 */
            save = function(type) {
            	var treeRow = spaceRqprExatMstTreeDataSet.getRow();
            	var vm = spaceRqprExatMstTreeDataSet.getNameValue(treeRow, 'expCrtnScnCd') == '1' ? vm1 : vm2;

                if (vm.validateDataSet(spaceRqprExatDataSet, spaceRqprExatDataSet.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[spaceRqprExatDataSet],
                        url:'<c:url value="/space/saveSpaceRqprExat.do"/>'
                    });
            	}
            };

	    	dm.loadDataSet({
                dataSets: [spaceRqprExatMstTreeDataSet, spaceRqprExatDataSet],
                url: '<c:url value="/space/getSpaceRqprExatInfo.do"/>',
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
   						<button type="button" class="btn"  id="closeBtn" name="closeBtn" onclick="parent.spaceRqprExatRsltDialog.cancel()">닫기</button>
   					</div>
   				</div>

			    <div id="bd" class="tree_wrap01">
			        <div class="LblockMarkupCode">
			            <div id="contentWrapper">
			                <div id="spaceRqprExatTreeView"></div>
			            </div>
			            <div id="fieldWrapper">
			   				<table class="table table_txt_right">
			   					<colgroup>
			   						<col style="width:24%;"/>
			   						<col style="width:76%;"/>
			   					</colgroup>
			   					<tbody>
			   						<tr>
			   							<th align="right">실험명</th>
			   							<td><span id="exatNm"/></td>
			   						</tr>
			   						<tr>
			   							<th align="right">평가TOOL</th>
			   							<td><div id="mchnInfoId"></div></td>
			   						</tr>
			   						<!-- 사용안함 <tr>
			   							<th align="right">평가모듈</th>
			   							<td><input type="text" id="exatMdul"></td>
			   						</tr> -->
			   						<tr>
			   							<th align="right">평가<br/>케이스수</th>
			   							<td><input type="text" id="exatCaseQty"></td>
			   						</tr>
			   						<tr>
			   							<th align="right">평가일수</th>
			   							<td><input type="text" id="exatDct"></td>
			   						</tr>
			   						<tr>
			   							<th align="right">평가수가</th>
			   							<td><span id="exatExpView"/></td>
			   						</tr>
			   						<tr>
			   							<th align="right">평가기간</th>
			   							<td>
			   								<input type="text" id="exatStrtDt"/><em class="gab"> ~ </em>
			   								<input type="text" id="exatFnhDt"/>
			   							</td>
			   						</tr>
			   						<tr>
			   							<th align="right">평가방법</th>
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