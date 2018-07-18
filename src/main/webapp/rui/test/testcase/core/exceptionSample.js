
var setUpPageStatus = 'complete';
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testException(){
	try {
		Rui.getConfig().set('$.core.logger.show', [true]);
		new Test.Cls('aa').test();
	} 
	catch (e) {
		Rui.log(e.message + ' : ' + Rui.getException(e).getStackTrace());
		assert(true);
	}
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}
