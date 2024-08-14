<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="iris.web.prj.tss.tctm.TctmUrl"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : mkInnoTssList.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2019.09.24   IRIS005     제조혁신과제 과제 목록
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LPager.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
var mkInnoRegDialog;
var roleCheck ="PER";
var roleUserId = '${inputData._userId}';


	Rui.onReady(function() {
		/*  
		   권한 : admin all
		        team  
		        person
		*/
		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
			roleCheck = "ADM";
		}else if( roleUserId == "gabriel" || roleUserId == "jhkimai" ) {
			roleCheck = "ADM";
		}else if("<c:out value='${inputData._roleId}'/>".indexOf('FG0') > 1)  {
			roleCheck = "TEAM";
		}
		
		/* [ 제조혁신과제 등록 Dialog] */
		mkInnoRegDialog = new Rui.ui.LFrameDialog({
	        id: 'mkInnoRegDialog',
	        title: '제조혁신과제 등록',
	        width:  890,
	        height: 500,
	        modal: true,
	        visible: false,
	    });

		mkInnoRegDialog.render(document.body);
		
		//WBS Code
        wbsCd = new Rui.ui.form.LTextBox({
            applyTo: 'wbsCd',
            defaultValue: '<c:out value="${inputData.wbsCd}"/>',
            width: 200
        });
		
      	//과제명
        tssNm = new Rui.ui.form.LTextBox({
            applyTo: 'tssNm',
            defaultValue: '<c:out value="${inputData.tssNm}"/>',
            width: 200
        });

        //과제리더
        saUserName = new Rui.ui.form.LTextBox({
            applyTo: 'saUserName',
            defaultValue: '<c:out value="${inputData.saUserName}"/>',
            width: 200
        });
		
      	//조직
        deptName = new Rui.ui.form.LTextBox({
            applyTo: 'deptName',
            defaultValue: '<c:out value="${inputData.deptName}"/>',
            width: 200
        });
	
      //과제기간 시작일
        tssStrtDd = new Rui.ui.form.LMonthBox({
            applyTo: 'tssStrtDd',
            defaultValue: '<c:out value="${inputData.tssStrtDd}"/>',
            width: 100,
            dateType: 'string'
        });
  
        //과제기간 종료일
        tssFnhDd = new Rui.ui.form.LMonthBox({
            applyTo: 'tssFnhDd',
            defaultValue: '<c:out value="${inputData.tssFnhDd}"/>',
            width: 100,
            dateType: 'string'
        });
	 
      //상태
        tssSt = new Rui.ui.form.LCombo({
            applyTo: 'tssSt',
            name: 'tssSt',
            emptyValue: '',
            useEmptyText: true,
            width: 150,
            defaultValue: '<c:out value="${inputData.tssSt}"/>',
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=TSS_ST"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            autoMapping: true
        });
        tssSt.getDataSet().on('load', function(e) {
             var tssStDs = tssSt.getDataSet();

            for(var i = tssStDs.getCount(); i > -1; i--) {
                if(stringNullChk(tssStDs.getNameValue(i, "COM_DTL_CD")).substr(0,1) == "5") {
                    tssStDs.removeAt(i);
                }
            }
        });
        
      //프로젝트명
        prjNm = new Rui.ui.form.LTextBox({
            applyTo: 'prjNm',
            defaultValue: '<c:out value="${inputData.prjNm}"/>',
            width: 200
        });

        //진행상태
        pgsStepCd = new Rui.ui.form.LCombo({
            applyTo: 'pgsStepCd',
            name: 'pgsStepCd',
            emptyValue: '',
            useEmptyText: true,
            defaultValue: '<c:out value="${inputData.pgsStepCd}"/>',
            emptyText: '전체',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PGS_STEP_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            autoMapping: true
        });
		
        /* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            fields: [
                  { id: 'wbsCd'}        //과제코드
                , { id: 'pkWbsCd'}      //wbs코드
                , { id: 'tssNm'}        //과제명
                , { id: 'prjNm'}        //소속명(프로젝트명)
                , { id: 'saUserName'}   //과제리더
                , { id: 'deptName'}     //조직
                , { id: 'tssStrtDd'}    //과제기간시작
                , { id: 'tssFnhDd'}     //과제기간종료
                , { id: 'cmplNxFnhDd'}  //과제실적종료
                , { id: 'tssSt'}        //상태
                , { id: 'tssStNm'}        //상태
                , { id: 'tssCd'}        //과제코드
                , { id: 'pgsStepCd'}    //진행단계코드
                , { id: 'pgsStepNm'}    //진행단계코드
            ]
        });
        
        /* [Grid] 컬럼설정 */
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                  { field: 'wbsCd',      label: '과제코드', sortable: true, align:'center', width: 100, renderer: function(value, p, record, row, col) {
                        var stepCd = record.get("pgsStepCd");
                        if(stepCd == "PL") return "SEED-" + value;
                        return value;
                  }}
                , { field: 'tssNm',   label: '과제명', sortable: true, align:'center', width: 350 }
                , { field: 'prjNm',        label: '팀명', sortable: true, align:'center', width: 135 }
                , { field: 'saUserName',   label: '과제리더', sortable: true, align:'center', width: 80 }
                , { field: 'deptName',     label: '조직', sortable: true, align:'center', width: 200 }
                , { id: 'G1', label: '과제기간(계획일)' }
                , { field: 'tssStrtDd',    label: '시작일', groupId: 'G1', sortable: true, align:'center', width: 90 }
                , { field: 'tssFnhDd',     label: '종료일', groupId: 'G1', sortable: true, align:'center', width: 90 }
                , { field: 'cmplNxFnhDd',  label: '종료일(실종료일)',  sortable: true, align:'center', width: 90 }
                , { field: 'pgsStepNm',    label: '진행단계', sortable: true, align:'center', width: 80, editor: pgsStepCd, renderer: function(value, p, record, row, col) {
                    p.editable = false;
                    return value;
                } }
                , { field: 'tssStNm',        label: '처리상태', sortable: true, align:'center', width: 90, editor: tssSt, renderer: function(value, p, record, row, col) {
                    p.editable = false;
                    return value;
                } }
            ]
        });
        
        
	   /**
	 	 총 건수 표시
	    **/
	    dataSet.on('load', function(e){
	        var seatCnt = 0;
	        var sumOrd = 0;
	        var sumMoOrd = 0;
	        var tmp;
	        var tmpArray;
	        var str = "";
	
	        document.getElementById("cnt_text").innerHTML = '총: '+ dataSet.getCount() + '건';
	
	        paging(dataSet,"defaultGrid");
	    });
	    
	
	    /* [Grid] 패널설정 */
	    var grid = new Rui.ui.grid.LGridPanel({
	        columnModel: columnModel,
	        dataSet: dataSet,
	        width: 1210,
	        height: 420,
	        autoWidth: true
	
	    });
	    
	    grid.render('defaultGrid');
	        
	    
	    grid.on('cellClick', function(e) {
             var tssCd     = dataSet.getNameValue(e.row, "tssCd");     //과제코드
             var pPgsStepCd = dataSet.getNameValue(e.row, "pgsStepCd"); //진행상태코드

             var urlParam = "?tssCd="+tssCd

             //계획
             if(pPgsStepCd == "PL") {
                 nwinsActSubmit(document.aform, "<c:url value='/prj/tss/mkInno/mkInnoTssPlnDetail.do?tssCd="+tssCd+"'/>");
             }else if(pPgsStepCd == "PG") {
                  nwinsActSubmit(document.aform, "<c:url value='/prj/tss/mkInno/mkInnoTssPgsDetail.do'/>"+urlParam);
             }else if(pPgsStepCd == "CM") {
                 nwinsActSubmit(document.aform, "<c:url value='/prj/tss/mkInno/mkInnoTssCmplDetail.do'/>"+urlParam);
             }
        });
	    
	    /* [버튼] 조회 */
	    fnSearch = function() {
	    	dataSet.load({
	            url: '<c:url value="/prj/tss/mkInno/retrieveMkInnoTssList.do"/>'
	          , params : {
	                wbsCd : document.aform.wbsCd.value                        //과제코드
	              , tssNm : encodeURIComponent(document.aform.tssNm.value)    //과제명
	              , deptName : encodeURIComponent(document.aform.deptName.value)                  //조직
	              , tssStrtDd : tssStrtDd.getValue() //과제기간(시작일)
	              , tssFnhDd : tssFnhDd.getValue()   //과제기간(종료일)
	              , tssSt : tssSt.getValue()                        //상태
	              , prjNm : encodeURIComponent(document.aform.prjNm.value)    //프로젝트명
	              , saUserName : encodeURIComponent(document.aform.saUserName.value)    //과제리더명
	              , pgsStepCd : document.aform.pgsStepCd.value                //상태
	            }
	        });
	    };     
        
	    fnSearch();
	    
	    /* [버튼] 엑셀 */
        var butExcel = new Rui.ui.LButton('butExcel');
        butExcel.on('click', function() {
          	dataSet.clearFilter();
        	var dataSet2 = dataSet.clone('dataSet2');
        	/* [Grid] 엑셀 */
            var grid2 = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: dataSet2,
                width: 0,
                height: 0
            });
            grid2.render('defaultGrid2');
	         // 목록 페이징
            paging(dataSet,"defaultGrid");
            if(dataSet.getCount() > 0) {

            	var excelColumnModel = new Rui.ui.grid.LColumnModel({
                    gridView: columnModel,
                    columns: [
                    	 { field: 'wbsCd',      label: '과제코드', sortable: true, align:'center', width: 85, renderer: function(value, p, record, row, col) {
                             var stepCd = record.get("pgsStepCd");
                             if(stepCd == "PL") return "SEED-" + value;
                             return value;
                       }}
                     , { field: 'tssNm',         label: '과제명', sortable: true, align:'center', width: 290 }
                     , { field: 'prjNm',        label: '팀명', sortable: true, align:'center', width: 120 }
                     , { field: 'saUserName',   label: '과제리더', sortable: true, align:'center', width: 80 }
                     , { field: 'deptName',     label: '조직', sortable: true, align:'center', width: 100 }
                     , { id: 'G1', label: '과제기간(계획일)' }
                     , { field: 'tssStrtDd',    label: '시작일', groupId: 'G1', sortable: true, align:'center', width: 73 }
                     , { field: 'tssFnhDd',     label: '종료일', groupId: 'G1', sortable: true, align:'center', width: 73 }
                     , { field: 'cmplNxFnhDd',  label: '종료일(실종료일)', sortable: true, align:'center', width: 73 }
                     , { field: 'pgsStepNm',    label: '상태', sortable: true, align:'center', width: 50 }
                     , { field: 'tssStNm',        label: '처리상태', sortable: true, align:'center', width: 80}
                 ]
             });
            	duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('과제관리_제조혁신과제_') + new Date().format('%Y%m%d') + '.xls', {
		            columnModel: excelColumnModel
		        });

            } else {
                Rui.alert("조회 후 엑셀 다운로드 해주세요.");
            }

        });
        
        function setSize(gridObj,id){
            var winH = $(window).height();
            var listY = $("#"+id).offset().top;
            var bottomH = 20;
            var listH = winH-listY - bottomH;
            if(listH<200)listH=300;
            gridObj.setHeight(listH);
        }

        function setGridFullHeight(gridObj,id){
            setSize(gridObj,id);
            $(window).resize(function(){
                setSize(gridObj,id);
            });
        }
        
        fncMkInnoRegPop = function(){
        	mkInnoRegDialog.setUrl('<c:url value="/prj/tss/mkInno/mkInnoTssRegPop.do"/>');
        	mkInnoRegDialog.show(true);
        }
        
	});
	
	

</script>
</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
<Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
        <div class="titleArea">
        	<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
            <h2>제조혁신 과제관리</h2>
        </div>
		<div class="sub-content">
            <form name="aform" id="aform" method="post">
            <input type="hidden" id="deptCode" value="">
                <div class="search">
					<div class="search-content">
						<table>
		                    <colgroup>
		                        <col style="width:120px" />
								<col style="width:330px" />
								<col style="width:120px" />
								<col style="width:200px" />
								<col style="" />
		                    </colgroup>
		                    <tbody>
		                        <tr>
		                            <th>과제코드</th>
		                            <td>
		                                <input type="text" id="wbsCd" value="">
		                            </td>
		                            <th>과제명</th>
		                            <td>
		                                <input type="text" id="tssNm" value="">
		                            </td>
		                            <td></td>
		                        </tr>
		                        <tr>
		                            <th>과제리더</th>
		                            <td>
		                                <input type="text" id="saUserName" value="">
		                            </td>
		                            <th>조직</th>
		                            <td>
		                                <input type="text" id="deptName" value="">
		                            </td>
		                            <td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
		                        </tr>
		                        <tr>
		                            <th>과제기간</th>
		                            <td>
		                            	<input type="text" id="tssStrtDd" /><em class="gab"> ~ </em><input type="text" id="tssFnhDd" />
		                            </td>
		                            <th>팀명</th>
		                            <td>
		                                <input type="text" id="prjNm" value="">
		                            </td>
		                            <td></td>
		                        </tr>
		                        <tr>
		                            <th>상태</th>
		                            <td>
		                                <div id="pgsStepCd"></div>
		                            </td>
		                            <th>처리상태</th>
		                            <td>
		                                <div id="tssSt"></div>
		                            </td>
		                            <td></td>
		                        </tr>
		                    </tbody>
		                </table>
					</div>
				</div>	
			</form>	
		
			<div class="titArea">
                <span class="Ltotal" id="cnt_text">총 : 0건</span>
                <div class="LblockButton">
                    <button type="button" id="butReg" name="butReg" onClick="fncMkInnoRegPop()">신규과제등록</button>
                    <button type="button" id="butExcel" name="butExcel">EXCEL다운로드</button>
                </div>
            </div>

            <div id="defaultGrid"></div>
       </div>
   </div>         
</body>
</html>
