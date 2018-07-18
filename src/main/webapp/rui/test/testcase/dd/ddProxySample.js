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
	// The first two instances will share a proxy
	// element, created automatically by the utility.
	// This element will be resized at drag time so
	// that it matches the size of the source element.
	// It is configured by default to have a 2 pixel
	// grey border.
	dd = new Rui.dd.LDDProxy("dd-demo-1");
	dd2 = new Rui.dd.LDDProxy("dd-demo-2");

	// The third instance has a dedicated custom proxy
	dd3 = new Rui.dd.LDDProxy("dd-demo-3", "default", {

		// Define a custom proxy element.  It will be
		// created if not already on the page.
		dragElId: "dd-demo-3-proxy",

		// When a drag starts, the proxy is normally
		// resized.  Turn this off so we can keep a
		// fixed sized proxy.
		resizeFrame: false
	});
	assert(true);
}
/*</b>*/

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}