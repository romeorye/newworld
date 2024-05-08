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
     * 여러개의 패널이 걸쳐있을 경우 focus상태를 관리하는데 이용
    * @namespace Rui.ui
    * @plugin
    * @class LPanelManager
    * @constructor
    * @param {Array} Panels Optional. A collection of Panels to register 
    * with the manager.
    * @param {Object} userConfig  The object literal representing the user 
    * configuration of the LPanelManager
    */
    Rui.ui.LPanelManager = function (userConfig) {
        this.init(userConfig);
    };

    var Overlay = Rui.ui.LPanel,
        Event = Rui.util.LEvent,
        Dom = Rui.util.LDom,
        Config = Rui.ui.LConfig,
        LCustomEvent = Rui.util.LCustomEvent,
        LPanelManager = Rui.ui.LPanelManager;

    /**
    * The CSS class representing a focused Overlay
    * @property CSS_FOCUSED
    * @private
    * @static
    * @final
    * @type String
    */
    LPanelManager.CSS_FOCUSED = "focused";

    LPanelManager.prototype = {

        /**
        * The class's constructor function
        * @property contructor
        * @private
        * @type Function
        */
        constructor: LPanelManager,

        /**
        * The array of Overlays that are currently registered
        * @property overlays
        * @private
        * @type Rui.ui.LOverlay[]
        */
        overlays: null,

        /**
        * Initializes the default configuration of the LPanelManager
        * @method initDefaultConfig
        * @private
        */
        initDefaultConfig: function () {
            /**
            * The collection of registered Overlays in use by 
            * the LPanelManager
            * @config overlays
            * @type Rui.ui.LOverlay[]
            * @default null
            */
            this.cfg.addProperty("overlays", { suppressEvent: true } );

            /**
            * The default DOM event that should be used to focus an Overlay
            * @config focusevent
            * @type String
            * @default "mousedown"
            */
            this.cfg.addProperty("focus", { value: "mousedown" } );
        },

        /**
        * Initializes the LPanelManager
        * @method init
        * @private
        * @param {Overlay[]} overlays Optional. A collection of Overlays to 
        * register with the manager.
        * @param {Object} userConfig  The object literal representing the user 
        * configuration of the LPanelManager
        */
        init: function (userConfig) {

            /**
            * The LPanelManager's Config object used for monitoring 
            * configuration properties.
            * @property cfg
            * @type Config
            */
            this.cfg = new Config(this);

            this.initDefaultConfig();

            if (userConfig) {
                this.cfg.applyConfig(userConfig, true);
            }
            this.cfg.fireQueue();

            /**
            * The currently activated Overlay
            * @property activeOverlay
            * @private
            * @type Rui.ui.LOverlay
            */
            var activeOverlay = null;

            /**
            * Returns the currently focused Overlay
            * @method getActive
            * @return {Overlay} The currently focused Overlay
            */
            this.getActive = function () {
                return activeOverlay;
            };

            /**
            * Focuses the specified Overlay
            * @method focus
            * @param {Overlay} overlay The Overlay to focus
            * @param {String} overlay The id of the Overlay to focus
            */
            this.focus = function (overlay) {
                var o = this.find(overlay);
                if (o) {
                    o.focus();
                }
            };

            /**
            * Removes the specified Overlay from the manager
            * @method remove
            * @param {Overlay} overlay The Overlay to remove
            * @param {String} overlay The id of the Overlay to remove
            */
            this.remove = function (overlay) {

                var o = this.find(overlay), 
                        originalZ;

                if (o) {
                    if (activeOverlay == o) {
                        activeOverlay = null;
                    }

                    var bDestroyed = (o.element === null && o.cfg === null) ? true : false;

                    if (!bDestroyed) {
                        // Set it's zindex so that it's sorted to the end.
                        originalZ = Dom.getStyle(o.element, "zIndex");
                        o.cfg.setProperty("zIndex", -1000, true);
                    }

                    this.overlays.sort(this.compareZIndexDesc);
                    this.overlays = this.overlays.slice(0, (this.overlays.length - 1));

                    o.unOn('hide', o.blur, o);
                    o.unOn('destroy', this._onOverlayDestroy, o);
                    o.unOn('focus', this._onOverlayFocusHandler, o);
                    o.unOn('blue', this._onOverlayBlurHandler, o);

                    if (!bDestroyed) {
                        Event.removeListener(o.element, this.cfg.getProperty("focus"), this._onOverlayElementFocus);
                        o.cfg.setProperty("zIndex", originalZ, true);
                        o.cfg.setProperty("manager", null);
                    }

                    /* _managed Flag for custom or existing. Don't want to remove existing */
                    /*
                    if (o.focusEvent._managed) { o.focusEvent = null; }
                    if (o.blurEvent._managed) { o.blurEvent = null; }

                    if (o.focus._managed) { o.focus = null; }
                    if (o.blur._managed) { o.blur = null; }
                    */
                }
            };

            /**
            * Removes focus from all registered Overlays in the manager
            * @method blurAll
            */
            this.blurAll = function () {

                var nOverlays = this.overlays.length, i;

                if (nOverlays > 0) {
                    i = nOverlays - 1;
                    do {
                        this.overlays[i].blur();
                    }
                    while(i--);
                }
            };

            /**
             * Updates the state of the LPanelManager and overlay, as a result of the overlay
             * being blurred.
             * 
             * @method _manageBlur
             * @param {Overlay} overlay The overlay instance which got blurred.
             * @protected
             */
            this._manageBlur = function (overlay) {
                
                if(typeof overlay === "undefined") return; 
                
                var changed = false;
                if (activeOverlay == overlay) {
                    Dom.removeClass(activeOverlay.element, LPanelManager.CSS_FOCUSED);
                    activeOverlay = null;
                    changed = true;
                }
                return changed;
            };

            /**
             * Updates the state of the LPanelManager and overlay, as a result of the overlay 
             * receiving focus.
             *
             * @method _manageFocus
             * @param {Overlay} overlay The overlay instance which got focus.
             * @protected
             */
            this._manageFocus = function(overlay) {
                
                if(typeof overlay === "undefined") return; 
                
                var changed = false;
                if (activeOverlay != overlay) {
                    if (activeOverlay) {
                        activeOverlay.blur();
                    }
                    activeOverlay = overlay;
                    this.bringToTop(activeOverlay);
                    Dom.addClass(activeOverlay.element, LPanelManager.CSS_FOCUSED);
                    changed = true;
                }
                return changed;
            };

            var overlays = this.cfg.getProperty("overlays");

            if (! this.overlays) {
                this.overlays = [];
            }

            if (overlays) {
                this.register(overlays);
                this.overlays.sort(this.compareZIndexDesc);
            }
        },

        /**
        * @method _onOverlayElementFocus
        * @description Event handler for the DOM event that is used to focus 
        * the Overlay instance as specified by the "focusevent" 
        * configuration property.
        * @private
        * @param {Event} p_oEvent Object representing the DOM event 
        * object passed back by the event utility (Event).
        */
        _onOverlayElementFocus: function (p_oEvent) {

            var oTarget = Event.getTarget(p_oEvent),
                oClose = this.close;

            if (oClose && (oTarget == oClose || Dom.isAncestor(oClose, oTarget))) {
                this.blur();
            } else {
                this.focus();
            }
        },

        /**
        * @method _onOverlayDestroy
        * @description "destroy" event handler for the Overlay.
        * @private
        * @param {String} p_sType String representing the name of the event  
        * that was fired.
        * @param {Array} p_aArgs Array of arguments sent when the event 
        * was fired.
        * @param {Overlay} p_oOverlay Object representing the overlay that 
        * fired the event.
        */
        _onOverlayDestroy: function (p_sType, p_aArgs, p_oOverlay) {
            this.remove(p_oOverlay);
        },

        /**
        * @method _onOverlayFocusHandler
        *
        * focusEvent Handler, used to delegate to _manageFocus with the 
        * correct arguments.
        *
        * @private
        * @param {String} p_sType String representing the name of the event  
        * that was fired.
        * @param {Array} p_aArgs Array of arguments sent when the event 
        * was fired.
        * @param {Overlay} p_oOverlay Object representing the overlay that 
        * fired the event.
        */
        _onOverlayFocusHandler: function(p_sType, p_aArgs, p_oOverlay) {            
            this._manageFocus(p_oOverlay);
        },

        /**
        * @method _onOverlayBlurHandler
        *
        * blurEvent Handler, used to delegate to _manageBlur with the 
        * correct arguments.
        *
        * @private
        * @param {String} p_sType String representing the name of the event  
        * that was fired.
        * @param {Array} p_aArgs Array of arguments sent when the event 
        * was fired.
        * @param {Overlay} p_oOverlay Object representing the overlay that 
        * fired the event.
        */
        _onOverlayBlurHandler: function(p_sType, p_aArgs, p_oOverlay) {
            this._manageBlur(p_oOverlay);
        },

        /**
         * Subscribes to the Overlay based instance focusEvent, to allow the LPanelManager to
         * monitor focus state.
         * 
         * If the instance already has a focusEvent (e.g. LMenu), LPanelManager will on 
         * to the existing focusEvent, however if a focusEvent or focus method does not exist
         * on the instance, the _bindFocus method will add them, and the focus method will 
         * update the LPanelManager's state directly.
         * 
         * @method _bindFocus
         * @param {Overlay} overlay The overlay for which focus needs to be managed
         * @protected
         */
        _bindFocus: function(overlay) {
            var mgr = this;
           
            overlay.on('focus', mgr._onOverlayFocusHandler, this, true);
            
            Event.on(overlay.element, mgr.cfg.getProperty("focus"), mgr._onOverlayElementFocus, null, overlay);
            overlay.focus = function () {
                if (mgr._manageFocus(this)) {
                    // For Panel/Dialog
                    if (this.cfg.getProperty("visible") && this.focusFirst) {
                        this.focusFirst();
                        }
                     this.fireEvent('focus', {target: this});
               }
            };
            overlay.focus._managed = true;
        },

        /**
         * Subscribes to the Overlay based instance's blurEvent to allow the LPanelManager to
         * monitor blur state.
         *
         * If the instance already has a blurEvent (e.g. LMenu), LPanelManager will on 
         * to the existing blurEvent, however if a blurEvent or blur method does not exist
         * on the instance, the _bindBlur method will add them, and the blur method 
         * update the LPanelManager's state directly.
         *
         * @method _bindBlur
         * @param {Overlay} overlay The overlay for which blur needs to be managed
         * @protected
         */
        _bindBlur: function(overlay) {
            var mgr = this;

            overlay.on('blur', mgr._onOverlayBlurHandler, this, true);

            overlay.blur = function () {
                if (mgr._manageBlur(this)) {
                    this.fireEvent('blur', {target: this}); 
                    }
            };
            overlay.blur._managed = true;

            overlay.on('hide', overlay.blur, this, true);
        },

        /**
         * Subscribes to the Overlay based instance's destroyEvent, to allow the Overlay
         * to be removed for the LPanelManager when destroyed.
         * 
         * @method _bindDestroy
         * @param {Overlay} overlay The overlay instance being managed
         * @protected
         */
        _bindDestroy: function(overlay) {
            var mgr = this;
            overlay.on('destroy', mgr._onOverlayDestroy, mgr, true); 
        },

        /**
         * Ensures the zIndex configuration property on the managed overlay based instance
         * is set to the computed zIndex value from the DOM (with "auto" translating to 0).
         *
         * @method _syncZIndex
         * @param {Overlay} overlay The overlay instance being managed
         * @protected
         */
        _syncZIndex: function(overlay) {
            var zIndex = Dom.getStyle(overlay.element, "zIndex");
            if (!isNaN(zIndex)) {
                overlay.cfg.setProperty("zIndex", parseInt(zIndex, 10));
            } else {
                overlay.cfg.setProperty("zIndex", 0);
            }
        },

        /**
        * Registers an Overlay or an array of Overlays with the manager. Upon 
        * registration, the Overlay receives functions for focus and blur, 
        * along with CustomEvents for each.
        *
        * @method register
        * @param {Overlay} overlay  An Overlay to register with the manager.
        * @param {Overlay[]} overlay  An array of Overlays to register with 
        * the manager.
        * @return {boolean} true if any Overlays are registered.
        */
        register: function (overlay) {

            var registered = false,
                i,
                n;

            if (overlay instanceof Overlay) {

                overlay.cfg.addProperty("manager", { value: this } );
               // overlay.useType = 1; 

                this._bindFocus(overlay);
                this._bindBlur(overlay);
                this._bindDestroy(overlay);
                this._syncZIndex(overlay);

                this.overlays.push(overlay);
                this.bringToTop(overlay);

                registered = true;

            } else if (overlay instanceof Array) {

                for (i = 0, n = overlay.length; i < n; i++) {
                    registered = this.register(overlay[i]) || registered;
                }

            }

            return registered;
        },

        /**
        * Places the specified Overlay instance on top of all other 
        * Overlay instances.
        * @method bringToTop
        * @param {Rui.ui.LOverlay} p_oOverlay Object representing an 
        * Overlay instance.
        * @param {String} p_oOverlay String representing the id of an 
        * Overlay instance.
        */        
        bringToTop: function (p_oOverlay) {

            var oOverlay = this.find(p_oOverlay),
                nTopZIndex,
                oTopOverlay,
                aOverlays;

            if (oOverlay) {

                aOverlays = this.overlays;
                aOverlays.sort(this.compareZIndexDesc);

                oTopOverlay = aOverlays[0];

                if (oTopOverlay) {
                    nTopZIndex = Dom.getStyle(oTopOverlay.element, "zIndex");

                    if (!isNaN(nTopZIndex)) {

                        var bRequiresBump = false;

                        if (oTopOverlay !== oOverlay) {
                            bRequiresBump = true;
                        } else if (aOverlays.length > 1) {
                            var nNextZIndex = Dom.getStyle(aOverlays[1].element, "zIndex");
                            // Don't rely on DOM order to stack if 2 overlays are at the same zindex.
                            if (!isNaN(nNextZIndex) && (nTopZIndex == nNextZIndex)) {
                                bRequiresBump = true;
                            }
                        }

                        if (bRequiresBump) {
                            oOverlay.cfg.setProperty("zindex", (parseInt(nTopZIndex, 10) + 2));
                        }
                    }
                    aOverlays.sort(this.compareZIndexDesc);
                }
            }
        },

        /**
        * Attempts to locate an Overlay by instance or ID.
        * @method find
        * @param {Overlay} overlay  An Overlay to locate within the manager
        * @param {String} overlay  An Overlay id to locate within the manager
        * @return {Overlay} The requested Overlay, if found, or null if it 
        * cannot be located.
        */
        find: function (overlay) {

            var isInstance = overlay instanceof Overlay,
                overlays = this.overlays,
                n = overlays.length,
                found = null,
                o,
                i;

            if (isInstance || typeof overlay == "string") {
                for (i = n-1; i >= 0; i--) {
                    o = overlays[i];
                    if ((isInstance && (o === overlay)) || (o.id == overlay)) {
                        found = o;
                        break;
                    }
                }
            }

            return found;
        },

        /**
        * Used for sorting the manager's Overlays by z-index.
        * @method compareZIndexDesc
        * @private
        * @return {Number} 0, 1, or -1, depending on where the Overlay should 
        * fall in the stacking order.
        */
        compareZIndexDesc: function (o1, o2) {

            var zIndex1 = (o1.cfg) ? o1.cfg.getProperty("zIndex") : null, // Sort invalid (destroyed)
                zIndex2 = (o2.cfg) ? o2.cfg.getProperty("zIndex") : null; // objects at bottom.

            if (zIndex1 === null && zIndex2 === null) {
                return 0;
            } else if (zIndex1 === null){
                return 1;
            } else if (zIndex2 === null) {
                return -1;
            } else if (zIndex1 > zIndex2) {
                return -1;
            } else if (zIndex1 < zIndex2) {
                return 1;
            } else {
                return 0;
            }
        },

        /**
        * Shows all Overlays in the manager.
        * @method showAll
        */
        showAll: function () {
            var overlays = this.overlays,
                n = overlays.length,
                i;

            for (i = n - 1; i >= 0; i--) {
                overlays[i].show();
            }
        },

        /**
        * Hides all Overlays in the manager.
        * @method hideAll
        */
        hideAll: function () {
            var overlays = this.overlays,
                n = overlays.length,
                i;

            for (i = n - 1; i >= 0; i--) {
                overlays[i].hide();
            }
        },

        /**
        * Returns a string representation of the object.
        * @method toString
        * @return {String} The string representation of the LPanelManager
        */
        toString: function () {
            return "LPanelManager";
        }
    };
}());
