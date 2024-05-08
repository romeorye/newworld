setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){               
	debugger; 
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){                
	debugger; 
}
//**************test function 시작*****************

function testAnimateMethod(){
	debugger; 
	assertEquals(anim.animate(), true);
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
	debugger; }