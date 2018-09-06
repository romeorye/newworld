<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceEvaluationMgmtReqPopup.jsp
 * @desc    : 관련분석 리스트 조회 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.08  dongys		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 2차 프로젝트
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
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">
	var rqprId= window.parent.rqprId;
	var opiId= window.parent.opiId;
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

             //의견
             var opiSbcTxtArea = new Rui.ui.form.LTextArea({
            	 applyTo: 'opiSbc',
                  editable: true,
                  disabled:false,
                  width: 600,
                  height:300
             });

            /*============================================================================
            =================================    DataSet     =============================
            ============================================================================*/
            //dataSet
            var dataSet = new Rui.data.LJsonDataSet({
     	        id: 'dataSet',
     	        remainRemoved: true,
     	        fields: [
                 		  { id: 'rqprId' }
                 		, { id: 'rgstId' }
						, { id: 'rgstNm' }
						, { id: 'rgstDt' }
						, { id: 'opiSbc' }
						, { id: 'attcFilId' }
     		            ]
     	    });

            var bind = new Rui.data.LBind({
    			groupId: 'aform',
    		    dataSet: dataSet,
    		    bind: true,
    		    bindInfo: [
					 { id: 'rqprId', 			ctrlId: 'rqprId', 			value: 'value' },
    		         { id: 'rgstId', 			ctrlId: 'rgstId', 			value: 'value' },
    		         { id: 'rgstNm', 			ctrlId: 'rgstNm', 			value: 'value' },
    		         { id: 'rgstDt', 			ctrlId: 'rgstDt', 			value: 'value' },
    		         { id: 'opiSbc', 			ctrlId: 'opiSbc', 		value: 'value' },
    		         { id: 'attcFilId', 		ctrlId: 'attcFilId', 		value: 'value' },
    		     ]
    		});
            if(opiId=="0"){
            	dataSet.newRecord();
            }else{
            	fnSearch = function() {
    		    	dataSet.load({
    		        url: '<c:url value="/space/getSpaceRqprOpinitionList.do"/>' ,
    	           	params :{
    	           				opiId : opiId,
    	           				rqprId : rqprId
    		                }
    	            });
    	        }
    	       	fnSearch();
            }

            /* prodNm.setValue(prod);
            $('#ctgr0').val(ctgr0);
            $('#ctgr1').val(ctgr1);
            $('#ctgr2').val(ctgr2);
            $('#ctgr3').val(ctgr3); */
            //dataSet.setValue(0,"opiSbc",prod);
            //$('#prodNm').val(prod);
            //alert(dataSet.getNameValue(0,"prodNm"));
            //alert($('#prodNm').val());

          //서버전송용
            var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

            dm.on('success', function(e) {
            	/* parent.fnList();
                parent.mchnDialog.cancel(true); */
                var data = dataSet.getReadData(e);
                if(data.records[0].resultYn == "Y") {
                	//Rui.alert(data.records[0].resultMsg);
                	parent.getSpaceRqprOpinitionList(data.records[0].resultMsg);
                	/* parent.opinitionDialog.cancel(true);
                	parent.opinitionUpdateDialog.cancel(true); */

                }
            });
            dm.on('failure', function(e) {
                var data = dataSet.getReadData(e);
                Rui.alert(data.records[0].resultMsg);
            });

            //저장
            fnSave = function() {

                //dataSet.setValue(0, "rqprId",  rqprId);
                //dataSet.setValue(0,"opiSbc",$('#opiSbc').html());
                //dataSet.setNameValue(0, "rqprId",  rqprId);
                /* alert(1);
                alert($('#opiSbc').html());
                alert($('#opiSbc').val());
                alert(dataSet.getAt(0).data.opiSbc); */

                Rui.confirm({
                    text: '저장하시겠습니까?',
                    handlerYes: function() {
                        dm.updateDataSet({
                            url:'<c:url value="/space/saveSpaceRqprOpinition.do"/>',
                            //dataSets:[dataSet]
                            params: {
                            	rqprId : rqprId
                            	, opiId : opiId
	    	    	         	, opiSbc : document.aform.opiSbc.value
	    	    	         	, attcFilId : document.aform.attcFilId.value
	    	    	       }
                        });
                    },
                    handlerNo: Rui.emptyFn
                });
            }

          //삭제
            fnDel = function() {

                //dataSet.setValue(0, "rqprId",  rqprId);
                //dataSet.setValue(0,"opiSbc",$('#opiSbc').html());
                //dataSet.setNameValue(0, "rqprId",  rqprId);
                /* alert(1);
                alert($('#opiSbc').html());
                alert($('#opiSbc').val());
                alert(dataSet.getAt(0).data.opiSbc); */

                Rui.confirm({
                    text: '삭제하시겠습니까?',
                    handlerYes: function() {
                        dm.updateDataSet({
                            url:'<c:url value="/space/deleteSpaceRqprOpinition.do"/>',
                            //dataSets:[dataSet]
                            params: {
                            	rqprId : rqprId
                            	, opiId : opiId
	    	    	       }
                        });
                    },
                    handlerNo: Rui.emptyFn
                });
            }

            /*************************첨부파일****************************/
    		/* 첨부파일*/
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

    		var attId;
    		//dataset에서 첨부파일 정보가 있을경우
    		dataSet.on('load', function(e) {
    			attId = dataSet.getNameValue(0, "attcFilId");
    			//alert(attId);
                if(!Rui.isEmpty(attId)) getAttachFileList();
            });

    		//첨부파일 정보 조회
       		getAttachFileList = function(){
    			attachFileDataSet.load({
                    url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                    params :{
                        attcFilId : attId
                    }
                });
    		}

    		//첨부파일 조회후 load로 정보 호출
    		attachFileDataSet.on('load', function(e) {
                getAttachFileInfoList();
            });

    		//첨부파일 정보
    		getAttachFileInfoList = function() {
                var attachFileInfoList = [];

                for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                    attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
                }
                setAttachFileInfo(attachFileInfoList);
            };

        	/* [버튼] : 첨부파일 팝업 호출 */
        	var butAttcFil = new Rui.ui.LButton('butAttcFil');
        	butAttcFil.on('click', function(){
        		var attcFilId = document.aform.attcFilId.value;
        		openAttachFileDialog(setAttachFileInfo, attcFilId,'mchnPolicy', '*');
        	});

        	//첨부파일 callback
    		setAttachFileInfo = function(attcFilList) {

               /* if(attcFilList.length > 1 ){
            	   alert("첨부파일은 한개만 가능합니다.");
            	   return;
               }else{
    	           $('#atthcFilVw').html('');
               } */
               $('#atthcFilVw').html('');
               for(var i = 0; i < attcFilList.length; i++) {
                   $('#atthcFilVw').append($('<a/>', {
                       href: 'javascript:downloadAttcFil("' + attcFilList[i].data.attcFilId + '", "' + attcFilList[i].data.seq + '")',
                       text: attcFilList[i].data.filNm
                   })).append('<br/>');
               document.aform.attcFilId.value = attcFilList[i].data.attcFilId;
               dataSet.setNameValue(0, "attcFilId",  document.aform.attcFilId.value);
               }
           	};
          //첨부파일 다운로드
            downloadMnalFil = function(attId, seq){
     	       var param = "?attcFilId=" + attId + "&seq=" + seq;
     	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
     	       	document.aform.submit();

            }

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="rqprId" name="rqprId"/>
		<input type="hidden" id="attcFilId" name="attcFilId" />
		<input type="hidden" id="rgstId" name="rgstId" />
		<input type="hidden" id="rgstNm" name="rgstNm" />
		<input type="hidden" id="rgstDt" name="rgstDt" />


   		<div class="LblockMainBody">

   			<div class="sub-content">

   				<table class="searchBox">
   					<colgroup>
   						<col style="width: 120px;" />
		                <col style="width: *" />
		                <col style="width: 120px;" />
		                <col style="width: *" />
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">의견</th>
   							<td colspan="3">
   								<input type="text" id="opiSbc" value="">
   							</td>
   						</tr>
   						<tr>
							<th align="right">파일</th>
							<td id="atthcFilVw" colspan="2"></td>
							<td>
								<button type="button" id="butAttcFil">첨부파일등록</button>
							</td>
						</tr>
   					</tbody>
   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>