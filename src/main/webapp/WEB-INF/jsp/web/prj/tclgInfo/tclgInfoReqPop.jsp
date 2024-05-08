<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%--
/*
 *************************************************************************
 * $Id      : tclgInfoReqPop.jsp
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
		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
                , { id: 'guId' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
     
		/* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFilBtn = new Rui.ui.LButton('butAttcFil');
    	
		butAttcFilBtn.on('click', function(){
			parent.openAttachFileDialog(setAttachFileInfo, "",'prjPolicy', '*');
    	});

		//첨부파일 callback
		setAttachFileInfo = function(attcFilList) {
            $('#atthcFilVw').html('');
            
            var frm = document.aform;
            for(var i = 0; i < attcFilList.length; i++) {
                $('#atthcFilVw').append($('<a/>', {
                    href: 'javascript:downloadAttcFil("' + attcFilList[i].data.attcFilId + '", "' + attcFilList[i].data.seq + '")',
                    text: attcFilList[i].data.filNm
                })).append('<br/>');
                
                frm.attcFilId.value = attcFilList[i].data.attcFilId;
                attCnt++;
            }
        };
	
        /* 닫기  */
		var butClose = new Rui.ui.LButton('butClose');
		butClose.on('click', function(){
			parent.tclgInfoReqDialog.submit(true);
        });
        	
		/* 기술정보요청 등록  */
		var butSave = new Rui.ui.LButton('butSave');
		
		butSave.on('click', function(){
			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
	   		
			dm.on('success', function(e) {      // 업데이트 성공시
	   			var resultData = resultDataSet.getReadData(e);

	   			Rui.alert(resultData.records[0].rtnMsg);
	   			
	   			if( resultData.records[0].rtnSt == "S"){
		   			parent.tclgInfoReqDialog.submit(true);
		   			parent.fnSearch();
	   			}
	   	    });

	   	    dm.on('failure', function(e) {      // 업데이트 실패시
	   	    	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
	   	    });

	   	    if( attCnt == 0){
	   	    	Rui.alert("첨부파일이 없습니다.");
	   	    	return;
	   	    }
	   	    
			Rui.confirm({
	   			text: '등록하시겠습니까?',
	   	        handlerYes: function() {
	   	        	 dm.updateForm({
	   	        	    url: "<c:url value='/prj/tclgInfo/insertTclgInfoReq.do'/>",
	   	        	    form : 'aform'
	   	        	    });
	  	     	}
    	    });
			
        });
	
	});


</script>

</head>
<body>
<form name="aform" id="aform">
	<input type="hidden" id="rgstNo" name="rgstNo" value="${inputData.rgstNo}" />	
	<input type="hidden" id="prjCd" name="prjCd" value="${inputData.prjCd}" />	
	<input type="hidden" id="wbsCd" name="wbsCd" value="${inputData.wbsCd}" />	
	<input type="hidden" id="deptCd" name="deptCd" value="${inputData.deptCd}" />	
	<input type="hidden" id="attcFilId" name="attcFilId" value="${inputData.attcFilId}"   />	
		
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
						<c:out value='${inputData.prjNm}'/>
					</td>
					<th align="right">등록자</th>
					<td>
						<c:out value='${inputData.rgstNm}'/>
					</td>
				</tr>
				<tr>
					<th align="right">첨부파일</th>
					<td id="atthcFilVw" colspan="2">&nbsp;&nbsp;</td>
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