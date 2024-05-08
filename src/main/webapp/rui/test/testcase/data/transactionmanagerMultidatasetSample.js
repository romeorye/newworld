setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testLoad(){
	// loadDataSet시에는 load와 loadException 이벤트가 호출됨.
	tm.loadDataSet({
		dataSets: [dataSet1, dataSet2],
		url: './../../resources/data/codeData.json'
	});
}

function testUpdate(){
	// updateDataSet시에는 success와 failure 이벤트가 호출됨.
	tm.updateDataSet({
		dataSets: [dataSet1, dataSet2],
		url: '/loadmultidataset.dev',
		params: {
			mode: 'update'
		}
	});
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}