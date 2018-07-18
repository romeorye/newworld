setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************

function testGetValue() {
	Rui.log(col1TextBox.getValue());
}

function testSetValue() {
	col1TextBox.setValue('12345678');
}

function testEnable(){
	col1TextBox.enable();
}

function testDisable(){
	col1TextBox.disable();
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}