package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SpaceEvToolUseMgmtService {

	/* 공간평가 Tool 사용관리 리스트 조회 */
	List<Map<String, Object>> spaceEvToolUseMgmtSearchList(HashMap<String, Object> input);
}
