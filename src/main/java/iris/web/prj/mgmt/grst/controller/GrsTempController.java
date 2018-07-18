package iris.web.prj.mgmt.grst.controller;

import java.net.URLDecoder;
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
import iris.web.prj.mgmt.grst.service.GrsTempService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : GrsTempController.java
 * DESC : 관리 controller
 * PROJ : Iris
 * *************************************************************/

@Controller
public class GrsTempController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "grsTempService")
    private GrsTempService grsTempService;


    private StringUtil stringUtil;
    static final Logger LOGGER = LogManager.getLogger(GrsTempController.class);

    /*
     * GRS 조회
     */
    @RequestMapping(value="/prj/mgmt/grst/grsTempList.do")
    public String grsTempList(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsTempController - grsTempList [grs템플릿화면 호출]");
        LOGGER.debug("###########################################################");

        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);

        if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
            String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
            SayMessage.setMessage(rtnMsg);
        } else {
            model.addAttribute("inputData", input);
        }

        LOGGER.debug("###########################################################");
        LOGGER.debug("loginUser => " + model.get("loginUser"));
        LOGGER.debug("inputData => " + input);

        LOGGER.debug("###########################################################");

        return "web/prj/mgmt/grst/grsTempList";
    }

    /**
     * 템플릿 조회
     * @param input
     * @param request
     * @param response
     * @param session
     * @param model
     * @return
     */
    @RequestMapping(value="/prj/mgmt/grst/retrieveGrsTempList.do")
    public ModelAndView retrieveGrsTempList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGrsTempList - retrieveGrsTempList [grs req]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = grsTempService.retrieveGrsTempList(input);

        Object a = RuiConverter.createDataset("dataSet", list);


        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }




    @RequestMapping(value="/prj/mgmt/grst/grsTempSave.do")
    public String grsTempSave(@RequestParam HashMap<String, String> input,HttpServletRequest request,
            HttpSession session,ModelMap model) throws Exception{

        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);
        if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
            String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
            SayMessage.setMessage(rtnMsg);
        } else {
            model.addAttribute("inputData", input);
        }

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsTempController - grsTempSave [GRS템플릿 등록 화면 호출]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");



        return "web/prj/mgmt/grst/grsTempSave";

    }


    /**
     * 템플릿저장
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     */
    @SuppressWarnings("static-access")
    @RequestMapping(value="/prj/mgmt/grst/insertGrsTempSave.do")
    public ModelAndView insertGrsTempSave(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGrsTempSave [GRS 템플릿 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

        List<Map<String, Object>> dsLst = null;

        try {

            dsLst = RuiConverter.convertToDataSet(request,  "gridDataSet");

            if(!stringUtil.isNullString(input.get("grsEvSn").toString())) {
                input.put("grsEvSeq", 0);
            }

            String evSbcNm = URLDecoder.decode( (String) input.get("evSbcNm"), "UTF-8");

            input.put("evSbcNm" , evSbcNm);


            input.put("userId", input.get("_userId"));
            int  mstRtCnt = grsTempService.saveGrsTemp(input);

            if(mstRtCnt > 0) {
                for(Map<String, Object> ds  : dsLst) {
                    Object sGrsEvSn = input.get("grsEvSn");
                    Object sGrsEvSeq = ds.get("grsEvSeq");

                    ds.put("grsEvSn",  sGrsEvSn);
                    ds.put("grsEvSeq", sGrsEvSeq);
                    ds.put("userId",   input.get("_userId"));

                    //최초등록
                    if(stringUtil.isNullString(sGrsEvSn.toString()) && stringUtil.isNullString(sGrsEvSeq.toString())) {
                        Map<String , Object> getSEQGrsTemp = grsTempService.getSeqGrsTemp();

                        ds.put("grsEvSn",  getSEQGrsTemp.get("grsEvSn"));
                        ds.put("grsEvSeq", null);
                    }
                    //추가등록
                    if(!stringUtil.isNullString(sGrsEvSn.toString()) && stringUtil.isNullString(sGrsEvSeq.toString())) {
                        ds.put("grsEvSeq", null);
                    }

                    grsTempService.saveGrsTempLst(ds);
                }
            }

            rtnMeaasge.put("rtCd", "SUCCESS");
            rtnMeaasge.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.


        } catch(Exception e) {
            e.printStackTrace();
            rtnMeaasge.put("rtCd", "FAIL");
            rtnMeaasge.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rtnMeaasge));
        return modelAndView;
    }

    /**
     * 템플릿삭제
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     */

    @SuppressWarnings("static-access")
    @RequestMapping(value="/prj/mgmt/grst/deleteGrsTemp.do")
    public ModelAndView deleteGrsTemp(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGrsTemp [GRS 템플릿 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        List<Map<String, Object>> dsLst = null;

        try {
            dsLst = RuiConverter.convertToDataSet(request, "gridDataSet");
            int mstRtCnt = grsTempService.deleteGrsTemp(dsLst);

            rtnMeaasge.put("rtCd", "SUCCESS");
            rtnMeaasge.put("rtVal",messageSourceAccessor.getMessage("msg.alert.deleted")); //저장되었습니다.
            rtnMeaasge.put("rtTy", "D");

        } catch(Exception e) {
            e.printStackTrace();
            rtnMeaasge.put("rtCd", "FAIL");
            rtnMeaasge.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rtnMeaasge));
        return modelAndView;
    }

    /**
     * 상세조회
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/prj/mgmt/grst/grsTempDtl.do")
    public String grsTempDtl(@RequestParam HashMap<String, String> input,HttpServletRequest request,
            HttpSession session,ModelMap model) throws Exception{

        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);
        if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
            String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
            SayMessage.setMessage(rtnMsg);
        } else {
            model.addAttribute("inputData", input);
        }

        ModelAndView modelAndView = new ModelAndView("ruiView");

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsTempController - grsTempSave [GRS템플릿 등록 화면 호출]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        HashMap<String, Object> inputMap = new HashMap<String, Object>();
        String grsEvSn =  input.get("grsEvSn");



        inputMap.put("grsEvSn", grsEvSn);
        inputMap.put("grsEvSeq" , 0 );



        HashMap<String, Object> rstDataSet = grsTempService.retrieveGrsTempDtl(inputMap);


        model.addAttribute("inputData", input);
        model.addAttribute("rstDtl", rstDataSet);

        return  "web/prj/mgmt/grst/grsTempDtl";

    }
    /**
     * 상세조회
     * @param input
     * @param request
     * @param response
     * @param session
     * @param model
     * @return
     */
    @RequestMapping(value="/prj/mgmt/grst/retrieveGrsTempDtl.do")
    public ModelAndView retrieveGrsTempDtl(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGrsTempList - retrieveGrsTempList [grs req]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);


        HashMap<String, Object> inputMap = new HashMap<String, Object>();
        String grsEvSn =  (String) input.get("grsEvSn");

        inputMap.put("grsEvSn", grsEvSn);

        List<Map<String, Object>> rstGridDataSet = grsTempService.retrieveGrsTempList(inputMap);

        modelAndView.addObject("gridDataSet", RuiConverter.createDataset("dataSet", rstGridDataSet));


        LOGGER.debug("###########################################################");
        LOGGER.debug("modelAndView => " + modelAndView);
        LOGGER.debug("###########################################################");

        return modelAndView;
    }



}
