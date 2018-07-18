package iris.web.knld.qna.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : GeneralQnaService.java
 * DESC : 지식관리 - 일반QnA관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.18  			최초생성
 *********************************************************************************/

public interface GeneralQnaService {

	List<Map<String, Object>> getGeneralQnaList(HashMap<String, Object> input);

	Map<String, Object> getGeneralQnaInfo(HashMap<String, Object> input);

	void insertGeneralQnaInfo(Map<String, Object> input);

	void deleteGeneralQnaInfo(HashMap<String, String> input);

	void updateGeneralQnaRtrvCnt(HashMap<String, String> input);

	/*덧글*/
	List<Map<String, Object>> getGeneralQnaRebList(HashMap<String, Object> input);

	void insertGeneralQnaRebInfo(Map<String, Object> input);

	void updateGeneralQnaRebInfo(List<Map<String, Object>> list);

	void deleteGeneralQnaRebInfo(HashMap<String, String> input);
}