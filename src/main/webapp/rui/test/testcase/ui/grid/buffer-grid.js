Ext.require([
    'Ext.grid.*',
    'Ext.data.*',
    'Ext.util.*',
    'Ext.grid.plugin.BufferedRenderer'
]);

Ext.define('Employee', {
    extend: 'Ext.data.Model',
    fields: [
        { name: 'col1' },
        { name: 'col2' },
        { name: 'col3' },
        { name: 'col4' },
        { name: 'col5' },
        { name: 'col6' }
    ],
    idField: 'employeeNo'
});
    var startTime = null;
    var endTime = null;

Ext.onReady(function() {
    
    // Create the Data Store.
    // Because it is buffered, the automatic load will be directed
    // through the prefetch mechanism, and be read through the page cache
    var store = Ext.create('Ext.data.JsonStore', {
        model: 'Employee'
    });
    
    var showLogEl = Ext.get('showLog');
    
    store.on('load', function(e) {
        endTime = new Date();
        var html = 'time average : ' + (endTime.getTime() - startTime.getTime()) + 'ms<br>';
        showLogEl.dom.innerHTML = html;
    });
    
    var jumpToRow = function(){
        var fld = grid.down('#gotoLine');
        if (fld.isValid()) {
            grid.view.bufferedRenderer.scrollTo(fld.getValue() - 1, true);
        }    
    };
    
    var data = [],
        perBatch = 1000,
        max = 5000;

    var grid = Ext.create('Ext.grid.Panel', {
        width: 700,
        height: 500,
        title: 'Buffered Grid of 5,000 random records',
        store: store,
        loadMask: true,
        plugins: 'bufferedrenderer',
        selModel: {
            pruneRemoved: false
        },
        viewConfig: {
            trackOver: false
        },
        features: [{
            ftype: 'groupingsummary',
            groupHeaderTpl: 'Department: {name}',
            showSummaryRow: false
        }],
        // grid columns
        columns:[{
            xtype: 'rownumberer',
            width: 40,
            sortable: false
        },
        { text: 'col1', dataIndex: 'col1' },
        { text: 'col2', dataIndex: 'col2' },
        { text: 'col3', dataIndex: 'col3' },
        { text: 'col4', dataIndex: 'col4' },
        { text: 'col5', dataIndex: 'col5' },
        { text: 'col6', dataIndex: 'col6' }
        ],
        bbar: [{
            labelWidth: 80,
            fieldLabel: 'Jump to row',
            xtype: 'numberfield',
            minValue: 1,
            maxValue: max,
            allowDecimals: false,
            itemId: 'gotoLine',
            enableKeyEvents: true,
            listeners: {
                specialkey: function(field, e){
                    if (e.getKey() === e.ENTER) {
                        jumpToRow();
                    }
                }
            }
        }, {
            text: 'Go',
            handler: jumpToRow
        }],
        renderTo: Ext.getBody()
    });
    
    Ext.get('search1000Btn').on('click', function(e) {
        startTime = new Date();
        store.load({
            url: '/test/ext-4.2.1.883/examples/grid/buffer-grid1000.json'
        });
    });
    
    Ext.get('search10000Btn').on('click', function(e) {
        startTime = new Date();
        store.load({
            url: '/test/ext-4.2.1.883/examples/grid/buffer-grid10000.json'
        });
    });
    
    Ext.get('search100000Btn').on('click', function(e) {
        startTime = new Date();
        store.load({
            url: '/test/ext-4.2.1.883/examples/grid/buffer-grid100000.json'
        });
    });
});