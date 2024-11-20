<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id      : tssUpdatePop.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2021.03.03
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=scriptPath%>/custom.js"></script>
<script type="text/javascript">

	Rui.onReady(function() {
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
	    
	    dataSet = new Rui.data.LJsonDataSet({
	        id: 'dataSet',
	        focusFirstRow: 0,
	        remainRemoved: true,
	        lazyLoad: true,
	        fields: [
	        	 { id: 'tssCd'}
	            ,{ id: 'wbsCd'}
	            ,{ id: 'pkWbsCd'}
	            ,{ id: 'pgsStepCd'}
	            ,{ id: 'tssSt'}
	            ,{ id: 'tssScnCd'}
	            ,{ id: 'tssScnNm'}
	            ,{ id: 'grsYn'}
	            ,{ id: 'tssNm'}
	            ,{ id: 'prjCd'}
	            ,{ id: 'prjNm'}
	            ,{ id: 'bizDptCd'}
	            ,{ id: 'bizDptNm'}
	            ,{ id: 'prodG'}
	            ,{ id: 'prodGNm'}
	            ,{ id: 'saSabunNew'}
	            ,{ id: 'saSabunNm'}
	            ,{ id: 'tssStrtDd'}
	            ,{ id: 'tssFnhDd'}
	            ,{ id: 'custSqlt'}
	            ,{ id: 'custSqltNm'}
	            ,{ id: 'tssAttrCd'}
	            ,{ id: 'tssAttrNm'}
	            ,{ id: 'tssType'}
	            ,{ id: 'tssTypeNm'}
	            ,{ id: 'fcCd'}
	            ,{ id: 'fcNm'}
	            ,{ id: 'ppslMbdCd'}
	            ,{ id: 'ppslMbdNm'}
	            ,{ id: 'rsstSphe'}
	            ,{ id: 'rsstSpheNm'}
	            ,{ id: 'deptCode'}
	         ]
	    });
		
		dataSet.on('load', function(e){
			tssStrtDd.disable();
		});

		//과제기간 시작일
        tssStrtDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssStrtDd',
            mask: '9999-99-99',
            width: 100,
            listPosition : 'down',
            dateType: 'string'
        });

        // 과제기간 종료일
        tssFnhDd = new Rui.ui.form.LDateBox({
            applyTo: 'tssFnhDd',
            mask: '9999-99-99',
            width: 100,
            listPosition : 'down',
            dateType: 'string'
        });
        
        tssFnhDd.on('blur', function() {
            if(!Rui.isEmpty(tssFnhDd.getValue())) {
                var startDt = tssStrtDd.getValue().replace(/\-/g, "").toDate();
                var fnhDt   = tssFnhDd.getValue().replace(/\-/g, "").toDate();

                var rtnValue = ((fnhDt - startDt) / 60 / 60 / 24 / 1000) + 1;

                if(rtnValue <= 0) {
                    Rui.alert("시작일보다 종료일이 빠를 수 없습니다.");
                    tssFnhDd.setValue("");
                    return;
                }
            }
        });
        
        fnSearch = function() {
        	dataSet.load({
                url: '<c:url value="/prj/grs/selectGrsMngInfo.do"/>'
              , params : {
                    tssCd : '${inputData.tssCd}'                       //과제코드
                }
            });
        };
        
        fnSearch();
        
        
        //과제 수정
        fncTssUpdate = function(){
        
            if(!dataSet.isUpdated()) {
                Rui.alert("변경된 데이터가 없습니다.");
                return;
            }
    	    
            if(!valid.validateGroup("aform")) {
        		alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid.getMessageList().join(''));
                return;
        	}
            
        	var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
            dm.on('success', function (e) {      // 업데이트 성공시
                var resultData = resultDataSet.getReadData(e);

            	alert(resultData.records[0].rtnMsg);
            	
                if ( resultData.records[0].rtnSt == "S"  ){
	                parent.tssUpdatePopDialog.submit(true);
	                parent.fnSearch();
                }
            });

            dm.on('failure', function (e) {      // 업데이트 실패시
                var resultData = resultDataSet.getReadData(e);
                alert(resultData.records[0].rtnMsg);
            });
            
        	if(confirm('수정하시겠습니까?')) {
                dm.updateDataSet({
                    dataSets:[dataSet],
                    url:'<c:url value="/prj/grs/updateTssInfo.do"/>'
                });
        	}	
        } 
      
    	//과제 수정취소
        fncCancel = function(){
        	parent.tssUpdatePopDialog.submit(true);
        }
        
        var valid = new Rui.validate.LValidatorManager({
            validators:[
                {id:'tssStrtDd', validExp:'과제기간시작:true'},
                {id:'tssFnhDd', validExp:'과제기간끝:true'}
            ]
        });
        
		bind = new Rui.data.LBind({
    		groupId: 'aform',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                 { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                ,{ id: 'wbsCd',            ctrlId: 'wbsCd',            value: 'value' }
                ,{ id: 'pkWbsCd',          ctrlId: 'pkWbsCd',          value: 'value' }
                ,{ id: 'pgsStepCd',        ctrlId: 'pgsStepCd',        value: 'value' }
                ,{ id: 'tssSt',            ctrlId: 'tssSt',            value: 'value' }
                ,{ id: 'tssScnCd',         ctrlId: 'tssScnCd',         value: 'value' }
                ,{ id: 'tssScnNm',         ctrlId: 'tssScnNm',         value: 'html' }
                ,{ id: 'grsYn',            ctrlId: 'grsYn',            value: 'html' }
                ,{ id: 'tssNm',            ctrlId: 'tssNm',            value: 'html' }
                ,{ id: 'prjCd',            ctrlId: 'prjCd',            value: 'value' }
                ,{ id: 'prjNm',            ctrlId: 'prjNm',            value: 'html' }
                ,{ id: 'bizDptNm',         ctrlId: 'bizDptNm',         value: 'html' }
                ,{ id: 'prodGNm',            ctrlId: 'prodGNm',            value: 'html' }
                ,{ id: 'saSabunNew',        ctrlId: 'saSabunNew',        value: 'value' }
                ,{ id: 'saSabunNm',        ctrlId: 'saSabunNm',        value: 'html' }
                ,{ id: 'tssStrtDd',        ctrlId: 'tssStrtDd',        value: 'value' }
                ,{ id: 'tssFnhDd',         ctrlId: 'tssFnhDd',         value: 'value' }
                ,{ id: 'custSqltNm',         ctrlId: 'custSqltNm',         value: 'html' }
                ,{ id: 'tssAttrNm',        ctrlId: 'tssAttrNm',        value: 'html' }
                ,{ id: 'tssTypeNm',          ctrlId: 'tssTypeNm',          value: 'html' }
                ,{ id: 'fcNm',             ctrlId: 'fcNm',             value: 'html' }
                ,{ id: 'rsstSpheNm',         ctrlId: 'rsstSpheNm',         value: 'html' }
                ,{ id: 'ppslMbdNm',        ctrlId: 'ppslMbdNm',        value: 'html' }

            ]
        });
		
	});	//end ready		
	

	</script>
	</head>
	<body>
	<div class="LblockMainBody">  
		<div class="sub-content">  
	  	<form id="aform" name="aform">	
	  		<table class="table table_txt_right">
				<colgroup>
					<col style="width:17%;"/>
					<col style="width:33%;"/>
					<col style="width:17%;"/>
					<col style="width:33%;"/>
				</colgroup>
				<tbody>
					<tr>
						<th align="right" ><span style="color:red;">* </span>과제구분</th>
						<td><span id="tssScnNm" /></td>
						<th align="right"><span style="color:red;">* </span>G1 수행여부</th>
						<td><span id="grsYn" /></td>
					</tr>
					<tr>
						<th align="right"><span style="color:red;">* </span>과제리더</th>
						<td><span id="saSabunNm" /></td>
						<th align="right"><span style="color:red;">* </span>사업부문<br/>(Funding기준)</th>
						<td><span id="bizDptNm" /></td>
					</tr>
					<tr>
						<th align="right"><span style="color:red;">* </span>프로젝트명<br />(개발부서)</th>
						<td colspan="3" ><span id="prjNm"></span>
					</tr>
					<tr>
						<th align="right"><span style="color:red;">* </span>과제명</th>
						<td colspan="3"><span id="tssNm" /></td>
					</tr>
					<tr>
						<th align="right"><span style="color:red;">* </span>제품군</th>
						<td><span id="prodGNm" /></td>
						<th align="right"><span style="color:red;">* </span>과제기간</th>
						<td><input type="text" id="tssStrtDd"> <em class="gab">~ </em> <input type="text" id="tssFnhDd"></td>
					</tr>
					<tr id="displayDiv1">
						<th align="right"><span style="color:red;">* </span>사업유형</th>
						<td><span id="custSqltNm" /></td>
						<th align="right"><span style="color:red;">* </span>과제속성</th>
						<td><span id="tssAttrNm" /></td>
					</tr>
					<tr id="displayDiv2">
						<th align="right"><span style="color:red;">* </span>개발등급</th>
						<td><span id="tssTypeNm" /></td>
						<th align="right"><span style="color:red;">* </span>공장구분</th>
						<td><span id="fcNm" /></td>
					</tr>
					<tr id="displayDiv3">
						<th align="right"><span style="color:red;">* </span>발의주체</th>
						<td><span id="ppslMbdNm" /></td>
						<th align="right"><span style="color:red;">* </span>연구분야</th>
						<td><span id="rsstSpheNm" /></td>
					</tr>
				</tbody>
			</table>	
	  		
	  	</form>
		</div>
	  		<div class="titArea">
		    <div class="LblockButton">
		        <button type="button" id="btnTssUpdate" onclick="fncTssUpdate()">수정</button>
		        <button type="button" id="butCancel" onClick="fncCancel()">닫기</button>
		    </div>
		</div>  
	</div>  
	</body>
	</html>	
