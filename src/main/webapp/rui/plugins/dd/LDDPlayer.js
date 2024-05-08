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
Rui.namespace('Rui.dd');
/**
 * @namespace Rui.dd
 * @plugin
 * @class LDDPlayer
 * @extends Rui.dd.LDDProxy
 * @constructor
 * @param {String} id 드랍 대상인 element의 id
 * @param {String} group 연관된 LDragDrop object들의 그룹
 * @param {object} attributes 설정 가능한 attribute를 포함한 object
 *                 LDragDrop에 추가적으로 LDDPlayer에 대해 유효한 속성들: 
 */
Rui.dd.LDDPlayer = function(config){
    Rui.dd.LDDPlayer.superclass.constructor.call(this, config);
    this.initPlayer(config);
};
Rui.extend(Rui.dd.LDDPlayer, Rui.dd.LDDProxy, {

    TYPE: 'LDDPlayer',

    initPlayer: function(config){
        if (!config) {
            return;
        }

        var el = this.getDragEl();
        Rui.util.LDom.setStyle(el, 'borderColor', 'transparent');
        Rui.util.LDom.setStyle(el, 'opacity', 0.76);


        this.isTarget = false;

        this.originalStyles = [];

        this.type = Rui.dd.LDDPlayer.TYPE;
        this.slot = null;

        this.startPos = Rui.util.LDom.getXY(this.getEl());
    },

    startDrag: function(x, y){
        var Dom = Rui.util.LDom;

        var dragEl = this.getDragEl();
        var clickEl = this.getEl();

        dragEl.innerHTML = clickEl.innerHTML;
        dragEl.className = clickEl.className;

        Dom.setStyle(dragEl, 'color', Dom.getStyle(clickEl, 'color'));
        Dom.setStyle(dragEl, 'backgroundColor', Dom.getStyle(clickEl, 'backgroundColor'));

        Dom.setStyle(clickEl, 'opacity', 0.1);

        var targets = Rui.dd.LDDM.getRelated(this, true);
        Rui.log(targets.length + ' targets', 'info', 'dd');
        for (var i = 0; i < targets.length; i++) {

            var targetEl = this.getTargetDomRef(targets[i]);

            if (!this.originalStyles[targetEl.id]) {
                this.originalStyles[targetEl.id] = targetEl.className;
            }

            Dom.addClass(targetEl, 'target');
        }
    },

    getTargetDomRef: function(oDD){
        if (oDD.player) {
            return oDD.player.getEl();
        }
        else {
            return oDD.getEl();
        }
    },

    endDrag: function(e){

        Rui.util.LDom.setStyle(this.getEl(), 'opacity', 1);

        this.resetTargets();
    },

    resetTargets: function(){

        var targets = Rui.dd.LDDM.getRelated(this, true);
        for (var i = 0; i < targets.length; i++) {
            var targetEl = this.getTargetDomRef(targets[i]);
            var oldStyle = this.originalStyles[targetEl.id];
            if (oldStyle) {
                Rui.util.LDom.removeClass(targetEl, 'target');
            }
        }
    },

    onDragDrop: function(e, id){

        var oDD;

        if ('string' == typeof id) {
            oDD = Rui.dd.LDDM.getDDById(id);
        }
        else {
            oDD = Rui.dd.LDDM.getBestMatch(id);
        }

        var el = this.getEl();


        if (oDD.player) {

            if (this.slot) {



                if (Rui.dd.LDDM.isLegalTarget(oDD.player, this.slot)) {
                    Rui.log('swapping player positions', 'info', 'dd');
                    Rui.dd.LDDM.moveToEl(oDD.player.getEl(), el);
                    this.slot.player = oDD.player;
                    oDD.player.slot = this.slot;
                }
                else {
                    Rui.log('moving player in slot back to start', 'info', 'dd');
                    Rui.util.LDom.setXY(oDD.player.getEl(), oDD.player.startPos);
                    this.slot.player = null;
                    oDD.player.slot = null;
                }
            }
            else {


                oDD.player.slot = null;
                Rui.dd.LDDM.moveToEl(oDD.player.getEl(), el);
            }
        }
        else {


            if (this.slot) {
                this.slot.player = null;
            }
        }

        Rui.dd.LDDM.moveToEl(el, oDD.getEl());
        this.resetTargets();

        this.slot = oDD;
        this.slot.player = this;
    },

    swap: function(el1, el2){
        var Dom = Rui.util.LDom;
        var pos1 = Dom.getXY(el1);
        var pos2 = Dom.getXY(el2);
        Dom.setXY(el1, pos2);
        Dom.setXY(el2, pos1);
    }

});

