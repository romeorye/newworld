setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testSetRemove(){
	//providerTests : testSetRemove 작동 여부
	p.set('aaa', 'data');
	Rui.log("설정한 aaa값 : " + p.get('aaa'));
	assertEquals(p.get('aaa'), 'data');
	p.remove('aaa');
	Rui.log("remove후 aaa값 : " + Rui.util.LObject.isUndefined(p.get('aaa')));
	assertTrue(Rui.util.LObject.isUndefined(p.get('aaa')));
}

function testManager(){
	//providerTests : testManager 작동 여부                
	m.set('ccc', '1');
	Rui.log("설정한 cookie ccc값 : " + m.get('ccc'));
	assertEquals(m.get('ccc'), '1');
	m.remove('ccc');
	Rui.log("remove후 cookie ccc값 : " + Rui.util.LObject.isUndefined(m.get('ccc')));
	assertTrue(Rui.util.LObject.isUndefined(m.get('ccc')));
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}