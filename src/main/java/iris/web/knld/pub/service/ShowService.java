package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : ShowService.java 
 * DESC : 지식관리 - 전시회관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.13  			최초생성                 
 *********************************************************************************/

public interface ShowService {

	List<Map<String, Object>> getShowList(HashMap<String, Object> input);

	Map<String, Object> getShowInfo(HashMap<String, Object> input);
	
	void insertShowInfo(Map<String, Object> input);
	
	void deleteShowInfo(HashMap<String, String> input);
	
	void updateShowRtrvCnt(HashMap<String, String> input);

}