package iris.web.anl.lib.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : AnlLibService.java
 * DESC : 분석의뢰관리 - 분석자료실관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.27  			최초생성
 *********************************************************************************/

public interface AnlLibService {

	List<Map<String, Object>> getAnlLibList(HashMap<String, Object> input);

	Map<String, Object> getAnlLibInfo(HashMap<String, Object> input);

	void insertAnlLibInfo(Map<String, Object> input);

	void deleteAnlLibInfo(HashMap<String, String> input);

	void updateAnlLibRtrvCnt(HashMap<String, String> input);

	List<Map<String, Object>> getAnlQnaList(HashMap<String, Object> input);

	/*덧글*/
	List<Map<String, Object>> getAnlQnaRebList(HashMap<String, Object> input);

	void insertAnlQnaRebInfo(Map<String, Object> input);

	void updateAnlQnaRebInfo(List<Map<String, Object>> list);

	void deleteAnlQnaRebInfo(HashMap<String, String> input);

}