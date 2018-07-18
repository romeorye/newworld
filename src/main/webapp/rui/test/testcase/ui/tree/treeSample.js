setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************

function testFocusLastest(){
	dataSet.load({ url: "./../../../resources/data/menu.json", method: "get" });
}

function testFocus(){
	tree.focus();
}

function testBlur(){
	tree.blur();
}   

function testShow(){
	tree.show();
}

function testDisable(){	
	tree.disable();
}

function testHide(){
	tree.hide();
}         

function testEnable(){
	tree.enable();
}

function noTestDestroy(){
	tree.destroy();
}

function testAddTopNode(){
	tree.addTopNode('test'); 
}

/*
function testAddChildNode(){
	// test용 
	var row = tree.addChildNode('test',false,nodeIdx++);    
	var newRecord = dataSet.getAt(row);
	newRecord.set("seq",200 + nodeIdx);

}
*/
//function testSetDataSet() {
//	tree.setDataSet(dataSet);
//}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}