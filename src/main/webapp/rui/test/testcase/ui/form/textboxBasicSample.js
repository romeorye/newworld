setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){

}

//**************test function 시작*****************
function testSetWidth(){
	col1TextBox.setWidth(30);
}

function testGetWidth(){
	Rui.log(col1TextBox.getWidth());
}

function testSetHeight(){
	col1TextBox.setHeight(20);
}

function testGetHeight(){
	Rui.log(col1TextBox.getHeight());
}

function testFocus(){
	col1TextBox.focus();
}

function testBlur(){
	col1TextBox.blur();
}

function testIsValid(){
	Rui.log(col1TextBox.isValid());
}

function testValid(){
	col1TextBox.valid();
}

function testInvalid(){
	col1TextBox.invalid();
}

function testIsExpand(){
	Rui.log(col1TextBox.isExpand());
}

function testClearFilter(){
	col1TextBox.clearFilter();
}

function testGetValue(){
	Rui.log(col1TextBox.getValue());
}

function testGetDisplayValue(){
	Rui.log(col1TextBox.getDisplayValue());
}

function testSetValue(){
	col1TextBox.setValue('');
}

function testGetDataSet(){
	Rui.log(col1TextBox.getDataSet());
}

function testSetEditable(){
	col1TextBox.setEditable(false);
}



function noTestDestroy(){
	col1TextBox.destroy();
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