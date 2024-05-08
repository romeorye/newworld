setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
/*<b>*/
function testDD(){
	var el = Dom.get("dd-demo-1");
	startPos = Dom.getXY(el);

	dd = new Rui.dd.LDD(el);

	// our custom click validator let's us prevent clicks outside
	// of the circle (but within the element) from initiating a
	// drag.
	dd.clickValidator = function(e){

		// get the screen rectangle for the element
		var el = this.getEl();
		var region = Dom.getRegion(el);

		// get the radius of the largest circle that can fit inside
		// var w = region.right - region.left;
		// var h = region.bottom - region.top;
		// var r = Math.round(Math.min(h, w) / 2);
		//-or- just use a well-known radius
		var r = clickRadius;

		// get the location of the click
		var x1 = Event.getPageX(e), y1 = Event.getPageY(e);

		// get the center of the circle
		var x2 = Math.round((region.right + region.left) / 2);
		var y2 = Math.round((region.top + region.bottom) / 2);


		// I don't want text selection even if the click does not
		// initiate a drag
		Event.preventDefault(e);

		// check to see if the click is in the circle
		return (((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)) <= r * r);
	};

	dd.onDragDrop = function(e, id){
		// center it in the square
		Dom.setXY(this.getEl(), Dom.getXY(id));
	};

	dd.onInvalidDrop = function(e){
		// return to the start position
		// Dom.setXY(this.getEl(), startPos);

		// Animating the move is more intesting
		new Rui.fx.LMotionAnim({
			el: this.id,
			attributes: {
				points: {
					to: startPos
				}
			},
			duration: 0.3,
			method: Rui.fx.LEasing.easeOut
		}).animate();

	};

	dd2 = new Rui.dd.LDDTarget("dd-demo-2");
	assert(true);
}
/*</b>*/

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}