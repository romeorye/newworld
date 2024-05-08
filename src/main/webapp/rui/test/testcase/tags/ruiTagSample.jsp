<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="rui" uri="/WEB-INF/tags/rui.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="devon-rui-sample" content="yes" />
    <meta name="devon-rui-keyword" content="콤보(LCombo), 리스트(List)" />
    <title>Json Custom Tag</title>

    <script type="text/javascript" src="./../../../js/rui_base.js"></script>
    <script type="text/javascript" src="./../../../js/rui_core.js"></script>
    <script type="text/javascript" src="./../../../js/rui_ui.js"></script>
    <script type="text/javascript" src="./../../../js/rui_form.js"></script>
    <script type="text/javascript" src="./../../../js/rui_grid.js"></script>
    <script type="text/javascript" src="./../../../resources/rui_config.js"></script>
    <link rel="stylesheet" type="text/css" href="./../../../resources/rui.css"/>

    <script type="text/javascript" src="./../../../sample/general/rui_sample.js"></script>
    
    <script type="text/javascript" class="script-code">
        Rui.onReady(function(){
            var combo1 = new Rui.ui.form.LCombo({
                applyTo: 'combo1',
                displayField: 'name',
                defaultValue: 'code1',
                /*<b>*/
                items: <rui:json executeClass="sample.devframework.bridge.rui.tags.SampleExecute" params="col1=aaa&col2=bbb"/>
                /*</b>*/
            });

            var combo2 = new Rui.ui.form.LCombo({
                applyTo: 'combo2',
                displayField: 'name',
                defaultValue: 'code3'
            });

            var dataSet = combo2.getDataSet();
            /*<b>*/
            dataSet.loadData(<rui:ruijson executeClass="sample.devframework.bridge.rui.tags.SampleExecute" params="col1=aaa&col2=bbb"/>[0]);
            /*</b>*/

            var combo3 = new Rui.ui.form.LCombo({
                applyTo: 'combo3'
            });
        });
    </script>
    
    
</head>
<body>
    <h1>Json Custom Tag</h1>
    <h2>Ajax를 이용하지 않고 서버에서 업무를 구현한 데이터를 Custom Tag로 생성하여 데이터를 구성한다.</h2>
    <div class="LblockLine"></div>
    <div class="LblockDesc">
        <p>기본적으로 Ajax는 Cost가 높은 작업이므로 불필요한 ajax 처리 보다는 서버 개발 기술인 Custom Tag를 이용하면 보다 성능이 높은 시스템을 개발할 수 있다.</p>
    </div>
    <div id="bd">
        <div class="LblockMarkupCode">
            <fieldset>
            <p>아래의 데이터는 단순한 json형 array를 변환해주는 샘플이다.</p>
            <code>
		      <rui:json executeClass="sample.devframework.bridge.rui.tags.SampleExecute" params="col1=aaa&col2=bbb"/>
		    </code>
		    <p>※ 위의 데이터로 combo1의 데이터를 생성했다.</p>
		    <div id="combo1"></div>
		
		    <br><br><br>
		    <code>
		      <rui:ruijson executeClass="sample.devframework.bridge.rui.tags.SampleExecute" params="col1=aaa&col2=bbb"/>
		    </code>
            <p>※ 위의 데이터로 combo2의 DataSet을 얻어와서 loadData 메소드로 데이터를 생성했다.</p>
            <div id="combo2"></div>
		
		    <br><br><br>
		    <p>※ Html select태그의 option 데이터를 생성했다.</p>
		    <select id="combo3" name="combo1">
		        <option value="" class="empty">선택하세요.</option>
		        <rui:options executeClass="sample.devframework.bridge.rui.tags.SampleExecute" params="col1=aaa&col2=bbb" selected="code5" displayField="name"/>
		    </select>
		    </fieldset>
		</div>
    </div>
</body>
</html>