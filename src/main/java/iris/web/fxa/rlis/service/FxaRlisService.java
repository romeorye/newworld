package iris.web.fxa.rlis.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FxaRlisService {

	/**
	 * 자산실사> 실사명 combo리스트 조회
	 * @param input
	 * @return
	 */
	List retrieveFxaRlisTitlCombo(String nvl);

	/**
	 * 자산실사 목록 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaRlisSearchList(HashMap<String, Object> input);

	/**
	 *  자산실사 To_do 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaRlisTodoList(HashMap<String, Object> input);

	/**
	 *  자산실사 To_do 저장
	 * @param input
	 * @return
	 */
	void saveFxaRlisTodoInfo(List<Map<String, Object>> inputList);

	/**
	 *  자산실사 To_do 결재저장
	 * @param input
	 * @return
	 */
	void saveFxaRlisTodoApprInfo(List<Map<String, Object>> inputList, HashMap<String, Object> input) throws Exception;

}
