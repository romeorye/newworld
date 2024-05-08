setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************

function testFocusLastest(){
	dataSet.load({ url: "./../../../resources/data/menu.json", method: "get" });
}

function testFocus(){
	tree.focus();
}

function testBlur(){
	tree.blur();
}   

function testShow(){
	tree.show();
}

function testHide(){
	tree.hide();
}         

function testEnable(){
	tree.enable();
}

function testDisable(){
	tree.disable();
}

function noTestDestroy(){
	tree.destroy();
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}