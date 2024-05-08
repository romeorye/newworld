package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RlabTestEqipService {

	/* 신뢰성시험 장비 리스트 조회 */
	List<Map<String, Object>> rlabTestEqipSearchList(HashMap<String, Object> input);

	/* 신뢰성시험 장비 등록  */
	void saveRlabTestEqip(HashMap<String, Object> input);
	
	/* 분석기기 상세조회 */
	HashMap<String, Object> rlabTestEqipSearchDtl(HashMap<String, Object> input);

}
