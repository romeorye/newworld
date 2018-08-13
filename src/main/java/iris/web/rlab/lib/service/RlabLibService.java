package iris.web.rlab.lib.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : RlabLibService.java
 * DESC : 분석의뢰관리 - 분석자료실관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.27  			최초생성
 *********************************************************************************/

public interface RlabLibService {

	List<Map<String, Object>> getRlabLibList(HashMap<String, Object> input);

	Map<String, Object> getRlabLibInfo(HashMap<String, Object> input);

	void insertRlabLibInfo(Map<String, Object> input);

	void deleteRlabLibInfo(HashMap<String, String> input);

	void updateRlabLibRtrvCnt(HashMap<String, String> input);

	List<Map<String, Object>> getRlabQnaList(HashMap<String, Object> input);

	/*덧글*/
	List<Map<String, Object>> getRlabQnaRebList(HashMap<String, Object> input);

	void insertRlabQnaRebInfo(Map<String, Object> input);

	void updateRlabQnaRebInfo(List<Map<String, Object>> list);

	void deleteRlabQnaRebInfo(HashMap<String, String> input);
	
	public List<Map<String, Object>> rlabBbsCodeList(HashMap<String, String> input);
	

}