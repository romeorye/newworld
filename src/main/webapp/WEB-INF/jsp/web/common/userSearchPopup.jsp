<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: userSearchPopup.jsp
 * @desc    : 사용자 조회 공통 팝업
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            var cnt = '${inputData.cnt}';
            var deptNm = new Rui.ui.form.LTextBox({
                 applyTo : 'deptNm',
                 placeholder : '',
                 defaultValue : '',
                 emptyValue: '',
                 width : 180
            });

            deptNm.on('blur', function(e) {
            	deptNm.setValue(deptNm.getValue().trim());
            });

            deptNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getUserList();
            	}
            });

            var userNm = new Rui.ui.form.LTextBox({
                 applyTo : 'userNm',
                 placeholder : '',
                defaultValue : '',
                emptyValue: '',
                 width : 180
            });
            userNm.focus();

            userNm.on('blur', function(e) {
            	// userNm.setValue(userNm.getValue().trim());
            });

            userNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getUserList();
            	}
            });

            /*******************
             * 변수 및 객체 선언
            *******************/
            var userDataSet = new Rui.data.LJsonDataSet({
                id : 'userDataSet',
                remainRemoved : true,
                lazyLoad : true,
                fields : [
                	  { id : 'saSabun'}
                	, { id : 'saUser'}
                	, { id : 'saName'}
                	, { id : 'saEName'}
                	, { id : 'saCName'}
                	, { id : 'deptName'}
                	, { id : 'deptCd'}
                	, { id : 'saJobxName'}
                	, { id : 'saJobx'}
                	, { id : 'saPhoneArea'}
                	, { id : 'saHand'}
                	, { id : 'saMail'}
                	, { id : 'uperDeptCd'}
                	, { id : 'uperDeptNm'}
                	, { id : 'prjCd'}
                ]
            });

            var userColumnModel = new Rui.ui.grid.LColumnModel({
                columns : [
                <c:if test="${inputData.cnt != 1}">
              	  	  new Rui.ui.grid.LSelectionColumn(),
              	</c:if>
                      { field : 'saName',		label : '이름',		sortable : false,	align :'center',	width : 80 }
                    , { field : 'saUser',		label : '아이디',	sortable : false,	align :'center',	width : 80 }
                    , { field : 'saJobxName',	label : '직위',		sortable : false,	align :'center',	width : 80 }
                    , { field : 'deptName',		label : '부서',		sortable : false,	align :'left',	width : (cnt == 1 ? 250 : 230) }
                    , { field : 'uperDeptCd',	hidden: true }
                    , { field : 'prjCd',		hidden: true }
                    , { field : 'saSabun',		hidden: true }
                ]
            });

            var userGrid = new Rui.ui.grid.LGridPanel({
                columnModel : userColumnModel,
                dataSet : userDataSet,
                width : 500,
                height : 150,
                autoToEdit : false,
                autoWidth : true
            });

            userGrid.render('userGrid');


            userGrid.on('cellDblClick', function(e) {
            	<c:if test="${inputData.cnt != 1}">
            		var record =  userDataSet.getAt(userDataSet.getRow());

            		if(selectUserDataSet.findRow('saSabun', record.data.saSabun) == -1) {
						selectUserDataSet.add(record.clone());
            		}

	            </c:if>
            	<c:if test="${inputData.cnt == 1}">
            		parent._callback(userDataSet.getAt(e.row).data);
            		parent._userSearchDialog.submit(true);
	            </c:if>
            });

            /* [버튼] 조회 */
            getUserList = function() {
            	userDataSet.load({
                    url : '<c:url value="/system/user/getUserList.do"/>',
                    params : {
                    	task : '${inputData.task}',
                    	deptNm : encodeURIComponent(deptNm.getValue()),
                    	userNm : encodeURIComponent(userNm.getValue()),
                    	userIds : ''
                    }
                });
            };

        <c:if test="${inputData.cnt != 1}">
	        var selectUserDataSet = userDataSet.clone('selectUserDataSet');

	        var selectUserColumnModel = new Rui.ui.grid.LColumnModel({
	            columns : [
	          	  	  new Rui.ui.grid.LSelectionColumn()
	                , { field : 'saName',		label : '이름',		sortable : false,	align :'center',	width : 80 }
	                , { field : 'saUser',		label : '아이디',	sortable : false,	align :'center',	width : 80 }
	                , { field : 'saJobxName',	label : '직위',		sortable : false,	align :'center',	width : 80 }
	                , { field : 'deptName',		label : '부서',		sortable : false,	align :'center',	width : (cnt == 1 ? 250 : 230) }
	            ]
	        });

	        var selectUserGrid = new Rui.ui.grid.LGridPanel({
	            columnModel : selectUserColumnModel,
	            dataSet : selectUserDataSet,
	            width : 500,
	            height : 150,
	            autoToEdit : false,
	            autoWidth : true
	        });

	        selectUserGrid.render('selectUserGrid');

	        if($('#userIds').val() != '') {
	        	selectUserDataSet.load({
	                url : '<c:url value="/system/user/getUserList.do"/>',
	                params : {
                    	task : '${inputData.task}',
	                	deptNm : '',
	                	userNm : '',
	                	userIds : $('#userIds').val()
	                }
	            });
	        }

	        /* [버튼] 추가 */
	        addUser = function() {
	        	var selectUser = userDataSet.getMarkedRange();

				for(var i = 0, size = userDataSet.getMarkedCount(); i < size ; i++ ){
					if(selectUserDataSet.findRow('saSabun', selectUser.items[i].data.saSabun) == -1) {
	        			selectUserDataSet.add(selectUser.items[i].clone());
					}
				}
	        };

	        /* [버튼] 삭제 */
	        deleteUser = function() {
				for( var i = selectUserDataSet.getCount(); i > -1 ; i-- ) {
					if(selectUserDataSet.isMarked(i)) {
						selectUserDataSet.removeAt(i);
					}
				}
	        };

	        getSelectUser = function() {
	        	var userList = [];

				for( var i = 0, size = selectUserDataSet.getCount(); i < size ; i++ ) {
					userList.push(selectUserDataSet.getAt(i).data);
				}

				return userList;
	        };
      	</c:if>

			//이름이 있는 경우 검색 실행
			if(decodeURIComponent('${inputData.userNm}')!=''){
                userNm.setValue(decodeURIComponent('${inputData.userNm}'));
                getUserList();
            }
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="cnt" name="cnt" value="${inputData.cnt}"/>
		<input type="hidden" id="userIds" name="userIds" value="${inputData.userIds}"/>

   		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0; padding-left:3px;">
	   			<div class="search mb5">
				<div class="search-content">
   				<table>
   					<colgroup>
   						<col style="width:80px;">
   						<col style="">
   						<col style="width:80px;">
   						<col style="">
   						<col style="width:80px;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">이름</th>
    						<td class="user_search_td">
   								<input type="text" id="userNm" value="">
    						</td>
    						<th align="right">부서</th>
   							<td class="user_search_td">
   								<input type="text" id="deptNm" value="">
   							</td>
   							<td class="txt-right">
   								<a style="cursor: pointer;" onclick="getUserList();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
   				</div>

   				<div id="userGrid"></div>

        	<c:if test="${inputData.cnt != 1}">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="rgstBtn" name="rgstBtn" onclick="addUser();">추가</button>
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="deleteUser();">삭제</button>
   					</div>
   				</div>

   				<div id="selectUserGrid"></div>
   			</c:if>
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>