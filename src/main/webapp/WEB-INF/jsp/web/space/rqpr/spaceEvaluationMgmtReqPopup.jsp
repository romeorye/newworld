<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceEvaluationMgmtReqPopup.jsp
 * @desc    : 관련평가 리스트 조회 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.08  dongys		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 2차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">
	var ctgrNm01= window.parent.ctgrNm01;
	var ctgrNm02= window.parent.ctgrNm02;
	var ctgrNm03= window.parent.ctgrNm03;
	var ctgrNm04= window.parent.ctgrNm04;
	var ctgr0= window.parent.ctgr0;
	var ctgr1= window.parent.ctgr1;
	var ctgr2= window.parent.ctgr2;
	var ctgr3= window.parent.ctgr3;
	var prod=ctgrNm01+" > "+ctgrNm02+" > "+ctgrNm03+" > "+ctgrNm04;
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

             //제품명
             var prodNm = new Rui.ui.form.LTextBox({
                  applyTo: 'prodNm',
                  editable: false,
                  disabled:true,
                  width: 500
             });

             //구분
            var anlNm = new Rui.ui.form.LTextBox({
                 applyTo: 'scn',
                 defaultValue: '',
                 emptyValue: '',
                 width: 200
            });

            //성능값
            var pfmcVal = new Rui.ui.form.LTextBox({
                 applyTo: 'pfmcVal',
                 defaultValue: '',
                 emptyValue: '',
                 width: 200
            });

            //공개여부
    		var cbOttpYnYn = new Rui.ui.form.LCombo({
    			applyTo : 'ottpYn',
    			name : 'ottpYn',
    			defaultValue: '<c:out value="${inputData.ottpYn}"/>',
    			width : 100,
    			emptyText: '선택하세요',
    				items: [
    	                   { code: 'Y', value: 'Y' }, // value는 생략 가능하며, 생략시 code값을 그대로 사용한다.
    	                   { code: 'N', value: 'N' }  // code명과 value명 변경은 config의 valueField와 displayField로 변경된다.
    	                	]
    		});

            //유효시작일
            strtVldDt = new Rui.ui.form.LDateBox({
	            applyTo: 'strtVldDt',
	            mask: '9999-99-99',
	            displayValue: '%Y-%m-%d',
	            width: 100,
	            dateType: 'string'
	        });
            strtVldDt.on('blur', function() {
	            if(strtVldDt.getValue() == "") {
	                return;
	            }
	            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(strtVldDt.getValue(),"-","")))) {
	                Rui.alert('날자형식이 올바르지 않습니다.!!');
	                strtVldDt.setValue(new Date());
	            }
	        });

          //유효종료일
            fnhVldDt = new Rui.ui.form.LDateBox({
	            applyTo: 'fnhVldDt',
	            mask: '9999-99-99',
	            displayValue: '%Y-%m-%d',
	            width: 100,
	            dateType: 'string'
	        });
            fnhVldDt.on('blur', function() {
	            if(fnhVldDt.getValue() == "") {
	                return;
	            }
	            if(!Rui.util.LDate.isDate(Rui.util.LString.toDate(nwinsReplaceAll(fnhVldDt.getValue(),"-","")))) {
	                Rui.alert('날자형식이 올바르지 않습니다.!!');
	                fnhVldDt.setValue(new Date());
	            }
	        });

            //비고
            var rem = new Rui.ui.form.LTextBox({
                applyTo: 'rem',
                defaultValue: '',
                emptyValue: '',
                width: 500
           });

            /*============================================================================
            =================================    DataSet     =============================
            ============================================================================*/
            //dataSet
            var dataSet = new Rui.data.LJsonDataSet({
     	        id: 'dataSet',
     	        remainRemoved: true,
     	        fields: [
                 		  { id: 'ctgr0' }
						, { id: 'ctgr1' }
						, { id: 'ctgr2' }
						, { id: 'ctgr3' }
						, { id: 'prodNm' }
						, { id: 'scn' }
						, { id: 'pfmcVal' }
						, { id: 'frstRgstDt' }
						, { id: 'strtVldDt' }
						, { id: 'fnhVldDt' }
						, { id: 'ottpYn' }
						, { id: 'attcFilId' }
						, { id: 'rem' }
     		            ]
     	    });

            var bind = new Rui.data.LBind({
    			groupId: 'aform',
    		    dataSet: dataSet,
    		    bind: true,
    		    bindInfo: [
    		         //{ id: 'ctgr0', 		ctrlId: 'ctgr0', 		value: 'value' },
    		         //{ id: 'ctgr1', 		ctrlId: 'ctgr1', 		value: 'value' },
    		         //{ id: 'ctgr2', 		ctrlId: 'ctgr2', 		value: 'value' },
    		         //{ id: 'ctgr3', 		ctrlId: 'ctgr3', 		value: 'value' },
    		         { id: 'scn', 			ctrlId: 'scn', 			value: 'value' },
    		         { id: 'pfmcVal', 			ctrlId: 'pfmcVal', 			value: 'value' },
    		         { id: 'frstRgstDt', 			ctrlId: 'frstRgstDt', 			value: 'value' },
    		         { id: 'strtVldDt', 		ctrlId: 'strtVldDt', 		value: 'value' },
    		         { id: 'fnhVldDt', 		    ctrlId: 'fnhVldDt', 	        value: 'value' },
    		         { id: 'ottpYn', 		ctrlId: 'ottpYn', 		value: 'value' },
    		         { id: 'attcFilId', 		ctrlId: 'attcFilId', 		value: 'value' },
    		         { id: 'rem', 		ctrlId: 'rem', 		value: 'value' }
    		     ]
    		});
            dataSet.newRecord();
            prodNm.setValue(prod);
            $('#ctgr0').val(ctgr0);
            $('#ctgr1').val(ctgr1);
            $('#ctgr2').val(ctgr2);
            $('#ctgr3').val(ctgr3);
            //dataSet.setValue(0,"prodNm",prod);
            //$('#prodNm').val(prod);
            //alert(dataSet.getNameValue(0,"prodNm"));
            //alert($('#prodNm').val());

          //서버전송용
            var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});

            dm.on('success', function(e) {
            	parent.fnList();
                //alert("1");
                parent.mchnDialog.cancel(true);
                //alert("2");
                var data = dataSet.getReadData(e);
                if(data.records[0].rtCd == "SUCCESS") {
                    //parent.fnSearch();

                }
            });
            dm.on('failure', function(e) {
                var data = dataSet.getReadData(e);
                Rui.alert(data.records[0].rtVal);
            });

            //저장
            fnSave = function() {

                dataSet.setNameValue(0, "ctgr0",  ctgr0);
                dataSet.setNameValue(0, "ctgr1",  ctgr1);
                dataSet.setNameValue(0, "ctgr2",  ctgr2);
                dataSet.setNameValue(0, "ctgr3",  ctgr3);
                dataSet.setNameValue(0, "prodNm",  prod);
                dataSet.setNameValue(0, "prodNm",  prod);

                Rui.confirm({
                    text: '저장하시겠습니까?',
                    handlerYes: function() {
                        dm.updateDataSet({
                            url:'<c:url value="/space/insertSpaceEvMtrl.do"/>',
                            dataSets:[dataSet]
                        });
                    },
                    handlerNo: Rui.emptyFn
                });
            }

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
    			alert(attId);
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

        	/* [버튼] : 첨부파일 팝업 호출 */
        	var butAttcFil = new Rui.ui.LButton('butAttcFil');
        	butAttcFil.on('click', function(){
        		var attcFilId = document.aform.attcFilId.value;
        		openAttachFileDialog(setAttachFileInfo, attcFilId,'mchnPolicy', '*');
        	});

        	//첨부파일 callback
    		setAttachFileInfo = function(attcFilList) {

               if(attcFilList.length > 1 ){
            	   alert("첨부파일은 한개만 가능합니다.");
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
               dataSet.setNameValue(0, "attcFilId",  document.aform.attcFilId.value);
               }
           	};
          //첨부파일 다운로드
            downloadMnalFil = function(attId, seq){
     	       var param = "?attcFilId=" + attId + "&seq=" + seq;
     	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
     	       	document.aform.submit();
         	    /*var param = "?attcFilId="+ attId+"&seq="+seq;
     			Rui.getDom('dialogImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
     			Rui.get('imgDialTitle').html('기기이미지');
     			imageDialog.clearInvalid();
     			imageDialog.show(true);*/

            }

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="ctgr0" name="ctgr0" value=""/>
		<input type="hidden" id="ctgr1" name="ctgr1" value=""/>
		<input type="hidden" id="ctgr2" name="ctgr2" value=""/>
		<input type="hidden" id="ctgr3" name="ctgr3" value=""/>
		<input type="hidden" id="attcFilId" name="attcFilId" />
		<input type="hidden" id="frstRgstDt" name="frstRgstDt" />


   		<div class="LblockMainBody">

   			<div class="sub-content">

   				<table class="searchBox">
   					<colgroup>
   						<col style="width: 120px;" />
		                <col style="width: *" />
		                <col style="width: 120px;" />
		                <col style="width: *" />
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">제품명</th>
   							<td colspan="3">
   								<input type="text" id="prodNm" value="">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">구분</th>
   							<td>
   								<input type="text" id="scn" value="">
   							</td>
   							<th align="right">공개여부</th>
   							<td>
   								<select id="ottpYn" name="ottpYn"></select>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">성능값</th>
   							<td>
   								<input type="text" id="pfmcVal" value="">
   							</td>
   							<th align="right">유효기간</th>
   							<td colspan="3">
   								<input type="text" id=strtVldDt /><em class="gab"> ~ </em><input type="text" id="fnhVldDt" />
   							</td>
   						</tr>
   						<tr>
   							<th align="right">비고</th>
   							<td colspan="3">
   								<input type="text" id="rem" value="">
   							</td>
   						</tr>
   						<tr>
							<th align="right">파일</th>
							<td id="atthcFilVw" colspan="2"></td>
							<td>
								<button type="button" id="butAttcFil">첨부파일등록</button> <b>(280*200)</b>
							</td>
						</tr>
   					</tbody>
   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>