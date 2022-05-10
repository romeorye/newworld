package iris.web.prj.grs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface GrsMngService {
	List<Map<String, Object>> selectListGrsMngList(HashMap<String, Object> input);

	Map<String, Object> selectGrsMngInfo(HashMap<String, Object> input);

	void updateGrsInfo(Map<String, Object> input);

	Map<String, Object> saveGrsInfo(HashMap<String, Object> input);

	Map<String, String> evGrs(HashMap<String, Object> input, List<Map<String, Object>> dsLst, HashMap<String, Object> dtlDs);

	void deleteGrsInfo(Map<String, Object> input);

	void updateGrsReqInfo(Map<String, Object> input);

	void updateDefTssSt(HashMap<String, Object> input);

	void moveDefGrsDefInfo(HashMap<String, Object> input);

	void deleteDefGrsDefInfo(HashMap<String, Object> input);

	String isBeforGrs(HashMap<String, Object> input);

	List<Map<String, Object>> retrieveGrsApproval(HashMap<String, Object> input);

	void updateApprGuid(HashMap<String, Object> input);

	String getGuid(HashMap<String, Object> input);

	String reqGrsApproval(HashMap<String, Object> input) throws Exception;

	//**************************   GRS 개선 **********************************************************//
	/**
	 * 신규 과제 등록
	 * @param ds
	 */
	void saveTssInfo(Map<String, Object> ds) throws Exception;

	/**
	 * GRS 정보 조회
	 * @param input
	 * @return
	 */
	Map<String, Object> retrievveGrsInfo(HashMap<String, Object> input);

	/**
	 * GRS평가 임시저장
	 * @param dsMap
	 */
	void saveTmpGrsEvRsltInfo(Map<String, Object> dsMap) throws Exception;

	/**
	 * GRS평가 저장
	 */
	void saveGrsEvRsltInfo(Map<String, Object> dsMap) throws Exception;

	/**
	 * GRS 결재번호 업데이트
	 * @param appList
	 */
	void updateGrsGuid(List<Map<String, Object>> appList);

	String retrieveGrsUserChk(HashMap<String, String> input);
}
