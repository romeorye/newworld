package iris.web.prj.tss.mkInnoMonCls.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("mkInnoMonClsService")
public class MkInnoMonClsServiceImpl implements MkInnoMonClsService {
	
static final Logger LOGGER = LogManager.getLogger(MkInnoMonClsServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	

	
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
	public List<Map<String, Object>> retrieveMkInnoMonClsSearchList(HashMap<String, Object> input){
		return commonDao.selectList("prj.mkInnoMonCls.retrieveMkInnoMonClsSearchList" ,input);
	}
	
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
	public Map<String, Object> retrieveMkInnoMonClsDtl(HashMap<String, Object> input) {
		return commonDao.select("prj.mkInnoMonCls.retrieveMkInnoMonClsDtl" ,input);
	}
	
	/**
     * 과제관리 > 제조혁신 월마감 저장 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
	 * @throws Exception 
     * */
	public void updateMkInnoMonClsInfo(Map<String, Object> monClsInfo) throws Exception {
		
		if( commonDao.update("prj.mkInnoMonCls.updateMkInnoMonClsInfo" ,monClsInfo) > 0 ){
			
		}else{
			throw new Exception("저장중 오류가 발생했습니다.");
		}
		
	}

	
	
	
	
}
