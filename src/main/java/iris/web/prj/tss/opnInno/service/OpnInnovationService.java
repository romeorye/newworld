package iris.web.prj.tss.opnInno.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface OpnInnovationService {

	/**
	 *  open innovation 협력과제 관리 리스트조회
	 */
	List<Map<String, Object>> retrieveOpnInnoSearchList(HashMap<String, Object> input);

	/**
	 *  open innovation 협력과제 정보 등록(수정) 정보 조회
	 */
	Map<String, Object> retrieveOpnInnoInfo(HashMap<String, Object> input);

	/**
	 *  open innovation 협력과제 정보 저장
	 */
	void saveOpnInnoInfo(Map<String, Object> saveDataSet);

	/**
	 *  open innovation 협력과제 정보 삭제
	 */
	void deleteOpnInnoInfo(HashMap<String, Object> input);
	
	
	
	

}
