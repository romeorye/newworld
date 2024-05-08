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
 * @description button의 code값과 display값을 분리하여 처리하는 객체
 * @namespace Rui.ui.grid
 * @class LEditButtonColumn
 * @extends Rui.ui.grid.LTriggerColumn
 * @plugin
 * @deprecated
 * @constructor
 * @param {Object} config Object literal of definitions.
 */
Rui.ui.grid.LEditButtonColumn = function(config) {
    config = config || {};
    Rui.ui.grid.LEditButtonColumn.superclass.constructor.call(this, config);

    /**
     * @description Column renderer 속성
     * @property renderer
     * @private
     * @type {Function}
     */
    this.beforeRenderer = this.buttonRenderer(config.editor);
};

Rui.extend(Rui.ui.grid.LEditButtonColumn, Rui.ui.grid.LTriggerColumn, {
    /**
     * @description ButtonColumn을 renderer하는 메소드
     * @method buttonRenderer
     * @protected
     * @param {Rui.ui.LButton} button button 객체
     * @return {String}
     */
    buttonRenderer : function(button) {
        return function(val, p, record, row, i) {
            val = (Rui.isEmpty(val)) ? '&nbsp;' : val;
            p.editable = true;
            return '<div style="position:relative">' + 
                '<div class="L-popup-button">' + val + '</div>' + 
                '<span class="L-popup-button-icon L-ignore-event" style="position:absolute">&nbsp;</span>' + 
                '</div>';
        };
    }
});    
