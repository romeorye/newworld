/********************************************************************
*  Function Name : createDashDateToString(date) / createDashMonthToString(date)
*  Description   : date를 '-' 붙인 문자열로 반환
*  Input Data    : javascript date 타입 데이터
*  Output Data   : YYYY-MM-DD 문자열 / YYYY-MM 문자열
********************************************************************/
function pad(num) {
    num = num + '';
    return num.length < 2 ? '0' + num : num;
}
function createDashDateToString(date){
    return date.getFullYear() + '-' + pad(date.getMonth()+1) + '-' + pad(date.getDate());
}

function createDashMonthToString(date){
    return date.getFullYear() + '-' + pad(date.getMonth()+1);
}

/********************************************************************
*  Function Name : addDashMonthToString(dashMonth, i)
*  Description   : 월계산 후  '-' 붙인 문자열로 반환
*  Input Data    : YYYY-MM 문자열
*  Output Data   : YYYY-MM 문자열
********************************************************************/
function addDashMonthToString(dashMonth, i){
    var arrDashMonth = dashMonth.split('-');
    var addMonthDate = new Date(arrDashMonth[0],arrDashMonth[1],'01');
    addMonthDate.setMonth(addMonthDate.getMonth() + i);

    return addMonthDate.getFullYear() + '-' + pad(addMonthDate.getMonth()+1);
}

/********************************************************************
 *  Function Name : stringNullChk(str)
 *  Description   : 문자열을 null체크 후 공백 또는 input값으로 반환
 *  Input Data    : 문자열
 *  Output Data   : 문자열
 ********************************************************************/
function stringNullChk(str) {

    var rtStr = "";

    if(str == null || str == "" || str == "undefined") rtStr = "";
    else {
        if(typeof str == "string") rtStr = str.trim();
        else rtStr = str;
    }

    return rtStr;
}
/********************************************************************
 *  Function Name : numberNullChk(str)
 *  Description   : 문자열을 null체크 후 0 또는 input값으로 반환
 *  Input Data    : 문자열
 *  Output Data   : 숫자
 ********************************************************************/
function numberNullChk(str) {

    var rtStr = 0;

    if(str == null || str == "" || str == "undefined") { rtStr = 0; }
    else {
        if(typeof str == "number") { rtStr = str; }
        else if(typeof str == "string" && !isNaN(str)) { rtStr = parseInt(str.trim()); }
    }

    return rtStr;
}

/********************************************************************
 *  Function Name : floatNullChk(str)
 *  Description   : 문자열을 null체크 후 0.0 또는 input값으로 반환
 *  Input Data    : 문자열
 *  Output Data   : 숫자
 ********************************************************************/
function floatNullChk(str) {

    var rtStr = 0;

    if(str == null || str == "" || str == "undefined") { rtStr = 0; }
    else {
        if(typeof str == "float") { rtStr = str; }
        else if(typeof str == "string" && !isNaN(str)) { rtStr = parseFloat(str.trim()); }
    }

    return rtStr;
}

/********************************************************************
 *  Function Name : openWindow(mypage, myname, w, h, scroll)
 *  Description   : 모달리스 팝업창 띄우기
 *  Input Data    : mypage -> page url
 *                  myname -> target name
 *                  w -> width
 *                  h -> height
 *                  scroll -> scroll 여부
 *  Output Data   :
 ********************************************************************/
function openWindow(mypage, myname, w, h, scroll) {
    var winl = (screen.width - w) / 2;
    var wint = (screen.height - h) / 2;

    winprops = 'height=' + h + ',width=' + w + ',top=' + wint + ',left=' + winl
             + ',scrollbars=' + scroll + ',resizable, status=yes';
    win    = open(mypage, myname, winprops);

    if (parseInt(navigator.appVersion) >= 4) {
        win.window.focus();
    }
}


/********************************************************************
 *  Function Name : initFrameSetHeight(pId)
 *  Description   : iFrame 높이 조정
 *  Input Data    : pId -> body영역의 높이를 알 수 있는 ID
 *  Output Data   :
 ********************************************************************/
function initFrameSetHeight(pId) {
    var pageHeight;

    if(stringNullChk(pId) != "") {
        pageHeight = $("#"+pId).height();
    } else {
        var body = document.body;
        var html = document.documentElement;

        console.log('elemnet size?', {
            bodyScrollheight: body.scrollHeight,
            bodyOffsetHeight: body.offsetHeight,
            bodyClientHeight: body.clientHeight,
            htmlScrollHeight: html.scrollHeight,
            htmlOffsetHeight: html.offsetHeight,
            htmlClientHeight: html.clientHeight
        })

        pageHeight = Math.max( body.scrollHeight+50, body.offsetHeight+50, html.clientHeight+50, html.scrollHeight+50, html.offsetHeight+50 );
      //pageHeight = Math.max( body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight );

    }

    var fId = window.frameElement.id;

    window.parent.document.getElementById(fId).height = pageHeight+'px';
}

$(function () {

    $('.leftCon').on('click', function () {
        parent.setMenuFrame();
    });

    // Search toggle
  /*
    var searhButton = '';
        searhButton += '<div class="search-toggleBtn">';
        searhButton +=   '<button type="button" class="btn btn-default">';
        searhButton +=       '<span>Fold</span>';
        searhButton +=   '</button>';
        searhButton += '</div>';
    $('form[name="aform"] table').each(function(){
        var searchTr = $(this).children().find('tr');
        if(searchTr.length > 2) {
            searchTr.eq(1).addClass('display-row');
            $(this).parent().append(searhButton);
        };
        if($(this).hasClass('in') == true) {
               searchTr.eq(1).removeClass('display-row');
               $('.search-toggleBtn').addClass('spread');
            };
        $('.search-toggleBtn').on('click', function(){
            if(searchTr.eq(2).css('display') == 'none') {
               searchTr.eq(1).removeClass('display-row');
               $(this).addClass('spread');
            } else{
                searchTr.eq(1).addClass('display-row');
                $(this).removeClass('spread');
            }
        });
    });  */

});



function chgChar(str){
    alert(str);
}

//[20240419.siseo]사원정보 팝업
function getPersonInfo(sabunnew, loginSabun){
    //var popupUrl = "http://lghsearch.lxhausys.com:8501/empSearchNew/emp.jsp?sabunnew=" + sabunnew +"&loginSabun=" + loginSabun ;
    var popupUrl = "http://gportal.lxhausys.com/portal/main/listUserMain.do?hideOrgYN=true&rightFrameUrl=/support/profile/getProfile.do?targetUserId="+loginSabun ;
    var popupOption = "width=900, height=700, top=300, left=400";
    window.open(popupUrl,"pInfo",popupOption);
}
