package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : TechnologyService.java 
 * DESC : 지식관리 - 시장기술정보관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.08  			최초생성                 
 *********************************************************************************/

public interface TechnologyService {

	List<Map<String, Object>> getTechnologyList(HashMap<String, Object> input);

	Map<String, Object> getTechnologyInfo(HashMap<String, Object> input);
	
	void insertTechnologyInfo(Map<String, Object> input);
	
	void deleteTechnologyInfo(HashMap<String, String> input);
	
	void updateTechnologyRtrvCnt(HashMap<String, String> input);
	
	//void updatePubNoticeUgyYn(Map<String, Object> input);

}