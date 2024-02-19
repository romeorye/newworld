<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%--
/*
 *************************************************************************
 * $Id      : tclgInfoDetailPop.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2019.02.13   IRIS05
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>


<script type="text/javascript">
var attCnt=0;
var lvAttcFilId ;

	Rui.onReady(function() {
		
		/*******************
          * 변수 및 객체 선언
          *******************/
          /** dataSet **/
          dataSet = new Rui.data.LJsonDataSet({
              id: 'dataSet',
              remainRemoved: true,
              lazyLoad: true,
              fields: [
              	  { id: 'tclgRqId'}
  				, { id: 'prjCd'}
  				, { id: 'prjNm'}
  				, { id: 'wbsCd'}
  				, { id: 'deptCd'}
  				, { id: 'rgstNo'}
  				, { id: 'rgstNm'}
  				, { id: 'attcFilId'}
  			]
          });

        var bind = new Rui.data.LBind({
        	groupId: 'aform',
        	dataSet: dataSet,
            bind: true,
            bindInfo: [
                { id: 'prjNm',	ctrlId:'prjNm',		value:'html'},
                { id: 'rgstNm',	ctrlId:'rgstNm',	value:'html'}
            ]
        });
        
        dataSet.on('load', function(e){
        	getAttachFileList();
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
        attachFileDataSet.on('load', function(e) {
        	getAttachFileInfoList();
        });
        
        getAttachFileList = function() {
        	attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                	attcFilId : dataSet.getNameValue(0, "attcFilId")
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

        /*첨부파일 다운로드*/
        downloadAttachFile = function(attcFilId, seq) {
            downloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
            $('#attcFilId').val(attcFilId);
            $('#seq').val(seq);
            downloadForm.submit();
        };
        
        /* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFilBtn = new Rui.ui.LButton('butAttcFil');
    	
		butAttcFilBtn.on('click', function(){
			//최초 등록자만 추가 가능
			if ( '${inputData._userSabun}' != dataSet.getNameValue(0, 'rgstNo')){
				Rui.alert("등록자만 수정이 가능합니다. 신규로 등록하십시오.");
				return;
			}
			
			parent.openAttachFileDialog(setAttachFileInfo, dataSet.getNameValue(0, 'attcFilId'),'prjPolicy', '*');
    	});

        fnSearch = function() {
      		dataSet.load({
 	            url: '<c:url value="/prj/tclgInfo/retrieveTclgInfoDetail.do"/>',
 	            params :{
 	            	tclgRqId  : document.aform.tclgRqId.value
 	    	          }
             });
        }

        fnSearch();
        
        /* 닫기  */
		var butClose = new Rui.ui.LButton('butClose');
		butClose.on('click', function(){
			parent.tclgInfoReqDialog.submit(true);
        });
        
        /* 저장  */
		var butSave = new Rui.ui.LButton('butSave');
		butSave.on('click', function(){
			Rui.alert("수정되었습니다.");
			parent.tclgInfoReqDialog.submit(true);
			parent.fnSearch();
        });
        
	});


</script>



</head>
<body>
<form name="aform" id="aform">
	<input type="hidden" id="tclgRqId" name="tclgRqId" value="${inputData.tclgRqId}"   />	
		
		<table class="table table_txt_right">
			<colgroup>
				<col style="width:20%;"/>
				<col style="width:30%;"/>
				<col style="width:20%;"/>
				<col style="width:30%;"/>
			</colgroup>
			<tbody>
				<tr>
					<th align="right">프로젝트명</th>
					<td>
						<span id="prjNm"></span>
					</td>
					<th align="right">등록자</th>
					<td>
						<span id="rgstNm"></span> 
					</td>
				</tr>
				<tr>
					<th align="right">첨부파일</th>
					<td id="attchFileView" colspan="2">&nbsp;&nbsp;</td>
					<td>
						<button type="button" id="butAttcFil">첨부파일등록</button>
					</td>
				</tr>
			</tbody>
		</table>
	<br>
	 <div class="LblockButton">
          <button type="button" id="butSave" >등록</button>
          <button type="button" id="butClose" >닫기</button>
      </div>
	</form>
	<form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
</body>
</html>