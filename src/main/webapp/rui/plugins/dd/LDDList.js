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

(function() {
    Rui.namespace('Rui.dd');

    var Dom = Rui.util.LDom;
    var Event = Rui.util.LEvent;
    var LDDM = Rui.dd.LDragDropManager;

    /**
     * @namespace Rui.dd
     * @plugin
     * @class LDDList
     * @extends Rui.dd.LDDProxy
     * @constructor
     * @param {String} id 드랍 대상인 element의 id
     * @param {String} group 연관된 LDragDrop object들의 그룹
     * @param {object} attributes 설정 가능한 attribute를 포함한 object
     *                 LDragDrop에 추가적으로 LDDList에 대해 유효한 속성들: 
     */
    Rui.dd.LDDList = function(config) {
        Rui.dd.LDDList.superclass.constructor.call(this, config);

        this.isProxy = Rui.applyIf(config.isProxy, {
            isProxy: true
        });
        this.logger = this.logger || Rui;
        var el = this.getDragEl();
        Dom.setStyle(el, 'opacity', 0.67); 

        this.goingUp = false;
        this.lastY = 0;
    };

    Rui.extend(Rui.dd.LDDList, Rui.dd.LDDProxy, {
        startDrag: function(x, y) {
            this.logger.log(this.id + ' startDrag');

            var dragEl = this.getDragEl();
            var clickEl = this.getEl();
            Dom.setStyle(clickEl, 'visibility', 'hidden');

            if(this.isProxy)
                dragEl.innerHTML = clickEl.innerHTML;

            Dom.setStyle(dragEl, 'color', Dom.getStyle(clickEl, 'color'));
            Dom.setStyle(dragEl, 'backgroundColor', Dom.getStyle(clickEl, 'backgroundColor'));
            Dom.setStyle(dragEl, 'border', '2px solid gray');
        },

        endDrag: function(e) {
            var srcEl = this.getEl();
            var proxy = this.getDragEl();

            Dom.setStyle(proxy, 'visibility', '');
            var a = new Rui.fx.LMotionAnim({
                el: proxy,
                attributes: {
                    points: { 
                        to: Dom.getXY(srcEl)
                    }
                },
                duration: 0.2,
                method: Rui.fx.LEasing.easeOut 
            });
            var proxyid = proxy.id;
            var thisid = this.id;


            a.on('complete', function() {
                Dom.setStyle(proxyid, 'visibility', 'hidden');
                Dom.setStyle(thisid, 'visibility', '');
            });
            a.animate();
        },

        onDragDrop: function(e, id) {


            if (LDDM.interactionInfo.drop.length === 1) {

                var pt = LDDM.interactionInfo.point; 

                var region = LDDM.interactionInfo.sourceRegion; 



                if (!region.intersect(pt)) {
                    var destEl = Dom.get(id);
                    var destDD = LDDM.getDDById(id);
                    destEl.appendChild(this.getEl());
                    destDD.isEmpty = false;
                    LDDM.refreshCache();
                }

            }
        },

        onDrag: function(e) {

            var y = Event.getPageY(e);
            if (y < this.lastY) {
                this.goingUp = true;
            } else if (y > this.lastY) {
                this.goingUp = false;
            }
            this.lastY = y;
        },

        onDragOver: function(e, id) {
            var srcEl = this.getEl();
            var destEl = Dom.get(id);


            if (destEl.nodeName.toLowerCase() == 'li') {
                var p = destEl.parentNode;
                if (this.goingUp) {
                    p.insertBefore(srcEl, destEl); 
                } else {
                    p.insertBefore(srcEl, destEl.nextSibling); 
                }
                LDDM.refreshCache();
            }
        }
    });

})();
