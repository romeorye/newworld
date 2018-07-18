package iris.web.fxa.dsu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FxaDsuService {

	/**
	 * 자산폐기 목록 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaDsuSearchList(HashMap<String, Object> input);

}
