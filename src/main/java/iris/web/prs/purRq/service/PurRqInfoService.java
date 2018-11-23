package iris.web.prs.purRq.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PurRqInfoService {

	List<Map<String, Object>> retrievePurRqList(HashMap<String, Object> input);

}
