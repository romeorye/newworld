package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : ModalityService.java 
 * DESC : 지식관리 - 표준양식관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.13  			최초생성                 
 *********************************************************************************/

public interface ModalityService {

	List<Map<String, Object>> getModalityList(HashMap<String, Object> input);

	Map<String, Object> getModalityInfo(HashMap<String, Object> input);
	
	void insertModalityInfo(Map<String, Object> input);
	
	void deleteModalityInfo(HashMap<String, String> input);
	
	void updateModalityRtrvCnt(HashMap<String, String> input);

}