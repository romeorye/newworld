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
 * @description 화면 가이드를 지원하는 객체
 * @namespace Rui.ui
 * @plugin
 * @class LGuide
 * @extends Rui.ui.LUIComponent
 * @constructor LGuide 
 * @param {Object} oConfig The intial LGuide.
 */
Rui.ui.LGuide = function(oConfig){
    Rui.applyObject(this, oConfig, true);
};

Rui.ui.LGuide.prototype = {












    pageName: null,
    webStore: null,







    getBoolean: function(key){
        if(this.debug) return false;
        var val = this.webStore.getBoolean('gm_' + this.pageName + '_' + key, false);
        this.webStore.set('gm_' + this.pageName + '_' + key, true);
        var guideKeys = this.webStore.get('gm_' + this.pageName + '_guide_keys', '');
        if(guideKeys.indexOf(key) < 0) {
            guideKeys += '|' + key;
            this.webStore.set('gm_' + this.pageName + '_guide_keys', guideKeys);
        }
        return val;
    },







    getInt: function(key){
        if(this.debug) return 0;
        var val = this.webStore.getInt('gm_' + this.pageName + '_' + key, 0);
        this.webStore.set('gm_' + this.pageName + '_' + key, val + 1);
        var guideKeys = this.webStore.get('gm_' + this.pageName + '_guide_keys', '');
        if(guideKeys.indexOf(key) < 0) {
            guideKeys += '|' + key;
            this.webStore.set('gm_' + this.pageName + '_guide_keys', guideKeys);
        }
        return val;
    },







    getToday: function(key){
        if(this.debug) return false;
        var today = new Date().format('%Y%m%d');
        var val = this.webStore.getString('gm_' + this.pageName + '_' + key, null);
        var isShow = (!val) ? true : (val != today) ? true : false;
        this.webStore.set('gm_' + this.pageName + '_' + key, today);
        var guideKeys = this.webStore.get('gm_' + this.pageName + '_guide_keys', '');
        if(guideKeys.indexOf(key) < 0) {
            guideKeys += '|' + key;
            this.webStore.set('gm_' + this.pageName + '_guide_keys', guideKeys);
        }
        return isShow;
    }
};
