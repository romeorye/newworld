setUpPageStatus = 'complete';
//setUpPageStatus == 'complete'가 되어야만  test function이 실행된다.
function setUpPage(){
    setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testRightClick(){
    layout.getUnitByPosition('right').toggle();
}

function testLeftClick(){
    layout.getUnitByPosition('left').toggle();
}

function testCloseLeftClick(){
    layout.getUnitByPosition('left').close();
}

function testChangeRightContentClick(){
    layout.getUnitByPosition('right').bodyHtml("<b>Right 영역 AJAX등을 사용하여 content 채우기</b>");
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}