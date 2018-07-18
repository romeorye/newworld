package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MchnCgdgService {

	/**
	 * 분석기기 > 관리 > 소모품 관리 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveCdgsList(HashMap<String, Object> input);

	/**
	 * 소모품 신규 및 상세 조회
	 * @param input
	 * @return
	 */
	HashMap<String, Object> retrieveCdgsMst(HashMap<String, Object> input);

	/**
	 * 소모품 정보 저장 및 수정
	 * @param input
	 * @return
	 */
	void saveCgdsMst(HashMap<String, Object> input);

	/**
	 * 소모품 정보 삭제
	 * @param input
	 * @return
	 */
	void updateCgdsMst(HashMap<String, Object> input);

	/**
	 * 소모품입출력정보 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveCdgsMgmt(HashMap<String, Object> input);

	/**
	 * 소모품 입출력 정보 조회
	 * @param input
	 * @return
	 */
	HashMap<String, Object> retrieveCgdsMgmtPopInfo(HashMap<String, Object> input);

	/**
	 * 분석기기 > 관리 > 소모품 관리 > 관리 > 소모품 입출력 > 팝업창 정보 저장 및 수정
	 * @param input
	 * @return
	 */
	void saveCgdsMgmtPopInfo(HashMap<String, Object> input);

	/**
	 * 현재고 가지고 오기
	 * @param input
	 * @return
	 */
	int retrieveTotQty(HashMap<String, Object> input);

}
