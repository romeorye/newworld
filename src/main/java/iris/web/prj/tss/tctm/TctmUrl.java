package iris.web.prj.tss.tctm;

public class TctmUrl {

	private static final String jspHome = "web/prj/tss/tctm";
	private static final String doHome = "/prj/tss/tctm";

	// do 화면
	public static final String doList = doHome + "/tctmTssList.do";                              // 과제 목록
	public static final String jspList = jspHome + "/tctmTssList";                                    // 과제 목록 jsp

	public static final String doView = doHome + "/tctmTssDetail.do";                        // 과제 상세
	public static final String jspView = jspHome + "/tctmTssDetail";                            // 과제 상세 jsp

	public static final String doTabAltr = doHome + "/tctmTssAltrIfm.do";                                // 변경개요 Iframe
	public static final String jspTabAltr = jspHome + "/tctmTssAltrIfm";                                    // 변경개요 jsp

	public static final String doAltrCsusView = doHome + "/tctmTssAltrCsusRq.do";                                    // 변경내부품의
	public static final String jspAltrCsusView = jspHome + "/tctmTssAltrCsusRq";                                    // 변경내부품의 jsp


	public static final String doTabCmpl = doHome + "/tctmTssCmplIfm.do";                            // 완료 Iframe
	public static final String jspTabCmpl = jspHome + "/tctmTssCmplIfm";                                // 완료 jsp
	public static final String doUpdateCmplInfo = doHome + "/tctmTssUpdateCmpl.do";                // 완료 등록/수정 Query


	public static final String doTabDcac = doHome + "/tctmTssDcacIfm.do";                            // 중단 Iframe
	public static final String jspTabDcac = jspHome + "/tctmTssDcacIfm";                                // 중단 jsp


	public static final String doTabSum = doHome + "/tctmTssSmryIfm.do";            // 개요 Iframe
	public static final String jspTabSum = jspHome + "/tctmTssSmryIfm";                   // 개요 jsp

	public static final String doTabGoal = doHome + "/tctmTssGoalYldIfm.do";            // 목표 및 산출물 Iframe
	public static final String jspTabGoal = jspHome + "/tctmTssGoalYldIfm";            // 목표 및 산출물 jsp

	public static final String doTabAltrHis = doHome + "/tctmTssAltrHisIfm.do";                                    // 변경이력 Iframe
	public static final String jspTabAltrHis = jspHome + "/tctmTssAltrHisIfm";                                        // 변경이력 jsp
	public static final String doTabAltrHisPop = doHome + "/tctmTssAltrHisPop.do";                            // 변경이력 상세팝업
	public static final String jspTabAltrHisPop = jspHome + "/tctmTssAltrHisPop";                                 // 변경이력 상세팝업jsp
	public static final String doSelectTabAltrHisPop = doHome + "/tctmTssSelectAltrHisPop.do";        // 변경이력 상세팝업 Query

	//do Query
	public static final String doSelectList = doHome + "/tctmTssSelectList.do";                        // 목록 조회 Query
	public static final String doUpdateInfo = doHome + "/tctmTssUpdateInfo.do";                    // 등록/수정 Query
	public static final String doDeleteInfo = doHome + "/tctmTssDeleteInfo.do";                        // 삭제 Query

	public static final String doUpdateInfoAltr = doHome + "/tctmTssUpdateAltr.do";                // 변경개요 조회 Query
	public static final String doCancelInfoAltr = doHome + "/tctmTssCancelAltr.do";                // 변경취소 Query


	public static final String doSelectInfoAltrListSmry = doHome + "/tctmTssSelectAltrListSmry.do";            // 변경개요목록 조회 Query


	public static final String doCsusView = doHome + "/tctmTssCsusRq.do";                    //품의서 요청 화면
	public static final String jspCsusView = jspHome + "/tctmTssCsusRq";                        // 품의서 요청 jsp(계획)
	public static final String jspCmCsusView = jspHome + "/tctmTssCmplCsusRq";                // 품의서 요청 jsp(완료)
	public static final String jspDcCsusView = jspHome + "/tctmTssDcacCsusRq";                // 품의서 요청 jsp(중단)

	public static final String doTctmSrch = doHome + "/tctmTssItgSrch.do";                    //통합검색 조회 화면
}



