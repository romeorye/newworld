package iris.web.prj.tss.itg.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TssItgRdcsService {

	List<Map<String, Object>> retrieveTssItgRdcsList(HashMap<String, Object> input);
}
