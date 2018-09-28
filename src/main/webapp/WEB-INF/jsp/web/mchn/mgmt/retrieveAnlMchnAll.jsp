<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: retrieveAnlMchnAll.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 관리이력
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.04.17     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
var mchnMgmtRegDialog;

	Rui.onReady(function(){
	
		mchnMgmtRegDialog = new Rui.ui.LFrameDialog({
	        id: 'mchnMgmtRegDialog',
	        title: '분석기기 관리',
	        width:  900,
	        height: 600,
	        modal: true,
	        visible: false
	    });

		mchnMgmtRegDialog.render(document.body);
		
		/*******************
	 	* 변수 및 객체 선언
	 	*******************/
	 	//grid dataset
		var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            fields: [
            	  { id: 'mchnMgmtNm'}
            	 ,{ id: 'mchnNm'}
            	 ,{ id: 'mchnClCd'}
            	 ,{ id: 'mchnClNm'}
            	 ,{ id: 'mgmtDt'}
            	 ,{ id: 'mgmtUfe'}
            	 ,{ id: 'rgstNm'}
            	 ,{ id: 'mchnUsePsblYn'}
            	 ,{ id: 'mchnUsePsblNm'}
            	 ,{ id: 'smrySbc'}
            	 ,{ id: 'rgstDt'}
            	 ,{ id: 'rgstId'}
            	 ,{ id: 'mchnInfoId'}
            	 ,{ id: 'infoMgmtId'}
            	 ,{ id: 'rgstId'}
            	 ,{ id: 'dtlClCd'}
            ]
        });

		dataSet.on('load', function(e){
	    	document.getElementById("cnt_text").innerHTML = '총 ' + dataSet.getCount() + '건';
	    });

		 var columnModel = new Rui.ui.grid.LColumnModel({
		     groupMerge: true,
		     columns: [
		        	{ field: 'mchnClNm', 		label:'기기분류' , 	sortable: false, align: 'center', width: 80},
		        	{ field: 'mchnNm', 			label:'기기명' , 	sortable: false, align: 'left', width: 355},
		        	{ field: 'mchnMgmtNm', 		label:'관리분류' , 	sortable: false, align: 'center', width: 60},
		            { field: 'mgmtDt',  		label:'관리일', 	sortable: true, align: 'center', width: 80},
		            { field: 'smrySbc', 		label: '내용',   	sortable: false, align: 'left',	  width: 413},
		            { field: 'mgmtUfe',  		label:'비용', 		sortable: false, align: 'right',  width: 70,
                   	 renderer: function(value, p, record){
      	        		return Rui.util.LFormat.numberFormat(parseInt(value));
      		        	}
                  	},
		            { field: 'rgstNm',  		label:'작성자', 	sortable: false, align: 'center', width: 80},
		            { field: 'mchnUsePsblNm', 	label: '상태', 		sortable: false, align: 'center', width: 80},
		            { field: 'rgstDt', 			label: '등록일',   	sortable: false, align: 'center', width: 90},
		            { field: 'rgstId',  		hidden : true},
		            { field: 'mchnInfoId',  	hidden : true},
		            { field: 'infoMgmtId',  	hidden : true},
		            { field: 'rgstId',  		hidden : true},
		            { field: 'dtlClCd',  		hidden : true}
		        ]
		 });

		var grid = new Rui.ui.grid.LGridPanel({
		    columnModel: columnModel,
		    dataSet: dataSet,
		    width:1150,
		    height: 460,
		    autoWidth : true
		});

		grid.render('mhcnGrid');
		
		grid.on('cellClick', function(e) {
			var record = dataSet.getAt(dataSet.getRow());

			if(dataSet.getRow() > -1) {
				var param = 'infoMgmtId='+record.get("infoMgmtId")
				           +'&mchnInfoId='+record.get("mchnInfoId");

				mchnMgmtRegDialog.setUrl('<c:url value="/mchn/mgmt/retrieveMchnMgmtInfoPop.do?"/>'+param);
				mchnMgmtRegDialog.show(true);
			}
	 	});

		//기기명
	    var mchnNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'mchnNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.mchnNm}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });
		
		//작성자
	    var rgstNm = new Rui.ui.form.LTextBox({            // LTextBox개체를 선언
	        applyTo: 'rgstNm',                           // 해당 DOM Id 위치에 텍스트박스를 적용
	        width: 200,                                    // 텍스트박스 폭을 설정
	        defaultValue: '<c:out value="${inputData.rgstNm}"/>',
	        placeholder: '',     // [옵션] 입력 값이 없을 경우 기본 표시 메시지를 설정
	        invalidBlur: false                            // [옵션] invalid시 blur를 할 수 있을지 여부를 설정
	    });

		//기기분류
		mchnClCd = new Rui.ui.form.LCombo({
			applyTo : 'mchnClCd',
			name : 'mchnClCd',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MCHN_CL_CD"/>',
			displayField: 'COM_DTL_NM',
			valueField: 'COM_DTL_CD'
		});
		
		//관리분류
		mchnMgmtCd = new Rui.ui.form.LCombo({
			applyTo : 'mchnMgmtCd',
			name : 'mchnMgmtCd',
			useEmptyText: true,
		    emptyText: '선택하세요',
		    url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=MCHN_MGMT_CD"/>',
			displayField: 'COM_DTL_NM',
			valueField: 'COM_DTL_CD'
		});
		
		//관리일(시작)
		var mgmtStrDt = new Rui.ui.form.LMonthBox({
			applyTo: 'mgmtStrDt',
			defaultValue: '',
			width: 100,
			dateType: 'string'
		});
 
		mgmtStrDt.on('blur', function(){
			if( mgmtStrDt.getValue() > mgmtEndDt.getValue() ) {
				alert('시작월이 종료월보다 클 수 없습니다.!!');
				mgmtStrDt.setValue(mgmtEndDt.getValue());
			}
		});

		//관리일(종료) 
		var mgmtEndDt = new Rui.ui.form.LMonthBox({
				applyTo: 'mgmtEndDt',
				defaultValue: '',
				width: 100,
				dateType: 'string'
			});
 
		mgmtEndDt.on('blur', function(){
			if( mgmtStrDt.getValue() > mgmtEndDt.getValue() ) {
				alert('시작월이 종료월보다 클 수 없습니다.!!');
				mgmtStrDt.setValue(mgmtEndDt.getValue());
			}
		});

		 
		fnSearch = function(){
			
			if( Rui.isEmpty(mgmtStrDt.getValue()) && !Rui.isEmpty(mgmtEndDt.getValue())){
				Rui.alert("관리시작월을 입력해주십시오");
				return;
			}
			if( !Rui.isEmpty(mgmtStrDt.getValue()) && Rui.isEmpty(mgmtEndDt.getValue())){
				Rui.alert("관리종료월을 입력해주십시오");
				return;
			}
			 
			dataSet.load({
        	url: '<c:url value="/mchn/mgmt/retrieveAnlMchnAllSearchList.do"/>', 
	       	params :{
	       		    mchnNm : encodeURIComponent(document.aform.mchnNm.value)		//기기명
	       		   ,rgstNm : encodeURIComponent(document.aform.rgstNm.value)		//기기명
	       	       ,mchnClCd : document.aform.mchnClCd.value		//분류
	       	       ,mchnMgmtCd  : document.aform.mchnMgmtCd.value		//자산번호
	       	       ,mgmtStrDt : document.aform.mgmtStrDt.value		//오픈기기 여부
	       	       ,mgmtEndDt : document.aform.mgmtEndDt.value		//오픈기기 여부
	                }
       		});
		};

		fnSearch();
		
	});
	
</script>
<script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
			<h2>분석기기 관리이력</h2>
		</div>

		<div class="sub-content">

			<form name="aform" id="aform" method="post">

				<div class="search">
					<div class="search-content">
		   				<table>
							<colgroup>
								<col style="width:120px" />
								<col style="width:200px" />
								<col style="width:120px" />
								<col style="width:400px" />
								<col style="" />
							</colgroup>
							<tbody>
								<tr>
									<th align="right">기기명</th>
									<td><input type="text" id="mchnNm"/></td>
									<th align="right">기기분류</th>
									<td>
										<select  id="mchnClCd" ></select>
									</td>
									<td></td>
								</tr>
								<tr>
									<th align="right">작성자</th>
									<td><input type="text" id="rgstNm" /></td>
									<th align="right">관리분류</th>
									<td>
										<select  id="mchnMgmtCd" ></select>
									</td>
									<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
								</tr>
								<tr>	
									<th align="right">관리일</th>
									<td colspan="3">
										<input type="text" id="mgmtStrDt"><em class="gab"> ~ </em><input type="text" id="mgmtEndDt">
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="titArea">
					<span class="table_summay_number" id="cnt_text"></span>
					<div class="LblockButton">
						<button type="button" id="butExcl" name="butExcl">EXCEL</button>
					</div>
				</div>
				<div id="mhcnGrid"></div>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>	