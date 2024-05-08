package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : PrjRsstPduInfoService.java
 * DESC : 프로젝트 - 연구팀(Project) - 산출물(Pdu) Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.10  IRIS04	최초생성     
 *********************************************************************************/

public interface PrjRsstPduInfoService {

	/* 산출물 리스트 조회 */
	List<Map<String, Object>> retrievePrjRsstPduSearchInfo(HashMap<String, Object> input);
	
	/* 산출물 삭제 */
	void deletePrjRsstPduInfo(Map<String, Object> input);
	
	/* 산출물 입력, 업데이트 */
	void insertPrjRsstPduInfo(Map<String, Object> input);
	
}