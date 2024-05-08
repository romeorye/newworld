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
 * @description 파일을 첨부하여 서버로 업로드하는데 필요한 업로드용 dialog
 * LFileUploadDialog
 * @namespace Rui.ui
 * @plugin js,css
 * @class LFileUploadDialog
 * @extends Rui.ui.LDialog
 * @sample default
 * @constructor LFileUploadDialog
 * @param {Object} config The intial LFileUploadDialog.
 */
Rui.ui.LFileUploadDialog = function(config) {
    config = config || {};
    
    this.uploadDelegate = Rui.util.LFunction.createDelegate(this.onUpload, this);

    config = Rui.applyIf(config, {
        postmethod: 'async',
        visible: false,
        hideaftersubmit: false,
        callback: {
            upload: this.uploadDelegate
        },
        buttons : 
            [ 
                { text:"Upload", handler:this.handleSubmit, isDefault:true },
                { text:"Close", handler:this.handleCancel } 
            ]
    });
    
    this.activeTaskDelegate = Rui.util.LFunction.createDelegate(this.activeTask, this);
    this.updateProgressDelegate = Rui.util.LFunction.createDelegate(this.updateProgress, this);
    
    config = Rui.applyIf(config, Rui.getConfig().getFirst('$.ext.fileupload.defaultProperties'));
    
    this.url = config.url;
    this.useProgressBar = config.useProgressBar === true;
    
    Rui.ui.LFileUploadDialog.superclass.constructor.call(this, config);
    this.createEvent('success');
};

Rui.extend(Rui.ui.LFileUploadDialog, Rui.ui.LDialog, {
    /**
     * @description https가 적용되었는지 확인하는 속성
     * @property isSecure
     * @type {Boolean}
     * @private
     */
    isSecure: false,
    /**
     * @description upload url 경로
     * @config url
     * @type {String}
     * @default null
     */
    /**
     * @description upload url 경로
     * @property url
     * @type {String}
     * @private
     */
    url: null,
    /**
     * @description dialog내에 생성되는 fileBox의 name값
     * @config name
     * @type {String}
     * @default null
     */
    /**
     * @description dialog내에 생성되는 fileBox의 name값
     * @property name
     * @type {String}
     * @private
     */
    name: null,
    /**
     * @description 파일 선택 메시지
     * @config emptyMsg
     * @type {String}
     * @default '선택된 파일이 없습니다.'
     */
    /**
     * @description 파일 선택 메시지
     * @property emptyMsg
     * @type {String}
     * @private
     */
    emptyMsg: null,
    /**
     * @description 업로드 진행 상태를 볼 수 있는 여부
     * @property useProgressBar
     * @type {boolean}
     * @private
     */
    useProgressBar: false,
    /**
     * @description 상태를 확인하는 url
     * @config statusUrl
     * @type {String}
     * @default 'fileUploadStatus.jsp'
     */
    /**
     * @description 상태를 확인하는 url
     * @property statusUrl
     * @type {String}
     * @private
     */
    statusUrl: 'fileUploadStatus.jsp',
    /**
     * @description 파일 업로드시 request의 파라미터 설정한다.
     * @config params
     * @type {Object}
     * @default null
     */
    /**
     * @description 파일 업로드시 request의 파라미터 설정한다.
     * @property params
     * @type {Object}
     * @private
     */
    params: null,
    /**
     * @description 상태를 확인하는 delay 시간
     * @property delayTime
     * @type {int}
     * @private
     */
    delayTime: 500,
    /**
     * @description upload후 호출되는 이벤트
     * @method onUpload
     * @private
     * @param {Object} e 이벤트 객체
     * @return {void}
     */
    onUpload: function(e) {
        this.formEl.dom.reset();
        if (this.useProgressBar) {
            this.setProgressValue(100); 
        }
        this.fireEvent('success', {target: this, conn: e, value: this.fileBox.getValue()});
        this.createFile(true);
        this.updateStatus(false);
        this.hide();
    },
    /**
     * @description submit시 호출되는 메소드
     * @method handleSubmit
     * @private
     * @param {Object} e 이벤트 객체
     * @return {void}
     */
    handleSubmit: function(e) {
        var value = this.fileBox.getValue();
        if(value == '') {
            Rui.alert(this.emptyMsg || Rui.getMessageManager().get('$.ext.msg023'));
            return;
        }
        this.updateStatus(true);
        Rui.LConnect._isFormSubmit = true;
        if(this.params) {
            Rui.select('.L-upload-parameters').remove();
            var html = '<div class="L-upload-parameters">';
            for(m in this.params) {
                var v = this.params[m];
                html += '<input type="hidden" name="' + m + '" value="' + v + '">';
            }
            html += '</div>';
            this.formEl.appendChild(html);
        }
        this.submit();
        if(this.useProgressBar) {
            this.startProgress();
        }
    },
    /**
     * @description 파일 업로드시 전달할 request 파라미터를 변경한다.
     * @method setParams
     * @private
     * @param {Object} e 이벤트 객체
     * @return {void}
     */
    setParams: function(params) {
        this.params = params;
    },
    /**
     * @description 서버에 상태를 호출하는 메소드
     * @method activeTask
     * @private
     * @return {void}
     */
    activeTask: function() {
        var uri = this.statusUrl;
        uri = Rui.util.LString.getTimeUrl(uri);
        Rui.LConnect.asyncRequest('GET', uri, {
            success: this.updateProgressDelegate,
            failure: Rui.util.LFunction.createDelegate(function(e) {
                Rui.alert(Rui.getMessageManager().get('$.base.msg101') + ' : ' + e.statusText);
            }, this)
        });
    },
    /**
     * @description progress의 진행 값을 반영한다.
     * @method setProgressValue
     * @public
     * @param {int} percent 진행값 
     * @return {void}
     */
    setProgressValue: function(percent) {
        this.progressMaskEl.setStyle('margin-left', percent + '%');
    },
    /**
     * @description progressbar의 상태를 반영하는 메소드
     * @method updateProgress
     * @private
     * @return {void}
     */
    updateProgress: function(e) {
        try {
            var isUpdateStatus = this.isUpdateStatus() ;
            var percent = isUpdateStatus ? parseInt(e.responseText) : 100;
            this.setProgressValue(percent); 
            if(percent < 100 && isUpdateStatus)
                this.activeDelayedTask.delay(this.delayTime);
        } catch(e) {}
    },
    /**
     * @description 진행상태를 반영하는 메소드
     * @method updateStatus
     * @private
     * @param {boolean} status 진행상태 여부
     * @return {void}
     */
    updateStatus: function(status) {
        var bodyEl = Rui.get(this.body);
        if (status) 
            bodyEl.addClass('upload-status');
        else
            bodyEl.removeClass('upload-status');
    },
    /**
     * @description 진행상태를 리턴하는 메소드
     * @method isUpdateStatus
     * @private
     * @return {boolean}
     */
    isUpdateStatus: function() {
        return Rui.get(this.body).hasClass('upload-status');
    },
    /**
     * @description progress bar를 시작하는 메소드
     * @method startProgress
     * @private
     * @return {void}
     */
    startProgress: function() {
        if(!this.activeDelayedTask)
            this.activeDelayedTask = new Rui.util.LDelayedTask(this.activeTaskDelegate);
        
        this.activeDelayedTask.delay(500);
    },
    /**
     * @description cancel시 호출되는 메소드
     * @method handleCancel
     * @private
     * @param {Object} e 이벤트 객체
     * @return {void}
     */
    handleCancel: function(e) {
        this.hide();
    },
    /**
     * @description render후 호출되는 메소드
     * @method afterRender
     * @protected
     * @param {HTMLElement} container 부모 객체
     * @return void
     */
    afterRender: function(bodyDom) {
        Rui.ui.LFileUploadDialog.superclass.afterRender.call(this, bodyDom);
        this.setHeader('File upload');
        this.setBody(this.getBodyHtml());

        this.createFile(false);            

        var bodyEl = Rui.get(this.body);
        this.formEl = bodyEl.select('.L-file-upload-form').getAt(0);
        this.progressMaskEl = bodyEl.select('.L-file-upload-progress-mask').getAt(0);
        
        this.formEl.dom.enctype = 'multipart/form-data';
        this.formEl.dom.encoding = 'multipart/form-data';
        
        this.on('show', this.onShow, this, true);
    },
    /**
     * @description show event handler
     * @method onShow
     * @protected
     * @param {Event} e handler 이벤트
     * @return void
     */
    onShow: function(e){
        this.fileBox.focus();
        this.formEl.dom.reset();
    },
    /**
     * @description filebox 생
     * @method createFile
     * @private
     * @return {boolean} isNew
     */
    createFile: function(isNew) {
        if(isNew) this.fileBox.destroy();
        this.fileBox = new Rui.ui.form.LFileBox({
            id: this.id + 'fileBox',
            width: 400,
            name: this.name,
            renderTo: this.id + 'fileBox'
        });
    },
    /**
     * @description body html 생성
     * @method getBodyHtml
     * @private
     * @return {String}
     */
    getBodyHtml: function() {
        this.templates = new Rui.LTemplate(
            "<div class='L-file-upload-progress L-file-upload-active-{active}'><div class='L-file-upload-progress-mask'></div></div>",
            "<form name='fileUploadFrm' method='post' action='{url}' class='L-file-upload-form'>",
            "    <div id='" + this.id + "fileBox'></div>",
            "</form>"
        );
        var p = {
            url: this.url,
            active: this.useProgressBar,
            blockFileInput: 'block' + this.id + '-input',
            blcokGridId: 'block' + this.id + '-grid'
        };
        return this.templates.apply(p);
    },
    /**
     * @description 유효성을 체크하는 메소드
     * @method validate
     * @private
     * @return {boolean}
     */
    validate: function () {
        var isValid = Rui.ui.LFileUploadDialog.superclass.validate.call(this);
        if(this.useProgressBar) {
            this.setProgressValue(0);
        }
        this.updateStatus(false);
        return isValid;
    },
    /**
     * @description file 객체인 LFileBox를 리턴한다.
     * @method getFileBox
     * @private
     * @return {Rui.ui.form.LFileBox}
     */
    getFileBox: function() {
        return this.fileBox;
    }, 
    /**
     * @description params 객체를 리턴한다.
     * @method getParams
     * @return {Object}
     */
    getParams: function() {
        return this.params;
    },
    /**
     * @description params 객체를 변경한다.
     * @method setParams
     * @return {Object}
     */
    setParams: function(params) {
        this.params = params;
    },
    /**
     * @description 객체를 destroy한다.
     * @method destroy
     * @public
     * @sample default
     * @return {void}
     */
    destroy: function(){
        this.unOn('show', this.onShow, this);
        Rui.ui.LFileUploadDialog.superclass.destroy.call(this);
    }
});


