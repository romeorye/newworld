package iris.web.mchn.open.spaceMchn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SpaceMchnInfoService {

	/**
	 * 보유기기 리스트 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveMchnInfoSearchList(HashMap<String, Object> input);

	/**
	 * 보유기기 Detail 화면 조회
	 * @param input
	 * @return
	 */
	HashMap<String, Object> retrieveMchnInfoDtl(HashMap<String, Object> input) throws Exception;

	/**
	 * 보유기기 예약 신규 및 Detail 화면조회 
	 * @param input
	 * @return
	 */
	HashMap<String, Object> retrieveMchnPrctInfo(HashMap<String, Object> input)  throws Exception;

	//calender 일정 조회
	List<Map<String, Object>> retrieveMchnPrctCalInfo(HashMap<String, Object> input);
	
	/**
	 * 보유기기 예약 신규 및 수정
	 * @param input
	 * @return
	 * @throws Exception 
	 */
	void saveMchnPrctInfo(HashMap<String, Object> input)  throws Exception;

	/**
	 * 보유기기 예약 삭제
	 * @param input
	 * @return
	 * @throws Exception 
	 */
	void deleteMchnPrctInfo(HashMap<String, Object> input);

}
