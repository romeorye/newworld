package iris.web.anl.bbs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : AnlBbsService.java
 * DESC : 분석의뢰관리 - 분석자료실관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.27  			최초생성
 *********************************************************************************/

public interface AnlBbsService {

	List<Map<String, Object>> getAnlBbsList(HashMap<String, Object> input);
	
	List<Map<String, Object>> getAnlBbsList2(HashMap<String, Object> input);

	Map<String, Object> getAnlBbsInfo(HashMap<String, Object> input);

	void insertAnlBbsInfo(Map<String, Object> input);

	void deleteAnlBbsInfo(HashMap<String, String> input);

	void updateAnlBbsRtrvCnt(HashMap<String, String> input);

	List<Map<String, Object>> getAnlQnaList(HashMap<String, Object> input);

	/*덧글*/
	List<Map<String, Object>> getAnlQnaRebList(HashMap<String, Object> input);

	void insertAnlQnaRebInfo(Map<String, Object> input);

	void updateAnlQnaRebInfo(List<Map<String, Object>> list);

	void deleteAnlQnaRebInfo(HashMap<String, String> input);
	
	public List<Map<String, Object>> anlBbsCodeList(HashMap<String, String> input);

}