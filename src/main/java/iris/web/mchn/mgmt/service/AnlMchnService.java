package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AnlMchnService {

	/* 분석기기 리스트 조회 */
	List<Map<String, Object>> retrieveAnlMchnSearchList(HashMap<String, Object> input);

	/* 분석기기 등록  */
	void saveMachineInfo(HashMap<String, Object> input);

	/* 고정자산 조회  */
	List<Map<String, Object>> retrieveFxaInfoSearchList(HashMap<String, Object> input);

	/* 고정자산등록 여부 조회*/
	int retrieveFxaInfoCnt(HashMap<String, Object> input);

	/* 분석기기 상세조회 */
	HashMap<String, Object> retrieveAnlMchnSearchDtl(HashMap<String, Object> input);

	/* 전체기기 관리 조회*/
	List<Map<String, Object>> retrieveAnlMchnAllSearchList(HashMap<String, Object> input);

}
