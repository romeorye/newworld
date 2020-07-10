<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoDtl.jsp
 * @desc    : 자산 상세정보 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.09.11  IRIS05		최초생성
 * 1.0  2020.07.08  IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript">
var fxaDtlDataSet; // 자산 상세정보 데이터셋
var prjSearchDialog;
var lvAttcFilId;
var fxaInfoId;

	Rui.onReady(function() {
		
		fxaInfoId = '${inputData.fxaInfoId}';
		
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
		
        /* DATASET : grid */
		fxaDtlDataSet = new Rui.data.LJsonDataSet({
		    id: 'fxaDtlDataSet',
		    remainRemoved: true,
		    lazyLoad: true,
		    fields: [
		    	  {id: 'fxaInfoId'     } /*고정자산 명*/
		    	, {id: 'fxaNm'     } /*고정자산 명*/
		    	, {id: 'fxaNo'     } /*고정자산 번호*/
		    	, {id: 'fxaStCd'   } /*고정자산 상태 코드*/
		    	, {id: 'wbsCd'     } /*WBS 코드*/
		    	, {id: 'prjNm'     } /*PJT 코드*/
		    	, {id: 'crgrNm'    } /*담당자명*/
		    	, {id: 'fxaLoc'    } /*고정자산 위치*/
		    	, {id: 'fxaClss'   } /*고정자산 클래스*/
		    	, {id: 'fxaQty'   , defaultValue: 0 } /*고정자산 수량*/
		    	, {id: 'fxaUtmNm'  } /*고정자산 단위 명*/
		    	, {id: 'obtPce'   , defaultValue: 0 } /*취득가*/
		    	, {id: 'bkpPce'   , defaultValue: 0 } /*장부가*/
		    	, {id: 'obtDt'     } /*취득일(YYYY-MM-Dd)*/
		    	, {id: 'rlisDt'    } /*실사일*/
		    	, {id: 'dsuDt'     } /*폐기일*/
				, {id: 'mkNm'      } /*Maker 명*/
				, {id: 'useUsf'    } /*사용 용도*/
				, {id: 'prcDpt'    } /*구입처*/
				, {id: 'fxaSpc'    } /*고정자산 SPECIFICATION*/
		    	, {id: 'tagYn'     } /*태그 여부*/
		    	, {id: 'imgFilPath'} /*이미지 FILE PATH*/
		    	, {id: 'imgFilNm'  } /*이미지 FILE 명*/
		    	, {id: 'attcFilId'  } /*이미지 FILE id*/
		    	, {id: 'attcFilSeq'  } /*이미지 FILE id*/
		    	, {id: 'crgrId'  } /*담당자id*/
		    ]
		});
            
		fxaDtlDataSet.on('load', function(e){
			if(fxaDtlDataSet.getNameValue(0, "tagYn") == "Y"){
				tagYn.setValue(true);
			}else{
				tagYn.setValue(false);
			}
			
			lvAttcFilId = fxaDtlDataSet.getNameValue(0, "attcFilId");

			if(!Rui.isEmpty(lvAttcFilId)){
				getAttachFileList();
			}
			
		});    
	        
	  	//WBC CD
		var wbsCd = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'wbsCd',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		
	  	// 프로젝트 팝업 DIALOG
	    prjSearchDialog = new Rui.ui.LFrameDialog({
	        id: 'prjSearchDialog',
	        title: '프로젝트 조회',
	        width: 620,
	        height: 500,
	        modal: true,
	        visible: false
	    });

    	//프로젝트 명
    	var prjNm = new Rui.ui.form.LPopupTextBox({
	    	applyTo: 'prjNm',
	    	width: 200,
            editable: false,
            placeholder: ''
	    });
    	
    	prjNm.on('popup', function(e){
	    	openPrjSearchDialog(setPrjInfo,'ALL');
	    });

	 	
	    prjSearchDialog.render(document.body);

	    openPrjSearchDialog = function(f,p) {
			var param = '?searchType=';
			if( !Rui.isNull(p) && p != ''){
				param += p;
			}
			_callback = f;

			prjSearchDialog.setUrl('<c:url value="/prj/rsst/mst/retrievePrjSearchPopup.do"/>' + param);
			prjSearchDialog.show();
		};

		setPrjInfo = function(prjInfo) {
			clearPrjInfo();

			prjNm.setValue(prjInfo.prjNm);
			wbsCd.setValue(prjInfo.wbsCd);
	    };

	    clearPrjInfo = function(prjInfo) {
	    	prjNm.setValue('');
	    	wbsCd.setValue('');
	    };

		/* 담당자 팝업 */
	    var crgrNm = new Rui.ui.form.LPopupTextBox({
            applyTo: 'crgrNm',
            width: 200,
            placeholder: '',
            editable: false,
            enterToPopup: true
        });

	    crgrNm.on('popup', function(e){
	    	openUserSearchDialog(setUserInfo, 1, '');
       	});

	    setUserInfo = function (user){
	    	crgrNm.setValue(user.saName);
	    	dataSet.setValue(0, 'crgrId',   user.saSabun )
	    };

	  	//위치
		var fxaLoc = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'fxaLoc',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	  	/*Maker 명*/
		var mkNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mkNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	  	/*사용 용도 */
		var useUsf = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'useUsf',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	  	/* 태그 여부*/
		var tagYn = new Rui.ui.form.LCheckBox({ // 체크박스를 생성
	        applyTo: 'tagYn',
	        checked : true,
	        value : "Y"
	    });

	    /*구입처 */
		var prcDpt = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'prcDpt',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

	    /*고정자산 클래스 */
		var fxaClss = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'fxaClss',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		// 취득일
		var obtDt = new Rui.ui.form.LDateBox({
            applyTo: 'obtDt',
            dateType: 'string'
        });

		// 실사일
		var rlisDt = new Rui.ui.form.LDateBox({
            applyTo: 'rlisDt',
            dateType: 'string'
        });
		// 수량
		var fxaQty = new Rui.ui.form.LNumberBox({
	        applyTo: 'fxaQty',
	        placeholder: '수량을입력해주세요.',
	        maxValue: 9999999999,           // 최대값 입력제한 설정
	        minValue: 0,                  // 최소값 입력제한 설정
	        width: 120,
	        decimalPrecision: 0            // 소수점 자리수 3자리까지 허용
	    });

		// 단위
		var fxaUtmNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'fxaUtmNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 80,                                    // 텍스트박스 폭을 설정
	        placeholder: '단위를입력하세요',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		/*고정자산 SPECIFICATION*/
		var fxaSpc = new Rui.ui.form.LTextArea({
            applyTo: 'fxaSpc',
            placeholder: '',
            width: 900,
            height: 100
        });
    
		var fnSearch = function(){
			fxaDtlDataSet.load({
		        url: '<c:url value="/fxa/anl/retrieveFxaDtlSearchInfo.do"/>' ,
		        params :{
		        	fxaInfoId : fxaInfoId
		        }
		    });
		}

		fnSearch();   
	        
		/* [DataSet] bind */
	    var fxaDtlBind = new Rui.data.LBind({
	        groupId: 'aform',
	        dataSet: fxaDtlDataSet,
	        bind: true,
	        bindInfo: [
		    	  {id: 'fxaInfoId',   ctrlId: 'fxaInfoId',  value: 'value' }
		    	, {id: 'fxaNm',       ctrlId: 'fxaNm',      value: 'html' }
		    	, {id: 'fxaNo',       ctrlId: 'fxaNo',      value: 'html' }
		    	, {id: 'fxaStCd',     ctrlId: 'fxaStCd',    value: 'value' }
		    	, {id: 'wbsCd',       ctrlId: 'wbsCd',      value: 'value' }
		    	, {id: 'prjNm',       ctrlId: 'prjNm',      value: 'value' }
		    	, {id: 'crgrNm',      ctrlId: 'crgrNm',     value: 'value' }
		    	, {id: 'fxaLoc',      ctrlId: 'fxaLoc',     value: 'value' }
		    	, {id: 'fxaClss',     ctrlId: 'fxaClss',    value: 'value' }
		    	, {id: 'fxaQty',      ctrlId: 'fxaQty',     value: 'value' }
		    	, {id: 'fxaUtmNm',    ctrlId: 'fxaUtmNm',   value: 'value' }
		    	, {id: 'obtPce',      ctrlId: 'obtPce',     value: 'html' ,
	               	 renderer: function(value, p, record){
		  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
		  		        }
		              }
		    	, {id: 'bkpPce',      ctrlId: 'bkpPce',     value: 'html' ,
	               	 renderer: function(value, p, record){
		  	        		return Rui.util.LFormat.numberFormat(parseInt(value));
		  		        }
		              }
		    	, {id: 'obtDt' ,      ctrlId: 'obtDt',      value: 'value' }
		    	, {id: 'rlisDt',      ctrlId: 'rlisDt',     value: 'value' }
		    	, {id: 'dsuDt',       ctrlId: 'dsuDt',      value: 'value' }
				, {id: 'mkNm' ,       ctrlId: 'mkNm',       value: 'value' }
				, {id: 'useUsf',      ctrlId: 'useUsf',     value: 'value' }
				, {id: 'tagYn',       ctrlId: 'tagYn',      value: 'value' }
				, {id: 'prcDpt',      ctrlId: 'prcDpt',     value: 'value' }
				, {id: 'fxaSpc',      ctrlId: 'fxaSpc',     value: 'value' }
		    	, {id: 'imgFilPath',  ctrlId: 'imgFilPath', value: 'value' }
		    	, {id: 'imgFilNm',    ctrlId: 'imgFilNm',   value: 'value' }
		    	, {id: 'crgrId',      ctrlId: 'crgrId',     value: 'value' }
	        ]
	    });   
	        
		
	    fncSave = function(){
	    	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
    		
	    	dm.on('success', function(e) {      // 업데이트 성공시
    			var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    		 	
    			if( resultData.records[0].rtnSt == "S"){
    				fncFxaList();
    			}
    	    });

    	    dm.on('failure', function(e) {      // 업데이트 실패시
    	    	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
    	    });
		
    	    if(valid.validateGroup('aform') == false) {
    	    	alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid.getMessageList().join(''));
                return;
			}	
			
    	    if(confirm('저장 하시겠습니까?')) {
				dm.updateDataSet({
                    modifiedOnly: false,
                    url: "<c:url value='/fxa/anl/saveFxaInfo.do'/>",
                    dataSets:[fxaDtlDataSet]
                });
			}
	    }
	    
		
	    fncFxaList = function(){
	    	nwinsActSubmit(document.aform, "<c:url value='/fxa/anl/retrieveFxaAnlList.do'/>");
	    }
		
	    var valid = new Rui.validate.LValidatorManager({
       	 validators:[
           	  { id: 'prjNm'    , validExp:'프로젝트명:true' }
           	 ,{ id: 'crgrNm'   , validExp:'담당자:true' }
           	 ,{ id: 'wbsCd'    , validExp:'wbsCd코드:true' }
            ]
        });
	    
	    
	    /*************************첨부파일****************************/
    	/* [기능] 첨부파일 조회 */
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
             attachFileDataSet.clearData();
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

         getAttachFileId = function() {
             if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

             return lvAttcFilId;
         };
         setAttachFileInfo = function(attachFileList) {
             $('#attchFileView').html('');

             for(var i = 0; i < attachFileList.length; i++) {
                 $('#attchFileView').append($('<a/>', {
                     href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                     text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                 })).append('<br/>');
             }
             
             if(attachFileList.length > 0) {
                 lvAttcFilId = attachFileList[0].data.attcFilId;
                 fxaDtlDataSet.setNameValue(0, "attcFilId", lvAttcFilId)
             }
         };

         downloadAttachFile = function(attcFilId, seq) {
        	aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
      		aform.submit();
         };

		
		
   
	}); // end RUI Lodd	        
	        
	        
</script>
</head>
<style type="text/css">
.search-toggleBtn {display:none;}
</style>
<body>

<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
        	<span class="hidden">Toggle 버튼</span>
       	</a>    
		<h2>자산 등록</h2>
	</div>
<div class="sub-content">
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="menuType" name="menuType" value="IRIFI010"/>
		<input type="hidden" id="fxaStCd" name="fxaStCd" />
		<input type="hidden" id="rtnUrl" name="rtnUrl"  value="<c:out value='${inputData.rtnUrl}'/>">
    
		<div class="titArea btn_top">
			<div class="LblockButton">    
				<button type="button" id="butSave" onClick="fncSave();">저장</button>
				<button type="button" id="butList" onClick="fncFxaList();">목록</button>
			</div>
		</div>
	
		<table class="table table_txt_right">
			<colgroup>
				<col style="width:15%;"/>
				<col style="width:35%;"/>
				<col style="width:15%;"/>
				<col style=""/>
			</colgroup>
			<tbody>
				<tr>
					<th align="right">자산명</th>
					<td>
						<span id="fxaNm" />
					</td>
					<th align="right">자산번호</th>
					<td>
						<span id="fxaNo" />
					</td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">*  </span>wbsCd</th>
					<td>
						<input type="text" id="wbsCd" />
					</td>
					<th align="right"><span style="color:red;">*  </span>프로젝트명</th>
					<td>
						<input type="text" id="prjNm" />
					</td>
				</tr>
				<tr>
					<th align="right"><span style="color:red;">*  </span>담당자</th>
					<td>
						<div id="crgrNm"></div>
					</td>
					<th align="right">위치</th>
					<td>
						<input type="text" id="fxaLoc" />
					</td>
				</tr>
				<tr>
					<th align="right">자산클래스</th>
					<td>
						<input type="text" id="fxaClss" />
					</td>
					<th align="right">수량(단위)</th>
					<td>
						<input type="text" id="fxaQty" />(<input type="text" id="fxaUtmNm" />)
					</td>
				</tr>

				<tr>
					<th align="right"></span>취득가</th>
					<td>
						<span id="obtPce" />
					</td>
					<th align="right">장부가</th>
					<td>
						<span id="bkpPce" />
					</td>
				</tr>
				<tr>
					<th align="right">취득일</th>
					<td>
						<input typt="text" id="obtDt">
					</td>
					<th align="right">실사일</th>
					<td>
						<input typt="text" id="rlisDt">
					</td>
				</tr>
				</tr>
				<tr>
					<th align="right">Maker/모델명</th>
					<td>
						<input type="text" id="mkNm" />
					</td>
					<th align="right">용도</th>
					<td>
						<input type="text" id="useUsf" />
					</td>
				</tr>
				<tr>
					<th align="right">태그</th>
					<td>
						 <input type="checkbox" id="tagYn" >
					</td>
					<th align="right">구입처</th>
					<td>
						<input type="text" id="prcDpt" />
					</td>
				</tr>
				<tr>
					<th align="right">Spec</th>
					<td colspan="3" class="space_tain">
						<textarea id="fxaSpc"></textarea>
					</td>
				</tr>
				<tr>
					<th align="right">이미지</th>
					<td id="attchFileView" colspan="2">&nbsp;&nbsp;
					</td>
					<td>
						<button type="button" class="btn"  id="butAttcFil" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'fxaPolicy', '*')">첨부파일등록</button>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	</div>
</div>
</body>
</html>        
	        
	