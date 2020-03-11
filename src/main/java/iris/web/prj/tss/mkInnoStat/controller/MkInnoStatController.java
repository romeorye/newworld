package iris.web.prj.tss.mkInnoStat.controller;

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
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.mkInnoStat.service.MkInnoStatService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MkInnoStatController extends IrisBaseController{

	@Resource(name = "mkInnoStatService")
	private MkInnoStatService mkInnoStatService;
	
	static final Logger LOGGER = LogManager.getLogger(MkInnoStatController.class);
	

	
	
	/*
	 * 제조혁신과제 대시보드
	 */
	@RequestMapping("/prj/tss/mkInnoStat/mkInnoTssPgsList.do")
	public String mkInnoTssPgsList(@RequestParam HashMap<String, String> input,
							 HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("MkInnoStatController - mkInnoTssPgsList [제조혁신과제 대시보드 화면 호출]");
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8(input);

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/prj/tss/mkInno/mkInnoStat/mkInnoTssPgsList";
	}
	
	/**
     * 과제관리 > 제조혁신 대시보드 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInnoStat/retrieveMkInnoStatInfoList.do")
    public ModelAndView retrieveMkInnoStatInfoList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoStatController - retrieveMkInnoStatInfoList [과제관리 > 제조혁신 대시보드 리스트조회]");
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        //과제건수 사업부별 과제 관리
        List<Map<String,Object>> cntBizList = mkInnoStatService.retrieveCntBizSearchList(input);
        //과제건수 팀별 과제 관리
        List<Map<String,Object>> cntTeamList = mkInnoStatService.retrieveCntTeamSearchList(input);
        //과제진행현황 사업부별 관리
        List<Map<String,Object>> pgsBizList = mkInnoStatService.retrievePgsBizSearchList(input);
        //과제진행현황 팀별 관리
        List<Map<String,Object>> pgsTeamList = mkInnoStatService.retrievePgsTeamSearchList(input);
        
        modelAndView.addObject("cntBizDataSet", RuiConverter.createDataset("cntBizDataSet", cntBizList));
        modelAndView.addObject("cntTeamDataSet", RuiConverter.createDataset("cntTeamDataSet", cntTeamList));
        modelAndView.addObject("pgsBizDataSet", RuiConverter.createDataset("pgsBizDataSet", pgsBizList));
        modelAndView.addObject("pgsTeamDataSet", RuiConverter.createDataset("pgsTeamDataSet", pgsTeamList));

        return modelAndView;
    }

	
	
}
