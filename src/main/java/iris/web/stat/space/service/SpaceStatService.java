package iris.web.stat.space.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SpaceStatService {

	//연도조회
	List<Map<String, Object>> retrieveSpaceYyList(HashMap<String, Object> input);

	//담당자별통계 조회
	List<Map<String, Object>> getSpaceBzdvStatList(HashMap<String, Object> input);

	//평가업무현황 조회
	List<Map<String, Object>> getSpaceEvAffrSttsList(HashMap<String, Object> input);

	//분석목적별통계 조회
	List<Map<String, Object>> getSpaceAnlStatList(HashMap<String, Object> input);

	//사업부별통계 조회
	List<Map<String, Object>> getSpaceCrgrStatList(HashMap<String, Object> input);

}
