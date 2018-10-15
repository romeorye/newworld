<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : prjRsstFxaList.jsp
 * @desc    : 연구팀 > 프로젝트 등록 > 고정자산 탭 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.31  IRIS04      최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">
var pTopForm = parent.topForm;	// 프로젝트마스터 폼
var dataSet08;                  // 고정자산 데이터셋
var grid08;						// 고정자산 그리드
var fxaDtlDialog;				// 상세팝업 다이얼로그
var imageDialog;				// 이미지 다이얼로그
var imageDialogWidth  = 350;	// 이미지 다이얼로그 너비
var imageDialogHeight = 350;	// 이미지 다이얼로그 높이

Rui.onReady(function() {

	/* DATASET : defaultGrid01 : 고정자산목록 */
	dataSet08 = new Rui.data.LJsonDataSet({
	    id: 'dataSet08',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  {id: 'fxaInfoId' } /*고정자산 정보 ID*/
	    	, {id: 'fxaNm'     } /*고정자산 명*/
	    	, {id: 'fxaNo'     } /*고정자산 번호*/
	    	, {id: 'wbsCd'     } /*WBS 코드*/
	    	, {id: 'prjCd'     } /*PJT 코드*/
	    	, {id: 'prjNm'     } /*프로젝트명(소속명)*/
	    	, {id: 'crgrNm'    } /*담당자명*/
	    	, {id: 'fxaLoc'    } /*고정자산 위치*/
	    	, {id: 'fxaQty'    } /*고정자산 수량*/
	    	, {id: 'fxaUtmNm'  } /*고정자산 단위 명*/
	    	, {id: 'obtPce'    } /*취득가*/
	    	, {id: 'bkpPce'    } /*장부가*/
	    	, {id: 'obtDt'     } /*취득일(YYYY-MM-Dd)*/
	    	, {id: 'rlisDt'    } /*실사일*/
	    	, {id: 'tagYn'     } /*태그 여부*/
	    	, {id: 'imgFilPath'} /*이미지 FILE PATH*/
	    	, {id: 'imgFilNm'  } /*이미지 FILE 명*/
	    	, {id: 'attcFilId' } /*파일ID*/
	    	, {id: 'attcFilSeq' }  /*파일시퀀스*/
	    	, {id: 'attcFilNm' }   /*파일명*/
	    	, {id: 'attcFilPath' } /*파일경로*/
	    	, {id: 'attcFilSize' } /*파일사이즈*/


	    ]
	});

	/* COLUMN : defaultGrid */
	var columnModel01 = new Rui.ui.grid.LColumnModel({
	    columns: [
	    	  { field: 'wbsCd',         label: 'WBS코드',   align:'center', width: 60 }
	        , { field: 'prjNm',         label: '소속명',    align:'left', width: 130 }
	        , { field: 'fxaNo',         label: '자산번호',  align:'center', width: 80 }
	        , { field: 'fxaNm',         label: '자산명',    align:'left', width: 280
	        	, renderer: function(value){
	        		Rui.util.LRenderer.popupRenderer();
	        		return "<a href='javascript:void(0);'><u>" + value + "<u></a>";
	          }}
	        , { field: 'fxaQty',        label: '수량',      align:'right', width: 40 }
	        , { field: 'fxaUtmNm',      label: '단위',      align:'center', width: 40 }
	        , { field: 'crgrNm',        label: '담당자',    align:'center', width: 70 }
	        , { field: 'obtDt',         label: '취득일',    align:'center', width: 80 }
	        , { field: 'obtPce',        label: '취득가',    align:'right', width: 100,
	        	renderer: function(value, p, record){
	        		return Rui.util.LFormat.numberFormat(parseInt(value));
		        }
	        }
	        , { field: 'bkpPce',        label: '장부가',    align:'right', width: 95,
	        	renderer: function(value, p, record){
	        		return Rui.util.LFormat.numberFormat(parseInt(value));
		        }
	          }
	        , { id : 'imgFileIcon',     label: '사진', width: 85 ,
	        	renderer: function(val, p, record, row, i){
	        		console.log(record);
	            	var recordFilPath = nullToString(record.data.attcFilPath);
	            	var strBtnFun = "openImageView('"+ row +"')";
	            	if(recordFilPath != ""){
		            	return '<button type="button" class="L-grid-button L-popup-action" onclick="'+strBtnFun+'">보기</button>';
	            	}
	            }
	          }
	        , { field: 'fxaLoc',        label: '위치',      align:'left', width: 140 }
	        , { field: 'tagYn',         label: '태그여부',  align:'center', width: 55 }
	        , { field: 'rlisDt',        label: '실사일',    align:'center', width: 70 }
	    ]
	});

	/* GRID : defaultGrid01 */
	grid08 = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel01,
	    dataSet: dataSet08,
	    width: 600,
	    height: 450,
	    autoWidth: true
	});

	grid08.on('cellClick', function(e) {
		// 자산명 : 상세팝업 출력
		var record = dataSet08.getAt(dataSet08.getRow());
		if(dataSet08.getRow() > -1) {

			if(e.col == 3) {
				openTfxaDtlDialog(dataSet08.getAt(e.row));
	        }
		}
	});

	grid08.on('popup', function(e) {
		// 자산명 : 상세팝업 출력
		var record = dataSet08.getAt(dataSet08.getRow());
		if(dataSet08.getRow() > -1) {

			if(e.col == 3) {
				openTfxaDtlDialog(dataSet08.getAt(e.row));
	        }
		}
    });

	grid08.render('defaultGrid01');

	/* [버튼] 목록 */
	var butGoList = new Rui.ui.LButton('butGoList');
	butGoList.on('click', function() {
		nwinsActSubmit(document.tabForm08, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
	});

	 /* [버튼] EXCEL다운로드 */
	var lbButExcl = new Rui.ui.LButton('butExcl');
	lbButExcl.on('click', function() {
		fncExcelDown();
	});

	/* [ 이미지 Dialog] */
	imageDialog = new Rui.ui.LDialog({
        applyTo: 'imageDialog',
        width: imageDialogWidth ,
        height: imageDialogHeight,
        visible: false,
        postmethod: 'none',
        buttons: [
            { text:'닫기', isDefault: true, handler: function() {
                this.cancel(false);
            } }
        ]
    });
	imageDialog.hide(true);

	/* [ 자산 상세정보 Dialog] */
	fxaDtlDialog = new Rui.ui.LFrameDialog({
        id: 'fxaDtlDialog',
        title: '자산 상세정보',
        width:  700,
        height: 500,
        modal: true,
        visible: false,
        buttons : [
            { text:'닫기', handler: function() {
              	this.cancel(false);
              }
            }
        ]
    });

	fxaDtlDialog.render(document.body);

	 /* 첨부파일 다운 */
    downloadAttachFile = function(attcFilId, seq) {
    	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
    	tabForm08.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
    	tabForm08.submit();
	};

	// 마스터폼 disable
	parent.fnChangeFormEdit('disable');

	// 온로드 조회
	fnSearchList();

});

<%--/*******************************************************************************
 * FUNCTION 명 : 월별 목록조회(fnSearchByMonth)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnSearchList() {

	dataSet08.load({
        url: '<c:url value="/prj/rsst/retrievePrjFxaSearchInfo.do"/>' ,
        params :{
		    wbsCd : pTopForm.wbsCd.value
        }
    });
}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 고정자산 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

	var prjNm = pTopForm.prjNm.value

    if( dataSet08.getCount() > 0){
    	grid08.saveExcel(toUTF8(prjNm +'_고정자산목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	Rui.alert('조회된 데이타가 없습니다.!!');
    }
}

<%--/*******************************************************************************
 * FUNCTION 명 : 자산 상세정보 팝업 호출
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function openFxaDtlDialog(rd){
	var recordData;
	var url = '';
	if(rd == null || rd == ''){ return; }

	recordData = rd;
	url = '?fxaInfoId='+recordData.get('fxaInfoId');

	fxaDtlDialog.setUrl('<c:url value="/prj/rsst/retrieveFxaDtlInfo.do'+url+' "/>');
	fxaDtlDialog.show();
}

<%--/*******************************************************************************
 * FUNCTION 명 : (부모창)자산 상세정보 팝업 호출
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function openTfxaDtlDialog(rd){
	var recordData;
	var url = '';
	if(rd == null || rd == ''){ return; }

	recordData = rd;
	url = '?fxaInfoId='+recordData.get('fxaInfoId');

	parent.tfxaDtlDialog.setUrl('<c:url value="/prj/rsst/retrieveFxaDtlInfo.do'+url+' "/>');
	parent.tfxaDtlDialog.show();
}

<%--/*******************************************************************************
 * FUNCTION 명 : 자산 상세정보 팝업 호출
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function openImageView(row){
	var attId = dataSet08.getAt(row).get('attcFilId');
	var seq = dataSet08.getAt(row).get('attcFilSeq');
	var param = "?attcFilId="+ attId+"&seq="+seq;

	Rui.getDom('dialogImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
	Rui.get('imgDialTitle').html('자산이미지');
	imageDialog.clearInvalid();
	imageDialog.show(true);
}


</script>

</head>
<body>
<form name="tabForm08" id="tabForm08" method="post"></form>
    <Tag:saymessage /><!--  sayMessage 사용시 필요 -->

    <div class="titArea">
<!--     	<h3>고정자산목록</h3> -->
    	<div class="LblockButton">
            <button type="button" id="butExcl" name="butExcl" >EXCEL다운로드</button>
        </div>
    </div>

    <div id="defaultGrid01"></div>

    <div class="titArea btn_btm">
    	<div class="LblockButton">
            <button type="button" id="butGoList" name="butGoList">목록</button>
        </div>
    </div>

	<!-- 이미지 -->
	<div id="imageDialog">
		<div class="hd" id="imgDialTitle">이미지</div>
		<div class="bd" id="imgDialContents" align="center">
			<img id="dialogImage"/>
		</div>
	</div>

</body>
</html>