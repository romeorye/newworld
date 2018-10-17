
var aCnt = 10;		//게시물수
var pCnt = 10;		//페이지 수
var pDs;
var pId;
var nowP = 1;
var totalPCnt=0;


function paging(dsSet,gridId){

    pDs = dsSet;

    $("#paging").remove();
    var total = pDs.getCount(); // 전체 게시물수
    totalPCnt = Math.ceil(total/aCnt);	//전체 페이지수
    if(totalPCnt<1)totalPCnt = 1;


    $("#"+gridId).after("<div id='paging'></div>");
    $("#paging").css("padding-top","10px");
    $("#paging").css("text-align","center");

    pagingSetPage(1);
}

function pagingSetList(){
    $("#paging").children().remove();
    var startP = Math.floor((nowP-1)/10)*10+1
    var endP = startP+ pCnt;
    if(endP>totalPCnt)endP = totalPCnt+1;

    $("#paging").append("<a href='javascript:pagingSetPage(1)'><img src='/iris/resource/web/images/newIris/pagenate_first.png'></a>").css;
    $("#paging").append("<a href='javascript:pagingSetPage(\"befor\")'><img src='/iris/resource/web/images/newIris/pagenate_prev.png'></a>");
    for(var i=startP;i<=endP-1;i++){
        $("#paging").append("<a name='"+i+"' href='javascript:pagingSetPage("+i+")'>"+i+"</a>");
    }
    $("#paging").append("<a href='javascript:pagingSetPage(\"next\")'><img src='/iris/resource/web/images/newIris/pagenate_next.png'></a>");
    $("#paging").append("<a href='javascript:pagingSetPage("+totalPCnt+")'><img src='/iris/resource/web/images/newIris/pagenate_last.png'></a>");
    // $("#paging").children().css("margin-left","8px");
    // $("#paging").children().css("font-size","16px");
    $("#paging").children().css("cssText","font-size:16px;display:inline-block;width:25px;text-align:center;");
}

function pagingSetPage(p){

    if(p=="befor")p=nowP-1;
    if(p=="next")p=nowP+1;

    if(p<1)p=1
    if(p>totalPCnt)p=totalPCnt;

    nowP = p;
    pagingSetList();
    var startIdx = (p-1)*aCnt;
    var endIdx = ((p-1)*aCnt)+aCnt;
    pDs.filter(function(id, record, i){
        return i>=startIdx && i<endIdx;
    });

    $("#paging").children().css("font-weight","normal");
    $("#paging").children().css("color","#7d7d7d");
    $("#paging > a[name='"+p+"']").css("font-weight","bold");
    $("#paging > a[name='"+p+"']").css("color","#DA1C5A");
}

function duplicateExcelGrid(columnModel){
    nDs = $.extend({}, pDs);
    nDs.clearFilter();
    $("#"+pId).after("<div id='excelGrid' style='display: none'/>");

    nG = new Rui.ui.grid.LGridPanel({
        columnModel: columnModel,
        dataSet: nDs,
        width: 1210,
        height: 400,
        autoWidth: true,
    });

    nG.render('excelGrid');
}
