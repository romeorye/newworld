setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testDD(){
	/*<b>*/
	dd = new Rui.dd.LDD("dd-demo-1");

	// Configure one or more child element as a drag handle
	dd.setHandleElId("dd-handle-1a");
	dd.setHandleElId("dd-handle-1b");

	dd2 = new Rui.dd.LDD("dd-demo-2");
	dd2.setHandleElId("dd-handle-2");

	dd3 = new Rui.dd.LDD("dd-demo-3");
	dd3.setHandleElId("dd-handle-3a");

	// A handle that is not child of the source element
	dd3.setOuterHandleElId("dd-handle-3b");
	assert(true);
	/*</b>*/
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}