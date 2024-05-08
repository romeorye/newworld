setUpPageStatus = 'complete';
//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testXmlDataSet(){
	//xmlDataSetTests.html : testXmlDataSet 작동 여부
	//log 활성화
	Rui.getConfig().set('$.core.logger.show', [true]);
	try {
		/*<b>*/
		var dataSet = new Rui.data.LXmlDataSet({
			id: 'dataSet',
			fields: [{
				id: 'col1'
			}]
		});

		dataSet.on('load', function(e){
			Rui.log("loaded !, vdataSet.getAt(0).get('col1')값 : " + dataSet.getAt(0).get('col1'));
		});

		dataSet.on('loadException', function(e){
			//debug(e.throwObject.message);
			Rui.log("error : " + e.throwObject.message);
		});

		dataSet.load({
			url: './../../resources/data/data.xml',
			sync: true,
			method:"get"
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