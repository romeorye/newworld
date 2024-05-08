package iris.web.fxa.rlisAnl.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FxaRlisAnlService {

	/**
	 * 자산실기간관리 목록 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaRlisAnlSearchList(HashMap<String, Object> input);

	/**
	 * 자산실기간관리 신규등록
	 * @param input
	 */
	void saveFxaRlisAnlInfo(HashMap<String, Object> input) throws Exception;

	/**
	 * 자산 담당자 정보 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaRlisCrgrList(HashMap<String, Object> input);

	/**
	 * 실사할 자신건수 있는지 체크
	 * @param input
	 * @return
	 */
	int retrieveFxaCnt(HashMap<String, Object> input);

	/**
	 * 실사정보 저장
	 * @param input
	 */
	void insertFxaRlisList(HashMap<String, Object> input);

	/**
	 * 실사기간과 자산매핑
	 * @param input
	 */
	void insertFxaRlisMapp(HashMap<String, Object> input);

	/**
	 * to_do 정보
	 * @param input
	 */
	void insertFxaRlisTodo(HashMap<String, Object> input);

	/**
	 * 실사건이 없을 경우 삭제
	 * @param input
	 */
	void deleteFxaRlisTrmInfo(HashMap<String, Object> input);

	/**
	 * 실사기간 관리 팝업 정보조회
	 * @param input
	 */
	HashMap<String, Object> retrieveFxaRlisAnlInfo(HashMap<String, Object> input);

}
