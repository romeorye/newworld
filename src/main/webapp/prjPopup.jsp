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

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

			 <%-- TextBox --%>
			    ltWbsCd = new Rui.ui.form.LTextBox({
			    	applyTo: 'wbsCd',
			    	attrs: {
			    			maxLength: 6
			    			}
			    	});
			    ltPrjNm = new Rui.ui.form.LPopupTextBox({
			    	applyTo: 'prjNm',
			    	width : 300,
			    	editable: true,
			    	attrs: {
			    			maxLength: 33
			    			}
			    	});
			    ltPrjNm.on('popup', function(e){
			    	openPrjSearchDialog(setPrjInfo,'');
			    });


			    //과제Form
			    tssNm = new Rui.ui.form.LPopupTextBox({
			    	applyTo: 'tssNm',
			    	width : 300,
			    	editable: true,
			    });
			    tssNm.on('popup', function(e){
			    	openTssSearchDialog(setTssInfo, '');
			    });

			    tssCd = new Rui.ui.form.LTextBox({
                    applyTo: 'tssCd'
                });


			 	// 프로젝트 팝업 DIALOG
			    prjSearchDialog = new Rui.ui.LFrameDialog({
			        id: 'prjSearchDialog',
			        title: '프로젝트 조회',
			        width: 600,
			        height: 500,
			        modal: true,
			        visible: false
			    });

			    prjSearchDialog.render(document.body);

				openPrjSearchDialog = function(f,p) {
					var param = '?searchType=';
					if( !Rui.isNull(p) && p != ''){
						param += p;
					}

					_callback = f;

					prjSearchDialog.setUrl('<c:url value="/prj/rsst/mst/retrievePrjSearchPopup.do"/>' + param);
					prjSearchDialog.show();
				};

				setPrjInfo = function(prjInfo) {
					clearPrjInfo();

					ltPrjNm.setValue(prjInfo.prjNm);
					ltWbsCd.setValue(prjInfo.wbsCd);
					Rui.get('spnSaName').html(prjInfo.plEmpName);
					Rui.get('spnDeptName').html(prjInfo.deptName);

			    };

			    clearPrjInfo = function(prjInfo) {
					ltPrjNm.setValue('');
					ltWbsCd.setValue('');
					Rui.get('spnSaName').html('');
					Rui.get('spnDeptName').html('');

			    };


			 	// 과제 팝업 DIALOG
			    tssSearchDialog = new Rui.ui.LFrameDialog({
			        id: 'tssSearchDialog',
			        title: '과제 조회',
			        width: 600,
			        height: 500,
			        modal: true,
			        visible: false
			    });

			    tssSearchDialog.render(document.body);

				openTssSearchDialog = function(f) {
					_callback = f;

					tssSearchDialog.setUrl('<c:url value="/prj/tss/com/tssSearchPopup.do"/>');
					tssSearchDialog.show();
				};

				setTssInfo = function(tssInfo) {
				    tssNm.setValue(tssInfo.tssNm);
				    tssCd.setValue(tssInfo.wbsCd);
			    };
        });
	</script>

    </head>
    <body>

		<div class="titArea">
			<div class="LblockButton">
				<button type="button" class="btn"  id="prjSearchBtn" name="prjSearchBtn" onclick="openPrjSearchDialog(setPrjInfo,'')">프로젝트조회</button>
				<button type="button" class="btn"  id="prjSearchBtn" name="prjSearchBtn" onclick="openPrjSearchDialog(setPrjInfo,'ALL')">프로젝트조회(전체조직)</button>
				<button type="button" class="btn"  id="tssSearchBtn" name="tssSearchBtn" onclick="openTssSearchDialog(setTssInfo)">과제목록</button>
			</div>
		</div>
	 	<form name="topForm" id="topForm" method="post">
	   		<table class="searchBox" id="pjtMstInfo">
				<colgroup>
					<col style="width:15%"/>
					<col style="width:30%"/>
					<col style="width:15%"/>
					<col style="width:*"/>
				</colgroup>
				<tbody>
				    <tr>
						<th align="right">WBS 코드</th>
						<td>
							<input type="text" class="" id="wbsCd" name="wbsCd" value="" >
						</td>
						<th align="right"><label for="lPrjNm">프로젝트명</label></th>
						<td>
							<input type="text" class="" id="prjNm" name="prjNm" value="" >
							<a style="cursor: pointer;" onclick="openPrjSearchDialog(setPrjInfo,'');" class="icoBtn">검색</a>
						</td>
					</tr>
						<tr>
						<th align="right">PL 명</th>
						<td><span id="spnSaName"></span></td>
						<th align="right">조직</th>
						<td>
							<span id="spnDeptName"></span>
						</td>
					</tr>
					</tr>
						<tr>
						<th align="right">과제명</th>
						<td><input type="text" id="tssNm" /></td>
						<th align="right">과제코드</th>
						<td><input type="text" id="tssCd" /></td>
					</tr>
				</tbody>
			</table>
	  		</form>

    </body>
</html>