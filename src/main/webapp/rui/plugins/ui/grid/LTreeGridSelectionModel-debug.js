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
(function(){
	var Event = Rui.util.LEvent;
    /**
     * @description 그리드에서 cell를 선택시 cell의 흐름 제어를 하는 객체
     * @namespace Rui.ui.grid
     * @class LTreeGridSelectionModel
     * @extends Rui.ui.grid.LSelectionModel
     * @plugin
     * @constructor
     * the THEAD.
     */
    Rui.ui.grid.LTreeGridSelectionModel = function(oConfig) {
        Rui.ui.grid.LTreeGridSelectionModel.superclass.constructor.call(this, oConfig);

    };

    Rui.extend(Rui.ui.grid.LTreeGridSelectionModel, Rui.ui.grid.LSelectionModel, {
        otype : 'Rui.ui.grid.LTreeGridSelectionModel',
        /**
         * @description 데이터의 총건수를 리턴한다.
         * @method getDataCount
         * @protected
         * @return {int}
         */
        getDataCount: function() {
            return this.view.showData.length;
        },
        /**
         * @description row에서 moveIdx만큼 이동할 row를 계산하여 리턴한다.
         * @method getMoveRow
         * @protected
         * @param {int} row row 위치
         * @return {int}
         */
        getMoveRow: function(row, moveIdx) {
            var ds = this.view.getDataSet(), len = this.view.getDataCount(), realLen = ds.getCount();
            var currRow = row, currCount = 0, calVal = 0;
            var n = 0 < moveIdx ? 1 : -1;
            while(0 <= currRow && currRow < realLen) {
                if(currRow != row && ds.getAt(currRow).getAttribute('_show')) {
                    currCount += n;
                    if(currCount == moveIdx) {
                        break;
                    }
                }
                calVal++;
                currRow = currRow + n;
            }
            if(0 > ((row + calVal * n))) {
                return (0 < len ? 0 : -1);
            }
            return row + (calVal * n);
        },
        /**
         * @description page down 이벤트 발생시 호출되는 메소드
         * @method onPageDown
         * @protected
         * @param {Object} e Event 객체
         * @return {void}
         */
        onPageDown: function(e) {
            var view = this.gridPanel.getView(), ds = view.getDataSet();
            var visibleRowCount = view.getVisibleRowCount ? view.getVisibleRowCount(true) : this.pageUpDownRow;
            var row = this.getMoveRow(ds.getRow(), visibleRowCount);
            row = view.getDataSetRow(row);
            row = (row > view.getDataCount() - 1) ? view.getDataSetRow(view.getDataCount() - 1) : row;
            // 이동값 계산
            view.getDataSet().setRow(row);
            ds = view = null;
        },
        /**
         * @description keydown 이벤트 발생시 호출되는 메소드
         * @method onKeydown
         * @protected
         * @param {Object} e Event 객체
         * @return {void}
         */
        onKeydown: function(e){
            var view = this.view, gridPanel = view.gridPanel, ds = view.getDataSet(), row = ds.getRow(), realCount = ds.getCount(), colId = this.getColId();
            var k = Rui.util.LKey.NAVKEY;
            var isCellMove = true;
            var r = ds.getAt(row);
            switch (e.keyCode) {
                case k.LEFT:
                	if(row > -1 && colId && this.gridPanel.isEdit !== true && colId == view.treeColumnId) {
                        var pRow = row;
                        if(r.getAttribute('_expand') == 'normal')
                            pRow = view.getParentRow(row);
                        else if(r.getAttribute('_expand') == 'close')
                            pRow = view.getParentRow(row);
                        if(pRow > -1) {
                            ds.setRow(pRow);
                            view.collapse(pRow);
                            isCellMove = false;
                        }
                	}
                	break;
                case k.RIGHT:
                	if(row > -1 && colId && this.gridPanel.isEdit !== true && colId == view.treeColumnId) {
                        var pRow = row;
                        if (r.getAttribute('_expand') == 'normal')
                        	break;
                        else if (r.getAttribute('_expand') == 'close') 
                                pRow = row;
                        else pRow = -1;
                        if(pRow > -1) {
                            ds.setRow(pRow);
                            view.expand(pRow);
                            isCellMove = false;
                        }
                	}
                	break;
                case k.DOWN:
                    var moveRow = this.getMoveRow(row, 1);
                    if(moveRow < realCount) {
                        if(e.ctrlKey !== true && e.shiftKey !== true) this.clearSelection();
                        gridPanel.doSelectCell(moveRow, this.currentCol, e.shiftKey ? false : undefined);
                        gridPanel.systemSelect = true;
                    }
                    gridPanel.focusRow();
                    isCellMove = false;
                    Event.stopEvent(e);
                    break;
            }
            if(isCellMove)
                Rui.ui.grid.LTreeGridSelectionModel.superclass.onKeydown.call(this, e);
            ds = view = null;
        }
    });
})();
