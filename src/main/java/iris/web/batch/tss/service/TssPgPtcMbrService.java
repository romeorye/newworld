package iris.web.batch.tss.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TssPgPtcMbrService {

	List<Map<String, Object>> retrieveTssPgMgr();

	void updateTssPgMgr( HashMap<String, Object> input);

}
