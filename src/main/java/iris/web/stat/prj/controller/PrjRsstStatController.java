package iris.web.stat.prj.controller;

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
import iris.web.stat.prj.service.PrjRsstStatService;
import iris.web.system.base.IrisBaseController;

@Controller
public class PrjRsstStatController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name="prjRsstStatService")
	private PrjRsstStatService prjRsstStatService;
	
	static final Logger LOGGER = LogManager.getLogger(PrjRsstStatController.class);
	
	
	 /**
     * 통계 > 프로젝트 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/prj/prjState.do")
    public String prjRsstStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	LOGGER.debug("###########################################################");
        LOGGER.debug("prjState [통계 > 프로젝트 리스트 화면]");
        LOGGER.debug("###########################################################");
    	
        checkSessionObjRUI(input, session, model);

         model.addAttribute("inputData", input);

        return "web/stat/prj/prjRsstStatList";
    }
    
    /**
     * 통계 > 일반과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrievePrjRsstStatList.do")
    public ModelAndView retrievePrjRsstStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePrjRsstStatList [통계 > 프로젝트 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = prjRsstStatService.retrievePrjRsstStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }
}
