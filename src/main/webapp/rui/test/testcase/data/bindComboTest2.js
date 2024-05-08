setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************                        
function testBind() {
	info('bindTests : testBind 작동 여부');
	dataBind();
	assertEquals(document.getElementById('col1').value, 'Kaden Q. Delacruz');
}

function testDataSetFirst() {
	info('bindTests : dataSet.first() 작동 여부');                
	moveDataSetFirst();            
	assertEquals(dataSet.getRow(), 0);
}

function testDataSetLast() {
	info('bindTests : testDataSetLast 작동 여부');            
	moveDataSetLast();                
	assertEquals(dataSet.getRow(), dataSet.getCount() - 1);
}

function testDataSetPrevious() {
	info('bindTests : testDataSetPrevious 작동 여부');
	var moveCount = moveDataSetPrevious();
	assertEquals(moveCount, 1);
}

function testDataSetNext() {
	info('bindTests : testDataSetNext 작동 여부');
	var moveCount = moveDataSetNext();
	assertEquals(moveCount, 1);
}

function testSetValue(){
	info('bindTests : setValue 작동 여부');
	assertEquals(setValue(),"");
}

function testRebind() {
	bind.rebind();
}

function testSetData() {
	bind.setDataSet(dataSet);
}

function testAdd(){
	var row = dataSet.newRecord();
	//dataSet.setNameValue(row, 'col4', 'R2');
}

function testDisable() {                
	Rui.select('input, textarea, select, div.L-form-field').disable();
}

function testEnable() {
	Rui.select('input, textarea, select, div.L-form-field').enable();
}

function testValidate() {
	var vm = new Rui.validate.LValidatorManager({
		validators:[
		            {id:'col4', validExp:'col4:true:groupRequire=col4'}
		            ]
	});
	vm.validateGroup('frm');

}

function testSetBind(isBind) {
	bind.setBind(isBind);
}

function alertValue() {
	alert(dataSet.getNameValue(0, 'code'));
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}