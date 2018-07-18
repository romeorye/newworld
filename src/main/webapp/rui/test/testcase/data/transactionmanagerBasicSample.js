setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
		                                     
	//  Rui.getConfig().set('$.base.dataSet.defaultProperties.sync', [true]);
	 // Rui.getConfig().set('$.base.dataSet.defaultProperties.sync', [true]);
}

//**************test function 시작*****************

function testFirst() {
	dataSet.first();
}

function testPrevious() {
	dataSet.previous();
}

function testNext() {
	dataSet.next();
}

function testLast() {
	dataSet.last();
}

function testAdd() {
	if(dataSet.getCount() >= 30) {
		alert('더이상 Record를 추가할 수 없습니다.');
		return;
	}

	var row = dataSet.newRecord();
    if (row !== false) {
        var record = dataSet.getAt(row);                
        record.set("id", "007");
        record.set("col1", "test1");
        record.set("col2", "test2");   
        record.set("col3", "test3");
        record.set("col4", "test4"); 
        record.set("col5", "test5");
        record.set("col6", "test6"); 
    }	
}

function testNew() {
	if(dataSet.getCount() >= 30) {
		alert('더이상 Record를 추가할 수 없습니다.');
		return;
	}

	var row = dataSet.newRecord();

	dataSet.setRow(row);
}

function testRemove() {
	dataSet.removeAt(dataSet.getRow());
}

function testSubmit() {

	var form = new Rui.ui.form.LForm('frm', {
	});

	try {
		var obj = form.getValues();
		Rui.log(Rui.dump(obj));
	} catch(e) {
		alert(e);
	}
	return false;
}

function testUndo() {
	dataSet.undo(dataSet.getRow());
}

function testUndoAll() {
	dataSet.undoAll();
}

function testUpdater() {
	tm.update({
		url: './../../../sample/data/saveData.json', 
		params: 'id=asdff&pwd=ddd&pwd=bbb'
	});
}

function testFormUpdater() {
	tm.updateForm({
		url: './../../../sample/data/saveData.json',
		form: 'frm',
		params: {
			test: '1'
		}                    
	});
}

function testDataSetUpdater() {
	tm.updateDataSet({
		dataSets: [ dataSet ],
		modifiedOnly: false, 
		url: './../../../sample/data/saveData.json'    
	});
}

function testCommit() {
	dataSet.commit();
}

function testCallLoad() {
	bind.load(1);
}

function testSetRow(){
	bind.load(2);
}

function testSetState() {
	dataSet.setState(2, Rui.data.LRecord.STATE_INSERT);
}

function testLoadDataSet() {
	tm.loadDataSet({
		dataSets:[dataSet], 
		url : './../../resources/data/data.json'
	});
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}