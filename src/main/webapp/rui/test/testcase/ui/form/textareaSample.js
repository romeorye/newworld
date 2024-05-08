setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testSetVisibilityMode(){
	col1TextArea.setVisibilityMode(false);
}

function testValid(){
	col1TextArea.valid();
}

function testInvalid(){
	col1TextArea.invalid();
}

function testFocus(){
	col1TextArea.focus();
}

function testBlur(){
	col1TextArea.blur();
}

function testSetWidth(){
	col1TextArea.setWidth('30px');
}

function testGetWidth(){
	Rui.log(col1TextArea.getWidth());
}

function testSetEditable(){
	col1TextArea.setEditable(false);
}

function testHide(){
	col1TextArea.hide();
}

function testShow(){
	col1TextArea.show();
}

function testEnable(){
	col1TextArea.enable();
}

function testDisable(){
	col1TextArea.disable();
}

function noTestDestroy(){
	col1TextArea.destroy();
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}