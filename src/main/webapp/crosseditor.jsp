<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" />
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript">
var fnSubmit;	
	Rui.onReady(function(){
		
		
		
		var dataSet = new Rui.data.LJsonDataSet({
		    id: 'dataSet',
		    remainRemoved: true,
		    fields: [
		    		  { id: 'pe_aMu'}
		            ]
		});	
		
		//요약설명 textarea
	    var pe_aMu = new Rui.ui.form.LTextArea({
            applyTo: 'pe_aMu',
            placeholder: '',
            width: 730,
            height: 450
        });
		
		/* 
		 var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
	        dm.on('success', function(e) {
	            var data = dataSet.getReadData(e);

	            alert(data.records[0].rtVal);

	            //실패일경우 ds insert모드로 변경
	            if(data.records[0].rtCd == "FAIL") {
	                dataSet.setState(0, 1);
	            } else {
	                //신규저장일 경우 pk값 전역으로 셋팅
	                if(data.records[0].rtType == "I") {
	                    dataSet.loadData(data);
	                }
	            }
	        });
	    
	   	 */
	   	fnSubmit  = function(){
	   		 	dataSet.setNameValue(0, "pe_aMu",  CrossEditor.GetBodyValue()  );
				
	        	/* 
				dm.updateDataSet({
					url: "<c:url value='/mchn/mgmt/saveRlabTestEqip.do'/>",
		            dataSets:[dataSet]
		        }); */
	        }
		
			
		
		
	});


</script>
</head>
<body>
<table>
		<tr>
			<td><h3><span id="pe_abx"></span>&nbsp;Sample Page - <span id="pe_bcj"></span></h3></td>
		</tr>
		<tr>
			<td id="ce-parent-node">
				<input type="textarea" id="pe_aMu" name="pe_aMu"/>
				<script type="text/javascript" language="javascript">
					var CrossEditor = new NamoSE('pe_aMu');
					CrossEditor.params.Width = "100%";
					CrossEditor.params.UserLang = "auto";
					CrossEditor.params.ImageSavePath = "/iris/resource/fileupload/mchn";
					CrossEditor.params.FullScreen = false;
					CrossEditor.EditorStart();
					
					function OnInitCompleted(e){
						e.editorTarget.SetBodyValue(document.getElementById("pe_aMu").value);
					}
				</script>
			</td>
		</tr>
		<tr>
			<td>
				<button type="button" id="butSave" onclick="fnSubmit();">저장</button>
			</td>
		</tr>
	</table>
</body>
</html>