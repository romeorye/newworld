<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlMachineList.jsp
 * @desc    : 분석기기 >  관리 > 소모품 등록 및 수정
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.25     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>


<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>



<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
%>


<script type="text/javascript">
var attId;
var fncCgdsAnlList;

	Rui.onReady(function(){
	
		<%-- RESULT DATASET --%>
        var resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });
        
		//grid dataset
		var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'cgdsNm'}
            	 ,{ id: 'mkrNm'}
            	 ,{ id: 'stkNo'}
            	 ,{ id: 'cgdsLoc'}
            	 ,{ id: 'cgdCrgrNm'}
            	 ,{ id: 'cgdCrgrId'}
            	 ,{ id: 'prpIvQty'}
            	 ,{ id: 'utmCd'}
            	 ,{ id: 'useUsf'}
            	 ,{ id: 'attcFilId'}
            	 ,{ id: 'seq'}
            	 ,{ id: 'cdgCrgr'}
            	 ,{ id: 'cgdsId'}
            	 ,{ id: 'cgdsMgmtId'}
            ]
        });
	
		//소모품명
		var cgdsNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'cgdsNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

 		//제조사
		var mkrNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mkrNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

 		//Stock No.
		var stkNo = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'stkNo',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
 		
		/* 담당자 팝업 */
	    var cgdCrgrNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'cgdCrgrNm',
            width: 150,
            editable: true,
            placeholder: '',
            enterToPopup: true
        });
		
	    cgdCrgrNm.on('popup', function(e){
	    	openUserSearchDialog(setUserInfo, 1, '', 'prj');
       	});

	    setUserInfo = function (user){
	    	cgdCrgrNm.setValue(user.saName);
	    	document.aform.cgdCrgrId.value = user.saSabun;
	    };
	
 		//위치.
		var cgdsLoc = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'cgdsLoc',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 100,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
	
 		//재고.
 		var prpIvQty = new Rui.ui.form.LNumberBox({
	        applyTo: 'prpIvQty',
	        placeholder: '',
	        maxValue: 9999999999,           // 최대값 입력제한 설정
	        minValue: -1,                  // 최소값 입력제한 설정
	        decimalPrecision: 0            // 소수점 자리수 3자리까지 허용
	    });
 		
 		//용도
 		var useUsf = new Rui.ui.form.LTextArea({
            applyTo: 'useUsf',
            placeholder: '',
            width: 900,
            height: 100
        });
	
 		//소모품상태
 		var cbUtmCd = new Rui.ui.form.LCombo({
	 		applyTo : 'utmCd',
			name : 'utmCd',
			useEmptyText: true,
	           emptyText: '전체',
	           url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=UTM_CD"/>',
	    	displayField: 'COM_DTL_NM',
	    	valueField: 'COM_DTL_CD',
      	 });

		cbUtmCd.getDataSet().on('load', function(e) {
	          console.log('cbUtmCd :: load');
	    });
	
		fnSearch = function(){
			dataSet.load({
				url: '<c:url value="/mchn/mgmt/retrieveCdgsMst.do"/>',
				params :{
					cgdsId  : document.aform.cgdsId.value	//기기교육 id
	                }
			});
		}

		fnSearch();
 		
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


		//dataset에서 첨부파일 정보가 있을경우
		dataSet.on('load', function(e) {
			attId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(attId)) getAttachFileList();
            
            if(dataSet.getNameValue(0, "cgdsId")  == undefined || dataSet.getNameValue(0, "cgdsId") == ""){
	            butDel.hide();
            }
            
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
        
 		//첨부파일 다운로드
        downloadAttcFil = function(attId, seq){
 	       /* 	var param = "?attcFilId=" + attId + "&seq=" + seq;
 	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
 	       	document.aform.submit(); */
 	       	
        	var param = "?attcFilId="+ attId+"&seq="+seq;
			Rui.getDom('dialogImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
			Rui.get('imgDialTitle').html('분석기기이미지(소모품)');
			imageDialog.clearInvalid();
			imageDialog.show(true);
        }
 		
        /* [ 이미지 Dialog] */
    	var imageDialog = new Rui.ui.LDialog({
            applyTo: 'imageDialog',
            width: 400,
            height: 400,
            visible: false,
            postmethod: 'none',
            buttons: [
                { text:'닫기', isDefault: true, handler: function() {
                    this.cancel(false);
                } }
            ]
        });
    	imageDialog.hide(true);
	
      //첨부파일 callback
		setAttachFileInfo = function(attcFilList) {

           var chkCnt = attcFilList.length;
           
           if(chkCnt > 1 ){
    	       	Rui.alert("첨부파일은 1개만 가능합니다");
	           	return;
           }else{
	           $('#atthcFilVw').html('');
           }
           
           for(var i = 0; i < attcFilList.length; i++) {
               $('#atthcFilVw').append($('<a/>', {
                   href: 'javascript:downloadAttcFil("' + attcFilList[i].data.attcFilId + '", "' + attcFilList[i].data.seq + '")',
                   text: attcFilList[i].data.filNm
               })).append('<br/>');
           document.aform.attcFilId.value = attcFilList[i].data.attcFilId;
           }
       	};
       	
       	var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		         { id: 'cgdsNm', 		ctrlId: 'cgdsNm', 		value: 'value' },
		         { id: 'mkrNm', 		ctrlId: 'mkrNm', 		value: 'value' },
		         { id: 'stkNo', 		ctrlId: 'stkNo', 		value: 'value' },
		         { id: 'prpIvQty', 		ctrlId: 'prpIvQty', 	value: 'value' },
		         { id: 'utmCd', 		ctrlId: 'utmCd', 		value: 'value' },
		         { id: 'cgdsLoc', 		ctrlId: 'cgdsLoc', 		value: 'value' },
		         { id: 'cgdCrgrNm',		ctrlId: 'cgdCrgrNm', 	value: 'value' },
		         { id: 'cgdCrgrId',		ctrlId: 'cgdCrgrId', 	value: 'value' },
		         { id: 'useUsf', 		ctrlId: 'useUsf', 		value: 'value' },
		         { id: 'attcFilId', 	ctrlId: 'attcFilId', 	value: 'value' },
		         { id: 'cgdsId', 		ctrlId: 'cgdsId', 		value: 'value' },
		     ]
		});
       
       	
       	/* [버튼] : 등록 정보 저장 */
    	var butSave = new Rui.ui.LButton('butSave');
   		butSave.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);
	    		
    			alert(resultData.records[0].rtnMsg);
	    		
	    		if( resultData.records[0].rtnSt == "S"){
	    			fncCgdsAnlList();
	    		}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
				var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    		if(fncVaild()) {
	    		 Rui.confirm({
	    			text: '저장하시겠습니까?',
	    	        handlerYes: function() {
	            	    dm.updateForm({
	    	        	    url: "<c:url value='/mchn/mgmt/saveCgdsMst.do'/>",
	    	        	    form: 'aform'
	    	        	});
	    	        }
	    		});
    		}
   	 	});
   		
   		
   		/* [버튼] : 소모품 삭제 */
    	var butDel = new Rui.ui.LButton('butDel');
    	butDel.on('click', function(){
   			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
				var resultData = resultDataSet.getReadData(e);
	    		
    			alert(resultData.records[0].rtnMsg);
	    		
	    		if( resultData.records[0].rtnSt == "S"){
	    			fncCgdsAnlList();
	    		}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
				var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    		 Rui.confirm({
    			text: '삭제하시겠습니까?',
    	        handlerYes: function() {
            	    dm.updateDataSet({
    	        	    url: "<c:url value='/mchn/mgmt/updateCgdsMst.do'/>",
    	        	    params: {                                 // 업데이트시 조건 파라메터를 기술합니다. 
    	        	    	cgdsId: document.aform.cgdsId.value
    	                }
    	        	});
    	        }
    		});
   	 	});
   		
        /* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFil = new Rui.ui.LButton('butAttcFil');
    	butAttcFil.on('click', function(){
    		var attcFilId = document.aform.attcFilId.value;
    		openAttachFileDialog(setAttachFileInfo, attcFilId,'mchnPolicy', '*');
    	});
    	
    	/* [버튼] : 소모품 목록 이동 */
    	var butList = new Rui.ui.LButton('butList');

    	butList.on('click', function(){
    		fncCgdsAnlList();
    	});

    	//vaild check
     	var fncVaild = function(){
     		var frm = document.aform;

    		if(cgdsNm.getValue() == null || cgdsNm.getValue() == ""){
    			Rui.alert("소모품명은 필수항목입니다");
    			cgdsNm.focus();
    			return false;
    		}
    		if(mkrNm.getValue() == null || mkrNm.getValue() == ""){
    			Rui.alert("제조사는 필수항목입니다");
    			mkrNm.focus();
    			return false;
    		}
    		if(prpIvQty.getValue() == null || prpIvQty.getValue() == ""){
    			Rui.alert("적정재고는 필수항목입니다.");
    			prpIvQty.focus();
    			return false;
    		}
    		if(cbUtmCd.getValue() == null || cbUtmCd.getValue() == ""){
    			Rui.alert("단위는 필수항목입니다.");
    			cbUtmCd.focus();
    			return false;
    		}
    		
    		return true;
     	}
    	
    	//소모품관리 목록 화면으로 이동
	    fncCgdsAnlList = function(){
	    	$('#searchForm > input[name=cgdsNm]').val(encodeURIComponent($('#searchForm > input[name=cgdsNm]').val()));
    	   	$('#searchForm > input[name=mkrNm]').val(encodeURIComponent($('#searchForm > input[name=mkrNm]').val()));
    	   	$('#searchForm > input[name=cgdCrgrNm]').val(encodeURIComponent($('#searchForm > input[name=cgdCrgrNm]').val()));
	    	
	    	nwinsActSubmit(searchForm, "<c:url value="/mchn/mgmt/retrieveMchnCgdgList.do"/>");	
	    }

	});		//end ready
		
		
</script>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
			<h2>소모품등록</h2>
		</div>

		<div class="sub-content">
		
		<form name="searchForm" id="searchForm">
			<input type="hidden" name="cgdsNm" value="${inputData.cgdsNm}"/>
			<input type="hidden" name="mkrNm" value="${inputData.mkrNm}"/>
			<input type="hidden" name="stkNo" value="${inputData.stkNo}"/>
			<input type="hidden" name="cgdCrgrNm" value="${inputData.cgdCrgrNm}"/>
	    </form>
	    
	    
			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" value="IRIED0202"/>
				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="cgdCrgrId" name="cgdCrgrId" />
				<input type="hidden" id="cgdsId" name="cgdsId" value="<c:out value='${inputData.cgdsId}'/>">
				
				<div class="LblockButton top">
					<button type="button" id="butSave">저장</button>
					<button type="button" id="butDel">삭제</button>
					<button type="button" id="butList">목록</button>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>소모품명</th>
							<td>
								<input type="text" id="cgdsNm" />
							</td>
							<th align="right"><span style="color:red;">*  </span>제조사</th>
							<td>
								<input type="text" id="mkrNm" />
							</td>
						</tr>
						<tr>
							<th align="right">Stock No.</th>
							<td>
								<input type="text" id="stkNo" />
							</td>
							<th align="right">  담당자/위치</th>
							<td>
								<input type="text" id="cgdCrgrNm" /> / <input type="text" id="cgdsLoc" />
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>적정재고</th>
							<td>
								<input type="text" id="prpIvQty" />
							</td>
							<th align="right"><span style="color:red;">*  </span>단위</th>
							<td>
								<select id="utmCd"></select>
							</td>
						</tr>
						<tr>
							<th align="right">용도</th>
							<td colspan="3">
								<textarea id="useUsf"></textarea>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
							<td id="atthcFilVw" colspan="2"></td>
							<td>
								<button type="button" id="butAttcFil">첨부파일등록</button> <b>(120*120)</b>
							</td>
						</tr>
						</tbody>
				</table>
			</form>

		</div>
		<!-- //sub-content -->
		
		<!-- 이미지 -->
		<div id="imageDialog">
			<div class="hd" id="imgDialTitle">이미지</div>
			<div class="bd" id="imgDialContents">
				<img id="dialogImage"/>
			</div>
		</div>
	</div>
	<!-- //contents -->
</body>
</html>