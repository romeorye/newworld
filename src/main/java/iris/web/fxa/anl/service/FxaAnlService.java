package iris.web.fxa.anl.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FxaAnlService {

	/**
	 *  고정자산 리스트 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaAnlSearchList(HashMap<String, Object> input);

	/**
	 * 자산관리 삭제
	 * @param input
	 */
	void deleteFxaInfo(HashMap<String, Object> input);

	/**
	 * 자산관리 정보 저장
	 * @param input
	 */
	void saveFxaInfo(HashMap<String, Object> input);

	/**
	 * 자산관리 상세 조회
	 * @param input
	 * @return
	 */
	Map<String, Object> retrieveFxaAnlSearchDtl(HashMap<String, Object> input);



}
