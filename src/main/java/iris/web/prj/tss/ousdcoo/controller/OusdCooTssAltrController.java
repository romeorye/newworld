package iris.web.prj.tss.ousdcoo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import iris.web.common.code.service.CodeService;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.MimeDecodeException;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssAltrService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssAltrService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : OusdCooTssAltrController.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 변경 controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.22  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class OusdCooTssAltrController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "genTssAltrService")
    private GenTssAltrService genTssAltrService;		// 일반과제 변경 서비스

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;		// 대외협력과제 공통 서비스

    @Resource(name = "ousdCooTssAltrService")
    private OusdCooTssAltrService ousdCooTssAltrService;	// 대외협력과제 변경 서비스

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssAltrController.class);

    //================================================================================================ 마스터
    /**
     * 과제관리 > 대외협력과제 > 변경 > 상단 마스터탭화면 이동
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssAltrDetail.do")
    public String ousdCooTssAltrDetail(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("###################################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrMst [과제관리 > 대외협력과제 > 변경 > 상단 마스터탭화면 이동]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################");

        checkSession(input, session, model);
        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssAltrService.retrieveGenTssAltrMst(input);

                Map<String, Object> mbrCnt = genTssAltrService.retrieveGenTssPtcMbrCnt(input);
                result.put("mbrCnt", mbrCnt.get("mbrCnt"));

                Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
                result.put("tssRoleType", role.get("tssRoleType"));
                result.put("tssRoleId",   role.get("tssRoleId"));
            }

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/ousdcoo/altr/ousdCooTssAltrDetail";
    }

    /**
     * 과제관리 > 대외협력과제 > 변경 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssAltrMst.do")
    public ModelAndView retrieveOusdCooTssAltrMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("###################################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrMst [과제관리 > 대외협력과제 > 변경 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> result = genTssAltrService.retrieveGenTssAltrMst(input);
        Map<String, Object> mbrCnt = null;
        if( !result.isEmpty() ) {
            mbrCnt = genTssAltrService.retrieveGenTssPtcMbrCnt(input);
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result.put("mbrCnt", NullUtil.nvl(mbrCnt.get("mbrCnt"),"0"));
            }
        }

        List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
        resultList.add(result);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultList));
        return modelAndView;
    }

    /**
     * 과제관리 > 대외협력과제 > 변경 > 마스터 신규(신규+변경개요)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssAltrMst.do")
    public ModelAndView insertOusdCooTssAltrMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("#####################################################################################");
        LOGGER.debug("insertOusdCooTssAltrMst [과제관리 > 대외협력과제 > 변경 > 마스터 신규(신규+변경개요)]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#####################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        List<Map<String, Object>> altrDs = null;

        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            // 특수문자 변환 INPUT
            if( smryDs != null && !smryDs.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Input(smryDs);
            }
            
            altrDs = RuiConverter.convertToDataSet(request, "altrDataSet");

            ousdCooTssAltrService.insertOusdCooTssAltrMst(mstDs, smryDs, altrDs);

            mstDs.put("rtCd", "SUCCESS");
            mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
            mstDs.put("rtType", "I");
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }


    /**
     * 과제관리 > 대외협력과제 > 변경 > 마스터 수정(마스터+일반개요)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssAltrMst.do")
    public ModelAndView updateOusdCooTssAltrMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("#######################################################################################");
        LOGGER.debug("updateOusdCooTssAltrMst [과제관리 > 대외협력과제 > 변경 > 마스터 수정(마스터+일반개요)]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#######################################################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();

        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            boolean errYn   = false;
            boolean upWbsCd = false;

            if(!errYn) {
                // 특수문자 변환 INPUT
                if( smryDs != null && !smryDs.isEmpty() ) {
                	iris.web.common.util.StringUtil.toUtf8Input(smryDs);
                }
                
                ousdCooTssAltrService.updateOusdCooTssAltrMst(mstDs, smryDs, upWbsCd);

                mstDs.put("rtCd", "SUCCESS");
                mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
            }
        } catch(MimeDecodeException e) {
        	LOGGER.debug("MimeDecodeException ERROR");
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.imageUploadError")); //이미지파일 등록에 실패했습니다.
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }

    //================================================================================================ 변경개요
    
	/**
     * 과제관리 > 대외협력과제 > 변경 > 변경개요 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssAltrIfm.do")
    public String retrieveOusdCooTssAltrSmry1(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("#######################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrSmry [과제관리 > 대외협력과제 > 변경 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#######################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = ousdCooTssService.retrieveOusdCooTssSmry(input);
                // 특수문자 변환 OUTPUT
                if( result != null && !result.isEmpty() ) {
                	iris.web.common.util.StringUtil.toUtf8Output((HashMap) result);
                }
            }

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/ousdcoo/altr/ousdCooTssAltrIfm";
    }

    /**
     * 과제관리 > 대외협력과제 > 변경 > 변경개요목록 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssAltrSmryList.do")
    public ModelAndView retrieveOusdCooTssAltrSmryList(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("###################################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrSmryList [과제관리 > 대외협력과제 > 변경 > 변경개요목록 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = genTssAltrService.retrieveGenTssAltrSmryList(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        //        request.setAttribute("resultCnt", 0);
        //        request.setAttribute("result", null);

        return modelAndView;
    }

    /**
     * 과제관리 > 대외협력과제 > 변경 > 변경개요 수정
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssAltrSmry.do")
    public ModelAndView updateOusdCooTssAltrSmry(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("#########################################################################");
        LOGGER.debug("updateOusdCooTssAltrSmry [과제관리 > 대외협력과제 > 변경 > 변경개요 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#########################################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> smryDs = new HashMap<String, Object>();

        try {
            List<Map<String, Object>> smryDsList = RuiConverter.convertToDataSet(request, "smryDataSet");
            List<Map<String, Object>> altrDs = RuiConverter.convertToDataSet(request, "altrDataSet");

            smryDs = (HashMap<String, Object>) smryDsList.get(0);
            // 특수문자 변환 INPUT
            if( smryDs != null && !smryDs.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Input(smryDs);
            }
            ousdCooTssAltrService.updateOusdCooTssAltrSmry(smryDs, altrDs);

            smryDs.put("rtCd", "SUCCESS");
            smryDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            smryDs.put("rtCd", "FAIL");
            smryDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", smryDs));

        return modelAndView;
    }

    //================================================================================================ 개요
    
	/**
     * 과제관리 > 대외협력과제 > 변경 > 개요 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssAltrSmryIfm.do")
    public String retrieveOusdCooTssAltrSmry2(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("#######################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrSmry [과제관리 > 대외협력과제 > 변경 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#######################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = ousdCooTssService.retrieveOusdCooTssSmry(input);
                
                // 특수문자 변환 OUTPUT
                if( result != null && !result.isEmpty() ) {
                	iris.web.common.util.StringUtil.toUtf8Output((HashMap) result);
                }
            }

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/ousdcoo/altr/ousdCooTssAltrSmryIfm";
    }


    /**
     * 과제관리 > 대외협력과제 > 변경 > 개요저장(수정)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    /*    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssAltrSmry.do")
    public ModelAndView updateOusdCooTssAltrSmry(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("##########################################################################");
        LOGGER.debug("updateOusdCooTssAltrSmry [과제관리 > 대외협력과제 > 변경 > 개요저장(수정)]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("##########################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "smryDataSet");
            ousdCooTssService.updateOusdCooTssSmry((HashMap<String, Object>)ds.get(0));

            ds.get(0).put("rtCd", "SUCCESS");
            ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }*/

    //================================================================================================ 참여연구원
    /**
     * 과제관리 > 대외협력과제 > 변경 > 참여연구원 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssAltrPtcRsstMbrIfm.do")
    public String ousdCooTssAltrPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("######################################################################################");
        LOGGER.debug("ousdCooTssAltrPtcRsstMbrIfm [과제관리 > 대외협력과제 > 변경 > 참여연구원 iframe 화면 ]");
        LOGGER.debug("######################################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE"); //참여역할

            model.addAttribute("codeRtcRole", codeRtcRole);

            //데이터 있을 경우
            List<Map<String, Object>> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssAltrService.retrieveGenTssAltrPtcRsstMbr(input);
            }

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/ousdcoo/altr/ousdCooTssAltrPtcRsstMbrIfm";
    }


    /**
     * 과제관리 > 대외협력과제 > 변경 > 참여연구원 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssAltrPtcRsstMbr.do")
    public ModelAndView retrieveOusdCooTssAltrPtcRsstMbr(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###################################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrPtcRsstMbr [과제관리 > 대외협력과제 > 변경 > 참여연구원 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = genTssAltrService.retrieveGenTssAltrPtcRsstMbr(input);

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
     * 과제관리 > 대외협력과제 > 변경 > 참여연구원 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssAltrPtcRsstMbr.do")
    public ModelAndView updateOusdCooTssAltrPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("#################################################################################");
        LOGGER.debug("updateOusdCooTssAltrPtcRsstMbr [과제관리 > 대외협력과제 > 변경 > 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");
            genTssAltrService.updateGenTssAltrPtcRsstMbr(ds);

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
     * 과제관리 > 대외협력과제 > 변경 > 참여연구원 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/deleteOusdCooTssAltrPtcRsstMbr.do")
    public ModelAndView deleteOusdCooTssAltrPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("#################################################################################");
        LOGGER.debug("deleteOusdCooTssAltrPtcRsstMbr [과제관리 > 대외협력과제 > 변경 > 참여연구원 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");
            genTssAltrService.deleteGenTssAltrPtcRsstMbr(ds);

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

    //================================================================================================ 목표및산출물
    
	/**
     * 과제관리 > 대외협력과제 > 변경 > 목표및산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssAltrGoalYldIfm.do")
    public String ousdCooTssAltrGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("#####################################################################################");
        LOGGER.debug("ousdCooTssAltrGoalYldIfm [과제관리 > 대외협력과제 > 변경 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("#####################################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> resultGoal = null;
            List<Map<String, Object>> resultYld  = null;

            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                resultGoal = genTssAltrService.retrieveGenTssAltrGoal(input);
                
                // 특수문자 변환 OUTPUT
                if( resultGoal != null && resultGoal.size() > 0 ) {
                	for(int i=0; i< resultGoal.size(); i++) {
                		iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultGoal.get(i));
                	}
                }
                
                resultYld  = genTssAltrService.retrieveGenTssAltrYld(input);
            }

            JSONObject obj1 = new JSONObject();
            obj1.put("records", resultGoal);
            request.setAttribute("resultGoalCnt", resultGoal == null ? 0 : resultGoal.size());
            request.setAttribute("resultGoal", obj1);

            JSONObject obj2 = new JSONObject();
            obj2.put("records", resultYld);
            request.setAttribute("resultYldCnt", resultYld == null ? 0 : resultYld.size());
            request.setAttribute("resultYld", obj2);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/ousdcoo/altr/ousdCooTssAltrGoalYldIfm";
    }

    /**
     * 과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssAltrGoal.do")
    public ModelAndView retrieveOusdCooTssAltrGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("######################################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrGoal [과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("######################################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = genTssAltrService.retrieveGenTssAltrGoal(input);
        
        // 특수문자 변환 OUTPUT
        if( resultGoal != null && resultGoal.size() > 0 ) {
        	for(int i=0; i< resultGoal.size(); i++) {
        		iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultGoal.get(i));
        	}
        }
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultGoal));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultGoalCnt", 0);
        request.setAttribute("resultGoal", null);
        request.setAttribute("resultYldCnt", 0);
        request.setAttribute("resultYld", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssAltrYld.do")
    public ModelAndView retrieveOusdCooTssAltrYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("#######################################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrYld [과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#######################################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = genTssAltrService.retrieveGenTssAltrYld(input);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultYld));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultGoalCnt", 0);
        request.setAttribute("resultGoal", null);
        request.setAttribute("resultYldCnt", 0);
        request.setAttribute("resultYld", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssAltrGoal.do")
    public ModelAndView updateOusdCooTssAltrGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("####################################################################################");
        LOGGER.debug("updateOusdCooTssAltrGoal [과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 목표 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#####################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            // 특수문자 변환 INPUT
            if( ds != null && ds.size() > 0 ) {
            	for(int i=0; i< ds.size(); i++) {
            		iris.web.common.util.StringUtil.toUtf8Input((HashMap) ds.get(i));
            	}
            }
            genTssAltrService.updateGenTssAltrGoal(ds);

            ds.get(0).put("targetDs", "GOAL");
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
     * 과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssAltrYld.do")
    public ModelAndView updateOusdCooTssAltrYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("#####################################################################################");
        LOGGER.debug("updateOusdCooTssAltrYld [과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 산출물 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#####################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            genTssAltrService.updateGenTssAltrYld(ds);

            ds.get(0).put("targetDs", "YLD");
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
     * 과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 목표 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/deleteOusdCooTssAltrGoal.do")
    public ModelAndView deleteOusdCooTssAltrGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("####################################################################################");
        LOGGER.debug("deleteOusdCooTssAltrGoal [과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 목표 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("####################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            genTssAltrService.deleteGenTssAltrGoal(ds);

            ds.get(0).put("targetDs", "GOAL");
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
     * 과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 산출물 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/deleteOusdCooTssAltrYld.do")
    public ModelAndView deleteOusdCooTssAltrYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("#####################################################################################");
        LOGGER.debug("deleteOusdCooTssAltrYld [과제관리 > 대외협력과제 > 변경 > 목표및산출물 > 산출물 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#####################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            genTssAltrService.deleteGenTssAltrYld(ds);

            ds.get(0).put("targetDs", "YLD");
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



    //================================================================================================ 품의서
    
	/**
     * 과제관리 > 대외협력과제 > 변경 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssAltrCsusRq.do")
    public String ousdCooTssAltrCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("########################################################################");
        LOGGER.debug("ousdCooTssAltrCsusRq [과제관리 > 대외협력과제 > 변경 > 품의서요청 화면 ]");
        LOGGER.debug("########################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst        = genTssAltrService.retrieveGenTssAltrMst(input);       //마스터
            
            Map<String, Object> resultSmry       = ousdCooTssService.retrieveOusdCooTssSmryNtoBr(input); //개요
            // 특수문자 변환 OUTPUT
            if( resultSmry != null && !resultSmry.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultSmry);
            }
            
            List<Map<String, Object>> resultAltr = genTssAltrService.retrieveGenTssAltrSmryList(input);  //변경이력
            Map<String, Object> resultCsus       = genTssService.retrieveGenTssCsus(resultMst); 		 //품의서
            // 특수문자 변환 OUTPUT
            if( resultCsus != null && !resultCsus.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultCsus);
            }

            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("attcFilId", NullUtil.nvl(resultSmry.get("altrAttcFilId"),"") );

            List<Map<String, Object>> resultAttc  = genTssAltrService.retrieveGenTssAltrAttc(inputInfo);	//첨부파일

            model.addAttribute("inputData", input);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultAltr", resultAltr);
            model.addAttribute("resultAttc", resultAttc);
            model.addAttribute("resultCsus", resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("records", resultSmry);

            request.setAttribute("jsonSmry", obj);
        }

        return "web/prj/tss/ousdcoo/altr/ousdCooTssAltrCsusRq";
    }


    /**
     * 과제관리 > 대외협력과제 > 변경 > 품의서요청 생성(사용안함)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssAltrCsusRq.do")
    public ModelAndView insertOusdCooTssAltrCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("#############################################################################");
        LOGGER.debug("insertOusdCooTssAltrCsusRq [과제관리 > 대외협력과제 > 변경 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#############################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
            // 특수문자 변환 INPUT
            if( ds != null && ds.size()>0 ) {
            	iris.web.common.util.StringUtil.toUtf8Input((HashMap) ds.get(0));
            }
            
            genTssAltrService.insertGenTssAltrCsusRq(ds.get(0));

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

    //================================================================================================ 비용지급실적
    /**
     * 과제관리 > 대외협력과제 > 변경 > 비용지급실적 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssAltrExpStoaIfm.do")
    public String ousdCooTssPgsExpStoaIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################################################");
        LOGGER.debug("ousdCooTssAltrExpStoaIfm [과제관리 > 대외협력과제 > 변경 > 비용지급실적 iframe 화면]");
        LOGGER.debug("###########################################################################################");

        checkSession(input, session, model);
        if(pageMoveChkSession(input.get("_userId"))) {

            //데이터 있을 경우
            Map<String, Object> result = null;
            Map<String, Object> smry = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = ousdCooTssService.retrieveOusdCooTssExpStoa(input);
                smry = ousdCooTssService.retrieveOusdCooTssSmry(input);
                if(smry != null) {
                    input.put("rsstExp"           , NullUtil.nvl(smry.get("rsstExp"),"0"));
                    input.put("rsstExpConvertMil" , NullUtil.nvl(smry.get("rsstExpConvertMil"),"0"));
                }
            }

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }
        LOGGER.debug("###########################################################################################");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################################################");

        return "web/prj/tss/ousdcoo/altr/ousdCooTssAltrExpStoaIfm";
    }

    /**
     * 과제관리 > 대외협력과제 > 변경 > 비용지급실적 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssAltrExpStoa.do")
    public ModelAndView retrieveOusdCooTssPgsExpStoa(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("############################################################################");
        LOGGER.debug("retrieveOusdCooTssPgsExpStoa [과제관리 > 대외협력과제 > 변경 > 개발비 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("############################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> result = ousdCooTssService.retrieveOusdCooTssExpStoa(input);
        Map<String, Object> smry = ousdCooTssService.retrieveOusdCooTssSmry(input);
        if(smry != null) { input.put("rsstExp", NullUtil.nvl(smry.get("rsstExp"),"0")); }
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        return modelAndView;
    }

    /**
     * 과제관리 > 대외협력과제 > 변경 > 비용지급실적 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssAltrExpStoa.do")
    public ModelAndView insertOusdCooTssPgsExpStoa(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###############################################################################");
        LOGGER.debug("insertOusdCooTssPgsExpStoa [과제관리 > 대외협력과제 > 변경 > 비용지급실적 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "expStoaDataSet");
            if(ds.size() > 0) {
                ousdCooTssService.insertOusdCooTssExpStoa((HashMap<String, Object>) ds.get(0));
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
     * 과제관리 > 대외협력과제 > 변경 > 비용지급실적 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssAltrExpStoa.do")
    public ModelAndView updateOusdCooTssPgsExpStoa(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###############################################################################");
        LOGGER.debug("updateOusdCooTssPgsExpStoa [과제관리 > 대외협력과제 > 변경 > 비용지급실적 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "expStoaDataSet");
            if(ds.size() > 0) {
                ousdCooTssService.updateOusdCooTssExpStoa((HashMap<String, Object>)ds.get(0));
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
