package iris.web.fxa.rlisCrgrAnl.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FxaRlisCrgrAnlService {


	/**
	 * 자산담당자 목록 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaRlisCrgrAnlSearchList(HashMap<String, Object> input);
	
	/**
	 * 자산담당자 등록
	 * @param crgrList
	 */
	void insertCrgrInfo(List<Map<String, Object>> crgrList,  List<Map<String, Object>> rfpList) throws Exception;

}
