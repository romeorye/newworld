setUpPageStatus = 'complete';
//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testLoadEvent(){
	try {
		var dataSet = new Rui.data.LJsonDataSet({
			id: 'dataSet',
			fields: [{
				id: 'col1'
			}]
		});

		/*<b>*/
		dataSet.on('loadException', function(e){
			alert("dataSet load 실패 : " + e.throwObject.message);
		});

		dataSet.load({
			url: './../../resources/data/data.json'
		});
		/*</b>*/

		if (dataSet.getCount() > 0) 
			Rui.log("dataSet.getAt(1).get('col1') 값 : " + dataSet.getAt(1).get('col1'));

		var dataSet2 = new Rui.data.LJsonDataSet({
			id: 'dataSet2',
			dataIndex: 1,
			fields: [{
				id: 'col1'
			}]
		});

		/*<b>*/
		dataSet2.on('load', function(e){
			Rui.log("load event, dataSet2.getAt(1).get('col1')값 : " + dataSet2.getAt(1).get('col1'));
		});

		dataSet2.on('loadException', function(e){
			alert("dataSet2 load error : " + e.throwObject.message);
		});

		dataSet2.load({
			url: './../../resources/data/data.json',
			cache: true
		});
		/*</b>*/

	} 
	catch (e) {
		alert("error : " + e.message);
	}
}
//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}