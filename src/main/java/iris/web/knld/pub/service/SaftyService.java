package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : SaftyService.java 
 * DESC : 지식관리 - 안전환경보건관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.14  			최초생성                 
 *********************************************************************************/

public interface SaftyService {

	List<Map<String, Object>> getSaftyList(HashMap<String, Object> input);

	Map<String, Object> getSaftyInfo(HashMap<String, Object> input);
	
	void insertSaftyInfo(Map<String, Object> input);
	
	void deleteSaftyInfo(HashMap<String, String> input);
	
	void updateSaftyRtrvCnt(HashMap<String, String> input);

}