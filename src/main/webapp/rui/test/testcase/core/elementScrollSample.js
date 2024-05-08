var setUpPageStatus = 'complete';

function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testGetScrollLeftTop(){
	getScrollLeftTop();
	assert(true);
}

function testSetScrollLeftTop(){
	setScrollLeftTop();
	assert(true);
}

function testMoveScrollToTarget(){
	moveScrollToTarget();
	assert(true);
}

function testMoveYOnlyScroll(){
	moveYOnlyScroll();
	assert(true);
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}
