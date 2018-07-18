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
	dd1 = new Rui.dd.LDDRegion('dd-demo-1', '', {
		cont: 'dd-demo-canvas3'
	});
	dd2 = new Rui.dd.LDDRegion('dd-demo-2', '', {
		cont: 'dd-demo-canvas2'
	});
	dd3 = new Rui.dd.LDDRegion('dd-demo-3', '', {
		cont: 'dd-demo-canvas1'
	});
	/*</b>*/
	assert(true);
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}