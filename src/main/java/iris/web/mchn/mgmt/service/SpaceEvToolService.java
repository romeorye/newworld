package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SpaceEvToolService {

	/* 공간평가Tool 리스트 조회 */
	List<Map<String, Object>> retrieveSpaceEvToolSearchList(HashMap<String, Object> input);
	
	/* 공간평가Tool 상세조회 */
	HashMap<String, Object> retrieveSpaceEvToolSearchDtl(HashMap<String, Object> input);
	
	/* 공간평가Tool 등록  */
	void saveSpaceEvToolInfo(HashMap<String, Object> input);
	
}
