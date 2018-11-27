<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purRqDetail.jsp
 * @desc    : 구매요청시스템 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.11.22   김연태		최초생성
 * ---	-----------	----------	-----------------------------------------
 * PRS 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">
var lvAttcFilId;
var prjInfoListDialog;	//프로젝트 코드 팝업 dialog
var purRqItemDialog;	//구매요청 item 팝업 dialog
var callback;

	Rui.onReady(function() {
		var frm = document.aform;
		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

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
		
		var purRqUserDataSet = new Rui.data.LJsonDataSet({
			id: 'purRqUserDataSet',
			remainRemoved: true,
            lazyLoad: true,
            fields: [
            	 { id : 'banfnPrs'}   
            	,{ id : 'bnfpoPrs'}   
            	,{ id : 'seqNum'}     
            	,{ id : 'sCode'}      
            	,{ id : 'banfn'}       
            	,{ id : 'bnfpo'}       
            	,{ id : 'knttp'}       
            	,{ id : 'pstyp'}       
            	,{ id : 'meins'}       
            	,{ id : 'eeind'}       
            	,{ id : 'afnam'}       
            	,{ id : 'matkl'}       
            	,{ id : 'ekgrp'}       
            	,{ id : 'bednr'}       
            	,{ id : 'peinh'}       
            	,{ id : 'anlkl'}       
            	,{ id : 'txt50'}       
            	,{ id : 'itemTxt'}       
            	,{ id : 'kostl'}       
            	,{ id : 'posid'}       
            	,{ id : 'post1'}       
            	,{ id : 'prsFlag'}    
            	,{ id : 'bizCd'}      
            	,{ id:  'attcFilId'}	
            	,{ id: 'txz01'}	/*요청품명*/
		    	,{ id: 'maker'}	/*메이커*/
		    	,{ id: 'vendor'}	/* 벤더*/
		    	,{ id: 'catalogno'}	/*카탈로그 no*/
		    	,{ id: 'waers'}	/* 요청단위 콤보*/
		    	,{ id: 'menge'}	/* 요청 수량*/
		    	,{ id: 'preis'}	/* 예상단가*/
		    	,{ id: 'sakto'}	/* 계정코드*/
		    	,{ id: 'usedCode'}	/* */
		    	,{ id: 'werks'}	/* 플랜트*/
            ]
        });

		
		purRqUserDataSet.on('load', function(e){
			purRqUserDataSet.setNameValue(0, 'sakto', '${inputData.sakto}');
			purRqUserDataSet.setNameValue(0, 'bednr', '${inputData._userSabun}');
			purRqUserDataSet.setNameValue(0, 'bnfpoPrs', '1');   // 추가할 경우 변경됨
		});

		/* prject list 팝업 설정*/
        var post1 = new Rui.ui.form.LPopupTextBox({
        	applyTo: 'post1',
            placeholder: 'prj정보를 입력해주세요.',
            defaultValue: '',
            emptyValue: '',
            editable: false,
            width: 200
        });
		
        post1.on('popup', function(e){
        	openWbsListSearchDialog(setWbsCdInfo);
        });
		
        openWbsListSearchDialog = function(f) {
	    	callback = f;
	    	prjInfoListDialog.setUrl('<c:url value="/prs/pur/wbsCdSearchPopup.do"/>');
	    	prjInfoListDialog.show();
	    };
        
	  	//project  코드 팝업 세팅
		setWbsCdInfo = function(r){
			post1.setValue(r.post1);
			
			purRqUserDataSet.setNameValue(0, 'post1', r.post1);
			purRqUserDataSet.setNameValue(0, 'posid', r.posid);
	  	} 
			
		//품목
        var sCode = new Rui.ui.form.LCombo({
			applyTo : 'sCode',
			width: 180,
			defaultValue: '<c:out value="${inputData.sCode}"/>',
			useEmptyText: false,
			items: [
	                   { code: '견본', value: '견본' } 
	                  ,{ code: '금영제작', value: '금영제작' }
	                  ,{ code: '원재료,임가공품목(개발품목)', value: '원재료,임가공품목(개발품목)' } 
	                  ,{ code: '제작설비(해외)', value: '제작설비(해외)' } 
	               ]
		});
		
        sCode.getDataSet().on('load', function(e) {
        	if(!Rui.isEmpty('${inputData.sCode}')  ){
            	sCode.setValue( '${inputData.sCode}' );
           	}
        });
       	
		//납품요청일
		var eeind = new Rui.ui.form.LDateBox({
			applyTo: 'eeind',
			mask: '9999-99-99',
			displayValue: '%Y-%m-%d',
			defaultValue : '',		// default -1년
			width: 100,
			dateType: 'string'
		});
		
		//구매요청 사유 및 세부 spec.(400자 이내)
	    var itemTxt = new Rui.ui.form.LTextArea({
            applyTo: 'itemTxt',
            placeholder: '구매요청 사유 및 세부 spec.(400자 이내)',
            width: 1000,
            height: 100
        });
	 
		//구매그룹
		var ekgrp = new Rui.ui.form.LCombo({
            applyTo: 'ekgrp',
            width: 200,
            useEmptyText: false,
            url: '<c:url value="/common/prsCode/retrieveEkgrpInfo.do"/>',
            displayField: 'CODE_NM',
            valueField: 'CODE',
            autoMapping: true
        });

        ekgrp.getDataSet().on('load', function(e) {
        	//ekgrp.setValue('code4');
        });
     
		//납품위치
        var position = new Rui.ui.form.LCombo({
			applyTo : 'position',
			width: 180,
			useEmptyText: false,
			items: [
	                   { code: 'LG사이언스파크 E4', value: 'LG사이언스파크 E4' } // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
	                ]
		});
        
		//grid dataset
		var purListDataSet = new Rui.data.LJsonDataSet({
            id: 'purListDataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'knttp'}
            	 ,{ id: 'txz01'}
            	 ,{ id: 'waers'}
            	 ,{ id: 'menge'}
            	 ,{ id: 'eeind'}
            	 ,{ id: 'preis'}
            	 ,{ id: 'itemTxt'}
            	 ,{ id: 'bednr'}
            ]
        });
		
		purListDataSet.on('load', function(e){
	    	//document.getElementById("cnt_text").innerHTML = '총 ' + purListDataSet.getCount() + '건';
	    });
		
		var columnModel = new Rui.ui.grid.LColumnModel({
		     groupMerge: true,
		     columns: [
		        	{ field: 'knttp', 		label:'품목구분' , 	sortable: false, align: 'center', width: 200},
		            { field: 'txz01',  		label:'요첨품명', 	sortable: false, align: 'center', width: 400},
		            { field: 'waers',  		label:'요청수량', 		sortable: false, align: 'right',  width: 100,
                  	 renderer: function(value, p, record){
     	        		return Rui.util.LFormat.numberFormat(parseInt(value));
     		        	}
                 	},
		            { field: 'menge',  		label:'단위', 	sortable: false, align: 'center', width: 115},
		            { field: 'eeind', 	label: '남품요청일', 		sortable: false, align: 'center', width: 120},
		            { field: 'preis', 		label: '예상단가',   	sortable: false, align: 'left',	  width: 100},
		            { field: 'meins', 			label: '통화',   	sortable: false, align: 'center', width: 100},
		            { field: 'itemTxt', 		label: '구매요청 사유 및 세부스펙',   	sortable: false, align: 'center', width: 300},
		            { field: 'bednr',  		hidden : true}
		        ]
		 });

		var grid = new Rui.ui.grid.LGridPanel({
		    columnModel: columnModel,
		    dataSet: purListDataSet,
		    width:1150,
		    height: 450,
		    autoWidth : true
		});

		//grid.render('purRqGrid');

		fnSearch = function() {
			purRqUserDataSet.load({
	 	 		url: '<c:url value="/prs/purRq/retrievePurRqInfo.do"/>', 
	 	        params :{
	 	        	banfnPrs  : '${inputData.banfnPrs}'
	 	    	         }
	        });
	    }

		fnSearch();
		
		var bind = new Rui.data.LBind({
		     groupId: 'aform',
		     dataSet: purRqUserDataSet,
		     bind: true,
		     bindInfo: [
		         { id: 'sCode', ctrlId: 'sCode', value: 'value' },
		         { id: 'post1', ctrlId: 'post1', value: 'value' },
		         { id: 'eeind', ctrlId: 'eeind', value: 'value' },
		         { id: 'position', ctrlId: 'position', value: 'value' },
		         { id: 'ekgrp', ctrlId: 'ekgrp', value: 'value' },
		         { id: 'itemTxt', ctrlId: 'itemTxt', value: 'value' },
		         { id: 'sakto', ctrlId: 'sakto', value: 'html' },
		         { id: 'saktoNm', ctrlId: 'saktoNm', value: 'html' }
		     ]
		 });
	
		prjInfoListDialog= new Rui.ui.LFrameDialog({
		     id: 'prjInfoListDialog',
		     title: 'Project Code',
		     width:  980,
		     height: 550,
		     modal: true,
		     visible: false,
		     buttons : [
		         { text:'닫기', handler: function() {
		           	this.cancel(false);
		           }
		         }
		     ]
		 });

		 prjInfoListDialog.render(document.body);
		 
		 
		 /* [ 구매요청 item 팝업 Dialog] */
		 purRqItemDialog = new Rui.ui.LFrameDialog({
		     id: 'purRqItemDialog',
		     title: '구매요청 Item',
		     width:  1100,
		     height: 700,
		     modal: true,
		     visible: false,
		     buttons : [
		         { text:'닫기', handler: function() {
		           	this.cancel(false);
		           }
		         }
		     ]
		 });

		 purRqItemDialog.render(document.body);
		 
		/* [버튼] 추가 */
	    var btnAddPurRq = new Rui.ui.LButton('btnAddPurRq');
		btnAddPurRq.on('click', function() {
			//구매요청 정보 팝업창 호출	
			var params = "?code="+'${inputData.sakto}';
			
			purRqItemDialog.setUrl('<c:url value="/prs/popup/purRqItemPop.do"/>'+params);
			purRqItemDialog.show(true); 
		});
		
		
		fncSave = function(dataSet){
			purRqUserDataSet.setNameValue(0, 'txz01', dataSet.getNameValue(0, 'txz01'));
	    	purRqUserDataSet.setNameValue(0, 'maker', dataSet.getNameValue(0, 'maker'));
	    	purRqUserDataSet.setNameValue(0, 'vendor', dataSet.getNameValue(0, 'vendor'));
	    	purRqUserDataSet.setNameValue(0, 'catalogno', dataSet.getNameValue(0, 'catalogno'));
	    	purRqUserDataSet.setNameValue(0, 'waers', dataSet.getNameValue(0, 'waers'));
	    	purRqUserDataSet.setNameValue(0, 'menge', dataSet.getNameValue(0, 'menge'));
	    	purRqUserDataSet.setNameValue(0, 'preis', dataSet.getNameValue(0, 'preis'));
	    	purRqUserDataSet.setNameValue(0, 'werks', dataSet.getNameValue(0, 'werks'));
			
			//구매요청 Item 정보 저장	 
	    	if( confirm("저장하시겠습니까?") == true ){
	    		dm.updateDataSet({
                    modifiedOnly: false,
                    url:'<c:url value="/prs/purRq/insertPurRqInfo.do"/>',
                    dataSets:[purRqUserDataSet]
                });
	    	} 
		}
		
		dm.on('success', function(e) {
			var resultData = resultDataSet.getReadData(e);
   			
			if( resultData.records[0].rtnSt == "S"){
				Rui.alert(resultData.records[0].rtnMsg);
            	grid.render('purRqGrid');
			}
        });
        dm.on('failure', function(e) {
        	var resultData = resultDataSet.getReadData(e);
   			Rui.alert(resultData.records[0].rtnMsg);
        });

		
		 
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

                if(Rui.isEmpty(lvAttcFilId)) {
                	lvAttcFilId =  attachFileList[0].data.attcFilId;
                	purRqUserDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
                }
            }
        };

        /*첨부파일 다운로드*/
        downloadAttachFile = function(attcFilId, seq) {
            downloadForm.action = '<c:url value="/system/attach/downloadAttachFile.do"/>';
            $('#attcFilId').val(attcFilId);
            $('#seq').val(seq);
            downloadForm.submit();
        };

       	//첨부파일 끝
       	
       	
       	
	});
		
		


</script>

</head>
<body>
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
			<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			<span class="hidden">Toggle 버튼</span>
	   	</a>
	    <h2>비용요청(구매) 상세내용</h2>
    </div>

	<form id="aform" name ="aform">
	<input type="hidden" id="tabId" name="tabId" value="<c:out value='${inputData.tabId}'/>">  
	<input type="hidden" id="sakto" name="sakto" value="<c:out value='${inputData.sakto}'/>">  
	<input type="hidden" id="posid" name="posid" />  
	
	<div class="sub-content">
			<table class="table table_txt_right">
            	<colgroup>
                	<col width="120px">
                    <col width="400px">
                    <col width="110px">
                    <col width="200px">
                    <col width="*">
                 </colgroup>
			     <tbody>
			     	<tr>
			        	<th>품목구분</th>
			            <td>
			            	<select id="sCode" name="sCode"></select> 
			            </td>
			            <th>Project Code</th>
			            <td>
							<input type="text" class="" id="post1" name="post1" value="" >
						</div>
			            </td>
			        </tr>
			        <tr>
			        	<th>성명</th>
			            <td>
			            	${inputData._userNm}
			            </td>
			            <th>납품요청일</th>
			            <td>
			            	<div id="eeind"/>
			            </td>
					</tr>
			        <tr>
			        	<th>납품위치</th>
			            <td>
			            	<select id="position" name="position"></select>
			            </td>
			            <th>구매그룹</th>
			            <td>
			                <select id="ekgrp" name="ekgrp"></select>
			            </td>
			         </tr>
			         <tr>
			         	<th>그룹요청사유 및 <br/>세부스펙(440자 이내)</th>
			            <td colspan="3">
			            	<textarea id="itemTxt" name="itemTxt"></textarea>
			            </td>
					</tr>	
					<tr>
	                    <th align="right">첨부파일)</th>
	                    <td colspan="2" id="attchFileView">&nbsp;</td>
	                    <td colspan="1"><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prsPolicy', '*')">첨부파일등록</button></td>
	                </tr>
				</tbody>
			</table>
	    <div class="titArea">
	    	<span class="Ltotal" id="cnt_text">총 : 0 </span>
	    	<div class="LblockButton">
	    	 	<button type="button" id="btnAddPurRq" name="btnAddPurRq" class="redBtn">추가</button>
	    	</div> 
	    </div>
	</div>
	    
	    
		<div id="purRqGrid"></div>

</form>
</body>
</html>