<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: commonPopup.jsp
 * @desc    : 공통팝업 샘플
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
             
			userName = new Rui.ui.form.LTextBox({
				applyTo: 'userName',
			    placeholder: '사용자를 입력해주세요.',
			    defaultValue: '',
			    emptyValue: '',
			    width: 100
			});
            
            usersName = new Rui.ui.form.LPopupTextBox({
                applyTo: 'usersName',
                width: 600,
                editable: false,
                placeholder: '사용자를 입력해주세요.',
                emptyValue: '',
                enterToPopup: true
            });
             
			deptName = new Rui.ui.form.LTextBox({
				applyTo: 'deptName',
			    placeholder: '부서를 입력해주세요.',
			    defaultValue: '',
			    emptyValue: '',
			    width: 300
			});
             
			attchFileId = new Rui.ui.form.LTextBox({
				applyTo: 'attchFileId',
			    placeholder: '조회용 첨부파일 ID를 입력해주세요.',
			    defaultValue: '',
			    emptyValue: '',
			    width: 300
			});
			
            usersName.on('popup', function(e){
            	openUserSearchDialog(setUsersInfo, 10, $('#userIds').val());
            });
            
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

            var attachFileColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LStateColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'center',	width: 300 }
                ]
            });

            var attachFileGrid = new Rui.ui.grid.LGridPanel({
                columnModel: attachFileColumnModel,
                dataSet: attachFileDataSet,
                width: 300,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            attachFileGrid.on('cellClick', function(e) {
                
                if(e.colId == "filNm") {
                	downloadAttachFile(attachFileDataSet.getAt(e.row).data.attcFilId, attachFileDataSet.getAt(e.row).data.seq);
                }
            });
            
            attachFileGrid.render('attachFileGrid');
            
            /* 첨부파일 리스트 조회 */
            getAttachFileList = function() {
            	attachFileDataSet.load({
                    url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                    params :{
                    	attcFilId : attchFileId.getValue()
                    }
                });
            };
            
            /* 첨부파일 리스트 조회 */
            getAttachFileId = function() {
            	return attchFileId.getValue();
            };
            
    	    setUsersInfo = function(userList) {
    	    	var idList = [];
    	    	var nameList = [];
    	    	
    	    	for(var i=0, size=userList.length; i<size; i++) {
    	    		idList.push(userList[i].saUser);
    	    		nameList.push(userList[i].saName);
    	    	}
    	    	
    	    	usersName.setValue(nameList.join(', '));
    	    	
    	    	$('#userIds').val(idList);
    	    };
    		
    	    setUserInfo = function(userInfo) {
    	    	userName.setValue(userInfo.saName);
    	    };
    		
    	    setDeptInfo = function(deptInfo) {
    	    	deptName.setValue(deptInfo.deptNm);
    	    };
    		
    	    setAttachFileInfo = function(attachFileList) {
    	    	$('#attchFileView').html('');
    	    	
    	    	for(var i=0; i<attachFileList.length; i++) {
        	    	$('#attchFileView').append($('<a/>', {
        	            href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
        	            text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
        	        })).append('<br/>');
    	    	}
    	    };
    		
    	    setAttachFileInfoGrid = function(attachFileList) {
    	    	attachFileDataSet.clearData();
    	    	
    	    	for(var i=0; i<attachFileList.length; i++) {
    		    	attachFileDataSet.add(attachFileList[i]);
    	    	}
    	    };
			
			downloadAttachFile = function(attcFilId, seq) {
				aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
				$('#attcFilId').val(attcFilId);
				$('#seq').val(seq);
				aform.submit();
			};
			
        });
	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="userIds" name="userIds" value=""/>
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
   		<div class="contents">
   		
   			<div class="sub-content">
   				<div class="titArea">
   					<div class="LblockButton">
						<button type="button" class="btn"  id="userSearchBtn" name="userSearchBtn" onclick="openUserSearchDialog(setUserInfo, 1, '', 'anl')">사용자조회</button>
						<button type="button" class="btn"  id="usersSearchBtn" name="usersSearchBtn" onclick="openUserSearchDialog(setUsersInfo, 10, $('#userIds').val(), 'anl')">사용자조회(복수)</button>
						<button type="button" class="btn"  id="deptSearchBtn" name="deptSearchBtn" onclick="openDeptSearchDialog(setDeptInfo, 'anl')">부서조회</button>
						<button type="button" class="btn"  id="attachFileListSearchBtn" name="attachFileListSearchBtn" onclick="getAttachFileList()">첨부파일 리스트 조회</button>
						<button type="button" class="btn"  id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'anlPolicy', '*')">첨부파일(필드)</button>
						<button type="button" class="btn"  id="attchFileMngGridBtn" name="attchFileMngGridBtn" onclick="openAttachFileDialog(setAttachFileInfoGrid, getAttachFileId(), 'anlPolicy', '|XLS|XLSX|PDF|PPT|PPTX|')">첨부파일(그리드)</button>
   					</div>
   				</div>
   				
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">단건사용자</th>
   							<td colspan="3">
						        <div class="LblockMarkupCode">
   									<input type="text" id="userName" value="">
						        </div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">복수사용자</th>
   							<td colspan="3">
						        <div class="LblockMarkupCode">
						            <div id="usersName"></div>
						        </div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">부서</th>
   							<td colspan="3">
						        <div class="LblockMarkupCode">
   									<input type="text" id="deptName" value="">
						        </div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">첨부파일 ID(조회용)</th>
   							<td colspan="3">
						        <div class="LblockMarkupCode">
   									<input type="text" id="attchFileId" value="">
						        </div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">첨부파일</th>
   							<td colspan="3" id="attchFileView">
   							</td>
   						</tr>
   					</tbody>
   				</table>
				<div id="attachFileGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
		<iframe id="hiddenIFrame" name="hiddenIFrame" style="display:none;"></iframe>
    </body>
</html>