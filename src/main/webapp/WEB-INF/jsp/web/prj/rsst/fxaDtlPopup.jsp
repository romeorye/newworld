<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaDtlPopup.jsp
 * @desc    : 자산 상세정보 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.31  IRIS04		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">
var fxaDtlDataSet; // 자산 상세정보 데이터셋
var imageWidth  = 100;	// 이미지 표시너비
var imageHeight = 100;	// 이미지 표시높이

Rui.onReady(function() {

	/* DATASET : grid */
	fxaDtlDataSet = new Rui.data.LJsonDataSet({
	    id: 'fxaDtlDataSet',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  {id: 'fxaInfoId' } /*고정자산 정보 ID*/
	    	, {id: 'fxaNm'     } /*고정자산 명*/
	    	, {id: 'fxaNo'     } /*고정자산 번호*/
	    	, {id: 'fxaStCd'   } /*고정자산 상태 코드*/
	    	, {id: 'wbsCd'     } /*WBS 코드*/
	    	, {id: 'prjCd'     } /*PJT 코드*/
	    	, {id: 'crgrNm'    } /*담당자명*/
	    	, {id: 'fxaLoc'    } /*고정자산 위치*/
	    	, {id: 'fxaClss'   } /*고정자산 클래스*/
	    	, {id: 'fxaQty'   , defaultValue: 0 } /*고정자산 수량*/
	    	, {id: 'fxaUtmNm'  } /*고정자산 단위 명*/
	    	, {id: 'obtPce'   , defaultValue: 0 } /*취득가*/
	    	, {id: 'bkpPce'   , defaultValue: 0 } /*장부가*/
	    	, {id: 'obtDt'     } /*취득일(YYYY-MM-Dd)*/
	    	, {id: 'rlisDt'    } /*실사일*/
	    	, {id: 'dsuDt'     } /*폐기일*/
			, {id: 'mkNm'      } /*Maker 명*/
			, {id: 'useUsf'    } /*사용 용도*/
			, {id: 'tagYn'     } /*태그 여부*/
			, {id: 'prcDpt'    } /*구입처*/
			, {id: 'fxaSpc'    } /*고정자산 SPECIFICATION*/
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

	fxaDtlDataSet.on('load', function(e) {

    	// 이미지표시
    	if( fxaDtlDataSet.getCount() > 0 && !Rui.isEmpty(fxaDtlDataSet.getAt(0).get("attcFilId")) ){
    		Rui.getDom('fxaImage').src = "<c:url value='/system/attach/downloadAttachFile.do'/>?attcFilId="+fxaDtlDataSet.getAt(0).get("attcFilId")+"&seq="+fxaDtlDataSet.getAt(0).get("attcFilSeq");
//    		Rui.getDom('fxaImage').width  = imageWidth;
//    	    Rui.getDom('fxaImage').height = imageHeight;
    	}else{
    		Rui.getDom('fxaImage').height = 200;
    	}

    });

	/* [DataSet] bind */
    var fxaDtlBind = new Rui.data.LBind({
        groupId: 'fxaDtlPopupForm',
        dataSet: fxaDtlDataSet,
        bind: true,
        bindInfo: [
              {id: 'fxaInfoId' ,  ctrlId: 'fxaInfoId',      value: 'html' }
	    	, {id: 'fxaNm',       ctrlId: 'spnFxaNm',      value: 'html' }
	    	, {id: 'fxaNo',       ctrlId: 'spnFxaNo',      value: 'html' }
	    	, {id: 'fxaStCd',     ctrlId: 'fxaStCd',      value: 'html' }
	    	, {id: 'wbsCd',       ctrlId: 'wbsCd',      value: 'html' }
	    	, {id: 'prjCd',       ctrlId: 'prjCd',      value: 'html' }
	    	, {id: 'crgrNm',      ctrlId: 'spnCrgrNm',      value: 'html' }
	    	, {id: 'fxaLoc',      ctrlId: 'spnFxaLoc',      value: 'html' }
	    	, {id: 'fxaClss',     ctrlId: 'spnFxaClss',      value: 'html' }
	    	, {id: 'fxaQty',      ctrlId: 'spnFxaQty',      value: 'html' }
	    	, {id: 'fxaUtmNm',    ctrlId: 'spnFxaUtmNm',      value: 'html' }
	    	, {id: 'obtPce',      ctrlId: 'spnObtPce',      value: 'html' }
	    	, {id: 'bkpPce',      ctrlId: 'spnBkpPce',      value: 'html' }
	    	, {id: 'obtDt' ,      ctrlId: 'spnObtDt',      value: 'html' }
	    	, {id: 'rlisDt',      ctrlId: 'spnRlisDt',      value: 'html' }
	    	, {id: 'dsuDt',       ctrlId: 'dsuDt',      value: 'html' }
			, {id: 'mkNm' ,       ctrlId: 'spnMkNm',      value: 'html' }
			, {id: 'useUsf',      ctrlId: 'spnUseUsf',      value: 'html' }
			, {id: 'tagYn',       ctrlId: 'spnTagYn',      value: 'html' }
			, {id: 'prcDpt',      ctrlId: 'spnPrcDpt',      value: 'html' }
			, {id: 'fxaSpc',      ctrlId: 'spnFxaSpc',      value: 'html' }
	    	, {id: 'tagYn',       ctrlId: 'tagYn',      value: 'html' }
	    	, {id: 'imgFilPath',  ctrlId: 'imgFilPath',      value: 'html' }
	    	, {id: 'imgFilNm',    ctrlId: 'imgFilNm',      value: 'html' }
        ]
    });

	// 온로드시 조회
    fnSearch();

}); // end RUI Lodd

<%--/*******************************************************************************
 * FUNCTION 명 : fnSearch
 * FUNCTION 기능설명 : MBO 단건 조회(popupDataSet0302)
 *******************************************************************************/--%>
function fnSearch(){

	fxaDtlDataSet.load({
        url: '<c:url value="/prj/rsst/retrieveFxaDtlSearchInfo.do"/>' ,
        params :{
        	fxaInfoId : fxaDtlPopupForm.hFxaInfoId.value
        }
    });


}

</script>
</head>

<body>

<!-- 	<div class="titArea">
		<h3>자산 상세정보</h3>
	</div> -->

<div class="LblockMainBody">
	<div class="sub-content">

	<form name="fxaDtlPopupForm" id="fxaDtlPopupForm" method="post">
		<input type="hidden" id="hFxaInfoId" name="hFxaInfoId" value="<c:out value='${inputData.fxaInfoId}'/>"/>

		<table class="table">
			<colgroup>
				<col style="width:15%;"/>
				<col style="width:35%;"/>
				<col style="width:15%;"/>
				<col style="width:35%;"/>
			</colgroup>
			<tbody>
				<tr>
					<th align="right">자산번호</th>
					<td>
						<span id="spnFxaNo"></span>
					</td>
					<th align="right">자산명</th>
					<td>
						<span id="spnFxaNm"></span>
					</td>
				</tr>
				<tr>
					<th align="right">자산클래스</th>
					<td>
						<span id="spnFxaClss"></span>
					</td>
					<th align="right">수량</th>
					<td>
						<span id="spnFxaQty"></span>
					</td>
				</tr>
				<tr>
					<th align="right">단위</th>
					<td>
						<span id="spnFxaUtmNm"></span>
					</td>
					<th align="right">담당자</th>
					<td>
						<span id="spnCrgrNm"></span>
					</td>
				</tr>
				<tr>
					<th align="right">취득일</th>
					<td>
						<span id="spnObtDt"></span>
					</td>
					<th align="right">실사일</th>
					<td>
						<span id="spnRlisDt"></span>
					</td>
				</tr>
				<tr>
					<th align="right">위치</th>
					<td>
						<span id="spnFxaLoc"></span>
					</td>
					<th align="right">취득가</th>
					<td>
						<span id="spnObtPce"></span>
					</td>
				</tr>
				<tr>
					<th align="right">장부가</th>
					<td>
						<span id="spnBkpPce"></span>
					</td>
					<th align="right">Maker/모델명</th>
					<td>
						<span id="spnMkNm"></span>
					</td>
				</tr>
				<tr>
					<th align="right">구입처</th>
					<td>
						<span id="spnPrcDpt"></span>
					</td>
					<th align="right">Spec</th>
					<td>
						<span id="spnFxaSpc"></span>
					</td>
				</tr>
				<tr>
					<th align="right">용도</th>
					<td>
						<span id="spnUseUsf"></span>
					</td>
					<th align="right">태그</th>
					<td>
						<span id="spnTagYn"></span>
					</td>
				</tr>
				<tr>
					<th align="right">이미지</th>
					<td colspan="3">
						<img id="fxaImage"/>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	
	</div><!-- end sub-content -->
</div><!-- end LblockMainBody -->

</body>
</html>