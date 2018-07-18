package iris.web.system.base;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.ui.ModelMap;

import iris.web.system.menu.service.IrisFrameMenuService;

import devonframe.util.NullUtil;

public class IrisBaseController {

    private static final String AFFR_MAIN_SCN = "ESTI";
    private static final String AFFR_SUB_SCN = "SPOT";
    private static final String DEFAULT_MENU_NAME = "게시판";
    private static final String GRID_SPLIT_SIGN = "\t";
    
	@Resource(name="irisFrameMenuService")
	private IrisFrameMenuService frameMenuService;
	
    public IrisBaseController() {
    	
    }
    
    public void checkSession(HashMap<String, String> input,HttpSession session,ModelMap model){
    	
    	HashMap lsession = (HashMap)session.getAttribute("irisSession");
    	
    	if(! NullUtil.isNull(lsession)){
	        Iterator iterSession = lsession.entrySet().iterator();
	        while (iterSession.hasNext()) {
	            Map.Entry entry = (Map.Entry) iterSession.next();
	            if(!input.containsKey(entry.getKey())) input.put((String) entry.getKey(), (String) entry.getValue());
	        }		    	
	    	
//	        setMenuInfo(NullUtil.nvl(input.get("vMenuId"), ""), NullUtil.nvl(input.get("_xcmkCd"), ""), NullUtil.nvl(input.get("_userId"), ""), NullUtil.nvl(input.get("menuMoveYn"), ""), model);
	        
	        model.addAttribute("loginUser", lsession);
	        model.addAttribute("rowsPerPage", NullUtil.nvl(lsession.get("rowsPerPage"),"50"));
    	}
    }
    
    public void checkSessionRUI(HashMap<String, String> input,HttpSession session,ModelMap model){
    	
    	HashMap lsession = (HashMap)session.getAttribute("irisSession");
    	
    	if(! NullUtil.isNull(lsession)){
	        Iterator iterSession = lsession.entrySet().iterator();
	        while (iterSession.hasNext()) {
	            Map.Entry entry = (Map.Entry) iterSession.next();
	            if(!input.containsKey(entry.getKey())) input.put((String) entry.getKey(), (String) entry.getValue());
	        }
	        
//	        setMenuInfo(NullUtil.nvl(input.get("vMenuId"), ""), NullUtil.nvl(input.get("_xcmkCd"), ""), NullUtil.nvl(input.get("_userId"), ""), NullUtil.nvl(input.get("menuMoveYn"), ""), model);
    	}
    }    
	
    public void checkSessionObjRUI(HashMap<String, Object> input,HttpSession session,ModelMap model){
    	
    	HashMap lsession = (HashMap)session.getAttribute("irisSession");
    	
    	if(! NullUtil.isNull(lsession)){
	        Iterator iterSession = lsession.entrySet().iterator();
	        while (iterSession.hasNext()) {
	            Map.Entry entry = (Map.Entry) iterSession.next();
	            if(!input.containsKey(entry.getKey())) input.put((String) entry.getKey(), (String) entry.getValue());
	        }
	        
//	        setMenuInfo(NullUtil.nvl(input.get("vMenuId"), ""), NullUtil.nvl(input.get("_xcmkCd"), ""), NullUtil.nvl(input.get("_userId"), ""), NullUtil.nvl(input.get("menuMoveYn"), ""), model);
    	}
    }     
    
    public void setMenuInfo(String vMenuId, String xcmkCd, String userId, String menuMoveYn, ModelMap model){
    	
    	if(!"Y".equals(menuMoveYn) && !"".equals(vMenuId) && !"".equals(xcmkCd) && !"".equals(userId)){
    		HashMap <String, Object> input = new HashMap <String, Object> ();
    		
    		input.put("menuId", vMenuId);
    		input.put("xcmkCd", xcmkCd);
    		input.put("userId", userId);
    		
    		Map <String, Object> menuInfo = frameMenuService.retrieveMenuInfo(input);
    		model.addAttribute("menuInfo", menuInfo);
    	}
    	
    }
}
