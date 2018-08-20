package iris.web.prj.grs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface GrsMngService {
	List<Map<String, Object>> selectListGrsMngList(HashMap<String, Object> input);

	int updateGrsInfo(Map<String, Object> input);

	int deleteGrsInfo(Map<String, Object> input);
}
