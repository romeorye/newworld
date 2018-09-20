<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: wbsStdDtl.jsp
 * @desc    :  GRS 상세정보
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.28  jih		최초생성
 * ---	-----------	----------	-----------------------------------------
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTreeGridSelectionModel.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTreeGridView.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTreeGridView.css"/>

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


        /*******************
          * 변수 및 객체 선언 START
        *******************/

        /*******************
          * 변수 및 객체 선언 END
        *******************/
        /*******************
         * 그리드 셋팅 START
         *******************/

         var gridDataSet = new Rui.data.LJsonDataSet({ //listGrid dataSet
 			id: 'gridDataSet',
 		    fields: [
 	                { id: 'stdSn'},      //표준일정일련번호
 	                { id: 'wbsSn'},      //WBS일련번호
 	                { id: 'pidSn'},      //PID
 	                { id: 'depth', type: 'number', defaultValue: 0 },
 	                { id: 'deptSeq' , type: 'number' },    //순서
 	                { id: 'wbsNm'},      //WBS명
 	                { id: 'strtDt'},     //시작일
 	                { id: 'fnhDt'},      //종료일
 	                { id: 'attcFilId'},	 //첨부파일
 	                { id: 'wgvl' , type: 'number' , defaultValue: 100 }  ,      //가중치
 	                { id: 'trm'}         //기간
 	                ]
		});


        var columnModel = new Rui.ui.grid.LColumnModel({  //listGrid column
            columns: [
                new Rui.ui.grid.LNumberColumn(),
          			{ field: 'wbsNm',     		label: 'WBS명', sortable: false, align:'left', width: 300  },
          			{ field: 'trm',     		label: '기간',   sortable: false, align:'center', width: 175 },
          			{ field: 'wgvl',    		label: '가중치',  sortable: false, align:'center', width: 120   },
          		    { field: 'attcFilId',     	label: '템플릿',  sortable: false, align:'right', width: 170 ,

          				 renderer: function(val, p, record, row, i){
          					 if(val !=""){
          						 return '<button type="button" class="L-grid-button L-popup-action">첨부파일</button>';
          					 }
          				 }

          		    },



            ]
        });



 			var treeGridView = new Rui.ui.grid.LTreeGridView({
                defaultOpenDepth: 100,
                columnModel: columnModel,
                dataSet: gridDataSet,
                fields: {
                	//depth 값은 0 부터 시작하여야 하며 반드시 number형 이어야 합니다.
                    depthId: 'depth'
                },
                treeColumnId: 'wbsNm'
            });


            var grid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: gridDataSet,

                view: treeGridView,
                selectionModel: new Rui.ui.grid.LTreeGridSelectionModel(),

                autoWidth: true,
                // LGridStatusBar는 샘플용으로 사용
//                 footerBar: new Rui.ui.grid.LGridStatusBar(),
                height: 400
            });

            grid.on('popup', function(e) {
                popupRow = e.row;

                var filId = gridDataSet.getNameValue(popupRow, "attcFilId");

                openAttachFileDialog(setAttachFileInfo, stringNullChk(filId), 'prjPolicy', '*', pageMode)
            });

            grid.render('listGrid'); //listGrid render




        /*******************
         * 그리드 셋팅 END
        *******************/
        <%--/*******************************************************************************
         * FUNCTION 명 : setAttachFileInfo
         * FUNCTION 기능설명 : 첨부파일
         *******************************************************************************/--%>
        //첨부파일
        setAttachFileInfo = function(attachFileList) {
            if(attachFileList.length > 0) {
                dataSet2.setNameValue(popupRow, "attcFilId", attachFileList[0].data.attcFilId);
            }
        };

        <%--/*******************************************************************************
        * FUNCTION 명 : 목록이동
        * FUNCTION 기능설명 : 목록이동
        *******************************************************************************/--%>
        /* [버튼] 목록 */
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(document.xform, "<c:url value='/prj/mgmt/wbsStd/wbsStdList.do'/>");
        });


        <%--/*******************************************************************************
        * FUNCTION 명 : 상세내용정보조회
        * FUNCTION 기능설명 : data  조회
        *******************************************************************************/--%>
        /* 상세내역 가져오기 */
        fnDtlLstInfo = function() {
         var stdSn = '${inputData.stdSn}';
         gridDataSet.load({
                url: '<c:url value="/prj/mgmt/wbsStd/retrieveWbsStdDtl.do"/>',
                params :{
                	stdSn : stdSn
                }
            });


        };

       fnDtlLstInfo();


   });

</script>
</head>

<body>
<Tag:saymessage/><!--  sayMessage 사용시 필요 -->

	<div class="contents" >
		<div class="titleArea">
			<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
   			<h2>표준 WBS 상세</h2>
   		</div>
		<div class="sub-content">
		<div id="LblockDetail01" class="LblockDetail">
			<form name="xform" id="xform" method="post">
				<input type=hidden name='_userId' value='<c:out value="${inputData._userId}"/>'>
				<input type="hidden" id='stdSn' name='stdSn'   value='<c:out value="${inputData.stdSn}"/>' />

				<input type="hidden" id='wbsScnCd' name=wbsScnCd   value='<c:out value="${inputData.wbsScnCd}"/>' />
				<input type="hidden" id='stdTitl' name='stdTitl'   value='<c:out value="${inputData.stdTitl}"/>' />

				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>

   						<tr>
   							<th align="right">WBS 구분</th>
   							<td>
                               <c:out value='${inputData.wbsScnNmRe}' />
   							</td>

   							<th align="right">표준일정명</th>
   							<td>
   								 <c:out value='${inputData.stdTitlRe}' />
   							</td>

   							</tr>

   					</tbody>
   				</table>
			</form>
			</div>
			    <div id="listGrid" style="margin-top:20px"></div>
            	<div class="titArea btn_btm">
   					<div class="LblockButton">
       							<button type="button" id="btnList">목록</button>
   					</div>
   				</div>

		</div>
	</div>
</body>
</html>