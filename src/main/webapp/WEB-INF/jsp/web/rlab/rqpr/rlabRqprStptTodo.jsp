<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprStptTodo.jsp
 * @desc    : 신뢰성만족도 Todo
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 2차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .L-navset {overflow:hidden;}
</style>

	<script type="text/javascript">

		var callback;
		var rlabRqprDataSet;
		var opiId;
		var rqprId = '${inputData.MW_TODO_REQ_NO}';

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
 				/* if(rlabRqprStptDataSet.getNameValue(0, 'rlabAllStpt')=="0" || rlabRqprStptDataSet.getNameValue(0, 'rlabAllStpt')==""){
					$("#saveStpt").show();
					$("#rsltStpt").hide();
				}else{
					$("#saveStpt").hide();
					$("#rsltStpt").show();
					var rlabCnsQltyWidth = rlabRqprStptDataSet.getNameValue(0, 'rlabCnsQlty')*20;
					var rlabTrmQltyWidth = rlabRqprStptDataSet.getNameValue(0, 'rlabTrmQlty')*20;
					var rlabAllStptWidth = rlabRqprStptDataSet.getNameValue(0, 'rlabAllStpt')*20;
					$("#rlabCnsQltyRslt").width(rlabCnsQltyWidth+"%");
					$("#rlabTrmQltyRslt").width(rlabTrmQltyWidth+"%");
					$("#rlabAllStptRslt").width(rlabAllStptWidth+"%");
				}
 */
            });

            dm.on('success', function(e) {
                dm.loadDataSet({
                    dataSets: [rlabRqprDataSet, rlabRqprStptDataSet],
                    url: '<c:url value="/rlab/getRlabRqprDetailInfo.do"/>',
                    params: {
                        rqprId: rqprId
                    }
                });

            });


            rlabScnCdDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabScnCdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'COM_DTL_CD' }
                	, { id: 'COM_DTL_NM' }
                ]
            });

            rlabScnCdDataSet.load({
                url: '<c:url value="/common/code/retrieveCodeListForCache.do"/>',
                params :{
                	comCd : 'RLAB_SCN_CD'
                }
            });








            var vm = new Rui.validate.LValidatorManager({
            	validators:[
                        { id: 'rlabNm',				validExp: '시험명:true:maxByteLength=100' },
                        { id: 'rlabSbc',			validExp: '시험목적:true' },
        				{ id: 'rlabProdCd',			validExp: '시료 제품군:true' },
                        { id: 'rlabScnCd',			validExp: '시험구분:true' },
                        { id: 'rlabUgyYn',			validExp: '긴급유무:true' },
                        { id: 'infmTypeCd',			validExp: '통보유형:true' },
                        { id: 'rlabChrgId',			validExp: '시험담당자:true' },
                        { id: 'smpoTrtmCd',			validExp: '시료처리:true' },
        				{ id: 'smpoNm',				validExp: '시료명:true:maxByteLength=100' },
                        { id: 'mkrNm',				validExp: '제조사:true:maxByteLength=100' },
                        { id: 'mdlNm',				validExp: '모델명:true:maxByteLength=100' },
                        { id: 'smpoQty',			validExp: '수량:true:number' }
                ]
            });

            rlabRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId' }
                	, { id: 'rlabNm' }
					, { id: 'rlabSbc' }
					, { id: 'acpcNo' }
					, { id: 'acpcStNm' }
					, { id: 'rgstNm' }
					, { id: 'rqprDeptNm' }
					, { id: 'rqprDt' }
					, { id: 'acpcDt' }
					, { id: 'cmplParrDt' }
					, { id: 'cmplDt' }
					, { id: 'rlabScnCd' }
					, { id: 'rlabChrgId' }
					, { id: 'rlabChrgNm' }
					, { id: 'rlabUgyYn' }
					, { id: 'infmTypeCd' }
					, { id: 'smpoTrtmCd' }
					, { id: 'infmPrsnIds' }
					, { id: 'rlabRqprInfmView' }
					, { id: 'rlabRsltSbc' }
					, { id: 'rlabAcpcStCd' }
					, { id: 'rqprAttcFileId', defaultValue: '' }
					, { id: 'reqItgRdcsId' }
                ]
            });

            var rlabRqprSmpoDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprSmpoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'smpoId' }
                	, { id: 'rqprId', defaultValue: '${inputData.rqprId}' }
					, { id: 'smpoNm' }
					, { id: 'mkrNm' }
					, { id: 'mdlNm' }
					, { id: 'smpoQty', type: 'number' }
                ]
            });



          	/////////////////////////////////////////////////
          	//만족도
          	/* 시험 상담의 질 만족도 */
          	var rlabCnsQlty = new Rui.ui.form.LRadioGroup({
         		    applyTo : 'rlabCnsQlty',
         		    name : 'rlabCnsQlty',
         		    items : [
         		        {
         		            label : '도움 안됨',
         		            width : 100,
         		            value : '1'
         		        }, {
         		            label : '단순 참조',
         		           width : 100,
         		            value : '2'
         		        }, {
         		            label : '약간 도움',
         		           width : 100,
         		            value : '3'
         		        }, {
         		            label : '유익함',
         		           width : 100,
         		            value : '4'
         		        }, {
         		            label : '매우 유익함',
         		           width : 100,
         		            value : '5'
         		        }
         		    ]
              });

          	/* 시험 완료 기간 만족도 */
          	var rlabTrmQlty = new Rui.ui.form.LRadioGroup({
         		    applyTo : 'rlabTrmQlty',
         		    name : 'rlabTrmQlty',
         		    items : [
         		        {
         		            label : '도움 안됨',
         		            width : 100,
         		            value : '1'
         		        }, {
         		            label : '단순 참조',
         		            width : 100,
         		            value : '2'
         		        }, {
         		            label : '약간 도움',
         		            width : 100,
         		            value : '3'
         		        }, {
         		            label : '유익함',
         		           	width : 100,
         		            value : '4'
         		        }, {
         		            label : '매우 유익함',
         		            width : 100,
         		            value : '5'
         		        }
         		    ]
              });

          	/* 전체적인 만족도 */
          	var rlabAllStpt = new Rui.ui.form.LRadioGroup({
         		    applyTo : 'rlabAllStpt',
         		    name : 'rlabAllStpt',
         		    items : [
         		        {
         		            label : '도움 안됨',
         		            width : 100,
         		            value : '1'
         		        }, {
         		            label : '단순 참조',
         		            width : 100,
         		            value : '2'
         		        }, {
         		            label : '약간 도움',
         		            width : 100,
         		            value : '3'
         		        }, {
         		            label : '유익함',
         		            width : 100,
         		            value : '4'
         		        }, {
         		            label : '매우 유익함',
         		            width : 100,
         		            value : '5'
         		        }
         		    ]
              });

			var rlabRqprStptDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprStptDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId' }
                	, { id: 'rlabCnsQlty'	}
					, { id: 'rlabTrmQlty'		}
					, { id: 'rlabAllStpt'		}
                ]
            });

          	rlabRqprStptBind = new Rui.data.LBind({
                groupId: 'bform',
                dataSet: rlabRqprStptDataSet,
                bind: true,
                bindInfo: [
					{ id: 'rqprId',				ctrlId: 'rqprId',			value:'value'},
                    { id: 'rlabCnsQlty',		ctrlId: 'rlabCnsQlty',		value:'value'},
					{ id: 'rlabTrmQlty',		ctrlId: 'rlabTrmQlty',		value:'value'},
					{ id: 'rlabAllStpt',		ctrlId: 'rlabAllStpt',		value:'value'},
                ]
            });

          	rlabRqprStptDataSet.on('load', function(e) {
 				if(rlabRqprStptDataSet.getNameValue(0, 'rlabAllStpt')=="0"){
					$("#saveStpt").show();
					$("#rsltStpt").hide();
				}else{
					$("#saveStpt").hide();
					$("#rsltStpt").show();
					var rlabCnsQltyWidth = rlabRqprStptDataSet.getNameValue(0, 'rlabCnsQlty')*20;
					var rlabTrmQltyWidth = rlabRqprStptDataSet.getNameValue(0, 'rlabTrmQlty')*20;
					var rlabAllStptWidth = rlabRqprStptDataSet.getNameValue(0, 'rlabAllStpt')*20;
					$("#rlabCnsQltyRslt").width(rlabCnsQltyWidth+"%");
					$("#rlabTrmQltyRslt").width(rlabTrmQltyWidth+"%");
					$("#rlabAllStptRslt").width(rlabAllStptWidth+"%");
				}
            });

          //만족도 저장
            rlabStptSave = function() {
            	var rlabCnsQltyVal = rlabCnsQlty.getValue();
            	var rlabTrmQltyVal = rlabTrmQlty.getValue();
            	var rlabAllStptVal = rlabAllStpt.getValue();

            	if(!rlabCnsQltyVal){
            		alert("시험 상담의 질 만족도를 선택해 주세요.");
            		return;
            	}

            	if(!rlabTrmQltyVal){
            		alert("시험완료기간 만족도를 선택해 주세요.");
            		return;
            	}

            	if(!rlabAllStptVal){
            		alert("전체적인 만족도를 선택해 주세요.");
            		return;
            	}

            	if(confirm('저장 하시겠습니까?')) {
               		dm.updateDataSet({
                        url:'<c:url value="/rlab/saveRlabRqprStpt.do"/>',
                        //dataSets:[dataSet]
                        params: {
                        	rqprId : rqprId
                        	, rlabCnsQlty : rlabCnsQltyVal
    	    	         	, rlabTrmQlty : rlabTrmQltyVal
    	    	         	, rlabAllStpt : rlabAllStptVal
    	    	       }
                    });

               	}
            };

          	/////////////////////////////////////////////////
            dm.loadDataSet({
                dataSets: [rlabRqprDataSet, rlabRqprStptDataSet],
                url: '<c:url value="/rlab/getRlabRqprDetailInfo.do"/>',
                params: {
                    rqprId: rqprId
                }
            });




        });
	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="rlabNm" value="${inputData.rlabNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="rgstId" value="${inputData.rgstId}"/>
		<input type="hidden" name="rlabChrgNm" value="${inputData.rlabChrgNm}"/>
		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="rlabAcpcStCd" value="${inputData.rlabAcpcStCd}"/>
		<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
   		<div class="contents">
   			<div class="titleArea">

   				<h2>신뢰성 만족도 평가</h2>
   			</div>


   				<div id="rlabRqprStptDiv">
   				<form name="bform" id="bform" method="post">
   				<table class="table" id="saveStpt">
   					<colgroup>
   						<col style="width:20%;"/>
   						<col style="width:60%;"/>
   						<col style="width:20%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th>시험 상담의 질</th>
   							<td>
   								<div id="rlabCnsQlty"></div>
   							</td>
   							<td class="t_center" rowspan="3">
   								<a style="cursor: pointer;" onclick="rlabStptSave();" class="btnL">저장</a>
   							</td>
   						</tr>
   						<tr>
   							<th>시험 완료 기간</th>
   							<td>
   								<div id="rlabTrmQlty"></div>
   							</td>
   						</tr>
   						<tr>
   							<th>전체적인 만족도</th>
   							<td>
   								<div id="rlabAllStpt"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<table class="table" id="rsltStpt">
   					<colgroup>
						<col style="width:30%;">
						<col style="width:10%;">
						<col style="width:50%;">
						<col style="width:10%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<th>시험 상담의 질</th>
   							<td class="t_right">도움 안됨</td>
   							<td>
   								<div id="rlabCnsQltyRslt" style="background-color:#f1b224;width:0%;height:70%"></div>
   							</td>
   							<td>매우 유익함</td>
   						</tr>
   						<tr>
   							<th>시험 완료 기간</th>
   							<td class="t_right">도움 안됨</td>
   							<td>
   								<div id="rlabTrmQltyRslt" style="background-color:#f1b224;width:0%;height:70%"></div>
   							</td>
   							<td>매우 유익함</td>
   						</tr>
   						<tr>
   							<th>전체적인 만족도</th>
   							<td class="t_right">도움 안됨</td>
   							<td>
   								<div id="rlabAllStptRslt" style="background-color:#f1b224;width:0%;height:70%"></div>
   							</td>
   							<td>매우 유익함</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				</form>
   				</div>
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>