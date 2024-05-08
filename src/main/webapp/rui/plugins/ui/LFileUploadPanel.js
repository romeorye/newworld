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
 * @description 파일을 첨부하여 서버로 업로드하는데 필요한 업로드용 panel
 * LFileUploadPanel
 * @namespace Rui.ui
 * @plugin
 * @class LFileUploadPanel
 * @extends Rui.ui.LCommonPanel
 * @constructor LFileUploadPanel
 * @param {Object} oConfig The intial LFileUploadPanel.
 */
Rui.ui.LFileUploadPanel = function(oConfig) {
    Rui.ui.LFileUploadPanel.superclass.constructor.call(this, oConfig);
};

Rui.extend(Rui.ui.LFileUploadPanel, Rui.ui.LCommonPanel, {







    CSS_BASIC: 'L-file-upload-panel',

    isSecure: false,

    uploadUrl: 'consoleLog.dev',

    validate: Rui.emptyFn,

    success: Rui.emptyFn,








    initView: function(oConfig){

        this.el.html(this.getBodyHtml());

        this.blockFileInputEl = this.el.select('#block' + this.id + '-input').getAt(0);

        this.formEl = this.el.select('.L-file-upload-form').getAt(0);

        var fileBox = new Rui.ui.form.LFileBox({
            id: this.id + 'fileBox',
            renderTo: this.id + 'fileBox'
        });

        var uploadBtn = new Rui.ui.LButton(this.id + 'Upload');
        uploadBtn.on('click', function(e){
            if(fileBox.getValue() == '') {
                alert('파일을 선택하세요.');
                return;
            }

            if(this.validate(fileBox.getValue()) === false) 
                return;

            var uploadHandler = Rui.util.LFunction.createDelegate(function(e) {
                this.success({ conn: e, value: fileBox.getValue() });
                fileBox.setValue('');
                this.hide();
            }, this);

            Rui.LConnect.setForm(this.formEl.dom, true, this.isSecure);
            Rui.LConnect.asyncRequest('POST', this.uploadUrl, {
                upload: uploadHandler
            });

        }, this, true);

        var closeBtn = new Rui.ui.LButton(this.id + 'Close');
        closeBtn.on('click', function(e){
            this.hide();
        }, this, true);

        this.isViewRendered = true;
    },







    getBodyHtml: function() {
        this.templates = new Rui.LTemplate(
            "<div id='{blockFileInput}'>",
            "<form name='fileUploadFrm' method='post' action='/consoleLog.dev' class='L-file-upload-form'>",
            "    <div id='" + this.id + "fileBox'></div>",
            "</form>",
            "<button id='" + this.id + "Upload'>upload</button>",
            "<button id='" + this.id + "Close'>Close</button>",
            "</div>"
        );

        var p = {
            blockFileInput: 'block' + this.id + '-input',
            blcokGridId: 'block' + this.id + '-grid'
        };

        return this.templates.apply(p);
    },







    render: function(el) {
        this.el = Rui.get(el);
        this.el.addClass(this.CSS_BASIC);
        this.afterRender(this.el);
        this.hide();
    },








    show: function(useAnim) {
        this.el.show(useAnim);
    },







    hide: function(useAnim) {
        this.el.hide(useAnim);
    }
});

