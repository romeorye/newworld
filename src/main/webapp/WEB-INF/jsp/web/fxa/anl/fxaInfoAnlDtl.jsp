<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoDtl.jsp
 * @desc    : 자산 상세정보 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.09.11  IRIS05		최초생성
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

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript">
var fxaDtlDataSet; // 자산 상세정보 데이터셋

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
		    	, {id: 'prjNm'     } /*PJT 코드*/
		    	, {id: 'crgrNm'    } /*담당자명*/
		    	, {id: 'fxaLoc'    } /*고정자산 위치*/
		    	, {id: 'fxaArea'    } /*고정자산 위치*/
		    	, {id: 'fxaClss'   } /*고정자산 클래스*/
		    	, {id: 'fxaQty'   , defaultValue: 0  } /*고정자산 수량*/
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
		    	, {id: 'attcFilPath'} /*이미지 FILE PATH*/
		    	, {id: 'attcFilId'} /*이미지 FILE PATH*/
		    	, {id: 'seq'} /*이미지 FILE PATH*/
		    ]
		});

		fxaDtlDataSet.on('load', function(e) {
	    	// 이미지표시
	    	if(fxaDtlDataSet.getNameValue(0, "attcFilId") ){
	    		var param = "?attcFilId="+ fxaDtlDataSet.getNameValue(0, "attcFilId")+"&seq="+fxaDtlDataSet.getNameValue(0, "seq");
	    		Rui.getDom('fxaImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
	    		Rui.getDom('fxaImage').width = '200';
	    	    Rui.getDom('fxaImage').height = '300';
	    	}
	    });

		/* [DataSet] bind */
	    var fxaDtlBind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: fxaDtlDataSet,
	        bind: true,
	        bindInfo: [
	              {id: 'fxaInfoId' ,  ctrlId: 'fxaInfoId',		value: 'value' }
		    	, {id: 'fxaNm',       ctrlId: 'spnFxaNm', 		value: 'html' }
		    	, {id: 'fxaNo',       ctrlId: 'spnFxaNo',   	value: 'html' }
		    	, {id: 'fxaStCd',     ctrlId: 'fxaStCd',    	value: 'html' }
		    	, {id: 'wbsCd',       ctrlId: 'wbsCd',      	value: 'html' }
		    	, {id: 'prjNm',       ctrlId: 'prjNm',      	value: 'html' }
		    	, {id: 'crgrNm',      ctrlId: 'spnCrgrNm',     	value: 'html' }
		    	, {id: 'fxaLoc',      ctrlId: 'spnFxaLoc',      value: 'html' }
		    	, {id: 'fxaClss',     ctrlId: 'spnFxaClss',     value: 'html' }
		    	, {id: 'fxaQty',      ctrlId: 'spnFxaQty',      value: 'html' }
		    	, {id: 'fxaUtmNm',    ctrlId: 'spnFxaUtmNm',    value: 'html' }
		    	, {id: 'obtPce',      ctrlId: 'spnObtPce',      value: 'html' ,
	               	 renderer: function(value, p, record){
	  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
	  		        }
	              }
		    	, {id: 'bkpPce',      ctrlId: 'spnBkpPce',      value: 'html' ,
	               	 renderer: function(value, p, record){
		  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
		  		        }
		              }
		    	, {id: 'obtDt' ,      ctrlId: 'spnObtDt',      	value: 'html' }
		    	, {id: 'rlisDt',      ctrlId: 'spnRlisDt',      value: 'html' }
		    	, {id: 'dsuDt',       ctrlId: 'dsuDt',      	value: 'html' }
				, {id: 'mkNm' ,       ctrlId: 'spnMkNm',      	value: 'html' }
				, {id: 'useUsf',      ctrlId: 'spnUseUsf',      value: 'html' }
				, {id: 'tagYn',       ctrlId: 'spnTagYn',      	value: 'html' }
				, {id: 'prcDpt',      ctrlId: 'spnPrcDpt',      value: 'html' }
				, {id: 'fxaArea',  	  ctrlId: 'spnFxaArea',  	value: 'html' }
				, {id: 'fxaSpc',      ctrlId: 'spnFxaSpc',      value: 'html' }
		    	, {id: 'tagYn',       ctrlId: 'tagYn',      	value: 'html' }
		    	, {id: 'attcFilPath', ctrlId: 'attcFilPath',    value: 'html' }
		    	, {id: 'attcFilId',   ctrlId: 'attcFilId',      value: 'html' }
		    	, {id: 'seq', 		  ctrlId: 'seq',      		value: 'html' }
	        ]
	    });

		var fnSearch = function(){
			fxaDtlDataSet.load({
		        url: '<c:url value="/fxa/anl/retrieveFxaDtlSearchInfo.do"/>' ,
		        params :{
		        	fxaInfoId : document.aform.fxaInfoId.value
		        }
		    });
		}

		fnSearch();

		/* [버튼] : 수정페이지로 이동 */
		var butSave = new Rui.ui.LButton('butSave');
		butSave.on('click', function(){
			document.aform.action='<c:url value="/fxa/anl/retrieveFxaAnlUpdate.do"/>';
			document.aform.submit();
		});

		/* [버튼] : 삭제 이동 */
		var butDel = new Rui.ui.LButton('butDel');
		butDel.on('click', function(){
			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
    			alert('삭제했습니다.');
    			fncFxaAnlInfoList();
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
                Rui.alert("Delete Fail");
    	    });

	   		Rui.confirm({
	   			text: '삭제하시겠습니까?',
	   	        handlerYes: function() {
	           	    dm.updateDataSet({
	   	        	    url: "<c:url value='/fxa/anl/deleteFxaInfo.do'/>",
	   	        	    dataSets:[fxaDtlDataSet],
	   	        	    params: {
	   	        	    	fxaInfoId : document.aform.fxaInfoId.value
	        	        }
	   	        	});
	   	        }
	   		});
		});
		
		var adminChk = "<c:out value='${inputData.adminChk}'/>";

		if( adminChk == "Y"){
			butSave.show();
			butDel.show(); 
		}else{
			butSave.hide();
			butDel.hide(); 
		}
		
		/* [버튼] : 자산관리 목록으로 이동 */
		var butList = new Rui.ui.LButton('butList');
		butList.on('click', function(){
			fncFxaAnlInfoList();
		});

		var fncFxaAnlInfoList = function(){
			var rtnUrl = document.aform.rtnUrl.value;
			$('#searchForm > input[name=prjNm]').val(encodeURIComponent($('#searchForm > input[name=prjNm]').val()));
			$('#searchForm > input[name=fxaNm]').val(encodeURIComponent($('#searchForm > input[name=fxaNm]').val()));
			$('#searchForm > input[name=crgrNm]').val(encodeURIComponent($('#searchForm > input[name=crgrNm]').val()));
			
			document.searchForm.action = contextPath+rtnUrl;
			document.searchForm.submit();
		}

	}); // end RUI Lodd


</script>
</head>

<body>
<div class="contents">
	<div class="titleArea">
		<h2>자산 상세정보</h2>
	</div>
<div class="sub-content">
	<form name="searchForm" id="searchForm"  method="post">
		<input type="hidden" name="wbsCd" value="${inputData.wbsCd}"/>
		<input type="hidden" name="prjNm" value="${inputData.prjNm}"/>
		<input type="hidden" name="fxaNm" value="${inputData.fxaNm}"/>
		<input type="hidden" name="fxaNo" value="${inputData.fxaNo}"/>
		<input type="hidden" name="fromDate" value="${inputData.fromDate}"/>
		<input type="hidden" name="toDate" value="${inputData.toDate}"/>
		<input type="hidden" name="crgrNm" value="${inputData.crgrNm}"/>
    </form>
	
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="fxaInfoId" name="fxaInfoId"  value="<c:out value='${inputData.fxaInfoId}'/>">
		<input type="hidden" id="rtnUrl" name="rtnUrl"  value="<c:out value='${inputData.rtnUrl}'/>">

					<div class="LblockButton top">
						<button type="button" id="butSave">수정</button>
						<button type="button" id="butDel">삭제</button>
						<button type="button" id="butList">목록</button>
					</div>
		<table class="table table_txt_right">
			<colgroup>
				<col style="width:10%;"/>
				<col style="width:40%;"/>
				<col style="width:10%;"/>
				<col style="width:40%;"/>
			</colgroup>
			<tbody>
				<tr>
					<th align="right">자산명</th>
					<td>
						<span id="spnFxaNm"></span>
					</td>
					<th align="right">자산번호</th>
					<td>
						<span id="spnFxaNo"></span>
					</td>
				</tr>
				<tr>
					<th align="right">wbsCd</th>
					<td>
						<span id="wbsCd"></span>
					</td>
					<th align="right">프로젝트명</th>
					<td>
						<span id="prjNm"></span>
					</td>
				</tr>
				<tr>
					<th align="right">담당자</th>
					<td>
						<span id="spnCrgrNm"></span>
					</td>
					<th align="right">위치</th>
					<td>
						<span id="spnFxaAreaLoc"></span><span id="spnFxaLoc"></span>
					</td>
				</tr>
				<tr>
					<th align="right">자산클래스</th>
					<td>
						<span id="spnFxaClss"></span>
					</td>
					<th align="right">수량(단위)</th>
					<td>
						<span id="spnFxaQty"></span>(<span id="spnFxaUtmNm"></span>)
					</td>
				</tr>

				<tr>
					<th align="right">취득가</th>
					<td>
						<span id="spnObtPce"></span>
					</td>
					<th align="right">장부가</th>
					<td>
						<span id="spnBkpPce"></span>
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
				</tr>
				<tr>

					<th align="right">Maker/모델명</th>
					<td>
						<span id="spnMkNm"></span>
					</td>
					<th align="right">용도</th>
					<td>
						<span id="spnUseUsf"></span>
					</td>
				</tr>
				<tr>
					<th align="right">태그</th>
					<td>
						<span id="spnTagYn"></span>
					</td>
					<th align="right">구입처</th>
					<td>
						<span id="spnPrcDpt"></span>
					</td>
				</tr>
				<tr>
					<th align="right">Spec</th>
					<td colspan="3">
						<span id="spnFxaSpc"></span>
					</td>
				</tr>
				<tr>
					<th align="right">이미지</th>
					<td colspan="3" width="300" height="300" style="word-break:break-all">
						<img id="fxaImage"/>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	</div>
</div>
</body>
</html>