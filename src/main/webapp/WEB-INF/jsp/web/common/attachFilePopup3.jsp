<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: attachFilePopup.jsp
 * @desc    : 첨부파일 공통 팝업
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LFileBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LFileBox.css" />

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
  #fileList li div.L-filebox {width:372px !important;}
</style>

	<script type="text/javascript">

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var fileCnt = 0;
            var form1 = new Rui.ui.form.LForm('frm');

            var dm = new Rui.data.LDataSetManager();

            dm.on('success', function(e) {
                var data = attachFileDataSet.getReadData(e);

                alert(data.records[0].resultMsg);

                if(data.records[0].resultYn == 'Y') {
                	getAttachFileList();
                }
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
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 300 }
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
                	downloadAttachFile(attachFileDataSet.getAt(e.row).data.seq);
                }

            });

            attachFileGrid.render('attachFileGrid');

            /* 첨부파일 리스트 조회 */
            getAttachFileList = function() {
            	attachFileDataSet.load({
                    url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                    params :{
                    	attcFilId : $('#attcFilId').val()
                    }
                });
            };

            /* 첨부파일 삭제 */
            deleteAttachFile = function() {
                if(attachFileDataSet.getMarkedCount() > 0) {
                	Rui.confirm({
                	    text: "삭제 하시겠습니까?",
                	    handlerYes: function() {
                        	attachFileDataSet.removeMarkedRows();

                            dm.updateDataSet({
                                dataSets:[attachFileDataSet],
                                url:'<c:url value="/system/attach/deleteAttachFile.do"/>'
                            });
                    	},
                    	handlerNo: Rui.emptyFn
                	});
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

            var addBtn = new Rui.ui.LButton('addBtn');

            addBtn.on('click', function(){

                var ulEl = Rui.get('fileList');
                var liEl = Rui.createElements('<li></li>');

                liEl.appendTo(ulEl);

                var fileName = 'file' + ++fileCnt;

                /*<b>*/
                var fileBox = new Rui.ui.form.LFileBox({
                    fileName: fileName,
                    width: 350
                });
                fileBox.render(liEl);
                /*</b>*/

                var aEl = Rui.createElements('&nbsp;<button type="button" class="delBtn" id="deleteBtn" >삭제</button>');

                liEl.appendChild(aEl);

                aEl.on('click', function(e){
                	if(ulEl.dom.childNodes.length > 1) {
                        fileBox.destroy();
                        Rui.get(e.target).findParent('li').removeNode();
                	}
                });
            });

            var resetBtn = new Rui.ui.LButton('resetBtn');

            resetBtn.on('click', function(){
                form1.reset();
            });

            var saveBtn = new Rui.ui.LButton('saveBtn');

            saveBtn.on('click', function(){
            	var filePath;
            	var index;
            	var ext;
            	var isValid = true;
            	if(attachFileDataSet.getCount()>0){
            		alert("첨부파일은 한개만 가능합니다.");
            		return;
            	}
            	$('input:file').each(function( i ) {
            		filePath = $(this).val();

            		if ( filePath == "" ) {
            			alert('파일을 입력해주세요.');
            			isValid = false;
            			return false;
            		} else {
            			if($('#ext').val() != '*') {
                			index = filePath.lastIndexOf('.');
                			ext = filePath.substring(index + 1).toUpperCase();

                			if($('#ext').val().indexOf(ext) == -1) {
                				alert($('#ext').val() + ' 확장자만 첨부할 수 있습니다.');
                    			isValid = false;
                    			return false;
                			}
            			}
            		}
            	});

            	if(isValid) {
            		frm.action = '<c:url value='/system/attach/attachFileUpload.do'/>';
                	frm.submit();
            	}
            });

    		saveSuccess = function(attcFilId) {
    			alert('파일 업로드를 완료 하였습니다.');
                form1.reset();

                $('#attcFilId').val(attcFilId);

                getAttachFileList();
    		};

    		saveFail = function() {
    			alert('파일 업로드를 실패 하였습니다.');
    		};

	        getAttachFileInfoList = function() {
	        	var attachFileInfoList = [];

				for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
					attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
				}

				return attachFileInfoList;
	        };

			downloadAttachFile = function(seq) {
				frm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
				$('#seq').val(seq);
            	frm.submit();
			};

	        if($('#attcFilId').val() != '') {
	            getAttachFileList();
	        }

            addBtn.click();


            if($('#openMode').val() == 'R') {
                $('.LblockMarkupCode').hide();
                $('.LblockButton').hide();
            }
        });

	</script>
    </head>
    <body>
	<form id="frm" name="frm" method="post" enctype="multipart/form-data" target="hiddenIFrame">
		<input type="hidden" id="policy" name="policy" value="${inputData.policy}"/>
		<input type="hidden" id="ext" name="ext" value="${inputData.ext}"/>
		<input type="hidden" id="menuType" name="menuType" value="${inputData.menuType}"/>
		<input type="hidden" id="attcFilId" name="attcFilId" value="${inputData.attcFilId}"/>
		<input type="hidden" id="openMode" name="openMode" value="${inputData.openMode}"/>
		<input type="hidden" id="seq" name="seq" value=""/>

   		<div class="LblockMainBody pop_in">

   			<div class="sub-content">

		        <div class="LblockMarkupCode">
		            <div class="LblockButton" style="margin:0;" >
		                <button type="button" id="addBtn" >추가</button>
		                <button type="button" id="resetBtn" >초기화</button>
		                <button type="button" id="saveBtn" >저장</button>
		            </div>
		            <br/><br/>
	                <ul id="fileList" class="attach_file"></ul>
		        </div>
		        <br/>
   				<div class="titArea2">
   					<div class="LblockButton" style="margin:0;">
   						<button type="button" class="btn"   id="deleteAttachFileBtn" name="deleteAttachFileBtn" onclick="deleteAttachFile()">삭제</button>
   					</div>
   				</div>
				<div id="attachFileGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
	</form>
	<iframe id="hiddenIFrame" name="hiddenIFrame" style="display:none;"></iframe>
    </body>
</html>