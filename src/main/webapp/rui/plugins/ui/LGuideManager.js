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
 * @description 화면 가이드를 지원하는 LGuide객체 관리자
 * @namespace Rui.ui
 * @plugin
 * @class LGuideManager
 * @extends Rui.ui.LUIComponent
 * @constructor LGuideManager 
 * @sample default
 * @param {Object} oConfig The intial LGuideManager.
 */
Rui.ui.LGuideManager = function(oConfig){
    oConfig = Rui.applyIf(oConfig, Rui.getConfig().getFirst('$.base.guide.defaultProperties'));

    Rui.applyObject(this, oConfig, true);
    this.config = oConfig;

    this.init();
};

Rui.ui.LGuideManager.prototype = {












    showPageGuide: true,












    pageName: null,












    pageUrl: null,












    webStore: null,












    params: null,






    init: function() {
        if(!this.webStore)
            this.webStore = new Rui.webdb.LWebStorage();
        if(this.showPageGuide) {
            if(this.webStore.getBoolean('showGuide_' + this.pageName, false) === false) {
                var ruiPath = Rui.getRootPath();
                Rui.includeJs(ruiPath + '/plugins/ui/LNotification.js', true);
                Rui.includeJs(ruiPath + '/plugins/ui/LNotificationManager.js', true);
                Rui.includeJs(ruiPath + '/plugins/ui/LFocusNotification.js', true);
                Rui.includeJs(ruiPath + '/plugins/ui/LGuide.js', true);
                Rui.includeCss(ruiPath + '/plugins/ui/LFocusNotification.css', true);

                if(!this.pageUrl)
                    this.pageUrl = './' + this.pageName + '_guide.js';
                Rui.namespace('Rui.ui.guide');
                Rui.includeJs(this.pageUrl, true);
                var guideClassName = 'Rui.ui.guide.' + Rui.util.LString.firstUpperCase(this.pageName);
                var cls = null;
                try {
                    var obj = eval(guideClassName);
                    this.guide = new obj(this.config);
                    this.guide.webStore = this.webStore;
                } catch (e) {
                    alert('Guide class name is wrong : ' + guideClassName);
                }
                this.guide.onReady();
            }
        }
    },





    clear: function() {
        var guideKeys = this.webStore.get('gm_' + this.pageName + '_guide_keys', '');
        var keys = guideKeys.split('|');
        for(var i = 0, len = keys.length; i < len; i++) {
            this.webStore.remove('gm_' + this.pageName + '_' + keys[i]);
        }
    },






    invokeGuideFn: function(name) {
        if(!this.guide) return;
        var fn = this.guide[name];
        if(fn) {
            fn.call(this.guide);
        } else {
            alert(name + ' Guide method name is wrong');
        }
    },






    addParams: function(params) {
        this.params = Rui.applyIf(this.params, params);
        this.guide.params = this.params;
    }
};
