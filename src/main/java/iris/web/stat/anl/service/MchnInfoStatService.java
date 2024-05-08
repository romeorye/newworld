package iris.web.stat.anl.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MchnInfoStatService {

	/**
	 * 통계 > 분석 > OPEN기기 사용조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> mchnInfoStateList(HashMap<String, Object> input);

	
	
}
