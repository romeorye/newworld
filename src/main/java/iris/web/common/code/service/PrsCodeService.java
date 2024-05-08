package iris.web.common.code.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PrsCodeService {

	List<Map<String, Object>> retrieveEkgrpInfo(HashMap<String, Object> input);

	List<Map<String, Object>> retrieveWbsCdInfoList(HashMap<String, Object> input);
	
	List<Map<String, Object>> retrieveMeinsInfo(HashMap<String, Object> input);

	Map<String, Object> retrieveSaktoInfoList(HashMap<String, Object> input);

	List retrieveWerksInfo(HashMap<String, Object> input);
	
	List<Map<String, Object>> retrieveItemGubunInfo(HashMap<String, Object> input);
	
	List<Map<String, Object>> retrieveScodeInfo(HashMap<String, Object> input);

	List<Map<String, Object>> retrievePrsFlagInfo(HashMap<String, Object> input);

	List<Map<String, Object>> retrieveWaersInfo(HashMap<String, Object> input);
}
