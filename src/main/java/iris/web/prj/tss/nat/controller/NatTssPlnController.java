package iris.web.prj.tss.nat.controller;

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
import iris.web.common.util.StringUtil;
import iris.web.prj.rsst.service.PrjRsstMstInfoService;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssCmplService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.nat.service.NatTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : NatTssPlnController.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.0808
 *********************************************************************************/

@Controller
@SuppressWarnings({ "unchecked", "rawtypes" })
public class NatTssPlnController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "prjRsstMstInfoService")
    private PrjRsstMstInfoService prjRsstMstInfoService; /* 프로젝트 마스터 서비스 */

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "natTssService")
    private NatTssService natTssService;

    @Resource(name = "codeService")
    private CodeService codeService;

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;			// 대외협력과제 서비스

    @Resource(name = "genTssCmplService")
    private GenTssCmplService genTssCmplService;

    static final Logger LOGGER = LogManager.getLogger(NatTssPlnController.class);


    //===================================================================================== 마스터
    /**
     * 과제관리 > 국책과제 > 계획 > 상세 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPlnDetail.do")
    public String natTssPlnDetail(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPlnDetail [과제관리 > 국책과제 > 계획 > 상세 화면]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = new HashMap<String, Object>();
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssPlnService.retrieveGenTssPlnMst(input);
            }
            result = StringUtil.toUtf8Output((HashMap) result);

            //사용자권한
            Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
            result.put("tssRoleType", "W");
            result.put("tssRoleId",   role.get("tssRoleId"));

            //사용자조직
            HashMap<String, Object> userMap = new HashMap<String, Object>();
            userMap.put("deptCd", input.get("_teamDept"));

            userMap = genTssService.retrievePrjSearch(userMap);
            
            //마스터 데이터
            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            model.addAttribute("userMap", userMap);
        }

        return "web/prj/tss/nat/pln/natTssPlnDetail";
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/insertNatTssPlnMst.do")
    public ModelAndView insertNatTssPlnMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertNatTssPlnMst [과제관리 > 국책과제 > 계획 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        HashMap<String, Object> smryDecodeDs = null;

        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            List<Map<String, Object>> smryDsListLst = RuiConverter.convertToDataSet(request, "smryInstDataSet");

            boolean upWbsCd = false;

            HashMap<String, Object> getWbs = genTssService.getWbsCdStd("prj.tss.com.getWbsCdStd", mstDs);

            if(getWbs == null || getWbs.size() <= 0) {
                mstDs.put("rtCd", "FAIL");
                mstDs.put("rtVal", "상위사업부코드 또는 Project약어를 먼저 생성해 주시기 바랍니다.");
            }
            else {
                //SEED WBS_CD 생성
                int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
                String seqMaxS = String.valueOf(seqMax + 1);
                mstDs.put("wbsCd", "N" + seqMaxS);

                smryDecodeDs = (HashMap<String, Object>)ousdCooTssService.decodeNamoEditorMap(input,smryDs); //에디터데이터 디코딩처리

                smryDecodeDs = StringUtil.toUtf8Input(smryDecodeDs);
                natTssService.insertNatTssPlnMst(mstDs, smryDecodeDs, smryDsListLst, upWbsCd);

                mstDs.put("rtCd", "SUCCESS");
                mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
                mstDs.put("rtType", "I");
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


    /**
     * 과제관리 > 국책과제 > 계획 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPlnMst.do")
    public ModelAndView updateNatTssPlnMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPlnMst [과제관리 > 국책과제 > 계획 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        //input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();
        HashMap<String, Object> smryDecodeDs = null;


        try {
            mstDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            List<Map<String, Object>> smryDsListLst = RuiConverter.convertToDataSet(request, "smryInstDataSet");

            boolean errYn   = false;
            boolean upWbsCd = false;

            if(!errYn) {
                smryDecodeDs = (HashMap<String, Object>)ousdCooTssService.decodeNamoEditorMap(input,smryDs); //에디터데이터 디코딩처리

                smryDecodeDs = StringUtil.toUtf8Input(smryDecodeDs);
                natTssService.updateNatTssPlnMst(mstDs, smryDecodeDs, smryDsListLst, upWbsCd);

                mstDs.put("rtCd", "SUCCESS");
                mstDs.put("tssCd",mstDs.get("tssCd"));
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


    /**
     * 과제관리 > 국책과제 > 계획 > 삭제
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssPlnMst.do")
    public ModelAndView deleteNatTssPlnMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssPlnMst [과제관리 > 국책과제 > 계획 > 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();

        try {
            natTssService.deleteNatTssPlnMst(input);

            mstDs.put("rtCd", "SUCCESS");
            mstDs.put("rtVal","삭제되었습니다."); //삭제되었습니다.

        }catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }



    //===================================================================================== 개요
    /**
     * 과제관리 > 국책과제 > 계획 > 개요 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPlnSmryIfm.do")
    public String natTssPlnSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPlnSmryIfm [과제관리 > 국책과제 > 계획 > 개요 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = natTssService.retrieveNatTssPlnSmry(input);
            }
            result = StringUtil.toUtf8Output((HashMap)result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/nat/pln/natTssPlnSmryIfm";
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 개요목록 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/grs/retrieveSmryCrroInstList.do")
    public ModelAndView retrieveSmryCrroInstList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveSmryCrroInstList 과제관리 > 국책과제 > 계획 > 개요목록 조회 ");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);
        HashMap<String, Object> inputMap = new HashMap<String, Object>();

        inputMap.put("tssCd", input.get("tssCd"));
        List<Map<String, Object>> rstGridDataSet = natTssService.retrieveSmryCrroInstList(inputMap);

        modelAndView.addObject("smryInstDataSet", RuiConverter.createDataset("dataSet", rstGridDataSet));

        return modelAndView;
    }



    //===================================================================================== 참여연구원
    /**
     * 과제관리 > 국책과제 > 계획 > 참여연구원 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPlnPtcRsstMbrIfm.do")
    public String natTssPlnPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPlnPtcRsstMbrIfm [과제관리 > 국책과제 > 계획 > 참여연구원 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE_NAT"); //참여역할

            model.addAttribute("codeRtcRole", codeRtcRole);

            List<Map<String, Object>> result = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pln/natTssPlnPtcRsstMbrIfm";
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 참여연구원 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPlnPtcRsstMbr.do")
    public ModelAndView retrieveNatTssPlnPtcRsstMbr(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPlnPtcRsstMbr [과제관리 > 국책과제 > 계획 > 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 참여연구원 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPlnPtcRsstMbr.do")
    public ModelAndView updateNatTssPlnPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPlnPtcRsstMbr [과제관리 > 국책과제 > 계획 > 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;
        List<Map<String, Object>> inputDs = new ArrayList<Map<String, Object>>();

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");

            String saSabunNew = "";
            String saUserName = "";
            String duistate    = "";
            String ptcRole    = "";
            int ptcPro = 0;

            for(int i = 0; i < ds.size(); i++) {
                saSabunNew = String.valueOf(ds.get(i).get("saSabunNew"));
                saUserName = String.valueOf(ds.get(i).get("saUserName"));
                duistate   = String.valueOf(ds.get(i).get("duistate"));
                ptcRole    = String.valueOf(ds.get(i).get("ptcRole"));

                if("0".equals(duistate)) {
                    continue;
                } else {
                    inputDs.add(ds.get(i));
                }

                ptcPro = 0;
                for(int j = 0; j < ds.size(); j++) {
                    if(saSabunNew.equals(ds.get(j).get("saSabunNew")) && "02".equals(ds.get(j).get("ptcRole"))) {
                        ptcPro += Integer.parseInt(String.valueOf(ds.get(j).get("ptcPro")));
                    }
                }

                //참여연구원  Vaildation
                String check = this.getValChk(ds.get(i), ptcRole, ptcPro);
                if(!"P".equals(check)) {
                    if("F1".equals(check)) {
                        ds.get(0).put("rtVal", saUserName+"("+saSabunNew+") : "+messageSourceAccessor.getMessage("msg.inf.check.ptc.01")); //과제리더는 3개 이하의 과제만 수행가능합니다..
                    }
                    else {
                        ds.get(0).put("rtVal", saUserName+"("+saSabunNew+") : "+messageSourceAccessor.getMessage("msg.inf.check.ptc.02")); //연구원은 총과제 참여율이 100%를 넘길수 없습니다.
                    }

                    ds.get(0).put("rtCd", "FAIL");

                    modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

                    return modelAndView;
                }
            }

            genTssPlnService.updateGenTssPlnPtcRsstMbr(inputDs);

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
     * 과제관리 > 국책과제 > 계획 > 참여연구원 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssPlnPtcRsstMbr.do")
    public ModelAndView deleteNatTssPlnPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssPlnPtcRsstMbr [과제관리 > 국책과제 > 계획 > 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "mbrDataSet");
            genTssPlnService.deleteGenTssPlnPtcRsstMbr(ds);

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
     * 참여연구원 과제 투입 확인
     *
     * @param object Object
     * @param ptcRole String
     * @param ptcPro int
     * @return String
     */
    public String getValChk(Object object, String ptcRole, int ptcPro) {
        String valChk = "P"; //성공

        //1.연구리더는 과제가 3개를 초과하지 못함
        if("01".equals(ptcRole)) {
            int rstPlCnt = natTssService.retrieveNatPtcPlCnt(object);
            if(rstPlCnt >= 4) {
                valChk = "F1";
            }
        }

        //2.연구원 총 과제의 참여율이 100%가 넘으면 선택못함
        if("02".equals(ptcRole)) {
            int rstRePer = natTssService.retrieveNatPtcRePer(object);
            if(rstRePer + ptcPro > 100) {
                valChk = "F2";
            }
        }

        return valChk;
    }


    //===================================================================================== 사업비
    /**
     * 과제관리 > 국책과제 > 계획 > 사업비 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPlnTrwiBudgIfm.do")
    public String natTssPlnTrwiBudgIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPlnTrwiBudgIfm [과제관리 > 국책과제 > 계획 > 사업비 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pln/natTssPlnTrwiBudgIfm";
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 사업비 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPlnTrwiBudg.do")
    public ModelAndView retrieveNatTssPlnTrwiBudg(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPlnTrwiBudg [과제관리 > 국책과제 > 계획 > 사업비 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);


        List<Map<String, Object>> result = natTssService.retrieveNatTssPlnTrwiBudg(input);
        if("2".equals(input.get("gridFlg"))) { //grid 하우시스 사업비 상세
            modelAndView.addObject("dataSet2", RuiConverter.createDataset("dataSet", result));
        }else {
            modelAndView.addObject("dataSet1", RuiConverter.createDataset("dataSet", result));
        }
        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 사업비 저장
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPlnTrwiBudg.do")
    public ModelAndView updateNatTssPlnTrwiBudg(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPlnTrwiBudg [과제관리 > 국책과제 > 계획 > 사업비 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet1");
            saveNatTssPlnTrwiBudg(ds ,input);
            ds  = RuiConverter.convertToDataSet(request, "dataSet2");
            saveNatTssPlnTrwiBudg(ds ,input);

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
     * 사업비 저장
     *
     * @param ds List<Map<String, Object>>
     * @param input HashMap<String, Object>
     */
    private  List<Map<String, Object>> saveNatTssPlnTrwiBudg( List<Map<String, Object>>  ds , HashMap<String, Object> input) {
        for(Map<String, Object> dsEach : ds) {
            dsEach.put("userId", input.get("_userId"));
            dsEach.put("tssCd", input.get("tssCd"));

            if("haa".equals(dsEach.get("comDtlCd3")) || "hba".equals(dsEach.get("comDtlCd3"))
                    || "hca".equals(dsEach.get("comDtlCd3")) || "hda".equals(dsEach.get("comDtlCd3"))
                    || "hea".equals(dsEach.get("comDtlCd3")) ) {
                dsEach.put("comDtlNm3",  dsEach.get("comDtlNm3")) ;
                dsEach.put("comDtlCd3",   dsEach.get("comDtlCd3")) ;
                natTssService.saveNatTssPlnTrwiBudg(dsEach);
                if("ha".equals(dsEach.get("comDtlCd2")) || "hb".equals(dsEach.get("comDtlCd2"))
                        || "hc".equals(dsEach.get("comDtlCd2")) || "hd".equals(dsEach.get("comDtlCd2"))
                        || "he".equals(dsEach.get("comDtlCd2")) ) {
                    dsEach.put("comDtlNm3",  dsEach.get("comDtlNm2")) ;
                    dsEach.put("comDtlCd3",   dsEach.get("comDtlCd2")) ;
                    natTssService.saveNatTssPlnTrwiBudg(dsEach);
                }
            }else {
                natTssService.saveNatTssPlnTrwiBudg(dsEach);
            }
        }
        return ds;
    }



    //===================================================================================== 목표산출물
    /**
     * 과제관리 > 국책과제 > 계획 > 목표산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPlnGoalYldIfm.do")
    public String natTssPlnGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPlnGoalYldIfm [과제관리 > 국책과제 > 계획 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pln/natTssPlnGoalYldIfm";
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPlnGoal.do")
    public ModelAndView retrieveNatTssPlnGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPlnGoal [과제관리 > 국책과제 > 계획 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = genTssPlnService.retrieveGenTssPlnGoal(input);
        for(int i = 0; i < resultGoal.size(); i++) {
            StringUtil.toUtf8Output((HashMap)resultGoal.get(i));
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
     * 과제관리 > 국책과제 > 계획 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPlnGoal.do")
    public ModelAndView updateNatTssPlnGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPlnGoal [과제관리 > 국책과제 > 계획 > 목표 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "goalDataSet");
            for(int i = 0; i < ds.size(); i++) {
                StringUtil.toUtf8Input((HashMap)ds.get(i));
            }

            genTssPlnService.updateGenTssPlnGoal(ds);

            ds.get(0).put("targetDs", "GOAL");
            ds.get(0).put("rtCd", "SUCCESS");
            ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        for(int i = 0; i < ds.size(); i++) {
            StringUtil.toUtf8Output((HashMap)ds.get(i));
        }
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 목표 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssPlnGoal.do")
    public ModelAndView deleteNatTssPlnGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssPlnGoal [과제관리 > 국책과제 > 계획 > 목표 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            genTssPlnService.deleteGenTssPlnGoal(ds);

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
     * 과제관리 > 국책과제 > 계획 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPlnYld.do")
    public ModelAndView retrieveNatTssPlnYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPlnYld [과제관리 > 국책과제 > 계획 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = genTssPlnService.retrieveGenTssPlnYld(input);
        for(int i = 0; i < resultYld.size(); i++) {
            StringUtil.toUtf8Output((HashMap)resultYld.get(i));
        }

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultYld));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultGoalCnt", 0);
        request.setAttribute("resultGoal", null);
        request.setAttribute("resultYldCnt", 0);
        request.setAttribute("resultYld", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPlnYld.do")
    public ModelAndView updateNatTssPlnYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPlnYld [과제관리 > 국책과제 > 계획 > 산출물 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            for(int i = 0; i < ds.size(); i++) {
                StringUtil.toUtf8Input((HashMap)ds.get(i));
            }

            genTssPlnService.updateGenTssPlnYld(ds);

            ds.get(0).put("targetDs", "YLD");
            ds.get(0).put("rtCd", "SUCCESS");
            ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        for(int i = 0; i < ds.size(); i++) {
            StringUtil.toUtf8Output((HashMap)ds.get(i));
        }
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 산출물 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssPlnYld.do")
    public ModelAndView deleteNatTssPlnYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssPlnYld [과제관리 > 국책과제 > 계획 > 산출물 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            genTssPlnService.deleteGenTssPlnYld(ds);

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
     * 과제관리 > 국책과제 > 계획 > 목표및산출물 > 목표 평가이력조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     */
    @RequestMapping(value="/prj/tss/nat/retrieveGoalEvHis.do")
    public ModelAndView retrieveGoalEvHis(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGoalEvHis [과제관리 > 국책과제 > 계획 > 목표및산출물 > 목표 평가이력조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = natTssService.retrieveGoalEvHis(input);
        modelAndView.addObject("dataSet3", RuiConverter.createDataset("dataset", resultGoal));

        return modelAndView;
    }



    //================================================================================================ 품의서
    /**
     * 과제관리 > 국책과제 > 계획 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPlnCsusRq.do")
    public String natTssPlnCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPlnCsusRq [과제관리 > 국책과제 > 계획 > 품의서요청 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst         = genTssPlnService.retrieveGenTssPlnMst(input);  //마스터
            Map<String, Object> resultSmry        = natTssService.retrieveNatTssPlnSmry(input); //개요
            Map<String, Object> resultCsus        = genTssService.retrieveGenTssCsus(resultMst); //품의서
            List<Map<String, Object>> resultCrro  = natTssService.retrieveNatTssCsusCrro(input); //수행기관
            List<Map<String, Object>> resultMbr   = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input); //참여연구원
            List<Map<String, Object>> resultBudg1 = natTssService.retrieveNatTssCsusBudg1(input); //추정예산1
            List<Map<String, Object>> resultBudg2 = natTssService.retrieveNatTssCsusBudg2(input); //추정예산1
            List<Map<String, Object>> resultGoal  = genTssPlnService.retrieveGenTssPlnGoal(input);

            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("tssCd",     String.valueOf(input.get("tssCd")));
            inputInfo.put("pgTssCd",   String.valueOf(resultMst.get("pgTssCd")));
            inputInfo.put("tssStrtDd", String.valueOf(resultMst.get("tssStrtDd")));
            inputInfo.put("tssFnhDd",  String.valueOf(resultMst.get("tssFnhDd")));
            inputInfo.put("attcFilId", String.valueOf(resultSmry.get("attcFilId")));

            List<Map<String, Object>> resultAttc  = genTssCmplService.retrieveGenTssCmplAttc(inputInfo);

            resultMst  = StringUtil.toUtf8Output((HashMap)resultMst);
            resultSmry = StringUtil.toUtf8Output((HashMap)resultSmry);
            resultCsus = StringUtil.toUtf8Output((HashMap)resultCsus);
//            for(int i = 0; i < resultGoal.size(); i++) {
//                    StringUtil.toUtf8Output((HashMap)resultGoal.get(i));
//            }

            model.addAttribute("inputData", input);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultCrro", resultCrro);
            model.addAttribute("resultMbr", resultMbr);
            model.addAttribute("resultBudg1", resultBudg1);
            model.addAttribute("resultBudg2", resultBudg2);
            model.addAttribute("resultGoal", resultGoal);
            model.addAttribute("resultCsus", resultCsus);
            model.addAttribute("resultAttc", resultAttc);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("jsonSmry", resultSmry);
            obj.put("jsonGoal", resultGoal);

            request.setAttribute("resultJson", obj);
        }

        return "web/prj/tss/nat/pln/natTssPlnCsusRq";
    }


    /**
     * 과제관리 > 국책과제 > 계획 > 품의서요청 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/insertNatTssPlnCsusRq.do")
    public ModelAndView insertNatTssPlnCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertNatTssPlnCsusRq [과제관리 > 국책과제 > 계획 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
            natTssService.insertNatTssPlnCsusRq(ds.get(0));

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
     * 과제관리 > 국책과제 > 계획 > 진행화면
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPlnPgsMove.do")
    public String natTssPgsCsus(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsCsus [과제관리 > 국책과제 > 계획 > 진행화면]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = natTssService.retrieveNatTssPgsCsus(input);

            //사용자권한
            Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
            result.put("tssRoleType", role.get("tssRoleType"));
            result.put("tssRoleId",   role.get("tssRoleId"));

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/nat/pgs/natTssPgsDetail";
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
