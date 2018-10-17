<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
                 java.util.*,
                 devonframe.util.NullUtil,
                 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id      : deptSearchPopup.jsp
 * @desc    : 부서 조회 공통 팝업
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2016.07.25  민길문      최초생성
 * ---  ----------- ----------  -----------------------------------------
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript">

    Rui.onReady(function() {
        /*******************
         * 변수 및 객체 선언
         *******************/
        var upperDeptNm = new Rui.ui.form.LTextBox({
             applyTo : 'upperDeptNm',
             placeholder : '검색할 조직명을 입력해주세요.',
             defaultValue : '',
             emptyValue: '',
             width : 230
        });

        upperDeptNm.on('blur', function(e) {
            upperDeptNm.setValue(upperDeptNm.getValue().trim());
        });

        upperDeptNm.on('keypress', function(e) {
            if(e.keyCode == 13) {
                getDeptList();
            }
        });

        var textBox = new Rui.ui.form.LTextBox({
            emptyValue: ''
        });

        var useYn = new Rui.ui.form.LRadioGroup({
            gridFixed: true,
            autoMapping: true,
            valueField: 'value',
            displayField: 'label',
            items:[
                {
                    label : 'Y',
                    value:'Y',
                    checked:true
                },
                {
                    label : 'N',
                    value:'N'

                }
            ]
        });


        /*******************
         * 변수 및 객체 선언
        *******************/
        var deptDataSet = new Rui.data.LJsonDataSet({
            id : 'deptDataSet',
            remainRemoved : true,
            lazyLoad : true,
            fields : [
                  { id : 'upperDeptCd'}
                , { id : 'upperDeptNm'}
                , { id : 'deptName'}
                , { id : 'deptCode'}
                , { id : 'deptUperCodeA'}
                , { id : 'useYn'}
            ]
        });
        deptDataSet.load({
            url : '<c:url value="/system/dept/retrieveUpperDeptList.do"/>',
            params : {
                task : '${inputData.task}',
                upperDeptNm : encodeURIComponent(upperDeptNm.getValue())
            }
        });
        var deptColumnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns : [
                  { id: 'group1',label : '조직' }
                , { field : 'upperDeptNm', groupId: 'group1',   label : '조직명',   align :'center',    width : 200 }
                , { field : 'upperDeptCd', groupId: 'group1',   label : '조직코드', align :'center',    width : 120 }
                , { id: 'group2',label : '부서' }
                , { field : 'deptName', label : '부서명',       groupId: 'group2',  align :'center',    width : 260 }
                , { field : 'deptCode', label : '부서코드',     groupId: 'group2',  align :'center',    width : 120 }
                , { field : 'deptUperCodeA',label : '조직코드약어', align :'center', width : 120 , editor: textBox ,renderer: function(val, p, record){
                            if(!Rui.isEmpty(record.get('deptCode'))){ //부서
                                if(!Rui.isEmpty(val)){
                                    if(val.length >2){
                                        Rui.alert(record.get('upperDeptCd') + " 부서코드의 약어코드는 2자 입니다.");
                                        return "";
                                    }
                                }
                            }else{
                                if(!Rui.isEmpty(val)){ //조직
                                    if(val.length>1){
                                        Rui.alert( record.get('deptCode') + " 조직코드의 약어코드는 1자 입니다.");
                                        return val;
                                    }
                                }
                            }
                        return val;
                }}
                , { field : 'useYn',label : '사용여부', align :'center', width : 120 , editor: useYn
                    , renderer: function(v) {
                        if(v == null) {
                            return 'Y';
                        } else {
                             return v;
                        }
                     }
                }
            ]
        });

        var deptGrid = new Rui.ui.grid.LGridPanel({
            columnModel : deptColumnModel,
            dataSet : deptDataSet,
            width : 600,
            height : 400,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        deptGrid.render('deptGrid');

        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = deptDataSet.getReadData(e);

            Rui.alert(data.records[0].rtVal);

            if(data.records[0].rtCd == "SUCCESS") {
                getDeptList();
            }
        });
        dm.on('failure', function(e) {
            var data = deptDataSet.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });


        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'deptUperCodeA', validExp: '약어코드:true:minLength=1:maxLength=2' }
            ]
        });


        /**
        총 건수 표시
        **/
        deptDataSet.on('load', function(e) {
            var seatCnt = 0;
            var sumOrd = 0;
            var sumMoOrd = 0;
            var tmp;
            var tmpArray;
            var str = "";
            document.getElementById("cnt_text").innerHTML = '총: '+deptDataSet.getCount();
            // 목록 페이징
	    	paging(deptDataSet,"deptGrid");
        });


        <%--/*******************************************************************************
        * FUNCTION 명 : getDeptList
        * FUNCTION 기능설명 : 조회
        *******************************************************************************/--%>
        getDeptList = function() {
            deptDataSet.load({
                url : '<c:url value="/system/dept/retrieveUpperDeptList.do"/>',
                params : {
                    task : '${inputData.task}',
                    upperDeptNm : encodeURIComponent(upperDeptNm.getValue())
                }
            });
        };


        <%--/*******************************************************************************
        * FUNCTION 명 : validation
        * FUNCTION 기능설명 : 입력값 점검
        *******************************************************************************/--%>
        function validation(){
            if(!vm.validateGroup($('aform'))){
                Rui.alert({
                    text: vm.getMessageList().join('<br/>'),
                    width: 380
                });
                return false;
            }
            return true;
        }


        <%--/*******************************************************************************
        * FUNCTION 명 : btnSave
        * FUNCTION 기능설명 : 저장
        *******************************************************************************/--%>
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {

            if(!deptDataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                 dm.updateDataSet({
                     url:'<c:url value="/system/dept/insertUpperDeptCdASave.do"/>',
                     dataSets:[deptDataSet]
                 });
                },
                handlerNo: Rui.emptyFn
            });
        });

       <%--/*******************************************************************************
        * FUNCTION 명 : fnExcel
        * FUNCTION 기능설명 :excel 다운로드
        *******************************************************************************/--%>
       fnExcel = function() {
	        // 엑셀 다운로드시 전체 다운로드를 위해 추가
	       	deptDataSet.clearFilter();

	       	if(deptDataSet.getCount() > 0 ) {
	       		var excelColumnModel = columnModel.createExcelColumnModel(false);
	       		duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('실험정보_') + new Date().format('%Y%m%d') + '.xls');

	       	}else{
	       		Rui.alert("리스트 건수가 없습니다.");
	       		return;
	       	}
	       	// 목록 페이징
	        paging(deptDataSet,"deptGrid");
       };
    });
</script>
    </head>
    <body>
    <form name="aform" id="aform" method="post" onSubmit="return false;">
    </form>
        <div class="contents">
            <div class="titleArea">
            	<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
                <h2>조직코드약어관리</h2>
            </div>
            <div class="sub-content">

                <div class="search">
					<div class="search-content">
		   				<table>
		                    <colgroup>
		                        <col style="width:120px;"/>
		                        <col style="width:*"/>
		                        <col style="width:15%;"/>
		                    </colgroup>
		                    <tbody>
		                        <tr>
		                            <th align="right">조직</th>
		                            <td>
		                                <input type="text" id="upperDeptNm" value="">
		                            </td>
		                            <td class="txt-right">
		                                <a style="cursor: pointer;" onclick="getDeptList();" class="btnL">검색</a>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
	                </div>
                </div>


                <div class="titArea">
                    <span class="Ltotal" id="cnt_text">총 : 0 </span>
                    <div class="LblockButton">
                        <button type="button" onclick="javascript:fnExcel()">Excel다운로드</button>
                    </div>
                </div>
                 <div id="deptGrid"></div>

                <div class="LblockButton btn_btn">
                    <button type="button" id="btnSave" name="btnSave" class="redBtn" >저장</button>
                </div>
            </div><!-- //sub-content -->


        </div><!-- //contents -->

    </body>
</html>