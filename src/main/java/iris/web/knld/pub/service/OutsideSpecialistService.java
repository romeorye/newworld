package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : OutsideSpecialistService.java 
 * DESC : 지식관리 - 사외전문가관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.14  			최초생성                 
 *********************************************************************************/

public interface OutsideSpecialistService {

	List<Map<String, Object>> getOutsideSpecialistList(HashMap<String, Object> input);

	Map<String, Object> getOutsideSpecialistInfo(HashMap<String, Object> input);
	
	void insertOutsideSpecialistInfo(Map<String, Object> input);
	
	void deleteOutsideSpecialistInfo(HashMap<String, String> input);
	
	void updateOutsideSpecialistRtrvCnt(HashMap<String, String> input);

}