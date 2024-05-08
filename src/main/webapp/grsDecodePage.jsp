<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title>Insert title here</title>

<script type="text/javascript">
	
	Rui.onReady(function() {
		/* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            fields: [
                  { id: 'chk'}        //과제코드
                , { id: 'tssCd'}        //과제코드
                , { id: 'tssCdSn'}       //사용자ID
                , { id: 'evTitl'}       //사용자ID
                , { id: 'commTxt'}        //과제상태
            ]
        });
		
        dataSet.on('load', function(e){
           
        });

        
        /* [Grid] 컬럼설정 */
        var columnModel = new Rui.ui.grid.LColumnModel({
        	columns: [
        	      new Rui.ui.grid.LSelectionColumn()
                 , { field: 'tssCd',        label: '과제TSSCD', sortable: true, align:'center', width: 120 }
                , { field: 'tssCdSn',   label: 'SEQ', sortable: true, align:'center', width: 50 }
                , { field: 'evTitl',     label: 'title', sortable: true, align:'center', width: 200 }
                , { field: 'commTxt',     label: 'comment', sortable: true, align:'center', width: 900 }
              ]  
              
        });

        /* [Grid] 패널설정 */
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet,
            width: 1210,
            height: 400,
			autoWidth: true,
        });

        grid.render('defaultGrid');
		
        
        /* [버튼] 조회 */
        fnSearch = function() {
        	dataSet.load({
                url: '<c:url value="/prj/grs/retrieveGrsDecodeList.do"/>'
            });
        };
        fnSearch();
		
        var fncChk = function(ds){
        	if(ds.getCount() > 0) {
        		for(var i=0; i < ds.getCount(); i++ ){
        			if( ds.isMarked(i) ){
        				ds.setNameValue(i, 'chk', '1');
	        		}
	        	}
        	}
        }
        
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        /* [버튼] 과제등록 */
        var butSave = new Rui.ui.LButton('butSave');
        butSave.on('click', function() {
        	dm.on('success', function(e) {
    			// 재조회
    			fnSearch();
    		});

        	dm.on('failure', function(e) {
    		});
        	
        	fncChk(dataSet);

        	dm.updateDataSet({
        		url:'<c:url value="/prj/grs/updateGrsDecode.do"/>',
                dataSets:[dataSet]
            }); 
        });
        
		
	});


</script>




</head>


<body>

<div class="contents">
        <div class="LblockButton">
			<button type="button" id="butSave" name="butSave">GRS저장</button>
  		</div>

    <div class="sub-content">
    	
		
		<div id="defaultGrid"></div>
					
	</div>
</div>


</body>
</html>