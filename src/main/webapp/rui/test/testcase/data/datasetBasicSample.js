setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************                        

function testDataSetAddUndo() {
	info('bindTests : testDataSetUndo 작동 여부');

	var count = dataSet.getCount();

	dataSet.newRecord();

	assertEquals(dataSet.getCount(), count + 1);    

	dataSet.undo(dataSet.getCount() - 1);

	assertEquals(dataSet.getCount(), count);
}

function testDataSetCreateRecord() {
	var data = {
			col:'aaa'
	}
	var record = dataSet.createRecord(data);
}

function testDataSetUndo() {
	info('bindTests : testDataSetUndo 작동 여부');

	dataSet.getAt(0).set('col1', 'test');

	assertEquals(dataSet.getAt(0).get('col1'), 'test');

	dataSet.undo(0);

	assertEquals(dataSet.getAt(0).get('col1'), 'Kaden Q. Delacruz');
}

function testDataSetUndoAll() {
    debugger; 
	info('bindTests : testDataSetUndoAll 작동 여부');

	dataSet.getAt(0).set('col1', 'test1');
	dataSet.getAt(1).set('col1', 'test2');

	assertEquals(dataSet.getAt(0).get('col1'), 'test1');
	assertEquals(dataSet.getAt(1).get('col1'), 'test2');

	dataSet.undoAll();
	assertEquals(dataSet.getAt(0).get('col1'), 'Kaden Q. Delacruz');
	assertEquals(dataSet.getAt(1).get('col1'), 'Bertha G. Carr');
}

function testDataSetFirst() {
	info('bindTests : testDataSetFirst 작동 여부');

	dataSet.first();

	assertEquals(dataSet.getRow(), 0);
}

function testDataSetLast() {
	info('bindTests : testDataSetLast 작동 여부');

	var value = dataSet.getAt(dataSet.getCount() - 1).get('col1');

	dataSet.last();

	assertEquals(dataSet.getRow(), dataSet.getCount() - 1);
}

function testDataSetPrevious() {
	info('bindTests : testDataSetPrevious 작동 여부');

	var value = dataSet.getAt(dataSet.getCount() - 1).get('col1');
	var oldRow = dataSet.getRow();
	dataSet.previous();
	if(dataSet.getRow() != 1)
		assertEquals(dataSet.getRow(), oldRow-1);
}

function testDataSetNext() {
	info('bindTests : testDataSetNext 작동 여부');

	var value = dataSet.getAt(2).get('col1');

	var oldRow = dataSet.getRow();

	dataSet.next();

	if(dataSet.getCount() - 1 != dataSet.getRow())
		assertEquals(dataSet.getRow(), (oldRow + 1));
}

function testQuery() {
	var queryList = dataSet.query(
			function(id, record) {
				if(record.get('col4') == 'R2')
					return true;
			}
	);

	queryList.each(function(id, record){
		Rui.log(id);
	})
}

function testFilter() {
	dataSet.filter(
			function(id, record) {
				if(record.get('col4') == 'R2')
					return true;
			}
	);
}

function testClearFilter() {
	dataSet.clearFilter();
}

function testClone(){
	var testDataSet = dataSet.clone('testDataSet');
	Rui.log(testDataSet.getCount());
}

function testDataSetCommit() {
	info('bindTests : testDataSetCommit 작동 여부');

	dataSet.getAt(3).set('col1', 'test1');
	dataSet.getAt(4).set('col1', 'test2');

	assertEquals(dataSet.getAt(3).get('col1'), 'test1');
	assertEquals(dataSet.getAt(4).get('col1'), 'test2');

	dataSet.commit();

	assertEquals(dataSet.getAt(3).get('col1'), 'test1');
	assertEquals(dataSet.getAt(4).get('col1'), 'test2');
}
//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}