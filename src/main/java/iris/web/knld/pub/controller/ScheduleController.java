package iris.web.knld.pub.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.knld.pub.service.ScheduleService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : ScheduleController.java 
 * DESC : Knowledge - 일정 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성
 *********************************************************************************/

@Controller
public class ScheduleController extends IrisBaseController {
	
	@Resource(name = "knldScheduleService")
	private ScheduleService knldScheduleService;
	
	static final Logger LOGGER = LogManager.getLogger(ScheduleController.class);

	@RequestMapping(value="/knld/pub/retrieveLabSchedule.do")
	public String scheduleMng(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ScheduleController - scheduleMng [연구소 주요일정 관리 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
		String fromAdscDt = DateUtil.addDays(today, -(DateUtil.whichDay(today, "yyyy-MM-dd")-1), "yyyy-MM-dd");
		
		input.put("fromAdscDt", fromAdscDt);
		input.put("toAdscDt", DateUtil.addDays(fromAdscDt, 6, "yyyy-MM-dd"));
		input.put("adscMonth", today.substring(0, 7));

		String adscMonth = (String)input.get("adscMonth");
		String beforeMonth = null;
		String afterMonth = null;
		int year = Integer.parseInt(adscMonth.substring(0, 4));
		int month = Integer.parseInt(adscMonth.substring(5)) - 1;
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM", java.util.Locale.KOREA);
		
		calendar.set(year, month, 1);
		
		calendar.add(Calendar.MONTH, -1);
		
		beforeMonth = formatter.format(calendar.getTime());
		
		calendar.add(Calendar.MONTH, 2);
		
		afterMonth = formatter.format(calendar.getTime());
    	
		List<Map<String,Object>> monthScheduleList = knldScheduleService.getMonthScheduleList(input);
		
		model.addAttribute("inputData", input);
		model.addAttribute("beforeMonth", beforeMonth);
		model.addAttribute("afterMonth", afterMonth);
		model.addAttribute("monthScheduleList", monthScheduleList);

		return "web/knld/pub/scheduleMng";
	}
	
	@RequestMapping(value="/knld/schedule/getDayScheduleList.do")
	public ModelAndView getDayScheduleList(
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
		LOGGER.debug("ScheduleController - getDayScheduleList [연구소 주요일정 일별 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> dayScheduleList = knldScheduleService.getDayScheduleList(input);
		
		modelAndView.addObject("dayDataSet", RuiConverter.createDataset("dayDataSet", dayScheduleList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/knld/schedule/getMonthScheduleList.do")
	public String getMonthScheduleList(
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
		LOGGER.debug("ScheduleController - getMonthScheduleList [연구소 주요일정 월별 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

		String adscMonth = (String)input.get("adscMonth");
		String beforeMonth = null;
		String afterMonth = null;
		int year = Integer.parseInt(adscMonth.substring(0, 4));
		int month = Integer.parseInt(adscMonth.substring(5)) - 1;
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM", java.util.Locale.KOREA);
		
		calendar.set(year, month, 1);
		
		calendar.add(Calendar.MONTH, -1);
		
		beforeMonth = formatter.format(calendar.getTime());
		
		calendar.add(Calendar.MONTH, 2);
		
		afterMonth = formatter.format(calendar.getTime());
    	
		List<Map<String,Object>> monthScheduleList = knldScheduleService.getMonthScheduleList(input);

		model.addAttribute("inputData", input);
		model.addAttribute("beforeMonth", beforeMonth);
		model.addAttribute("afterMonth", afterMonth);
		model.addAttribute("monthScheduleList", monthScheduleList);
		
		return "web/knld/pub/scheduleMonthList";
	}
	
	@RequestMapping(value="/knld/schedule/scheduleDetailPopup.do")
	public String scheduleDetailPopup(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ScheduleController - scheduleDetailPopup 연구소 주요일정 상세 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
    	
		Map<String,Object> scheduleInfo = knldScheduleService.getScheduleInfo(input);
		
		model.addAttribute("inputData", input);
		model.addAttribute("scheduleInfo", scheduleInfo);
		
		return "web/knld/pub/scheduleDetailPopup";
	}
	
	@RequestMapping(value="/knld/schedule/saveSchedulePopup.do")
	public String saveSchedulePopup(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ScheduleController - saveSchedulePopup 연구소 주요일정 저장 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);
		
		return "web/knld/pub/saveSchedulePopup";
	}
	
	@RequestMapping(value="/knld/schedule/getScheduleInfo.do")
	public ModelAndView getScheduleInfo(
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
		LOGGER.debug("ScheduleController - getScheduleInfo [연구소 주요일정 상세 정보 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		Map<String,Object> scheduleInfo = knldScheduleService.getScheduleInfo(input);
		
		modelAndView.addObject("scheduleDataSet", RuiConverter.createDataset("scheduleDataSet", scheduleInfo));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/knld/schedule/saveSchedule.do")
	public ModelAndView saveSchedule(
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
		LOGGER.debug("ScheduleController - saveSchedule 연구소 주요일정 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			knldScheduleService.saveSchedule(input);

			resultMap.put("cmd", "saveSchedule");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/knld/schedule/deleteSchedule.do")
	public ModelAndView deleteSchedule(
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
		LOGGER.debug("ScheduleController - deleteSchedule 연구소 주요일정 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			knldScheduleService.deleteSchedule(input);

			resultMap.put("cmd", "saveSchedule");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
}