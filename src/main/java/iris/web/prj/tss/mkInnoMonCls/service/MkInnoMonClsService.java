package iris.web.prj.tss.mkInnoMonCls.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MkInnoMonClsService {

	/**
     * 과제관리 > 제조혁신 월마감 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrieveMkInnoMonClsSearchList(HashMap<String, Object> input);

	/**
     * 과제관리 > 제조혁신 월마감 상세 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
	Map<String, Object> retrieveMkInnoMonClsDtl(HashMap<String, Object> input);

	/**
     * 과제관리 > 제조혁신 월마감 저장 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
	void updateMkInnoMonClsInfo(Map<String, Object> monClsInfo)  throws Exception ;

}
