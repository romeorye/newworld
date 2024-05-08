package iris.web.knld.nrm.controller;

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

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.knld.nrm.service.NrmInfoService;
import iris.web.knld.pub.controller.ConferenceController;
import iris.web.system.base.IrisBaseController;

@Controller
public class NrmInfoController extends IrisBaseController{

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name="nrmInfoService")
	private NrmInfoService nrmInfoService;
	
	static final Logger LOGGER = LogManager.getLogger(ConferenceController.class);
	
	/*리스트 화면 호출*/
	@RequestMapping(value="/knld/nrm/nrmList.do")
	public String nrmList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("NrmInfoController - nrmList [규격 리스트 화면이동 ]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/nrm/nrmList";
	}
	
	
	/*리스트*/
	@RequestMapping(value="/knld/nrm/retrieveNrmSearchList.do")
	public ModelAndView retrieveNrmSearchList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ConferenceController - retrieveNrmSearchList [규격 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 학회컨퍼런스 리스트 조회
		List<Map<String,Object>> nrmList = nrmInfoService.retrieveNrmSearchList(input);

		modelAndView.addObject("knldNrmDataSet", RuiConverter.createDataset("knldNrmDataSet", nrmList));
		return modelAndView;
	}
	
	/*규격상세 화면 호출*/
	@RequestMapping(value="/knld/nrm/nrmInfoDtl.do")
	public String nrmInfoDtl(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("NrmInfoController - nrmInfoDtl [규격상세 화면이동 ]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/nrm/nrmDetail";
	}
	
	
	/*리스트*/
	@RequestMapping(value="/knld/nrm/retrieveNrmInfo.do")
	public ModelAndView retrieveNrmInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ConferenceController - retrieveNrmInfo [규격상세 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 학회컨퍼런스 리스트 조회
		Map<String,Object> nrmInfo = nrmInfoService.retrieveNrmInfo(input);

		modelAndView.addObject("knldNrmDataSet", RuiConverter.createDataset("knldNrmDataSet", nrmInfo));
		return modelAndView;
	}
	
	
	/*규격 등록및 수정*/
	@RequestMapping(value="/knld/nrm/saveNrmInfo.do")
	public ModelAndView saveNrmInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ConferenceController - saveNrmInfo [규격 등록및 수정]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

	    HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		Map<String, Object> nrmInfo = new HashMap<String, Object>();
		String rtnSt ="F";
		String rtnMsg = "";
			
		try{
			nrmInfo = RuiConverter.convertToDataSet(request, "knldNrmDataSet").get(0);
			nrmInfo.put("userId", input.get("_userId"));

			nrmInfoService.saveNrmInfo(nrmInfo);
			
			rtnMsg = "저장되었습니다.";
			rtnSt = "S";
			
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = e.getMessage();
		}
		
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
		
	}
	
	
	
	
	
	
	
}
