setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
    setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}

// divObj에 background-color를 gray로 변경이 정상적으로 적용되는지 테스트
function testSetStyle() {
    $E('divObj').setStyle('background-color', 'gray');
    var color = $E('divObj').getStyle('background-color');
    assert(color == 'gray');
}
