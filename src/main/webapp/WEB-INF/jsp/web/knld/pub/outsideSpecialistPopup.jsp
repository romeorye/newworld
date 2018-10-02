<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>
<%--
/*
 *************************************************************************
 * $Id      : outsideSpecialistPopup.jsp
 * @desc    : 사외전문가 팝업
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.19  IRIS04      최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">

Rui.onReady(function() {
	
	/*검색조건*/
	var lcbSearchType = new Rui.ui.form.LCombo({
		useEmptyText: false,
        applyTo: 'searchType',
        defaultValue: 'instNm',
        items: [
             { text: '기관명'        , value: 'instNm' }
           , { text: '사외전문가명'  , value: 'spltNm' }  
           , { text: '대표분야'      , value: 'repnSphe' }
        ]
        
    });
	lcbSearchType.on('blur', function(e) {
		lcbSearchType.setValue(lcbSearchType.getValue().trim());
    });
	lcbSearchType.on('changed', function(e){
		ltbSearchParam.setValue('');
    });
	
	/*검색파람*/
	var ltbSearchParam = new Rui.ui.form.LTextBox({
	     applyTo : 'searchParam',
	     placeholder : '',
	     defaultValue : '',
	     emptyValue: '',
	     width : 250
	});
	ltbSearchParam.on('blur', function(e) {
		ltbSearchParam.setValue(ltbSearchParam.getValue().trim());
    });
	ltbSearchParam.on('keypress', function(e) {
    	if(e.keyCode == 13) {
    		getOutsideSpecialist();
    	}
    });

	/** dataSet **/
	outSpclDataSet = new Rui.data.LJsonDataSet({
	    id: 'outSpclDataSet',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
			      { id: 'outSpclId' }
				, { id: 'instNm'    }
				, { id: 'opsNm'     }
				, { id: 'poaNm'     }
				, { id: 'spltNm'    }
				, { id: 'tlocNm'    }
				, { id: 'ccpcNo'    }
				, { id: 'eml'       }
				, { id: 'repnSphe'  }
				, { id: 'hmpg'      }
				, { id: 'timpCarr'  }
				, { id: 'attcFilId' }
				, { id: 'rgstId'    }
				, { id: 'rgstNm'    }
				, { id: 'rgstOpsId' }
				, { id: 'delYn'     }
				, { id: 'frstRgstDt'}
		]
	});
      var columnModel = new Rui.ui.grid.LColumnModel({
          columns: [
                { field: 'instNm',	  label: '기관명',       sortable: false,	align:'left',	width: 200 }
              , { field: 'opsNm',	  label: '부서',		 sortable: false,	align:'center',	width: 130 }
              , { field: 'poaNm',	  label: '직위',		 sortable: false,	align:'center',	width: 100 }
		      , { field: 'spltNm',	  label: '사외전문가명', sortable: false, 	align:'center',	width: 100 }
	  	      , { field: 'repnSphe',  label: '대표분야',     sortable: false, 	align:'left', width: 150 }
          ]
      });

	var grid = new Rui.ui.grid.LGridPanel({
	    columnModel : columnModel,
	    dataSet : outSpclDataSet,
	    width :710,
	    height : 300,
	    autoToEdit : false,
	    autoWidth : true
	});

 	grid.on('cellDblClick', function(e) {

		parent._callback(outSpclDataSet.getAt(e.row).data);
		parent.outsideSpecialistSearchDialog.submit();
	});

	grid.render('grid01');

	/* [버튼] 조회 */
	getOutsideSpecialist = function() {
		// 검색조건 초기화
		aform.instNm.value = '';
		aform.repnSphe.value = '';
		aform.spltNm.value = '';
		
		var searchType = lcbSearchType.getValue();
		var searchParam = ltbSearchParam.getValue();
		if(searchType == 'instNm'){
			aform.instNm.value = searchParam;
		}else if(searchType == 'repnSphe'){
			aform.repnSphe.value = searchParam;
		}else if(searchType == 'spltNm'){
			aform.spltNm.value = searchParam;
		}
			
		outSpclDataSet.load({
			url : '<c:url value="/knld/pub/getOutsideSpeciaList.do"/>',
			params :{
				  instNm   : encodeURIComponent(aform.instNm.value)
				, repnSphe : encodeURIComponent(aform.repnSphe.value)
				, spltNm   : encodeURIComponent(aform.spltNm.value)
               }
		});
	};

	// onLoad 조회
	//getOutsideSpecialist();

});

</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="hSearchType" name="hSearchType" value="${inputData.searchType}"/>
		<input type="hidden" id="hSearchParam" name="hSearchParam" value="${inputData.searchParam}"/>
		<input type="hidden" id="instNm" name="instNm" value=""/>
		<input type="hidden" id="repnSphe" name="repnSphe" value=""/>
		<input type="hidden" id="spltNm" name="spltNm" value=""/>

		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0; padding-left:3px;">
				<div class="search mb5">
				<div class="search-content">
 				<table>
 					<colgroup>
 						<col style="width:110px;"/>
 						<col style="width:*"/>
 					</colgroup>
 					<tbody>
 						<tr>
 							<th>검색조건</th>
 							<td>
 								<div id="searchType"></div>
 								<input type="text" id="searchParam" value="">
 								<a style="cursor: pointer;" onclick="getOutsideSpecialist();" class="btnL">검색</a>
 							</td>
 						</tr>
 					</tbody>
 				</table>
 				</div>
 				</div>

 				<div id="grid01"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->

		</form>
    </body>
</html>