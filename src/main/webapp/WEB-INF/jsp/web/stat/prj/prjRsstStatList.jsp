<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
                 java.util.*,
                 devonframe.util.NullUtil,
                 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id        : prjRsstStatList.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER    DATE        AUTHOR        DESCRIPTION
 * ---    -----------    ----------    -----------------------------------------
 * 1.0  2017.12.15
 * ---    -----------    ----------    -----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script><!-- Lgrid view -->

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

    <script type="text/javascript">

        Rui.onReady(function() {

            var yy = document.aform.yyyy.value;

//            if(Rui.isEmpty(yy)){
                document.aform.yyyy.value = new Date().format('%Y');
//            }

            /*******************
             * 변수 및 객체 선언
            *******************/
            var dataSet = new Rui.data.LJsonDataSet({
                id: 'dataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: false,
                fields: [
                       { id: 'prjCd'}
                        , { id: 'wbsCd' }
                        , { id: 'deptNm' }       /*조직명*/
                        , { id: 'prjNm' }        /*프로젝트명*/
                        , { id: 'plEmpName' }    /*PL명*/
                        , { id: 'prjCpsn' }      /*팀원수*/
                        , { id: 'pduGoalCnt' }   /*Monthly Report 목표개수*/
                        , { id: 'arslCnt' }      /*Monthly Report 실적개수*/
                        , { id: 'prptGoalCnt' }  /*계획 지적재산권 개수*/
                        , { id: 'prptArslCnt' }  /*실적 지적재산권 개수*/
                        , { id: 'ttm' }          /*TTM(과제완료률)*/
                        , { id: 'tssBudg' }      /*예산(억원)*/
                        , { id: 'tssExp' }          /*비용(억원)*/
                        , { id: 'tssExe' }       /*집행율(%) 소수점1자리*/
                ]
            });

            var columnModel = new Rui.ui.grid.LColumnModel({
                groupMerge: true,
                columns: [
                      { field: 'deptNm',          label: '조직명',           sortable: false,  align:'center', width: 300 }
                    , { field: 'prjNm',         label: '프로젝트명',       sortable: false,  align:'left', width: 335 }
                    , { field: 'plEmpName',     label: 'PL',             sortable: false,  align:'center', width: 80 }
                    , { field: 'prjCpsn',          label: '팀원',             sortable: false,  align:'right', width: 73
                        , renderer: function(value, p, record, row, col){
                            if( value != '' && value != null && value != 'undefined' ){
                                return value + '명'
                            }else{
                                return '0명'
                            }
                        }
                      }
                    , { id : '지적재산권 (국내)'}
                    , { field: 'prptGoalCnt',   groupId: '지적재산권 (국내)' ,label: '계획',    sortable: false,  align:'center', width: 80
                        , renderer: function(value, p, record, row, col){
                            var prptArslCnt = record.get('prptArslCnt');    // 실적

                            if( value != '' && value != null && value != 'undefined' ){
                                return value + '건';
                            }
                            // 실적이 존재하면 0건으로 화면표시
                            else if( prptArslCnt != '' && prptArslCnt != null && prptArslCnt != 'undefined' ){
                                return '0건';
                            }
                        }
                      }
                    , { field: 'prptArslCnt',   groupId: '지적재산권 (국내)' ,label: '실적',    sortable: false,  align:'center', width: 80
                        , renderer: function(value, p, record, row, col){
                            var prptGoalCnt = record.get('prptGoalCnt');    // 계획

                            if( value != '' && value != null && value != 'undefined' ){
                                return value + '건';
                            }
                            // 계획이 존재하면 0건으로 화면표시
                            else if( prptGoalCnt != '' && prptGoalCnt != null && prptGoalCnt != 'undefined' ){
                                return '0건';
                            }
                        }
                      }
                    , { field: 'ttm',            label: 'TTM(%)<BR>(개발완료)',              sortable: false,  align:'center', width: 80
                        , renderer: function(value, p, record, row, col){
                            if( value != '' && value != null && value != 'undefined' ){
                                return value + '%';
                            }
                        }
                      }
                    , { field: 'tssBudg',         label: '예산(억원)',             sortable: false,  align:'right',  width: 90 }
                    , { field: 'tssExp',          label: '비용(억원)',             sortable: false,  align:'right',  width: 90 }
                    , { field: 'tssExe',        label: '집행율(%)',               sortable: false,  align:'center', width: 100
                        , renderer: function(value, p, record, row, col){
                            if( value != '' && value != null && value != 'undefined' ){
                                return value + '%';
                            }else if( value == 0){
                                return value + '%';
                            }
                        }
                      }
                ]
            });

            var defaultGrid = new Rui.ui.grid.LGridPanel({
                columnModel: columnModel,
                dataSet: dataSet,
                width: 1150,
                height: 400,
                autoWidth: true
            });

            defaultGrid.render('defaultGrid');
            var defaultGridView = defaultGrid.getView();

            /* 조회 */
            fnSearch = function() {

                dataSet.load({
                    url: '<c:url value="/stat/prj/retrievePrjRsstStatList.do"/>',
                    params :{
                        yyyy : document.aform.yyyy.value
                    }
                });
            };

            dataSet.on('load', function(e) {
                   $("#cnt_text").html('총 ' + dataSet.getCount() + '건');
               // 목록 페이징
                   paging(dataSet,"defaultGrid");
                 });

            downloadExcel = function() {
                // 엑셀 다운로드시 전체 다운로드를 위해 추가
                dataSet.clearFilter();
                var excelColumnModel = new Rui.ui.grid.LColumnModel({
                    gridView: defaultGridView,
                        columns: [
                            { field: 'deptNm',          label: '조직명',           sortable: false,  align:'center', width: 250 }
                            , { field: 'prjNm',         label: '프로젝트명',       sortable: false,  align:'left', width: 250 }
                            , { field: 'plEmpName',     label: 'PL',             sortable: false,  align:'center', width: 60 }
                            , { field: 'prjCpsn',          label: '팀원',             sortable: false,  align:'right', width: 50
                                , renderer: function(value, p, record, row, col){
                                    if( value != '' && value != null && value != 'undefined' ){
                                        return value + '명'
                                    }else{
                                        return '0명'
                                    }
                                }
                              }
                            , { id : 'Monthly Report'}
                            , { field: 'pduGoalCnt',    groupId: 'Monthly Report', label: '계획',     sortable: false,  align:'center', width: 55
                                , renderer: function(value, p, record, row, col){
                                    var arslCnt = record.get('arslCnt');    // 실적

                                    if( value != '' && value != null && value != 'undefined' ){
                                        return value + '건'
                                    }
                                    // 실적이 존재하면 0건으로 화면표시
                                    else if( arslCnt != '' && arslCnt != null && arslCnt != 'undefined' ){
                                        return '0건'
                                    }
                                }
                              }
                            , { field: 'arslCnt',          groupId: 'Monthly Report', label: '실적',   sortable: false,  align:'center', width: 55
                                , renderer: function(value, p, record, row, col){
                                    var pduGoalCnt = record.get('pduGoalCnt');    // 목표

                                    if( value != '' && value != null && value != 'undefined' ){
                                        return value + '건'
                                    }
                                    // 목표가 존재하면 0건으로 화면표시
                                    else if( pduGoalCnt != '' && pduGoalCnt != null && pduGoalCnt != 'undefined' ){
                                        return '0건'
                                    }
                                }
                              }
                            , { id : '지적재산권 (국내)'}
                            , { field: 'prptGoalCnt',   groupId: '지적재산권 (국내)' ,label: '계획',    sortable: false,  align:'center', width: 55
                                , renderer: function(value, p, record, row, col){
                                    var prptArslCnt = record.get('prptArslCnt');    // 실적

                                    if( value != '' && value != null && value != 'undefined' ){
                                        return value + '건';
                                    }
                                    // 실적이 존재하면 0건으로 화면표시
                                    else if( prptArslCnt != '' && prptArslCnt != null && prptArslCnt != 'undefined' ){
                                        return '0건';
                                    }
                                }
                              }
                            , { field: 'prptArslCnt',   groupId: '지적재산권 (국내)' ,label: '실적',    sortable: false,  align:'center', width: 55
                                , renderer: function(value, p, record, row, col){
                                    var prptGoalCnt = record.get('prptGoalCnt');    // 계획

                                    if( value != '' && value != null && value != 'undefined' ){
                                        return value + '건';
                                    }
                                    // 계획이 존재하면 0건으로 화면표시
                                    else if( prptGoalCnt != '' && prptGoalCnt != null && prptGoalCnt != 'undefined' ){
                                        return '0건';
                                    }
                                }
                              }
                            , { field: 'ttm',            label: 'TTM(%)(개발완료)',              sortable: false,  align:'center', width: 90
                                , renderer: function(value, p, record, row, col){
                                    if( value != '' && value != null && value != 'undefined' ){
                                        return value + '%';
                                    }
                                }
                              }
                            , { field: 'tssBudg',         label: '예산(억원)',             sortable: false,  align:'right',  width: 70 }
                            , { field: 'tssExp',          label: '비용(억원)',             sortable: false,  align:'right',  width: 70 }
                            , { field: 'tssExe',        label: '집행율(%)',               sortable: false,  align:'center', width: 70
                                , renderer: function(value, p, record, row, col){
                                    if( value != '' && value != null && value != 'undefined' ){
                                        return value + '%';
                                    }else if( value == 0){
                                        return value + '%';
                                    }
                                }
                              }
                        ]
                });

                var excelColumnModel = excelColumnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('통계_프로젝트') + new Date().format('%Y%m%d') + '.xls',{
                    columnModel: excelColumnModel
                });
             // 목록 페이징
                paging(dataSet,"defaultGrid");

            };

            fnSearch();

        });

    </script>
    </head>
<body>
    <form name="aform" id="aform" method="post">

        <div class="contents">

            <div class="">
                <div class="titleArea">
                    <a class="leftCon" href="#"><img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control"><span class="hidden">Toggle 버튼</span></a>
                    <h2>프로젝트 통계리스트</h2>
                </div>
                <div class="sub-content">
                    <div class="search">
                        <div class="search-content">
                            <!-- <table class="searchBox"> -->
                            <table>
                                <colgroup>
                                    <col style="width: 120px;" />
                                    <col style="" />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th align="right">연도</th>
                                        <td>
                                            <c:set var="now" value="<%=new java.util.Date()%>"/>
                                            <fmt:formatDate var="nowYear" value="${now}" pattern="yyyy"/>
                                            <select id="yyyy" name="yyyy">
                                                <!-- <option value="">선택하세요</option> -->
                                                <c:forEach var="year" begin="2009" end="${nowYear+1}">
                                                    <option value="${year}" ${yyyy eq year ? 'selected': ''}>${year}</option>
                                                </c:forEach>
                                            </select>
                                            <a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="titArea">
                        <span class="Ltotal" id="cnt_text">총  0건 </span><span class="sub-tit md20">조회연도가 '현재년도' 인 경우 '팀원'항목은 현재원 기준으로 조회됩니다.</span>
                        <div class="LblockButton">
                            <button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadExcel()">Excel</button>
                        </div>
                    </div>

                    <div id="defaultGrid"></div>
                </div>
            </div><!-- //sub-content -->
        </div><!-- //contents -->
    </form>
</body>
</html>