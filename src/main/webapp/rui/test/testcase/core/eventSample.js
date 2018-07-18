
var setUpPageStatus = 'complete';
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testDD(){
	Rui.util.LEvent.addListener(Rui.browser.msie ? document.body : document, "mousedown", function(e){
		Rui.log("dd-demo-2");
	}, this, true);
	Rui.util.LEvent.addListener(Rui.browser.msie ? document.body : document, "mousedown", function(e){
		Rui.log("dd-demo-2-2");
	}, this, true);
	Rui.util.LEvent.addListener(Rui.browser.msie ? document.body : document, "mousedown", function(e){
		Rui.log("dd-demo-1");
	}, this, true);
	assert(true);
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}
