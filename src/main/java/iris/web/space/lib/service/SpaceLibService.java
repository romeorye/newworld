package iris.web.space.lib.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : SpaceLibService.java
 * DESC : 분석의뢰관리 - 분석자료실관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.27  			최초생성
 *********************************************************************************/

public interface SpaceLibService {

	List<Map<String, Object>> getSpaceLibList(HashMap<String, Object> input);

	Map<String, Object> getSpaceLibInfo(HashMap<String, Object> input);

	void insertSpaceLibInfo(Map<String, Object> input);

	void deleteSpaceLibInfo(HashMap<String, String> input);

	void updateSpaceLibRtrvCnt(HashMap<String, String> input);

	List<Map<String, Object>> getSpaceQnaList(HashMap<String, Object> input);

	/*덧글*/
	List<Map<String, Object>> getSpaceQnaRebList(HashMap<String, Object> input);

	void insertSpaceQnaRebInfo(Map<String, Object> input);

	void updateSpaceQnaRebInfo(List<Map<String, Object>> list);

	void deleteSpaceQnaRebInfo(HashMap<String, String> input);
	
	public List<Map<String, Object>> spaceBbsCodeList(HashMap<String, String> input);

}