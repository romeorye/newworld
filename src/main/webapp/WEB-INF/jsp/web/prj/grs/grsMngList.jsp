<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id      : grsMngList.jsp
 * @desc    :  GRS 관리
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.28  jih     최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>


<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/grsEv.js"></script>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>

<style>
    .grid-bg-color-sum {
        background-color: rgb(255,204,204);
    }
</style>

<%
    HashMap inputData = (HashMap)request.getAttribute("inputData");
%>
    <!-- 그리드 소스 -->
<script type="text/javascript">
    Rui.onReady(function() {

    	var resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });



        /*******************
         * 그리드 셋팅 START
         *******************/
         listDataSet = new Rui.data.LJsonDataSet({
             id: 'listDataSet',
             focusFirstRow: 0,
             lazyLoad: true,
             fields: [
					{ id: 'tssCd' },
					{ id: 'wbsCd' },
					{ id: 'pkWbsCd' },
					{ id: 'pgsStepCd' },
					{ id: 'pgsStepNm' },
					{ id: 'tssSt' },
					{ id: 'tssStNm' },
					{ id: 'tssNm' },
					{ id: 'prjCd' },
					{ id: 'prjNm' },
					{ id: 'bizDptCd' },
					{ id: 'prodG' },
					{ id: 'tssSmryTxt' },
					{ id: 'custSqlt' },
					{ id: 'nprodSalsPlnY' },
					{ id: 'ctyOtPlnM' },
					{ id: 'tssScnCd' },
					{ id: 'tssScnNm' },
					{ id: 'saSabunCd' },
					{ id: 'saSabunNm' },
					{ id: 'tssStrtDd' },
					{ id: 'tssFnhDd' },
					{ id: 'tssDd' },
					{ id: 'grsYn' },
					{ id: 'frstRgstDt' },
					{ id: 'frstRgstId' },
					{ id: 'tMdfyDt' },
					{ id: 'tMdfyId' }
              ]
         });


         var listColumnModel = new Rui.ui.grid.LColumnModel({
             autoWidth: true,
             columns: [
                     { field: 'tssScnCd',   label: '선택',  align:'center',  width: 40   , renderer: function(value){
                         return "<input type='checkbox'/>";
                     } },
                     { field: 'tssScnNm',   label: '과제구분',  align:'center',  width: 65 },
                     { field: 'tssCd',   label: '과제코드',  align:'center',  width: 70 },
                     { field: 'tssNm',   label: '과제명',  align:'center',  width: 100 },
                     { field: 'prjNm',   label: '프로젝트명',  align:'center',  width: 100 },
                     { field: 'saSabunNm',   label: '과제담당자',  align:'center',  width: 70 },
                     { field: 'tssDd',   label: '과제기간',  align:'center',  width: 100 },
                     { field: 'pgsStepNm',   label: '과제단계',  align:'center',  width: 60 },
                     { field: 'tssStNm',   label: 'GRS단계',  align:'center',  width: 65 },
                     { field: 'tssScnCd',   label: 'GRS상태',  align:'center',  width: 65 },
                     { field: 'tssScnCd',        label: '관리',       align:'center',      width: 90  , renderer: function(val, p, record, row, i){
                         return "<input type='button' data='"+record.data.tssCd+"' value='평가' onclick='evTss(this)'/><input type='button' data='"+record.data.tssCd+"' value='수정' onclick='modifyTss(this)'/>";
                     } }
             ]
         });
        var listGrid = new Rui.ui.grid.LGridPanel({ //masterGrid
            columnModel: listColumnModel,
            dataSet: listDataSet,
            height: 550,
            width: 600,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        listGrid.render('listGrid');

        /*******************
         * 그리드 셋팅 END
        *******************/
        infoDataSet = new Rui.data.LJsonDataSet({
            id: 'infoDataSet',
            fields: [
					{ id: 'tssCd' },
					{ id: 'wbsCd' },
					{ id: 'pkWbsCd' },
					{ id: 'pgsStepCd' },
					{ id: 'pgsStepNm' },
					{ id: 'tssSt' },
					{ id: 'tssStNm' },
					{ id: 'tssNm' },
					{ id: 'prjCd' },
					{ id: 'prjNm' },
					{ id: 'bizDptCd' },
					{ id: 'prodG' },
					{ id: 'tssSmryTxt' },
					{ id: 'custSqlt' },
					{ id: 'nprodSalsPlnY' },
					{ id: 'ctyOtPlnM' },
					{ id: 'tssScnCd' },
					{ id: 'tssScnNm' },
					{ id: 'saSabunCd' },
					{ id: 'saSabunNm' },
					{ id: 'tssStrtDd' },
					{ id: 'tssFnhDd' },
					{ id: 'tssDd' },
					{ id: 'grsYn' },
					{ id: 'tssAttrCd'},
					{ id: 'tssType'},
					{ id: 'smrSmryTxt'},
					{ id: 'smrGoalTxt'},
					{ id: 'frstRgstDt' },
					{ id: 'frstRgstId' },
					{ id: 'lastMdfyDt' },
					{ id: 'lastMdfyId' },
					{ id: 'attcFilId' }        //첨부파일
             ]
        });

    /* 상세 bind */
        var etcTssBind = new Rui.data.LBind({
            groupId: 'defTssForm',
            dataSet: infoDataSet,
            bind: true,
            bindInfo: [
					{ id: 'tssCd', ctrlId: 'tssCd', value: 'value' },
					{ id: 'tssScnCd', ctrlId: 'tssScnCd', value: 'value' },
					{ id: 'grsYn', ctrlId: 'grsYn', value: 'value' },
					{ id: 'tssNm', ctrlId: 'tssNm', value: 'value' },
					{ id: 'prjCd', ctrlId: 'prjCd', value: 'value' },
					{ id: 'prjNm', ctrlId: 'prjNm', value: 'value' },
					{ id: 'bizDptCd', ctrlId: 'bizDptCd', value: 'value' },
					{ id: 'prodG', ctrlId: 'prodG', value: 'value' },
					{ id: 'saSabunCd', ctrlId: 'saSabunCd', value: 'value' },
					{ id: 'saSabunNm', ctrlId: 'saSabunNm', value: 'value' },
					{ id: 'tssStrtDd', ctrlId: 'tssStrtDd', value: 'value' },
					{ id: 'tssFnhDd', ctrlId: 'tssFnhDd', value: 'value' },
					{ id: 'tssSmryTxt', ctrlId: 'tssSmryTxt', value: 'value' },
					{ id: 'custSqlt', ctrlId: 'custSqlt', value: 'value' },
					{ id: 'tssAttrCd', ctrlId: 'tssAttrCd', value: 'value' },
					{ id: 'tssType', ctrlId: 'tssType', value: 'value' },
					{ id: 'smrSmryTxt', ctrlId: 'smrSmryTxt', value: 'value' },
					{ id: 'smrGoalTxt', ctrlId: 'smrGoalTxt', value: 'value' },
					{ id: 'nprodSalsPlnY', ctrlId: 'nprodSalsPlnY', value: 'value' },
					{ id: 'ctyOtPlnM', ctrlId: 'ctyOtPlnM', value: 'value' },
            ]
        });

        /* 평가 bind */
        var evTssBind = new Rui.data.LBind({
            groupId: 'evTssForm',
            dataSet: infoDataSet,
            bind: true,
            bindInfo: [
					{ id: 'prjNm', ctrlId: 'prjNm', value: 'html' },
					{ id: 'tssNm', ctrlId: 'tssNm', value: 'html' },
					{ id: 'tssDd', ctrlId: 'tssDd', value: 'html' },
					{ id: 'tssScnNm', ctrlId: 'tssScnNm', value: 'html' },
					{ id: 'saSabunNm', ctrlId: 'saSabunNm', value: 'html' },
					{ id: 'grsYn', ctrlId: 'grsYn', value: 'html' },
					{ id: 'tssCd', ctrlId: 'tssCd', value: 'value' },
					{ id: 'evTitl', ctrlId: 'evTitl', value: 'value' },
					{ id: 'cfrnAtdtCdTxtNm', ctrlId: 'cfrnAtdtCdTxtNm', value: 'value' },
					{ id: 'commTxt', ctrlId: 'commTxt', value: 'value' },
					{ id: 'attchFileView', ctrlId: 'attchFileView', value: 'value' },
					{ id: 'grsEvSnNm', ctrlId: 'grsEvSnNm', value: 'value' },
            ]
        });

        /*******************
          * Function 및 데이터 처리 START
        *******************/
        /**
            총 건수 표시
        **/
        listDataSet.on('load', function(e){
            var seatCnt = 0;
            var sumOrd = 0;
            var sumMoOrd = 0;
            var tmp;
            var tmpArray;
            var str = "";

            document.getElementById("cnt_text").innerHTML = '총 : '+listDataSet.getCount();

        });
 <%--/*******************************************************************************
  * FUNCTION 명 : init
  * FUNCTION 기능설명 :화면로딩
  *******************************************************************************/--%>
        init = function() {
            listDataSet.load({
                url: '<c:url value="/prj/grs/selectListGrsMngInfo.do"/>',
                params: {
                    tssNm: escape(encodeURIComponent('${inputData.tssNmSch}')) //과제명
                    ,bizDtpCd: '${inputData.bizDtpCd}'
                    ,grsEvSt:'${inputData.grsEvStSch}'
                    ,tssScnCd:'${inputData.tssScnCd}'
                    ,grsSt:'${inputData.grsSt}'
                }
            });
        }

 <%--/*******************************************************************************
  * FUNCTION 명 : fncSearch
  * FUNCTION 기능설명 :검색
  *******************************************************************************/--%>
        fnSearch = function() {

            listDataSet.load({
              url: '<c:url value="/prj/grs/selectListGrsMngInfo.do"/>',
                params: {
//                     tssNm: escape(encodeURIComponent(document.xform.tssNmSch.value)) //과제명
                     stssScnCd : stssScnCd.getValue()
                    ,stssCd  : stssCd.getValue()
                    ,stssNm : stssNm.getValue()
                    ,sprjNm    : sprjNm.getValue()
                    ,ssaSabunNm    : ssaSabunNm.getValue()
                }
            });
        }

        fnSearch();
 <%--/*******************************************************************************
  * FUNCTION 명 : fnExcel
  * FUNCTION 기능설명 :excel 다운로드
  *******************************************************************************/--%>

        fnExcel = function() {
            masterGrid.saveExcel(toUTF8('GRS_심의현황_') + new Date().format('%Y%m%d') + '.xls');
        };

        form = new Rui.ui.form.LForm('defTssForm', {});


      /* 기본정보 등록 팝업 */
      etcTssDialog = new Rui.ui.LDialog({
          applyTo: 'divEtcTss',
          width: 800,
          visible: false,
          postmethod: 'none',
          buttons: [
              { text:'저장', isDefault: true, handler:
                function() {
            	  dm.on('success', function(e) {      // 업데이트 성공시
            			var resultData = resultDataSet.getReadData(e);
            			alert(resultData.records[0].rtnMsg);
            			fnSearch();
            			etcTssDialog.hide();
            		});

            		dm.on('failure', function(e) {      // 업데이트 실패시
            			var resultData = resultDataSet.getReadData(e);
            			alert(resultData.records[0].rtnMsg);
            		});

            		if(fncVaild()) {
            			Rui.confirm({
            				text: '저장하시겠습니까?',
            				handlerYes: function() {
            					dm.updateForm({
            						url: "<c:url value='/prj/grs/updateGrsMngInfo.do'/>",
            						form: 'defTssForm'
            					});
            				}
            			});
            		}
                  }
              },
              { text:'삭제', isDefault: true, handler:
                function() {
                  }
              },
              { text:'닫기', isDefault: true, handler:
                function() {
                    this.cancel(false);
                  }
              }
          ]
      });
      /* 평가 팝업 */
      evTssDialog = new Rui.ui.LDialog({
          applyTo: 'divEvTss',
          width: 1210,
          visible: false,
          postmethod: 'none',
          buttons: [
              { text:'평가완료', isDefault: true, handler:
                function() {
                var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
                dm.on('success', function(e) {      // 업데이트 성공시
                	var resultData = resultDataSet.getReadData(e);
                	alert(resultData.records[0].rtnMsg);
                });

                dm.on('failure', function(e) {      // 업데이트 실패시
                	var resultData = resultDataSet.getReadData(e);
                	alert(resultData.records[0].rtnMsg);
                });

                if(fncVaild()) {
                   Rui.confirm({
                    text: '평가완료하시겠습니까?',
                        handlerYes: function() {
//                              dm.updateForm({
//                                url: "<c:url value='/prj/grs/updateGrsMngInfo.do'/>",
//                                form: 'defTssForm'
//                                 });
                        }
                  });
                }
                  }
              },
              { text:'닫기', isDefault: true, handler:
                function() {
                    this.cancel(false);
                  }
              }
          ]
      });

    var fncVaild = function(){
    return true;
    }

      /* [함수] 화면초기화 */
      fnOnInit = function(){
        // 다이얼로그 숨김
        etcTssDialog.hide();
      }

      //화면초기화
      fnOnInit();

      //기본값 세팅
      tssScnCd.setSelectedIndex(3);
      grsYn.setSelectedIndex(0);
      tssNm.setValue("개발과제 테스트");
      prjNm.setValue("창호.창호개발연구PJT");

    $("#prjCd").val("PRJ00025");
    $("#deptCode").val("58117903");

    bizDptCd.setSelectedIndex(2);
    prodG.setSelectedIndex(2);

    saSabunNm.setValue("김건휘");
    $("#saSabunCd").val("00207959");
    tssStrtDd.setValue("2018-08-10");
    tssFnhDd.setValue("2019-08-10");
    custSqlt.setSelectedIndex(1);
    tssSmryTxt.setValue("컨셉내용");
    tssAttrCd.setSelectedIndex(1);
    tssType.setSelectedIndex(1);
    smrSmryTxt.setValue("서머리 개요");
    smrGoalTxt.setValue("서머리 목표");
    nprodSalsPlnY.setValue(100);
    ctyOtPlnM.setValue("2018-09");

    makeGrsEvPop();
    makeGrsEvTable();
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
             infoDataSet.setNameValue(0, "attcFilId", lvAttcFilId)
         }
     };

		downloadAttachFile = function(attcFilId, seq) {
		    mstForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
		    mstForm.submit();
     };


   }); //onReady END


  function testSubmit() {
    try {
      var obj = form.getValues();
      Rui.log(Rui.dump(obj));
    } catch (e) {
      alert(e);
    }
    return false;
  }

   function addTss(){
	   etcTssDialog.show(true);
   }

   function evTss(obj){
	   evTssDialog.show(true);
	   infoDataSet.clearData();
		var tssCd = $(obj).attr('data');
        infoDataSet.load({
            url: '<c:url value="/prj/grs/selectListGrsMngInfo.do"/>',
            params: {
            	tssCd: tssCd
            }
        });
   }

   function modifyTss(obj){
	   etcTssDialog.show(true);
		var tssCd = $(obj).attr('data');
        infoDataSet.load({
            url: '<c:url value="/prj/grs/selectListGrsMngInfo.do"/>',
            params: {
            	tssCd: tssCd
            }
        });
   }

 //평가표 팝업 cbf
   function setGrsEvSnInfo(grsInfo) {
	 $("#evTssForm > #grsEvSn").val(grsInfo.grsEvSn);
	 grsEvSnNm.setValue(grsInfo.evSbcNm);
	 getGrsEvTableData(grsInfo.grsEvSn, infoDataSet.getAt(0).get("tssCd"), '');
   }


/*
  function test(){
    console.log("test");
    tssScnCd.setValue("개발과제");
    tssScnCd.setSelectedIndex(3);
    console.log(tssScnCd);
  }
 */

</script>
</head>

<!-- <body onload="init();"> -->
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="contents">
		<div class="titleArea">
			<h2>GRS 관리</h2>
		</div>
		<div class="LblockSearch">
			<form name="xform" id="xform" method="post">
				<table class="searchBox">
					<colgroup>
						<col style="width: 15%;" />
						<col style="width: 30%;" />
						<col style="width: 15%;" />
						<col style="width: 30%;" />
						<col style="width: 10%;" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">과제구분</th>
							<td><div id="stssScnCd" /></td>
							<th align="right">과제코드</th>
							<td><div id="stssCd" /></td>
							<td class="t_center" rowspan="3"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
						</tr>
						<tr>
							<th align="right">과제명</th>
							<td><div id="stssNm" /></td>
							<th align="right">프로젝트명</th>
							<td><div id="sprjNm" /></td>
						</tr>
						<tr>
							<th align="right">과제담당자</th>
							<td><div id="ssaSabunNm" /></td>
							<th align="right">GRS상태</th>
							<td></td>
						</tr>
					</tbody>
				</table>
			</form>
			<div class="titArea">
				<span class="Ltotal" id="cnt_text">총 : 0 </span>
				<div class="LblockButton">
					<button type="button">품의 요청</button>
					<button type="button" onclick="addTss()">등록</button>
					<button type="button" onclick="javascript:fnExcel()">Excel다운로드</button>
				</div>
			</div>
			<div id="listGrid"></div>
			<!--<div id="masterGrid"></div>-->
			<!-- 과제 기본정보입력 팝업 시작 -->
			<div id="divEtcTss" style="visibility: hidden;">
				<div class="hd">과제기본정보입력</div>
				<div class="bd">
					<!-- <div class="titArea"> -->
					<div class="LblockButton" style="margin-bottom: 10px">
						<!-- <button type="button" id="butEtcTssClear" name="butEtcTssClear">초기화</button> -->
						<!-- <button type="button" id="butEtcTssRgst" name="butEtcTssRgst">저장</button> -->
					</div>
					<!-- </div> -->
					<form name="defTssForm" id="defTssForm" method="post">
						<input type="hidden" name="tssCd" id="tssCd">
						<input type="hidden" name="prjCd" id="prjCd">
						<input type="hidden" name="saSabunCd" id="saSabunCd">
						<input type="hidden" name="deptCode" id="deptCode">
						<table class="table table_txt_right">
							<colgroup>
								<col style="width: 15%;" />
								<col style="width: 30%;" />
								<col style="width: 15%;" />
								<col style="width: 30%;" />
							</colgroup>
							<tbody>
								<tr>
									<th align="right">과제구분</th>
									<td><div id="tssScnCd" /></td>
									<th align="right">GRS(P1)수행여부</th>
									<td><div id="grsYn" /></td>
								</tr>
								<tr>
									<th align="right">과제명</th>
									<td colspan="3"><input id="tssNm" type="text" style="width: 100%" /></td>
								</tr>
								<tr>
									<th align="right">프로젝트명<br />(개발부서)
									</th>
									<td colspan="3"><input type="text" id="prjNm" /></td>
								</tr>
								<tr>
									<th align="right">사업부</th>
									<td><div id="bizDptCd" /></td>
									<th align="right">제품군</th>
									<td><div id="prodG" /></td>
								</tr>
								<tr>
									<th align="right">과제담당자</th>
									<td><input type="text" id="saSabunNm" /></td>
									<th align="right">과제기간</th>
									<td><input type="text" id="tssStrtDd"> <em class="gab"> ~ </em> <input type="text" id="tssFnhDd"></td>
								</tr>
								<tr>
									<th align="right">고객특성</th>
									<td><div id="custSqlt" /></td>
									<th align="right">Concept</th>
									<td><input id="tssSmryTxt" type="text" style="width: 100%" /></td>
								</tr>
								<tr>
									<th align="right">과제속성</th>
									<td><div id="tssAttrCd" /></td>
									<th align="right">신제품 유형</th>
									<td><div id="tssType" /></td>
								</tr>
								<tr>
									<th align="right">Summary 개요</th>
									<td colspan="3"><textarea id="smrSmryTxt" name="smrSmryTxt" style="width: 100%; height: 100px"></textarea></td>
								</tr>
								<tr>
									<th align="right">Summary 목표</th>
									<td colspan="3"><textarea id="smrGoalTxt" name="smrGoalTxt" style="width: 100%; height: 100px"></textarea></td>
								</tr>
								<tr>
									<th align="right">매출계획</th>
									<td><input id="nprodSalsPlnY" type="text" /></td>
									<th align="right">출시계획</th>
									<td><input type="text" id="ctyOtPlnM" /></td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
			<!-- 과제 기본정보입력 팝업 종료 -->
			<!--평가 팝업 시작 -->
			<div id="divEvTss" style="visibility: hidden;">
				<div class="hd">과제 GRS 평가</div>
				<div class="bd">
					<!-- <div class="titArea"> -->
					<div class="LblockButton" style="margin-bottom: 10px"></div>
					<!-- </div> -->
					<form name="evTssForm" id="evTssForm" method="post">
						<input type="hidden" name="tssCd" id="tssCd">
						<input type="hidden" name="saSabunCd" id="saSabunCd">
						<input type="hidden" name="tssCdSn" id="tssCdSn">
						<input type="hidden" name="grsEvSn" id="grsEvSn">
						<table class="table table_txt_right">
							<colgroup>
								<col style="width: 20%;" />
								<col style="width: 30%;" />
								<col style="width: 20%;" />
								<col style="width: 30%;" />
							</colgroup>
							<tbody>
								<tr>
									<th align="right">프로젝트명</th>
									<td colspan="3"><span id="prjNm" /></td>
								</tr>
								<tr>
									<th align="right">과제명</th>
									<td><span id="tssNm" /></td>
									<th align="right">과제기간</th>
									<td><span id="tssDd" /></td>
								</tr>
								<tr>
									<th align="right">과제구분</th>
									<td><span id="tssScnNm" /></td>
									<th align="right">과제담당자</th>
									<td><span id="saSabunNm" /></td>
								</tr>
								<tr>
									<th align="right">GRS(P1) 수행여부</th>
									<td><span id="grsYn" /></td>
									<th align="right">GRS 상태</th>
									<td><span id="" /></td>
								</tr>
							</tbody>
						</table>
						<table class="table table_txt_right">
							<colgroup>
								<col style="width: 20%" />
								<col style="width: 20%;" />
								<col style="width: 60%;" />
							</colgroup>
							<tbody>
								<tr>
									<th align="right">회의 일정/장소</th>
									<td colspan="2"><div id="evTitl" /></td>
								</tr>
								<tr>
									<th align="right">회의 참석자</th>
									<td colspan="2"><div id="cfrnAtdtCdTxtNm" /></td>
								</tr>
								<tr>
									<th align="right">Comment</th>
									<td colspan="2"><div id="commTxt" /></td>
								</tr>
								<tr>
									<th align="right">첨부파일</th>
									<td id="attchFileView" />
									<td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
								</tr>
								<tr>
									<th align="right">평가표 선택</th>
									<td colspan="2"><div id="grsEvSnNm" /></td>
								</tr>
							</tbody>
						</table>
						<div id="evTableGrid" style="margin-top: 20px"></div>
					</form>
				</div>
			</div>
			<!-- 평가 팝업 종료 -->
		</div>
	</div>
</body>
</html>
<script>
	/* 검색 */
	nCombo('stssScnCd', 'TSS_SCN_CD') // 과제구분
	nTextBox('stssCd', 300, '과제코드를 입력해주세요'); // 과제코드
	nTextBox('stssNm', 300, '과제명을 입력해주세요'); // 과제명
	nTextBox('sprjNm', 300, '프로젝트명을 입력해주세요'); // 프로젝트명
	nTextBox('ssaSabunNm', 300, '과제담당자명을 입력해주세요'); // 과제명
	/* 등록 */
	nCombo('tssScnCd', 'TSS_SCN_CD') // 과제구분
	nCombo('grsYn', 'COMM_YN') // GRS 수행여부
	nTextBox('tssNm', 620, '과제명을 입력해주세요'); // 과제명
	popProject('prjNm', 'prjCd', 'deptCode', 'prjSearchDialog') // 프로젝트명
	nCombo('bizDptCd', 'BIZ_DPT_CD') // 사업부
	nCombo('prodG', 'PROD_G'); // 제품군
	popSabun('saSabunNm', 'saSabunCd') // 담당자
	nDateBox('tssStrtDd'); // 과제 시작일
	nDateBox('tssFnhDd'); // 과제 종료일
	//고객 특성
	var custSqlt = new Rui.ui.form.LCombo({
		applyTo : 'custSqlt',
		emptyValue : '',
		emptyText : '선택',
		width : 100,
		defaultValue : '${inputData.custSqlt}',
		items : [ {
			text : 'B2B제품군',
			value : '01'
		}, {
			text : '일반제품군',
			value : '02'
		}, ]
	});
	nTextBox('tssSmryTxt', 257, 'ConCept을 입력해주세요'); // Concept
	nCombo('tssAttrCd', 'TSS_ATTR_CD'); // 과제속성
	nCombo('tssType', 'TSS_TYPE'); // 신제품 유형
	nTextArea('smrSmryTxt', 644, 122, 'Sumarry개요를 입력해주세요'); // Summary 개요
	nTextArea('smrGoalTxt', 644, 122, 'Summary 목표를 입력해주세요'); // Summary 목표
	nTextBox('nprodSalsPlnY', 200); // 매출 계획 nprodSalsPlnY
	nMonthBox('ctyOtPlnM'); // 출시계획

	/* 평가 */
	// 회의 일정/장소
	nTextBox('evTitl', 580, '회의 일정/장소를 입력해주세요');
	// 회의 참석자
	nTextBox('cfrnAtdtCdTxtNm', 580, '회의 참석자를  입력해주세요');
	// Comment
	nTextArea('commTxt', 580, 122, 'Comment를 입력해주세요');
	// 첨부파일
	//attcFilId
	// 평가표 선택
	//nCombo('grsEvSn','TSS_TYPE');
</script>
