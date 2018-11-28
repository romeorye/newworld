<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: rlabTemaGateCmpl.jsp
 * @desc    : Technical Service >  신뢰성시험 > Team Gate 평가완료
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.06        		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LFileBox.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LFileUploadDialog.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LFileBox.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFileUploadDialog.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.css"/>

<%-- rui Validator --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/validate/LCustomValidator.js"></script>

<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
%>


<script type="text/javascript">

var firstLoad = "Y";	//화면오픈


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

		/*******************
	     * 변수 및 객체 선언
	     *******************/
	    var dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        remainRemoved: true,
	        fields: [
            		  { id: 'teamGateId'}
            		 ,{ id: 'titl'}
		           	 ,{ id: 'sbc'}
		           	 ,{ id: 'attcFilId'}
		           	 ,{ id: 'frstRgstDt'}
		           	 ,{ id: 'frstRgstId'}
		           	 ,{ id: 'frstRgstNm'}
		           	 ,{ id: 'evCnt'}
		           	 ,{ id: 'ev1'}
		           	 ,{ id: 'ev2'}
		           	 ,{ id: 'ev3'}
		           	 ,{ id: 'ev4'}
		           	 ,{ id: 'ev5'}
		           	 ,{ id: 'ev6'}
		           	 ,{ id: 'ev7'}
		           	 ,{ id: 'ev8'}
		           	 ,{ id: 'ev9'}
		           	 ,{ id: 'ev10'}
		           	,{ id: 'evSum'}
		            ]
	    });

	    dataSet.on('load', function(e){
			document.aform.teamGateId.value = dataSet.getNameValue(0, "teamGateId");

			firstLoad = "N";
	    });

		var teamGateId = document.aform.teamGateId.value;
		if( teamGateId != ""){
		    fnSearch = function() {
		    	dataSet.load({
		        url: '<c:url value="/rlab/tmgt/rlabTeamGateCmplDtl.do"/>' ,
	           	params :{
	           		teamGateId : teamGateId
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
		         { id: 'titl', 		ctrlId: 'titl', 		value: 'html' },
		         { id: 'sbc', 			ctrlId: 'sbc', 		value: 'html' },
		         { id: 'ev1', 		ctrlId: 'ev1', 		value: 'html' },
		         { id: 'ev2', 		ctrlId: 'ev2', 		value: 'html' },
		         { id: 'ev3', 		ctrlId: 'ev3', 		value: 'html' },
		         { id: 'ev4', 		ctrlId: 'ev4', 		value: 'html' },
		         { id: 'ev5', 		ctrlId: 'ev5', 		value: 'html' },
		         { id: 'ev6', 		ctrlId: 'ev6', 		value: 'html' },
		         { id: 'ev7', 		ctrlId: 'ev7', 		value: 'html' },
		         { id: 'ev8', 		ctrlId: 'ev8', 		value: 'html' },
		         { id: 'ev9', 		ctrlId: 'ev9', 		value: 'html' },
		         { id: 'ev10', 		ctrlId: 'ev10', 		value: 'html' },
		         { id: 'attcFilId', 		ctrlId: 'attcFilId', 		value: 'value' },
		         { id: 'teamGateId', 		ctrlId: 'teamGateId', 		value: 'value' },
		         { id: 'frstRgstDt', 		ctrlId: 'frstRgstDt', 		value: 'html' },
	           	 { id: 'frstRgstId',		ctrlId: 'frstRgstId', 		value: 'value' },
	           	 { id: 'frstRgstNm', 		ctrlId: 'frstRgstNm', 		value: 'html' },
	           	 { id: 'evSum', 		ctrlId: 'evSum', 		value: 'html' },
	           	 { id: 'evCnt', 		ctrlId: 'evCnt', 		value: 'html' }
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



//************** button *************************************************************************************************/
		/* [버튼] : team gate 목록 이동 */
    	var butList = new Rui.ui.LButton('butList');

    	butList.on('click', function(){
    		fncRlabTeamGateList();
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
           }
       	};

       //첨부파일 다운로드
       downloadAttcFil = function(attId, seq){
    	   var param = "?attcFilId=" + attId + "&seq=" + seq;
	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
	       	document.aform.submit();
       }

     //team gate 목록 화면으로 이동
       var fncRlabTeamGateList = function(){
    	   	$('#searchForm > input[name=titl]').val(encodeURIComponent($('#searchForm > input[name=titl]').val()));

	    	nwinsActSubmit(searchForm, "<c:url value="/rlab/tmgt/rlabTeamGate.do"/>");
       }

     //vaild check

     var fncVaild = function(){
     		var frm = document.aform;
    		//평가의견    vailid

    		return true;
     	}
	});

       //end ready

</script>
</head>
<body>
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
	        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	        	<span class="hidden">Toggle 버튼</span>
        	</a>
			<h2>TEAM GATE</h2>
		</div>
		<div class="sub-content">
			<form name="searchForm" id="searchForm">
				<input type="hidden" name="titl" value="${inputData.titl}"/>
				<input type="hidden" name="cmplYn" value="${inputData.cmplYn}"/>
		    </form>

			<form name="aform" id="aform" method="post">
				<input type="hidden" id="menuType" name="menuType" />

				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="frstRgstId" name="frstRgstId" />

				<input type="hidden" id="teamGateId" name="teamGateId" value="<c:out value='${inputData.teamGateId}'/>">
				<div class="LblockButton top mt10">
					<button type="button" id="butList">목록</button>
				</div>
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 20%" />
						<col style="width: 15%" />
						<col style="width: 20%" />
						<col style="" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right"><span style="color:red;">*  </span>제목</th>
							<td>
								<span id="titl" />
							</td>
							<th align="right">참여인원</th>
							<td colspan="2">
								<span id="evCnt"/>
							</td>
						</tr>
						<tr>
							<th align="right">제안자</th>
							<td>
								<span id="frstRgstNm"/>
							</td>
							<th align="right">등록일</th>
							<td colspan="2">
								<span id="frstRgstDt"/>
							</td>
						</tr>
						<tr>
							<th  align="right">개요</th>
							<td colspan="4">
								<span id="sbc"></span>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
							<td colspan="3" id="atthcFilVw"></td>
							<td style="display:none">
								<button type="button" id="butAttcFil">첨부파일등록</button>
							</td>
						</tr>
						</tbody>
						</table>
				<div class="LblockButton top mt10">

				</div>

<table class="table table_txt_right">
					<colgroup>
						<col style="width: 20%" />
						<col style="width: 25%" />
						<col style="width: 20%" />
						<col style="width: 20%" />
						<col style="" />
					</colgroup>
					<tbody>						<tr>
							<th>평가구분</th>
							<th>평가지표</th>
							<th>영역점수</th>
							<th>개별점수</th>
							<th>평가의견</th>
						</tr>
						<tr>
							<td rowspan="3">고객가치지표</td>
							<td>고객 삶에 대한 혁신성</td>
							<td rowspan="3">30점</td>
							<td>10점</td>
							<td>
								<span id="ev1"></span>
							</td>
						</tr>
						<tr>
							<td>유사/경쟁 상품 비교우위</td>
							<td>10점</td>
							<td>
								<span id="ev2"></span>
							</td>
						</tr>
						<tr>
							<td>본질적 또는 차별화 가치</td>
							<td>10점</td>
							<td>
								<span id="ev3"></span>
							</td>
						</tr>
						<tr>
							<td rowspan="3">기술지표</td>
							<td>구현 기술 독창성</td>
							<td rowspan="3">30점</td>
							<td>10점</td>
							<td>
								<span id="ev4"></span>
							</td>
						</tr>
						<tr>
							<td>구현 기술의 경제성</td>
							<td>10점</td>
							<td>
								<span id="ev5"></span>
							</td>
						</tr>
						<tr>
							<td>내부 R&D 가능여부</td>
							<td>10점</td>
							<td>
								<span id="ev6"></span>
							</td>
						</tr>
						<tr>
							<td rowspan="3">사업지표</td>
							<td>예상 시장 규모</td>
							<td rowspan="3">30점</td>
							<td>10점</td>
							<td>
								<span id="ev7"></span>
							</td>
						</tr>
						<tr>
							<td>사업 Impact</td>
							<td>10점</td>
							<td>
								<span id="ev8"></span>
							</td>
						</tr>
						<tr>
							<td>시장 파급도</td>
							<td>10점</td>
							<td>
								<span id="ev9"></span>
							</td>
						</tr>
						<tr>
							<td>전략지표</td>
							<td>당사 전략 적합성</td>
							<td>10점</td>
							<td>10점</td>
							<td>
								<span id="ev10"></span>
							</td>
						</tr>
						<tr>
							<td colspan='3'></td>
							<td>합계</td>
							<td>
								<span id="evSum"></span>
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
