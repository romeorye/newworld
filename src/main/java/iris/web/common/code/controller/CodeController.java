package iris.web.common.code.controller;

import java.util.HashMap;
import java.util.List;

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

import devonframe.util.NullUtil;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.code.service.CodeService;
import iris.web.common.converter.RuiConverter;
import iris.web.system.base.IrisBaseController;

/**
 * <pre>
 * 본 클래스는 코드 정보에 대한 CRUD를 담당하는 Controller 클래스입니다.
 * </pre>
 *
 * @author XXX팀 OOO
 */

@Controller
public class CodeController extends IrisBaseController  {

    @Resource(name = "codeService")
    private CodeService codeService;

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "codeCacheManager")
    private CodeCacheManager codeCacheManager;

    static final Logger LOGGER = LogManager.getLogger(CodeController.class);


    @RequestMapping(value="/common/code/retrieveCodeListForCache.do")
    public ModelAndView retrieveCodeListForCache(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("CodeController - retrieveCodeListForCache [공통코드 캐쉬조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공통코드 캐쉬조회
        List codeList = codeCacheManager.retrieveCodeValueListForCache(NullUtil.nvl(input.get("comCd"), ""));

        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", codeList));

        return modelAndView;
    }

    @RequestMapping(value="/common/code/retrieveCodeAllListForCache.do")
    public ModelAndView retrieveCodeAllListForCache(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("CodeController - retrieveCodeAllListForCache [공통코드 캐쉬조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공통코드 캐쉬조회
        List codeList = codeCacheManager.retrieveCodeAllListForCache(input);

        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", codeList));

        return modelAndView;
    }

    @RequestMapping(value="/common/code/refresh.do")
    public ModelAndView refresh(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("CodeController - retrieveCodeAllListForCache [공통코드 캐시제거]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        input.put("comCd", "");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공통코드 캐시제거 및 재조회
        codeCacheManager.refresh();
        List codeList = codeCacheManager.retrieveCodeAllListForCache(input).subList(0, 1); //임시로 넣기
        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", codeList));

        return modelAndView;
    }

}
