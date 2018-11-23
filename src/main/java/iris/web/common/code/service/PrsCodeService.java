package iris.web.common.code.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PrsCodeService {

	List<Map<String, Object>> retrieveEkgrpInfo(HashMap<String, Object> input);

	List<Map<String, Object>> retrieveWbsCdInfoList(HashMap<String, Object> input);

}
