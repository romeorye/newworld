package iris.web.system.menu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


@Service("irisFrameMenuService")
public class IrisFrameMenuServiceImpl implements IrisFrameMenuService {

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public List<Map<String, Object>> retrieveMenuAffrList(HashMap<String, String> input) {
    	return commonDao.selectList("sql-menu.retrieveMenuAffrList",input);
    	
    }
	
    public List<Map<String, Object>> retrieveTopMenuList(HashMap<String, Object> input) {
    	return commonDao.selectList("sql-menu.retrieveTopMenuList",input);
    }
    
    public List<Map<String, Object>> retrieveSubMenuList(HashMap<String, String> input) {
    	return commonDao.selectList("sql-menu.retrieveSubMenuList",input);
    }

    public Map <String, Object> retrieveMenuInfo(HashMap<String, Object> input){
    	/** 메뉴 이용 로그  */
    	commonDao.update("sql-menu.insertMenuHit", input);
    	return commonDao.select("sql-menu.retrieveMenuInfo", input);
    }
    
    public Map <String, Object> retrieveMenuInfoString(HashMap<String, String> input){
    	/** 메뉴 이용 로그  */
    	commonDao.update("sql-menu.insertMenuHit", input);
    	return commonDao.select("sql-menu.retrieveMenuInfo", input);
    }
    
    public Map <String, Object> checkMyMenu(HashMap<String, Object> input){
    	return commonDao.select("sql-menu.checkMyMenu", input);
    }
    
	public int insertMyMenu(HashMap<String, Object> input){
		return commonDao.insert("sql-menu.insertMyMenu", input);
	}
	
	public int deleteMyMenu(HashMap<String, Object> input){
		return commonDao.insert("sql-menu.deleteMyMenu", input);
	}
	
	public List<Map<String, Object>> retrieveMyMenuList(HashMap<String, String> input){
		return commonDao.selectList("sql-menu.retrieveMyMenuList",input);
	}
	
	public List<Map<String, Object>> retrieveQuickLinkList(HashMap<String, Object> input){
		return commonDao.selectList("sql-menu.retrieveQuickLinkList",input);
	}
	
    public Map <String, Object> retrieveSubMenuId(HashMap<String, String> input){
    	return commonDao.select("sql-menu.retrieveSubMenuId", input);
    }
    
    public int retrieveSubMenuYn(HashMap<String, String> input){
    	return commonDao.select("sql-menu.retrieveSubMenuYn", input);
    }
    
    public Map <String, Object> retrieveThirdMenuUrl(HashMap<String, String> input){
    	return commonDao.select("sql-menu.retrieveThirdMenuUrl", input);
    }
    
    public Map <String, Object> retrieveSubMenuUrl(HashMap<String, String> input){
    	return commonDao.select("sql-menu.retrieveSubMenuUrl", input);
    }
    
}
