package iris.web.prj.grs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import iris.web.prj.grs.service.GrsMngService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
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
import iris.web.prj.grs.service.GrsReqService;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : GrsReqController.java
 * DESC : 관리 controller
 * PROJ : Iris
 * *************************************************************/

@Controller
public class GrsReqController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "grsReqService")
    private GrsReqService grsReqService;

    @Resource(name = "grsMngService")
    private GrsMngService grsMngService;

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;


    static final Logger LOGGER = LogManager.getLogger(GrsReqController.class);

    /*
     * GRS 조회
     */
    @RequestMapping(value="/prj/grs/grsReqList.do")
    public String grsReqList(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsReqController - grsReqList [grs화면 호출]");
        LOGGER.debug("inputData => " + input);
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);
        
        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/prj/grs/grsReqList";
    }


    @RequestMapping(value="/prj/grs/retrieveGrsReqList.do")
    public ModelAndView retrieveGrsReqList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGrsReqList - retrieveGrsReqList [grs req]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd",   role.get("tssRoleCd"));

        List<Map<String,Object>> list = grsReqService.retrieveGrsReqList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }


    /**
     * GRS 요청 화면 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/grs/grsEvRslt.do")
    public String grsEvRslt(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGrsEvRslt [GRS요청]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = grsReqService.retrieveGrsEvRslt(input);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("result", obj);
        }

        return "web/prj/grs/grsEvRslt";
    }


    /**
     * 통합검색
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/grs/grsItgSrch.do")
    public String grsItgSrch(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("grsItgSrch [통합검색]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            input.put("tssCdSn", "1");
            Map<String, Object> result = grsReqService.retrieveGrsEvRslt(input);
            result.put("itgSrch", "Y");

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("result", obj);
            request.setAttribute("itgSrch", "Y");
        }

        return "web/prj/grs/grsEvRslt";
    }


    /**
     * GRS 요청 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/grs/updateGrsEvRslt.do")
    public ModelAndView updateGrsEvRslt(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGrsEvRslt [GRS 요청 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");

            if("".equals(ds.get(0).get("tssCdSn")) || ds.get(0).get("tssCdSn") == null) {
                grsReqService.insertGrsEvRslt(ds.get(0));
            } else {
                grsReqService.updateGrsEvRslt(ds.get(0));
            }

            ds.get(0).put("rtCd", "SUCCESS");
            ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }



    /**
     * GRS 평가항목 목록 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/grs/grsEvStdPop.do")
    public String grsEvStdPop(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("grsEvStdPop [GRS 평가항목]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> resultCode = grsReqService.retrieveGrsEvStdGrsY();
            List<Map<String, Object>> result = grsReqService.retrieveGrsEvStd(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("inputData", input);
            request.setAttribute("result", obj);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("grsYList", resultCode);
        }

        return "web/prj/grs/grsEvStdPop";
    }


    /**
     * GRS 평가항목 목록 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/grs/retrieveGrsEvStd.do")
    public ModelAndView retrieveGrsEvStd(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGrsEvStd [GRS 평가항목 목록 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = grsReqService.retrieveGrsEvStd(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultCnt", 0);
        request.setAttribute("result", null);

        return modelAndView;
    }


    /**
     * GRS 평가항목 상세 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/grs/grsEvStdDtlPop.do")
    public String grsEvStdDtlPop(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("grsEvStdDtlPop [GRS 평가항목]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> result = grsReqService.retrieveGrsEvStdDtl(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("inputData", input);
            request.setAttribute("result", obj);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
        }

        return "web/prj/grs/grsEvStdDtlPop";
    }


    /**
     * 상세 화면
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     * @throws Exception
     */


    @RequestMapping(value="/prj/grs/grsEvRsltDtl.do")
    public String grsReqDtl(@RequestParam HashMap<String, String> input,HttpServletRequest request,
            HttpSession session,ModelMap model) throws Exception{

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsReqController - grsEvRsltDtl [GRS평가 결과 등록 화면 호출]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> role = tssUserService.getTssListRoleChk2(input);
            input.put("tssRoleType", (String) role.get("tssRoleType"));
            input.put("tssRoleId",   (String) role.get("tssRoleId"));

            Map<String, Object> result = grsReqService.retrieveGrsEvRslt(input);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            result = StringUtil.toUtf8Output((HashMap) result);
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("result", obj);
        }

        return  "web/prj/grs/grsEvRsltDtl";

    }


    /**
     * 과제GRS 평가 결과 등록 상세(Todo)
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     * @throws Exception
     */


    @RequestMapping(value="/prj/grs/grsReqDtlToDo.do")
    public String grsReqDtlToDo(@RequestParam HashMap<String, String> input,HttpServletRequest request,
            HttpSession session,ModelMap model) throws Exception{

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsReqController - grsEvRsltDtl [GRS평가 결과 등록 화면 호출]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //Todo view에서 pk조회
            Map<String, Object> todoMap = grsReqService.retrieveGrsTodo(input);
            input.put("tssCdSn", String.valueOf(todoMap.get("tssCdSn")));
            input.put("tssCd",   String.valueOf(todoMap.get("tssCd")));

            //GRS상세 조회
            Map<String, Object> result = grsReqService.retrieveGrsEvRslt(input);
            for(Entry<String, Object> entry : result.entrySet()) {
                input.put(entry.getKey(), String.valueOf(entry.getValue()));
            }

            String saveYn = String.valueOf(input.get("saveYN"));
            if("N".equals(saveYn)) saveYn = "1";
            else saveYn = "2";

            input.put("tssStNm", saveYn);

            //로그인사용자 버튼권한 조회
            Map<String, Object> role = tssUserService.getTssListRoleChk2(input);
            input.put("tssRoleType", (String) role.get("tssRoleType"));
            input.put("tssRoleId",   (String) role.get("tssRoleId"));

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("result", obj);
        }

        return  "web/prj/grs/grsEvRsltDtl";

    }
    /**
     * 상세 화면 조회
     * @param input
     * @param request
     * @param response
     * @param session
     * @param model
     * @return
     */
    @RequestMapping(value="/prj/grs/retrieveGrsReqDtl.do")
    public ModelAndView retrieveGrsReqDtl(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGrsTempList - retrieveGrsReqDtl [grs req]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);


        HashMap<String, Object> inputMap = new HashMap<String, Object>();
        String grsEvSn =  (String) input.get("grsEvSn");

        inputMap.put("grsEvSn", grsEvSn);
        inputMap.put("tssCd", input.get("tssCd"));
        inputMap.put("tssCdSn", input.get("tssCdSn"));
        List<Map<String, Object>> rstGridDataSet = grsReqService.retrieveGrsReqDtlLst(inputMap);

        modelAndView.addObject("gridDataSet", RuiConverter.createDataset("dataSet", rstGridDataSet));


        LOGGER.debug("###########################################################");
        LOGGER.debug("modelAndView => " + modelAndView);
        LOGGER.debug("###########################################################");

        return modelAndView;
    }

    @SuppressWarnings("static-access")
    @RequestMapping(value="/prj/grs/insertGrsEvRsltSave.do")
    public ModelAndView insertGrsEvRsltSave(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
                                            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGrsEvRsltSave [GRS 평가완료]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        List<Map<String, Object>> dsLst = null;
        String rtnMsg = "";
        String rtnSt = "F";

        try {
            dsLst = RuiConverter.convertToDataSet(request, "gridDataSet");
            input.put("userId", input.get("_userId"));
            input.put("cfrnAtdtCdTxt", input.get("cfrnAtdtCdTxt").toString().replaceAll("%2C", ",")); //참석자
            input = StringUtil.toUtf8Input(input);

            grsReqService.insertGrsEvRsltSave(dsLst, input);

			LOGGER.debug("===GRS 평가 완료후 과제 상태값 변경===");
            input.put("tssSt", "102");
            genTssPlnService.updateGenTssPlnMstTssSt(input);
            grsMngService.updateDefTssSt(input);


            if(grsMngService.isBeforGrs(input).equals("1")){
                LOGGER.debug("===GRS 관리에서 기본정보를 입력한경우===");
                LOGGER.debug("===과제 관리 마스터로 데이터 복제 (과제정보, 개요)===");
                grsMngService.moveDefGrsDefInfo(input);
            }

			LOGGER.debug("===해당과제 리더에게 완료 메일 발송===");
            genTssPlnService.retrieveSendMail(input); //개발에서 데이터 등록위해 반영위해 주석 1121

            rtnMsg = "평가완료되었습니다.";
            rtnSt = "S";
        } catch (Exception e) {
            e.printStackTrace();
            rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
        }

        rtnMeaasge.put("rtnMsg", rtnMsg);
        rtnMeaasge.put("rtnSt", rtnSt);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rtnMeaasge));
        return modelAndView;
    }


    /**
     * 페이지 이동시 세션체크
     *
     * @param userId 로그인ID
     * @return boolean
     * */
    public boolean pageMoveChkSession(String userId) {

        boolean rtVal = true;

        if(NullUtil.isNull(userId) || NullUtil.nvl(userId, "").equals("-1")) {
            SayMessage.setMessage(messageSourceAccessor.getMessage("msg.alert.sessionTimeout"));
            rtVal = false;
        }

        return rtVal;
    }

}
