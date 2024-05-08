package iris.web.fxa.oscp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FxaOscpService {

	/**
	 * 사외자산리스트 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaOscpSearchList(HashMap<String, Object> input);

	/**
	 * 사외자산이관 정보 저장
	 * @return
	 */
	String insertFxaOscpInfo(List<Map<String, Object>> oscpList, HashMap<String, Object> input) throws Exception;

	/**
	 *  사외자산이관 팝업목록 조회
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaOscpPopList(HashMap<String, Object> input);

}
