/*!
 * bgSlider - background image slide with jQuery
 *   http://crossxp.tistory.com/bgSlider
 *
 * Copyright (c) 2013 Feb CrossXP (http://crossxp.tistory.com)
 *
 * Built on top of the jQuery library
 *   http://jquery.com
 *
 * Inspired by the "jCarousel" by sorgalla
 *   http://sorgalla.com/jcarousel/
 */
(function($){
	//default configuration properties
	var defaults = {
		item:2, 
		interval:1000, 
		speed:"slow", 
		easing:"swing", 
		vertial:false, 
		disabled:false,
		width:"auto",
		height:"auto"
	};

	/**
	 * The bgSlider Object.
	 *
	 * @contructor
	 * @class bgSlider
	 * @param e {HTMLElement} The element to create the bgSlider for.
	 * @param o {Object} A set of key/value pairs to set as configuration properties.
	 */
	var F = $.bgSlider = function(e,o){
		var opts = null;
		var current = null;
		var width = 0;
		var height = 0;
		var timer = null;
		var idx = 0;

		this.setup(e,o);
	}

	F.fn = F.prototype = {
		bgSlider: '1.0.1'
	};

	F.fn.extend = F.extend = $.extend;

	F.fn.extend({
		/**
		 * Setup the bgSlider Configurations.
		 *
		 * @method setup
		 * @return undefined
		 */
		setup:function(e,o){
			this.opts = $.extend(true,{},defaults,o);
			this.opts.easing = (this.opts.easing=="auto") ? "swing" : this.opts.easing;
			this.current = e;
			this.width = (this.opts.width=="auto") ? parseInt(e.css("width")) : parseInt(this.opts.width);
			this.height = (this.opts.height=="auto") ? parseInt(e.css("height")) : parseInt(this.opts.height);
			this.timer = null;
			this.idx=1;

			this.callback();			
		},

		/**
		 * Call back function
		 *
		 * @method callback
		 * @return undefined
		 */
		callback:function(){
			var that = this;
			var call = F.transition.horizon;
			call = (this.opts.vertical==true) ? F.transition.vertical : call;
			this.timer = setTimeout(function(){call(that)},this.opts.interval);
		},

		reload:function(){
			clearTimeout(this.timer);
			F.transition.disabled(this);
		}
	});

	/**
	 * Create Transition animation.
	 *
	 * @class bgSlider
	 * @method transition
	 */
	F.transition = {
		//Animate for horizon slide
		horizon:function(o){
			var x = parseInt(o.current.css("background-position-x")); 
			var max = -o.width*(o.opts.item-1); 
			var ap = -o.width*o.idx+"px";
			//ie,firefox,opera,safari fix
			x = (!o.current.css("background-position-x")) ? parseInt(o.current.css("background-position").split(" ")[0]) : x;

			if(x<=max){
				o.idx = ap = 0;
			}
			o.idx++;
			
			//ie,firefox,opera,safari fix
			if(!o.current.css("background-position-x")){
				o.current.stop().animate({"background-position":ap},o.opts.speed,o.opts.easing);
			} else {
				o.current.stop().animate({"background-position-x":ap},o.opts.speed,o.opts.easing);
			}
			o.callback();
		},

		//Animate for vertical slide
		vertical:function(o){
			var x = parseInt(o.current.css("background-position-y"));
			var max = -o.height*(o.opts.item-1);
			var ap = -o.height*o.idx+"px";
			//ie,firefox,opera,safari fix
			x = (!o.current.css("background-position-y")) ? parseInt(o.current.css("background-position").split(" ")[1]) : x;

			if(x<=max){
				o.idx = ap = 0;
			}
			o.idx++;

			//ie,firefox,opera,safari fix
			if(!o.current.css("background-position-y")){
				o.current.stop().animate({backgroundPositionY:ap.replace("px","")},o.opts.speed,o.opts.easing);
			} else {
				o.current.stop().animate({"background-position-y":ap},o.opts.speed,o.opts.easing);
			}
			o.callback();
		},

		//Position set to 0 when disabled
		disabled:function(o){
			o.current.stop();
			o.current.css("background-position",'0 0');
			o.idx=1;
		}
	};

	/**
	 * Set slide to enable/disable
	 *
	 * @class bgSlider
	 * @method excute
	 * @return undefined
	 * @param e [String] Element Selector String
	 * @param s [String] Excuting Command
	 */
	F.execute = function(e,s){
		var $this = $(e).data("bgSlider");
		if(s=="disable" && $this.opts.disabled==false){
			$this.opts.disabled=true;
			clearTimeout($this.timer);
			F.transition.disabled($this);
		} else if(s=="enable" && $this.opts.disabled==true){
			$this.opts.disabled=false;
			$this.callback();
		}
	}

    /**
     * Creates a bgSlider for all matched elements.
     *
     * @example $("#mybgSlider").bgSlider();
     * @before <div id="mybgSlider" class="bgSlider-skin-name"></div>
     *
     * @method bgSlider
     * @return jQuery
     * @param o {Hash|String} A set of key/value pairs to set as configuration properties or a method name to call on a formerly created instance.
     */
	$.fn.bgSlider = function(options){
		var instance = $(this).data('bgSlider');
		if(instance){
			if(options){
				var args = [this,options];
				instance.setup.apply(instance,args);
			}
			instance.reload();
		} else {
			instance = $(this).data('bgSlider',new F(this,options));
		}
		return instance;
	}

})(jQuery)

//Add backgroundPositionY cssHookers for ie,firefox,safari,opera
$.cssHooks["backgroundPositionY"] = {
    get: function(e) {
        return e.style.backgroundPosition.split(' ')[1];
    },
    set: function(e,v) {
        var x = e.style.backgroundPosition.split(' ')[0];
        e.style.backgroundPosition = x + ' ' + v;
    }
};