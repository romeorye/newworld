
var numberBox = new Rui.ui.form.LNumberBox({
	emptyValue : '',
	minValue : 0,
	maxValue : 99999
});


function makeGrsEvPop() {
	/* 평가표 */
	grsEvSnNm = new Rui.ui.form.LPopupTextBox({
		applyTo : 'grsEvSnNm',
		width : 300,
		editable : false,
		placeholder : '',
		emptyValue : '',
		enterToPopup : true
	});
	grsEvSnNm.on('popup', function(e) {
		openGrsEvSnDialog();
	});

	openGrsEvSnDialog = function() {
		grsEvSnDialog.setUrl('/iris/prj/grs/grsEvStdPop.do?tssCd=' + infoDataSet.getNameValue(0, "tssCd") + '&userId=' + infoDataSet.getNameValue(0, "saSabunCd"));
		grsEvSnDialog.show();
	};

	// 팝업: 평가표
	grsEvSnDialog = new Rui.ui.LFrameDialog({
		id : 'grsEvSnDialog',
		title : 'GRS 평가항목선택',
		width : 800,
		height : 500,
		modal : true,
		visible : false
	});

	grsEvSnDialog.render(document.body);

	openGrsEvDtlDialog = function(grsEvSn) {
		grsEvDtlDialog.setUrl('/iris/prj/grs/grsEvStdDtlPop.do?grsEvSn=' + grsEvSn);
		grsEvDtlDialog.show();
	};

	// 팝업: 상세내용
	grsEvDtlDialog = new Rui.ui.LFrameDialog({
		id : 'grsEvSnDialog',
		title : 'GRS 평가항목',
		width : 1250,
		height : 430,
		modal : true,
		visible : false
	});

	grsEvDtlDialog.render(document.body);

	openGrsEvDtlDialog = function(grsEvSn) {
		grsEvDtlDialog.setUrl('/iris/prj/grs/grsEvStdDtlPop.do?grsEvSn=' + grsEvSn);
		grsEvDtlDialog.show();
	};
}

function makeGrsEvTable() {
//	listGrid.setEditable(false);

    gridDataSet = new Rui.data.LJsonDataSet({ //listGrid dataSet
        id: 'gridDataSet',
        //focusFirstRow: 0,
        lazyLoad: true,
        fields: [
                { id: 'grsEvSn'},           					//GRS 일련번호
                { id: 'grsEvSeq'},          					//평가STEP1
                { id: 'evPrvsNm_1'},        					//평가항목명1
                { id: 'evPrvsNm_2'},        					//평가항목명2
                { id: 'evCrtnNm'},          					//평가기준명
                { id: 'evSbcTxt'},          					//평가내용
                { id: 'dtlSbcTitl_1'},    						//상세내용1
                { id: 'dtlSbcTitl_2'},      						//상세내용2
                { id: 'dtlSbcTitl_3'},     						//상세내용3
                { id: 'dtlSbcTitl_4'},      						//상세내용4
                { id: 'dtlSbcTitl_5'},      						//상세내용5
                { id: 'evScr', type: 'number' },              //평가점수 , defaultValue: 0
                { id: 'wgvl' , type: 'number' },              //가중치
                { id: 'calScr'  },          						//환산점수
                { id: 'grsY'},              						//년도
                { id: 'grsType'},           					//유형
                { id: 'evSbcNm'},           					//템플릿명
                { id: 'useYn'}              					//사용여부
                ]
    });
	gridDataSet.on('load', function(e) {
		//환산점수 - 화면 로드 시
		for (var i = 0; i < gridDataSet.getCount(); i++) {
			var evScr = gridDataSet.getNameValue(i, "evScr");
			var wgvl = gridDataSet.getNameValue(i, "wgvl");
			var val = evScr / 5 * wgvl;
			var cal = Rui.util.LNumber.round(val, 1);

			if (evScr == null || evScr == "") {
				gridDataSet.setNameValue(i, "calScr", "");
				continue;
			}
			if (!isNaN(cal)) {
				gridDataSet.setNameValue(i, "calScr", cal);
				continue;
			}
		}
	});

	gridDataSet.on('update', function(e) {
		if (e.colId == "evScr") {
			if (e.value > 5) {
				Rui.alert("평가점수는 5점이상을 입력할수 없습니다.");
				gridDataSet.setNameValue(e.row, e.colId, "");
				return;
			}
			if (e.value == '') {
				gridDataSet.setNameValue(e.row, e.colId, "");
				gridDataSet.setNameValue(e.row, "calScr", "");
				return;
			}

			//환산점수 - 평가점수 입력 시
			for (var i = 0; i < gridDataSet.getCount(); i++) {
				var evScr = gridDataSet.getNameValue(i, "evScr");
				var wgvl = gridDataSet.getNameValue(i, "wgvl");
				var val = evScr / 5 * wgvl;
				var cal = Rui.util.LNumber.round(val, 1);

				if (evScr == null || evScr == "") {
					gridDataSet.setNameValue(i, "calScr", "");
					continue;
				}
				if (!isNaN(cal)) {
					gridDataSet.setNameValue(i, "calScr", cal);
					continue;
				}
			}
		}
	});

	mGridColumnModel = new Rui.ui.grid.LColumnModel({ //listGrid column
		columns : [ {
			field : 'evPrvsNm_1',
			label : '평가항목',
			sortable : false,
			align : 'center',
			width : 140,
			editable : false,
			vMerge : true
		}, {
			field : 'evPrvsNm_2',
			label : '평가항목',
			sortable : false,
			align : 'center',
			width : 100,
			editable : false,
			vMerge : true
		}, {
			field : 'evCrtnNm',
			label : '평가기준',
			sortable : false,
			align : 'center',
			width : 130,
			editable : false,
			vMerge : true
		}, {
			field : 'evSbcTxt',
			label : '평가내용',
			sortable : false,
			align : 'left',
			width : 220,
			editable : false
		}, {
			id : 'G1',
			label : '평가 기준및 배점'
		}, {
			field : 'dtlSbcTitl_1',
			groupId : 'G1',
			label : '5점',
			sortable : false,
			align : 'left',
			width : 82,
			editable : false
		}, {
			field : 'dtlSbcTitl_2',
			groupId : 'G1',
			label : '4점',
			sortable : false,
			align : 'left',
			width : 82,
			editable : false
		}, {
			field : 'dtlSbcTitl_3',
			groupId : 'G1',
			label : '3점',
			sortable : false,
			align : 'left',
			width : 82,
			editable : false
		}, {
			field : 'dtlSbcTitl_4',
			groupId : 'G1',
			label : '2점',
			sortable : false,
			align : 'left',
			width : 82,
			editable : false
		}, {
			field : 'dtlSbcTitl_5',
			groupId : 'G1',
			label : '1점',
			sortable : false,
			align : 'left',
			width : 82,
			editable : false
		}, {
			field : 'evScr',
			label : '평가점수',
			sortable : false,
			align : 'center',
			width : 60,
			editor : numberBox,
			editable : true
		//                     , renderer: function(value, p) {
		//                         var chk = '<c:out value="${inputData.tssStNm}"/>'; //요청일 경우에만 validation check
		//                         if(chk == 1) {
		//                             if(value > 5) {
		////                                     Rui.alert("평가점수는 5점이상을 입력할수 없습니다.");
		////                                     value = '';
		//                             }
		//                             return  value;
		//                         }
		//                         else {
		//                               if(todoYN) {
		//                                   if(value > 5) {
		////                                         Rui.alert("평가점수는 5점이상을 입력할수 없습니다.");
		////                                         value = '';
		//                                   }
		//                                   return value;
		//                               }
		//                               else {
		//                                   return value;
		//                               }
		//                         }
		//                     }
		}, {
			field : 'wgvl',
			label : '가중치',
			sortable : false,
			align : 'center',
			width : 45,
			editable : false
		}, {
			field : 'calScr',
			label : '환산점수',
			sortable : false,
			align : 'center',
			width : 55,
			editable : false
		} ]
	});

	/* 합계 */

	var sumColumns = [ 'evScr', 'wgvl', 'calScr' ];
	summary = new Rui.ui.grid.LTotalSummary();
	summary.on('renderTotalCell', summary.renderer({
		label : {
			id : 'evPrvsNm_1',
			text : '합 계'
		},
		columns : {
			//evScr: { type: 'avg', renderer: function(val) { return Rui.util.LNumber.round(val, 2); } }
			//evScr: { type: 'sum', renderer: 'number' }  //평가점수 합계 삭제 요청 : 20171219
			wgvl : {
				type : 'sum',
				renderer : 'number'
			},
			calScr : {
				type : 'sum',
				renderer : function(val) {
					return Rui.util.LNumber.round(val, 1);
				}
			}
		}
	}));

	evTableGrid = new Rui.ui.grid.LGridPanel({ //listGrid
		columnModel : mGridColumnModel,
		dataSet : gridDataSet,
		height : 280,
		width : 600,
		autoToEdit : true,
		clickToEdit : true,
		enterToEdit : true,
		autoWidth : true,
		autoHeight : true,
		multiLineEditor : true,
		useRightActionMenu : false,
		viewConfig : {
			plugins : [ summary ]
		}
	});

	evTableGrid.render('evTableGrid'); //listGrid render
}

