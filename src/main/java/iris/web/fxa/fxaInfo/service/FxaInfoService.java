package iris.web.fxa.fxaInfo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FxaInfoService {

	/**
	 *  연구팀 > 프로젝트 > 고정자산 목록 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrievePrjFxaSearchInfo(HashMap<String, Object> input);

	/**
	 *  고정자산 상세 조회
	 * @param input
	 * @return
	 */
	Map<String, Object> retrieveFxaDtlSearchInfo(HashMap<String, Object> input);

	/**
	 *  자산이관 목록 > 등록자 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrievePrjUserSearch(HashMap<String, Object> input);

}
