package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : ConferenceService.java 
 * DESC : 지식관리 - 학회컨퍼런스관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.12  			최초생성                 
 *********************************************************************************/

public interface ConferenceService {

	List<Map<String, Object>> getConferenceList(HashMap<String, Object> input);

	Map<String, Object> getConferenceInfo(HashMap<String, Object> input);
	
	void insertConferenceInfo(Map<String, Object> input);
	
	void deleteConferenceInfo(HashMap<String, String> input);
	
	void updateConferenceRtrvCnt(HashMap<String, String> input);

}