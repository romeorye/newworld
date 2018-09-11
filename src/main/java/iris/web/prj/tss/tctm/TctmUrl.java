package iris.web.prj.tss.tctm;

public class TctmUrl {

	public static final String jspHome = "web/prj/tss/tctm";
	public static final String doHome = "/prj/tss/tctm";


	// do 화면
	public static final String doList = doHome + "/tctmTssList.do";                              // 과제 목록
	public static final String jspList = jspHome + "/tctmTssList";									// 과제 목록 jsp

	public static final String doView = doHome + "/tctmTssDetail.do";                       	// 과제 상세
	public static final String jspView = jspHome + "/tctmTssDetail";							// 과제 상세 jsp

	public static final String doTabAltr = doHome + "/tctmTssAltrIfm.do";             					// 변경개요 Iframe
	public static final String jspTabAltr = jspHome + "/tctmTssAltrIfm";                 					// 변경개요 jsp

	public static final String doTabCmpl = doHome + "/tctmTssCmplIfm.do";    						// 완료 Iframe
	public static final String jspTabCmplSmryIfm = jspHome + "/tctmTssCmplSmryIfm";		// 완료 jsp

	public static final String doTabSum = doHome + "/tctmTssSmryIfm.do";           	// 개요 Iframe
	public static final String jspTabSum = jspHome + "/tctmTssSmryIfm";                   // 개요 jsp

	public static final String doTabGoal = doHome + "/tctmTssGoalYldIfm.do";        	// 목표 및 산출물 Iframe
	public static final String jspTabGoal = jspHome + "/tctmTssGoalYldIfm";          	// 목표 및 산출물 jsp

	public static final String doTabAltrHis = doHome + "/tctmTssAltrHisIfm.do";  		// 변경이력 Iframe
	public static final String jspTabAltrHis = jspHome + "/tctmTssAltrHisIfm";                        // 변경이력 jsp

	//do Query
	public static final String doSelectList = doHome + "/tctmTssSelectList.do";                		// 목록 조회 Query
	public static final String doUpdateInfo = doHome + "/tctmTssUpdateInfo.do";              		// 등록/수정 Query
	public static final String doDeleteInfo = doHome + "/tctmTssDeleteInfo.do";                		// 삭제 Query
	
	public static final String doUpdateInfoAltr = doHome + "/tctmTssUpdateAltr.do"; 				// 변경개요 조회 Query
	public static final String doSelectInfoAltr = doHome + "/tctmTssSelectAltr.do"; 				// 변경개요 조회 Query
	
	public static final String doUpdateInfoCmpl = doHome + "/tctmTssUpdateCmpl.do";			// 완료 등록/수정 Query
	public static final String doSelectInfoCmpl = doHome + "/tctmTssSelectCmpl.do";			// 완료 조회 Query

	public static final String doUpdateInfoSmry = doHome + "/tctmTssUpdateSmry.do";     	// 개요 등록/수정 Query
	public static final String doSelectInfoSmry = doHome + "/tctmTssSelectSmry.do";     		// 개요 조회 Query

	public static final String doUpdateInfoAltrListSmry = doHome + "/tctmTssUpdateAltrListSmry.do";     	// 변경개요목록 등록/수정 Query
	public static final String doSelectInfoAltrListSmry = doHome + "/tctmTssSelectAltrListSmry.do";     		// 변경개요목록 조회 Query

	public static final String doUpdateInfoGoal = doHome + "/tctmTssUpdateGoal.do";       	// 목표 및 산출물 등록/수정 Query
	public static final String doSelectInfoGoal = doHome + "/tctmTssSelectGoal.do";       		// 목표 및 산출물 조회 Query
	

	public static final String doUpdateInfoAltrHis = doHome + "/tctmTssUpdateAltrHis.do"; 	// 변경이력 등록 Query
	public static final String doSelectInfoAltrHis = doHome + "/tctmTssSelectAltrHis.do"; 		// 변경이력 조회

	public static final String doCsusView = doHome + "/tctmTssCsusRq.do"; 					//품의서 요청 화면
	public static final String jspCsusView = jspHome + "/tctmTssCsusRq";                        // 품의서 요청 jsp
}



