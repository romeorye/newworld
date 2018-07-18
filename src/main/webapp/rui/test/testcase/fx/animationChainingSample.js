setUpPageStatus = 'complete';
function setUpPage(){
	setUpPageStatus = 'running';
}            
function testAnimateMethod(){
	debugger; 
	assertEquals(move.animate(), true);
	assertEquals(changeColor.animate(), true);
}