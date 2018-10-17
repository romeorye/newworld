<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: prdtListRgst.jsp
 * @desc    : 연구산출물 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.14  			최초생성
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

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tree/rui_tree.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tree/rui_tree.css"/>


<script type="text/javascript">
	document.title = "업무분류 노드 선택";
	var knldAffrTreeDataSet;
	var gvAffrNm = "";
	var affrClGroup = "${inputData.affrClGroup}";
	var affrClNm = "${inputData.affrClNm}";

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
              var dm = new Rui.data.LDataSetManager();

              dm.on('success', function(e) {
                  var data = parent.prdtListRgstDataSet.getReadData(e);

                  alert(data.records[0].resultMsg);

                  if(data.records[0].resultYn == 'Y') {
//                   	parent.callback();
//                   	parent.knldAffrTreeSrhRsltDialog.cancel();
                	  window.close();
                  }
              });

            <%-- DATASET --%>
            var knldAffrTreeDataSet = new Rui.data.LJsonDataSet({
                id: 'knldAffrTreeDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: -1,
                fields: [
                      { id: 'affrClId',     type: 'number' }   /*업무분류ID*/
                    , { id: 'affrClNm'    }                    /*업무분류이름*/
                    , { id: 'affrNm'    }                      /*업무분류괄호이름*/
                    , { id: 'supiAffrClId', type: 'number' }   /*업무분류부모ID*/
                    , { id: 'affrClL',      type: 'number' }   /*업무분류레벨*/
                    , { id: 'affrClGroup' }                    /*게시판이름*/
                    , { id: 'rtrvSeq',      type: 'number' }   /*조회순서*/
                    , { id: 'delYn'       }                    /*삭제여부*/
                ]
            });

            knldAffrTreeDataSet.on('load', function(e) {
            	knldAffrTreeDataSet.setNameValue(0,'affrNm', affrClNm );
            	gvAffrNm = knldAffrTreeDataSet.getNameValue(0,'affrNm');
            	document.getElementById('affrNm').innerHTML = gvAffrNm;
            });

            var knldAffrTreeView = new Rui.ui.tree.LTreeView({
                id: 'knldAffrTreeView',
                dataSet: knldAffrTreeDataSet,
                fields: {
                    rootValue: 0,
                    parentId: 'supiAffrClId',
                    id: 'affrClId',
                    label: 'affrClNm',
                    order: 'rtrvSeq'
                },
                defaultOpenDepth: 0,
                width: 539,
                height: 360,
                useAnimation: true
            });


			knldAffrTreeView.on('focusChanged', function(e) {
				var newNode = e.newNode,
            	record = newNode.getRecord();

				if(record.get('affrClL') < 3) {
            		return;
            	}

				var newNode = e.newNode.getRecord();
				var affrClId = record.get('affrClId');

				knldAffrTreeDataSet.setNameValue(0, 'affrClId', affrClId);
				knldAffrTreeDataSet.setNameValue(0, 'affrNm', getAffrClNm(e.newNode,''));

				gvAffrNm = knldAffrTreeDataSet.getNameValue(0,'affrNm');
				document.getElementById('affrNm').innerHTML = gvAffrNm;

			});

            knldAffrTreeView.render('knldAffrTreeView');

            //function
            getAffrClNm = function(node, affrClNm) {
            	if(node == false) {
        			return affrClNm;
            	} else {
            		if(!Rui.isEmpty(affrClNm)) {
                	affrClNm = '>' + affrClNm;
                }
                	affrClNm = knldAffrTreeDataSet.getNameValue(node.getRow(), 'affrClNm') + affrClNm;

               		return getAffrClNm(node.getParentNode(), affrClNm);
            	}
            };
            //function End

            bind = new Rui.data.LBind({
                groupId: 'fieldWrapper',
                dataSet: knldAffrTreeDataSet,
                bind: true,
                bindInfo: [
                    { id: 'affrNm',	ctrlId:'affrNm', value:'html' }
                ]
            });

            /* 저장버튼 */
			saveBtn = new Rui.ui.LButton('saveBtn');
		    saveBtn.on('click', function() {
		    		prdtListPopupSave();
		     });

		    prdtListPopupSave = function(){

		    	if(gvAffrNm==""){
		    		alert("선택된 노드가 없습니다.");
		    		return;
		    	}
		    	else{
					if(confirm("노드값을 저장하시겠습니까?")){
						var affrNm = knldAffrTreeDataSet.getNameValue(0,'affrNm');
						var affrClId = knldAffrTreeDataSet.getNameValue(0,'affrClId');
						window.parent.fnChildCall(affrNm , affrClId);
	                 	parent.knldAffrTreeSrhRsltDialog.cancel();
// 						opener.fnChildCall(affrNm , affrClId);
// 						window.close();
	                 }
		    	}
			};

            dm.loadDataSet({
                 dataSets: [knldAffrTreeDataSet],
                 url: '<c:url value="/knld/rsst/getKnldProductTreeInfo.do?affrClGroup="/>' + affrClGroup
            });

		 });//onReady 끝

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="prdtId" name="prdtId" value=""/>
<!--    		<div class="contents"> -->

<!--    			<div class="sub-content"> -->
   				<div class="titArea" style="padding-top:0">
   					<div class="LblockButton">
	   					<button type="button" id="saveBtn" name="saveBtn" >저장</button>
	   					<button type="button" id="closeBtn" name="closeBtn" onclick="parent.knldAffrTreeSrhRsltDialog.cancel()">닫기</button>
   					</div>
   			    </div>
   			    <div id="bd">
			        <div class="LblockMarkupCode">
						<div id="fieldWrapper" style="width:100% !important;">
	   						<table class="table table_txt_right" style=" margin-bottom:10px !important;">
			   					<colgroup>
			   						<col style="width:100px;"/>
			   						<col style="width:300px;"/>
			   					</colgroup>
								<tbody>
				   					<tr>
					   					<th align="right">선택된 노드</th>
					   					<td colspan="2">
					   						<div id="affrNm"/>
<!-- 					   						<span id="affrNm"></span> -->
					   					</td>
				   					</tr>
				   				</tbody>
				   			</table>
		   				</div>
			            <div id="contentWrapper">
			                <div id="knldAffrTreeView"></div>
			            </div>
			        </div>
			    </div>

<!--    			</div>//sub-content -->
<!--    		</div>//contents -->
	</form>
    </body>
</html>