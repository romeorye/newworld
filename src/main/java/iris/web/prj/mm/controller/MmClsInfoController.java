package iris.web.prj.mm.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.mm.service.MmClsInfoService;
import iris.web.prj.rsst.service.RsstClsService;
import iris.web.sapBatch.service.SapBudgCostService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : MmClsInfoController.java
 * DESC : M/M 관리 - M/M 입력 controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.05  IRIS04    최초생성
 *********************************************************************************/

@Controller
public class MmClsInfoController extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "mmClsInfoService")
    private MmClsInfoService mmClsInfoService;        // mm서비스

    @Resource(name = "rsstClsService")
    private RsstClsService rsstClsService;        // mm서비스

    @Resource(name = "sapBudgCostService")
    private SapBudgCostService sapBudgCostService;

    static final Logger LOGGER = LogManager.getLogger(MmClsInfoController.class);

    private String testSabun = "";

    /** M/M 입력 페이지 화면이동 **/
    @RequestMapping(value="/prj/mm/retrieveMmInInfo.do")
    public String retrieveMmInInfoView(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("########################################################################################");
        LOGGER.debug("MmClsInfoController - retrieveMmInInfoView [M/M 입력 페이지 화면이동]");
        LOGGER.debug("########################################################################################");

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
            String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
            SayMessage.setMessage(rtnMsg);
        } else {

            input.put("userJoinProjects", mmClsInfoService.retrieveJoinProject(input)) ;    // 유저조직의 프로젝트 리스트(문자열)
            model.addAttribute("inputData", input);
        }

        return "web/prj/mm/mmList";
    }

    /** M/M 입력 목록조회 (내가 참여중인  과제) **/
    @RequestMapping(value="/prj/mm/retrieveMmInSearchInfo.do")
    public ModelAndView retrieveMmInSearchInfo(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        LOGGER.debug("##############################################################################################");
        LOGGER.debug("MmClsInfoController - retrieveMmInSearchInfo [M/M 입력 목록조회 (내가 참여중인  과제)]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("##############################################################################################");

        List<Map<String,Object>> list = mmClsInfoService.retrieveMmInSearchInfo(input);
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        LOGGER.debug("###########################################################");
        LOGGER.debug("modelAndView => " + modelAndView);
        LOGGER.debug("###########################################################");

        return modelAndView;
    }

    /** M/M입력(입력/수정) : 참여중인 과제 참여율 (입력/수정)
     * MM입력 TO-DO 대상이면 뷰 조회 후 프로시져 호출처리
     * **/
    @RequestMapping(value="/prj/mm/insertMmIn.do")
    public ModelAndView insertMmIn(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){
        LOGGER.debug("################################################################");
        LOGGER.debug("MmClsInfoController - insertMmIn [과제별 참여율 저장(입력/수정)]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        model.addAttribute("inputData", input);

        String rtnMsg = messageSourceAccessor.getMessage("msg.alert.saved");    // 결과메시지
        int totCnt = 0;                                //전체건수
        List<Map<String, Object>> dataSetList;        //변경된 저장데이터 리스트
        String toDoYn = NullUtil.nvl(input.get("toDoYn"), "N");

        try {
            dataSetList = RuiConverter.convertToDataSet(request,"mmClsDataSet");
                for(Map<String,Object> dataSetMap : dataSetList) {

                    dataSetMap.put("_userId"    , NullUtil.nvl(input.get("_userId"), ""));
//                    dataSetMap.put("saSabunNew" , testSabun);
                    dataSetMap.put("saSabunNew" , NullUtil.nvl(input.get("_userSabun"), ""));
                    dataSetMap.put("mmYymm"     , NullUtil.nvl(input.get("searchMonth"), ""));
//                    dataSetMap.put("_userId"    , testSabun);

                    // 완료버튼으로 진입한 경우 To-Do 완료데이터 입력
                    if( "Y".equals(toDoYn) ) {
                        dataSetMap.put("toDoYn" , "Y");
                    }else {
                        dataSetMap.put("toDoYn" , "N");
                    }

                    // 입력데이터 존재여부 체크
                    if("Y".equals( NullUtil.nvl(dataSetMap.get("clsDataYn"), "") )){
                        mmClsInfoService.updateMmCls(dataSetMap);
                    }else {
                        mmClsInfoService.insertMmCls(dataSetMap);
                    }

                    totCnt++;
                }

                // 완료처리시 MM입력 TO-DO 대상이면 뷰 조회 후 프로시져 호출처리
                if( totCnt != 0 && "Y".equals(toDoYn ) ) {
                    // M/M입력 TO-DO 프로시져 실행
                    Map<String, Object> inputParam = new HashMap<String, Object>();
                    inputParam.put("todoReqNo", NullUtil.nvl(input.get("_userSabun"),"") );
                    inputParam.put("todoEmpNo", NullUtil.nvl(input.get("_userSabun"),"") );
                    List<Map<String, Object>> mmInTodoList =  mmClsInfoService.retrieveMmInTodoList(inputParam);    // todo view 대상조회
                    if( mmInTodoList != null && mmInTodoList.size() > 0 ) {
                        mmClsInfoService.saveMmpUpMwTodoReq(inputParam);
                    }
                }

                if(totCnt == 0 ) {
                    rtnMsg = "변경된 내용이 없습니다.";
                }
        } catch (Exception e) {
            rtnMsg = messageSourceAccessor.getMessage("msg.alert.error");
        }

        input.put("rtnMsg", rtnMsg);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

        return modelAndView;
    }

    /** M/M 마감 페이지 화면이동 **/
    @RequestMapping(value="/prj/mm/retrieveMmClsInfo.do")
    public String retrieveMmClsInfoView(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){
        LOGGER.debug("########################################################################################");
        LOGGER.debug("MmClsInfoController - retrieveMmClsInfoView [M/M 마감 페이지 화면이동]");
        LOGGER.debug("########################################################################################");

        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);

        String plEmpNo = mmClsInfoService.retrievePrjLeaderEmpNo(input);

        input.put("plEmpNo", plEmpNo);

        model.addAttribute("inputData", input);

        return "web/prj/mm/mmClsList";
    }

    /** M/M 마감 목록조회 **/
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/mm/retrieveMmClsSearchInfo.do")
    public ModelAndView retrieveMmClsSearchInfo(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);
        LOGGER.debug("##############################################################################################");
        LOGGER.debug("MmClsInfoController - retrieveMmClsSearchInfo [M/M 마감 목록조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("##############################################################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = mmClsInfoService.retrieveMmClsSearchInfo(input);
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        LOGGER.debug("###########################################################");
        LOGGER.debug("modelAndView => " + modelAndView);
        LOGGER.debug("###########################################################");

        return modelAndView;
    }


    /**
     * M/M마감 저장
     * **/
    @RequestMapping(value="/prj/mm/saveMmClsInfo.do")
    public ModelAndView saveMmClsInfo(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){
        LOGGER.debug("################################################################");
        LOGGER.debug("MmClsInfoController - saveMmClsInfo [M/M마감 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        model.addAttribute("inputData", input);

        String rtnMsg = messageSourceAccessor.getMessage("msg.alert.saved");    // 결과메시지
        int totCnt = 0;                                //전체건수
        List<Map<String, Object>> dataSetList;        //변경된 저장데이터 리스트
        Map<String,Object> inputParamMap;            //인풋데이터파람

        try {
            dataSetList = RuiConverter.convertToDataSet(request,"mmClsDataSet");


            for(Map<String,Object> dataSetMap : dataSetList) {
                inputParamMap = new HashMap<String,Object>();
                inputParamMap.put("_userId"    , NullUtil.nvl(input.get("_userId"), ""));           // 유저ID
                inputParamMap.put("tssCd", dataSetMap.get("tssCd"));
                inputParamMap.put("prjCd", dataSetMap.get("prjCd"));
                inputParamMap.put("saSabunNew", dataSetMap.get("saSabunNew"));
                inputParamMap.put("ptcPro", dataSetMap.get("ptcPro"));
                inputParamMap.put("mmYymm", dataSetMap.get("mmYymm"));
                inputParamMap.put("commTxt", dataSetMap.get("commTxt"));
                inputParamMap.put("ousdTssYn", NullUtil.nvl(dataSetMap.get("ousdTssYn"), "N"));
                inputParamMap.put("clsDt", NullUtil.nvl(dataSetMap.get("clsDt"), ""));
                inputParamMap.put("tssWbsCd", dataSetMap.get("tssWbsCd"));
                inputParamMap.put("wbsCd", dataSetMap.get("tssWbsCd"));
                inputParamMap.put("ilckSt", "N");
                inputParamMap.put("toDoYn", "Y");

                mmClsInfoService.saveMmCls(inputParamMap);

                totCnt++;
            }

            if(totCnt == 0 ) {
                rtnMsg = "변경된 내용이 없습니다.";
            }
        } catch (Exception e) {
            rtnMsg = messageSourceAccessor.getMessage("msg.alert.error");
        }

        input.put("rtnMsg", rtnMsg);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

        return modelAndView;
    }

    /** M/M마감 수정
     *  마감여부, 마감일자, 연동상태, 메모 업데이트
     * **/
    @RequestMapping(value="/prj/mm/updateMmClsInfo.do")
    public ModelAndView updateMmClsInfo(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){
        LOGGER.debug("################################################################");
        LOGGER.debug("MmClsInfoController - updateMmClsInfo [M/M마감 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        model.addAttribute("inputData", input);

        String rtnMsg = messageSourceAccessor.getMessage("msg.alert.saved");    // 결과메시지
        int totCnt = 0;                                //전체건수
        List<Map<String, Object>> dataSetList;        //변경된 저장데이터 리스트
        Map<String,Object> inputParamMap;            //인풋데이터파람

        try {
            dataSetList = RuiConverter.convertToDataSet(request,"mmClsDataSet");

            String roleId = (String)((HashMap)session.getAttribute("irisSession")).get("_roleId");

            if(roleId.indexOf("WORK_IRI_T01") > -1){

            }else if(roleId.indexOf("WORK_IRI_T05") > -1){

            }else{
                if( rsstClsService.retrievePrjMmCls(input) > 0 ){
                }else{
                    rtnMsg ="전월 프로젝트 월마감을 완료하셔야 MM마감 처리를 진행하실수 있습니다.";

                    input.put("rtnMsg", rtnMsg);
                    modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

                    return modelAndView;
                }
            }

            for(Map<String,Object> dataSetMap : dataSetList) {
                // 업데이트 파라미터 처리
                inputParamMap = new HashMap<String,Object>();
                inputParamMap.put("_userId"    , NullUtil.nvl(input.get("_userId"), ""));           // 유저ID

                // KEY
                inputParamMap.put("tssCd"      , NullUtil.nvl(dataSetMap.get("tssCd"), ""));       // 과제코드
                inputParamMap.put("saSabunNew" , NullUtil.nvl(dataSetMap.get("saSabunNew"), ""));  // 사번
                inputParamMap.put("mmYymm"     , NullUtil.nvl(dataSetMap.get("mmYymm"), ""));       // 마감월

                // DATA
                inputParamMap.put("clsYn"      , NullUtil.nvl(dataSetMap.get("clsYn"), ""));       // 마감여부
                inputParamMap.put("ptcPro"     , NullUtil.nvl(dataSetMap.get("ptcPro"), ""));       // 참여율
                inputParamMap.put("commTxt"    , NullUtil.nvl(dataSetMap.get("commTxt"), ""));       // 메모
                inputParamMap.put("prjCd"      , NullUtil.nvl(dataSetMap.get("prjCd"), ""));       // 프로젝트코드
                inputParamMap.put("tssWbsCd"      , NullUtil.nvl(dataSetMap.get("tssWbsCd"), ""));       // WBS코드
                inputParamMap.put("wbsCd"      , NullUtil.nvl(dataSetMap.get("tssWbsCd"), ""));       // WBS코드2

                // 마감
                if("Y".equals(NullUtil.nvl(dataSetMap.get("clsYn"),""))) {
                    inputParamMap.put("clsDt"      , NullUtil.nvl(dataSetMap.get("clsDt"), ""));    // 마감일자
                    inputParamMap.put("toDoYn"     , "Y");                                            // TO-DO 완료여부
                }

                mmClsInfoService.saveMmCls(inputParamMap);

                totCnt++;

                // 완료처리시 MM마감,입력 TO-DO 대상이면 뷰 조회 후 프로시져 호출처리
                if("Y".equals(NullUtil.nvl(dataSetMap.get("clsYn"),""))) {

                    // 1. M/M마감 TO-DO 프로시져 실행
                    Map<String, Object> inputParam = new HashMap<String, Object>();
                    inputParam.put("todoReqNo", NullUtil.nvl(dataSetMap.get("prjCd"),"") );
                    inputParam.put("todoEmpNo", NullUtil.nvl(input.get("_userSabun"),"") );

                    List<Map<String, Object>> mmClsTodoList =  mmClsInfoService.retrieveMmClsTodoList(inputParam);    // todo마감 view 대상조회
                    if( mmClsTodoList != null && mmClsTodoList.size() > 0 ) {
                        mmClsInfoService.saveMmlUpMwTodoReq(inputParam);
                    }

                    // 2. M/M입력 TO-DO 프로시져 실행
                    inputParam.put("todoReqNo", NullUtil.nvl(input.get("_userSabun"),"") );
                    inputParam.put("todoEmpNo", NullUtil.nvl(input.get("_userSabun"),"") );
                    List<Map<String, Object>> mmInTodoList =  mmClsInfoService.retrieveMmInTodoList(inputParam);    // todo입력 view 대상조회
                    if( mmInTodoList != null && mmInTodoList.size() > 0 ) {
                        mmClsInfoService.saveMmpUpMwTodoReq(inputParam);
                    }
                }
            }

            if(totCnt == 0 ) {
                rtnMsg = "변경된 내용이 없습니다.";
            }
        } catch (Exception e) {
            rtnMsg = messageSourceAccessor.getMessage("msg.alert.error");
        }

        input.put("rtnMsg", rtnMsg);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

        return modelAndView;
    }


    /**
     * 마감연동
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     */
    @RequestMapping(value="/prj/mm/updateMmIlckSap.do")
    public ModelAndView updateMmIlckSap(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ) {

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        model.addAttribute("inputData", input);

        //    1.sap connection
            try {
                sapBudgCostService.sapConnection() ;

            } catch (IOException e) {
            //오류가 발생하였습니다.
                input.put("rtnMsg", messageSourceAccessor.getMessage("msg.alert.error"));
                e.printStackTrace();
            }

            // 2.데이터 조회 및 수정
            try {

                List<Map<String, Object>> dataSetList = RuiConverter.convertToDataSet(request,"mmClsDataSet");
                mmClsInfoService.updateMmIlckSap(dataSetList , input);
            } catch (Exception e) {
                //오류가 발생하였습니다.
                input.put("rtnMsg", messageSourceAccessor.getMessage("msg.alert.error"));
                e.printStackTrace();
            }


        //처리되었습니다.
          input.put("rtnMsg", messageSourceAccessor.getMessage("msg.alert.processSuccess"));
          modelAndView.addObject("dataset", RuiConverter.createDataset("dataSet", input));
         return modelAndView;
    }

    /** TO-DO M/M 입력 페이지 화면이동(URL 다름) **/
    @RequestMapping(value="/prj/mm/retrieveMmInTodoInfo.do")
    public String retrieveMmTodoInInfo(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){
        LOGGER.debug("########################################################################################");
        LOGGER.debug("MmClsInfoController - retrieveMmInInfoView [TO-DO M/M 입력 페이지 화면이동]");
        LOGGER.debug("########################################################################################");

        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);
        if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
            String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
            SayMessage.setMessage(rtnMsg);
        } else {
            model.addAttribute("inputData", input);
        }

        return "web/prj/mm/mmList";
    }

    /** TO-DO M/M 마감 페이지 화면이동(URL 다름) **/
    @RequestMapping(value="/prj/mm/retrieveMmClsTodoInfo.do")
    public String retrieveMmClsTodoInfoView(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){
        LOGGER.debug("########################################################################################");
        LOGGER.debug("MmClsInfoController - retrieveMmClsInfoView [TO-DO M/M 마감 페이지 화면이동]");
        LOGGER.debug("########################################################################################");

        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);
        if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
            String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
            SayMessage.setMessage(rtnMsg);
        } else {
            model.addAttribute("inputData", input);
        }

        return "web/prj/mm/mmClsList";
    }

}// end class
