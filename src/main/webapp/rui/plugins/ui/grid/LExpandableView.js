/*
 * @(#) rui plugin
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
 * @description 그리드의 기능 확장을 rendering하는 grid
 * IE 8 이하에서는 지원하지 않음.
 * @module ui_grid
 * @title LExpandableView
 * @requires Rui.ui.grid.LBufferGridView
 */
(function() {
    var Dom = Rui.util.LDom;










    Rui.ui.grid.LExpandableView = function(oConfig) {  
        Rui.ui.grid.LExpandableView.superclass.constructor.call(this,oConfig);









        this.createEvent('expand');








        this.createEvent('collapse');
    };

    Rui.extend(Rui.ui.grid.LExpandableView, Rui.ui.grid.LGridView, {
        isAfterRenderRow: true,














        rowRenderer: function(row, record) {
            return '';
        },







        getRowDom: function(row, index) {
            if(row < 0) return null;
            return this.getRows(index)[row * 2];
        },







        doAddData: function(e) {
            this.hideEmptyDataMessage();
            var row = e.row, record = e.record, ds = e.target, cm = this.columnModel;
            var rowHtml = this.getRenderRow(row, record, ds);
            var bodyLi = this.getLastLiEl();
            var tableDom = bodyLi.dom.firstChild;

            var newRowDom = Rui.createElements(rowHtml);
            //newRowDom.innerHTML = rowHtml;
            var newDom = newRowDom.getAt(0).dom;
            if(ds.getCount() > 1) {
                if (row === 0) {
                    var rowDom = this.getRowDom(row);
                    if (rowDom) {
                        var oldDom = tableDom.insertRow(row);
                        Dom.replaceChild(newDom, oldDom);
                        oldDom = null;
                    }
                } else {
                    var oldDom = tableDom.insertRow(row * 2);
                    Dom.replaceChild(newDom, oldDom);
                    oldDom = null;
                }
            } else {
                var oldDom = tableDom.insertRow();
                Dom.replaceChild(newDom, oldDom); 
                oldDom = null;
            }
            this.updateRenderRows(row);

            if (cm.freezeIndex > -1) {
                var rowDom = this.getRowDom(row, 0);
                rowDom = Rui.util.LDom.getNextSibling(rowDom);
                var rowHtml = this.getAfterRenderRow(e.row, e.record, ds.getCount(), true, null);
                var newRowEl = Rui.createElements(rowHtml);
                Dom.insertAfter(newRowEl.getAt(0).dom, rowDom);
            }
            var rowDom = this.getRowDom(row);
            var rowHtml = this.getAfterRenderRow(e.row, e.record, ds.getCount(), false, null);
            var newRowEl = Rui.createElements(rowHtml);
            var oldDom = tableDom.insertRow(row * 2 + 1);
            Dom.replaceChild(newRowEl.getAt(0).dom, oldDom);
            oldDom = null;

            var dataSetRow = ds.getRow();

            if(dataSetRow > -1) {
                this.gridPanel.getSelectionModel().selectRow(dataSetRow);
            }
            this.focusRow(row,0);
        },







        doRemoveData: function(e) {
            if(e.remainRemoved !== true) {
                var cm = this.columnModel;
                if (cm.freezeIndex > -1) {
                    var rowDom = this.getRowDom(e.row, 0);
                    rowDom = Rui.util.LDom.getNextSibling(rowDom);
                    rowDom.colspan = 1;
                    Dom.removeNode(rowDom);
                }
                var rowDom = this.getRowDom(e.row, 1);
                rowDom = Rui.util.LDom.getNextSibling(rowDom);
                rowDom.colspan = 1;
                Dom.removeNode(rowDom);
            }
            Rui.ui.grid.LExpandableView.superclass.doRemoveData.call(this, e);
        },







        doUndoData: function(e) {
            var firstDom, lastDom = null;
            if (e.beforeState == Rui.data.LRecord.STATE_INSERT) {
                var cm = this.columnModel;
                if (cm.freezeIndex > -1) {
                    firstDom = this.getRowDom(e.row, 0);
                    firstDom = Rui.util.LDom.getNextSibling(rowDom);
                }
                var lastDom = this.getRowDom(e.row, 1);
                lastDom = Rui.util.LDom.getNextSibling(lastDom);
            }
            Rui.ui.grid.LExpandableView.superclass.doUndoData.call(this, e);
            var state = e.beforeState, row = e.row;//, record = e.record, dataSet = e.target;
            if(state == Rui.data.LRecord.STATE_INSERT) {
                if(firstDom) {
                    firstDom.colspan = 1;
                    Dom.removeNode(firstDom);
                }
                if(lastDom) {
                    lastDom.colspan = 1;
                    Dom.removeNode(lastDom);
                }
            }
        },













        getAfterRenderRow: function(row, record, rowCount, firstColumns, spansm, sumRowsInfo){
            var cm = this.columnModel;
            var colspan = cm.getColumnCount(true);
            if(this.rowRenderer) {
                var html = this.rowRenderer(row, record);
                var contentWidth = this.columnModel.getTotalWidth(true);
                return '<tr class="L-grid-row-expandable L-grid-row-expandable-' + record.id + '" style="width:' + contentWidth + 'px"><td colspan="' + colspan + '" style="width:' + contentWidth + 'px" class="L-grid-col-expandable">' + html + '</td></tr>';
            } else return '';
        },






        hasExpand: function(row) {
            var rowDom = this.getRowDom(row);
            rowDom = Rui.util.LDom.getNextSibling(rowDom);
            var rowEl = Rui.get(rowDom);
            return rowEl.hasClass('L-expand');
        },







        setExpand: function(row, isExpand) {
            var rowDom = this.getRowDom(row);
            rowDom = Rui.util.LDom.getNextSibling(rowDom);
            var rowEl = Rui.get(rowDom);
            if(isExpand) rowEl.addClass('L-expand'); else rowEl.removeClass('L-expand');
            var isFirst = !rowEl.hasClass('L-expanded');
            rowEl.addClass('L-expanded');
            var options = { target: this, expandableTarget: rowEl.dom.firstChild, row: row, isFirst: isFirst };
            if(isExpand)
                this.fireEvent('expand', options);
            else
                this.fireEvent('collapse', options);
        },






        getRowHeight: function(){
            var rows = this.getRows(), h = 30;
            if(rows.length < 1)
            	return 30;
            return this._getRowHeight(rows[0]);
        }
    });
})();
