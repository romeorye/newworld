setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************

function testFocus(){
	button3.focus();
}

function testBlur(){
	button3.blur();
}

function testGetLabel(){
	Rui.log(button3.getLabel());
}

function testSetLabel(){
	button3.setLabel('testAutoWidth');
}

function testGetForm(){
	Rui.log(button3.getForm());
}

function testEnable(){
	button3.enable();
}

function testDisable(){
	button3.disable();
}
//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}