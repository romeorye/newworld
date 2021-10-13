<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : insertGenTssSmry.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.08
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;
    var lvTssStrtDd = window.parent.tmpTssStrtDd;
    var pageMode = (lvTssSt == "100" || lvTssSt == "" || lvTssSt == "302") && (lvPageMode == "W" || lvPageMode == "") ? "W" : "R";
    
    var lvTssAttrCd = window.parent.tssAttrCd;
    var lvBizDptCd = window.parent.bizDptCd;
    var dataSet;
    var lvAttcFilId;

    var strDt =window.parent.tmpTssStrtDd;
    var endDt =window.parent.tmpTssFnhDd;

    Rui.onReady(function() {

        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //시장규모
        mrktSclTxt = new Rui.ui.form.LTextArea({
            applyTo: 'mrktSclTxt',
            height: 100,
            width: 1100
        });

        //요약개요
        smrSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrSmryTxt',
            height: 100,
            width: 1100
        });

        //요약목표
        smrGoalTxt = new Rui.ui.form.LTextArea({
            applyTo: 'smrGoalTxt',
            height: 100,
            width: 1100
        });
       
        //지적재산권 통보
        pmisTxt = new Rui.ui.form.LTextArea({
            applyTo: 'pmisTxt',
            height: 100,
            width: 1100
        });

        //Form 비활성화
        disableFields = function() {
            btnSave.hide();
        };

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }            //과제코드
                , { id: 'smryNTxt' }         //Needs
                , { id: 'smryATxt' }         //Approach
                , { id: 'smryBTxt' }         //Benefit
                , { id: 'smryCTxt' }         //Competition
                , { id: 'smryDTxt' }         //Deliverables
                , { id: 'mrktSclTxt' }       //시장규모
                , { id: 'ctyOtPlnM' }        //상품출시(계획)
                , { id: 'smrSmryTxt' }       //Summary 개요
                , { id: 'smrGoalTxt' }       //Summary 목표
                , { id: 'bizPrftProY'   }     //영업이익율Y
                , { id: 'bizPrftProY1'  }     //영업이익율Y+1
                , { id: 'bizPrftProY2'  }     //영업이익율Y+2
                , { id: 'bizPrftProY3'  }     //영업이익율Y+3
                , { id: 'bizPrftProY4'  }     //영업이익율Y+4
                , { id: 'bizPrftPlnY'  }     //영업이익Y
                , { id: 'bizPrftPlnY1'  }     //영업이익Y+1
                , { id: 'bizPrftPlnY2'  }     //영업이익Y+2
                , { id: 'nprodSalsPlnY'  }    //신제품매출계획Y
                , { id: 'nprodSalsPlnY1'  }   //신제품매출계획Y+1
                , { id: 'nprodSalsPlnY2'  }   //신제품매출계획Y+2
                , { id: 'nprodSalsPlnY3'  }   //신제품매출계획Y+3
                , { id: 'nprodSalsPlnY4'  }   //신제품매출계획Y+4
                , { id: 'expArslY'  }         //투입비용(M/M)Y
                , { id: 'expArslY1'  }        //투입비용(M/M)Y+1
                , { id: 'expArslY2'  }        //투입비용(M/M)Y+2
                , { id: 'expArslY3'  }        //투입비용(M/M)Y+3
                , { id: 'expArslY4'  }        //투입비용(M/M)Y+4
                , { id: 'ptcCpsnY'  }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnY1'  }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnY2'  }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnY3'  }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnY4'  }        //투입인원(M/M)Y+4
                
                , { id: 'bizPrftProYBefore'   }     //영업이익율Y
                , { id: 'bizPrftProY1Before'  }     //영업이익율Y+1
                , { id: 'bizPrftProY2Before'  }     //영업이익율Y+2
                , { id: 'bizPrftProY3Before'  }     //영업이익율Y+3
                , { id: 'bizPrftProY4Before'  }     //영업이익율Y+4
                , { id: 'bizPrftPlnYBefore'  }     //영업이익Y
                , { id: 'bizPrftPlnY1Before'  }     //영업이익Y+1
                , { id: 'bizPrftPlnY2Before'  }     //영업이익Y+2
                , { id: 'nprodSalsPlnYBefore'  }    //신제품매출계획Y
                , { id: 'nprodSalsPlnY1Before'  }   //신제품매출계획Y+1
                , { id: 'nprodSalsPlnY2Before'  }   //신제품매출계획Y+2
                , { id: 'nprodSalsPlnY3Before'  }   //신제품매출계획Y+3
                , { id: 'nprodSalsPlnY4Before'  }   //신제품매출계획Y+4
                , { id: 'expArslYBefore'  }         //투입비용(M/M)Y
                , { id: 'expArslYBefore'  }        //투입비용(M/M)Y+1
                , { id: 'expArslY2Before'  }        //투입비용(M/M)Y+2
                , { id: 'expArslY3Before'  }        //투입비용(M/M)Y+3
                , { id: 'expArslY4Before'  }        //투입비용(M/M)Y+4
                , { id: 'ptcCpsnYBefore'  }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnY1Before'  }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnY2Before'  }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnY3Before'  }        //투입인원(M/M)Y+4
                , { id: 'ptcCpsnY4Before'  }        //투입인원(M/M)Y+4
                , { id: 'pmisTxt' }       //지적재산권 통보
                , { id: 'attcFilId' }        //첨부파일ID
                , { id: 'userId' }           //로그인ID
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");
            
            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
          
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();

            Wec0.SetBodyValue( dataSet.getNameValue(0, "smryNTxt") );
            Wec1.SetBodyValue( dataSet.getNameValue(0, "smryATxt") );
            Wec2.SetBodyValue( dataSet.getNameValue(0, "smryBTxt") );
            Wec3.SetBodyValue( dataSet.getNameValue(0, "smryCTxt") );
            Wec4.SetBodyValue( dataSet.getNameValue(0, "smryDTxt") );
/* 
	        setTimeout(function () {
                tabViewS.selectTab(0);
            }, 1000);
	          */
        });

        //유효성
        vm = new Rui.validate.LValidatorManager({
            validators: [
                  { id: 'tssCd',             validExp: '과제코드:false' }
                , { id: 'mrktSclTxt',        validExp: '시장규모:true' }
                , { id: 'ctyOtPlnM',         validExp: '상품출시(계획):true' }
                , { id: 'smrSmryTxt',        validExp: 'Summary 개요:true' }
                , { id: 'smrGoalTxt',        validExp: 'Summary 목표:true' }
                , { id: 'userId',            validExp: '로그인ID:false' }
            ]
        });

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //Report
        var btnReport = new Rui.ui.LButton('btnReport');
        btnReport.on('click', function() {
            var tssStrtDd  = lvTssStrtDd.substring(0, 4);
            var url= "<%=lghausysReportPath%>/genSmryReportPopup.jsp?reportMode=HTML&clientURIEncoding=UTF-8"
                     +"&reportParams=skip_decimal_point:true&menu=old&tss_cd="+lvTssCd+"&year="+tssStrtDd;

            var w = window.open(url , 'reportPopup' , 'width=1180 height=900');
        });

        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
        	var frm = document.smryForm;
            
        	dataSet.setNameValue(0, "smryNTxt", Wec0.GetBodyValue());
            dataSet.setNameValue(0, "smryATxt", Wec1.GetBodyValue());
            dataSet.setNameValue(0, "smryBTxt", Wec2.GetBodyValue());
            dataSet.setNameValue(0, "smryCTxt", Wec3.GetBodyValue());
            dataSet.setNameValue(0, "smryDTxt", Wec4.GetBodyValue());
            
            if(  dataSet.getNameValue(0, "smryNTxt") == "<p><br></p>" ||  dataSet.getNameValue(0, "smryNTxt")  == "") {
            	alert("Needs를 입력하세요");
            	return;
            }
            if(  dataSet.getNameValue(0, "smryATxt") == "<p><br></p>"  ||  dataSet.getNameValue(0, "smryATxt") == "" ) {
            	alert("Approach를 입력하세요");
            	return;
            }
            if(  dataSet.getNameValue(0, "smryBTxt")  == "<p><br></p>" ||  dataSet.getNameValue(0, "smryBTxt") == "") {
            	alert("Benefit를 입력하세요");
            	return;
            }
            if(  dataSet.getNameValue(0, "smryCTxt") == "<p><br></p>" ||  dataSet.getNameValue(0, "smryCTxt") == "") {
            	alert("Competition를 입력하세요");
            	return;
            }
            if(  dataSet.getNameValue(0, "smryDTxt") == "<p><br></p>" ||  dataSet.getNameValue(0, "smryDTxt") == "" ) {
            	alert("Deliverables를 입력하세요");
            	return;
            }
            
	        window.parent.fnSave();
        });
        
        
        function fncPtcCpsnYChk(sDt, eDt){
        	
        }

        //첨부파일 조회
        var attachFileDataSet = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet.on('load', function(e) {
            getAttachFileInfoList();
        });

        getAttachFileList = function() {
            attachFileDataSet.load({
                url: "<c:url value='/system/attach/getAttachFileList.do'/>" ,
                params :{
                    attcFilId : lvAttcFilId
                }
            });
        };

        getAttachFileInfoList = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }

            setAttachFileInfo(attachFileInfoList);
        };

        //첨부파일 등록 팝업
        getAttachFileId = function() {
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

            return lvAttcFilId;
        };

        setAttachFileInfo = function(attachFileList) {
            $('#attchFileView').html('');

            for(var i = 0; i < attachFileList.length; i++) {
                $('#attchFileView').append($('<a/>', {
                    href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                    text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                })).append('<br/>');
            }

            if(attachFileList.length > 0) {
                lvAttcFilId = attachFileList[0].data.attcFilId;
                dataSet.setNameValue(0, "attcFilId", lvAttcFilId)
            }

            initFrameSetHeight("smryFormDiv");
        };

        downloadAttachFile = function(attcFilId, seq) {
            smryForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            smryForm.submit();
        };


        tabViewS = new Rui.ui.tab.LTabView({
            tabs: [
                {
                    label: 'Needs',
                    content: ''
                }, {
                    label: 'Approach',
                    content: ''
                }, {
                    label: 'Benefit',
                    content: ''
                }, {
                    label: 'Competition',
                    content: ''
                }, {
                    label: 'Deliverables ',
                    content: ''
                }
            ]
        });

        tabViewS.on('activeTabChange', function(e){
            var index = e.activeIndex;
            
        	if( index == 0 ){
	    		document.getElementById("divWec0").style.display = "block";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "none";	
	    		document.getElementById("divWec3").style.display = "none";	
	    		document.getElementById("divWec4").style.display = "none";	
	    	
	    	}else if( index == 1 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "block";	
	    		document.getElementById("divWec2").style.display = "none";
	    		document.getElementById("divWec3").style.display = "none";	
	    		document.getElementById("divWec4").style.display = "none";
	    	}else if( index == 2 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "block";	
	    		document.getElementById("divWec3").style.display = "none";	
	    		document.getElementById("divWec4").style.display = "none";
	    	}else if( index == 3 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "none";	
	    		document.getElementById("divWec3").style.display = "block";	
	    		document.getElementById("divWec4").style.display = "none";
	    	}else if( index == 4 ){
	    		document.getElementById("divWec0").style.display = "none";	
	    		document.getElementById("divWec1").style.display = "none";	
	    		document.getElementById("divWec2").style.display = "none";	
	    		document.getElementById("divWec3").style.display = "none";	
	    		document.getElementById("divWec4").style.display = "block";
	    	}
        });
	
        tabViewS.render('tabViewS');

        //최초 데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet.loadData(${result});
        } else {
            console.log("smry searchData2");
            dataSet.newRecord();
            tabViewS.selectTab(0);
        }

        //버튼 비활성화 셋팅
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
		}

        if(window.parent.isEditable){
            btnSave.show();
            $("#btnSave").show();
        }else{
            disableFields();
        }

        //Form 바인드
        	var bind = new Rui.data.LBind({
                    groupId: 'smryFormDiv',
                    dataSet: dataSet,
                    bind: true,
                    bindInfo: [
                          { id: 'tssCd',            ctrlId: 'tssCd',            value: 'value' }
                        , { id: 'smryNTxt',         ctrlId: 'smryNTxt',         value: 'value' }
                        , { id: 'smryATxt',         ctrlId: 'smryATxt',         value: 'value' }
                        , { id: 'smryBTxt',         ctrlId: 'smryBTxt',         value: 'value' }
                        , { id: 'smryCTxt',         ctrlId: 'smryCTxt',         value: 'value' }
                        , { id: 'smryDTxt',         ctrlId: 'smryDTxt',         value: 'value' }
                        , { id: 'mrktSclTxt',       ctrlId: 'mrktSclTxt',       value: 'value' }
                        , { id: 'ctyOtPlnM',        ctrlId: 'ctyOtPlnM',        value: 'html' }
                        , { id: 'smrSmryTxt',       ctrlId: 'smrSmryTxt',       value: 'value' }
                        , { id: 'smrGoalTxt',       ctrlId: 'smrGoalTxt',       value: 'value' }
                        , { id: 'bizPrftProY',      ctrlId: 'bizPrftProY',      value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'bizPrftProY1',     ctrlId: 'bizPrftProY1',     value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'bizPrftProY2',     ctrlId: 'bizPrftProY2',     value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'bizPrftProY3',     ctrlId: 'bizPrftProY3',     value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'bizPrftProY4',     ctrlId: 'bizPrftProY4',     value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'bizPrftPlnY',      ctrlId: 'bizPrftPlnY',      value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'bizPrftPlnY1',     ctrlId: 'bizPrftPlnY1',     value: 'html', renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'bizPrftPlnY2',     ctrlId: 'bizPrftPlnY2',     value: 'html', renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'nprodSalsPlnY',    ctrlId: 'nprodSalsPlnY',    value: 'html', renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'nprodSalsPlnY1',   ctrlId: 'nprodSalsPlnY1',   value: 'html', renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'nprodSalsPlnY2',   ctrlId: 'nprodSalsPlnY2',   value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'expArslY',         ctrlId: 'expArslY',         value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'expArslY1',        ctrlId: 'expArslY1',        value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'expArslY2',        ctrlId: 'expArslY2',        value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'expArslY3',        ctrlId: 'expArslY3',        value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'expArslY4',        ctrlId: 'expArslY4',        value: 'html' , renderer: function(value) {
                        	//if ( parseFloat(value) > 0 ){
	                        	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			//}else{
                			//	return "";
                			//}
                        }
                    }    
                        , { id: 'ptcCpsnY',         ctrlId: 'ptcCpsnY',         value: 'html' }
                        , { id: 'ptcCpsnY1',        ctrlId: 'ptcCpsnY1',        value: 'html' }
                        , { id: 'ptcCpsnY2',        ctrlId: 'ptcCpsnY2',        value: 'html' }
                        , { id: 'ptcCpsnY3',        ctrlId: 'ptcCpsnY3',        value: 'html' }
                        , { id: 'ptcCpsnY4',        ctrlId: 'ptcCpsnY4',        value: 'html' }
                        
                        
                        
                        , { id: 'bizPrftProYBefore',      ctrlId: 'bizPrftProYBefore',      value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'bizPrftProY1Before',     ctrlId: 'bizPrftProY1Before',     value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'bizPrftProY2Before',     ctrlId: 'bizPrftProY2Before',     value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'bizPrftProY3Before',     ctrlId: 'bizPrftProY3Before',     value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'bizPrftProY4Before',     ctrlId: 'bizPrftProY4Before',     value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'bizPrftPlnYBefore',      ctrlId: 'bizPrftPlnYBefore',      value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'bizPrftPlnY1Before',     ctrlId: 'bizPrftPlnY1Before',     value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'bizPrftPlnY2Before',     ctrlId: 'bizPrftPlnY2Before',     value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'nprodSalsPlnYBefore',    ctrlId: 'nprodSalsPlnYBefore',    value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'nprodSalsPlnY1Before',   ctrlId: 'nprodSalsPlnY1Before',   value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'nprodSalsPlnY2Before',   ctrlId: 'nprodSalsPlnY2Before',   value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'expArslYBefore',         ctrlId: 'expArslYBefore',         value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'expArslY1Before',        ctrlId: 'expArslY1Before',        value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'expArslY2Before',        ctrlId: 'expArslY2Before',        value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'expArslY3Before',        ctrlId: 'expArslY3Before',        value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'expArslY4Before',        ctrlId: 'expArslY4Before',        value: 'html'  , renderer: function(value) {
                        	if ( parseFloat(value) > 0 ){
                            	return Rui.util.LFormat.numberFormat(parseFloat(value));
                			}else{
                				return "";
                			}
                        }
                    }    
                        , { id: 'ptcCpsnYBefore',         ctrlId: 'ptcCpsnYBefore',         value: 'html' }
                        , { id: 'ptcCpsnY1Before',        ctrlId: 'ptcCpsnY1Before',        value: 'html' }
                        , { id: 'ptcCpsnY2Before',        ctrlId: 'ptcCpsnY2Before',        value: 'html' }
                        , { id: 'ptcCpsnY3Before',        ctrlId: 'ptcCpsnY3Before',        value: 'html' }
                        , { id: 'ptcCpsnY4Before',        ctrlId: 'ptcCpsnY4Before',        value: 'html' }
                        , { id: 'pmisTxt',       	ctrlId: 'pmisTxt',       	value: 'value' }
                        , { id: 'userId',           ctrlId: 'userId',           value: 'value' }
                        , { id: 'attcFilId',        ctrlId: 'attcFilId',        value: 'value' }
                    ]
    	});

    });
    //평균구하기
    function fnGetYAvg(gbn) {
    }


    //validation
    function fnIfmIsUpdate(gbn) {
    }
    
    function fncPtcCpsnYDisable(sDt, eDt){
    }
    
    
    function fnIfmInit(){
    }
    
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("smryFormDiv");
});
</script>
</head>
<body style="overflow: hidden">
<div id="smryFormDiv">
    <form name="smryForm" id="smryForm" method="post" style="padding: 10px 1px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        <input type="hidden" id="attcFilId" name="attcFilId" value=""/>

        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 20%;" />
                <col style="width: 16%;" />
                <col style="width: 16%;" />
                <col style="width: 16%;" />
                <col style="width: 16%;" />
                <col style="width: 16%;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">Summary 개요</th>
                    <td colspan="5" class="space_tain"><input type="text" id="smrSmryTxt" name="smrSmryTxt"  ></td>
                </tr>
                <tr>
                    <th align="right">Summary 목표</th>
                    <td colspan="5" class="space_tain"><input type="text" id="smrGoalTxt" name="smrGoalTxt"  ></td>
                </tr>
                <tr>
                    <th align="right" rowspan="2">개요 상세</th>
                    <td colspan="5">
                        <div id="tabViewS"></div>
                    </td>
                </tr>
               
                <tr>
                    <td colspan="5">
                        <div id="divWec0">
                            <textarea id="smryNTxt" name="smryNTxt"></textarea>
                            <script>
                                Wec0 = new NamoSE('smryNTxt');
                                Wec0.params.Width = "100%";
                                Wec0.params.UserLang = "auto";
                                Wec0.params.Font = fontParam;
                                Wec0.params.ImageWidthLimit = 600;
                                uploadPath = "<%=uploadPath%>";
                                Wec0.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec0.params.FullScreen = false;
                                Wec0.EditorStart();
                            </script>
                        </div>
                        <div id="divWec1"  style="display:none">
                            <textarea id="smryATxt" name="smryATxt"></textarea>
                            <script>
                                Wec1 = new NamoSE('smryATxt');
                                Wec1.params.Width = "100%";
                                Wec1.params.UserLang = "auto";
                                Wec1.params.Font = fontParam;
                                Wec1.params.ImageWidthLimit = 600;
                                uploadPath = "<%=uploadPath%>";
                                Wec1.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec1.params.FullScreen = false;
                                Wec1.EditorStart();

                            </script>
                        </div>
                        <div id="divWec2"  style="display:none">
                            <textarea id="smryBTxt" name="smryBTxt"></textarea>
                            <script>
                                Wec2 = new NamoSE('smryBTxt');
                                Wec2.params.Width = "100%";
                                Wec2.params.UserLang = "auto";
                                Wec2.params.Font = fontParam;
                                Wec2.params.ImageWidthLimit = 600;
                                uploadPath = "<%=uploadPath%>";
                                Wec2.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec2.params.FullScreen = false;
                                Wec2.EditorStart();
                            </script>
                        </div>
                        <div id="divWec3"  style="display:none">
                            <textarea id="smryCTxt" name="smryCTxt"></textarea>
                            <script>
                                Wec3 = new NamoSE('smryCTxt');
                                Wec3.params.Width = "100%";
                                Wec3.params.UserLang = "auto";
                                Wec3.params.Font = fontParam;
                                Wec3.params.ImageWidthLimit = 600;
                                uploadPath = "<%=uploadPath%>";
                                Wec3.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec3.params.FullScreen = false;
                                Wec3.EditorStart();
                            </script>
                        </div>
                        <div id="divWec4"  style="display:none">
                            <textarea id="smryDTxt" name="smryDTxt"></textarea>
                            <script>
                                Wec4 = new NamoSE('smryDTxt');
                                Wec4.params.Width = "100%";
                                Wec4.params.UserLang = "auto";
                                Wec4.params.Font = fontParam;
                                Wec4.params.ImageWidthLimit = 600;
                                uploadPath = "<%=uploadPath%>";
                                Wec4.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec4.params.FullScreen = false;
                                Wec4.EditorStart();
                            </script>
                        </div>
                        <script type="text/javascript" language="javascript">
                            function OnInitCompleted(e){
                            	e.editorTarget.SetBodyValue(document.getElementById("divWec0").value);
                                e.editorTarget.SetBodyValue(document.getElementById("divWec1").value);
                                e.editorTarget.SetBodyValue(document.getElementById("divWec2").value);
                                e.editorTarget.SetBodyValue(document.getElementById("divWec3").value);
                                e.editorTarget.SetBodyValue(document.getElementById("divWec4").value); 
                            }
                        </script>                        
                    </td>
                </tr>
                <tr>
                    <th align="right">시장규모</th>
                    <td colspan="5" class="space_tain"><input type="text" id="mrktSclTxt" name="mrktSclTxt"></td>
                </tr>
                <tr>
                    <th align="right">상품출시(계획)</th>
                    <td colspan="5"><span id="ctyOtPlnM" /></td>
                </tr>
   				<tr  id="trbizPrftProHead"  >
                    <th rowspan="2">영업이익율(%)</th>
                    <th class="alignC">출시년도</th>
                    <th class="alignC">출시년도+1</th>
                    <th class="alignC">출시년도+2</th>
                    <th class="alignC">출시년도+3</th>
                    <th class="alignC">출시년도+4</th>
                </tr>
                <tr id="trbizPrftPro">
                    <td class="alignR"><span id="bizPrftProY" ></td>
                    <td class="alignR"><span id="bizPrftProY1" ></td>
                    <td class="alignR"><span id="bizPrftProY2" ></td>
                    <td class="alignR"><span id="bizPrftProY3" ></td>
                    <td class="alignR"><span id="bizPrftProY4"></td>
                </tr>
                <tr id="trbizPrftPlnHead"  >
                    <th rowspan="2">영업이익(억원)</th>
                    <th class="alignC">출시년도</th>
                    <th class="alignC">출시년도+1</th>
                    <th class="alignC">출시년도+2</th>
                    <th class="alignC">출시년도+3</th>
                    <th class="alignC">출시년도+4</th>
                </tr>
                <tr id="trbizPrftPln" >
                    <td class="alignR"><span id="bizPrftPlnY"></td>
                    <td class="alignR"><span id="bizPrftPlnY1" ></td>
                    <td class="alignR"><span id="bizPrftPlnY2" ></td>
                    <td class="alignR"></td>
                    <td class="alignR"></td>
                </tr>
                <tr id="trNprodSalHead" >
                    <th rowspan="2">신제품 매출계획(단위:억원)</th>
                    <th class="alignC">출시년도</th>
                    <th class="alignC">출시년도+1</th>
                    <th class="alignC">출시년도+2</th>
                    <th class="alignC">출시년도+3</th>
                    <th class="alignC">출시년도+4</th>
                </tr>
                <tr id="trNprodSal" >
                    <td class="alignR"><span id="nprodSalsPlnY" ></td>
                    <td class="alignR"><span id="nprodSalsPlnY1" ></td>
                    <td class="alignR"><span id="nprodSalsPlnY2"></td>
                    <td class="alignR"></td>
                    <td class="alignR"></td>
                </tr>
                <tr id="trPtcCpsnHead">
                    <th rowspan="2">투입인원(M/M)</th>
                    <th class="alignC">Y<br/>(과제 시작 년도)</th>
                    <th class="alignC">Y+1</th>
                    <th class="alignC">Y+2</th>
                    <th class="alignC">Y+3</th>
                    <th class="alignC">Y+4</th>
                </tr>
                <tr id="trPtcCpsn">
                    <td class="alignR"><span id="ptcCpsnY" ></td>
                    <td class="alignR"><span id="ptcCpsnY1"></td>
                    <td class="alignR"><span id="ptcCpsnY2"></td>
                    <td class="alignR"><span id="ptcCpsnY3"></td>
                    <td class="alignR"><span id="ptcCpsnY4"></td>
                </tr>
                <tr id="trExpArslHead">
                    <th rowspan="2">투입비용</th>
                    <th class="alignC">Y<br/>(과제 시작 년도)</th>
                    <th class="alignC">Y+1</th>
                    <th class="alignC">Y+2</th>
                    <th class="alignC">Y+3</th>
                    <th class="alignC">Y+4</th>
                </tr>
                <tr id="trExpArsl">
                    <td class="alignR"><span id="expArslY" ></td>
                    <td class="alignR"><span id="expArslY1"></td>
                    <td class="alignR"><span id="expArslY2"></td>
                    <td class="alignR"><span id="expArslY3" ></td>
                    <td class="alignR"><span id="expArslY4" ></td>
                </tr>
                <tr>
                    <th align="right">지적재산팀 검토의견</th>
                    <td colspan="5" class="space_tain"><input type="text" id="pmisTxt" name="pmisTxt"></td>
                </tr>
                <tr>
                    <th align="right">GRS심의파일<br/>(심의파일, 회의록 필수 첨부)</th>
                    <td colspan="5" id="attchFileView">&nbsp;</td>
                </tr>
            </tbody>
        </table>
    </form>
    <div class="titArea btn_btm">
        <div class="LblockButton">
            <button type="button" id="btnReport" name="btnReport">Report</button>
            <button type="button" id="btnSave" name="btnSave">저장</button>
            <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
        </div>
    </div>
</div>
</body>
</html>