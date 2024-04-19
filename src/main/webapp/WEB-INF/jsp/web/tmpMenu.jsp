<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<script src="./webcad/drwg/Libs/jquery-2.1.4.min.js"></script>
<style>
#tmpMenu {
	background-color:#FFFFFF;
    border: 2px solid black;
    border-radius: 25px;
    padding: 20px;
    top: 20px;
}
</style>
<script>
 var menu01 = [
{name:"Project", mdName:"", depth:"0",confirm:""},
{name:"Main", mdName:"/iris/prj/main.do", depth:"2",confirm:""},

{name:"연구팀(Project)", mdName:"", depth:"1",confirm:""},
{name:"현황", mdName:"", depth:"2",confirm:""},
{name:"월마감", mdName:"", depth:"2",confirm:""},

{name:"GRS", mdName:"", depth:"1",confirm:""},
//				{name:"기본정보관리", mdName:"", depth:"2",confirm:""},
{name:"GRS관리", mdName:"/iris/prj/grs//listGrsMngInfo.do", depth:"2",confirm:""},

{name:"과제관리", mdName:"", depth:"1",confirm:""},
{name:"일반과제", mdName:"", depth:"2",confirm:""},
{name:"대외협력과제", mdName:"", depth:"2",confirm:""},
{name:"국책과제", mdName:"", depth:"2",confirm:""}, //natJob
{name:"기술팀과제", mdName:"/iris/prj/tss/tctm/tctmTssList.do", depth:"2",confirm:""},
{name:"O/I협력과제", mdName:"", depth:"2",confirm:""},
{name:"RFP요청관리", mdName:"", depth:"2",confirm:""},
{name:"결재현황", mdName:"", depth:"2",confirm:""}, //jobApprove

{name:"M/M관리", mdName:"", depth:"1",confirm:""},
{name:"M/M입력", mdName:"", depth:"2",confirm:""},
{name:"M/M마감", mdName:"", depth:"2",confirm:""},

{name:"관리", mdName:"", depth:"1",confirm:""},
{name:"신제품코드매핑", mdName:"", depth:"2",confirm:""},
{name:"표준WBS관리", mdName:"", depth:"2",confirm:""},
{name:"GRS템플릿관리", mdName:"", depth:"2",confirm:""},
{name:"투입예산관리", mdName:"", depth:"2",confirm:""},
{name:"조직코드약어관리", mdName:"", depth:"2",confirm:""},
{name:"일반과제개요/분류관리", mdName:"", depth:"2",confirm:""}
];

 var menu02 = [
{name:"Technical Service", mdName:"", depth:"0",confirm:""},
{name:"Main", mdName:"/iris/anl/main.do", depth:"2",confirm:""}, //analMain

{name:"기기분석", mdName:"", depth:"1",confirm:""},
{name:"분석의뢰", mdName:"", depth:"2",confirm:""},
{name:"분석목록", mdName:"", depth:"2",confirm:""},
{name:"자료실", mdName:"", depth:"2",confirm:""},
{name:"안내", mdName:"", depth:"2",confirm:""},

{name:"신뢰성시험", mdName:"", depth:"1",confirm:""},
{name:"시험의뢰", mdName:"/iris/rlab/rlabRqprList.do", depth:"2",confirm:""},
{name:"시험목록", mdName:"/iris/rlab/rlabRqprList4Chrg.do", depth:"2",confirm:""},
{name:"자료실", mdName:"/iris/rlab/lib/retrieveRlabLibList.do", depth:"2",confirm:""},
{name:"안내", mdName:"/iris/rlab/gid/rlabSphereInfo.do", depth:"2",confirm:""},

{name:"공간평가", mdName:"", depth:"1",confirm:""},
{name:"평가의뢰", mdName:"/iris/space/spaceRqprList.do", depth:"2",confirm:""},
{name:"평가목록", mdName:"/iris/space/spaceRqprList4Chrg.do", depth:"2",confirm:""},
{name:"성능 Master", mdName:"/iris/space/spacePfmcMst.do", depth:"2",confirm:""},
{name:"자료실", mdName:"/iris/space/lib/retrieveSpaceLibList.do", depth:"2",confirm:""},
{name:"안내", mdName:"/iris/space/gid/spaceSphereInfo.do", depth:"2",confirm:""},


//			{name:"통합분석의뢰", mdName:"", depth:"1",confirm:""},
//			{name:"통합분석자료실", mdName:"", depth:"1",confirm:""},

{name:"통합게시판", mdName:"", depth:"1",confirm:""},
{name:"공지사항", mdName:"/iris/anl/bbs/retrieveAnlBbsList.do", depth:"2",confirm:""},
{name:"Q&A", mdName:"/iris/anl/bbs/retrieveAnlQnaList.do", depth:"2",confirm:""},


//			{name:"통합분석안내", mdName:"", depth:"1",confirm:""},

{name:"관리", mdName:"", depth:"1",confirm:""},
{name:"기기분석 시험정보관리", mdName:"", depth:"2",confirm:""},
{name:"신뢰성 시험정보관리", mdName:"/iris/rlab/rlabExatList.do", depth:"2",confirm:""},
{name:"공간성능평가 시험정보관리", mdName:"/iris/space/spaceExatList.do", depth:"2",confirm:""},
{name:"공간성능평가 평가법관리", mdName:"/iris/space/spaceEvaluationMgmt.do", depth:"2",confirm:""}
];

 var menu03 = [
{name:"Instrument", mdName:"", depth:"0",confirm:""},

{name:"분석기기", mdName:"", depth:"1",confirm:""},
{name:"보유 기기", mdName:"", depth:"2",confirm:"1"}, //tool
{name:"기기 교육", mdName:"", depth:"2",confirm:""}, //toolEdu

{name:"신뢰성시험 장비", mdName:"", depth:"1",confirm:""},
{name:"보유 장비", mdName:"/iris/mchn/open/rlabMchn/retrieveMachineList.do", depth:"2",confirm:""}, //tool

{name:"공간성능평가 Tool", mdName:"", depth:"1",confirm:""},
{name:"보유 TOOL", mdName:"/iris/mchn/open/spaceMchn/retrieveMachineList.do", depth:"2",confirm:"1"}, //tool


//			{name:"기기예약", mdName:"", depth:"1",confirm:""},
//			{name:"보유기기", mdName:"", depth:"2",confirm:""}, //tool
//			{name:"기기교육", mdName:"", depth:"2",confirm:""}, //toolEdu

{name:"관리", mdName:"", depth:"1",confirm:""},
{name:"분석기기 예약관리", mdName:"", depth:"2",confirm:"1"}, //reqToolMng
{name:"신뢰성시험장비 예약관리", mdName:"/iris/mchn/mgmt/retrieveRlabTestEqipPrctMgmtList.do", depth:"2",confirm:""}, //reqToolMng
{name:"공간성능평가Tool 사용관리", mdName:"/iris/mchn/mgmt/spaceEvToolUseMgmtList.do", depth:"2",confirm:""}, //reqToolMng
{name:"분석기기 교육관리", mdName:"", depth:"2",confirm:""}, //toolEduMng
{name:"소모품 관리", mdName:"", depth:"2",confirm:""},

{name:"분석기기 관리", mdName:"", depth:"2",confirm:""},//toolMng
{name:"신뢰성시험 장비관리", mdName:"/iris/mchn/mgmt/rlabTestEqipList.do", depth:"2",confirm:""},
//{name:"신뢰성시험 장비관리", mdName:"", depth:"2",confirm:""},//toolMng
{name:"공간성능평가 Tool관리", mdName:"/iris/mchn/mgmt/retrieveSpaceEvToolList.do", depth:"2",confirm:""}//toolMng
];

 var menu04 = [
{name:"Fixed Assets", mdName:"", depth:"0",confirm:""},
{name:"고정자산", mdName:"", depth:"1",confirm:""},
{name:"자산관리", mdName:"", depth:"2",confirm:""},
{name:"자산이관목록", mdName:"", depth:"2",confirm:""},
{name:"자산실사", mdName:"", depth:"2",confirm:""},
{name:"자산폐기", mdName:"", depth:"2",confirm:""},
{name:"실사기간관리", mdName:"", depth:"2",confirm:""},
{name:"자산담당자관리", mdName:"", depth:"2",confirm:""}
];

 var menu05 = [
{name:"Knowledge", mdName:"", depth:"0",confirm:""},
{name:"공지/게시판", mdName:"", depth:"1",confirm:""},
{name:"공지사항", mdName:"", depth:"2",confirm:""},
{name:"시장/기술정보", mdName:"", depth:"2",confirm:""},
{name:"교육/세미나", mdName:"", depth:"2",confirm:""},
{name:"학회/컨퍼런스", mdName:"", depth:"2",confirm:""},
{name:"전시회", mdName:"", depth:"2",confirm:""},
{name:"특허", mdName:"", depth:"2",confirm:""},
{name:"표준양식", mdName:"", depth:"2",confirm:""},
{name:"특허정보 리스트", mdName:"", depth:"2",confirm:""},
{name:"안전/환경/보건", mdName:"", depth:"2",confirm:""},
{name:"규정/업무Manual", mdName:"", depth:"2",confirm:""},
{name:"사외전문가", mdName:"", depth:"2",confirm:""},
{name:"연구소주요일정", mdName:"", depth:"2",confirm:""},
{name:"Q&A", mdName:"", depth:"1",confirm:""},
{name:"Group R&D", mdName:"", depth:"2",confirm:""},
{name:"일반 Q&A", mdName:"", depth:"2",confirm:""},
{name:"연구산출물", mdName:"", depth:"1",confirm:""},
{name:"고분자재료 Lab", mdName:"", depth:"2",confirm:""},
{name:"점착기술 Lab", mdName:"", depth:"2",confirm:""},
{name:"무기소재 Lab", mdName:"", depth:"2",confirm:""},
{name:"코팅기술 Lab", mdName:"", depth:"2",confirm:""},
{name:"연구소  공통", mdName:"", depth:"2",confirm:""},
{name:"LG화학 연구소", mdName:"", depth:"2",confirm:""},
{name:"LG화학 테크센터", mdName:"", depth:"2",confirm:""},
{name:"LG하우시스 연구소", mdName:"", depth:"2",confirm:""}
];

 var menu06 = [
{name:"Statistics", mdName:"", depth:"0",confirm:""},
{name:"연구과제", mdName:"", depth:"1",confirm:""},
{name:"프로젝트통계", mdName:"", depth:"2",confirm:""},
{name:"일반과제통계", mdName:"", depth:"2",confirm:""},
{name:"대외협력과제통계", mdName:"", depth:"2",confirm:""},
{name:"국책과제통계", mdName:"", depth:"2",confirm:""},
{name:"포트폴리오", mdName:"", depth:"2",confirm:""},
{name:"신제품매출실적", mdName:"", depth:"2",confirm:""},
{name:"기기분석", mdName:"", depth:"1",confirm:""},
{name:"분석완료", mdName:"", depth:"2",confirm:""},
{name:"분석 기기사용", mdName:"", depth:"2",confirm:""},
{name:"OPEN 기기사용", mdName:"", depth:"2",confirm:""},
{name:"분석 업무현황", mdName:"", depth:"2",confirm:""},
{name:"사업부 통계", mdName:"", depth:"2",confirm:""},
{name:"담당자 분석통계", mdName:"", depth:"2",confirm:""},
{name:"신뢰성시험", mdName:"", depth:"1",confirm:""},
{name:"연도별 통계", mdName:"/iris/stat/rlab/rlabState.do", depth:"2",confirm:""},
{name:"기간별 통계", mdName:"/iris/stat/rlab/rlabTermState.do", depth:"2",confirm:""},
{name:"장비사용 통계", mdName:"/iris/stat/rlab/rlabMchnUseState.do", depth:"2",confirm:""},
{name:"공간평가", mdName:"", depth:"1",confirm:""},
{name:"평가업무현황", mdName:"/iris/stat/space/spaceEvAffrStts.do", depth:"2",confirm:""},
{name:"사업부별통계", mdName:"/iris/stat/space/spaceCrgrStat.do", depth:"2",confirm:""},
{name:"담당자별통계", mdName:"/iris/stat/space/spaceBzdvStat.do", depth:"2",confirm:""},
{name:"분석목적별통계", mdName:"/iris/stat/space/spaceAnlStat.do", depth:"2",confirm:""},
{name:"분석방법별통계", mdName:"/iris/stat/space/spaceAnlWayStat.do", depth:"2",confirm:""},
{name:"관리", mdName:"", depth:"1",confirm:""},
{name:"공통코드관리", mdName:"", depth:"2",confirm:""}
];


function makeMenu(){

}
$(document).ready(function(){
	makeMn($("#m01"),menu01)
	makeMn($("#m02"),menu02)
	makeMn($("#m03"),menu03)
	makeMn($("#m04"),menu04)
	makeMn($("#m05"),menu05)
	makeMn($("#m06"),menu06)
	hideTmpMenu();
});

function makeMn(sp,arr){
	for(var i=0;i<arr.length;i++){
		var str = "";
		if(arr[i].depth==0 || arr[i].depth==1){
			str +="<br>";
		}
		if(arr[i].mdName!=""){
			str += "<u><a href='"+arr[i].mdName+"'>"+arr[i].name+"</a></u><br/>";
		} else {
			str += arr[i].name+ "<br/>";
		}
		if(arr[i].depth==0 || arr[i].depth==1){
			str = "<strong>"+str+"</strong>";
		}

		sp.append(str);
	}
}

function hideTmpMenu(){
	$("#tmpMenu").hide();
}
function showTmpMenu(){
	$("#tmpMenu").show();
}

</script>
<div style="position:absolute;z-index: 999;top: 0px"><input type="button" value="임시메뉴" onclick="showTmpMenu()"></div>
<div id="tmpMenu" style="position:absolute;z-index: 999;">
	<div>
		<input type="button" value="닫기" onclick="hideTmpMenu()"/>
	</div>
	<div id="horizontalContainer" style="float: none">
		<span id="m01" style="float: left;margin-right: 20px;"></span>
		<span id="m02" style="float: left;margin-right: 20px;"></span>
		<span id="m03" style="float: left;margin-right: 20px;"></span>
		<span id="m04" style="float: left;margin-right: 20px;"></span>
		<span id="m05" style="float: left;margin-right: 20px;"></span>
		<span id="m05" style="float: left;margin-right: 20px;"></span>
		<span id="m06" style="float: left;margin-right: 20px;"></span>
	</div>
</div>
