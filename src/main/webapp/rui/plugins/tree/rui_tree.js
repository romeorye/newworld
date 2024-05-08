/*
 * @(#) rui_tree.js
 * build version : 2.4 Release $Revision: 19574 $
 *  
 * Copyright ⓒ LG CNS, Inc. All rights reserved.
 *
 * devon@lgcns.com
 * http://www.dev-on.com
 *
 * Do Not Erase This Comment!!! (이 주석문을 지우지 말것)
 *
 * rui/license.txt를 반드시 읽어보고 사용하시기 바랍니다. License.txt파일은 절대로 삭제하시면 않됩니다. 
 *
 * 1. 사내 사용시 KAMS를 통해 요청하여 사용허가를 받으셔야 소프트웨어 라이센스 계약서에 동의하는 것으로 간주됩니다.
 * 2. DevOn RUI가 포함된 제품을 판매하실 경우에도 KAMS를 통해 요청하여 사용허가를 받으셔야 합니다.
 * 3. KAMS를 통해 사용허가를 받지 않은 경우 소프트웨어 라이센스 계약을 위반한 것으로 간주됩니다.
 * 4. 별도로 판매될 경우는 LGCNS의 소프트웨어 판매정책을 따릅니다. (KAMS에 문의 바랍니다.)
 *
 * (주의!) 원저자의 허락없이 재배포 할 수 없으며
 * LG CNS 외부로의 유출을 하여서는 안 된다.
 */
/**
 * @description LUnorderedList
 * @module ui
 * @namespace Rui.ui
 * @class LUnorderedList
 * @extends Rui.ui.LUIComponent
 * @constructor
 * @protected
 * @param {Object} oConfig The intial LUnorderedList.
 */
if(!Rui.ui.LUnorderedList){











Rui.ui.LUnorderedList = function(config){
    config = config || {};
    config = Rui.applyIf(config, Rui.getConfig().getFirst('$.ext.unorderedList.defaultProperties'));
    if(Rui.platform.isMobile) config.useAnimation = false;







    this.createEvent('nodeClick');








    this.createEvent('dynamicLoadChild');








    this.createEvent('focusChanged');







    this.createEvent('collapse');







    this.createEvent('expand');





    this.renderDataEvent = this.createEvent('renderData', {isCE:true});






    this.createEvent('syncDataSet');

    Rui.ui.LUnorderedList.superclass.constructor.call(this, config);
};

Rui.extend(Rui.ui.LUnorderedList, Rui.ui.LUIComponent, {






    otype: 'Rui.ui.LUnorderedList',











    dataSet: null,












    renderer: null,





    endDepth: null,





    currentFocus: null,






    lastFocusId: undefined,











    focusLastest: true,







    prevFocusNode: null,












    childDataSet: null,












    hasChildValue: 1,












    defaultOpenDepth: -1,













    defaultOpenTopIndex: -1,













    onlyOneTopOpen: false,













    useTooltip: false,

















    ulData: [],







    lastNodeInfos: undefined,












    useAnimation: false,






    animDuration: 0.3,












    syncDataSet: true,






    liWidth: null,






    container: null,













    autoMark: true,













    contextMenu: null,















    useTempId: false,






    DATASET_EVENT_LOCK: {
        ADD: false,
        UPDATE: false,
        REMOVE: false,
        ROW_POS_CHANGED: false,
        ROW_SELECT_MARK: false
    },






    accessibilityELRole: null,

    NODE_CONSTRUCTOR: 'Rui.ui.LUnorderedListNode',
    CSS_BASE: 'L-ul',
    CLASS_UL_FIRST: 'L-ul-first',
    CLASS_UL_DEPTH: 'L-ul-depth',
    CLASS_UL_HAS_CHILD_CLOSE_MID: 'L-ul-has-child-close-mid',
    CLASS_UL_HAS_CHILD_CLOSE_LAST: 'L-ul-has-child-close-last',
    CLASS_UL_HAS_CHILD_OPEN_MID: 'L-ul-has-child-open-mid',
    CLASS_UL_HAS_CHILD_OPEN_LAST: 'L-ul-has-child-open-last',
    CLASS_UL_HAS_NO_CHILD_MID: 'L-ul-has-no-child-mid',
    CLASS_UL_HAS_NO_CHILD_LAST: 'L-ul-has-no-child-last',
    CLASS_UL_NODE: 'L-ul-node',
    CLASS_UL_LI: 'L-ul-li',
    CLASS_UL_LI_DEPTH: 'L-ul-li-depth',
    CLASS_UL_LI_INDEX: 'L-ul-li-index',
    CLASS_UL_LI_DIV_DEPTH: 'L-ul-li-div-depth',
    CLASS_UL_LI_LINE: 'L-ul-li-line',
    CLASS_UL_LI_SELECTED: 'L-ul-li-selected',
    CLASS_UL_FOCUS_TOP_NODE: 'L-ul-focus-top-node',
    CLASS_UL_FOCUS_PARENT_NODE: 'L-ul-focus-parent-node',
    CLASS_UL_FOCUS_NODE: 'L-ul-focus-node',
    CLASS_UL_MARKED_NODE: 'L-ul-marked-node',









    _setSyncDataSet: function(type, args, obj) {
        var isSync = args[0];

        this.dataSet.unOn('beforeLoad', this.doBeforeLoad, this);
        this.dataSet.unOn('load', this.onLoadDataSet, this);
        this.dataSet.unOn('add', this.onAddData, this);
        this.dataSet.unOn('dataChanged', this.onChangeData, this);
        this.dataSet.unOn('update', this.onUpdateData, this);
        this.dataSet.unOn('remove', this.onRemoveData, this);
        this.dataSet.unOn('undo', this.onUndoData, this);
        this.dataSet.unOn('rowPosChanged', this.onRowPosChangedData, this);
        this.dataSet.unOn('marked', this.onMarked, this);

        if(isSync === true) {
            this.dataSet.on('beforeLoad', this.doBeforeLoad, this, true, {system: true});
            this.dataSet.on('load', this.onLoadDataSet, this, true, {system: true});
            this.dataSet.on('add', this.onAddData, this, true, {system: true});
            this.dataSet.on('dataChanged', this.onChangeData, this, true, {system: true});
            this.dataSet.on('update', this.onUpdateData, this, true, {system: true});
            this.dataSet.on('remove', this.onRemoveData, this, true, {system: true});
            this.dataSet.on('undo', this.onUndoData, this, true, {system: true});
            this.dataSet.on('rowPosChanged', this.onRowPosChangedData, this, true, {system: true});
            this.dataSet.on('marked', this.onMarked, this, true, {system: true});
        }
        this.syncDataSet = isSync;
        this.fireEvent('syncDataSet', {
            target: this,
            isSync: isSync
        });
    },







    setSyncDataSet: function(isSync) {
        this.cfg.setProperty('syncDataSet', isSync);
        if(isSync) this.doRenderData();
    },






    NODE_STATE: {
        HAS_CHILD: 0,
        HAS_NO_CHILD: 1,
        MID: 2,
        LAST: 3,
        OPEN: 4,
        CLOSE: 5,
        MARK: 6,
        UNMARK: 7,
        FOCUS: 8,
        UNFOCUS: 9,
        FOCUS_TOP: 10,
        FOCUS_PARENT: 11,
        UNFOCUS_PARENT: 12
    },






    initEvents: function(){
        Rui.ui.LUnorderedList.superclass.initEvents.call(this);

        this._setSyncDataSet('syncDataSet', [this.syncDataSet]);
        if (this.childDataSet != null)
            this.childDataSet.on('load', this.onLoadChildDataSet, this, true, {system: true});
        this.on('expand', this.onExpand, this, true);

        if (this.contextMenu)
            this.contextMenu.on('triggerContextMenu', this.onTriggerContextMenu, this, true);

        this.on('dynamicLoadChild', this.onDynamicLoadChild, this, true);
    },






    initDefaultConfig: function() {
        Rui.ui.LUnorderedList.superclass.initDefaultConfig.call(this);
        this.cfg.addProperty('syncDataSet', {
                handler: this._setSyncDataSet,
                value: this.syncDataSet,
                validator: Rui.isBoolean
        });
    },






    createTemplate: function() {
        var ts = this.templates || {};
        if (!ts.master) {
            ts.master = new Rui.LTemplate('<ul class="{cssUlFirst} {cssUlDepth}" {accRole}>{li}</ul>');
        }

        if (!ts.li) {
            ts.li = new Rui.LTemplate(
                '<li class="{cssUlLiIndex} {cssUlLiDepth} {cssUlLiOthers}" style="{style}" {accRole}>',
                '<div class="{cssUlNode} {cssUlLiDivDepth} {cssNodeState} {cssUlNodeId} {cssMark}"' + (this.useTooltip ? 'title="{content}"' : '' ) + '>{content}</div>',
                '{childUl}',
                '</li>'
            );
        }
        this.templates = ts;
    },









    getUlHtml: function(parentId, depth, nodeInfos){
        var ts = this.templates || {};
        var nodes = '';
        if (this.endDepth === null || depth <= this.endDepth) {
            //render될때와 dynamic으로 생성될 때 두번 사용됨.  nodeInfos가 들어오면 dynamic add child, 안들어오면 render
            nodeInfos = nodeInfos ? nodeInfos : this.getChildNodeInfos(parentId);
            var nodeInfosLength = nodeInfos ? nodeInfos.length : 0;
            depth = !Rui.isEmpty(depth) ? depth + 1 : 0;

            if (nodeInfosLength > 0) {
                var liNodes = '';
                for (var i = 0; i < nodeInfosLength; i++) {
                    liNodes += this.getLiHtml(nodeInfos[i], depth, (nodeInfosLength - 1 == i ? true : false), i);
                }
                var aRole = this.getAccessibilityUlRole(depth);
                nodes = ts.master.apply({
                    cssUlFirst: (depth == 0 ? this.CLASS_UL_FIRST : ''),
                    cssUlDepth: this.CLASS_UL_DEPTH + '-' + depth,
                    accRole: (Rui.useAccessibility() && aRole ? 'role="'+aRole+'"' : ''),
                    li: liNodes
                });
            }
        }
        return nodes;
    },









    getLiHtml: function(nodeInfo, depth, isLast, index){
        depth = Rui.isEmpty(depth) ? 0 : depth;
        if(Rui.isEmpty(index)){
            var nodeInfos = nodeInfos ? nodeInfos : this.getChildNodeInfos(this.fields.rootValue);
            index = Rui.isEmpty(index) ? nodeInfos.length : index;
        }

        var ts = this.templates || {},
            record = this.getRecordByNodeInfo(nodeInfo),
            hasChild = nodeInfo.hasChild,
            cssNodeState = this.getNodeStateClass(hasChild, isLast),
            cssLine = ((this.defaultOpenDepth >= depth && isLast !== true) ? this.CLASS_UL_LI_LINE : ''),
            isMarked = this.isMarked(record),
            cssMarked = isMarked ? ' ' + this.CLASS_UL_MARKED_NODE : '',
            cssSelected = ((this.defaultOpenDepth >= depth && isLast !== true) ? this.CLASS_UL_LI_SELECTED : ''),
            width = this.liWidth ? 'width:' + this.liWidth + 'px;' : '',
            childUl = cssUlLiOthers = '';

        if(record.dataSet.remainRemoved !== true && record.state === Rui.data.LRecord.STATE_DELETE) return '';

        if(this.defaultOpenDepth >= depth) {
            var childNodeInfos = this.getChildNodeInfos(record.get(this.fields.id));
            childUl += this.getUlHtml(record.get(this.fields.id), depth, childNodeInfos, isLast);
            cssNodeState = hasChild ? (isLast ? this.CLASS_UL_HAS_CHILD_OPEN_LAST : this.CLASS_UL_HAS_CHILD_OPEN_MID) : this.CLASS_UL_HAS_NO_CHILD_LAST;
        }

        cssUlLiOthers = isLast ? this.CLASS_UL_LI + '-last' : (index == 0 ? this.CLASS_UL_LI + '-first' : '');
        if(record.state != Rui.data.LRecord.STATE_NORMAL) cssUlLiOthers += ' L-node-state-' + this.getState(record);

         var aRole = this.getAccessibilityLiRole();
         var content = this.getContent(record, cssNodeState, isMarked);
         var html = ts.li.apply({
             cssUlLiIndex: this.CLASS_UL_LI_INDEX + '-' + (index !== undefined ? index : ''),
             cssUlLiDepth: this.CLASS_UL_LI_DEPTH + '-' + depth + (cssLine ? ' ' + cssLine : ''),
             cssUlLiOthers: cssUlLiOthers,
             style: width,
             cssUlNode: this.CLASS_UL_NODE,
             cssUlLiDivDepth: this.CLASS_UL_LI_DIV_DEPTH + '-' + depth,
             cssNodeState: cssNodeState,
             cssUlNodeId: this.CLASS_UL_NODE + '-' + record.id,
             cssMark: cssMarked,
             accRole: (Rui.useAccessibility() && aRole ? 'role="'+aRole+'"' : ''),
             content: content,
             title: content,
             childUl: childUl
         });

         return html;
    },







    getAccessibilityUlRole: function(depth){
        return null;
    },






    getAccessibilityLiRole: function(){
        return null;
    },








    getNodeStateClass: function(hasChild, isLast){
        var cssNodeState = '';
        if (hasChild)
            cssNodeState = isLast ? this.CLASS_UL_HAS_CHILD_CLOSE_LAST : this.CLASS_UL_HAS_CHILD_CLOSE_MID;
        else
            cssNodeState = isLast ? this.CLASS_UL_HAS_NO_CHILD_LAST : this.CLASS_UL_HAS_NO_CHILD_MID;
        return cssNodeState;
    },








    getContent: function(record, cssNodeState, isMarked){
        return this.getLabel(record, cssNodeState);
    },








    getLabel: function(record, cssNodeState){
        var label = record.get(this.fields.label);
        label = label ? label : '&nbsp;';
        label = this.renderer ? this.renderer(label, record, cssNodeState) : label;
        return label;
    },







    isMarked: function(record){
        return this.dataSet.isMarked(this.dataSet.indexOfKey(record.id));
    },










    getChildNodeInfos: function(parentId, dataSet, parentDoms, refresh){
        //방금 사용한 cache 사용.
        var nodeInfos;
        if (parentId !== undefined) {
            nodeInfos = !refresh && this.lastNodeInfos && this.lastNodeInfos.parentId === parentId ? this.lastNodeInfos.nodeInfos : [];
            if (nodeInfos.length == 0) {
                nodeInfos = !parentDoms ? this.getChildNodeInfosByDataSet(parentId, dataSet) : this.getChildNodeInfosByDom(parentDoms, refresh);
                this.lastNodeInfos = {
                    parentId: parentId,
                    nodeInfos: nodeInfos
                };
            }
        }
        return nodeInfos;
    },








    getChildNodeInfosByDataSet: function(parentId, dataSet){
        var nodeInfos = new Array();
        if(parentId === this.fields.rootValue){
            this.ulData = [];
            nodeInfos = this.ulData;
        }
        var records = this.getChildRecords(parentId,dataSet);
        //호환성 코딩
        if (this.fields.setRootFirstChild === true && !this.rootChanged && parentId === this.fields.rootValue && records.length > 0) {
            //rootValue 변경
            this.rootChanged = true;
            this.tempRootValue = records[0].get(this.fields.id);
            records = this.getChildRecords(this.tempRootValue);
        }
        for (var i = 0; i < records.length; i++)
            nodeInfos.push(this.getNodeInfoByRecord(records[i]));
        return nodeInfos;
    },








    getRootValue: function(){
        return this.fields.setRootFirstChild === true ? this.tempRootValue : this.fields.rootValue;
    },








    getChildRecords: function(parentId, dataSet){
        var records = new Array();
        if (parentId !== undefined) {
            dataSet = dataSet ? dataSet : this.dataSet;
            parentId = parentId === undefined ? this.fields.rootValue : parentId;
            var rowCount = dataSet.getCount();
            var record = null;
            for (var i = 0; i < rowCount; i++) {
                record = dataSet.getAt(i);
                if (record.get(this.fields.parentId) === parentId)
                    records.push(record);
            }
            records = this.fields.order ? this.getSortedRecords(records) : records;
        }
        return records;
    },







    getSortedRecords: function(records){
        //1. order.idx 문자열값을 가지는 array를 record 수만큼 만든다.
        var sort_order_idx = new Array();
        var order;
        for (var i = 0; i < records.length; i++) {
            order = records[i].get(this.fields.order);
            sort_order_idx.push((order ? order : 10000000000) + '.' + i.toString());
        }
        //2. array를 order field를 기준으로 sort한다.
        sort_order_idx.sort(function(x, y){
            return x - y;
        });
        //3. sort한 순서대로 record array를 새로 만든다.
        var sorted_records = new Array();
        var idx = -1;
        var cur = -1;
        var s = null;
        for (var i = 0; i < sort_order_idx.length; i++) {
            s = sort_order_idx[i].split('.');
            idx = parseInt(s[1]);
            cur = parseInt(s[0]);
            sorted_records.push(records[idx]);
            prev = cur;
        }
        return sorted_records;
    },



















    getChildNodeInfosByDom: function(parentDoms,refresh){
        var nodeInfo = this.getNodeInfo(parentDoms);
        nodeInfo.children = (nodeInfo.hasChild && nodeInfo.children.length == 0) || refresh ? this.findChildNodeInfos(nodeInfo, parentDoms[0], refresh) : nodeInfo.children;
        if(refresh) nodeInfo.hasChild = nodeInfo.children.length > 0 ? this.hasChildValue : false;
        return nodeInfo.children;
    },







    getNodeInfo: function(parentDoms){
        var searchSuccess = true;
        //nodeInfo의 children정보도 있어야 한다.
        //찾아 내려 가면서 NodeInfo가 없으면 만들어 내려간다.
        var nodeInfos = this.ulData;
        searchSuccess = parentDoms ? true : false;
        if (searchSuccess) {
            for (var i = parentDoms.length - 1; i >= 0; i--) {
                //nodeInfos에 dom에 해당하는 nodeInfo가 있는지 검사, nodeInfos가 없으면 dom에서 추출한다.
                nodeInfo = this.findNodeInfo(nodeInfos, parentDoms[i]);
                //현재 dom에 대해 nodeInfo가 있으면 nodeInfos에 children을 넘기고 다음 자식 dom을 검사한다.
                if (nodeInfo)
                    nodeInfos = nodeInfo.children;
                else {
                    searchSuccess = false;
                    break;
                }
            }
        }
        return searchSuccess ? nodeInfo : false;
    },







    findNodeInfo: function(nodeInfos,dom){
        //nodeInfos는 ulData의 참조이다.  유지해야 한다.
        nodeInfos = nodeInfos.length == 0 ? this.getNodeInfos(this.getUL(dom)) : nodeInfos;
        return this.checkHasNode(nodeInfos,dom);
    },







    getNodeInfos: function(ul){
        var nodeInfos = new Array();
        var liCount = ul.childNodes.length;
        for(var i=0;i<liCount;i++)
            nodeInfos.push(this.getNodeInfoByDom(ul.childNodes[i].firstChild,i));
        return nodeInfos.length > 0 ? nodeInfos : false;
    },









    findChildNodeInfos: function(nodeInfo,dom,refresh){
        var nodeInfos = [];
        var ul = this.getChildUL(dom);
        if(ul && !refresh){
            nodeInfos = this.getNodeInfos(ul);
        } else {
            var record = this.getRecordByNodeInfo(nodeInfo);
            if(record) nodeInfos = this.getChildNodeInfosByDataSet(record.get(this.fields.id));
        }
        return nodeInfos;
    },








    checkHasNode: function(nodeInfos,dom){
        var nodeInfo = null;
        if (nodeInfos) {
            var recordId = this.getRecordId(dom);
            for (var j = 0; j < nodeInfos.length; j++) {
                if (nodeInfos[j].id == recordId) {
                    nodeInfo = nodeInfos[j];
                    break;
                }
            }
        }
        return nodeInfo ? nodeInfo : false;
    },







    checkHasChild: function(record){
        var hasChild = 0;
        if (this.fields.hasChild) {
            hasChild = record.get(this.fields.hasChild);
        }
        else {
            var parentId = record.get(this.fields.id);
            if (parentId !== undefined) {
                var rowCount = this.dataSet.getCount();
                for (var i = 0; i < rowCount; i++) {
                    if (this.dataSet.getAt(i).get(this.fields.parentId) === parentId) {
                        hasChild = this.hasChildValue;
                        break;
                    }
                }
            }
        }
        return hasChild;
    },







    checkHasChildByDom: function(dom){
        //dom에 없으면 record를 검사한다.
        return this.getChildUL(dom) ? true : this.checkHasChild(this.dataSet.get(this.getRecordId(dom)));
    },







    getNodeInfoByRecord: function(record){
        return {id:record.id,hasChild:this.checkHasChild(record),order:record.get(this.fields.order),children:[]};
    },








    getNodeInfoByDom: function(dom,idx){
        return {id:this.getRecordId(dom),hasChild:this.checkHasChildByDom(dom),order:idx,children:[]};
    },







    getRecordByNodeInfo: function(nodeInfo){
        return this.dataSet.get(nodeInfo.id);
    },







    htmlToDom: function(html){
        //html문자열을 dom으로 return
        var div = document.createElement('div');
        div.innerHTML = html;
        return div.childNodes[0];
    },








    markChilds: function (isMarked, record) {
        if (this.autoMark) {
            //한 depth만 표시한다.  재귀루프를 돌기 때문, findNode를 실패할 경우 더이상 진행하지 않게 하기위해 flag둠
            var records = this.getChildRecords(record.get(this.fields.id));
            for (var i = 0; i < records.length; i++)
                this.dataSet.setMark(this.dataSet.indexOfKey(records[i].id), isMarked);
        }
        this.onRecordMarking = false;
    },







    doRender: function(container){
        this.createTemplate();
        this.el.addClass(this.CSS_BASE);
        this.el.addClass('L-fixed');

        Rui.util.LEvent.removeListener(this.el.dom, 'mousedown', this.onCheckFocus);
        Rui.util.LEvent.addListener(this.el.dom, 'mousedown', this.onCheckFocus, this, true);

        if(Rui.useAccessibility() && this.accessibilityELRole)
            this.el.setAttribute('role', this.accessibilityELRole);

        this.doRenderData();
        this.container = container;

        this._rendered = true;
    },







    afterRender: function(container){
        Rui.ui.LUnorderedList.superclass.afterRender.call(this, container);
        this.el.unOn('click', this.onNodeClick, this);
        this.el.on('click', this.onNodeClick, this, true);

        this.unOn('dynamicLoadChild', this.onDynamicLoadChild, this, true);
        this.on('dynamicLoadChild', this.onDynamicLoadChild, this, true);
    },






    initDefaultFocus: function(){
        if (!this.lastFocusId && this.defaultOpenTopIndex > -1)
            this.openFirstDepthNode(this.defaultOpenTopIndex);
        else {
            //이전에 마지막에 선택된 행이 있으면 setRow한다.
            if (!this.setFocusLastest())
                this.refocusNode(this.dataSet.getRow());
        }
    },






    doRenderData: function(){
        if(!this.el) return;
        this.prevFocusNode = undefined;
        this.currentFocus = undefined;
        this.lastNodeInfos = undefined;
        this.rootChanged = false;
        this.el.html(this.getUlHtml(this.fields.rootValue));
        var firstLiEls = this.el.select('li.L-ul-li-depth-0');
        if(firstLiEls && firstLiEls.length){
            firstLiEls.getAt(0).setAttribute('tabindex', '0');
        }
        this.initDefaultFocus();
        this.renderDataEvent.fire();
    },








    onNodeClick: function(e){
        var node = this.findNodeByDom(e.target);
        if (node) {
            var r = this.fireEvent('nodeClick', {
                target: this,
                node: node,
                dom: e.target
            });
            if(r !== false){
                if(node !== this.currentFocus)
                    this.dataSet.setRow(node.getRow());
                this.toggleChild(node);
            }
        }
    },







    toggleChild: function(node){
        node.toggleChild();
    },







    focusNode: function(row){
        //focusing이 가능한지 판단
        if (!this.isPossibleNodeRecord(this.dataSet.getAt(row))) return false;
        if(this.currentFocus && this.currentFocus.getRow() === row) return false;
        //현재 dom에서 node를 찾는다.
        var nextFocusingNode = row >= 0 ? this.findNode(this.dataSet.getAt(row).id) : false;
        //없으면 node를 만들어가면서 찾는다.
        nextFocusingNode = !nextFocusingNode && row > -1 ? this.buildNodes(row) : nextFocusingNode;
        if (this.currentFocus) this.currentFocus.unfocus();
        this.prevFocusNode = this.currentFocus;
        this.currentFocus = nextFocusingNode;
        this.lastFocusId = this.currentFocus ? this.currentFocus.getIdValue() : undefined;
        if (this.currentFocus) {
            this.currentFocus.focus();
            this.el.moveScroll(this.currentFocus.el, false, true);
        }
        this.fireEvent('focusChanged', {
            target: this,
            oldNode: this.prevFocusNode,
            newNode: this.currentFocus
        });
        return this.currentFocus;
    },








    refocusNode: function(row,ignoreCanRowPos){
        ignoreCanRowPos = ignoreCanRowPos == true ? true : false;
        var currentRow = this.dataSet.getRow();
        if(currentRow == row)
            this.focusNode(row);
        else
            this.dataSet.setRow(row,{ignoreCanRowPosChangeEvent: ignoreCanRowPos});
    },







    isPossibleNodeRecord: function(record){
        return record === undefined || record.get(this.fields.parentId) === undefined ? false : true;
    },







    getLastLi: function(ulDom){
        return ulDom.childNodes && ulDom.childNodes.length > 0 ? ulDom.childNodes[ulDom.childNodes.length - 1] : false;
    },








    getLi: function(ulDom,index){
        return index < ulDom.childNodes.length ? ulDom.childNodes[index] : false;
    },







    getUL: function (dom) {
        return dom.parentNode.parentNode;
    },








    getChildUL: function (dom) {
        //next sibling이 ul이면 자식이 있는 것.
        var n_node = Rui.util.LDom.getNextSibling(dom);
        //1은 element, ul
        return n_node && n_node.nodeType == 1 && n_node.tagName.toLowerCase() == 'ul' ? n_node : false;
    },








    findNode: function(recordId, dom, deleted){
        if(!deleted && !this.isPossibleNodeRecord(this.dataSet.get(recordId))) return false;
        var el = dom ? Rui.get(dom) : this.el,
            els = el.select('div.' + this.CLASS_UL_NODE + '-' + recordId,true);
        el = els.getAt(0);
        return el && els.length > 0 ? this.getNodeObject(el.dom) : false;
    },







    buildNodes: function(row){
        var node = false;
        if (row > -1 && this.isPossibleNodeRecord(this.dataSet.getAt(row))) {
            var parentRecords = this.getParentRecords(row);
            //위에서 내려오면서 만들기
            var dom = this.el;
            for (var i = parentRecords.length - 1; i >= 0; i--) {
                node = this.findNode(parentRecords[i].id, dom);
                if (node && i !== 0) {
                    node.expand();
                    dom = node.getChildUL();
                } else break;
            }
        }
        return node;
    },







    findNodeByDom: function(dom){
        var nodeDom = Rui.util.LDom.findParent(dom, 'div.' + this.CLASS_UL_NODE, 10);
        return this.getNodeObject(nodeDom);
    },







    getFirstDepthNode: function(index){
        var rootUL = this.getRootUL();
        return rootUL ? this.getNodeObject(this.getLi(rootUL.dom,index)) : false;
    },







    openFirstDepthNode: function(index){
        if (index > -1) {
            var node = this.getFirstDepthNode(index);
            if (node) {
                this.dataSet.setRow(node.getRow());
                if(this.currentFocus != null)
                    this.currentFocus.expand();
            }
        }
    },







    getNode: function(record){
        return this.findNode(record.id);
    },






    getNodeById: function(id) {
        var row = this.dataSet.findRow(this.fields.id, id);
        if(row < 0) return null;
        var r = this.dataSet.getAt(row);
        return this.getNode(r);
    },







    getNodeObject: function(dom){
        if(dom){
            //반복 생성 방지.
            var recordId = this.getRecordId(dom);
            if (this.currentFocus && this.currentFocus.getRecordId() == recordId)
                return this.currentFocus;
            else
                return this.createNodeObject(dom);
        } else return null;
    },







    createNodeObject: function(dom){
        return new Rui.ui.LUnorderedListNode({
            unorderList: this,
            useAnimation: this.useAnimation,
            dom: dom
        });
    },







    createNode: function(config) {
        config = Rui.applyIf(config || {}, {
            unorderList: this,
            nodeConstructor: this.NODE_CONSTRUCTOR
        });
        return new eval(config.nodeConstructor + '.prototype.constructor')(config);
    },





    getFocusNode: function(){
        return this.currentFocus;
    },






    getFocusLastest: function(){
        return this.getFocusNode();
    },






    getRootUL: function(){
        var els = this.el.select('.' + this.CLASS_UL_FIRST,true);
        return els.length > 0 ? els.getAt(0) : false;
    },







    getParentRecord: function(record){
        if(!this.isPossibleNodeRecord(record)) return false;
        var row = this.dataSet.findRow(this.fields.id, record.get(this.fields.parentId));
        return row > -1 ? this.dataSet.getAt(row) : false;
    },







    getParentRecords: function(row){
        var parentRecords = new Array();
        if (row > -1) {
            var record = this.dataSet.getAt(row);
            parentRecords.push(record);
            var parentId;
            for (var i = 0; i < 1000; i++) {
                parentId = record.get(this.fields.parentId);
                if (parentId === this.fields.rootValue)
                    break;
                else {
                    record = this.getParentRecord(record);
                    if (record)
                        parentRecords.push(record);
                    else
                        break;
                }
            }
        }
        return parentRecords;
    },







    getParentId: function(dom){
        return this.dataSet.get(this.getRecordId(dom)).get(this.fields.id);
    },







    getRecordId: function(dom){
        dom = dom.tagName.toLowerCase() == 'li' ? dom.firstChild : dom;
        return Rui.util.LDom.findStringInClassName(dom, this.CLASS_UL_NODE + '-');
    },







    getNodeLabel: function(node){
        node = node ? node : this.currentFocus;
        return node ? this.dataSet.get(node.getRecordId()).get(this.fields.label) : '';
    },






    setFocusLastest: function(){
        return (this.focusLastest && this.lastFocusId !== undefined && this.dataSet) ? this.setFocusById(this.lastFocusId) : false;
    },






    setFocusById : function(id){
        if (id !== undefined) {
            var idx = this.dataSet.findRow(this.fields.id, id);
            if (idx === this.dataSet.getRow())
                return false;
            else {
                this.dataSet.setRow(idx);
                return true;
            };
        }
    },






    setRootValue : function(rootValue){
        this.fields.rootValue = rootValue;
        this.doRenderData();
    },
    doBeforeLoad: function(e) {
        this.showLoadingMessage();
    },






    onLoadDataSet: function(e){
        this.doRenderData();
        this.hideLoadingMessage();
    },






    showLoadingMessage: function(){
        if(!this.el) return;
        this.el.mask();
    },






    hideLoadingMessage: function() {
        if(!this.el) return;
        this.el.unmask();
    },






    onMarked: function(e){
        //e.target, e.row, e.isSelect, e.record
        var node = !this.onRecordMarking ? this.findNode(e.record.id) : false;
        if (node) {
            if(e.isSelect) node.mark(); else node.unmark();
        } else {
            this.onRecordMarking = true;
            this.markChilds(e.isSelect, e.record);
        }
    },






    onExpand: function(e){
        var currentFocus = e.node;
        if(currentFocus && currentFocus.getParentId() == e.target.getIdValue()){
            this.el.moveScroll(currentFocus.el, false, true);
        }
    },






    setDataSet: function(dataSet) {
        this.setSyncDataSet(false);
        this.dataSet = dataSet;
        this.setSyncDataSet(true);
    },








    getAllChildRecords: function(parentId, dataSet, rs){
        rs = rs ? rs : new Array();
        if (parentId !== undefined) {
            dataSet = dataSet ? dataSet : this.dataSet;
            var rowCount = dataSet.getCount();
            var r = null;
            for (var i = 0; i < rowCount; i++) {
                r = dataSet.getAt(i);
                if (r.get(this.fields.parentId) === parentId) {
                    rs.push(r);
                    this.getAllChildRecords(r.get(this.fields.id), dataSet, rs);
                }
            }
        }
        return rs;
    },










    getAllChildRecordsClone: function(parentId, dataSet, initIdValue){
        return this.getCloneRecords(this.getAllChildRecords(parentId, dataSet),initIdValue);
    },







    getCloneRecords: function(records,initIdValue){
        var cloneRecords = new Array();
        var record;
        for (var i = 0; i < records.length; i++) {
            record = records[i].clone();
            if(initIdValue) this.initIdValue(record,{ignoreEvent: true});
            cloneRecords.push(record);
        }
        return cloneRecords;
    },







    onTriggerContextMenu: function(e){
        var node = this.findNodeByDom(this.contextMenu.contextEventTarget);
        if (!node)
            this.contextMenu.cancel(false);
        else
            this.refocusNode(node.getRow());
    },







    onDynamicLoadChild: function(e){
    },








    setNodeLabel: function(label,node){
        //data값을 변경하면 event에 의해서 변경된다.
        node = node ? node : this.currentFocus;
        if(node) this.dataSet.get(node.getRecordId()).set(this.fields.label,label);
    },








    initIdValue: function(record, option){
        var fieldValue = undefined;
        if (this.useTempId) {
            var field = record.findField(this.fields.id);
            var today = new Date;
            //중복 제거를 위해 붙임.
            var recordId = parseInt(Rui.util.LString.simpleReplace(record.id, 'r', ''), 10);
            switch (field.type) {
                case 'number':
                    fieldValue = today.getTime() + recordId;
                    break;
                case 'date':
                    fieldValue = Rui.util.LDate.add(today, Rui.util.LDate.MILLISECOND, recordId);
                    break;
                case 'string':
                    fieldValue = '' + today.getTime() + '' + recordId;
                    break;
            }
        }
        record.set(this.fields.id,fieldValue,option);
        return fieldValue;
    },







    addTopNode: function(label,row){
        return this.addChildNode(label, true, row);
    },








    addChildNode: function(label, addTop, row){
        var parentId = addTop === true ? this.getRootValue() : (this.currentFocus ? this.currentFocus.getIdValue() : this.getRootValue());
        var record;
        if (typeof parentId !== 'undefined') {
            if (typeof row === 'undefined') {
                this.DATASET_EVENT_LOCK.ADD = true;
                this.DATASET_EVENT_LOCK.ROW_POS_CHANGED = true;
                //onAddData와 rowPosChanged가 동시에 발생
                row = this.dataSet.newRecord();
                this.DATASET_EVENT_LOCK.ROW_POS_CHANGED = false;
                this.DATASET_EVENT_LOCK.ADD = false;
            }
            record = this.dataSet.getAt(row);
            this.DATASET_EVENT_LOCK.UPDATE = true;
            this.initIdValue(record);
            record.set(this.fields.label, label);
            this.DATASET_EVENT_LOCK.UPDATE = false;
            record.set(this.fields.parentId, parentId);
            this.refocusNode(row);
        } else {
            //throw new Rui.LException('부모의 id가 없음.  tempId를 사용하려면 config.useTempId:true로 설정.  이 경우 create된 record는 id 또는 parentId가 temp값임');
            alert('부모의 id가 없음.  신규 추가한 node에 id가 있어야 자식을 추가할 수 있음. \r\ntempId를 사용하려면 config.useTempId:true로 설정.  \r\n이 경우 create된 record는 id 또는 parentId가 temp값이므로 DB업데이트시 주의요망');
        }
        return row;
    },








    addChildNodeHtml: function(record, addTop, parentNode){
        var nodeInfos = [this.getNodeInfoByRecord(record)];
        parentNode = parentNode ? parentNode : this.currentFocus;
        if (!addTop && parentNode) {
            //record가 추가 되었으므로 다시 그린다.
            parentNode.open(true);
        }
        else {
            var rootUL = this.getRootUL();
            if (!rootUL) {
                //root에 하나도 없을때
                this.el.html(this.getUlHtml(undefined, null, nodeInfos));
            } else {
                //마지막 li를 mid로 변환
                var node = this.getNodeObject(this.getLastLi(rootUL.dom));
                node.changeStateTo(this.NODE_STATE.MID);
                rootUL.appendChild(this.htmlToDom(this.getLiHtml(nodeInfos[0], null, true)));
            }
            //root cache에도 추가한다.
            this.ulData.push(nodeInfos[0]);
        }
    },








    concatArray: function(origin,adding){
        for(var i=0;i<adding.length;i++){
            origin.push(adding[i]);
        }
    },








    redrawParent: function(parentId,focusChildRow,isDelete){
        isDelete = isDelete == true ? true : false;
        if (parentId !== undefined) {
            if (parentId !== this.getRootValue()) {
                var parentRow = this.dataSet.findRow(this.fields.id, parentId);
                //행이동을 하지 않고 다시 그리기
                this.focusNode(parentRow);
                if (this.currentFocus)
                    this.currentFocus.open(true);
                if (focusChildRow === undefined)
                    this.dataSet.setRow(parentRow, {ignoreCanRowPosChangeEvent: isDelete});
                else
                    this.refocusNode(focusChildRow,isDelete);
            }
            else
                this.doRenderData();
        }
    },









    deleteRecord: function(record,clone,childOnly){
        //자식 삭제를 위해 목록 가져오기, record index가 높은것 부터 삭제.
        var rs = new Array();
        //childOnly면 자신은 뺀다.
        if(!childOnly) rs.push(record);
        this.concatArray(rs,this.getAllChildRecords(record.get(this.fields.id)));
        var cloneRecords = clone ? this.getCloneRecords(rs) : undefined;
        //이동처리할 필요가 없다. 밑에서 부터 삭제한다.
        this.DATASET_EVENT_LOCK.ROW_POS_CHANGED = true;
        for (var i=rs.length-1;i>-1;i--) {
            this.DATASET_EVENT_LOCK.REMOVE = true;
            this.dataSet.removeAt(this.dataSet.indexOfKey(rs[i].id));
            this.DATASET_EVENT_LOCK.REMOVE = false;
        }
        this.DATASET_EVENT_LOCK.ROW_POS_CHANGED = false;
        return cloneRecords;
    },










    deleteNode: function(node,clone,childOnly,parentId){
        node = node ? node : this.currentFocus;
        if(node){
            var record = node.getRecord();
            var rsClone;
            if (record) {
                parentId = record.get(this.fields.parentId);
                rsClone = this.deleteRecord(record, clone, childOnly);
            }
            if (parentId !== this.getRootValue())
                this.redrawParent(parentId,undefined,true);
            else {
                var siblingLi = node.getPreviousLi();
                siblingLi = siblingLi ? siblingLi : node.getNextLi();
                var siblingNode = siblingLi ? this.getNodeObject(siblingLi) : null;
                this.removeNodeDom(node);
                if (siblingNode)
                    this.dataSet.setRow(siblingNode.getRow(),{ignoreCanRowPosChangeEvent: true});
            }
            return rsClone;
        }
    },






    cutNode: function(node){
        node = node ? node : this.currentFocus;
        this.deletedRecords = node ? this.deleteNode(node,true) : null;
    },







    copyNode: function(withChilds, node){
        node = node ? node : this.currentFocus;
        this.copiedRecordId = node ? node.getRecordId() : null;
        this.copyWithChilds = withChilds == undefined || withChilds == null || !this.useTempId ? false : withChilds;
    },






    pasteNode: function(parentNode){
        parentNode = parentNode ? parentNode : this.currentFocus;
        if (parentNode) {
            if (this.copiedRecordId) {
                var record = this.dataSet.get(this.copiedRecordId);
                //id도 새로 만들어야 한다.
                //펼치고, 마지막 자식의 order seq + 1해서 update한다.
                var newOrder = this.getMaxOrder(parentNode.getIdValue());
                if (!this.copyWithChilds) {
                    var cloneR = record.clone();
                    this.DATASET_EVENT_LOCK.ADD = true;
                    cloneR.setState(Rui.data.LRecord.STATE_INSERT);
                    this.dataSet.add(cloneR);
                    this.initIdValue(cloneR,{ignoreEvent: true});
                    cloneR.set(this.fields.parentId, parentNode.getIdValue(), {
                        ignoreEvent: true
                    });
                    if (this.fields.hasChild) {
                        cloneR.set(this.fields.hasChild, null, {
                            ignoreEvent: true
                        });
                    }
                    if(this.fields.order){
                       cloneR.set(this.fields.order, newOrder + 1, {
                            ignoreEvent: true
                        });
                    }
                    this.DATASET_EVENT_LOCK.ADD = false;
                }
                else {
                    //this.useTempId === true일 경우만 작동
                    var rsClone = new Array();
                    rsClone.push(record.clone());
                    this.concatArray(rsClone,this.getAllChildRecordsClone(record.get(this.fields.id)),true);
                    this.DATASET_EVENT_LOCK.ADD = true;
                    for (var i = 0; i < rsClone.length; i++) {
                        rsClone[i].setState(Rui.data.LRecord.STATE_INSERT);
                        this.dataSet.add(rsClone[i]);
                        this.initIdValue(rsClone[0],{ignoreEvent: true});
                        rsClone[0].set(this.fields.parentId, parentNode.getIdValue(), {
                            ignoreEvent: true
                        });
                        if(this.fields.order){
                           rsClone[0].set(this.fields.order, newOrder + 1, {
                                ignoreEvent: true
                            });
                        }
                    }
                    this.DATASET_EVENT_LOCK.ADD = false;
                }
                //복사된 node중 최상위 node만 dom을 만들면 된다.
                parentNode.open(true);
            }
            else
                if (this.deletedRecords) {
                    this.DATASET_EVENT_LOCK.ADD = true;
                    for (var i = 0; i < this.deletedRecords.length; i++) {
                        this.deletedRecords[i].setState(Rui.data.LRecord.STATE_INSERT);
                        this.dataSet.add(this.deletedRecords[i]);
                        this.deletedRecords[0].set(this.fields.parentId, parentNode.getIdValue(), {
                            ignoreEvent: true
                        });
                    }
                    this.DATASET_EVENT_LOCK.ADD = false;
                    //복사된 node중 최상위 node만 dom을 만들면 된다.
                    parentNode.open(true);
                }
        }
         this.copiedRecordId = null;
         this.copyWithChilds = null;
         this.deletedRecords = null;
    },







    getMaxOrder: function(parentId){
        var maxOrder = -1;
        if (this.fields.order) {
            var rowCount = this.dataSet.getCount();
            var record;
            for (var i = 0; i < rowCount; i++) {
                record = this.dataSet.getAt(i);
                if (record.get(this.fields.parentId) === parentId) {
                    maxOrder = maxOrder < record.get(this.fields.order) ? record.get(this.fields.order) : maxOrder;
                }
            }
        }
        return maxOrder;
    },







    removeNodeDom: function(node){
        node = node ? node : this.currentFocus;
        if (node) {
            var ulEl = Rui.get(node.getUL());
            var liCount = ulEl.select('> li').length;
            //Unique인지 검사, first & last parent no-child design
            if (liCount == 1) {
                if (node.getDepth() > 0) {
                    var pNode = this.getNodeObject(node.getParentLi());
                    pNode.changeStateTo(this.NODE_STATE.HAS_NO_CHILD);
                }
                //ul 삭제
                var ul = ulEl.dom;
                if (node === this.currentFocus) {
                    delete this.currentFocus;
                }
                delete node;
                delete ulEl;
                Rui.util.LDom.removeNode(ul);
            } else if(liCount > 1){
                //마지막인지 검사, previous sibling last design
                if (node.isLast()) {
                    var prevNode = this.getNodeObject(node.getPreviousLi());
                    if(prevNode) prevNode.changeStateTo(this.NODE_STATE.LAST);
                }
                 //li 삭제
                var li = node.getLi();
                if (node === this.currentFocus) delete this.currentFocus;
                delete node;
                Rui.util.LDom.removeNode(li);
            }
        }
    },






    onAddData: function(e){
        //data추가시 insert/new
        //e.target, e.record, e.row
        if (this.DATASET_EVENT_LOCK.ADD !== true) {
            if (this.isPossibleNodeRecord(e.record)) {
                //root에 추가
                if (e.record.get(this.fields.parentId) === this.getRootValue())
                    this.addChildNodeHtml(e.record, true);
                else {
                    var parentRecord = this.getParentRecord(e.record);
                    if (parentRecord) {
                        var node = this.findNode(parentRecord.id);//html dom에 없을 수도 있다.
                        //다시 그린다.
                        if (node)
                            node.open(true);
                    }
                }
            } else
                this.addTopNode(e.record.get(this.fields.label),e.row);
        }
    },






    onChangeData: function(e){
        this.doRenderData();
    },






    onUpdateData: function(e){
        if (this.DATASET_EVENT_LOCK.UPDATE !== true) {
            //e.target, e.record, e.row, e.col, e.rowId(recordId), e.colId(fieldId), e.value, e.orginValue
            //수정 대상은 부모 자식 관계, 그리고 label
            var node = this.findNode(e.record.id);//html dom에 없을 수도 있다.
            var row = this.dataSet.getRow();
            if (e.colId == this.fields.parentId) {
                //node가 있으면 삭제한다.
                if (node)
                    this.removeNodeDom(node);
                if (e.value === this.getRootValue())
                    this.addChildNodeHtml(e.record, true);
                else {
                    var parentRecord = this.getParentRecord(e.record);
                    var parentNode = parentRecord ? this.findNode(parentRecord.id) : undefined;
                    this.addChildNodeHtml(e.record, false, parentNode);
                }
                //focus해야할 node이면 focus를 준다.
                if (e.row === row)
                    this.focusNode(row);
            }
            else
                if (node && e.colId == this.fields.label)
                    node.syncLabel();
                else
                    if (this.fields.order && e.colId == this.fields.order) {
                        this.redrawParent(e.record.get(this.fields.parentId), e.row);
                    }
                    else
                        if (node && e.colId == this.fields.id)
                            if (e.row === row)
                                this.lastFocusId = e.value;
        }
    },






    onRemoveData: function(e){
        if (this.DATASET_EVENT_LOCK.REMOVE !== true) {
            var deleted = true;
            var node = this.findNode(e.record.id,undefined,deleted);
            if (node) this.deleteNode(node, false, true, e.record.get(this.fields.parentId));
            else this.deleteRecord(e.record,false,true);
        }
    },






    onUndoData: function(e){
        //방금 수정한것 취소시, 이전 부모가 삭제되었을 수도 있으므로 다시 그려준다.
        this.doRenderData();
    },






    clearDataSet: function(){
        this.doRenderData();
    },






    onRowPosChangedData: function(e){
        if (this.DATASET_EVENT_LOCK.ROW_POS_CHANGED !== true) {
            this.focusNode(e.row);
        }
    },






    onLoadChildDataSet: function(e){
        var records = new Array(),
            nodeInfos = new Array(),
            isParentMarked = false,
            record, row, i;
        if (this.currentFocus) {
        	if(this.autoMark)
        		isParentMarked = this.dataSet.isMarked(this.dataSet.indexOfKey(this.currentFocus.getRecordId()));
            //현재 id를 부모로 하는 record들만 가져옴
            records = this.getChildRecords(this.currentFocus.getIdValue(), this.childDataSet);
            if (records.length > 0) {
                this.DATASET_EVENT_LOCK.ADD = true;
                for (i = 0; i < records.length; i++) {
                    record = records[i].clone();
                    row = this.dataSet.add(record);
                    if(this.autoMark && isParentMarked) this.dataSet.setMark(row, true);
                    nodeInfos.push(this.getNodeInfoByRecord(record));
                }
                this.DATASET_EVENT_LOCK.ADD = false;
            }
            this.currentFocus.renderChild(nodeInfos);
        }
    },






    isRendered: function() {
        return this._rendered === true;
    },






    getState: function(record) {
        switch (record.state) {
            case Rui.data.LRecord.STATE_INSERT:
                return 'I';
                break;
            case Rui.data.LRecord.STATE_UPDATE:
                return 'U';
                break;
            case Rui.data.LRecord.STATE_DELETE:
                return 'D';
                break;
        }
        return '';
    },




    destroy: function () {
        this.prevFocusNode = null;
        this.currentFocus = null;
        this.childDataSet = null;
        this.dataSet = null;
        Rui.ui.LUnorderedList.superclass.destroy.call(this);
    }
});
}








if(!Rui.ui.LUnorderedListNode){










Rui.ui.LUnorderedListNode = function (config) {
    Rui.applyObject(this, config);
    this.init();
};
Rui.ui.LUnorderedListNode.prototype = {







    el: null,






    otype: 'Rui.ui.LUnorderedListNode',







    recordId: null,







    idValue: null,







    depth: null,







    dom: null,







    isLeaf: null,







    unorderList: null,







    NODE_STATE: null,












    useAnimation: false,












    useCollapseAllSibling: false,






    childULHeight: 0,






    init: function () {
        this.dom = this.dom.tagName.toLowerCase() == 'li' ? this.dom.firstChild : this.dom;
        this.el = Rui.get(this.dom);
        this.NODE_STATE = this.unorderList.NODE_STATE;
        this.recordId = this.unorderList.getRecordId(this.dom);
        var depth = Rui.util.LDom.findStringInClassName(this.dom, this.unorderList.CLASS_UL_LI_DIV_DEPTH + '-');
        this.depth = depth == 'null' ? false : parseInt(depth);
        this.initIsLeaf();
    },






    initIsLeaf: function () {
        var isLeaf = true;
        var record = this.unorderList.dataSet.get(this.recordId);
        //record가 삭제된 경우 pass
        if (record) {
            if (this.unorderList.fields.hasChild) {
                var hasChild = record.get(this.unorderList.fields.hasChild);
                if (this.unorderList.hasChildValue != null) {
                    hasChild = hasChild == this.unorderList.hasChildValue ? true : false;
                }
                isLeaf = hasChild ? false : true;
            }
            else {
                var parentId = record.get(this.unorderList.fields.id);
                var row_count = this.unorderList.dataSet.getCount();
                var r = null;
                for (var i = 0; i < row_count; i++) {
                    r = this.unorderList.dataSet.getAt(i);
                    if (r.get(this.unorderList.fields.parentId) === parentId) {
                        isLeaf = false;
                        break;
                    }
                }
            }
        }
        this.isLeaf = isLeaf;
    },







    getRecordId: function () {
        return this.recordId;
    },







    getParentId: function () {
        var record = this.getRecord();
        return record ? record.get(this.unorderList.fields.parentId) : undefined;
    },







    getParentNode: function(){
    	if(this.getDepth() > 0){
    		var parentDom = this.getParentDom();
    		if(parentDom)
    			return this.unorderList.createNodeObject(parentDom);
    	}
    	return false;
    },






    getIdValue: function () {
        var record = this.getRecord();
        this.idValue = record ? record.get(this.unorderList.fields.id) : undefined;
        return this.idValue;
    },







    getRecord: function () {
        return this.unorderList.dataSet.get(this.getRecordId());
    },







    getRow: function () {
        return this.unorderList.dataSet.indexOfKey(this.getRecordId());
    },






    getDepth: function () {
        return this.depth;
    },






    hasChild: function () {
        return !this.isLeaf;
    },







    isFocus: function () {
        return this.checkNodeState(this.NODE_STATE.FOCUS);
    },






    focus: function () {
        this.changeStateTo(this.NODE_STATE.FOCUS);
        if(this.isTop()) this.changeStateTo(this.NODE_STATE.FOCUS_TOP);
    },






    unfocus: function () {
        this.changeStateTo(this.NODE_STATE.UNFOCUS);
    },







    isMarked: function () {
        return this.checkNodeState(this.NODE_STATE.MARK);
    },







    mark: function () {
        this.changeStateTo(this.NODE_STATE.MARK);
        this.unorderList.markChilds(true, this.getRecord());
    },







    unmark: function () {
        this.changeStateTo(this.NODE_STATE.UNMARK);
        this.unorderList.markChilds(false, this.getRecord());
    },







    isLast: function () {
        return this.checkNodeState(this.NODE_STATE.last);
    },







    isTop: function(){
        return this.depth == 0 ? true : false;
    },







    isExpand: function () {
        return this.checkNodeState(this.NODE_STATE.OPEN);
    },







    isCollaps: function () {
        return this.checkNodeState(this.NODE_STATE.CLOSE);
    },







    open: function (refresh) {
        var nodeInfos = new Array();
        //지우고 다시 그린다.
        if(refresh) this.removeChildUL(undefined,refresh);
        //cache가 있으면 그것 사용
        nodeInfos = this.unorderList.getChildNodeInfos(this.getIdValue(), null, this.getParentDoms(), refresh);
        if (!refresh && nodeInfos.length == 0) {
             this.unorderList.fireEvent('dynamicLoadChild',{
                 target: this.unorderList,
                 node: this,
                 parentId: this.getIdValue()
             });
        } else {
            this.renderChild(nodeInfos,refresh);
        }
        if(this.useCollapseAllSibling || (this.getDepth() === 0 && this.unorderList.onlyOneTopOpen === true))
            this.collapseAllSibling();
    },








    renderChild: function(nodeInfos,refresh){
        if (nodeInfos.length > 0) {
            this.addChildNodes(nodeInfos,refresh);
            this.changeStateTo(this.NODE_STATE.OPEN);
        } else {
            //자식이 없다.
            this.changeStateTo(this.NODE_STATE.HAS_NO_CHILD);
        }
    },






    close: function () {
        this.changeStateTo(this.NODE_STATE.CLOSE);
        this.removeChildUL();
    },






    syncLabel: function () {
        //label을 record값과 sync
        this.el.html(this.unorderList.getContent(this.getRecord()));
    },






    toggleChild: function () {
        if (this.isExpand()) {
            this.close();
        } else if (this.isCollaps()) {
            this.open();
        }
    },







    expand: function(){
        if(this.isCollaps()) this.open();
    },







    collapse: function(){
        if(this.isExpand()) this.close();
    },








    collapseAllSibling: function(){
        var ul = this.getUL();
        for(var i=0;i<ul.childNodes.length;i++){
            if(ul.childNodes[i].firstChild !== this.dom)
                this.unorderList.getNodeObject(ul.childNodes[i]).collapse();
        }
    },






    getOrder : function(){
        if(this.unorderList.fields.order) return this.getRecord().get(this.unorderList.fields.order); else return null;
    },







    getChildUL: function (dom) {
        return this.unorderList.getChildUL(dom ? dom : this.dom);
    },






    getChildULHeight : function(){
        return this.childULHeight;
    },








    removeChildUL: function (dom,refresh) {
        var ul = this.getChildUL(dom);
        if (ul) {
            var li = this.getLi();
            if (!refresh && this.useAnimation && (this.useAnimation === true || this.useAnimation.collapse === true)) {
                li.style.overflow = 'hidden';
                var anim = new Rui.fx.LAnim({
                    el: ul,
                    attributes: {
                        height: {
                            to: 1
                        }
                    },
                    duration: this.unorderList.animDuration
                });
                var thisNode = this;
                anim.on('complete', function(){
                    li.removeChild(ul);
                    thisNode.unorderList.fireEvent('collapse', {
                        target: thisNode,
                        node: thisNode.unorderList.currentFocus
                    });
                    li.style.overflow = '';
                });
                anim.animate();
            }else{
                li.style.overflow = 'hidden';
                li.removeChild(ul);
                this.unorderList.fireEvent('collapse', {
                    target: this,
                    node: this.unorderList.currentFocus
                });
                li.style.overflow = '';
            }
        }
    },







    getUL: function (dom) {
        return this.unorderList.getUL(dom ? dom : this.dom);
    },






    getIndex: function(){
        var ul = this.getUL();
        var li = this.getLi();
        var index = -1;
        for(var i=0;i<ul.childNodes.length;i++){
            if(li === ul.childNodes[i]){
                index = i;
                break;
            }
        }
        return index;
    },







    getLi: function (dom) {
        dom = dom ? dom : this.dom;
        return dom.parentNode;
    },







    getParentLi: function (dom) {
        dom = dom ? dom : this.dom;
        var li = dom.parentNode.parentNode.parentNode;
        li = li && li.tagName && li.tagName.toLowerCase() == 'li' ? li : null;
        return li;
    },







    getPreviousLi: function (dom) {
        dom = dom ? dom : this.dom;
        var li = this.getLi(dom);
        return Rui.util.LDom.getPreviousSibling(li);
    },







    getNextLi: function (dom) {
        dom = dom ? dom : this.dom;
        var li = this.getLi(dom);
        return Rui.util.LDom.getNextSibling(li);
    },







    getNextDom: function(dom){
        dom = dom ? dom : this.dom;
        var li = this.getNextLi(dom);
        var div = null;
        if(li){
            div = li.firstChild;
            div = div && div.tagName && div.tagName.toLowerCase() == 'div' ? div : null;
        }
        return div;
    },







    getPreviousDom: function(dom){
        dom = dom ? dom : this.dom;
        var li = this.getPreviousLi(dom);
        var div = null;
        if(li){
            div = li.firstChild;
            div = div && div.tagName && div.tagName.toLowerCase() == 'div' ? div : null;
        }
        return div;
    },






    getLastChildDom: function () {
        var ul = this.getChildUL();
        if (ul) return ul.lastChild.firstChild; else return null;
    },






    getParentDom: function(dom){
        dom = dom ? dom : this.dom;
        var li = this.getParentLi(dom);
        var div = null;
        if(li){
            div = li.firstChild;
            div = div && div.tagName && div.tagName.toLowerCase() == 'div' ? div : null;
        }
        return div;
    },







    getParentDoms: function(exceptCurrent){
        var parentDoms = new Array();
        var dom = this.dom;

        if(exceptCurrent !== true) parentDoms.push(dom);
        for(var i=0;i<100;i++){
            dom = this.getParentDom(dom);
            if(dom) parentDoms.push(dom); else break;
        }
        return parentDoms;
    },








    addChildNodes: function (nodeInfos,refresh) {
        if (nodeInfos && nodeInfos.length > 0) {
            //add unique child, 부모 state 변경해야 한다.
            this.changeStateTo(this.NODE_STATE.HAS_CHILD);
            this.isLeaf = false;
            var ulDom = this.unorderList.htmlToDom(this.unorderList.getUlHtml(null, this.depth, nodeInfos));
            var ulEl = Rui.get(ulDom);
            //animation 효과 주기
            if (!refresh || !this.isExpand()) {
                ulEl.setStyle('display', 'none');
            }
            this.el.parent().appendChild(ulDom);
            var wh = ulEl.getDimensions(); //width,height 가져오기, none된 부분도 구해옮
            this.childULHeight = wh.height;
            if (!refresh || !this.isExpand()) {
                if (this.useAnimation && (this.useAnimation === true || this.useAnimation.expand === true)) {
                    ulEl.setStyle('height', '1px');
                    ulEl.setStyle('display', '');
                    ulEl.setStyle('overflow', 'hidden');
                    //animation효과로 높이 키우기
                    var anim = new Rui.fx.LAnim({
                        el: ulDom,
                        attributes: {
                            height: {
                                from: 1,
                                to: wh.height
                            }
                        }
                    });
                    anim.duration = this.unorderList.animDuration;
                    anim.animate();
                    var thisNode = this;
                    anim.on('complete', function(){
                        ulEl.setStyle('height', 'auto');
                        thisNode.unorderList.fireEvent('expand', {
                            target: thisNode,
                            node: thisNode.unorderList.currentFocus
                        });
                        ulEl.setStyle('overflow', '');
                    });
                } else {
                    ulEl.setStyle('display', '');
                    ulEl.setStyle('overflow', 'hidden');
                    ulEl.setStyle('height', 'auto');
                    this.unorderList.fireEvent('expand', {
                        target: this,
                        node: this.unorderList.currentFocus
                    });
                    ulEl.setStyle('overflow', '');
                }
            }
        }
    },





    getChildNodes: function() {
        var records = [];
        if (this.unorderList)
            records = this.unorderList.getChildRecords(this.getIdValue(), this.childDataSet);
        return records;
    },








    checkNodeState: function (NODE_STATE) {
        switch (NODE_STATE) {
            case this.NODE_STATE.HAS_CHILD:
                return this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID);
                break;
            case this.NODE_STATE.HAS_NO_CHILD:
                return this.el.hasClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_MID)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST);
                break;
            case this.NODE_STATE.MID:
                return this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_MID);
                break;
            case this.NODE_STATE.LAST:
                return this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST);
                break;
            case this.NODE_STATE.OPEN:
                return this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST);
                break;
            case this.NODE_STATE.CLOSE:
                return this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST)
                    || this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID);
                break;
            case this.NODE_STATE.MARK:
                return this.el.hasClass(this.unorderList.CLASS_UL_MARKED_NODE);
                break;
            case this.NODE_STATE.UNMARK:
                return !this.el.hasClass(this.unorderList.CLASS_UL_MARKED_NODE);
                break;
            case this.NODE_STATE.FOCUS:
                return this.el.hasClass(this.unorderList.CLASS_UL_FOCUS_NODE);
                break;
            case this.NODE_STATE.UNFOCUS:
                return !this.el.hasClass(this.unorderList.CLASS_UL_FOCUS_NODE);
                break;
            default:
                return false;
                break;
        }
    },







    changeStateTo: function (NODE_STATE) {
        switch (NODE_STATE) {
            case this.NODE_STATE.HAS_CHILD:
                if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_MID)) {
                    this.el.replaceClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_MID, this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID);
                    Rui.get(this.getLi()).addClass(this.unorderList.CLASS_UL_LI_LINE);
                }
                else if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST, this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST);
                break;
            case this.NODE_STATE.HAS_NO_CHILD:
                if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID, this.unorderList.CLASS_UL_HAS_NO_CHILD_MID);
                else if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST, this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST);
                else if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID, this.unorderList.CLASS_UL_HAS_NO_CHILD_MID);
                else if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST, this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST);
                Rui.get(this.getLi()).removeClass(this.unorderList.CLASS_UL_LI_LINE);
                break;
            case this.NODE_STATE.MID:
                if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST, this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID);
                else if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST)) {
                    this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST, this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID);
                    Rui.get(this.getLi()).addClass(this.unorderList.CLASS_UL_LI_LINE);
                }
                else
                    if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST))
                        this.el.replaceClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST, this.unorderList.CLASS_UL_HAS_NO_CHILD_MID);
                break;
            case this.NODE_STATE.LAST:
                if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID, this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST);
                else if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID, this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST);
                else if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_MID)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_NO_CHILD_MID, this.unorderList.CLASS_UL_HAS_NO_CHILD_LAST);
                Rui.get(this.getLi()).removeClass(this.unorderList.CLASS_UL_LI_LINE);
                break;
            case this.NODE_STATE.OPEN:
                if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID)) {
                    this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID, this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID);
                    Rui.get(this.getLi()).addClass(this.unorderList.CLASS_UL_LI_LINE);
                }
                else
                    if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST))
                        this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST, this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST);
                break;
            case this.NODE_STATE.CLOSE:
                if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_MID, this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_MID);
                else if (this.el.hasClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST)) this.el.replaceClass(this.unorderList.CLASS_UL_HAS_CHILD_OPEN_LAST, this.unorderList.CLASS_UL_HAS_CHILD_CLOSE_LAST);
                Rui.get(this.getLi()).removeClass(this.unorderList.CLASS_UL_LI_LINE);
                break;
            case this.NODE_STATE.MARK:
                this.el.addClass(this.unorderList.CLASS_UL_MARKED_NODE);
                break;
            case this.NODE_STATE.UNMARK:
                //부모가 checked되어있으면 제거 => 보류, 회색 상태를 만들어야함.  상태 저장이 필요.
                //var pLi = this.getParentLi();
                //if (pLi) Rui.get(pLi.firstChild).removeClass(this.unorderList.CLASS_UL_MARKED_NODE);
                this.el.removeClass(this.unorderList.CLASS_UL_MARKED_NODE);
                break;
            case this.NODE_STATE.FOCUS:
                this.el.addClass(this.unorderList.CLASS_UL_FOCUS_NODE);
                var parent = this.getParentNode();
                if(parent)
                    parent.changeStateTo(this.NODE_STATE.FOCUS_PARENT);
                break;
            case this.NODE_STATE.UNFOCUS:
                this.el.removeClass(this.unorderList.CLASS_UL_FOCUS_NODE);
                var parent = this.getParentNode();
                if(parent)
                    parent.changeStateTo(this.NODE_STATE.UNFOCUS_PARENT);
                break;
            case this.NODE_STATE.FOCUS_PARENT:
                this.el.addClass(this.unorderList.CLASS_UL_FOCUS_PARENT_NODE);
                var parent = this.getParentNode();
                if(parent)
                    parent.changeStateTo(this.NODE_STATE.FOCUS_PARENT);
                break;
            case this.NODE_STATE.UNFOCUS_PARENT:
                this.el.removeClass(this.unorderList.CLASS_UL_FOCUS_PARENT_NODE);
                if(parent)
                    parent.changeStateTo(this.NODE_STATE.UNFOCUS_PARENT);
                break;
            case this.NODE_STATE.FOCUS_TOP:
                var ul = this.getUL();
                for(var i = 0, len = ul.childNodes.length; i < len; i++){
                    if(ul.childNodes[i].firstChild !== this.dom)
                        this.unorderList.getNodeObject(ul.childNodes[i]).el.removeClass(this.unorderList.CLASS_UL_FOCUS_TOP_NODE);
                }
                this.el.addClass(this.unorderList.CLASS_UL_FOCUS_TOP_NODE);
                break;
        }
    }
};
};






Rui.namespace('Rui.ui.tree');










Rui.ui.tree.LTreeView = function(id, config){
    config = id || config || {};
    if(typeof id == 'string'){
        config.id = id;
        config.applyTo = id;
    }
    config = Rui.applyIf(config, Rui.getConfig().getFirst('$.ext.treeView.defaultProperties'));
    Rui.ui.tree.LTreeView.superclass.constructor.call(this, config);   







    this.createEvent('nodeImageClick');







    this.createEvent('labelClick');







    this.createEvent('checkboxClick');
};
Rui.extend(Rui.ui.tree.LTreeView, Rui.ui.LUnorderedList, {






    otype: 'Rui.ui.tree.LTreeView',












    toggleByLabel: false,   













    nodeType: 'text',












    showFolder: true,                      

    CSS_BASE: 'L-ul L-ul-treeview',
    CLASS_UL_TREEVIEW_NODE_TABLE: 'L-ul-treeview-node-table',        
    CLASS_UL_TREEVIEW_NODE_TABLE_CELL: 'L-ul-treeview-node-table-cell',
    CLASS_UL_TREEVIEW_NODE_TABLE_CELL_FOLDER: 'L-ul-treeview-node-table-cell-folder',
    CLASS_UL_TREEVIEW_NODE_TABLE_CELL_FOLDER_NO_CHILD: 'L-ul-treeview-node-table-cell-folder-no-child',
    CLASS_UL_TREEVIEW_NODE_TABLE_CELL_FOLDER_HIDDEN: 'L-ul-treeview-node-table-cell-folder-hidden',
    CLASS_UL_TREEVIEW_NODE_TABLE_CELL_CHECKBOX: 'L-ul-treeview-node-table-cell-checkbox',
    CLASS_UL_TREEVIEW_NODE_TABLE_CELL_CHECKBOX_HIDDEN: 'L-ul-treeview-node-table-cell-checkbox-hidden',
    CLASS_UL_TREEVIEW_NODE_TABLE_CELL_CONTENT: 'L-ul-treeview-node-table-cell-content',
    CLASS_UL_TREEVIEW_NODE_IMAGE: 'L-ul-treeview-node-image',
    CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID: 'L-ul-treeview-node-image-close-mid',
    CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST: 'L-ul-treeview-node-image-close-last',
    CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID: 'L-ul-treeview-node-image-open-mid',
    CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST: 'L-ul-treeview-node-image-open-last',
    CLASS_UL_TREEVIEW_NODE_IMAGE_MID: 'L-ul-treeview-node-image-mid',
    CLASS_UL_TREEVIEW_NODE_IMAGE_LAST: 'L-ul-treeview-node-image-last',
    CLASS_UL_TREEVIEW_NODE_FOLDER: 'L-ul-treeview-node-folder',
    CLASS_UL_TREEVIEW_NODE_FOLDER_OPEN: 'L-ul-treeview-node-folder-open',
    CLASS_UL_TREEVIEW_NODE_FOLDER_CLOSE: 'L-ul-treeview-node-folder-close',
    CLASS_UL_TREEVIEW_NODE_CHECKBOX: 'L-ul-treeview-node-checkbox',
    CLASS_UL_TREEVIEW_NODE_CHECKBOX_CHECKED: 'L-ul-treeview-node-checkbox-checked',
    CLASS_UL_TREEVIEW_NODE_CHECKBOX_UNCHECKED: 'L-ul-treeview-node-checkbox-unchecked',
    CLASS_UL_TREEVIEW_NODE_CONTENT: 'L-ul-treeview-node-content',
    CLASS_UL_TREEVIEW_NODE_LABEL: 'L-ul-treeview-node-label',






    accessibilityELRole: 'tree',






    createTemplate: function() {
        Rui.ui.tree.LTreeView.superclass.createTemplate.call(this);
        var ts = this.templates || {};
        ts.td = new Rui.LTemplate(
            '<td class="{clsTd}"><div class="{clsDiv}">&nbsp;</div></td>'
        );
        ts.table = new Rui.LTemplate(
            '<table cellspacing="0" cellpadding="0" border="0" class="' + this.CLASS_UL_TREEVIEW_NODE_TABLE + '">',
            '<tbody>',
            '<tr>',
            '<td class="'+this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL+'">',
                '<div class="' + this.CLASS_UL_TREEVIEW_NODE_IMAGE + ' {nodeImageClass}">&nbsp;</div>',
            '</td>',
            '{folderTd}',
            '{checkboxTd}',
            '<td class="'+this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL+ ' ' +this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_CONTENT+'">',
                '<div class="' + this.CLASS_UL_TREEVIEW_NODE_CONTENT + '">',
                '<a class="' + this.CLASS_UL_TREEVIEW_NODE_LABEL + '">{label}</a>',
                '</div>',
            '</td>',
            '</tr>',
            '</tbody>',
            '</table>'
        );
        this.templates = ts;
    },







    getAccessibilityUlRole: function(depth){
        if(depth == 0) return 'tree';
        return 'group';
    },






    getAccessibilityLiRole: function(){
        return 'treeitem';
    },








    getContent: function(record,nodeStateClass,isMarked){
        var label = this.getLabel(record,nodeStateClass);
        var nodeImageClass = '';
        var folderImageClass = '';
        var hasChildNode = true;
        switch (nodeStateClass){
            case this.CLASS_UL_HAS_CHILD_CLOSE_MID: 
                nodeImageClass = this.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID;
                folderImageClass = this.CLASS_UL_TREEVIEW_NODE_FOLDER_CLOSE;
                break;
            case this.CLASS_UL_HAS_CHILD_CLOSE_LAST: 
                nodeImageClass = this.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST;
                folderImageClass = this.CLASS_UL_TREEVIEW_NODE_FOLDER_CLOSE;
                break;
            case this.CLASS_UL_HAS_CHILD_OPEN_MID: 
                nodeImageClass =  this.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID;
                folderImageClass = this.CLASS_UL_TREEVIEW_NODE_FOLDER_OPEN;
                break;
            case this.CLASS_UL_HAS_CHILD_OPEN_LAST: 
                nodeImageClass =  this.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST;
                folderImageClass = this.CLASS_UL_TREEVIEW_NODE_FOLDER_OPEN;
                break;
            case this.CLASS_UL_HAS_NO_CHILD_MID: 
                nodeImageClass =  this.CLASS_UL_TREEVIEW_NODE_IMAGE_MID;
                hasChildNode = false;
                break;
            case this.CLASS_UL_HAS_NO_CHILD_LAST: 
                nodeImageClass =  this.CLASS_UL_TREEVIEW_NODE_IMAGE_LAST;
                hasChildNode = false;
                break;
        }

        var ts = this.templates || {};
        var folderHTML, 
            clsTd = [this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL],
            clsDiv = [this.CLASS_UL_TREEVIEW_NODE_FOLDER];
        clsTd.push(this.showFolder !== true ? this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_FOLDER_HIDDEN : (
                hasChildNode === true ? this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_FOLDER : this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_FOLDER_NO_CHILD
            )
        );
        clsDiv.push(folderImageClass);
        folderHTML = ts.td.apply({
            clsTd: clsTd.join(' '),
            clsDiv: clsDiv.join(' ')
        });










        var checkboxHTML,
            clsTd = [this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL],
            clsDiv = [];
        if(this.nodeType.toLowerCase() == 'checkbox'){
        	var row = record.dataSet.indexOfKey(record.id);
        	if(!record.dataSet.isMarkable(row)) clsTd.push(this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_CHECKBOX + '-disabled');
            clsTd.push(this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_CHECKBOX);
            clsDiv.push(isMarked ? this.CLASS_UL_TREEVIEW_NODE_CHECKBOX_CHECKED : this.CLASS_UL_TREEVIEW_NODE_CHECKBOX_UNCHECKED);
        }else{
            clsTd.push(this.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_CHECKBOX_HIDDEN);
        }
        checkboxHTML = ts.td.apply({
            clsTd: clsTd.join(' '),
            clsDiv: clsDiv.join(' ')
        });















        label = ts.table.apply({
            folderTd: folderHTML,
            checkboxTd: checkboxHTML,
            nodeImageClass: nodeImageClass,
            label: label
        });










        return label;
    },        








    onNodeClick: function(e){
        var node = this.findNodeByDom(e.target);
        if (node) {
            var toggle = false;   
            var nodeEventType = '';
            var className = e.target.className; 
            if(node !== this.currentFocus) {
                var idx = this.dataSet.indexOfKey(node.getRecordId());
                this.dataSet.setRow(idx);
            }
            if(className.indexOf(this.CLASS_UL_TREEVIEW_NODE_IMAGE) > -1){
                toggle = true;   
                this.fireEvent('nodeImageClick', {target:this,node:this.currentFocus,dom:e.target});
                nodeEventType = 'nodeImageClick';
            }
            if(this.nodeType != 'text' && className.indexOf(this.CLASS_UL_TREEVIEW_NODE_CHECKBOX) > -1){
                var marking = false;
                if(className.indexOf(this.CLASS_UL_TREEVIEW_NODE_CHECKBOX_UNCHECKED) > -1){
                    marking = true;
                }
                this.dataSet.setMark(this.dataSet.indexOfKey(node.getRecordId()), marking);
                this.fireEvent('checkboxClick', {target:this,node:this.currentFocus,checked:this.currentFocus.isMarked(),dom:e.target});
                nodeEventType = 'checkboxClick';
            }
            if(Rui.util.LDom.findParent(e.target, 'a.' + this.CLASS_UL_TREEVIEW_NODE_LABEL, 10)){
                toggle = this.toggleByLabel !== false ? true : false;
                this.fireEvent('labelClick', {target:this,node:this.currentFocus,dom:e.target});
                nodeEventType = 'labelClick';
            }
            this.fireEvent('nodeClick', {target:this,node:this.currentFocus,nodeEventType:nodeEventType,dom:e.target});
            if(toggle) node.toggleChild();
        }
    },






    onNodeMouseover: function(e){
        var node = this.findNodeByDom(e.target);
        if (node) {  
            this.fireEvent('nodeMouseover', {
                target: this,
                node: node
            });
        }
    },






    onNodeMouseout: function(e){
        var node = this.findNodeByDom(e.target);
        if (node) {  
            this.fireEvent('nodeMouseout', {
                target: this,
                node: node
            });
        }
    },   






    openDepthNode: function(depth){
        var mm = Rui.getMessageManager();
        var cnt = this.dataSet.getCount();

        if(Rui.browser.msie678 && cnt >= 1000){
          if (confirm(mm.get('$.ext.msg017', [cnt])) == false) {
              return;
          }
        }
        this.defaultOpenDepth = depth; 
        this.render(this.container); 
    }, 







    createNodeObject: function(dom){
        return new Rui.ui.tree.LTreeViewNode({
            unorderList: this,
            useAnimation: this.useAnimation,
            dom: dom
        });
    }, 




    destroy: function(){
        Rui.ui.tree.LTreeView.superclass.destroy.call(this);
    }
});









Rui.ui.tree.LTreeViewNode = function(config){
    Rui.ui.tree.LTreeViewNode.superclass.constructor.call(this, config);
};
Rui.extend(Rui.ui.tree.LTreeViewNode, Rui.ui.LUnorderedListNode, {






    otype: 'Rui.ui.tree.LTreeViewNode',






    partType: {
        nodeImage: 0,
        folder: 1,
        cehckbox: 2,
        content: 3,
        label: 4
    },






    syncLabel: function(){
        //label을 record값과 sync
        this.getPartEl(this.partType.label).html(this.unorderList.getLabel(this.getRecord()));
    },








    getPartEl: function(partType,dom){
        dom = dom ? dom : this.dom;
        //특정 부분의 part el을 return한다.
        var cells = dom.firstChild.rows[0].cells;
        switch(partType){
        case this.partType.nodeImage:
            return Rui.get(cells[0].firstChild);
            break;
        case this.partType.folder:
            return Rui.get(cells[1].firstChild);
            break;
        case this.partType.checkbox:
            return Rui.get(cells[2].firstChild);
            break;
        case this.partType.content:
            return Rui.get(cells[3].firstChild);
            break;
        case this.partType.label:
            return Rui.get(cells[3].firstChild.firstChild);
            break;
        default:
            return null;
        break;
        }
    },







    changeStateTo: function(NODE_STATE){ 
        Rui.ui.tree.LTreeViewNode.superclass.changeStateTo.call(this, NODE_STATE);

        var elNodeImage = this.getPartEl(this.partType.nodeImage);
        var elFolder = this.getPartEl(this.partType.folder);
        var elCellFolder = Rui.get(elFolder.dom.parentNode);
        switch (NODE_STATE){                
        case this.NODE_STATE.HAS_CHILD:
            //node image 변경
            if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_MID)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_MID, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID); 
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_LAST)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_LAST, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST);
            //folder그림 변경 및 폴더 보이기.
            if (this.unorderList.showFolder) {
                elFolder.removeClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_FOLDER_CLOSE);
                elFolder.addClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_FOLDER_OPEN);
                elCellFolder.removeClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_FOLDER_HIDDEN);
            }                    
            break;
        case this.NODE_STATE.HAS_NO_CHILD:
            //node image 변경
            if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_MID);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_LAST);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_MID);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_LAST);
            //folder감추기
            if (this.unorderList.showFolder) {
                elFolder.removeClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_FOLDER_CLOSE);
                elFolder.removeClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_FOLDER_OPEN);
                elCellFolder.addClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_TABLE_CELL_FOLDER_HIDDEN);
            }
            break;
        case this.NODE_STATE.MID:
            //node image 변경
            if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_LAST)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_LAST, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_MID);
            break;
        case this.NODE_STATE.LAST:
            //마지막 previous sibling li style을 last에서 mid로 update한다.
            if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_MID)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_MID, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_LAST);
            break;
        case this.NODE_STATE.OPEN:
            if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST);
            elFolder.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_FOLDER_CLOSE,this.unorderList.CLASS_UL_TREEVIEW_NODE_FOLDER_OPEN);
            break;
        case this.NODE_STATE.CLOSE:
            if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_MID, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_MID);
            else if (elNodeImage.hasClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST)) elNodeImage.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_OPEN_LAST, this.unorderList.CLASS_UL_TREEVIEW_NODE_IMAGE_CLOSE_LAST);
            elFolder.replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_FOLDER_OPEN,this.unorderList.CLASS_UL_TREEVIEW_NODE_FOLDER_CLOSE);                    
            break;
        case this.NODE_STATE.MARK:
            this.getPartEl(this.partType.checkbox).replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_CHECKBOX_UNCHECKED,this.unorderList.CLASS_UL_TREEVIEW_NODE_CHECKBOX_CHECKED);
            break;
        case this.NODE_STATE.UNMARK:                   
            this.getPartEl(this.partType.checkbox).replaceClass(this.unorderList.CLASS_UL_TREEVIEW_NODE_CHECKBOX_CHECKED,this.unorderList.CLASS_UL_TREEVIEW_NODE_CHECKBOX_UNCHECKED);
            break;
        case this.NODE_STATE.FOCUS:
            break;
        case this.NODE_STATE.UNFOCUS:
            break;
        }
    }
});

