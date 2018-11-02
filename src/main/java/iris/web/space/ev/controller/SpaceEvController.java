package iris.web.space.ev.controller;

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

import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.knld.mgmt.service.ReteriveRequestService;
import iris.web.space.ev.service.SpaceEvService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : SpaceEvController.java
 * DESC : 공간평가 - 평가법 관리 controller
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.08.03  정현웅	최초생성
 *********************************************************************************/

@Controller
public class SpaceEvController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "spaceEvService")
	private SpaceEvService spaceEvService;

	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;

	@Resource(name = "knldRtrvRqService")
	private ReteriveRequestService knldRtrvRqService;

	static final Logger LOGGER = LogManager.getLogger(SpaceEvController.class);



	@RequestMapping(value="/space/spaceEvaluationMgmt.do")
	public String spaceEvaluationMgmt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvaluationMgmt [공간평가 평가법 관리화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceEvaluationMgmt";
	}

	@RequestMapping(value="/space/spaceEvBzdvList.do")
	public ModelAndView spaceEvBzdvList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvBzdvList [공간평가 평가법관리 사업부 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 분석담당자 리스트 조회
		List<Map<String,Object>> spaceEvBzdvList = spaceEvService.getSpaceEvBzdvList(input);

		modelAndView.addObject("spaceEvBzdvDataSet", RuiConverter.createDataset("spaceEvBzdvDataSet", spaceEvBzdvList));
		LOGGER.debug("spaceEvBzdvList : " + spaceEvBzdvList);
		return modelAndView;
	}

	@RequestMapping(value="/space/spaceEvProdClList.do")
	public ModelAndView spaceEvProdClList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvProdClList [공간평가 평가법관리 제품군 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 분석담당자 리스트 조회
		List<Map<String,Object>> getSpaceEvProdClList = spaceEvService.getSpaceEvProdClList(input);

		modelAndView.addObject("getSpaceEvProdClList", RuiConverter.createDataset("getSpaceEvProdClList", getSpaceEvProdClList));
		LOGGER.debug("getSpaceEvClList : " + getSpaceEvProdClList);
		return modelAndView;
	}

	@RequestMapping(value="/space/spaceEvClList.do")
	public ModelAndView spaceEvClList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvClList [공간평가 평가법관리 분류 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 분석담당자 리스트 조회
		List<Map<String,Object>> getSpaceEvClList = spaceEvService.getSpaceEvClList(input);

		modelAndView.addObject("getSpaceEvProdClList", RuiConverter.createDataset("getSpaceEvClList", getSpaceEvClList));
		LOGGER.debug("getSpaceEvClList : " + getSpaceEvClList);
		return modelAndView;
	}

	@RequestMapping(value="/space/spaceEvProdList.do")
	public ModelAndView spaceEvProdList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvProdList [공간평가 평가법관리 제품 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 분석담당자 리스트 조회
		List<Map<String,Object>> getSpaceEvProdList = spaceEvService.getSpaceEvProdList(input);

		modelAndView.addObject("getSpaceEvProdList", RuiConverter.createDataset("getSpaceEvProdList", getSpaceEvProdList));
		LOGGER.debug("getSpaceEvProdList : " + getSpaceEvProdList);
		return modelAndView;
	}

	@RequestMapping(value="/space/spaceEvMtrlList.do")
	public ModelAndView spaceEvMtrlList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvMtrlList [공간평가 평가법관리 상세 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공간평가 평가법관리 상세 조회
		List<Map<String,Object>> getSpaceEvMtrlList = spaceEvService.getSpaceEvMtrlList(input);

		modelAndView.addObject("getSpaceEvMtrlList", RuiConverter.createDataset("getSpaceEvMtrlList", getSpaceEvMtrlList));
		LOGGER.debug("getSpaceEvMtrlList : " + getSpaceEvMtrlList);
		return modelAndView;
	}

	@RequestMapping(value="/space/spaceRqprRsltList.do")
	public ModelAndView spaceRqprRsltList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

    	input = StringUtil.toUtf8(input);
		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceRqprRsltList [공간평가 평가결과서 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공간평가 평가법관리 상세 조회
		List<Map<String,Object>> spaceRqprRsltList = spaceEvService.spaceRqprRsltList(input);

		modelAndView.addObject("spaceRqprRsltList", RuiConverter.createDataset("spaceRqprRsltList", spaceRqprRsltList));
		LOGGER.debug("spaceRqprRsltList : " + spaceRqprRsltList);
		return modelAndView;
	}

	@RequestMapping(value="/space/spaceEvMtrlReqPop.do")
	public String spaceEvMtrlReqPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		return  "web/space/rqpr/spaceEvaluationMgmtReqPopup";
	}

	@RequestMapping(value="/space/spaceEvMtrlDtlPop.do")
	public String spaceEvMtrlDtlPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		model.addAttribute("inputData", input);
		return  "web/space/rqpr/spaceEvaluationMgmtDtlPopup";
	}

	@RequestMapping(value="/space/spaceEvMtrlDtl.do")
	public ModelAndView spaceEvMtrlDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = spaceEvService.getSpaceEvMtrlDtl(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;

	}

	//자재단위평가등록
	@RequestMapping(value="/space/insertSpaceEvMtrl.do")
	public ModelAndView insertSpaceEvMtrl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String,Object> ds = null;
        Map<String,Object> resultMap = new HashMap<String, Object>();

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet").get(0);

            ds.put("cmd", input.get("save"));
			ds.put("userId", input.get("_userId"));

			spaceEvService.insertSpaceEvMtrl(ds);

            resultMap.put("cmd", "saveAnlExprMst");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");

            //ds.get(0).put("rtCd", "SUCCESS");
            //ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
        	e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다.\n관리자에게 문의하세요.");
        }

        modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

        return modelAndView;
	}

	//자재단위평가등록
	@RequestMapping(value="/space/updateSpaceEvMtrl.do")
	public ModelAndView updateSpaceEvMtrl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String,Object> ds = null;
        Map<String,Object> resultMap = new HashMap<String, Object>();

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet").get(0);

            ds.put("cmd", input.get("save"));
			ds.put("userId", input.get("_userId"));

			spaceEvService.updateSpaceEvMtrl(ds);

            resultMap.put("cmd", "saveAnlExprMst");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");

            //ds.get(0).put("rtCd", "SUCCESS");
            //ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
        	e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다.\n관리자에게 문의하세요.");
        }

        modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

        return modelAndView;
	}


	/** 자재단위평가 삭제 **/
	@RequestMapping(value="/space/deleteSpaceEvMtrl.do")
	public ModelAndView deleteSpaceEvMtrl(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		try
		{
			spaceEvService.deleteSpaceEvMtrl(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("spaceEvMtrlListDataSet", RuiConverter.createDataset("spaceEvMtrlListDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 사업부 삭제 **/
	@RequestMapping(value="/space/deleteSpaceEvCtgr0.do")
	public ModelAndView deleteSpaceEvCtgr0(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		try
		{
			spaceEvService.deleteSpaceEvCtgr0(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("spaceEvBzdvDataSet", RuiConverter.createDataset("spaceEvBzdvDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 제품군 삭제 **/
	@RequestMapping(value="/space/deleteSpaceEvCtgr1.do")
	public ModelAndView deleteSpaceEvCtgr1(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		try
		{
			spaceEvService.deleteSpaceEvCtgr1(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("spaceEvProdClDataSet", RuiConverter.createDataset("spaceEvProdClDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 분류 삭제 **/
	@RequestMapping(value="/space/deleteSpaceEvCtgr2.do")
	public ModelAndView deleteSpaceEvCtgr2(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		try
		{
			spaceEvService.deleteSpaceEvCtgr2(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("spaceEvClDataSet", RuiConverter.createDataset("spaceEvClDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 제품 삭제 **/
	@RequestMapping(value="/space/deleteSpaceEvCtgr3.do")
	public ModelAndView deleteSpaceEvCtgr3(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		try
		{
			spaceEvService.deleteSpaceEvCtgr3(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("spaceEvProdDataSet", RuiConverter.createDataset("spaceEvProdDataSet", rtnMeaasge));
		return modelAndView;
	}

	//사업장등록
	@RequestMapping(value="/space/saveSpaceEvCtgr0.do")
	public ModelAndView saveSpaceEvCtgr0(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        String userId = (String)input.get("_userId");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "spaceEvBzdvDataSet");
            for(Map<String,Object> data : ds) {
				data.put("userId", userId);
			}
            spaceEvService.saveSpaceEvCtgr0(ds);

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

	//제품군등록
	@RequestMapping(value="/space/saveSpaceEvCtgr1.do")
	public ModelAndView saveSpaceEvCtgr1(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        String userId = (String)input.get("_userId");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "spaceEvProdClDataSet");
            for(Map<String,Object> data : ds) {
				data.put("userId", userId);
			}
            spaceEvService.saveSpaceEvCtgr1(ds);

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

	//분류등록
	@RequestMapping(value="/space/saveSpaceEvCtgr2.do")
	public ModelAndView saveSpaceEvCtgr2(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        String userId = (String)input.get("_userId");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "spaceEvClDataSet");
            for(Map<String,Object> data : ds) {
				data.put("userId", userId);
			}
            spaceEvService.saveSpaceEvCtgr2(ds);

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

	//제품등록
	@RequestMapping(value="/space/saveSpaceEvCtgr3.do")
	public ModelAndView saveSpaceEvCtgr3(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        String userId = (String)input.get("_userId");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "spaceEvProdDataSet");
            for(Map<String,Object> data : ds) {
				data.put("userId", userId);
			}
            spaceEvService.saveSpaceEvCtgr3(ds);

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
}