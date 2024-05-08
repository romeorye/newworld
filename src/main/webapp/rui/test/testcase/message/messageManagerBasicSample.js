setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testAddLocaleData(){            	
	//MessageManagerTests.html : testAddLocaleData 작동 여부
	var value = mm.get('$.core.test', ['test']);
	Rui.log("읽어온 메시지 : " + value);

	var data = mm.get('$.message.test2');
	Rui.log("기본 locale 읽어온 메시지 : " + data);
	assertEquals(data, "한글");

	mm.setLocale('en_US');
	var data = mm.get('$.message.test2');
	Rui.log("변경 locale en_US 읽어온 메시지 : " + data);
	assertEquals(data, "english");
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}