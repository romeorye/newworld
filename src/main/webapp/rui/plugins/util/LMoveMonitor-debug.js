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
 * 특정 브라우져에서만 작동하는 onmove 이벤트를 타이머로 구현한 클래스
 * @module util
 * @namespace Rui.util
 * @class LMoveMonitor
 * @plugin
 * @constructor LMoveMonitor
 * @param {Object} oConfig The intial LMoveMonitor.
 */
Rui.util.LMoveMonitor = function() {
    this.createEvent('move');
    this.init();
};

Rui.extend(Rui.util.LMoveMonitor, Rui.util.LEventProvider, {

    /**
    * @description 모니터할 dom 객체 배열
    * @property domList
    * @private
    * @type {Array}
    */
    domList: [],

    /**
    * @description 객체의 움직임 여부를 체크하는 시간
    * @property interval
    * @private
    * @type {int}
    */
    interval: 50,

    /**
    * @description 객체를 초기화하는 메소드
    * @method init
    * @protected
    * @return void
    */
    init: function() {
        setTimeout(Rui.util.LFunction.createDelegate(this.checkMove, this), this.interval);
    },

    /**
    * @description 이동여부를 체크하는 메소드
    * @method checkMove
    * @protected
    * @return void
    */
    checkMove: function() {
        for(var i = 0 ; i < this.domList.length; i++) {
            if(this.domList[i].dom.offsetTop != this.domList[i].offsetTop || this.domList[i].dom.offsetLeft != this.domList[i].offsetLeft) {
                var params = { 
                    target: this.domList[i].dom, 
                    clientX: this.domList[i].dom.offsetLeft, 
                    clientY: this.domList[i].dom.offsetTop 
                };
                this.fireEvent('move', params);
                this.domList[i].offsetLeft = this.domList[i].dom.offsetLeft;
                this.domList[i].offsetTop = this.domList[i].dom.offsetTop;
            }
        }
        setTimeout(Rui.util.LFunction.createDelegate(this.checkMove, this), this.interval);
    },

    /**
    * @description 모니터할 dom 객체를 추가하는 메소드 
    * @method add
    * @param {HTMLElement} dom 모니터할 dom 객체
    * @return void
    */
    add: function(dom) {
        dom = (typeof dom == 'string') ? document.getElementById(dom) : dom;
        this.domList.push({
            dom: dom,
            offsetTop: dom.offsetTop,
            offsetLeft: dom.offsetLeft
        });
        return this;
    },

    /**
    * @description 등록된 dom 객체를 삭제하는 메소드 
    * @method remove
    * @param {HTMLElement} dom 삭제할 dom 객체
    * @return void
    */
    remove: function(dom) {
        for(var i = 0 ; i < this.domList.length ; i++) {
            if(this.domList[i].dom === dom) {
                this.domList[i] = null;
                i--;
            }
        }
        return this;
    }
});
