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
	col1TimeBox.setVisibilityMode(false);
}

function testSetValue(){
	col1TimeBox.setValue('0221');
}

function testGetValue(){
	Rui.log(col1TimeBox.getValue());
}

function testValid(){
	col1TimeBox.valid();
}

function testInvalid(){
	col1TimeBox.invalid();
}

function testFocus(){
	col1TimeBox.focus();
}

function testBlur(){
	col1TimeBox.blur();
}

function testSetWidth(){
	col1TimeBox.setWidth(130);
}

function testGetWidth(){
	Rui.log(col1TimeBox.getWidth());
}

function testSetEditable(){
	col1TimeBox.setEditable(false);
}

function testDisable(){
	col1TimeBox.disable();
}

function testEnable(){
	col1TimeBox.enable();
}

function testShow(){
	col1TimeBox.show();
}

function testHide(){
	col1TimeBox.hide();
}

function noTestDestroy(){
	col1TimeBox.destroy();
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}
