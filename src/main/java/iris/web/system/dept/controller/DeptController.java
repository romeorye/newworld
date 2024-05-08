/********************************************************************************
 * NAME : DeptController.java 
 * DESC : 부서
 * PROJ : IRIS UPGRADE 1�� ������Ʈ
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.25  ������	���ʻ���            
 *********************************************************************************/

package iris.web.system.dept.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import iris.web.common.util.StringUtil;
import iris.web.prj.rsst.service.PrjRsstMstInfoService;
import iris.web.system.base.IrisBaseController;
import iris.web.system.dept.service.DeptService;

@Controller
public class DeptController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "deptService")
	private DeptService deptService;
	
	@Resource(name = "prjRsstMstInfoService")
	private PrjRsstMstInfoService prjRsstMstInfoService;
	
	static final Logger LOGGER = LogManager.getLogger(DeptController.class);
	
	@RequestMapping(value="/system/dept/deptSearchPopup.do")
	public String deptSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("DeptController - deptSearchPopup 부서 조회 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/common/deptSearchPopup";
	}
	
	@RequestMapping(value="/system/dept/getDeptList.do")
	public ModelAndView getDeptList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("DeptController - getDeptList 부서 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		List<Map<String,Object>>  deptList = deptService.getDeptList(input);
	        
		modelAndView.addObject("deptDataset", RuiConverter.createDataset("deptDataset", deptList));

		return modelAndView;
	}
	
	

	/**
	 * 부서관리 목록
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/system/dept/upperDeptCdAList.do")
	public String deptCdAList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("DeptController - upperDeptCdAList 부서 조회 ");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/prj/mgmt/upperDeptCdA/upperDeptCdAList";
	}
	
	/**
	 * 상위부서(조직)관리
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/system/dept/retrieveUpperDeptList.do")
	public ModelAndView retrieveUpperDeptList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("DeptController - retrieveUpperDeptList 조직 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		List<Map<String,Object>>  deptList = deptService.retrieveUpperDeptList(input);
	        
		modelAndView.addObject("deptDataset", RuiConverter.createDataset("deptDataset", deptList));

		return modelAndView;
	}
	
	
	@RequestMapping(value="/system/dept/insertUpperDeptCdASave.do")
    public ModelAndView insertDeptCdASave(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
                                              HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertDeptCdASave [부서관리저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");
  
        checkSessionObjRUI(input, session, model);
        
        ModelAndView modelAndView = new ModelAndView("ruiView");
        
        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

        List<Map<String, Object>> dsLst = null;
   
        try {
          
            dsLst = RuiConverter.convertToDataSet(request,  "deptDataSet");
            input.put("userId", input.get("_userId"));
            String useYn = (String) input.get("useYn");
                	for(Map<String, Object> ds  : dsLst) {
                		ds.put("userId", input.get("_userId"));
                		if(StringUtil.isNullString(useYn)) {
                			useYn = "Y";
                		}
                		ds.put("useYn", useYn);
                		
                		deptService.saveUpperDeptCdA(ds);
                		prjRsstMstInfoService.updatePrjDeptCdA(ds);
                	}
                
        	rtnMeaasge.put("rtCd", "SUCCESS");
        	rtnMeaasge.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        
            
        } catch(Exception e) {
        	e.printStackTrace();	
        	rtnMeaasge.put("rtCd", "FAIL");
        	rtnMeaasge.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }
        
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rtnMeaasge));
        return modelAndView;
    }
	
}