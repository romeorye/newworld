<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
                 java.util.*,
                 devonframe.util.NullUtil,
                 devonframe.util.DateUtil"%>
<%--
/*
 *************************************************************************
 * $Id      : tssSearchPopup.jsp
 * @desc    : 과제 조회 팝업
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.08
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript">

Rui.onReady(function() {
    //과제명
    var tssNm = new Rui.ui.form.LTextBox({
           applyTo : 'tssNm'
         , width : 150
         , emptyValue : ''
    });
    tssNm.on('blur', function(e) {
        //tssNm.setValue(tssNm.getValue().trim());
    });
    tssNm.on('keypress', function(e) {
        if(e.keyCode == 13) {
            fnSearch();
        }
    });

    //프로젝트명
    var prjNm = new Rui.ui.form.LTextBox({
          applyTo : 'prjNm'
        , width : 150
        , emptyValue : ''
    });

    var tssDataSet = new Rui.data.LJsonDataSet({
        id : 'tssDataSet',
        lazyLoad : true,
        fields : [
              { id: 'prjCd' }        //프로젝트코드
            , { id: 'prjNm' }        //프로젝트명
            , { id: 'tssCd' }        //과제코드
            , { id: 'pgsStepCd' }    //진행단계코드
            , { id: 'tssScnCd' }     //과제구분코드
            , { id: 'tssScnNm' }     //과제구분명
            , { id: 'wbsCd' }        //WBS코드
            , { id: 'pkWbsCd' }     //WBS코드(변경불가)
            , { id: 'deptCode' }     //조직코드(소속)
            , { id: 'ppslMbdCd' }    //발의주체코드
            , { id: 'bizDptCd' }     //사업부문코드
            , { id: 'tssNm' }        //과제명
            , { id: 'saSabunNew' }   //과제리더사번
            , { id: 'tssAttrCd' }    //과제속성코드
            , { id: 'tssStrtDd' }    //과제시작일
            , { id: 'tssFnhDd' }     //과제종료일
            , { id: 'altrBStrtDd' }  //변경전시작일
            , { id: 'altrBFnhDd' }   //변경전종료일
            , { id: 'altrNxStrtDd' } //변경후시작일
            , { id: 'altrNxFnhDd' }  //변경후종료일
            , { id: 'cmplBStrtDd' }  //완료전시작일
            , { id: 'cmplBFnhDd' }   //완료전종료일
            , { id: 'cmplNxStrtDd' } //완료후시작일
            , { id: 'cmplNxFnhDd' }  //완료후종료일
            , { id: 'dcacBStrtDd' }  //중단전시작일
            , { id: 'dcacBFnhDd' }   //중단전종료일
            , { id: 'dcacNxStrtDd' } //중단후시작일
            , { id: 'dcacNxFnhDd' }  //중단후종료일
            , { id: 'cooInstCd' }    //협력기관코드
            , { id: 'supvOpsNm' }    //주관부서명
            , { id: 'exrsInstNm' }   //전담기관명
            , { id: 'bizNm' }        //사업명
            , { id: 'tssSt' }        //과제상태
            , { id: 'tssNosSt' }     //과제차수상태
            , { id: 'tssStTxt' }     //과제상태의견
        ]
    });

    var tssColumnModel = new Rui.ui.grid.LColumnModel({
        columns : [
              { field : 'wbsCd',    label : 'WBS코드',  align :'center',    width : 70 }
            , { field : 'tssNm',    label : '과제명',   align :'left',    width : 200 }
            , { field : 'prjNm',    label : '프로젝트명', align :'left',    width : 200 }
            , { field : 'tssScnNm', label : '과제구분', align :'center',    width : 70 }
            , { field : 'tssNosSt', label : '과제차수', align :'center',    width : 70 }
        ]
    });

    var tssGrid = new Rui.ui.grid.LGridPanel({
        columnModel : tssColumnModel,
        dataSet : tssDataSet,
        width : 660,
        height : 290,
        autoToEdit : false,
        autoWidth : true
    });

    tssGrid.on('cellDblClick', function(e) {
        parent._callback(tssDataSet.getAt(e.row).data);
        parent.tssSearchDialog.submit(true);
    });

    tssGrid.render('tssGrid');

    /* [버튼] 조회 */
    fnSearch = function() {
        tssDataSet.load({
            url : '<c:url value="/prj/tss/com/retrieveTssSearchPopup.do"/>',
            params : {
                tssNm      : encodeURIComponent(tssNm.getValue()) ,
                prjNm      : encodeURIComponent(prjNm.getValue()) ,
                userDeptCd : document.aform.userDeptCd.value
            }
        });
    };

    /* 최초 데이터 셋팅 */
    if(${resultCnt} > 0) {
        tssDataSet.loadData(${result});
    }
});

</script>
    </head>
    <body>
    <form name="aform" id="aform" method="post" onSubmit="return false;">
    	<input type="hidden" id="userDeptCd" name="userDeptCd" value="<c:out value='${inputData.userDeptCd}'/>"/><!-- 부모창에서 넘어온 조회파라미터 : 특정부서의 프로젝트 과제만 조회시 -->
        <div class="LblockMainBody">
            <div class="sub-content" style="padding:5px 0 0 3px;">
            	<div class="search mb5">
				<div class="search-content">
                <table>
                    <colgroup>
                        <col style="width:90px;"/>
                        <col style="width:"/>
                        <col style="width:90px;"/>
                        <col style="width"/>
                        <col style="width:*;"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th align="right">과제명</th>
                            <td>
                                <input type="text" id="tssNm" value="">
                            </td>
                            <th align="right">프로젝트명</th>
                            <td>
                                <input type="text" id="prjNm" value="">
                            </td>
                            <td class="txt-right">
                                <a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </div>
                </div>

                <div id="tssGrid"></div>

            </div><!-- //sub-content -->
        </div><!-- //contents -->

        </form>
    </body>
</html>