<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : trwiBudgDtlPopup.jsp
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

<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var dataSet;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //년도
        var budgYY = new Rui.ui.form.LCombo({
            applyTo: 'budgYY',
            id: 'budgYY',
            url: '<c:url value="/prj/tss/gen/retrieveGenTssGoalYy.do"/>',
            displayField: 'goalYy',
            valueField: 'goalYy',
            rendererField: 'goalYy',
            autoMapping: true
        });
        budgYY.getDataSet().on('load', function(e) {
            budgYY.setValue('${inputData.yy}');
        });
        budgYY.on('changed', function(e){
            psnnRisnPro.setValue("");
            pceRisnPro.setValue("");
            fnSearch();
        });

        var psnnRisnPro = new Rui.ui.form.LNumberBox({
            applyTo: 'psnnRisnPro',
            defaultValue: '',
            emptyValue: '',
            minValue: 0,
            maxValue: 99999.99,
            decimalPrecision: 2,
            width: 100
        });

        var pceRisnPro = new Rui.ui.form.LNumberBox({
            applyTo: 'pceRisnPro',
            defaultValue: '',
            emptyValue: '',
            minValue: 0,
            maxValue: 99999.99,
            decimalPrecision: 2,
            width:  100
        });

        var textBox = new Rui.ui.form.LTextBox({
            emptyValue: ''
        });

        var numberBox = new Rui.ui.form.LNumberBox({
            emptyValue: '',
            minValue: 0,
            maxValue: 99999.99
        });

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/

        //서버전송용
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);

            Rui.alert(data.records[0].rtVal);

            if(data.records[0].rtCd == "SUCCESS") {
               fnSearch();
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });

        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'budgYY',      validExp: '년도:true' },
                  { id: 'pceRisnPro',  validExp: '물가상승율:true' },
                  { id: 'psnnRisnPro', validExp: '인건비상승율:true' },
            ]
        });

        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
                  { id:'yy' }   //비용구분 코드
                , { id:'psnnRisnPro' }  //인건비상승율
                , { id:'pceRisnPro' }   //물가상승율
                , { id:'expScnCd' }     //비용구분 코드
                , { id:'lgExpScnNm' }   //비용구분 명
                , { id:'expScnNm' }     //비용구분 명
                , { id:'mmExp' }     //총구분

            ]
        });
        dataSet.on('load', function(e) {
            psnnRisnPro.setValue(dataSet.getNameValue(0, "psnnRisnPro"));
            pceRisnPro.setValue(dataSet.getNameValue(0, "pceRisnPro"));
        });

        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                     { field: 'lgExpScnNm',  label: '구분1', sortable: false, align:'center', width: 50 ,vMerge: true  }
                    ,{ field: 'expScnNm',  label: '구분2', sortable: false, align:'center', width: 60 ,vMerge: true }
                    ,{ field: 'mmExp',  label: '총합계', sortable: false, align:'right', width: 40 , editor: numberBox }
            ]
        });

        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 460,
            height: 380,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        grid.render('onePerBudgGrid');


        var bind = new Rui.data.LBind({
            groupId: 'LblockDetail01',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                { id: 'budgYY', ctrlId: 'yy', value: 'value' }
            ]
        });


        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/

        <%--/*******************************************************************************
         * FUNCTION 명 : btnReset
         * FUNCTION 기능설명 : 초기화
         *******************************************************************************/--%>
//         var btnReset = new Rui.ui.LButton('btnReset');
//         btnReset.on('click', function() {

//         });
         <%--/*******************************************************************************
          * FUNCTION 명 : validation
          * FUNCTION 기능설명 : 입력값 점검
          *******************************************************************************/--%>
          function validation(){
            if(!vm.validateGroup($('xForm'))){
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

            if(!validation()) return false;

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {

                    var param = jQuery("#xForm").serialize().replace(/%/g,'%25');

                    dm.updateDataSet({
                        url:'<c:url value="/prj/mgmt/trwiBudg/insertTrwiBudgSave.do"/>',
                        dataSets:[dataSet],
                        params:param
                    });

                },
                handlerNo: Rui.emptyFn
            });

          });

        <%--/*******************************************************************************
         * FUNCTION 명 :  grid 삭제
         * FUNCTION 기능설명 : data 삭제
         *******************************************************************************/--%>

        /* [버튼] 삭제 */
        var btnDel = new Rui.ui.LButton('btnDel');
        btnDel.on('click', function() {
            Rui.confirm({
                text: Rui.getMessageManager().get('$.base.msg107'),
                handlerYes: function() {
                        var param = jQuery("#xForm").serialize().replace(/%/g,'%25');
                        dm.updateDataSet({
                            url:'<c:url value="/prj/mgmt/trwiBudg/deleteTrwiBudg.do"/>',
                            params:param
                        });

                },
                handlerNo: Rui.emptyFn
            });
        });


        <%--/*******************************************************************************
         * FUNCTION 명 : fnSearch
         * FUNCTION 기능설명 : 조회
         *******************************************************************************/--%>
     var fnSearch = function(){
         dataSet.load({
             url: "<c:url value='/prj/mgmt/trwiBudg/retrieveTrwiBudgDtl.do'/>"
           , params : {
                 yy : budgYY.getValue()
             }
         });
     }

     fnSearch();
   });


</script>

</head>
<body id="LblockBody">
<div id="formDiv">
        <div id="LblockMainBody">
            <!-- 컨텐츠 영역 -->


                <div class="sub-content">
                        <form name="xForm" id="xForm" method="post">
                                <div class="titArea" style="padding-top:0">
                                    <div class="LblockButton">
                                        <button type="button" id="btnSave" name="btnSave" >저장</button>
                                        <button type="button" id="btnDel" name="btnDel" >삭제</button>
                                    </div>
                                </div>

                                <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
                                <div id="LblockDetail01" >
                                <table class="table table_txt_right" >
                                    <colgroup>
                                        <col style="width:20%;"/>
                                        <col style="width:30%;"/>
                                        <col style="width:20%;"/>
                                        <col style="width:30%;"/>
                                        <col style="width:10%;"/>
                                    </colgroup>
                                    <tbody>
	                                    <tr>
	                                        <th align="right">년도</th>
	                                        <td colspan=3>
	                                           <div id="budgYY" ></div>
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th align="right">인건비상승율</th>
	                                        <td>
	                                            <input type="text" id="psnnRisnPro">
	
	                                        </td>
	                                        <th align="right">물가상승율</th>
	                                        <td>
	                                            <input type="text" id="pceRisnPro">
	
	                                        </td>
	                                    </tr>
                                    </tbody>
                                </table>
                             </div>
                        </form>
                      </div>

                                <div id="onePerBudgGrid" style="margin-top:10px"></div>


        </div>
</div>


</body>
</html>