<%@ page language="java" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<title>Converter To Rui</title>
<script type="text/javascript" src="./../../js/rui_base.js"></script>
<script type="text/javascript" src="./../../js/rui_core.js"></script>
<script type="text/javascript" src="./../../js/rui_ui.js"></script>
<script type="text/javascript" src="./../../js/rui_form.js"></script>
<script type="text/javascript" src="./../../js/rui_grid.js"></script>
<script type="text/javascript" src="./../../resources/rui_config.js"></script>
<script type="text/javascript" src="./../../resources/rui_license.js"></script>
<link rel="stylesheet" type="text/css" href="./../../resources/rui.css"/>

<script type="text/javascript" src="./../../plugins/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="./../../plugins/tab/rui_tab.css" />

<style type="text/css">
ul {
    list-style-type: none;
    padding: 0;
}

#scriptData {
    width: 99%;
    border: 1px solid #000;
}
</style>

<script type="text/javascript">
Rui.onReady(function() {
    var tabView = new Rui.ui.tab.LTabView();
    
    tabView.render('tab-container');
    var jsonText;
    
    var dataSet = new Rui.data.LJsonDataSet({
        id:'dataSet',
        fields:[
            { id: 'colId' },
            { id: 'colField' },
            { id: 'colLabel' },
            { id: 'colType', defaultValue: 'string' },
            { id: 'colWidth' },
            { id: 'colSortable' },
            { id: 'colAlign' },
            { id: 'colEditor' }
        ]
    });
    
    var typeCombo = new Rui.ui.form.LCombo( { useEmptyText: false } );
    typeCombo.getDataSet().loadData({
        records: [
            { value: 'string', text: 'string' },
            { value: 'number', text: 'number' },
            { value: 'date', text: 'date' },
        ]
    });
    
    var columnModel = new Rui.ui.grid.LColumnModel({
        columns: [
            new Rui.ui.grid.LStateColumn(),
            new Rui.ui.grid.LSelectionColumn(),
            new Rui.ui.grid.LNumberColumn(),
                { field: 'colId',           label: 'Id', editor: new Rui.ui.form.LTextBox() },
                { field: 'colField',           label: 'Field', editor: new Rui.ui.form.LTextBox() },
                { field: 'colLabel',           label: 'Lebel', editor: new Rui.ui.form.LTextBox() },
                { field: 'colType',           label: 'Type', editor: typeCombo, renderer: function(val) {
                    if(val == undefined) val = 'string';
                    return val;
                } },
                { field: 'colWidth',           label: 'Width', editor: new Rui.ui.form.LTextBox() },
                { field: 'colSortable',           label: 'Sortable', editor: new Rui.ui.form.LTextBox() },
                { field: 'colAlign',           label: 'Align', editor: new Rui.ui.form.LTextBox() },
                { field: 'colEditor',           label: 'Editor', editor: new Rui.ui.form.LTextBox() }
            ]
    });

    var grid = new Rui.ui.grid.LGridPanel({
        columnModel: columnModel,
        width: 700,
        height: 300,
        autoWidth: true,
        dataSet: dataSet
    });

    grid.render('grid');
    
    var gauceConverter = function(gauceHtml) {
        dataSet.clearData();
        gauceHtml = gauceHtml.replace(/<fc/gi, '<c');
        gauceHtml = gauceHtml.replace(/<\/fc/gi, '</c');
        gauceHtml = gauceHtml.replace(/<c/gi, '<c');
        gauceHtml = gauceHtml.replace(/<\/c/gi, '</c');
        var rowDatas = gauceHtml.trim().split('<c>');
        for(var i = 0 ; i < rowDatas.length; i++) {
            var rowData = rowDatas[i];
            if(rowData.length < 1) continue;
            rowData = rowData.trim();
            rowData = rowData.substring(0, rowData.length - 4);
            
            var isServerValue = false, j = 0, sPos = -1;
            while(key && rowData && (j = rowData.indexOf("\<\%", j+1)) > 0) {
                if(j > 0 && key) {
                    sPos = rowData.indexOf(key + "=", key.length + j - 1);
                    var ePos = rowData.indexOf("\%\>", sPos);
                    if(ePos > 0) {
                        value = rowData.substring(sPos + key.length + 2, ePos + 2);
                        
                        debugger;
                    }
                }
            }

            
            
            var columnDatas = rowData.split('=');
            var data1 = { colType: 'string' };
            var beforeKey = '';
            var key, value = '';
            for(var j = 0 ; j < columnDatas.length; j++) {
                var columnData = columnDatas[j];
                columnData = columnData.trim();
                if(j == 0) {
                    beforeKey = columnData.toLowerCase();
                    continue;
                }
                
                if(columnData.indexOf("\<\%") > 0) 
                	continue;
                sPos = columnData.lastIndexOf(' ');
                if(columnData.length - 2 == j)
                    key = null;
                else {
                    key = columnData.substring(sPos);
                    key = key.trim().toLowerCase();
                }
                value = '';
                value = columnData.substring(0, sPos).trim();
                if(j == columnDatas.length - 1)
                    value = columnData;
                
                if(value.indexOf("\%\>") > 0) {
                	value = "\<\%= " + value;
                }
                value = value.replace(/,/g, '');
                if(value.startsWith("\"")) value = value.substring(1);
                if(value.endsWith("\"")) value = value.substring(0, value.length - 1);
                if(beforeKey == 'id') {
                    data1.colId = value;
                    data1.colField = value;
                    data1.colLabel = value;
                    data1.colType = getType(data1.colId);
                } else if (beforeKey == 'name') {
               		value = Rui.util.LString.simpleReplace(value, '"', '');
                    data1.colLabel = Rui.util.LString.replaceHtml(value);
                } else if (beforeKey == 'width') {
                    data1.colWidth = value;
                } else if (beforeKey == 'edit') {
                    data1.colEditor = Rui.util.LString.simpleReplace(value.toLowerCase(), '"', '');
                } else if (beforeKey == 'sort') {
                    data1.colSortable = value.toLowerCase();
                } else if (beforeKey == 'align') {
                	if(value.length > 6) value = 'left';
                    data1.colAlign = value.toLowerCase();
                } else if (beforeKey == 'editstyle') {
                    data1.colEditor = value.toLowerCase();
                }
                beforeKey = (key) ? key.toLowerCase() : null;
                
            }
            if(!data1.colId)
                continue;
            var row = dataSet.add(dataSet.createRecord(data1));
            dataSet.setMark(row, true);
        }
        dataSet.commit();
    };

    var urlConverter = function(value, index) {
        index = index || 0;
        jsonText = value;
        try {
            var datas = Rui.util.LJson.decode(value);
            if(index > datas.length-1){
                index = datas.length-1;
            }
            var obj = datas[index];
            if(obj.records.length) {
                var rowData = obj.records[0];
                for(m in rowData) {
                    var v = rowData[m];
                    var data1 = { colType: 'string' };
                    data1.colId = m;
                    data1.colField = m;
                    data1.colLabel = m;
                    if(typeof v == 'number') {
                        data1.colType = 'number';
                    } else {
                        data1.colType = getType(data1.colId);
                    }
                    if(v && typeof(v) === 'string' && v.length > 30)
                        data1.colAlign = 'right';

                    if(v && typeof(v) === 'string')
                        data1.colEditor = getEditor(m);

                    var row = dataSet.add(dataSet.createRecord(data1));
                    dataSet.setMark(row, true);
                }
            }
            dataSet.commit();
        } catch(e1) {
            alert('알 수 없는 데이터가 리턴되었습니다. : ' + value);
            throw e1;
        }
    };
    
    var toHtml = function(html){
        html = Rui.util.LString.simpleReplace(html, '&lt;', '<');
        html = Rui.util.LString.simpleReplace(html, '&gt;', '>');
        return html;
    };
    
    var createScript = function() {
        var value = '';
        var dataSetTemplate = new Rui.LTemplate('\t{ id: \'{colId}\'');
        var dsScript = 'LDataSet field script \r\nfields:[\r\n';
        var cnt = dataSet.getCount();
        for(var i = 0 ; i < cnt; i++) {
            if(dataSet.isMarked(i) == false) continue;
            var obj = dataSet.getAt(i).getValues();
            dsScript += dataSetTemplate.apply(obj);
            if(obj.colType) {
                if(obj.colType == 'number') {
                    dsScript += ', type: \'number\', defaultValue: 0';
                } else if(obj.colType == 'date' ) {
                    dsScript += ', type: \'date\', defaultValue: new Date()';
                }
            }
            dsScript += ' }';
            if(i !== cnt - 1)
                dsScript += ',';
            dsScript += '\r\n';
        }
        dsScript += ']\r\n\r\n\r\n';
        value += dsScript;
        
        var comboList = [];
        
        var gridScript = 'LColumnModel field script \r\ncolumns:[\r\n\tnew Rui.ui.grid.LStateColumn(),\r\n';
        for(var i = 0 ; i < cnt; i++) {
            if(dataSet.isMarked(i) == false) continue;
            var obj = dataSet.getAt(i).getValues();
            try {
/*              if(obj.colId == 'choice') {
                    gridScript += '\tnew Rui.ui.grid.LSelectionColumn(),\r\n';
                    continue;
                }
*/
                gridScript += '\t{ field: \'' + obj.colId + '\'';
                
                if(!obj.colLabel) obj.colLabel = obj.colId;
                gridScript += ', label: \'' + toHtml(obj.colLabel) + '\'';
                
                if(obj.colWidth) {
                    gridScript += ', width: ' + obj.colWidth;
                }

                if(obj.colSortable) {
                    gridScript += ', sortable: ' + obj.colSortable;
                }

                if(obj.colAlign) {
                    if(obj.colType == 'number') {
                        gridScript += ', align: \'right\'';
                    } else if(obj.colType == 'date') {
                        gridScript += ', align: \'center\'';
                    } else {
                        if(obj.colAlign.toLowerCase() != 'left')
                              gridScript += ', align: \'' + obj.colAlign.toLowerCase() + '\'';
                    }
                }

                if(obj.colEditor) {
                    if(obj.colEditor.toLowerCase() != 'none') {
                        if(obj.colEditor.toLowerCase() == 'lookup') {
                            gridScript += ', editor: new Rui.ui.form.LCombo({ useEmptyText: false, optionsData: [ { value: \'Y\' }, { value: \'N\' } ] })';
                        } else if(obj.colEditor.toLowerCase() == 'combo') {
                            gridScript += ', editor: cb' + obj.colId.firstUpperCase();
                        } else if(obj.colEditor.toLowerCase() == 'checkbox') {
                            gridScript += ', editor: new Rui.ui.form.LCheckBox({ bindValues : [\'Y\', \'N\'] })';
                        } else {
                            if(obj.colType == 'number') {
                                gridScript += ', editor: new Rui.ui.form.LNumberBox()';
                            } else if(obj.colType == 'date') {
                                gridScript += ', editor: new Rui.ui.form.LDateBox()';
                            } else {
                                gridScript += ', editor: new Rui.ui.form.LTextBox()';
                            }
                        }
                        comboList.push(obj.colId);
                    }
                } else {
                    if(obj.colId.endsWith('Yn')) 
                        gridScript += ', editor: new Rui.ui.form.LCombo({ useEmptyText: false, optionsData: [ { value: \'Y\' }, { value: \'N\' } ] })';
                    else if(obj.colType == 'number') {
                        gridScript += ', editor: new Rui.ui.form.LNumberBox()';
                    } else if(obj.colType == 'date') {
                        gridScript += ', editor: new Rui.ui.form.LDateBox()';
                    } else {
                        gridScript += ', editor: new Rui.ui.form.LTextBox()';
                    }
                }

                gridScript += ' }';
                if(i !== cnt - 1)
                    gridScript += ',';
                gridScript += '\r\n'
            } catch(e) {
                alert('error : ' + Rui.dump(obj));
            }
        }
        gridScript += ']\r\n\r\n\r\n';
        value += gridScript;

        var comboTemplate = new Rui.LTemplate('var cb{colId} = new Rui.ui.form.LCombo({\r\n',
                '\tuseEmptyText: false,\r\n',
                '\tid: \'cb{colId}\'\r\n',
            '});');
        var comboScript = '';
        for(var i = 0 ; i < comboList.length; i++) {
            comboScript += comboTemplate.apply({ colId: comboList[i].firstUpperCase() });
            comboScript += '\r\n\r\n\r\n';
        }
        
        value += comboScript;

        var validatorTemplate = new Rui.LTemplate('\t{ id: \'{colId}\', validExp: \'{colLabel}:true\' }');
        var validateScript = 'LValidatorManager validators script \r\nvalidators:[\r\n';
        for(var i = 0 ; i < cnt; i++) {
            if(dataSet.isMarked(i) == false) continue;
            var obj = dataSet.getAt(i).getValues();
            obj.colLabel = toHtml(obj.colLabel);
            validateScript += validatorTemplate.apply(obj);
            if(i !== cnt - 1)
                validateScript += ',';
            validateScript += '\r\n';
        }
        validateScript += ']\r\n\r\n\r\n';
        value += validateScript;

        var bindTemplate = new Rui.LTemplate('\t{ id: \'{colId}\', ctrlId: \'{colId}\', value: \'value\' }');
        var bindScript = 'LBind bindInfo script \r\nbindInfo:[\r\n';
        for(var i = 0 ; i < cnt; i++) {
            if(dataSet.isMarked(i) == false) continue;
            var obj = dataSet.getAt(i).getValues();
            bindScript += bindTemplate.apply(obj);
            if(i !== cnt - 1)
                bindScript += ',';
            bindScript += '\r\n';
        }
        bindScript += ']\r\n\r\n\r\n';
        value += bindScript;
        
        // 필드 이름으로 공통코드 생성
        var commonScript = 'Commom script \r\n';
        for(var i = 0 ; i < cnt; i++) {
            if(dataSet.isMarked(i) == false) continue;
            var obj = dataSet.getAt(i).getValues();
            if(obj.colId == 'sysCd') {
                commonScript += '공통코드 생성\r\n';
            }
            commonScript += '\r\n';
        }
        commonScript += '\r\n\r\n\r\n';
        value += commonScript;
        Rui.get('scriptData').setValue(value);
    };

    // 필드 이름으로 type 규칙 생성
    var getType = function(id) {
        var type = 'string';
        if(id.endsWith('Amt') || id.endsWith('Qty') || id.endsWith('No') || id.endsWith('Seq')) {
            type = 'number';
        } else if(id.endsWith('Date') || id.endsWith('Dt') || id.toLowerCase().endsWith('ymd')) {
            type = 'date';
        }
        return type;
    };

 // 필드 이름으로 editor 규칙 생성
    var getEditor = function(id) {
        var colEditor;
        if(id.endsWith('Cd') || id.endsWith('Code') || id.toLowerCase() == 'code')
            colEditor = 'combo';
        return colEditor;
    }

    new Rui.ui.LButton('loadBtn').on('click', function() {
        dataSet.clearData();
        if(tabView.getActiveIndex() == 1) {
            var value = Rui.get('loadJsonData').getValue();
            if(!value){
                Rui.alert('JSON을 입력하세요.');
                Rui.get('loadJsonData').focus();
                return;
            }
            urlConverter(value);
            createScript();
        }else if(tabView.getActiveIndex() == 2) {
            var value = Rui.get('loadData').getValue();
            gauceConverter(value);
            createScript();
        } else {
            var loadUrl = Rui.get('loadUrl').getValue();
            if(loadUrl == '') {
                alert('Url을 입력하세요.');
                Rui.get('loadUrl').focus();
                return;
            }
            Rui.ajax({
                url: loadUrl,
                success: function(e) {
                    urlConverter(e.responseText);
                    createScript();
                },
                failure: function(e) {
                    alert('서버에서 데이터를 가져오는데 실패했습니다. : ' + e.message);
                }
            });
        }
    });

    new Rui.ui.LButton('loadAtBtn').on('click', function() {
        if(!jsonText){
            Rui.alert('load button을 먼저 실행하세요.');
            return;
        }
        Rui.prompt({
            text: 'DataSet의 index를 입력하세요.',
            handler: function(value) {
                dataSet.clearData();
                urlConverter(jsonText, value);
                createScript();
            }
        })
        
    });
    
    new Rui.ui.LButton('createBtn').on('click', function() {
        createScript();
    });

    new Rui.ui.LButton('clearBtn').on('click', function() {
        dataSet.clearData();
    });

    new Rui.ui.LButton('addBtn').on('click', function() {
        dataSet.newRecord();
    });

    new Rui.ui.LButton('add10Btn').on('click', function() {
        for(var i = 0 ; i < 10; i++) {
            dataSet.add(dataSet.createRecord({}));
        }
    });
    
    new Rui.ui.LButton('delBtn').on('click', function() {
        var row = dataSet.getRow();
        if(dataSet > -1)
            dataSet.removeAt(row);
    });
    
    new Rui.ui.LButton('undoAllBtn').on('click', function() {
        dataSet.undoAll();
    });
    
});
</script>
</head>

<body id="LblockBody">
<div id="LblockBodyMain">
    <div id="tab-container">
        <div title="Url To Rui">
            <div class="LblockSearch">
                <ul>
                    <li><input type="text" id="loadUrl" size="130" placeHolder="http://localhost:8080/test.rui" value="http://localhost:8080/"></li>
                </ul>
            </div><%-- LblockSearch --%>
        </div>
        <div title="JSON To Rui">
            <div class="LblockSearch">
                <ul>
                    <li><textarea rows="10" cols="165" id="loadJsonData"></textarea></li>
                </ul>
            </div><%-- LblockSearch --%>
        </div>
        <div title="Gauce To Rui">
            <div class="LblockSearch">
                <ul>
                    <li><textarea rows="10" cols="165" id="loadData"></textarea></li>
                </ul>
            </div><%-- LblockSearch --%>
        </div>
    </div>
    
    <div class="LblockButtons">
        <button type="button" id="loadBtn" >Load</button>
        <button type="button" id="loadAtBtn" >Load At</button>
        <button type="button" id="createBtn" >Create Script</button>
        <button type="button" id="clearBtn" >Clear</button>
        <button type="button" id="addBtn" >add</button>
        <button type="button" id="add10Btn" >add 10 rows</button>
        <button type="button" id="delBtn" >add</button>
        <button type="button" id="undoAllBtn" >undo All</button>
    </div>
    
    <div id="grid" class="LblockGrid"></div>
    
    <div id="LblockSearch">
        <ul>
            <li><textarea rows="50" cols="165" id="scriptData"></textarea></li>
        </ul>
    </div><%-- LblockSearch --%>
</div><!-- LblockMainBody -->

</body>
</html>
