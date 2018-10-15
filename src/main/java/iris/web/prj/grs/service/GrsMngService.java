package iris.web.prj.grs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface GrsMngService {
	List<Map<String, Object>> selectListGrsMngList(HashMap<String, Object> input);

	Map<String, Object> selectGrsMngInfo(HashMap<String, Object> input);

	int updateGrsInfo(Map<String, Object> input);

	Map<String, String> saveGrsInfo(HashMap<String, Object> input) ;

	Map<String, String> evGrs(HashMap<String, Object> input, List<Map<String, Object>>dsLst, HashMap<String, Object>dtlDs) ;


	void deleteGrsInfo(Map<String, Object> input);

	void updateGrsReqInfo(Map<String, Object> input);

	void updateDefTssSt(HashMap<String,Object> input);

	void moveDefGrsDefInfo(HashMap<String,Object> input);
	void deleteDefGrsDefInfo(HashMap<String,Object> input);

	String isBeforGrs(HashMap<String,Object> input);
	
	public List<Map<String, Object>> retrieveGrsApproval(HashMap<String, Object> input);
	
	void updateApprGuid(HashMap<String, Object> input);

    String getGuid(HashMap<String, Object> input);

    //QAS I/F

	// QAS 과제등록
	void insertToQasTssQasIF(HashMap<String, Object> input);
	// QAS gate 정보 조회
	List<Map<String, Object>> selectGateQasIF(HashMap<String, Object> input);
	// QAS gate 정보 IRIS 등록
	void insertGateToIrisQasIF(HashMap<String, Object> input);


}
