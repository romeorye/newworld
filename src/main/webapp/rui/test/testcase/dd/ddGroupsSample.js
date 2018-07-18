setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testDD(){
	/*<b>*/
	// slots
	slots[0] = new Rui.dd.LDDTarget("t1", "topslots");
	slots[1] = new Rui.dd.LDDTarget("t2", "topslots");
	slots[2] = new Rui.dd.LDDTarget("b1", "bottomslots");
	slots[3] = new Rui.dd.LDDTarget("b2", "bottomslots");
	slots[4] = new Rui.dd.LDDTarget("b3", "bottomslots");
	slots[5] = new Rui.dd.LDDTarget("b4", "bottomslots");

	// players
	players[0] = new Rui.dd.LDDPlayer("pt1", "topslots");
	players[1] = new Rui.dd.LDDPlayer("pt2", "topslots");
	players[2] = new Rui.dd.LDDPlayer("pb1", "bottomslots");
	players[3] = new Rui.dd.LDDPlayer("pb2", "bottomslots");
	players[4] = new Rui.dd.LDDPlayer("pboth1", "topslots");
	players[4].addToGroup("bottomslots");
	players[5] = new Rui.dd.LDDPlayer("pboth2", "topslots");
	players[5].addToGroup("bottomslots");

	LDDM.mode = document.getElementById("ddmode").selectedIndex;

	Event.on("ddmode", "change", function(e){
		Rui.dd.LDDM.mode = this.selectedIndex;
	});
	/*</b>*/
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}