package iris.web.prj.mgmt.wbsStd.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface WbsStdService {
/**
 * 목록
 * @param input
 * @return
 */
	List<Map<String, Object>> retrieveWbsStdList(HashMap<String, Object> input) ;
/**
 * 상세	
 * @param input
 * @return
 */
	List<Map<String, Object>> retrieveWbsStdDtl(HashMap<String, Object> input);


			
}
