<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: knldRtrvRqList.jsp
 * @desc    : Knowledge > 관리 > 조회 요청 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

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

            var rqDocNm = new Rui.ui.form.LTextBox({
                applyTo: 'rqDocNm',
                placeholder: '검색할 요청문서명을 입력해주세요.',
                defaultValue: '<c:out value="${inputData.rqDocNm}"/>',
                emptyValue: '',
                width: 300
            });

            rqDocNm.on('blur', function(e) {
            	rqDocNm.setValue(rqDocNm.getValue().trim());
            });

            rqDocNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getKnldRtrvRqList();
            	}
            });

            var sbcNm = new Rui.ui.form.LTextBox({
                applyTo: 'sbcNm',
                placeholder: '검색할 요청내용을 입력해주세요.',
                defaultValue: '<c:out value="${inputData.sbcNm}"/>',
                emptyValue: '',
                width: 300
            });

            sbcNm.on('blur', function(e) {
            	sbcNm.setValue(sbcNm.getValue().trim());
            });

            sbcNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getKnldRtrvRqList();
            	}
            });

            var knldRtrvRqDataSet = new Rui.data.LJsonDataSet({
                id: 'knldRtrvRqDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'rsstDocId' }
					, { id: 'rtrvRqDocCd' }
					, { id: 'rtrvRqDocNm' }
					, { id: 'docNo' }
					, { id: 'rqDocNm' }
					, { id: 'pgmPath' }
					, { id: 'rqDt' }
					, { id: 'rqNm' }
					, { id: 'rqApprStNm' }
					, { id: 'apprDt' }
					, { id: 'apprNm' }
					, { id: 'docUrl' }
					, { id: 'readFlag' }
                ]
            });

            var knldRtrvRqColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      { field: 'rtrvRqDocNm',	label: '문서종류',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'rqDocNm',		label: '요청문서명',	sortable: false,	align:'left',	width: 550 }
                    , { field: 'pgmPath',		label: '문서경로',		sortable: false,	align:'left',	width: 315 }
                    , { field: 'rqDt',			label: '요청일',		sortable: false,	align:'center',	width: 100 }
					, { field: 'rqNm',			label: '요청자',		sortable: false, 	align:'center',	width: 100 }
					, { field: 'rqApprStNm',	label: '상태',		sortable: false, 	align:'center',	width: 90 }
					, { field: 'apprDt',		label: '승인일',		sortable: false, 	align:'center',	width: 90 }
					, { field: 'docUrl',		hidden:true}
                ]
            });

            var knldRtrvRqGrid = new Rui.ui.grid.LGridPanel({
                columnModel: knldRtrvRqColumnModel,
                dataSet: knldRtrvRqDataSet,
                width: 600,
                height: 400,
                autoToEdit: false,
                autoWidth: true
            });

            knldRtrvRqGrid.on('cellClick', function(e) {

            	var record = knldRtrvRqDataSet.getAt(e.row);

            	if(record.get('readFlag') == 'N') {
            		alert('조회 기간이 지났거나 승인 상태가 아닙니다.');
            		return ;
            	}

            	$('#rtrvRqDocCd').val(record.get('rtrvRqDocCd'));
            	$('#docNo').val(record.get('docNo'));
            	$('#authYn').val(record.get('readFlag'));
            	$('#reUrl').val(record.get('docUrl'));
            	$('#docUrl').val(record.get('docUrl'));

            	//nwinsActSubmit(aform, "<c:url value="/knld/rsst/knldRtrvRqDetail.do"/>");
            	function onSubmit(){
            		 var myForm = document.aform;
            		 var url = "<c:url value="/knld/rsst/knldRtrvRqDetail.do"/>";
            		 window.open("" ,"aform",
            		       "width=1240, height=750, scrollorbars=yes");
            		 myForm.action =url;
            		 myForm.method="post";
            		 myForm.target="aform";
            		myForm.submit();
           		}
            	onSubmit();
            	//var param = "?attcFilId=" + attcFilId;
     	       	//document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
     	       	//document.aform.action = '<c:url value='/knld/rsst/knldRtrvRqDetail.do'/>';
     	       	//document.aform.submit();

            });

            knldRtrvRqGrid.render('knldRtrvRqGrid');

            /* 조회 */
            getKnldRtrvRqList = function() {
            	knldRtrvRqDataSet.load({
                    url: '<c:url value="/knld/mgmt/getKnldRtrvRqList.do"/>',
                    params :{
                    	rqDocNm : encodeURIComponent(rqDocNm.getValue()),
                    	sbcNm : encodeURIComponent(sbcNm.getValue()),
                    	isAdmin : '<c:out value="${inputData._roleId}"/>'.indexOf('WORK_IRI_T01') > -1 ? 1 : 0
                    }
                });
            };

            knldRtrvRqDataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + knldRtrvRqDataSet.getCount() + '건');
   	    		// 목록 페이징
   	            paging(knldRtrvRqDataSet,"knldRtrvRqGrid");
   	      	});

            getKnldRtrvRqList();

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="rtrvRqDocCd" name="rtrvRqDocCd" value=""/>
		<input type="hidden" id="docNo" name="docNo" value=""/>
		<input type="hidden" id="reUrl" name="reUrl" value=""/>
		<input type="hidden" id="authYn" name="authYn" value=""/>

   		<div class="contents">
   			<div class="titleArea">
					<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
        		</a>
   				<h2>조회 요청</h2>
   			</div>

  			<div class="sub-content">
	   			<div class="search">
					<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style="width:300px;"/>
		   						<col style="width:120px;"/>
		   						<col style="width:300px;"/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">요청문서명</th>
		   							<td>
		   								<input type="text" id="rqDocNm">
		   							</td>
		   							<th align="right">요청내용</th>
		   							<td>
		   								<input type="text" id="sbcNm">
		    						</td>
		   							<td class="t_center">
		   								<a style="cursor: pointer;" onclick="getKnldRtrvRqList();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
					</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton" style="line-height:30px;">
   						요청일 기준 15일 간 조회 가능합니다.
   					</div>
   				</div>

   				<div id="knldRtrvRqGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>