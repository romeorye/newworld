<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: attchFilReqPop.jsp
 * @desc    : 임차주택 필수첨부파일 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.11.21  IRIS005  	최초생성
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
<script type="text/javascript">
var lvAttcFilId;;	
	
	Rui.onReady(function() {
		
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
                , { id: 'leasId' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
        
		/*******************
         * 변수 및 객체 선언
         *******************/   
         var dataSet = new Rui.data.LJsonDataSet({
             id: 'dataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
					  { id: 'muagAttcFilId'}	//합의서	
					, { id: 'dplAttcFilId' }	//협약서
					, { id: 'nrmAttcFilId'}		//규정서	
             ]
         });
		
         dataSet.on('load', function(e) {
        	 if( !Rui.isEmpty( dataSet.getNameValue(0, 'muagAttcFilId') )  ){
 				getAttachFileList(dataSet.getNameValue(0, 'muagAttcFilId'));
 			}
 			if( !Rui.isEmpty( dataSet.getNameValue(0, 'dplAttcFilId') )  ){
 				getAttachFileList1(dataSet.getNameValue(0, 'dplAttcFilId'));
 			}
 			if( !Rui.isEmpty( dataSet.getNameValue(0, 'nrmAttcFilId') )  ){
 				getAttachFileList2(dataSet.getNameValue(0, 'nrmAttcFilId'));
 			}
         })
         
         fnSearch = function() {
         	dataSet.load({
             	url: '<c:url value="/knld/leasHousMgmt/retrieveAttchFilInfo.do"/>'
             });
         }
       	
       	fnSearch();
         
         
       	fncSave = function(){
       		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
           	dm.on('success', function(e) {
       			var resultData = resultDataSet.getReadData(e);
       		 	
       			Rui.alert(resultData.records[0].rtnMsg);
       			if( resultData.records[0].rtnSt == "S"){
       			}
       		});

        	dm.on('failure', function(e) {      // 업데이트 실패시
        		var resultData = resultDataSet.getReadData(e);
    	   			Rui.alert(resultData.records[0].rtnMsg);
        	});
        	
       		dm.updateDataSet({
                dataSets:[dataSet],
                url:'<c:url value="/knld/leasHousMgmt/saveAttchFil.do"/>',
                modifiedOnly: false
            });
       		
       	}
       	
      
       	getAttachFileId = function(gbn) {
            var lvAttcFilId;
			
            if ( gbn =="M" ){
            	lvAttcFilId = dataSet.getNameValue(0, 'muagAttcFilId');
           }else if( gbn =="N" ){
            	lvAttcFilId = dataSet.getNameValue(0, 'nrmAttcFilId');
            }else if( gbn =="D" ){
            	lvAttcFilId = dataSet.getNameValue(0, 'dplAttcFilId');
            }
            
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";
            
            return lvAttcFilId;
        }; 
        
       	/* [기능] 첨부파일 조회*/
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
        attachFileDataSet.on('load', function(e) {
            getAttachFileInfoList();
        });
        
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet1 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet1',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet1.on('load', function(e) {
            getAttachFileInfoList1();
        });
        
        /* [기능] 첨부파일 조회*/
        var attachFileDataSet2 = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet2',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet2.on('load', function(e) {
            getAttachFileInfoList2();
        });
         
       	getAttachFileList = function(id) {
            attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                	attcFilId : id
                }
            });
        };
        getAttachFileList1 = function(id) {
            attachFileDataSet1.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                	attcFilId : id
                }
            });
        };
        getAttachFileList2 = function(id) {
            attachFileDataSet2.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                	attcFilId : id
                }
            });
        };
         
        getAttachFileInfoList = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }

            setAttachFileInfo(attachFileInfoList);
        };
        getAttachFileInfoList1 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet1.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet1.getAt(i).clone());
            }

            setAttachFileInfo1(attachFileInfoList);
        };
        getAttachFileInfoList2 = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet2.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet2.getAt(i).clone());
            }

            setAttachFileInfo2(attachFileInfoList);
        };
 		
		
        //합의서
        setAttachFileInfo = function(attachFileList) {
        	var muagAttcFilId;
        		
        	$('#muagAttchFileView').html('');
        	
        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#muagAttchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

            	muagAttcFilId =  attachFileList[0].data.attcFilId;
               	
               	dataSet.setNameValue(0, "muagAttcFilId", muagAttcFilId);
            }
        }
        
        //확약서
        setAttachFileInfo1 = function(attachFileList) {
        	var dplAttcFilId;
        	$('#dplAttchFileView').html('');

        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#dplAttchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

            	dplAttcFilId =  attachFileList[0].data.attcFilId;
               	
            	dataSet.setNameValue(0, "dplAttcFilId", dplAttcFilId);
            }
        }
        
      //규정서
        setAttachFileInfo2 = function(attachFileList) {
        	var nrmAttcFilId;
        	
        	$('#nrmAttchFileView').html('');

        	if(attachFileList.length > 0) {
            	for(var i = 0; i < attachFileList.length; i++) {
                    $('#nrmAttchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

            	nrmAttcFilId =  attachFileList[0].data.attcFilId;
               	
            	dataSet.setNameValue(0, "nrmAttcFilId", nrmAttcFilId);
            }
        }
        
        /*첨부파일 다운로드*/
        downloadAttachFile = function(attcFilId, seq) {
        	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
        	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
        	aform.submit();
        };
	});
	
</script>
</head>
<body>
<div class="LblockMainBody">
<form name="aform" id="aform" method="post">
			
			<div class="titleArea">
		 		<a class="leftCon" href="#">
		       	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		       	<span class="hidden">Toggle 버튼</span>
		       	</a>
		 		<h2>임차주택 필수산출물</h2>
		 	</div>
			
	<div class="sub-content">
			<table class="table table_txt_right">
				<colgroup>
					<col style="width:17%;"/>
					<col style="width:35%;"/>
					<col style="width:35%;"/>
					<col style="width:15%;"/>
				</colgroup>
				<tbody>
					<tr>
						<th>임차주택관리합의서</th>
       			<td  colspan="2" id="muagAttchFileView">&nbsp;</td>
       			<td><button type="button" class="btn" id="muagAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId('M'), 'knldPolicy', '*')">첨부파일등록</button></td>
					</tr>
					<tr>
						<th>확약서</th>
       			<td  colspan="2" id="dplAttchFileView">&nbsp;</td>
       			<td><button type="button" class="btn" id="dplAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo1, getAttachFileId('D'), 'knldPolicy', '*')">첨부파일등록</button></td>
					</tr>
					<tr>
						<th>임차주택관리규정</th>
       			<td  colspan="2" id="nrmAttchFileView">&nbsp;</td>
       			<td><button type="button" class="btn" id="nrmAttchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo2, getAttachFileId('N'), 'knldPolicy', '*')">첨부파일등록</button></td>
					</tr>
				</tbody>
			</table>		
			<div class="titArea">
				<div class="LblockButton">
					<button type="button" id="rgstBtn" name="rgstBtn" onClick="fncSave()" >필수첨부파일 저장</button>
				</div>
			</div>
	</div>
</form>
</div>
</body>
</html>
