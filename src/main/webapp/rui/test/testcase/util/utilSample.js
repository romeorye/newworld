setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testCamelToHungarian(){
	Rui.get("camel").setValue("aaaBbbbCcc");
	convertToHungarian();
}

function testLpad() {
	var aaa = '1';
	aaa = Rui.util.LString.lPad(aaa, '0', 7);
	Rui.log(aaa);
}

function testRpad() {
	var aaa = '1';
	aaa = Rui.util.LString.rPad(aaa, '0', 7);
	new Date().format('%x');
	Rui.log(aaa);
}

function testRound() {
	Rui.log(Rui.util.LNumber.round(10.171, 1));
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}