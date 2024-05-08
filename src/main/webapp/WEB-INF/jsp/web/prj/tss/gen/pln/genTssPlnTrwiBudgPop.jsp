<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
                 java.util.*,
                 devonframe.util.NullUtil,
                 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPlnTrwiBudgPop.jsp
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

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFrameDialog.css" />
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.css" />
<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>
<script type="text/javascript">
    var dataSet;
    var lvTssCd  = "${inputData.tssCd}";
    var lvUserId = "${inputData._userId}";
    var lvPgsStepCd = window.parent.lvPgsStepCd;
    var alTssCd = window.parent.alTssCd;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //구매년도
        var cboPurY = new Rui.ui.form.LCombo({
            name: 'cboPurY',
            rendererField: 'text',
            autoMapping: true,
            items:[
                <c:forEach var="purYy" items="${purYy}">
                { value: '${purYy.tssYy}', text: '${purYy.tssYy}'},
                </c:forEach>
            ]
        });

        //항목별 주요투자 세부내역
        var txaFpTxt = new Rui.ui.form.LTextArea({
            applyTo: 'fpTxt',
            placeholder: '',
            width: 500,
            height: 50,
            autoWidth: true
        });


        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'tbmstDataSet',
            remainRemoved: true, //삭제시 삭제건으로 처리하지 않고 state만 바꾼다.
            lazyLoad: true, //대량건의 데이터를 로딩할 경우 timer로 처리하여 ie에서 스크립트 로딩 메시지가 출력하지 않게 한다.
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id: 'tssCd' }       //과제코드
                , { id: 'purY' }        //구매년도
                , { id: 'cpsn', type:'number', defaultValue: 0 }        //인원
                , { id: 'ivst', type:'number', defaultValue: 0 }        //투자
                , { id: 'stufExp', type:'number', defaultValue: 0 }     //재료비
                , { id: 'qltyCku', type:'number', defaultValue: 0 }     //품질검사
                , { id: 'mkMdfy', type:'number', defaultValue: 0 }      //금영제작/수정
                , { id: 'fpTxt' }       //항목별 주요투자 세부내역
                , { id: 'psnnRisnPro', type:'number', defaultValue: 0 } //
                , { id: 'pceRisnPro', type:'number', defaultValue: 0 }  //
                , { id: 'userId' }
                , { id: 'frstRgstId' }
            ]
        });
        dataSet.on('load', function(e) {
            console.log("tbmst load DataSet Success");

            //예산생성 후
            if(e.target.data.items[0].data.rtCd == "C") {
                parent.fn_refresh();
                parent.tbNewDialog.cancel(true);
            }
        });


        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'purY', label: '<span style=color:red>*</span> 구매년도', sortable: false, align:'center', width: 100, editor: cboPurY, renderer: function(value, p, record, row, col) {
                    if(record.state == 1) p.editable = true;
                    else p.editable = false;
                    return value;
                } }
                , { field: 'cpsn', label: '<span style=color:red>*</span> 인원', sortable: false, align:'center', width: 100, editor: new Rui.ui.form.LNumberBox }
                , { field: 'ivst', label: '투자', sortable: false, align:'right', width: 100, editor: new Rui.ui.form.LNumberBox }
                , { field: 'stufExp', label: '재료비', sortable: false, align:'right', width: 100, editor: new Rui.ui.form.LNumberBox }
                , { field: 'qltyCku', label: '품질검사', sortable: false, align:'right', width: 100, editor: new Rui.ui.form.LNumberBox }
                , { field: 'mkMdfy', label: '금영제작/수정', sortable: false, align:'right', width: 100, editor: new Rui.ui.form.LNumberBox }
            ]
        });

        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 500,
            height: 120,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false,
            autoWidth: true
        });

        grid.render('defaultGrid');


        //폼에 출력
        var bind = new Rui.data.LBind({
            groupId: 'aform',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'fpTxt', ctrlId: 'fpTxt', value: 'value' }
            ]
        });


        //유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'tssCd',        validExp: '과제코드:false' }
                , { id: 'purY',         validExp: '구매년도:true' }
                , { id: 'cpsn',         validExp: '인원:true:minNumber=1' }
                , { id: 'ivst',         validExp: '투자:false' }
                , { id: 'stufExp',      validExp: '재료비:false' }
                , { id: 'qltyCku',      validExp: '품질검사:false' }
                , { id: 'mkMdfy',       validExp: '금영제작/수정:false' }
                , { id: 'fpTxt',        validExp: '항목별 주요투자 세부내역:false' }
                , { id: 'psnnRisnPro',  validExp: ':false' }
                , { id: 'pceRisnPro',   validExp: ':false' }
                , { id: 'userId',       validExp: ':false' }
            ]
        });


        //서버전송
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);

            if(data.records[0].rtCd == "SUCCESS") {
                Rui.alert(data.records[0].rtVal);
            }
            //예산생성 후
            else if(data.records[0].rtCd == "C") {
                parent.fn_refresh();
                parent.tbNewDialog.cancel(true);
            }
            else {
                Rui.alert(data.records[0].rtVal);
                fn_search();
            }
        });
        dm.on('failure', function(e) {
            var data = dataSet.getReadData(e);
            Rui.alert(data.records[0].rtVal);
        });



        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //조회
        fn_search = function() {
            dataSet.load({
                url:'<c:url value="/prj/tss/gen/retrieveGenTssPlnTrwiBudgMst.do"/>',
                params : {
                    tssCd : lvTssCd
                    , pgsStepCd: lvPgsStepCd
                    , alTssCd: alTssCd
                }
            });
        };

        //생성
        fn_create = function() {
            Rui.confirm({
                text: dataSet.isUpdated() == true ? '저장되지 않은 데이터가 있습니다.<br/>투입예산을 생성하시겠습니까?' : '투입예산을 생성하시겠습니까?',
                handlerYes: function() {
                    var pUrl;
                    if(lvPgsStepCd == "AL") pUrl = '<c:url value="/prj/tss/gen/insertGenTssAltrTrwiBudg.do"/>'+'?tssCd='+lvTssCd+'&userId='+lvUserId;
                    else pUrl = '<c:url value="/prj/tss/gen/insertGenTssPlnTrwiBudg.do"/>'+'?tssCd='+lvTssCd+'&userId='+lvUserId;
                    
//                     dataSet.load({
//                         url: pUrl,
//                         params : {
//                             tssCd : lvTssCd,
//                             userId : lvUserId
//                         }
//                     });
                    
                    dm.updateDataSet({
                        url:pUrl,
                        dataSets:[dataSet]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        };

        //저장
        fn_save = function() {
            if(!dataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }

            if(!vm.validateDataSet(dataSet, dataSet.getRow())) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
                return false;
            }

            //pk중복체크
            var errCd = false;
            for(var i = 0; i < dataSet.getCount(); i++) {
                var fstYy = dataSet.getNameValue(i, "purY");

                for(var j = 0; j < dataSet.getCount(); j++) {
                    if(i != j && fstYy == dataSet.getNameValue(j, "purY")) {
                        errCd = true;
                        break;
                    }
                }
            }

            if(errCd) {
                Rui.alert("구매년도가 중복되었습니다.");
                return;
            }

            Rui.confirm({
                text: '저장하시겠습니까?',
                handlerYes: function() {
                    dm.updateDataSet({
                        url:'<c:url value="/prj/tss/gen/updateGenTssPlnTrwiBudgMst.do"/>',
                        dataSets:[dataSet]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        };


        //추가
        fn_recordNew = function() {
            var row = dataSet.newRecord();
            var record = dataSet.getAt(row);

            record.set("tssCd",  lvTssCd);
            record.set("userId", lvUserId);
        };


        //삭제
        fn_recordDel = function() {
            Rui.confirm({
                text: Rui.getMessageManager().get('$.base.msg107'),
                handlerYes: function() {
                    //실제 DB삭제건이 있는지 확인
                    var dbCallYN = false;
                    var chkRows = dataSet.getMarkedRange().items;
                    for(var i = 0; i < chkRows.length; i++) {
                        if(stringNullChk(chkRows[i].data.frstRgstId) != "") {
                            dbCallYN = true;
                            break;
                        }
                    }
                    
                    if(dataSet.getMarkedCount() > 0) {
                        dataSet.removeMarkedRows();
                    } else {
                        var row = dataSet.getRow();
                        if(row < 0) return;                        
                        dataSet.removeAt(row);
                    }
                    
                    if(dbCallYN) {
                        //삭제된 레코드 외 상태 정상처리
                        for(var i = 0; i < dataSet.getCount(); i++) {
                            if(dataSet.getState(i) != 3) dataSet.setState(i, Rui.data.LRecord.STATE_NORMAL);
                        }
                        
                        dm.updateDataSet({
                            url:'<c:url value="/prj/tss/gen/deleteGenTssPlnTrwiBudgMst.do"/>',
                            dataSets:[dataSet]
                        });
                    }
                },
                handlerNo: Rui.emptyFn
            });
        };


        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("tbmst searchData1");
            dataSet.loadData(${result});
        } else {
            console.log("tbmst searchData2");
        }
    });
</script>
</head>
<body>
<form name="aform" id="aform" method="post" onSubmit="return false;">
    <div class="LblockMainBody">
		<div class="titArea">
	        <font style="color:red;">※'구매년도' ,'인원' 항목만 입력하셔도 투입예산 생성이 가능합니다.</font> &nbsp;<font style="color:red;font-weight:bold;">(단위 : 백만원)</font>&nbsp;
			<div class="LblockButton">
				<button type="button" id="butRecordNew" onclick="fn_recordNew();">추가</button>
				<button type="button" id="butRecordDel" onclick="fn_recordDel();">삭제</button>
				<button type="button" id="btnSave" name="btnSave" onclick="fn_save();">저장</button>
				<button type="button" id="btnCreate" name="btnCreate" onclick="fn_create();">생성</button>
			</div>
		</div>
	    
	    <div id="defaultGrid"></div>
	    <br/>
	    
	    <table class="table table_txt_right">
	        <colgroup>
	            <col style="width:20%;"/>
	            <col style="width:*"/>
	         </colgroup>
	         <tbody>
	             <tr>
	                 <th align="right">항목별주요투자<br/>세부내역</th>
	                 <td style="padding-top:7px;">
	                     <input type="textarea" id="fpTxt" value="">
	                 </td>
	             </tr>
	             <tr>
	                 <td colspan="2" style="padding:10px">
	                     * 인원 - 연차별 월평균 투입인원을 소수점 첫째자리까지 표기<br/>    
						 * 투자 - 기계장치, 공구기구등 투자예산으로 진행되는 자산 구입비용<br/>  
						 * 재료비 - 재료비 중 연 3,000만원 이상 발생 시 <br/>
						 * 품질검사 - 성분분석, sample 제작 비용 등, 연 3,000만원 이상 발생 시<br/>    
						 * 금형제작/수정 - 연 3,000만원 이상 발생 시<br/>
	                 </td>
	             </tr>
	         </tbody>
	     </table>
     </div>
</form>
</body>
</html>
