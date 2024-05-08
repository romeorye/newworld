setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
//function setUpPage(){
//    setUpPageStatus = 'running';
//}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testJsonDataSet(){
	//jsonDataSetTests : testJsonDataSet 작동 여부
	try {
		/*<b>*/
		var dataSet = new Rui.data.LJsonDataSet({
			id: 'dataSet',
			dataIndex: 0,
			fields: [{
				id: 'col1'
			}]
		});
		dataSet.load({
			url: './../../resources/data/data.json',
			params: {
				aaa: 'aaa',
				bbb: 'bbb'
			}
		});
		/*</b>*/

		Rui.log("dataSet.getAt(0).get('col1') : " + dataSet.getAt(0).get('col1'));

		var dataSet2 = new Rui.data.LJsonDataSet({
			id: 'dataSet2',
			dataIndex: 1,
			fields: [{
				id: 'col1'
			}]
		});

		dataSet2.on('load', function(e){
			Rui.log("dataSet2.getAt(0).get('col1') : " + dataSet2.getAt(0).get('col1'));
		});

		dataSet2.on('loadException', function(e){
			alert("load error : " + e.throwObject.message);
		});

		dataSet2.load({
			url: './../../resources/data/data.json',
			cache: true
		});

	} 
	catch (e) {
		alert("dataset error : " + e.message);
	}
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}