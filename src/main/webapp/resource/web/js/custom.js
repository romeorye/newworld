//Textinput 기본
function nTextBox(id, width, ph,ed) {
    if(ed==undefined)ed = true;

	this[id] = new Rui.ui.form.LTextBox({
		applyTo : id,
		width : width,
		placeholder: ph,
        editable: ed,
	});
    if(!ed){
        setReadonly(id);
    }else{
        setEditable(id);
    }
}

//TextArea 기본
function nTextArea(id, width, height, ph,ed){
    if(ed==undefined)ed = true;

	this[id] = new Rui.ui.form.LTextArea({
	    applyTo: id,
	    width: width,
	    height: height,
	    placeholder: ph,
        editable: ed,
	});
    if(!ed){
        setReadonly(id);
    }else{
        setEditable(id);
    }
}


//Combo 기본
function nCombo(id, comCd) {
	this[id] = new Rui.ui.form.LCombo({
		applyTo : id,
		name : id,
		useEmptyText : true,
		emptyText : '선택',
		width : 140,
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
        width: 200,
        editable: true,
        enterToPopup: true
    });
    this[nameId].on('popup', function(e){
        console.log(e.displayValue);
        openUserSearchNmDialog(
        		function(userInfo){
        			console.log(userInfo)
        			this[nameId].setValue(userInfo.saName);
        			$("#"+sabunId).val(userInfo.saSabun);
                    setDept(userInfo.deptCd);
        		}
        , encodeURIComponent(e.displayValue), 800,600);
    });

    this[nameId].on('show', function(e){
        console.log("load");
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




function setReadonly(id){

    if ($("#" + id).hasClass("L-textbox") || $("#" + id).hasClass("L-textarea")) {
        eval(id).setEditable(false);
    }

    if ($("#" + id).hasClass("L-combo") ||
        $("#" + id).hasClass("L-popuptextbox") ||
        $("#" + id).hasClass("L-datebox") ||
        $("#" + id).hasClass("L-monthbox") ||
        $("#" + id).hasClass("L-popuptextbox")
    ) {
        $("#" + id + " > .icon").css("display", "none");
    }

    if ($("#" + id).hasClass("L-numberbox")) {
        eval(id).setEditable(false);
        $("#" + id).css("border-width", "0px");
    }

    $("#" + id).css("border-width", "0px");

    if(!$("#" + id).hasClass("L-textarea"))$("#" + id).css("pointer-events", "none");

    $("#" + id + " > input").attr("placeholder", "");
    $("#" + id + " > textarea").attr("placeholder", "");
}

function setEditable(id){
    if ($("#" + id).hasClass("L-textbox") || $("#" + id).hasClass("L-textarea")) {
        eval(id).setEditable(true);
    }

    if ($("#" + id).hasClass("L-combo") ||
        $("#" + id).hasClass("L-popuptextbox") ||
        $("#" + id).hasClass("L-datebox") ||
        $("#" + id).hasClass("L-monthbox") ||
        $("#" + id).hasClass("L-popuptextbox")
    ) {
        $("#" + id + " > .icon").css("display", "block");
    }

    if ($("#" + id).hasClass("L-numberbox")) {
        eval(id).setEditable(true);
        $("#" + id).css("border-width", "1px");
    }

    $("#" + id).css("border-width", "1px");
    $("#" + id).css("pointer-events", "auto");
    $("#" + id + " > input").attr("placeholder",  this[id].placeholder);
    $("#" + id + " > textarea").attr("placeholder",  this[id].placeholder);
}


function setReadonlyDate(fromId,endId) {
    setReadonly(fromId);
    $("#"+fromId).css("cssText","width: 75px !important; border-width: 0px; pointer-events: none;");
    $("#"+fromId).next().css("cssText","margin-left:5px !important");
    setReadonly(endId);
}