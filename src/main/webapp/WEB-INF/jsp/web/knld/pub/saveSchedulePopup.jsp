<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: saveSchedulePopup.jsp
 * @desc    : 연구소 주요일정 저장 팝업
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
                var data = parent.dayDataSet.getReadData(e);
                
                alert(data.records[0].resultMsg);
                
                if(data.records[0].resultYn == 'Y') {
                	parent.getDayScheduleList();
                	parent.getMonthScheduleList(parent.aform.adscMonth.value);
                	parent.scheduleDetailDialog.cancel();
                }
            });
            
            var adscTitl = new Rui.ui.form.LTextBox({
                applyTo: 'adscTitl',
                placeholder: '제목을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                width: 650
            });
            
            var adscSbc = new Rui.ui.form.LTextArea({
                applyTo: 'adscSbc',
                placeholder: '설명을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                width: 650,
                height: 200
            });
            
            var adscDt = new Rui.ui.form.LDateBox({
				applyTo: 'adscDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '',
				editable: false,
				width: 100,
				dateType: 'string'
			});

            adscDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(adscDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					adscDt.setValue(new Date());
				}
				
				if(repeatYn.isChecked()) {
					if( adscDt.getValue() > toAdscDt.getValue() ) {
						alert('시작일이 종료일보다 클 수 없습니다.!!');
						adscDt.setValue(toAdscDt.getValue());
					}
            	}
			});

            var toAdscDt = new Rui.ui.form.LDateBox({
				applyTo: 'toAdscDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '',
				editable: false,
				disabled: true,
				width: 100,
				dateType: 'string'
			});
			 
			toAdscDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toAdscDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					toAdscDt.setValue(new Date());
				}
				
				if( adscDt.getValue() > toAdscDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					adscDt.setValue(toAdscDt.getValue());
				}
			});
			
            var repeatYn = new Rui.ui.form.LCheckBox({
                applyTo: 'repeatYn',
                label: '반복',
            <c:if test="${inputData.labtAdscId != ''}">
            	disabled: true,
            </c:if>
                value: 'Y'
            });
            
            repeatYn.on('changed', function(e){
            	if(repeatYn.isChecked()) {
                	toAdscDt.enable();
            	} else {
                	toAdscDt.disable();
            	}
            });
            
            var adscKindCd = new Rui.ui.form.LCombo({
                applyTo: 'adscKindCd',
                name: 'adscKindCd',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ADSC_KIND_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
            
            var vm1 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'adscTitl',		validExp: '제목:true:maxByteLength=100' },
                { id: 'adscKindCd',		validExp: '일정구분:true' },
                { id: 'adscDt',			validExp: '일정일:true' },
                { id: 'adscStrtTim',	validExp: '일정시작시간:true' },
                { id: 'adscStrtMinu',	validExp: '일정시작분:true' },
                { id: 'adscFnhTim',		validExp: '일정종료시간:true' },
                { id: 'adscFnhMinu',	validExp: '일정종료분:true' },
                { id: 'adscSbc',		validExp: '설명:true:maxByteLength=1000' }
                ]
            });
            
            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'adscTitl',		validExp: '제목:true:maxByteLength=100' },
                { id: 'adscKindCd',		validExp: '일정구분:true' },
                { id: 'adscDt',			validExp: '반복일정 시작일:true' },
                { id: 'toAdscDt',		validExp: '반복일정 종료일:true' },
                { id: 'adscStrtTim',	validExp: '일정시작시간:true' },
                { id: 'adscStrtMinu',	validExp: '일정시작분:true' },
                { id: 'adscFnhTim',		validExp: '일정종료시간:true' },
                { id: 'adscFnhMinu',	validExp: '일정종료분:true' },
                { id: 'adscSbc',		validExp: '설명:true:maxByteLength=1000' }
                ]
            });
            
            scheduleDataSet = new Rui.data.LJsonDataSet({
                id: 'scheduleDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'labtAdscId', defaultValue: '' }
                	, { id: 'adscKindCd' }
					, { id: 'adscDt' }
					, { id: 'toAdscDt' }
					, { id: 'adscStrtTim' }
					, { id: 'adscStrtMinu' }
					, { id: 'adscFnhTim' }
					, { id: 'adscFnhMinu' }
					, { id: 'labtAdscGroupId' }
					, { id: 'adscTitl' }
					, { id: 'adscSbc' }
					, { id: 'repeatYn' }
                ]
            });
            
            scheduleDataSet.on('load', function(e) {
            	scheduleDataSet.setNameValue(0, 'toAdscDt', scheduleDataSet.getNameValue(0, 'adscDt'));
            });
        
            bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: scheduleDataSet,
                bind: true,
                bindInfo: [
                    { id: 'labtAdscId',			ctrlId:'labtAdscId',		value:'value'},
                    { id: 'adscTitl',			ctrlId:'adscTitl',			value:'value'},
                    { id: 'adscKindCd',			ctrlId:'adscKindCd',		value:'value'},
                    { id: 'repeatYn',			ctrlId:'repeatYn',			value:'value'},
                    { id: 'adscDt',				ctrlId:'adscDt',			value:'value'},
                    { id: 'toAdscDt',			ctrlId:'toAdscDt',			value:'value'},
                    { id: 'adscStrtTim',		ctrlId:'adscStrtTim',		value:'value'},
                    { id: 'adscStrtMinu',		ctrlId:'adscStrtMinu',		value:'value'},
                    { id: 'adscFnhTim',			ctrlId:'adscFnhTim',		value:'value'},
                    { id: 'adscFnhMinu',		ctrlId:'adscFnhMinu',		value:'value'},
                    { id: 'adscSbc',			ctrlId:'adscSbc',			value:'value'}
                ]
            });
            
            /* 저장 */
            save = function() {
            	var vm = repeatYn.isChecked() ? vm2 : vm1;
            	
                if (vm.validateGroup('aform') == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
                
            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        url:'<c:url value="/knld/schedule/saveSchedule.do"/>',
                        params: $("#aform").serialize()
                    });
            	}
            };
            
            if('<c:out value="${inputData.labtAdscId}"/>' != '') {
                scheduleDataSet.load({
                    url: '<c:url value="/knld/schedule/getScheduleInfo.do"/>',
                    params :{
                    	labtAdscId : '<c:out value="${inputData.labtAdscId}"/>'
                    }
                });
            } else {
            	var record = scheduleDataSet.getAt(scheduleDataSet.newRecord());
            	
            	record.set('adscDt', '<c:out value="${inputData.adscDt}"/>');
            	record.set('toAdscDt', '<c:out value="${inputData.adscDt}"/>');
            }
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="labtAdscId" name="labtAdscId" value=""/>
		
   		<div class="LblockMainBody">

   			<div>
   				
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save()">저장</button>
   						<button type="button" class="btn"  id="cancelBtn" name="cancelBtn" onclick="parent.scheduleDetailDialog.cancel()">닫기</button>
   					</div>
   				</div>
	   			
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:90px;"/>
   						<col style="width:290px;"/>
   						<col style="width:90px;"/>
   						<col style=""/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">제목</th>
   							<td colspan="3">
   								<input type="text" id="adscTitl">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">일정구분</th>
   							<td>
   								<div id="adscKindCd"></div>
   							</td>
   							<th align="right">옵션</th>
   							<td>
   								<input type="checkbox" id="repeatYn">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">일정일</th>
   							<td>
   								<input type="text" id="adscDt"/><em class="gab"> ~ </em>
   								<input type="text" id="toAdscDt"/>
   							</td>
   							<th align="right">일정시간</th>
   							<td>
   								<select id="adscStrtTim" name="adscStrtTim" style="width:55px;">
   									<option value="">선택</option>
   									<option value="00">00</option>
   									<option value="01">01</option>
   									<option value="02">02</option>
   									<option value="03">03</option>
   									<option value="04">04</option>
   									<option value="05">05</option>
   									<option value="06">06</option>
   									<option value="07">07</option>
   									<option value="08">08</option>
   									<option value="09">09</option>
   									<option value="10">10</option>
   									<option value="11">11</option>
   									<option value="12">12</option>
   									<option value="13">13</option>
   									<option value="14">14</option>
   									<option value="15">15</option>
   									<option value="16">16</option>
   									<option value="17">17</option>
   									<option value="18">18</option>
   									<option value="19">19</option>
   									<option value="20">20</option>
   									<option value="21">21</option>
   									<option value="22">22</option>
   									<option value="23">23</option>
   								</select> :
   								<select id="adscStrtMinu" name="adscStrtMinu" style="width:55px;">
   									<option value="">선택</option>
   									<option value="00">00</option>
   									<option value="05">05</option>
   									<option value="10">10</option>
   									<option value="15">15</option>
   									<option value="20">20</option>
   									<option value="25">25</option>
   									<option value="30">30</option>
   									<option value="35">35</option>
   									<option value="40">40</option>
   									<option value="45">45</option>
   									<option value="50">50</option>
   									<option value="55">55</option>
   								</select> ~ 
   								
   								<select id="adscFnhTim" name="adscFnhTim" style="width:55px;">
   									<option value="">선택</option>
   									<option value="00">00</option>
   									<option value="01">01</option>
   									<option value="02">02</option>
   									<option value="03">03</option>
   									<option value="04">04</option>
   									<option value="05">05</option>
   									<option value="06">06</option>
   									<option value="07">07</option>
   									<option value="08">08</option>
   									<option value="09">09</option>
   									<option value="10">10</option>
   									<option value="11">11</option>
   									<option value="12">12</option>
   									<option value="13">13</option>
   									<option value="14">14</option>
   									<option value="15">15</option>
   									<option value="16">16</option>
   									<option value="17">17</option>
   									<option value="18">18</option>
   									<option value="19">19</option>
   									<option value="20">20</option>
   									<option value="21">21</option>
   									<option value="22">22</option>
   									<option value="23">23</option>
   								</select> :
   								<select id="adscFnhMinu" name="adscFnhMinu" style="width:55px;">
   									<option value="">선택</option>
   									<option value="00">00</option>
   									<option value="05">05</option>
   									<option value="10">10</option>
   									<option value="15">15</option>
   									<option value="20">20</option>
   									<option value="25">25</option>
   									<option value="30">30</option>
   									<option value="35">35</option>
   									<option value="40">40</option>
   									<option value="45">45</option>
   									<option value="50">50</option>
   									<option value="55">55</option>
   								</select>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">설명</th>
   							<td colspan="3">
   								<textarea id="adscSbc"></textarea>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>