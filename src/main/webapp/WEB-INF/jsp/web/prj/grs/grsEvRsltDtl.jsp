<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : grsEvRslt.jsp
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">
    var gvCallPageId;
    var gvTssCd  = "";
    var gvUserId = "${inputData._userId}";
    var gvTssSt  = "";
    var tssSt    = "${inputData.tssSt}";

    var dataSet;
    var todoYN = stringNullChk("${inputData.LOGIN_SYS_CD}") != "" ? true : false;
    var pageMode;

    Rui.onReady(function() {
        var isInsert = false;
        var form = new Rui.ui.form.LForm('mstForm');


        var cfrnAtdtCdTxtNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'cfrnAtdtCdTxtNm',
            width: 600,
            editable: false,
            placeholder: '회의참석자를 입력해주세요.',
            emptyValue: '',
            enterToPopup: true
        });


        var evTitl = new Rui.ui.form.LTextBox({
            applyTo: 'evTitl',
            placeholder: '회의일정/장소을 입력해주세요.',
            emptyValue: '',
            width: 600
       });


        var commTxt = new Rui.ui.form.LTextArea({
            applyTo: 'commTxt',
            placeholder: '회의내용을 입력해 주세요',
            emptyValue: '',
            width: 600,
            height: 100
       });

        var textBox = new Rui.ui.form.LTextBox({
            emptyValue: ''
        });

        var numberBox = new Rui.ui.form.LNumberBox({
            emptyValue: '',
            minValue: 0,
            maxValue: 99999
        });

        //Form 비활성화
        disableFields = function() {
            if(todoYN) btnList.hide();

            if(pageMode == "W") return;

            //btnEvCompl.hide();

            listGrid.setEditable(false);
        };



        /* [DataSet] 설정 */
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }            //과제코드
                , { id: 'tssCdSn' }          //과제코드
                , { id: 'userId' }           //로그인ID
                , { id: 'prjNm' }            //프로젝트명
                , { id: 'bizDptCd' }         //과제유형
                , { id: 'bizDptNm' }         //과제유형
                , { id: 'tssAttrCd' }        //과제속성
                , { id: 'tssAttrNm' }        //과제속성
                , { id: 'tssNm' }            //과제명
                , { id: 'grsEvSt' }          //심의단계
                , { id: 'grsEvStNm' }        //심의단계
                , { id: 'grsEvSn' }          //평가표
                , { id: 'grsEvSnNm' }        //평가표
                , { id: 'dlbrParrDt' }       //심의예정일
                , { id: 'dlbrCrgr' }         //심의담당자
                , { id: 'dlbrCrgrNm' }       //심의담당자
                , { id: 'evTitl' }           //평가제목
                , { id: 'cfrnAtdtCdTxt' }    //회의참석자코드
                , { id: 'cfrnAtdtCdTxtNm' }  //회의참석자코드
                , { id: 'commTxt' }          //Comments
                , { id: 'attcFilId' }        //첨부파일
                , { id: 'tssRoleType' }
                , { id: 'tssRoleId' }
                , { id: 'saveYN' }
            ]
        });

        dataSet.on('load', function(e) {
            pageMode = dataSet.getNameValue(0, "tssRoleId") == "TR05" || dataSet.getNameValue(0, "saveYN") == "Y" ? "R" : "W";
            
            if(dataSet.getNameValue(0, 'dlbrCrgr') == '${inputData._userSabun}'){
            	btnEvCompl.show();
            }else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
            	btnEvCompl.show();
            }else{
            	btnEvCompl.hide();
            }
            
            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

            $("#prjNmDiv").text(dataSet.getNameValue(0, "prjNm"));
            $("#bizDptNmDiv").text(dataSet.getNameValue(0, "bizDptNm"));

            var tssAttrNm = dataSet.getNameValue(0, "tssAttrNm");

            if(tssAttrNm == undefined)tssAttrNm = "기술";
            $("#tssAttrNmDiv").text(tssAttrNm);
            $("#tssNmDiv").text(dataSet.getNameValue(0, "tssNm"));
            $("#grsEvStNmDiv").text(dataSet.getNameValue(0, "grsEvStNm"));
            $("#grsEvSnNmDiv").text(dataSet.getNameValue(0, "grsEvSnNm"));
            $("#dlbrParrDtDiv").text(dataSet.getNameValue(0, "dlbrParrDt"));
            $("#dlbrCrgrNmDiv").text(dataSet.getNameValue(0, "dlbrCrgrNm"));


            disableFields();
            fnDtlLstInfo();
        });

        dataSet.loadData(${result});



        /* [DataSet] 폼에 출력 */
        var bind = new Rui.data.LBind({
            groupId: 'mstFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                , { id: 'tssCdSn',          ctrlId: 'tssCdSn',          value: 'value' }
                , { id: 'prjNm',            ctrlId: 'prjNm',            value: 'value' }
                , { id: 'bizDptNm',         ctrlId: 'bizDptNm',         value: 'value' }
                , { id: 'tssAttrCd',        ctrlId: 'tssAttrCd',        value: 'value' }
                , { id: 'tssAttrNm',        ctrlId: 'tssAttrNm',        value: 'value' }
                , { id: 'tssNm',            ctrlId: 'tssNm',            value: 'value' }
                , { id: 'grsEvSt',          ctrlId: 'grsEvSt',          value: 'value' }
                , { id: 'grsEvStNm',        ctrlId: 'grsEvStNm',        value: 'value' }
                , { id: 'grsEvSn',          ctrlId: 'grsEvSn',          value: 'value' }
                , { id: 'grsEvSnNm',        ctrlId: 'grsEvSnNm',        value: 'value' }
                , { id: 'dlbrParrDt',       ctrlId: 'dlbrParrDt',       value: 'value' }
                , { id: 'dlbrCrgr',         ctrlId: 'dlbrCrgr',         value: 'value' }
                , { id: 'dlbrCrgrNm',       ctrlId: 'dlbrCrgrNm',       value: 'value' }
                , { id: 'evTitl',           ctrlId: 'evTitl',           value: 'value' } //평가제목
                , { id: 'cfrnAtdtCdTxt',    ctrlId: 'cfrnAtdtCdTxt',    value: 'value' }//회의참석자서번
                , { id: 'cfrnAtdtCdTxtNm',  ctrlId: 'cfrnAtdtCdTxtNm',  value: 'value' }//회의참석자명
                , { id: 'commTxt',          ctrlId: 'commTxt',          value: 'value' }//Comments
                , { id: 'attcFilId',        ctrlId: 'attcFilId',        value: 'value' }//첨부파일
            ]
        });


        var gridDataSet = new Rui.data.LJsonDataSet({ //listGrid dataSet
            id: 'gridDataSet',
            //focusFirstRow: 0,
            lazyLoad: true,
            fields: [
                    { id: 'grsEvSn'},           //GRS 일련번호
                    { id: 'grsEvSeq'},          //평가STEP1
                    { id: 'evPrvsNm_1'},        //평가항목명1
                    { id: 'evPrvsNm_2'},        //평가항목명2
                    { id: 'evCrtnNm'},          //평가기준명
                    { id: 'evSbcTxt'},          //평가내용
                    { id: 'dtlSbcTitl_1'},      //상세내용1
                    { id: 'dtlSbcTitl_2'},      //상세내용2
                    { id: 'dtlSbcTitl_3'},      //상세내용3
                    { id: 'dtlSbcTitl_4'},      //상세내용4
                    { id: 'dtlSbcTitl_5'},      //상세내용5
                    { id: 'evScr', type: 'number' },              //평가점수 , defaultValue: 0
                    { id: 'wgvl' , type: 'number' },              //가중치
                    { id: 'calScr'  },          //환산점수
                    { id: 'grsY'},              //년도
                    { id: 'grsType'},           //유형
                    { id: 'evSbcNm'},           //템플릿명
                    { id: 'useYn'}              //사용여부
                    ]
        });

        gridDataSet.on('load', function(e) {
        	//환산점수 - 화면 로드 시
       		for(var i=0; i<gridDataSet.getCount(); i++){
        	   var evScr = gridDataSet.getNameValue(i, "evScr");
          	   var wgvl = gridDataSet.getNameValue(i, "wgvl");
          	   var val = evScr/5*wgvl ;
               var cal = Rui.util.LNumber.round(val, 1);

               if(evScr == null || evScr == ""){
            	   gridDataSet.setNameValue(i,"calScr", "");
                   continue;
               }
               if(!isNaN(cal)) {
            	   gridDataSet.setNameValue(i,"calScr", cal);
                   continue;
               }
            }
        });


        gridDataSet.on('update', function(e) {
            if(e.colId == "evScr") {
                if(e.value > 5) {
                    Rui.alert("평가점수는 5점이상을 입력할수 없습니다.");
                    gridDataSet.setNameValue(e.row, e.colId, "");
                    return;
                }
                if(e.value == ''){
                	gridDataSet.setNameValue(e.row, e.colId, "");
                	gridDataSet.setNameValue(e.row,"calScr", "");
                    return;
                }

                //환산점수 - 평가점수 입력 시
           		for(var i=0; i<gridDataSet.getCount(); i++){
            	   var evScr = gridDataSet.getNameValue(i, "evScr");
              	   var wgvl = gridDataSet.getNameValue(i, "wgvl");
                   var val = evScr/5*wgvl ;
                   var cal = Rui.util.LNumber.round(val, 1);

                   if(evScr == null || evScr == ""){
                	   gridDataSet.setNameValue(i,"calScr", "");
	                   continue;
                   }
                   if(!isNaN(cal)) {
                	   gridDataSet.setNameValue(i,"calScr", cal);
	                   continue;
                   }
                }
            }
        });


        var mGridColumnModel = new Rui.ui.grid.LColumnModel({  //listGrid column
            columns: [
                    { field: 'evPrvsNm_1',      label: '평가항목',   sortable: false, align:'center', width: 140, editable: false , vMerge: true},
                    { field: 'evPrvsNm_2',      label: '평가항목',   sortable: false, align:'center', width: 100, editable: false , vMerge: true},
                    { field: 'evCrtnNm',        label: '평가기준',   sortable: false, align:'center', width: 130, editable: false , vMerge: true},
                    { field: 'evSbcTxt',        label: '평가내용',   sortable: false, align:'left', width: 220  , editable: false },
                    { id: 'G1', label: '평가 기준및 배점' },
                    { field: 'dtlSbcTitl_1',   groupId: 'G1' , label: '5점',   sortable: false, align:'left', width: 82, editable: false},
                    { field: 'dtlSbcTitl_2',   groupId: 'G1' , label: '4점',   sortable: false, align:'left', width: 82, editable: false},
                    { field: 'dtlSbcTitl_3',   groupId: 'G1' , label: '3점',   sortable: false, align:'left', width: 82, editable: false},
                    { field: 'dtlSbcTitl_4',   groupId: 'G1' , label: '2점',   sortable: false, align:'left', width: 82, editable: false},
                    { field: 'dtlSbcTitl_5',   groupId: 'G1' , label: '1점',   sortable: false, align:'left', width: 82, editable: false},
                    { field: 'evScr',           label: '평가점수',    sortable: false, align:'center', width: 60   ,editor: numberBox, editable: true
//                         , renderer: function(value, p) {
//                             var chk = '<c:out value="${inputData.tssStNm}"/>'; //요청일 경우에만 validation check
//                             if(chk == 1) {
//                                 if(value > 5) {
// //                                     Rui.alert("평가점수는 5점이상을 입력할수 없습니다.");
// //                                     value = '';
//                                 }
//                                 return  value;
//                             }
//                             else {
//                                   if(todoYN) {
//                                       if(value > 5) {
// //                                         Rui.alert("평가점수는 5점이상을 입력할수 없습니다.");
// //                                         value = '';
//                                       }
//                                       return value;
//                                   }
//                                   else {
//                                       return value;
//                                   }
//                             }
//                         }
                    },
                    { field: 'wgvl',            label: '가중치',    sortable: false, align:'center', width: 45   , editable: false},
                    { field: 'calScr',          label: '환산점수',  sortable: false, align:'center', width: 60   , editable: false}
            ]
        });

        /* 합계 */

        var sumColumns = ['evScr', 'wgvl', 'calScr'];
        var summary = new Rui.ui.grid.LTotalSummary();
        summary.on('renderTotalCell', summary.renderer({
            label: {
                id: 'evPrvsNm_1',
                text: '합 계'
            },
            columns: {
                //evScr: { type: 'avg', renderer: function(val) { return Rui.util.LNumber.round(val, 2); } }
                //evScr: { type: 'sum', renderer: 'number' }  //평가점수 합계 삭제 요청 : 20171219
                 wgvl: { type: 'sum', renderer: 'number' }
                ,calScr: { type: 'sum', renderer: function(val) { return Rui.util.LNumber.round(val, 1); } }
            }
        }));


        var listGrid = new Rui.ui.grid.LGridPanel({ //listGrid
            columnModel: mGridColumnModel,
            dataSet: gridDataSet,
            height: 280,
            width: 600,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false,
            viewConfig: {
                plugins: [ summary ]
            }
        });

        listGrid.render('listGrid'); //listGrid render



        /* [DataSet] 서버전송용 */
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);

            Rui.alert(data.records[0].rtVal);

            if(data.records[0].rtCd == "FAIL") {
                dataSet.setState(0, 1);
            } else {
                fnDtlLstInfo();
                //btnEvCompl.hide();

                if(todoYN) {
//                     document.domain = "lghausys.com";
//                     parent.TodoCallBack();
                }
            }
        });


        /* [DataSet] 유효성 설정 */
        var vm1 = new Rui.validate.LValidatorManager({
            validators: [
            	{ id: 'evScr', validExp: '평가점수:true' } //minLength=1&maxLength=10 :number&minNumber=1&maxNumber=5
            ]
        });


       <%--/*******************************************************************************
        * 첨부파일
        *******************************************************************************/--%>
        var lvAttcFilId;
        /* [기능] 첨부파일 조회 */
        var attachFileDataSet = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet.on('load', function(e) {
            getAttachFileInfoList();
        });

        getAttachFileList = function() {
            attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                    attcFilId : lvAttcFilId
                }
            });
        };

        getAttachFileInfoList = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }

            setAttachFileInfo(attachFileInfoList);
        };

        getAttachFileId = function() {
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

            return lvAttcFilId;
        };
        setAttachFileInfo = function(attachFileList) {
            $('#attchFileView').html('');

            for(var i = 0; i < attachFileList.length; i++) {
                $('#attchFileView').append($('<a/>', {
                    href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                    text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                })).append('<br/>');
            }

            if(attachFileList.length > 0) {
                lvAttcFilId = attachFileList[0].data.attcFilId;
                dataSet.setNameValue(0, "attcFilId", lvAttcFilId)
            }
        };

		downloadAttachFile = function(attcFilId, seq) {
		    mstForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
		    mstForm.submit();
        };


        <%--/*******************************************************************************
         * FUNCTION 명 : popup
         * FUNCTION 기능설명 : 회의 참석자
         *******************************************************************************/--%>
        cfrnAtdtCdTxtNm.on('popup', function(e){
            if(todoYN) {
                openUserSearchDialog(setUsersInfo, 10, $('#userIds').val(), null, 600, 400);
            }
            else {
                openUserSearchDialog(setUsersInfo, 10, $('#userIds').val());
            }
        });


        setUsersInfo = function(userList) {
            var idList = [];
            var nameList = [];
            var saSabunList = [];

            for(var i=0, size=userList.length; i<size; i++) {
                idList.push(userList[i].saUser);
                nameList.push(userList[i].saName);
                saSabunList.push(userList[i].saSabun);

            }

            cfrnAtdtCdTxtNm.setValue(nameList.join(', '));

            $('#userIds').val(idList);
            $('#cfrnAtdtCdTxt').val(saSabunList);
        };


        var   validatorManager = new Rui.validate.LValidatorManager({
            validators:[

                {id:'cfrnAtdtCdTxtNm', validExp:'회의참석자:true'},
                {id:'evTitl', validExp:'회의 일정/장소:true'},
                {id:'commTxt', validExp:'Comments:true'},

            ]
        });


           <%--/*******************************************************************************
            * FUNCTION 명 : validation
            * FUNCTION 기능설명 : 입력값 점검
            *******************************************************************************/--%>
            function validation(){
                if(!validatorManager.validateGroup($('mstForm'))){
                    Rui.alert({
                        text: validatorManager.getMessageList().join('<br/>'),
                        width: 380
                    });
                    return false;
                }
                return true;
            }


        <%--/*******************************************************************************
         * FUNCTION 명 : btnEvCompl
         * FUNCTION 기능설명 : 평가완료
         *******************************************************************************/--%>
        var btnEvCompl = new Rui.ui.LButton('btnEvCompl');
        btnEvCompl.on('click', function() {

             if(!validation()) return false;

             if(!gridDataSet.isUpdated()) {
                 Rui.alert("평가 점수에 변경된 데이터가 없습니다.");
                 return;
             }

// 			for(var i=0; i<gridDataSet.getCount(); i++){


             if(!vm1.validateDataSet(gridDataSet)) { //, gridDataSet.getRow()
                 Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm1.getMessageList().join('<br>'));
                 return false;
             }
// 			}


            Rui.confirm({
                 text: '평가완료 하시겠습니까?',
                 handlerYes: function() {
                    var param = jQuery("#mstForm").serialize().replace(/%/g,'%25');
                     dm.updateDataSet({
                          modifiedOnly: false,
                          url:'<c:url value="/prj/grs/insertGrsEvRsltSave.do"/>',
                          dataSets:[gridDataSet],
                         params:param
                      });

                 },
                handlerNo: Rui.emptyFn
             });

        });


        <%--/*******************************************************************************
         * FUNCTION 명 : btnList
         * FUNCTION 기능설명 : 목록조회
         *******************************************************************************/--%>
        //기능: 목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
        	
			$('#searchForm > input[name=tssNmSch]').val(encodeURIComponent($('#searchForm > input[name=tssNmSch]').val()));
             nwinsActSubmit(searchForm, "<c:url value='/prj/grs/grsReqList.do'/>");
        });


        <%--/*******************************************************************************
         * FUNCTION 명 : fnDtlLstInfo
         * FUNCTION 기능설명 : data  조회
         *******************************************************************************/--%>
         /* 상세내역 가져오기 */
         fnDtlLstInfo = function() {
          var grsEvSn = '${inputData.grsEvSn}';
          gridDataSet.load({
                 url: '<c:url value="/prj/grs/retrieveGrsReqDtl.do"/>',
                 params :{
                    grsEvSn : dataSet.getNameValue(0, "grsEvSn")
                    ,tssCd : document.getElementById('tssCd').value
                    ,tssCdSn: document.getElementById('tssCdSn').value
                 }
             });

         };
         
         if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
     		$('#btnEvCompl').hide();
     	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
     		$('#btnEvCompl').hide();
     	}
         
         
    });
</script>


</head>
<body>

<form name="searchForm" id="searchForm">
	<input type="hidden" name="bizDtpCd" value="${inputData.bizDtpCd}"/>
	<input type="hidden" name="grsEvStSch" value="${inputData.grsEvStSch}"/>
	<input type="hidden" name="tssNmSch" value="${inputData.tssNmSch}"/>
	<input type="hidden" name="tssScnCd" value="${inputData.tssScnCd}"/>
	<input type="hidden" name="grsSt" value="${inputData.grsSt}"/>
	<input type="hidden" name="wbsCd" value="${inputData.wbsCd}"/>
</form>
    
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
        <div class="titleArea">
			<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>  
            <h2 id="evRsltTitle">과제GRS 평가 결과 등록(
            <c:choose>
                <c:when test="${inputData.tssStNm == '1'}">평가요청</c:when>
                <c:otherwise>평가완료</c:otherwise>
            </c:choose>

            )</h2>
        </div>
        <div class="sub-content">
            <div id="mstFormDiv">
                <form name="mstForm" id="mstForm" method="post">
                    <input type="hidden" id="userIds" name="userIds" value=""/>
                    <input type="hidden" id="cfrnAtdtCdTxt" name="cfrnAtdtCdTxt" value=""/>
                    <input type="hidden" id="attcFilId" name="attcFilId" value=""/>
                    <input type="hidden" id="seq" name="seq" value=""/>
                    <input type="hidden" id="tssCd" name="tssCd" value="${inputData.tssCd}"/>
                    <input type="hidden" id="tssCdSn" name="tssCdSn" value="${inputData.tssCdSn}"/>
<!--                    <input type="text" id="cfrnAtdtCdTxtNm" name="cfrnAtdtCdTxtNm" value=""/> -->
                    <input type="hidden" id="grsEvSn" name="grsEvSn" value="${inputData.grsEvSn}"/>
                    <input type="hidden" id="grsEvStSch" name="grsEvStSch" value="${inputData.grsEvStSch}"/>


                    <input type="hidden" id="tssNmSch" name="tssNmSch" value="${inputData.tssNmSch}"/>
                    <input type="hidden" id="bizDtpCd" name="bizDtpCd" value="${inputData.bizDtpCd}"/>
                    <input type="hidden" id="tssScnCd" name="tssScnCd" value="${inputData.tssScnCd}"/>


                   <input type="hidden" id="dlbrParrDt" name="dlbrParrDt" value=""/>
                   <input type="hidden" id="dlbrCrgr" name="dlbrCrgr" value=""/>
                    <fieldset>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 100px;" />
                                <col style="width: 300px;" />
                                <col style="width: 100px;" />
                                <col style="width: 300px;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">프로젝트명</th>
                                    <td>
                                        <div id=prjNmDiv class=prjNmDiv/>
<!--                                            <input type="text" id="prjNm" style="width: 300px;" /> -->
                                    </td>
                                    <th align="right">과제유형</th>
                                    <td>
                                        <div id=bizDptNmDiv class=bizDptNmDiv/>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">과제속성</th>
                                    <td>
                                        <div id=tssAttrNmDiv class=tssAttrNm/>

                                    </td>
                                    <th align="right">과제명</th>
                                    <td>
                                        <div id=tssNmDiv class=tssNmDiv/>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">심의단계</th>
                                    <td>
                                         <div id=grsEvStNmDiv class=grsEvStNmDiv/>

                                    </td>
                                    <th align="right">평가표</th>
                                    <td>
                                        <div id=grsEvSnNmDiv class=grsEvSnNmDiv/>

                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">심의예정일</th>
                                    <td>
                                        <div id=dlbrParrDtDiv class=dlbrParrDtDiv/>
                                    </td>
                                    <th align="right">심의담당자</th>
                                    <td>
                                        <div id=dlbrCrgrNmDiv class=dlbrCrgrNmDiv/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 100px;" />
                                <col style="width: 300px;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">회의 일정/장소</th>
                                    <td colspan=2>
                                        <input type="text" id="evTitl"/>
                                    </td>

                                </tr>
                                <tr>
                                    <th align="right">회의참석자</th>
                                    <td colspan=2>
                                           <div class="LblockMarkupCode">
                                                <div id="cfrnAtdtCdTxtNm"></div>
                                        </div>
                                    </td>

                                </tr>
                                <tr>
                                    <th align="right">Comments</th>
                                    <td colspan=2>
                                        <input type="text" id="commTxt" />
                                    </td>

                                </tr>
                                <tr>
                                    <th align="right">첨부파일</th>
                                    <td id="attchFileView">&nbsp;</td>
                                    <td>
                                        <button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button>
                                    </td>
                                </tr>
                            </tbody>

                        </table>
                    </fieldset>
                </form>
            </div>

             <div id="listGrid" style="margin-top:20px"></div>

            <div class="titArea">
                <div class="LblockButton">
                    <button type="button" id="btnEvCompl" name="btnEvCompl">평가완료</button>
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>