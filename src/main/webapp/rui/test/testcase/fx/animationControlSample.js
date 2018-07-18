setUpPageStatus = 'complete';
function setUpPage(){
	setUpPageStatus = 'running';
}

function testAnimateMethod(){
	assertEquals(anim.animate(), true);
}