/*------------------------------------------------------------------------------
 * NAME : IrisFrameMenuService
 * DESC : 메뉴 service
 * VER  : V1.0
 * PROJ : LG CNS WINS 업그레이드 1차 프로젝트
 * Copyright 2016 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016/06/14  김수예   최초생성
 *------------------------------------------------------------------------------*/
package iris.web.system.menu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface IrisFrameMenuService {
	public List<Map<String, Object>> retrieveMenuAffrList(HashMap<String, String> input);
	
	public List<Map<String, Object>> retrieveTopMenuList(HashMap<String, Object> input);
	
	public List<Map<String, Object>> retrieveSubMenuList(HashMap<String, String> input);
	
	public Map <String, Object> retrieveMenuInfo(HashMap<String, Object> input);
	
	public Map <String, Object> retrieveMenuInfoString(HashMap<String, String> input);
	
	public Map <String, Object> checkMyMenu(HashMap<String, Object> input);
	
	public int insertMyMenu(HashMap<String, Object> input);
	
	public int deleteMyMenu(HashMap<String, Object> input);
	
	public List<Map<String, Object>> retrieveMyMenuList(HashMap<String, String> input);
	
	public List<Map<String, Object>> retrieveQuickLinkList(HashMap<String, Object> input);
	
	public Map <String, Object> retrieveSubMenuId(HashMap<String, String> input);
	
	public int retrieveSubMenuYn(HashMap<String, String> input);
	
	public Map <String, Object> retrieveThirdMenuUrl(HashMap<String, String> input);
	
	public Map <String, Object> retrieveSubMenuUrl(HashMap<String, String> input);

}
