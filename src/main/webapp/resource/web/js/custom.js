//Textinput 기본
function nTextBox(id, width, ph) {
	this[id] = new Rui.ui.form.LTextBox({
		applyTo : id,
		width : width,
		placeholder: ph,
	});
}

//TextInput 기본
function nTextArea(id, width, height, ph){
	this[id] = new Rui.ui.form.LTextArea({
	    applyTo: id,
	    width: width,
	    height: height,
	    placeholder: ph,
	});
}


//Combo 기본
function nCombo(id, comCd) {
	this[id] = new Rui.ui.form.LCombo({
		applyTo : id,
		name : id,
		useEmptyText : true,
		emptyText : '선택',
		width : 120,
		url : '/iris/common/code/retrieveCodeListForCache.do?comCd='+ comCd,
		displayField : 'COM_DTL_NM',
		valueField : 'COM_DTL_CD'
	});
}

function nDateBox(id){
    this[id] = new Rui.ui.form.LDateBox({
        applyTo: id
    });
}

function nMonthBox(id){
	this[id] = new Rui.ui.form.LMonthBox({
		applyTo: id,
		placeholder: 'yyyy-mm',
		width: 100,
		defaultValue: null
	});
}

// 프로젝트 조회 팝업
function popProject(nameId, cdId , deptCdId, dialId){
    this[nameId] = new Rui.ui.form.LPopupTextBox({
        applyTo: nameId,
        width: 400,
        editable: false,
        enterToPopup: true
    });
    this[nameId].on('popup', function(e){
        openPrjSearchDialog(
        		function(prjInfo){
        			console.log(prjInfo)
        			this[nameId].setValue(prjInfo.prjNm);
        			$("#"+cdId).val(prjInfo.prjCd);
        			$("#"+deptCdId).val(prjInfo.upDeptCd);
        			console.log($("#"+cdId).val());
        		}
        ,'');
    })

    this[dialId] = new Rui.ui.LFrameDialog({
        id:dialId,
        title: '프로젝트 조회',
        width: 620,
        height: 540,
        modal: true,
        visible: false
    });

    prjSearchDialog.render(document.body);

    openPrjSearchDialog = function(f,p) {
        var param = '?searchType=';
        if( !Rui.isNull(p) && p != ''){
            param += p;
        }

        _callback = f;

        prjSearchDialog.setUrl('/iris/prj/rsst/mst/retrievePrjSearchPopup.do' + param);
        prjSearchDialog.show();
    };
}

// 사용자 조회 팝업
function popSabun(nameId, sabunId){
    this[nameId] = new Rui.ui.form.LPopupTextBox({
        applyTo: nameId,
        width: 150,
        editable: false,
        enterToPopup: true
    });
    this[nameId].on('popup', function(e){
        openUserSearchDialog(
        		function(userInfo){
        			console.log(userInfo)
        			this[nameId].setValue(userInfo.saName);
        			$("#"+sabunId).val(userInfo.saSabun);
        		}
        , 1, '');
    });



// form 값 확인
	function testSubmit(form) {
		try {
			var obj = form.getValues();
			Rui.log(Rui.dump(obj));
		} catch (e) {
			alert(e);
		}
		return false;
	}

}