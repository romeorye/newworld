var setUpPageStatus = 'complete';
function setUpPage(){
	setUpPageStatus = 'running';
}

//test function이 실행되기 전에 먼저 실행된다.
function setUp(){
}

//**************test function 시작*****************
function testJson(){
	var employee = {
			firstName: "john",
			lastName: "Doe",
			employNumber: 123,
			title: "Accountant"
	}; 

	var lastName = employee.lastName;
	var title = employee.title;
	employee.employNumber = 456;

	var JSONTest = function(){
		this.id = null;
	}; 

	JSONTest.prototype.toString = function(){

	}; 

	JSONTest.prototype.toString2 = function(){

	}; 

	JSONTest.prototpye = {
			id: null,
			toString: function(){

			},
			toString2: function(){

			}
	}; 
	assert(true);
}

//**************test function   끝*****************
//모든 test function이 실행된 후 실행된다.
function tearDown(){
}