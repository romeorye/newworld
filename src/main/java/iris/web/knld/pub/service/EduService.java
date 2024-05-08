package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : EduService.java 
 * DESC : 지식관리 - 교육세미나관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.12  			최초생성                 
 *********************************************************************************/

public interface EduService {

	List<Map<String, Object>> getEduList(HashMap<String, Object> input);

	Map<String, Object> getEduInfo(HashMap<String, Object> input);
	
	void insertEduInfo(Map<String, Object> input);
	
	void deleteEduInfo(HashMap<String, String> input);
	
	void updateEduRtrvCnt(HashMap<String, String> input);
	
	//void updatePubNoticeUgyYn(Map<String, Object> input);

}