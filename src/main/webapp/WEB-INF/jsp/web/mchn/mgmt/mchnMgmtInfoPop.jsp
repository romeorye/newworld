<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMachineLis.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 목록(기기)  > 분석기기 신규 등록 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.30     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LFileBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LFileBox.css"/>

<script type="text/javascript">

	Rui.onReady(function(){
		
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
		
		var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'mgmtDt'}
            	 ,{ id: 'dtlClCd'}
            	 ,{ id: 'rgstNm'}
            	 ,{ id: 'rgstDt'}
            	 ,{ id: 'mchnUsePsblYn'}
            	 ,{ id: 'smrySbc'}
            	 ,{ id: 'mgmtUfe'}
            	 ,{ id: 'attcFilId'}
            	 ,{ id: 'infoMgmtId'}
            	 ,{ id: 'mchnInfoId'}
            	 ,{ id: 'rtnMsg'}
            ]
        });

		var dt = new Date();

		var y = dt.getFullYear();
		var m = dt.getMonth()+1;
		m = m >= 10 ? m : '0' + m;
		var d = dt.getDate();
		d = d >= 10 ? d : '0' + d;

		var rDt =  y+'-'+m+'-'+d;


		//관리일
		var mgmtDt = new Rui.ui.form.LDateBox({
            applyTo: 'mgmtDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            defaultValue: new Date(),
            dateType: 'string'
        });

		//분류
		var cbDtlClCd = new Rui.ui.form.LCombo({
		 	applyTo : 'dtlClCd',
			name : 'dtlClCd',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MCHN_MGMT_CD"/>',
			displayField: 'COM_DTL_NM',
			valueField: 'COM_DTL_CD'
		});

		cbDtlClCd.getDataSet().on('load', function(e) {
		   console.log('cbMchnClCd :: load');
		});

		//작성자
		var rgstNm = new Rui.ui.form.LTextBox({         // LTextBox개체를 선언
	        applyTo: 'rgstNm',                          // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                 // 텍스트박스 폭을 설정
	        placeholder: '',     						// [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                          // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//등록일
		var rgstDt = new Rui.ui.form.LTextBox({         // LTextBox개체를 선언
	        applyTo: 'rgstDt',                          // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                 // 텍스트박스 폭을 설정
	        disabled: true,
	        invalidBlur: false                          // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		var infoMgmtId = document.aform.infoMgmtId.value;

		if(infoMgmtId == ""){
			document.aform.rgstNm.value = "<c:out value='${inputData.saName}'/>";
			document.aform.rgstDt.value = rDt;
		}

		//기기 상태 radio
		var rdMchnUsePsblYn = new Rui.ui.form.LRadioGroup({
            applyTo : 'mchnUsePsblYn',
            name : 'mchnUsePsblYn',
            items : [
                {
                    label : '사용가능',
                    name : 'rpsGame',
                    value : 'Y'
                }, {
                    label : '점검중',
                    value : 'N'
                }
            ]
        });

		//비용 숫자입력
	    var mgmtUfe = new Rui.ui.form.LNumberBox({
	        applyTo: 'mgmtUfe',
	        placeholder: '',
	        maxValue: 9999999999,           // 최대값 입력제한 설정
	        minValue: 0,                  // 최소값 입력제한 설정
	        decimalPrecision: 0,            // 소수점 자리수 3자리까지 허용
	        width: 200,
	    });

	  	//요약설명 textarea
	    var smrySbc = new Rui.ui.form.LTextArea({
            applyTo: 'smrySbc',
            placeholder: '',
            width: 600,
            height: 100
        });

	    var fileBox = new Rui.ui.form.LFileBox({
            fileName: '"attchFil"',
            placeholder: '파일을 선택하세요',
            width: 200
        });

	    var infoMgmtId = document.aform.infoMgmtId.value;

		if( infoMgmtId != ""){
		    fnSearch = function() {
		    	dataSet.load({
		        url: '<c:url value="/mchn/mgmt/retrieveMchnMgmtInfoSearch.do"/>' ,
	           	params :{
	           		infoMgmtId : infoMgmtId
		                }
	            });
	        }
	       	fnSearch();
		}

		var bind = new Rui.data.LBind({
			groupId: 'aform',
		    dataSet: dataSet,
		    bind: true,
		    bindInfo: [
		          { id: 'mgmtDt', 			ctrlId: 'mgmtDt', 			value: 'value' }
		         ,{ id: 'dtlClCd', 			ctrlId: 'dtlClCd', 			value: 'value' }
		         ,{ id: 'rgstNm', 			ctrlId: 'rgstNm', 			value: 'value' }
		         ,{ id: 'rgstDt', 			ctrlId: 'rgstDt', 			value: 'value' }
		         ,{ id: 'mchnUsePsblYn', 	ctrlId: 'mchnUsePsblYn', 	value: 'value' }
		         ,{ id: 'mgmtUfe', 			ctrlId: 'mgmtUfe', 			value: 'value' }
		         ,{ id: 'smrySbc', 			ctrlId: 'smrySbc', 			value: 'value' }
		         ,{ id: 'attcFilId', 		ctrlId: 'attcFilId', 		value: 'value' }
		         ,{ id: 'infoMgmtId', 		ctrlId: 'infoMgmtId', 		value: 'value' }
		         ,{ id: 'mchnInfoId', 		ctrlId: 'mchnInfoId', 		value: 'value' }
		         ,{ id: 'rtnMsg', 			ctrlId: 'rtnMsg', 		value: 'value' }
		     ]
		});

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

		var attId;

		//dataset에서 첨부파일 정보가 있을경우
		dataSet.on('load', function(e) {
			attId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(attId)) getAttachFileList();
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

	    /* [버튼] : 저장 */
    	var butSave = new Rui.ui.LButton('butSave');
    	butSave.on('click', function(){
    		var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				parent.fnSearch();
    				parent.mchnMgmtRegDialog.submit(true);
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    	    if(fncValid()) {
	    		Rui.confirm({
	    			text: '저장하시겠습니까?',
	    	        handlerYes: function() {
	            	    dm.updateForm({
	    	        	    url: "<c:url value='/mchn/mgmt/saveMachineMgmtInfo.do'/>",
	    	        	    form: 'aform'
	    	        	});
	    	        }
	    		});
    		}
    	});


		/* [버튼] : 삭제 
    	var butDel = new Rui.ui.LButton('butDel');
		butDel.on('click', function(){
    		if(infoMgmtId == "") {
    			Rui.alert("삭제할 데이터가 없습니다.");
    			return;
    		}
    		var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

    		dm1.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);

    			if( resultData.records[0].rtnSt == "S"){
    				parent.fnSearch();
    				parent.mchnMgmtRegDialog.submit(true);
    			}
				//fncAnlMchnList();
    	    });
    	    dm1.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
    			alert(resultData.records[0].rtnMsg);
    	    });

    	    Rui.confirm({
    			text: '삭제하시겠습니까?',
    	        handlerYes: function() {
            	    dm.updateDataSet({
    	        	    url: "<c:url value='/mchn/mgmt/deleteMachineMgmtInfo.do'/>",
    	        	   	params :{
    	        	   			infoMgmtId : infoMgmtId
    	    	                }
    	        	});
    	        }
    		});
    	});
		*/
		
		//[버튼] : 닫기 
    	var butCls = new Rui.ui.LButton('butCls');
    	butCls.on('click', function(){
    		parent.mchnMgmtRegDialog.submit(true);
    	});
		
		/* [버튼] : 첨부파일 팝업 호출 */
    	var butAttcFil = new Rui.ui.LButton('butAttcFil');
    	butAttcFil.on('click', function(){
    		var attcFilId = document.aform.attcFilId.value;
    		openAttachFileDialog(setAttachFileInfo, attcFilId,'mchnPolicy', '*');
    	});

    	//첨부파일 callback
		setAttachFileInfo = function(attcFilList) {
           $('#atthcFilVw').html('');

           for(var i = 0; i < attcFilList.length; i++) {
               $('#atthcFilVw').append($('<a/>', {
                   href: 'javascript:downloadAttcFil("' + attcFilList[i].data.attcFilId + '", "' + attcFilList[i].data.seq + '")',
                   text: attcFilList[i].data.filNm
               })).append('<br/>');
           document.aform.attcFilId.value = attcFilList[i].data.attcFilId;
           }
       	};

       //첨부파일 다운로드
       downloadAttcFil = function(attId, seq){
	       	var param = "?attcFilId=" + attId + "&seq=" + seq;
	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
	       	document.aform.submit();
       }
       
       
       var fncValid = function(){
    	   
    	   	if(Rui.isEmpty(mgmtDt.getValue() )){
	   			Rui.alert("관리일을 입력하세요");
	   			mgmtDt.focus();
	   			return false;
	   		} 
	   		if(Rui.isEmpty(cbDtlClCd.getValue() )){
	   			Rui.alert("분류를 선택하세요");
	   			cbDtlClCd.focus();
	   			return false;
	   		}
	   		if(Rui.isEmpty(rdMchnUsePsblYn.getValue() )){
	   			Rui.alert("기기상태를 선택하세요");
	   			rdMchnUsePsblYn.focus();
	   			return false;
	   		}
	   		if(Rui.isEmpty(smrySbc.getValue() )){
	   			Rui.alert("요약상태를 입력하세요");
	   			smrySbc.focus();ㅔ
	   			return false;
	   		} 

   			return true;
       }

	});			//end onReady



</script>
</head>
<body>
	<div class="bd">
		<div class="sub-content" style="padding:0; padding-left:3px;">
			<form name="aform" id="aform"method="post">
				<input type="hidden" id="menuType" name="menuType" />
				<input type="hidden" id="rtnMsg" name="rtnMsg" />
				<input type="hidden" id="attcFilId" name="attcFilId" value="<c:out value='${inputData.attcFilId}'/>">
				<input type="hidden" id="rgstId" name="rgstId" value="<c:out value='${inputData.saSabun}'/>">
				<input type="hidden" id="mchnInfoId" name="mchnInfoId" value="<c:out value='${inputData.mchnInfoId}'/>">
				<input type="hidden" id="infoMgmtId" name="infoMgmtId" value="<c:out value='${inputData.infoMgmtId}'/>">
				<div class="titArea mt10">
					<div class="LblockButton mt0">
						<button type="button" id="butSave">저장</button>
						<button type="button" id="butCls">닫기</button>
						<!-- <button type="button" id="butDel">삭제</button> -->
					</div>
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
							<th align="right"><span style="color:red;">*  </span>관리일</th>
							<td>
								<input type="text" id="mgmtDt"/>
							<th align="right"><span style="color:red;">*  </span>분류</th>
							<td>
								<select id="dtlClCd"></select>
							</td>
						</tr>
						<tr>
							<th align="right">작성자</th>
							<td>
								<input type="text" id="rgstNm"/>
							</td>
							<th align="right">등록일</th>
							<td>
								<input type="text" id="rgstDt"/>
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>기기상태</th>
							<td>
								<div id="mchnUsePsblYn"></div>
							</td>
							<th align="right">비용</th>
							<td>
								<input type="text" id="mgmtUfe"/>&nbsp;(원)
							</td>
						</tr>
						<tr>
							<th align="right"><span style="color:red;">*  </span>요약설명</th>
							<td colspan="3">
								<textarea id="smrySbc"></textarea>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
							<td id="atthcFilVw" colspan="2"></td>
							<td>
								<button type="button" id="butAttcFil">첨부파일등록</button>
							</td>
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