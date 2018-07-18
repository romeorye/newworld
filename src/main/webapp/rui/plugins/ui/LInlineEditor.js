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
(function () {
/**
* LInlineEditor
* @namespace Rui.ui
* @class LInlineEditor
* @constructor LInlineEditor
* @extends Rui.ui.LUIComponent
* @sample default
* @plugin
*/
Rui.ui.LInlineEditor = function(oConfig) {
    var config = oConfig || {};
    Rui.applyObject(this, config);








    this.createEvent("isEdit");







    this.createEvent("startEdit");







    this.createEvent("stopEdit");

    Rui.ui.LInlineEditor.superclass.constructor.call(this, config);
};

Rui.extend(Rui.ui.LInlineEditor, Rui.ui.LUIComponent, {







    otype: 'Rui.ui.LInlineEditor',












    field : null,













    isDisable: false,













    enterStopEdit: true,








    doRender : function(container) {
       var parentEl = this.el.parent();
       var editorContainer = document.createElement('div');
       editorContainer.className = 'L-inline-editor';
       this.editorContainerEl = Rui.get(editorContainer);
       parentEl.appendChild(editorContainer);
       this.field.borderWidth = 0;
       this.field.render(editorContainer);
       this.editorContainerEl.setVisibilityMode(false);
       this.editorContainerEl.hide();
    },








    afterRender : function(container) {
       this.field.on("blur", this.onBlur, this, true);
       this.field.on('keydown', this.onKeyDown, this, true);
       this.el.on("click", this.onClick, this, true);
    },








    onKeyDown : function(e) {
        switch(e.keyCode) {
            case Rui.util.LKey.KEY.ENTER:
                if(this.enterStopEdit == true) {
                    this.stopEditor();
                    this.applyValue();
                }
                break;
            case Rui.util.LKey.KEY.ESCAPE:
                this.stopEditor();
                this.cancelValue();
                break;
        }
    },







    applyValue : function() {
       this.targetEl.html(this.field.getValue());
       this.oldValue = null;
    },







    cancelValue : function() {
        if(this.oldValue) {
            this.el.html(this.oldValue);
            this.field.setValue(this.oldValue);
            this.oldValue = null;
        }
    },








    onBlur : function(e) {
        this.stopEditor();
        this.applyValue();
    },








    onClick : function(e) {
        if(this.fireEvent('isEdit', { target: e.target, event: e}) === false) return;
        this.startEditor(e.target);
    },








    startEditor : function(target) {
        if(this.isDisable == true) return;
        this.targetEl = Rui.get(target);
        this.oldValue = this.targetEl.getHtml();
        this.field.setValue(this.oldValue);
        this.editorContainerEl.show();
        this.editorContainerEl.setRegion(this.targetEl.getRegion());
        this.field.setWidth(this.editorContainerEl.getWidth());
        this.field.setHeight(this.editorContainerEl.getHeight());
        this.field.focus();
        this.fireEvent('startEdit', { target: this, field: this.field});
    },







    stopEditor : function() {
        this.editorContainerEl.hide();
        this.fireEvent('stopEdit', { target: this, field: this.field});
    },






    enable: function() {
        this.isDisable = true;
    }, 






    disable: function() {
        this.isDisable = false;
    }
});
}());
