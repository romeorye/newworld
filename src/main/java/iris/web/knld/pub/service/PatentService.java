package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : PatentService.java 
 * DESC : 지식관리 - 특허관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.13  			최초생성                 
 *********************************************************************************/

public interface PatentService {

	List<Map<String, Object>> getPatentList(HashMap<String, Object> input);

	Map<String, Object> getPatentInfo(HashMap<String, Object> input);
	
	void insertPatentInfo(Map<String, Object> input);
	
	void deletePatentInfo(HashMap<String, String> input);
	
	void updatePatentRtrvCnt(HashMap<String, String> input);

}