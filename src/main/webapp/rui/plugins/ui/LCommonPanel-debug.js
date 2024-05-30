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
 * LCommonPanel
 * @namespace Rui.ui
 * @class LCommonPanel
 * @constructor LCommonPanel
 * @plugin
 * @param {Object} oConfig The intial LCommonPanel.
 */
Rui.ui.LCommonPanel = function(oConfig) {
    var config = oConfig || {};
    Rui.applyObject(this, config, true);
    this.initComponent();
};

Rui.ui.LCommonPanel.prototype = {

    /**
    * @description 기본 CSS
    * @property CSS_BASIC
    * @private
    * @type {String}
    */
    CSS_BASIC: 'L-common-panel',

    /**
    * @description input 객체의 width
    * @property width
    * @private
    * @type {String}
    */
    width: 100,

    /**
    * @description view render 여부
    * @property isViewRendered
    * @private
    * @type {Boolean}
    */
    isViewRendered: false,
    
    /**
    * @description Dom객체 생성 및 초기화하는 메소드
    * @method initComponent
    * @protected
    * @param {Object} oConfig 환경정보 객체
    * @return void
    */
    initComponent: function(oConfig){
        this.id = this.id || Rui.id();
    },

    /**
    * @description view를 초기화한다.
    * @method initView
    * @protected
    * @param {Object} oConfig 환경정보 객체
    * @return void
    */
    initView: function(oConfig){
        this.isViewRendered = true;
    },

    /**
    * @description 객체 render
    * @method render
    * @private
    * @return {void}
    */
    render: function(el) {
        this.el = Rui.get(el);
        this.el.addClass(this.CSS_BASIC);
        this.afterRender(this.el);
    },
    
    /**
    * @description render후 호출되는 메소드
    * @method afterRender
    * @protected
    * @param {Rui.LElement} container 부모 el 객체
    * @return void
    */
    afterRender: function(el) {
        this.initView();
    }
};

