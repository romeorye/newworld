setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************

function testUpdater() {
	info('updaterTests : testUpdater 작동 여부');
	tm.update({
		url: './../../../sample/data/saveData.json', 
		params: 'id=asdff&pwd=ddd&pwd=bbb'
	});
}

function testFormUpdater() {
	info('updaterTests : testFormUpdater 작동 여부');
	tm.updateForm({
		form:'frm'
	});
}

function testDataSetUpdater() {
	info('updaterTests : testDataSetUpdater 작동 여부');
	dataSet.getAt(0).set('col1', 'sdafsdafsd');

	var testDataSet = dataSet.clone('test');
	testDataSet.getAt(1).set('col1', 'sdafsdafsd');

	tm.updateDataSet({
		dataSets: [ testDataSet ], 
		url: './../../../sample/data/saveData.json'
	});
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}