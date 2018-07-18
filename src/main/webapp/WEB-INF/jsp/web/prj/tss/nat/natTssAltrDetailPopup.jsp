<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssAltrDetailPopup.jsp
 * @desc    : 
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2018.01.19
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">

	Rui.onReady(function() {
	
		//dataSet 설정
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y-%m-%d') },
            fields: [
                  { id: 'tssCd' }         //과제코드            
                , { id: 'userId' }        //사용자ID
                , { id: 'altrSn' }        //seq
                , { id: 'prvs' }          //항목
                , { id: 'altrPre' }       //변경전  
                , { id: 'altrAft' }       //변경후  
                , { id: 'altrApprDd' }    //변경승인일
            ]
        });
       
		dataSet.on('load', function(e){

 	    });
		
        var rsonDataSet = new Rui.data.LJsonDataSet({
            id: 'rsonDataSet',
            remainRemoved: true,
            fields: [
                  { id: 'tssCd' }         //과제코드            
                , { id: 'altrRsonTxt' }   //변경사유 
                , { id: 'addRsonTxt' }    //추가사유
                , { id: 'attcFilId' } //첨부파일
            ]
        });
		
        rsonDataSet.on('load', function(e){
        	altrRsonTxt.setValue(rsonDataSet.getNameValue(0, "altrRsonTxt"));
        	addRsonTxt.setValue(rsonDataSet.getNameValue(0, "addRsonTxt"));
        	
        	if(!Rui.isEmpty(rsonDataSet.getNameValue(0, "attcFilId"))){
        		getAttachFileList();
			}
 	    });
        
        
      //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LNumberColumn()
                , { field: 'altrApprDd', label: '변경승인일', sortable: false, align:'center', width: 100, vMerge: true }
                , { field: 'prvs',  label: '항목', sortable: false, align:'center', width: 150 }
                , { field: 'altrPre', label: '변경전',editable: true,  sortable: false, align:'center', width: 150 }
                , { field: 'altrAft', label: '변경후',editable: true,  sortable: false, align:'center', width: 150 }
            ]
        });
        
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 750,
            height: 150
        });
        
        grid.render('defaultGrid');
        
        var altrRsonTxt = new Rui.ui.form.LTextArea({
        	applyTo : 'altrRsonTxt',
        	width: 680,
            height: 180,
            disabled : true
        });
        
        var addRsonTxt = new Rui.ui.form.LTextArea({
        	applyTo : 'addRsonTxt',
            width: 680,
            height: 180,
            disabled : true
        });
        
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        
        fnSearch = function() {
        	dm.loadDataSet({
 	    		dataSets : [dataSet, rsonDataSet],
 	            url: '<c:url value="/prj/tss/nat/natssAltrDetailSearch.do"/>',
 	            params :{
 	            	tssCd  : document.aform.tssCd.value
 	    	          }
             });
        }
         
        fnSearch();
        
        /* [DataSet] bind */
	    var bind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: rsonDataSet,
	        bind: true,
	        bindInfo: [
		    	  {id: 'altrRsonTxt',   ctrlId: 'altrRsonTxt',  value: 'html' }
		    	, {id: 'addRsonTxt',    ctrlId: 'addRsonTxt',   value: 'html' }
	        ]
	    });
        
        
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
        
		attachFileDataSet.on('load', function(e) {
            getAttachFileInfoList();
        });
        
        getAttachFileList = function() {
            attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                    attcFilId : rsonDataSet.getNameValue(0, "attcFilId")
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
            
        setAttachFileInfo = function(attachFileList) {
            $('#attchFileView').html('');
            
            for(var i = 0; i < attachFileList.length; i++) {
                $('#attchFileView').append($('<a/>', {
                    href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                    text: attachFileList[i].data.filNm 
                })).append('<br/>');
            }
        };
        
        downloadAttachFile = function(attcFilId, seq) {
        	document.aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
        	document.aform.submit();
        };
	});
	
	
</script>
</head>
<body>
<div class="bd">
		<div class="sub-content">
	    
			<form name="aform" id="aform" method="post">
			<input type="hidden" id="tssCd"  name="tssCd" value="<c:out value='${inputData.tssCd}'/>">
				
				<div id="defaultGrid"></div>
				
				<table class="table table_txt_right">
					<tbody>
					<tr>
						<th>변경사유</th>
						<td>
							<input type="text" id="altrRsonTxt" name="altrRsonTxt" >
						</td>
					</tr>
					<tr>
						<th>추가사유</th>
						<td>
							<input type="text" id="addRsonTxt" name="addRsonTxt" >
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td class="tssLableCss" colspan="6" id="attchFileView">&nbsp;</td>
					</tr>
					</tbody>
				</table>
				
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>
