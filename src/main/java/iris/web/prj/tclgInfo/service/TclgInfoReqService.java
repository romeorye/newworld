package iris.web.prj.tclgInfo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TclgInfoReqService {

	/**
	 * 
	 * @param input
	 * @return
	 */
	HashMap<String, Object> retrievePrjInfo(HashMap<String, Object> input);

	List<Map<String, Object>> retrieveTclgInfoRqSearchList(HashMap<String, Object> input);

	void insertTclgInfoReq(HashMap<String, Object> input);

	Map<String, Object> retrieveTclgInfoDetail(HashMap<String, Object> input);
}
