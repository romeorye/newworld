package iris.web.stat.space.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SpaceStatService {

	//연도조회
	List<Map<String, Object>> retrieveSpaceYyList(HashMap<String, Object> input);

	//담당자별통계 조회
	List<Map<String, Object>> getSpaceBzdvStatList(HashMap<String, Object> input);
}
