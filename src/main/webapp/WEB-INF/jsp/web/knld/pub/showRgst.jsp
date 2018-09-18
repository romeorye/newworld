<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: ShowRgst.jsp
 * @desc    : 전시회 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.12  			최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
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
<style>
	div.L-combo-list-wrapper {max-height: 100px;}
</style>

	<script type="text/javascript">
	var showRgstDataSet;
	var vm;			//  Validator
	var setShowInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var titlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'titlNm',
                width: 400
            });


            var swrmNatCd = new Rui.ui.form.LCombo({
                applyTo: 'swrmNatCd',
                name: 'swrmNatCd',
                useEmptyText: true,
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                listPosition: 'up',
                width: 200,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=CFRN_LOC_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            var keywordNm = new Rui.ui.form.LTextBox({
            	applyTo: 'keywordNm',
                width: 700
            });

        	/** dateBox **/
			var swrmStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'swrmStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			swrmStrtDt.on('blur', function(){
				if(Rui.isEmpty(swrmStrtDt.getValue())) return;

				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(swrmStrtDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					swrmStrtDt.setValue(new Date());
				}

            	if(!Rui.isEmpty(swrmFnhDt.getValue())) {
                	var startDt = swrmStrtDt.getValue().replace(/\-/g, "").toDate();
                	var fnhDt   = swrmFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    swrmStrtDt.setValue("");
	                    return;
	                }
            	}
			});

			var swrmFnhDt = new Rui.ui.form.LDateBox({
				applyTo: 'swrmFnhDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			swrmFnhDt.on('blur', function(){
				if(Rui.isEmpty(swrmFnhDt.getValue())) return;

				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(swrmFnhDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					swrmFnhDt.setValue(new Date());
				}

	            if(!Rui.isEmpty(swrmStrtDt.getValue())) {
	                var startDt = swrmStrtDt.getValue().replace(/\-/g, "").toDate();
	                var fnhDt   = swrmFnhDt.getValue().replace(/\-/g, "").toDate();

	                if(startDt > fnhDt) {
	                    alert("시작일보다 종료일이 빠를 수 없습니다.");
	                    swrmFnhDt.setValue("");
	                    return;
	                }
	            }
			});

            <%-- DATASET --%>
            showRgstDataSet = new Rui.data.LJsonDataSet({
                id: 'showRgstDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
				      { id: 'showId' }           /*전시회ID*/
					, { id: 'titlNm' }           /*전시회명*/
					, { id: 'swrmNatCd' }        /*개최국코드*/
					, { id: 'swrmNatNm' }        /*개최국이름*/
					, { id: 'swrmStrtDt' }       /*전시시작일*/
					, { id: 'swrmFnhDt' }        /*전시종료일*/
					, { id: 'sbcNm' }            /*본문내용*/
					, { id: 'rtrvCnt' }          /*조회수*/
					, { id: 'keywordNm' }        /*키워드*/
					, { id: 'attcFilId' }        /*첨부파일ID*/
					, { id: 'rgstId' }           /*등록자ID*/
					, { id: 'rgstNm' }           /*등록자이름*/
					, { id: 'rgstOpsId' }        /*부서ID*/
					, { id: 'delYn' }            /*삭제여부*/
					, { id: 'frstRgstDt' }       /*등록일*/
  				 ]
            });

            showRgstDataSet.on('load', function(e) {
            	lvAttcFilId = showRgstDataSet.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                if(showRgstDataSet.getNameValue(0, "showId")  != "" ||  showRgstDataSet.getNameValue(0, "showId")  !=  undefined ){
                	CrossEditor.SetBodyValue( showRgstDataSet.getNameValue(0, "sbcNm") );
    			}
            });

            /* [DataSet] bind */
            var showRgstBind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: showRgstDataSet,
                bind: true,
                bindInfo: [
                      { id: 'showId',         ctrlId: 'showId',          value: 'value' }
                    , { id: 'titlNm',         ctrlId: 'titlNm',          value: 'value' }
                    , { id: 'swrmNatCd',      ctrlId: 'swrmNatCd',       value: 'value' }
                    , { id: 'swrmStrtDt',     ctrlId: 'swrmStrtDt',      value: 'value' }
                    , { id: 'swrmFnhDt',      ctrlId: 'swrmFnhDt',       value: 'value' }
                    , { id: 'sbcNm',          ctrlId: 'sbcNm',           value: 'value' }
                    , { id: 'keywordNm',      ctrlId: 'keywordNm',       value: 'value' }
                    , { id: 'attcFilId',      ctrlId: 'attcFilId',       value: 'value' }
                    , { id: 'rgstNm',         ctrlId: 'rgstNm',          value: 'html' }     //등록자
                    , { id: 'frstRgstDt',     ctrlId: 'frstRgstDt',      value: 'html' }     //등록일

                ]
            });

    		//첨부파일 시작
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

                for(var i = 0; i < attachFileList.length; i++) {
                    $('#attchFileView').append($('<a/>', {
                        href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                        text: attachFileList[i].data.filNm
                    })).append('<br/>');
                }

                if(Rui.isEmpty(lvAttcFilId)) {
                	lvAttcFilId =  attachFileList[0].data.attcFilId;
                	showRgstDataSet.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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
            fn_init();

            /* [버튼] 저장 */
            showRgstSave = function() {
                fncInsertShowInfo();
            };

    		/* [버튼] 목록 */
            goShowList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrieveShowList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
		    	showRgstSave();
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goShowList();
		    	}
		     });

        });//onReady 끝

		<%--/*******************************************************************************
		 * FUNCTION 명 : validation
		 * FUNCTION 기능설명 : 입력 데이터셋 점검
		 *******************************************************************************/--%>
		  /*유효성 검사 validation*/
        vm = new Rui.validate.LValidatorManager({
            validators:[
            	{ id: 'titlNm',      validExp: '전시회명:true:maxByteLength=400'},
            	{ id: 'swrmNatCd',   validExp: '개최국:true' },
            	{ id: 'swrmStrtDt',  validExp: '전시시작일:true' },
            	{ id: 'swrmFnhDt',   validExp: '전시종료일:true' },
				{ id: 'keywordNm',   validExp: '키워드:false:maxByteLength=100' }
            ]
        });

	   function validation(vForm){
		 	var vTestForm = vForm;
		 	if(vm.validateGroup(vTestForm) == false) {
		 		alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('') );
		 		return false;
		 	}

		 	return true;
		 }



		<%--/*******************************************************************************
		 * FUNCTION 명 : initialize
		 * FUNCTION 기능설명 : 초기 setting
		 *******************************************************************************/--%>
		fn_init = function(){
			var pageMode = '${inputData.pageMode}';
			var showId = '${inputData.showId}';

	    	if(pageMode == 'V'){
	             /* 상세내역 가져오기 */
	             getShowInfo = function() {
	            	 showRgstDataSet.load({
	                     url: '<c:url value="/knld/pub/getShowInfo.do"/>',
	                     params :{
	                    	 showId : showId
	                     }
	                 });
	             };

	             getShowInfo();

	    	}else if(pageMode == 'C')	{
	    		showRgstDataSet.newRecord();
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertShowInfo (전시회 저장)
	     * FUNCTION 기능설명 : 전시회 저장
	     *******************************************************************************/--%>
	    fncInsertShowInfo = function(){
	    	var pageMode = '${inputData.pageMode}';

	    	showRgstDataSet.setNameValue(0, 'sbcNm', CrossEditor.GetBodyValue());
	    	
	    	// 데이터셋 valid
			if(!validation('aform')){
	   			return false;
	   		}

			// 에디터 valid
			if( showRgstDataSet.getNameValue(0, "sbcNm") == "<p><br></p>" || showRgstDataSet.getNameValue(0, "sbcNm") == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert("내용 : 필수 입력 항목 입니다.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertShowInfo.do'/>",
		    	        dataSets:[showRgstDataSet],
		    	        params: {
		    	        	showId : document.aform.showId.value
		    	        	,sbcNm : showRgstDataSet.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertShowInfo.do'/>",
		    	        dataSets:[showRgstDataSet],
		    	        params: {
		    	        	sbcNm : showRgstDataSet.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = showRgstDataSet.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrieveShowList.do'/>");

			});

			dm1.on('failure', function(e) {
				ruiSessionFail(e);
			});
	    }

	</script>
    </head>
    <body>
	<form name="downloadForm" id="downloadForm" method="post">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
	</form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="showId" name="showId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">
   			<div class="titleArea">
					<a class="leftCon" href="#">
		          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		          <span class="hidden">Toggle 버튼</span>
				</a>   
 				<h2>전시회 등록</h2>
 			</div>

			<div class="sub-content">
				<div class="sub-content">
					<div class="titArea btn_top">
						<button type="button" id="saveBtn" name="saveBtn">저장</button>
						<button type="button" id="butGoList" name="butGoList">목록</button>
					</div>
				</div>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%"/>
						<col style="width:30%"/>
						<col style="width:15%"/>
						<col style="width:*"/>
   					</colgroup>

   					<tbody>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>전시회명</th>
   							<td>
   								<input type="text" id="titlNm" value="">
   							</td>
   						    <th align="right"><span style="color:red;">* </span>개최국</th>
   							<td>
   								<div id="swrmNatCd"></div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>전시시작일</th>
   							<td>
   								<input type="text" id="swrmStrtDt" />
   							</td>
   							<th align="right"><span style="color:red;">* </span>전시종료일</th>
   							<td>
   								<input type="text" id="swrmFnhDt" />
   							</td>
   						</tr>
   						<c:if test="${inputData.pageMode=='V'}">
   						<tr>
    						<th align="right">등록자</th>
   							<td>
                                <span id="rgstNm"></span>
   							</td>
   							<th align="right">등록일</th>
   							<td>
   								<span id="frstRgstDt"></span>
   							</td>
   						</tr>
   						</c:if>
   						<tr>
    						<!--<th align="right">내용</th> -->
   							<td colspan="4">
   								 <textarea id="sbcNm"></textarea>
   								 <script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('sbcNm');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										
										var uploadPath = "<%=uploadPath%>"; 
										
										CrossEditor.params.ImageSavePath = uploadPath+"/knld";
										CrossEditor.params.FullScreen = false;
										
										CrossEditor.EditorStart();
										
										function OnInitCompleted(e){
											e.editorTarget.SetBodyValue(document.getElementById("sbcNm").value);
										}
									</script>
   							</td>
   						</tr>
    					<tr>
   							<th align="right">키워드</th>
   							<td colspan="3">
   								<input type="text" id="keywordNm" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">첨부파일</th>
   							<td id="attchFileView" >
   							</td>
   							<td colspan="2">
   							<button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'knldPolicy', '*')">첨부파일등록</button></td>
   						</tr>
   					</tbody>
   				</table>



   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>