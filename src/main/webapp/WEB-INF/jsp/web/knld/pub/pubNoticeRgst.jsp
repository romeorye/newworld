<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: pwiImtrRgst.jsp
 * @desc    : 공지사항 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.07.25  민길문		최초생성
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
	div.L-combo-list-wrapper-nobg {max-height: 100px;}
</style>

	<script type="text/javascript">
	var dataSet01;
	var vm;			// dataSet01 Validator
	var setpwImtrInfo ;
	var userId = '${inputData._userId}';
	var lvAttcFilId;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var textBox = new Rui.ui.form.LTextBox({
                emptyValue: ''
            });

            var numberBox = new Rui.ui.form.LNumberBox({
                emptyValue: '',
                minValue: 0,
                maxValue: 99999
            });

            var titlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'titlNm',
                width: 700
            });

            var pwiScnCd = new Rui.ui.form.LCombo({
                applyTo: 'pwiScnCd',
                name: 'pwiScnCd',
                useEmptyText: true,
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                listPosition: 'up',
                expandCount: 5,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PWI_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            var ugyYn = new Rui.ui.form.LCombo({
                applyTo: 'ugyYn',
                name: 'ugyYn',
                useEmptyText: true,
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                expandCount: 1,
                listPosition: 'up',
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ANL_UGY_YN"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            var keywordNm = new Rui.ui.form.LTextBox({
            	applyTo: 'keywordNm',
                width: 700
            });

            <%-- DATASET --%>
            dataSet01 = new Rui.data.LJsonDataSet({
                id: 'dataSet01',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                      { id: 'pwiId' }      //공지사항ID
                    , { id: 'titlNm' }     //제목
                    , { id: 'pwiScnCd' }   //공지사항구분코드
                    , { id: 'pwiScnNm' }   //공지사항구분코드이름
                    , { id: 'ugyYn' }      //긴급일반 구분
                    , { id: 'sbcNm' }      //내용
                    , { id: 'keywordNm' }  //키워드
                    , { id: 'userId' }     //로그인ID
                    , { id: 'rgstId' }     //등록자ID
                    , { id: 'rgstNm' }     //등록자
                    , { id: 'frstRgstDt' } //등록일
                    , { id: 'attcFilId' }  //첨부파일ID

                ]
            });

            dataSet01.on('load', function(e) {
            	lvAttcFilId = dataSet01.getNameValue(0, "attcFilId");
                if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

                if(dataSet01.getNameValue(0, "pwiId")  != "" ||  dataSet01.getNameValue(0, "pwiId")  !=  undefined ){
                	CrossEditor.SetBodyValue( dataSet01.getNameValue(0, "sbcNm") );
    			}
            });

            /* [DataSet] bind */
            var bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: dataSet01,
                bind: true,
                bindInfo: [
                      { id: 'pwiId',       ctrlId: 'pwiId',           value: 'value' }
                    , { id: 'pwiScnCd',    ctrlId: 'pwiScnCd',        value: 'value' }
                    , { id: 'ugyYn',       ctrlId: 'ugyYn',           value: 'value' }
                    , { id: 'titlNm',      ctrlId: 'titlNm',          value: 'value' }
                    , { id: 'sbcNm',       ctrlId: 'sbcNm',           value: 'value' }
                    , { id: 'keywordNm',   ctrlId: 'keywordNm',       value: 'value' }
                    , { id: 'rgstNm',      ctrlId: 'rgstNm',          value: 'html' }     //등록자
                    , { id: 'frstRgstDt',  ctrlId: 'frstRgstDt',      value: 'html' }     //등록일

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
                 	dataSet01.setNameValue(0, "attcFilId", attachFileList[0].data.attcFilId);
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

            /*유효성 검사 validation*/
            vm = new Rui.validate.LValidatorManager({
                validators:[
                	{ id: 'titlNm',      validExp: '제목:true:maxByteLength=400'},
                	{ id: 'pwiScnCd',    validExp: '공지구분코드:true' },
    				{ id: 'keywordNm',   validExp: '키워드:false:maxByteLength=100' }
                ]
            });

            var pwiImtrAttachDataSet = new Rui.data.LJsonDataSet({
                id: 'pwiImtrAttachDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'fileId'}
					, { id: 'fileNm'}
                ]
            });

            var pwiImtrAttachColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LStateColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'fileNm',		label: '파일명',		sortable: false,	align:'center',	width: 320 }
                ]
            });

            var pwiImtrAttachGrid = new Rui.ui.grid.LGridPanel({
                columnModel: pwiImtrAttachColumnModel,
                dataSet: pwiImtrAttachDataSet,
                width: 300,
                height: 100,
                autoToEdit: false,
                autoWidth: true
            });

            pwiImtrAttachGrid.on('cellClick', function(e) {

                console.log("i:"+e.colId+", c:"+e.col+", r:"+e.row);

                if(e.colId == "a2") {
                    nwinsActSubmit(document.aform, "<c:url value='/pjt/tss/gen/basicItemMgmt.do'/>");
                }

            });
           
             pwiImtrAttachGrid.render('pwiImtrAttachGrid');

            fn_init();

            /* [버튼] 저장 */
            save = function() {
                fncInsertPwiImtrInfo();
            };

    		/* [버튼] 목록 */
            goPwiImtrList = function() {
            	$(location).attr('href', '<c:url value="/knld/pub/retrievePubNoticeList.do"/>');
            };

            /* 저장/목록 버튼 */
            saveBtn = new Rui.ui.LButton('saveBtn');
            butGoList = new Rui.ui.LButton('butGoList');

		    saveBtn.on('click', function() {
		    	save();
		     });
		    butGoList.on('click', function() {
		    	if(confirm("저장하지 않고 목록으로 돌아가시겠습니까?")){
		    		goPwiImtrList();
		    	}
		     });

        });//onReady 끝

		<%--/*******************************************************************************
		 * FUNCTION 명 : validation
		 * FUNCTION 기능설명 : 입력 데이터셋 점검
		 *******************************************************************************/--%>
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
			var pwiId = '${inputData.pwiId}';

	    	if(pageMode == 'V'){
	             /* 상세내역 가져오기 */
	             getPwiImtrInfo = function() {
	            	 dataSet01.load({
	                     url: '<c:url value="/knld/pub/getPubNoticeInfo.do"/>',
	                     params :{
	                     	pwiId : pwiId
	                     }
	                 });
	             };

	             getPwiImtrInfo();

	    	}else if(pageMode == 'C')	{
	    		dataSet01.newRecord();
    		}
		 }

	    <%--/*******************************************************************************
	     * FUNCTION 명 : fncInsertPwiImtrInfo (공지사항 저장)
	     * FUNCTION 기능설명 : 공지사항 저장
	     *******************************************************************************/--%>
	    fncInsertPwiImtrInfo = function(){
	    	var pageMode = '${inputData.pageMode}';

	    	dataSet01.setNameValue(0, 'sbcNm', CrossEditor.GetBodyValue());
	    	// 데이터셋 valid
    		if(!validation('aform')){
        		return false;
        	}

    		// 에디터 valid
			if( dataSet01.getNameValue(0, "sbcNm") == "<p><br></p>" || dataSet01.getNameValue(0, "sbcNm") == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
				alert("내용 : 필수 입력 항목 입니다.");
     		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
     		    return false;
     		}

	    	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

	    	if(confirm("저장하시겠습니까?")){
		    	if(pageMode == 'V'){
		    		// update
		    		dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertPubNoticeInfo.do'/>",
		    	        dataSets:[dataSet01],
		    	        params: {
		    	            pwiId : document.aform.pwiId.value
		    	        	,sbcNm : dataSet01.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}else if(pageMode == 'C'){
		   			dm1.updateDataSet({
		    	        url: "<c:url value='/knld/pub/insertPubNoticeInfo.do'/>",
		    	        dataSets:[dataSet01],
		    	        params: {
		    	            sbcNm : dataSet01.getNameValue(0, "sbcNm")
		    	        }
		    	    });
		    	}
	    	}

	    	dm1.on('success', function(e) {
				var resultData = dataSet01.getReadData(e);
	            alert(resultData.records[0].rtnMsg);

	  	    	nwinsActSubmit(document.aform, "<c:url value='/knld/pub/retrievePubNoticeList.do'/>");

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
		<input type="hidden" id="pwiId" name="pwiId" value=""/>
		<input type="hidden" id="pageMode" name="pageMode" value="V"/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	 				<h2>공지사항 등록</h2>
	 			</div>
				<div class="LblockButton top">
					<button type="button" id="saveBtn" name="saveBtn">저장</button>
					<button type="button" id="butGoList" name="butGoList">목록</button>
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
   							<th align="right"><span style="color:red;">* </span>제목</th>
   							<td colspan="3">
   								<input type="text" id="titlNm" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>구분</th>
   							<td>
   								<div id="pwiScnCd"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>긴급여부</th>
   							<td>
   								<div id="ugyYn"></div>
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
   							<td colspan="2" id="attchFileView" >
   							</td>
   							<td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn"
   									onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'knldPolicy', '*')">첨부파일등록</button></td>
   						</tr>
   					</tbody>
   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>