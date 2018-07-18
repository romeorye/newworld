package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MchnMgmtService {

	/* 기기관리 목록 조회*/
	List<Map<String, Object>> retrieveMchnMgmtSearchList(HashMap<String, Object> input);

	/* 관리 > 분석기기 > 기기관리 조회 > 신규 등록 및 수정 팝업조회 */
	HashMap<String, Object> retrieveMchnMgmtInfoSearch(HashMap<String, Object> input);

	/* 관리 > 분석기기 > 기기관리 조회 > 신규 등록 및 수정 */
	void saveMachineMgmtInfo(HashMap<String, Object> input) throws Exception;

}
