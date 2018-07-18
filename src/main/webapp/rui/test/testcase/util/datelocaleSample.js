setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testDateLocale(){
	//date object를 문자열로
	var sDate = Rui.util.LDate.format(new Date());
	var d1 = "default Locale format : " + sDate + "<br/>";
	//date string을 date object로
	var oDate = Rui.util.LDate.parse(sDate, {
		format: "%x"
	});
	d1 += "default Locale date : " + oDate + "<br/>";

	sDate = Rui.util.LDate.format(oDate, {
		format: '%x',
		locale: 'en'
	});
	d1 += "en Locale format : " + sDate + "<br/>";
	oDate = Rui.util.LDate.parse(sDate, {
		format: '%x',
		locale: 'en'
	});
	d1 += "en Locale date : " + oDate + "<br/>";

	Rui.util.LDateLocale['fr'] = Rui.merge(Rui.util.LDateLocale['ko'], {
		x: '%Y/%m/%d'
	});

	sDate = Rui.util.LDate.format(oDate, {
		format: '%x',
		locale: 'fr'
	});
	d1 += "fr Locale format : " + sDate + "<br/>";

	oDate = Rui.util.LDate.parse(sDate, {
		format: '%x',
		locale: 'fr'
	});
	d1 += "fr Locale date : " + oDate + "<br/>";

	sDate = Rui.util.LDate.format(new Date(), {
		format: '%T'
	});
	d1 += "%T format : " + sDate + "<br/>";

	Rui.log(d1);

	Rui.get('demo').html(d1);
}



//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}