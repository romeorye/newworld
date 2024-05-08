package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : ManualService.java 
 * DESC : 지식관리 - 규정/업무Manual관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.14  			최초생성                 
 *********************************************************************************/

public interface ManualService {

	List<Map<String, Object>> getManualList(HashMap<String, Object> input);

	Map<String, Object> getManualInfo(HashMap<String, Object> input);
	
	void insertManualInfo(Map<String, Object> input);
	
	void deleteManualInfo(HashMap<String, String> input);
	
	void updateManualRtrvCnt(HashMap<String, String> input);

}