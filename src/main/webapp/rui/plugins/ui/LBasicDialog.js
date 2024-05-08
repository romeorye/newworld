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
 * LBasicDialog
 * @namespace Rui.ui
 * @class LBasicDialog
 * @extends Rui.ui.LCommonPanel
 * @constructor LBasicDialog
 * @plugin 
 * @param {Object} oConfig The intial LBasicDialog.
 */
Rui.ui.LBasicDialog = function(oConfig) {
    var config = oConfig || {};

    this.handleApplyDelegate = Rui.util.LFunction.createDelegate(this.onHandleApply, this);
    this.handleCancelDelegate = Rui.util.LFunction.createDelegate(this.onHandleCancel, this);

    Rui.ui.LBasicDialog.superclass.constructor.call(this, config);
};

Rui.extend(Rui.ui.LBasicDialog, Rui.ui.LCommonPanel, {






    title: '공통 팝업',







    CSS_BASIC: 'L-basic-dialog',







    dialogWidth: 400,







    onHandleApply: function() {
        this.dialog.submit(true);
    },







    onHandleCancel: function() {
        this.dialog.cancel(true);
    },








    initComponent: function(oConfig){
        this.id = this.id || Rui.id();
    },








    initView: function(oConfig){
        this.dialog = new Rui.ui.LDialog({
        	id: Rui.id(),
            width : this.dialogWidth,
            visible : false,
            modal: true,
            fixedcenter: true,
            postmethod:'none',
            buttons :
                [
                    { text:"Apply", handler: this.handleApplyDelegate, isDefault:true },
                    { text:"Close", handler: this.handleCancelDelegate }
                ]
        });

        this.dialog.render(document.body);
        this.dialog.setHeader(this.title);
        this.dialog.setBody(this.getBodyHtml());
        this.isViewRendered = true;
    },







    getBodyHtml: function() {
        this.templates = new Rui.LTemplate(
            '<div id="{gridId}"></div>'
        );

        var p = {
            gridId: this.id + '-grid'
        };

        return this.templates.apply(p);
    },







    render: function(el) {
        this.el = Rui.get(el);
        this.el.addClass(this.CSS_BASIC);
        this.afterRender(this.el);
    },







    showDialog: function() {
        if(!this.isViewRendered) {
            this.initView();
        }
        this.dialog.show(true);
    },








    afterRender: function(el) {
        this.el.html("<input type='text' id='" + this.id + "Code' style='width:" + this.width + "' readOnly> <div class='" + this.CSS_BASIC + "-icon'></div>");
        this.inputCodeEl = this.el.select('#' + this.id + 'Code').getAt(0);
        this.inputCodeEl = Rui.get(this.inputCodeEl.id);
        this.iconEl = this.el.select('.' + this.CSS_BASIC + '-icon').getAt(0);

        this.iconEl.on('click', function(){
            this.showDialog();
        }, this, true);
    }
});

