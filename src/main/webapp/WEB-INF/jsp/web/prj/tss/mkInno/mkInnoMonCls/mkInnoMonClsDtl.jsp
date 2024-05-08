<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: mkInnoMonClsDtl.jsp
 * @desc    : 제조혁신 > 제조혁신월마감 > 월마감 상세정보
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.11.11     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--  meta http-equiv="X-UA-Compatible" content="IE=7" /  -->
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<%-- month Calendar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">

var tssCd = '${inputData.tssCd}';
var lvAttcFilId;

	Rui.onReady(function() {

		<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
        
		mkStCd = new Rui.ui.form.LCombo({
	    	applyTo:'mkStCd',
	        useEmptyText: true,
	        emptyText: '선택',
	        url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MK_ST_CD"/>',
	        displayField: 'COM_DTL_NM',
	        valueField: 'COM_DTL_CD'
	    });
		
		/* form setting */
		searchMonth = new Rui.ui.form.LMonthBox({
	        applyTo: 'searchMonth',
	        defaultValue: new Date(),
	        dateType: 'string',
	        width: 100
	    });

		tssClsSbc = new Rui.ui.form.LTextArea({
	        applyTo: 'tssClsSbc' ,
	        placeholder: '' ,
	        width: 600 ,
	        height: 100 ,
	        attrs: {
    			maxLength: 2000
    			}
	    });

		fnoPln = new Rui.ui.form.LTextArea({
	        applyTo: 'fnoPln' ,
	        placeholder: '' ,
	        width: 600 ,
	        height: 100 ,
	        attrs: {
    			maxLength: 4000
    			}
	    });
		
		/*******************
         * 변수 및 객체 선언
        *******************/
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                 { id: 'tssCd'}
                ,{ id: 'wbsCd'}
                ,{ id: 'tssNm'}
                ,{ id: 'uperdeptNm'}
                ,{ id: 'saName'}
                ,{ id: 'clsYymm'}
                ,{ id: 'beforeClsNm'}
                ,{ id: 'mkStCd'}
                ,{ id: 'fnoPln'}
                ,{ id: 'tssClsSbc'}
                ,{ id: 'searchMonth'}
                ,{ id: 'attcFilId'}
            ]
        });

        dataSet.on('load', function(e){
        	if( !Rui.isEmpty(dataSet.getNameValue(0, 'attcFilId')) ){
        		lvAttcFilId = dataSet.getNameValue(0, 'attcFilId');
        		getAttachFileList();
        	}
    	});
        
        fnSearch = function() {
        	dataSet.load({
	            url: '<c:url value="/prj/tss/mkInnoMonCls/retrieveMkInnoMonClsDtl.do"/>',
	            params :{
	    			    tssCd  : tssCd
	    			   ,searchMonth : searchMonth.getValue()
	    	          }
            });
        }

        fnSearch();
        
        
        fncCslSave = function(){
        	
        	var dm = new Rui.data.LDataSetManager();

    		dm.on('load', function(e) {
    		});
            
    		dm.on('success', function(e) {
    			var data = resultDataSet.getReadData(e);
    			
    			if(Rui.isEmpty(data.records[0].rtnSt) == "Y") {
    				fncMkInnoMonClsList();
    			}
            });
        	
    		dataSet.setNameValue(0, 'clsYymm', searchMonth.getValue() ); 
    				
    		if(confirm('저장 하시겠습니까?')) {
                dm.updateDataSet({
                    dataSets:[dataSet],
                    url:'<c:url value="/prj/tss/mkInnoMonCls/updateMkInnoMonClsInfo.do"/>',
                });
        	}
        }
        
        fncMkInnoMonClsList = function(){
        	nwinsActSubmit(document.aform, "<c:url value='/prj/tss/mkInnoMonCls/mkInnoTssMonClsList.do'/>");
        }
        
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
        
        getAttachFileList = function() {
            attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                	attcFilId : lvAttcFilId
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
        
        /* [기능] 첨부파일 등록 팝업*/
        getAttachFileId = function() {
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

            return lvAttcFilId;
        };

        setAttachFileInfo = function(attachFileList) {
            $('#attchFileView').html('');
            if(attachFileList.length > 0) {
                for(var i = 0; i < attachFileList.length; i++) {
                    $('#attchFileView').append($('<a/>', {
                    	href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

               	lvAttcFilId =  attachFileList[0].data.attcFilId;
               	dataSet.setNameValue(0, "attcFilId", lvAttcFilId);
            }
        };
        
        /*첨부파일 다운로드*/
        downloadAttachFile = function(attcFilId, seq) {
        	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
        	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + param;
        	aform.submit();
        };

        /* bind */
        var bind = new Rui.data.LBind({
            groupId: 'aform',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                // 화면표시 정보
                  { id: 'wbsCd',        ctrlId: 'wbsCd',    	value: 'html'}	
                , { id: 'tssNm',    	ctrlId: 'tssNm',  		value: 'html'}
                , { id: 'saName',    	ctrlId: 'saName',  		value: 'html'}
                , { id: 'uperdeptNm',   ctrlId: 'uperdeptNm',   value: 'html'}
                , { id: 'clsYymm',      ctrlId: 'clsYymm',     	value: 'value'}	
                , { id: 'beforeClsNm',  ctrlId: 'beforeClsNm',  value: 'html'}	
                , { id: 'mkStCd',      ctrlId: 'mkStCd',     	value: 'value'}	
                , { id: 'fnoPln',       ctrlId: 'fnoPln',    	value: 'value'}
                , { id: 'tssClsSbc',    ctrlId: 'tssClsSbc',    value: 'value'}
            ]
        });
        
		
		
	});	//end ready
</script>

</head>
<body>
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
   		<h2>제조혁신 월마감 상세정보</h2>
   	</div>
   	<div class="sub-content">
   		<div class="titArea" style="margin-top:0;">
			<h3>제조혁신과제 정보</h3>
		</div>
<form id="aform" name="aform">
   		<div class="search">
			<div class="search-content">
				<table>
					<colgroup>
						<col style="width:15%"/>
						<col style="width:30%"/>
						<col style="width:15%"/>
						<col style="width:30%"/>
						<col style="width:*"/>
					</colgroup>
					<tbody>
					    <tr>
							<th align="right">WBS 코드</th>
							<td>
								<span id="wbsCd"></span>
							</td>
							<th align="right">과제명</th>
							<td>
								<span id="tssNm"></span>
							</td>
							<td rowspan="3" class="t_center">
		 						<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
		 					</td>
						</tr>
						<tr>
							<th align="right">PL 명</th>
							<td><span id="saName"></span></td>
							<th align="right">조직</th>
							<td>
								<span id=uperdeptNm></span>
							</td>
						</tr>
						<tr>
							<th align="right">기준월</th>
							<td>
								<input type="text" id="searchMonth" name="searchMonth"/>
							</td>
							<th align="right">전월마감완료</th>
							<td>
								<span id="beforeClsNm"></span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
   		<div>
   			<table class="table table_txt_right mt10">
				<colgroup>
					<col style="width:15%; "/>
					<col style="width:55%; "/>
					<col style="width:*; "/>
				</colgroup>
				<tbody>
				    <tr>
						<th align="right">진척상태</th>
						<td colspan="2">
							<div id="mkStCd"></select>
						</td>
					</tr>
					<tr>
						<th align="right">지연내역 및<br>향후계획</th>
						<td colspan="2" style="padding:6px;">
							<textarea id="fnoPln"></textarea>
						</td>
					</tr>
					<tr>
						<th align="right">월마감내용</th>
						<td colspan="2" style="padding:6px;">
							<textarea id="tssClsSbc"></textarea>
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
	         			<td id="attchFileView">&nbsp;</td>
                    	<td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
						</td>
					</tr>
				</tbody>
			</table>
   		</div>
</form>   		
   		<div class="titArea btn_btm2">
			<div class="LblockButton">
				<button type="button" id="butRgst" name="butRgst" onclick="fncCslSave()" >마감</button>
				<button type="button" id="butGoList" name="butGoList" onclick="fncMkInnoMonClsList()">목록</button>
			</div>
		</div>
   	</div>	
</div>
</body>
</html>