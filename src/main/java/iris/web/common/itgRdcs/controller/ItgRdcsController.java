package iris.web.common.itgRdcs.controller;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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
import iris.web.common.itgRdcs.service.ItgRdcsService;
import iris.web.system.base.IrisBaseController;


@Controller
public class ItgRdcsController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "itgRdcsService")
	private ItgRdcsService itgRdcsService;

	static final Logger LOGGER = LogManager.getLogger(ItgRdcsController.class);


	/**
	 *  전자결재 정보 저장
	 */
	@RequestMapping(value="/ItgRdcs/saveItgRdcsInfo.do")
	public ModelAndView saveItgRdcsInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";

		try{
			itgRdcsService.saveItgRdcsInfo(input);

			//결재 url 호출


			rtnMsg = "저장되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생하였습니다. 관리자에게 문의해주십시오";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}


	/**
	 *  전자결재 삭제

	@RequestMapping(value="/ItgRdcs/deleteItgRdcsInfo.do")
	public ModelAndView deleteItgRdcsInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		LOGGER.debug("session="+lsession);

		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";

		try{

			itgRdcsService.deleteItgRdcsInfo(input);

			rtnMsg = "삭제되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생하였습니다. 관리자에게 문의해주십시오";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}
	*/
}
