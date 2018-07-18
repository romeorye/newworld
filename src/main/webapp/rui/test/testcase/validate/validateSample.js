setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testValidate(){
	Rui.get("col17").setValue("7");
	Rui.get("col2").setValue("4444");
	button.dom.click();
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}