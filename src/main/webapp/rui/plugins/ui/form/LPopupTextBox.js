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
 * @description TextBox에 팝업아이콘을 생성하는 PopupTextBox (beta)
 * LTextBox의 모든 속성이 적용되지 않는다. (mask)
 * LMonthBox
 * @namespace Rui.ui.form
 * @plugin js,css
 * @class LPopupTextBox
 * @extends Rui.ui.form.LTextBox
 * @constructor LPopupTextBox
 * @param config {Object} The intial LPopupTextBox. 
 */
Rui.ui.form.LPopupTextBox = function(config){
    config = config || {};
    config = Rui.applyIf(config, Rui.getConfig().getFirst('$.ext.popupTextBox.defaultProperties'));
    Rui.ui.form.LPopupTextBox.superclass.constructor.call(this, config);




    this.createEvent('popup');
};

Rui.extend(Rui.ui.form.LPopupTextBox, Rui.ui.form.LTextBox, {






    otype: 'Rui.ui.form.LPopupTextBox',






    CSS_BASE: 'L-popuptextbox',














    iconWidth: 20,












    iconMarginLeft: 1,












    editable: false,






    checkContainBlur: true,












    useHiddenValue: false,












    enterToPopup: false,












    picker: true, 







    doRender: function(){
        this.createTemplate(this.el);
        if(this.useHiddenValue) {
            var hiddenInput = document.createElement('input');
            hiddenInput.type = 'hidden';
            hiddenInput.name = this.name || this.id;
            hiddenInput.instance = this;
            hiddenInput.className = 'L-instance L-hidden-field';
            this.el.appendChild(hiddenInput);
            this.hiddenInputEl = Rui.get(hiddenInput);
            this.hiddenInputEl.addClass('L-hidden-field');

            var input = this.inputEl.dom;
            input.removeAttribute('name');
        }else{
            this.inputEl.dom.instance = this;
            this.inputEl.addClass('L-instance');
        }
        this.doRenderPopup();
    },






    doRenderPopup: function(){
        if(!this.picker) return;

        var iconDom = document.createElement('a');
        iconDom.className = 'icon';
        this.el.appendChild(iconDom);
        this.iconEl = Rui.get(iconDom);
        if(Rui.useAccessibility())
            this.iconEl.setAttribute('role', 'button');
    },






    popupOn: function(){
        if(!this.iconEl) return;
        this.iconEl.unOn('click', this.onIconClick, this);
        this.iconEl.on('click', this.onIconClick, this, true);
        this.iconEl.setStyle('cursor', 'pointer');
        this.iconEl.setAttribute('tabindex', '0');
    },






    popupOff: function(){
        if(!this.iconEl) return;
        this.iconEl.unOn('click', this.onIconClick, this);
        this.iconEl.setStyle('cursor', 'default');
        this.iconEl.removeAttribute('tabindex');
    },









    _setWidth: function(type, args, obj) {
    	if(args[0] < 0) return;
        Rui.ui.form.LDateBox.superclass._setWidth.call(this, type, args, obj);
        if(this.iconEl){
            this.getDisplayEl().setWidth(this.getContentWidth() - (this.iconEl.getWidth() || this.iconWidth) - this.iconMarginLeft);
        }
    },







    onEnterKeyDown: function(e) {
        if(e.keyCode === 13) {
            this.onIconClick(e);
            Rui.util.LEvent.stopEvent(e);
            return false;
        }
    },







    onIconClick: function(e) {
        try {
            this.inputEl.focus();
        } catch(e1) {}
        var value = (this.useHiddenValue) ? this.hiddenInputEl.getValue() : this.inputEl.getValue();
        var displayValue = this.inputEl.getValue();
        this.fireEvent('popup', { value: value, displayValue: displayValue });
    },









    _setEditable: function(type, args, obj) {
        Rui.ui.form.LPopupTextBox.superclass._setEditable.call(this, type, args, obj);
    	if(this.editable){
    		if(this.enterToPopup) {
    			this.inputEl.on('keydown', this.onEnterKeyDown, this, true);
    		}
    	}else{
            this.inputEl.unOn('keydown', this.onEnterKeyDown, this, true);
    	}
    },









    _setDisabled: function(type, args, obj) {
        if(args[0] === false) {
            this.popupOn();
        } else {
            this.popupOff();
        }
        Rui.ui.form.LPopupTextBox.superclass._setDisabled.call(this, type, args, obj);
    },







    setValue: function(o, ignoreEvent) {
        if(Rui.isUndefined(o) == true || this.lastValue == o) return;
        if(this.useHiddenValue)
            this.hiddenInputEl.setValue(o);
        Rui.ui.form.LPopupTextBox.superclass.setValue.call(this, o, ignoreEvent);
    },






    setDisplayValue: function(o) {
    	//protected to public이므로 삭제하지 말것
        Rui.ui.form.LPopupTextBox.superclass.setDisplayValue.call(this, o);
        this.lastDisplayValue = o;
    },






    getValue: function() {
        var value = (this.useHiddenValue) ? this.hiddenInputEl.getValue() : this.inputEl.getValue();
        return value;
    },






    destroy: function() {
        if (this.iconEl) {
            this.iconEl.remove();
            delete this.iconEl;
        }
        Rui.ui.form.LPopupTextBox.superclass.destroy.call(this);
    }
});
