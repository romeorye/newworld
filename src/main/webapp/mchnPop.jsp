<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: prjPopup.jsp
 * @desc    : 프로젝트팝업 샘플
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.07.25  민길문		최초생성
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

<script type="text/javascript">
var openMchnSearchDialog;
var setMchnInfo;

		Rui.onReady(function() {
			var mchnDataSet = new Rui.data.LJsonDataSet({
                id: 'mchnDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	 {id: 'mchnNm'}          //기기명
             		,{id: 'mdlNm'}           //모델명
             		,{id: 'mkrNm'}           //제조사
             		,{id: 'mchnClNm'}        //분류
             		,{id: 'mchnCrgrId'}      //담당자
             		,{id: 'mchnClCd'}        //분류
             		,{id: 'mchnCrgrNm'}      //담당자
             		,{id: 'mchnInfoId'}      //기기 정보 ID
                ]
            });


			<%-- TextBox --%>
			var mchnNm = new Rui.ui.form.LTextBox({
		    	applyTo: 'mchnNm',
		    	attrs: {
		    			maxLength: 6
		    			}
		    });

			var mdlNm = new Rui.ui.form.LPopupTextBox({
		    	applyTo: 'mdlNm',
		    	width : 300,
		    	editable: true,
		    });

			var mkrNm = new Rui.ui.form.LPopupTextBox({
		    	applyTo: 'mkrNm',
		    	width : 300,
		    	editable: true,
		    });

			var mchnClNm = new Rui.ui.form.LPopupTextBox({
		    	applyTo: 'mchnClNm',
		    	width : 300,
		    	editable: true,
		    });

			var mchnCrgrNm = new Rui.ui.form.LPopupTextBox({
		    	applyTo: 'mchnCrgrNm',
		    	width : 300,
		    	editable: true,
		   	});

			var mchnInfoId = new Rui.ui.form.LPopupTextBox({
		    	applyTo: 'mchnInfoId',
		    	width : 300,
		    	editable: true,
		    });

			var mchnCrgrId = new Rui.ui.form.LPopupTextBox({
		    	applyTo: 'mchnCrgrId',
		    	width : 300,
		    	editable: true,
		    });

			var mchnClCd = new Rui.ui.form.LPopupTextBox({
		    	applyTo: 'mchnClCd',
		    	width : 300,
		    	editable: true,
		    });

			var mchnClCd = new Rui.ui.form.LPopupTextBox({
		    	applyTo: 'mchnClCd',
		    	width : 300,
		    	editable: true,
		    });


			/* [ 분산기기 Dialog] */
			mchnDialog = new Rui.ui.LFrameDialog({
		        id: 'mchnDialog',
		        title: '분석기기 목록',
		        width:  900,
		        height: 550,
		        modal: true,
		        visible: false,
		        buttons : [
		            { text:'닫기', handler: function() {
		              	this.cancel(false);
		              }
		            }
		        ]
		    });

			mchnDialog.render(document.body);


			openMchnSearchDialog = function(f) {
		    	_callback = f;
		    	mchnDialog.setUrl('<c:url value="/mchn/open/eduAnl/retrieveMchnInfoPop.do"/>');
		    	mchnDialog.show();
		    };



		    setMchnInfo = function(record){
				mchnNm.setValue(record.get("mchnNm"));
				mdlNm.setValue(record.get("mdlNm"));
				mkrNm.setValue(record.get("mkrNm"));
				mchnCrgrNm.setValue(record.get("mchnCrgrNm"));
				mchnCrgrId.setValue(record.get("mchnCrgrId"));
				mchnClNm.setValue(record.get("mchnClNm"));
				mchnInfoId.setValue(record.get("mchnInfoId"));
				mchnClCd.setValue(record.get("mchnClCd"));
			}



        });
	</script>

    </head>
    <body>

		<div class="titArea">
			<div class="LblockButton">
				<button type="button" class="btn"  id="mchnSearchBtn" name="mchnSearchBtn" onclick="openMchnSearchDialog(setMchnInfo,'')">기기조회</button>
			</div>
		</div>
	 	<form name="topForm" id="topForm" method="post">
	   		<table class="searchBox" id="Info">
				<colgroup>
					<col style="width:15%"/>
					<col style="width:30%"/>
					<col style="width:15%"/>
					<col style="width:*"/>
				</colgroup>
				<tbody>
				    <tr>
						<th align="right">기기명</th>
						<td>
							<input type="text" class="" id="mchnNm" name="mchnNm" >
						</td>
						<th align="right">기기ID</th>
						<td>
							<input type="text" class="" id="mchnInfoId" name="mchnInfoId" >
						</td>
					</tr>
					<tr>
						<th align="right">모델명</th>
						<td><span id="mdlNm"></span></td>
						<th align="right">제조사</th>
						<td>
							<span id="mkrNm"></span>
						</td>
					</tr>
					<tr>
						<th align="right">관리자</th>
						<td><span id="mchnCrgrNm"></span></td>
						<th align="right">관리자id</th>
						<td>
							<span id="mchnCrgrId"></span>
						</td>
					</tr>
					<tr>
						<th align="right">분류코드 </th>
						<td><span id="mchnClCd"></span></td>
						<th align="right">분류</th>
						<td>
							<span id="mchnClNm"></span>
						</td>
					</tr>
				</tbody>
			</table>
			<div id="mhcnGrid"></div>
	  		</form>

    </body>
</html>