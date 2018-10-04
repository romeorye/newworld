package iris.web.prj.grs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface GrsMngService {
	List<Map<String, Object>> selectListGrsMngList(HashMap<String, Object> input);

	Map<String, Object> selectGrsMngInfo(HashMap<String, Object> input);

	int updateGrsInfo(Map<String, Object> input);

	void deleteGrsInfo(Map<String, Object> input);

	void updateGrsReqInfo(Map<String, Object> input);

	void updateDefTssSt(HashMap<String,Object> input);

	void moveDefGrsDefInfo(HashMap<String,Object> input);
	void deleteDefGrsDefInfo(HashMap<String,Object> input);

	String isBeforGrs(HashMap<String,Object> input);
}
