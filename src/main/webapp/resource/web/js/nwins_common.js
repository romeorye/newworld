/********************************************************************
*  Function Name : ruiSessionFail(e)                                *
*  Description   : 세션없는 경우 로긴화면으로 이동                           *
*  Input Data    : LDataSetManager의 failure event                   *
*  Output Data   : 로긴화면이동 또는 경고창                                *
********************************************************************/



function ruiSessionFail(e)
{
    if( e.status == '999') {
     	Rui.alert(Rui.getMessageManager().get('$.message.msgSessionOut')); //세션연결이 종료되었습니다. 다시 로긴해 주시기 바랍니다.
     	document.location = contextPath + "/common/login/sessionError.do";
     } else {
     	Rui.alert(Rui.getMessageManager().get('$.message.msg001'));
     }	
}


/* modal창 오픈*/
function nwinsOpenModal(loc, args, width, height, scrollbar) {
  if(!args)
    args = new Object();
  var agent = navigator.userAgent.toLowerCase();
  var scroll = (scrollbar == "1" ? "yes" : "no")
  if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
            
	  var ret = window.showModalDialog(loc, args, "dialogWidth:"+width+"px;dialogHeight:"+height+"px;scroll:"+scroll+";status:no");
	  args.returnValue = ret;
  }else{
	  alert("Internet Explorer browser인지 확인해 주세요");
  }
  return args;
}

/* 팝업오픈 */
function nwinsOpenWin(loc,popname,width,height,left,top,popStyle,scrollbar) {
  var args = nwinsOpenWin.arguments;

  if(args.length < 3) {
    width = document.body.clientWidth / 2;
    height = document.body.clientHeight / 2;
  } 
  if(args.length < 5) {
    left = (screen.width - width) / 2;
    top = (screen.height - height) / 2;
  }
  var scroll = (scrollbar == "1" ? "1" : "0")

  var status = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars="+scroll+",resizable=no,width=" + width + ",height=" + height + ",top=" + top + ",left=" + left;

  if(popStyle!="1"){
	  //openw = 
		  window.open(loc,popname,status);
  }else{
	  //openw = 
		  window.open(loc,popname);
  }
  //return openw;
}

/* 문자바꾸기  */
function nwinsReplaceAll(str, orgStr, destStr){
  var i = 0;
  while(i >= 0){
    i = str.indexOf(orgStr, i);
    if(i >= 0){
      str = str.replace(orgStr,destStr);
    }else{
      break;
    }
  }
  return str;
}
/* 문자바꾸기  */
function nwinsReplaceAll2(str, orgStr, destStr){
	var i = 0;
	if(str){
		while(i >= 0){
			i = str.indexOf(orgStr, i);
			if(i >= 0){
				str = str.replace(orgStr,destStr);
			}else{
				break;
			}
		}
		return str;
	}else{
	  var	str = ""; 
	  return str;
	}
	
}

/*******************************************************************************
* FUNCTION 명 : nwinsGetBetweenDay( startDt, endDt, fromToDayMax ) - 2011.11.08 양호진
* FUNCTION 기능설명 : 조회종료일 - 조회시작일 > 최대일자 클경우    
* INPUT  : startDt(YYYYMMDD)-조회시작일, endDt(YYYYMMDD)-조회종료일, fromToDayMax(31일)-조회기간최대일
* RETURN : rtnTrueFalse : true => 통과 , false=> 통과못함
*         -1       : ERROR..!
*    MSG :
*******************************************************************************/
function nwinsGetBetweenDay( startDt, endDt, fromToDayMax )
{
	//alert(startDt);
	//alert(endDt);
    var rtnValue = 0 ;		//조회기간 차이
    var rtnTrueFalse = true ;	//리턴값 

    var yyyy = startDt.substring(0,4) +"" ;
    var mm   = startDt.substring(4,6) +"" ;
    var dd   = startDt.substring(6,8) +"" ;
    var startDate = new Date(yyyy,(eval(mm)-1),dd) ; // 달 은 한달이 느리므로 1을 빼준다.
    //alert(startDate);

    yyyy = endDt.substring(0,4) +"" ;
    mm   = endDt.substring(4,6) +"" ;
    dd   = endDt.substring(6,8) +"" ;
    var endDate = new Date(yyyy,(eval(mm)-1),dd) ;
    //alert(endDate);

    // 1000분의 1초 단위를 일 단위로 바꾸기
    rtnValue = ((endDate-startDate)/60/60/24/1000) ;	//조회종료일 - 조회시작일
    
    if (rtnValue > fromToDayMax-1 ) { //(종료일 - 시작일) > (조회기간 최대값 -1) 		
    	rtnTrueFalse = false ;
	}
    
	return rtnTrueFalse ;
}


function nwinsActSubmit(oform, action, target) {
	if (target) oform.target = target;
	if (action) oform.action = action;
	if (!oform.method) oform.method = "post";
	oform.submit();
}

//utf-8 encoding
function toUTF8(szInput)
{
	var wch,x,uch="",szRet="";
	for (x=0; x<szInput.length; x++) {
		wch=szInput.charCodeAt(x);
		if (!(wch & 0xFF80)) {
			szRet += "%" + wch.toString(16);
		}
		else if (!(wch & 0xF000)) {
			uch = "%" + (wch>>6 | 0xC0).toString(16) + "%" + (wch & 0x3F | 0x80).toString(16);
			szRet += uch;
		}else {
			uch = "%" + (wch >> 12 | 0xE0).toString(16) + "%" + (((wch >> 6) & 0x3F) | 0x80).toString(16) + "%" + (wch & 0x3F | 0x80).toString(16);
			szRet += uch;
		}
	}
	return(szRet);
}


/*******************************************************************************
* FUNCTION 명 : divDisplay(divId, displayYn)
* FUNCTION 기능설명 :  div display 처리
* 예시  : divDisplay("header")				// header div display <-> block
*         divDisplay("header", "Y")			// header div display 여부 지정
*                                           // 대신 보여줄 div 지정 가능 - 'headerN'
* Param			: divId			display와 관련된 div id [대신 보여줄 div Id 추가 가능]
* 				  displayYn		display 여부 - "Y", "N"
*******************************************************************************/
function divDisplay(divId, displayYn){

	var divIdN = divId + "N";
	var divId  = document.getElementById(divId);
	var divIdN = document.getElementById(divIdN);

	if(divId == null) return;		//alert("divId not setting..");
	
	if(displayYn != null) {
		if(displayYn == "Y") {
			divId.style.display  = 'inline';
			if(divIdN != null) divIdN.style.display = 'none';
		} else if(displayYn == "N") {
			divId.style.display  = 'none';
			if(divIdN != null) divIdN.style.display = 'inline';
		}
	} else {
		if (divId.style.display == 'none') {
			divId.style.display  = 'inline';
			if(divIdN != null) divIdN.style.display = 'none';
		} else if (divId.style.display == 'inline') {
			divId.style.display  = 'none';
			if(divIdN != null) divIdN.style.display = 'inline';
		}
	}
}

/*******************************************************************************
* 				  replace : cfReplaceAll(dataSetMain0.getAt(row).get("reqDt"), "-", "")
*******************************************************************************/
function cfReplaceAll(str, orgStr, destStr){
	  var i = 0;
	  while(i >= 0){
	    i = str.indexOf(orgStr, i);
	    if(i >= 0){
	      str = str.replace(orgStr,destStr);
	    }else{
	      break;
	    }
	  }
	  return str;
	}

/*******************************************************************************
* FUNCTION 명 : chgPerStr(tag, frm)
* FUNCTION 기능설명 : 문자열 변경
* 예시              : chgPerStr("inc", document.aform);	// % 문자열 처리(incode)
*                     chgPerStr("dec", document.aform);	// % 문자열 처리(decode)
*******************************************************************************/
function chgPerStr(tag, frm) {
	
	for(i=0; i<frm.elements.length; i++) {
		if(frm.elements[i].type=="text" 	  ||
		   frm.elements[i].type=="textarea"		) {

			if(tag == "inc") 		{
				if(frm.elements[i].value.match("%")) 		frm.elements[i].value = cfReplaceAll(frm.elements[i].value, '%'    ,"_per_" );
			} else if(tag == "dec")	{
				if(frm.elements[i].value.match("_per_")) 	frm.elements[i].value = cfReplaceAll(frm.elements[i].value, "_per_", "%"	);
			}
		}
	}
}

/********************************************************************
*  Function Name : convertToUpperCase()                             *
*  Description   : 입력받은 문자를 대문자로 변경                            *
*                  예시) "aabbcc" -> "AABBCC"                         *
*  Input Data    : theField                                         *
*  Output Data   : None                                             *
********************************************************************/
function convertToUpperCase(fieldObject)
{
    fieldObject.value = fieldObject.value.toUpperCase();
}

/*******************************************************************************
* FUNCTION 명 : objDisable(form, arrBtnImg, arrObject)
* FUNCTION 기능설명 : form의 오브젝트 Disable 설정
* 예시              : objDisable(
*								document.aform,		// form
*								new Array("pculConditionImg", "saveImg", "selModlImg", "chgWindLocNmImg", "colrPrizImg", "reqDtImg", "insdgrasThikImg", "ousdgrasThikImg"),	// 특수창, 저장, 모형선택,명칭변경,색상버튼,납기요청일,유리_내 두깨, 유리_외 두께 버튼
*								new Array("searchGubun")		// 구분
*					  );
* Param		     	: form	해당 form
*                     Disable Imgage
*                     Disable Object
*******************************************************************************/
function objDisable(form, arrBtnImg, arrObject) {

	var param = "?";
	var type  = "";
	var chk = true;

	for(var i=0; i<form.elements.length; i++) {
		type = form.elements[i].type;

		if(type == "checkbox" || type == "select-one" || type == "text" || type == "file" || type == "radio" || type == "textarea") {
			chk = true;
		   	for(var j = 0; j < arrObject.length; j++) {
				if(form.elements[i].name == arrObject[j]) {
					chk = false;
				   	break;
			   	}
		   	}
		   	
			if(chk == true) {
				form.elements[i].enabled  = false;
				form.elements[i].disabled = true;
			}
		}
	}

	if(arrBtnImg.length > 0) {
		for(var k = 0; k < arrBtnImg.length; k++) {
			if(form.elements[i] != null) {
				$(arrBtnImg[k]).hide();	
			}
		}
	}
}
/*******************************************************************************
* FUNCTION 명 : objEnable(form, arrBtnImg, arrObject)
* FUNCTION 기능설명 : form의 오브젝트 Enable 설정
* 예시              : objEnable(
*								document.aform,		// form
*								new Array("pculConditionImg", "saveImg", "selModlImg", "chgWindLocNmImg", "colrPrizImg", "reqDtImg", "insdgrasThikImg", "ousdgrasThikImg"),	// 특수창, 저장, 모형선택,명칭변경,색상버튼,납기요청일,유리_내 두깨, 유리_외 두께 버튼
*								new Array("searchGubun")		// 구분
*					  );
* Param		     	: form	해당 form
*                     Enable Imgage
*                     Enable Object
*******************************************************************************/
function objEnable(form, arrBtnImg, arrObject) {

	var param = "?";
	var type  = "";
	var chk = true;

	for(var i=0; i<form.elements.length; i++) {
		type = form.elements[i].type;
		if(type == "checkbox" || type == "select-one" || type == "text" || type == "file" || type == "radio" || type == "textarea") {
			chk = true;
		   	for(var j = 0; j < arrObject.length; j++) {
				if(form.elements[i].name == arrObject[j]) {
					chk = false;
				   	break;
			   	}
		   	}

			if(chk == true) {
				form.elements[i].enabled  = true;
				form.elements[i].disabled = false;
			}
		}
	}

	if(arrBtnImg.length > 0) {
		for(var k = 0; k < arrBtnImg.length; k++) {
			if(form.elements[i] != null) {
				$(arrBtnImg[k]).show();
			}
		}
	}
}
//숫자 체크
function CheckNum(tocheck)
{
	var isnum = true;
	
	if (tocheck == null || tocheck == "")
	{
		isnum = false;
		return isnum;
	}
	
	for (var j = 0 ; j < tocheck.length; j++)
	{
		if (tocheck.substring(j, j + 1) != "0" &&
		tocheck.substring(j, j + 1) != "1" &&
		tocheck.substring(j, j + 1) != "2" &&
		tocheck.substring(j, j + 1) != "3" &&
		tocheck.substring(j, j + 1) != "4" &&
		tocheck.substring(j, j + 1) != "5" &&
		tocheck.substring(j, j + 1) != "6" &&
		tocheck.substring(j, j + 1) != "7" &&
		tocheck.substring(j, j + 1) != "8" &&
		tocheck.substring(j, j + 1) != "9")
		{
			isnum = false;
		}
	}
	return isnum;
}

function js_FormatNum(ans, k){
  var val, i_split, i_mod, re_val, val_f, val_l;
  val = parseFloat(js_FormatStr(ans, k));
  val = js_trim(val.toString());
  if(isNaN(ans)){ 
     val_f = "0";

     if(k > 0){
        val_l = ".";
        for(var n = 0; n < k; n++){
           val_l = val_l + "0";
        }
     }else{
    	 val_l = "";
     }
     return val_f + val_l;
  }

  comma = val.indexOf(".");
  if(comma != -1){
      val_f = val.substr(0, comma);
      val_l = val.substr(comma, k+1);
      if( k > 0 ) {
        if(val_l.length < k+1){
          var diff = (k+1) - val_l.length;
          for(var n = 0; n < diff; n++){
             val_l = val_l + "0";
          }
        }
      }else{
        val_l = "";
      }
  }else{
      val_f = val;

      if( k > 0 ) {
        val_l = ".";
        for(var n = 0; n < k; n++){
           val_l = val_l + "0";
        }
      }else{
        val_l = "";
      }
  }

  len = val_f.length;

  if(len > 3){
    i_split = len / 3;
    i_mod = len % 3;

    if(i_mod == 0){
      re_val = val_f.substr(0, 3);
      i_mod = 3;
    }else{
      re_val = val_f.substr(0, i_mod);
    }

    for(var i=0; i<i_split-1; i++){
       if (re_val != "-")
           re_val = re_val + ',' + val_f.substr( i_mod+(i*3), 3);
       else
           re_val = re_val + val_f.substr( i_mod+(i*3), 3);
    }
    return(re_val + val_l);
  }else{
     return(val_f + val_l);
  }
}

function js_FormatStr(ans, k){
	var val = "";
	var str = ans.toString();
	var tmp = str.split(",");
	var sp_len = tmp.length;

	if(ans != ""){
		for(var i=0;i<sp_len;i++){
		  val = val + tmp[i];
		}
		
		comma = val.indexOf(".");
		
		if(comma != -1){
			val_f = val.substr(0, comma);
			val_l = val.substr(comma, k+1);
			
			if(k > 0){
				if(val_l.length < k+1){
					var diff = (k+1) - val_l.length;
					for(var n=0;n < diff;n++){
						val_l = val_l + "0";
					}
				}
			}else{
				val_l = "";
			}
		}else{
			val_f = val;
			
			if(k > 0){
				val_l = ".";
				for(var n = 0; n < k; n++){
					val_l = val_l + "0";
				}
			}else{
				val_l = "";
			}
		}
		
		return val_f + val_l;
	}else{
		return 0;
	}
}

function js_trim(sValue){
	var idx = sValue.indexOf(" ");
	while(idx > -1){
	    if(idx > 0) break;
	    else{
	        sValue = sValue.substr(idx+1);
	        idx = sValue.indexOf(" ");
	    }
	}
	idx = sValue.lastIndexOf(" ");
	while(idx > -1){
	    if(idx < sValue.length - 1) break;
	    else{
	        sValue = sValue.substring(0, idx);
	        idx = sValue.lastIndexOf(" ");
	    }
	}
	
	return sValue;
}

function isValidDate(s) {
	var pt = /^\d{4}\d{2}\d{2}$/;
	if (!pt.test(s)) return false;
	var y = parseInt(s.substr(0,4), 10);
	var m = parseInt(s.substr(4,2), 10) - 1;
	var d = parseInt(s.substr(6,2), 10);
	var dt = new Date(y, m, d);
	
	if (dt.getFullYear() == y && dt.getMonth() == m && dt.getDate() == d) {
		return true;
	} else {
		return false;
	}
}

/*******************************************************************************
* FUNCTION 명 : changeInput
* FUNCTION 기능설명	: form의 KeyIn 값중에 아래의 문자를 포함하면 치환된 값을 리턴함 
* 문자 &, <, >, #, ", ', (, ), /, \, : 
* 예시  : 
*******************************************************************************/
function changeInput(form) {

	var type  = "";
	var str = "";
	var chkChar = ["&", "<", ">", "#", "\"", "'", "(", ")", "/", "\\", ":", "\n"];
	var chgChar = ["&amp;", "&lt;", "&gt;", "&#35;", "&quot;", "&#39;", "&#40;", "&#41;", "&#47;", "&#92;", "&#59;", "<br>"];
	var chgValue = "";

	for(var i=0; i<form.elements.length; i++) {
		type = form.elements[i].type;

		if(type == "text") {
			if(form.elements[i].readOnly){
				//변경대상이 아님
			}else{
		    	for (var j = 0; j < chkChar.length; j++){
		    		form.elements[i].value = replaceInput(form.elements[i].value,chkChar[j],chgChar[j]);
		    	}
			}
		}else if (type == "textarea"){
			form.elements[i].value = replaceInput(form.elements[i].value,chkChar[1],"{@");
			form.elements[i].value = replaceInput(form.elements[i].value,chkChar[2],"@}");
		}

	}
}

function replaceInput(str, ori, req){
	return str.split(ori).join(req);
}

function nullToString(aa){	
	var retS = "";
	if(aa == "undefined" || aa == null || aa == 'null') {
		return retS;
	}
	return aa;
}

/*******************************************************************************
* FUNCTION 명 : isValidFloat
* FUNCTION 기능설명	: 정수여부 체크. 음수도 true일 수 있으므로 음수를 허용하지 않는 경우에는 별도의 validation 필요 
* Param			: str	비교할 입력값
* return : T/F
* 예시 : '2.34', '2', '-234.34'(minusYn == true일 때)는 true
* 		'2..23', '2.12..3' 등은 false
* 		숫자, '-', '.'외의 문자가 포함된 경우 false
* 		
* 		
*******************************************************************************/
function isValidFloat1(str){
     var isFloat = true;

     var chkPoint = false;
     var chkMinus = false;

     for (j = 0 ; isFloat && (j < str.length); j++){
         if ((str.substring(j,j+1) < "0") || (str.substring(j,j+1) > "9")){
            if (str.substring(j,j+1) == "." ){
               if (!chkPoint) {
            	   chkPoint = true;
               }
               else{
            	   isFloat = false;
               }
            }else if (str.substring(j,j+1) == "-"){
	               if (( j == 0) && (!chkMinus)) chkMinus = true ;
	               else isFloat = false;
	            }
            else isFloat = false;
        }
    }
    return isFloat;
}

/*******************************************************************************
* FUNCTION 명 : isValidDecimal
* FUNCTION 기능설명	: 소수점 자리수 체크 
* Param			: str	비교할 입력값
* 				  positive 정수부분 자릿수
* 				  negative 소수점 이하 자릿수
* return : T/F
* 예시 : isValidDecimal(str, '2', '3') 
* positive == 2, negative == 3인 경우 - '2.12', '23.315', '1' 은 true, '2.1345', '345.2' 등은 false
* 		
*******************************************************************************/

function isValidDecimal(str, positive, negative){
    var isPoint = true;

    if (isValidFloat1(str)){
        var inx = str.indexOf(".");

        if ( inx == -1 ){
             if (str.length > parseInt(positive)){
                isPoint = false;
             }else{
                isPoint = true;
             }
         }else{
              var pos = str.substring( 0, inx );
              var nev = str.substring(inx + 1);

              if (pos.length > parseInt(positive)){
                    isPoint = false;
              }else if (nev.length > parseInt(negative)){
                    isPoint = false;
              }else{
                    isPoint = true;
              }
         }
     }else{
           isPoint = false;
     }
     return isPoint;
}

function changeInputUtf8(form) {

	for(var i=0; i<form.elements.length; i++) {
		if(form.elements[i].readOnly){
			//변경대상이 아님
		}else{
    		form.elements[i].value = encodeURIComponent(form.elements[i].value);
		}
	}
}
