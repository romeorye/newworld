package iris.web.prs.purStts.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PurSttsService {


	/**
	 *  구매요청현황 리스트 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrievePurSttsList(HashMap<String, Object> input);
	
	
	
	
	
	
	
	
}
