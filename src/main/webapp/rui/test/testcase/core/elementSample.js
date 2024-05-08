setUpPageStatus = 'complete';
function setUpPage(){
    setUpPageStatus = 'running';
}

function testBrowserInfo(){
    assertNotUndefined(logData);
}

function testEnableDisable(){
	var form = new Rui.ui.form.LForm('frm');
	if (form.isDisable()) {
		form.enable();
		Rui.get('enableDisableLink').html('testDisable');
	}
	else {
		form.disable();
		Rui.get('enableDisableLink').html('testEnable');
	}
}

function testInvalid(){
	var el = Rui.get('col1');
	if (el.isValid()) {
		el.invalid();
		Rui.get('invalidLink').html('testInvalid');
	}
	else {
		el.valid();
		Rui.get('invalidLink').html('testValid');
	}
}

function testHide(){
	var el = Rui.get('col1');
	if (el.isShow()) {
		el.hide(true);
		Rui.get('hideLink').html('testShow');
	}
	else {
		el.show(true);
		Rui.get('hideLink').html('testHide');
	}
}

function testSetValue(){
	var el = Rui.get('col1');
	el.setValue('ccc');
}

function testSetValues(){
	var form = new Rui.ui.form.LForm('frm');
	var obj = {
			col1: 'asdfasdf',
			col2: 'bbb',
			col3: 'tes3'
	};

	form.setValues(obj);
}

function testFindParent(){
	var el = Rui.get('panel');
	Rui.log(el.findParent('.container').id);
}

function testFindParentNode(){
	var el = Rui.get('panel');
	Rui.log(el.findParentNode('.container').id);
}

function testParent(){
	var el = Rui.get('frm');
	Rui.log(el.parent().id);
}

function testClip(){
	panelEl.clip();
	Rui.log(panelEl.getStyle("overflow"));
}

function testUnclip(){
	panelEl.unclip();
	Rui.log(panelEl.getStyle("overflow"));
}

function testRepaint(){
	panelEl.repaint();
	Rui.log("repainted");
}

function testAppendTo(){
	var sp2 = Rui.get("col2");
	var sp3 = Rui.get("col3");
	sp2.appendTo(sp2.parent(), sp3.dom);
}

function testInsertBefore(){
	var frm = Rui.get('frm');
	var sp1 = document.createElement("input");
	sp1.type = 'radio';
	sp1.id = 'radio1';
	sp1.name = 'radio1';
	var sp2 = Rui.get("col2");
	sp2.insertBefore(sp1, sp2.dom);
}

function testInsertAfter(){
	var frm = Rui.get('frm');
	var sp1 = document.createElement("input");
	sp1.type = 'radio';
	sp1.id = 'radio2';
	sp1.name = 'radio2';
	var sp2 = Rui.get("col2");
	sp2.insertAfter(sp1, sp2.dom);
}

function testCreateElement() {
	var html = '<li>test1</li><li>test2</li>';
	var el = Rui.createElements(html);
	el.appendTo(Rui.get('appendTest'));
}

function testSetRegion(){
	debugger; 
	Rui.get('demo').setRegion({
		left: 600,
		right: 800,
		top: 200,
		bottom: 300
	}, true);
}

function testMoveTo(){
	Rui.get('demo').moveTo(600, 200, true);
}

function testSetSize(){
	Rui.get('demo').setSize(100, 100, true);
}

function testSetWidth(){
	Rui.get('demo').setWidth(100, true);
}



function testGetLRTB(){
	var demo = Rui.get('demo');
	Rui.log('getLeft : ' + demo.getLeft());
	Rui.log('getRight : ' + demo.getRight());
	Rui.log('getTop : ' + demo.getTop());
	Rui.log('getBottom : ' + demo.getBottom());

}

function testMargins(){
	var fieldset = Rui.select('#frm fieldset');
	if (fieldset.length > 0) {
		var ell = fieldset.getAt(0);
		var o = ell.getMargins('lr');
		Rui.log('length : ' + o);
	}
}

function testForm(){
	var logCat = {
			cat: 'info',
			src: 'Component'
	};
	Rui.get('p').appendChild(Rui.get('col1'));
	Rui.log(Rui.get('col2').getValue(), logCat);
	Rui.log('#col2:first-child,select : ' + Rui.get('p').select('#col2:first-child,select').length, logCat);
	var el = Rui.get('p').select('*');
	Rui.log('length : ' + el.length, logCat);
	Rui.log('length.select : ' + el.select('*').length, logCat);
	Rui.log('item(0) : ' + el.getAt(0), logCat);
}

function testMask(){
	Rui.get("frm").mask();
	Rui.get("demo").mask();
}

function testUnmask(){
	Rui.get("frm").unmask();
	Rui.get("demo").unmask();
}

function noTestRemove(){
	Rui.get('col3').remove();
}
