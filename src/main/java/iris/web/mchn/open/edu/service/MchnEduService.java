package iris.web.mchn.open.edu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MchnEduService {

	/**
	 *  open기기 > 기기교육 > 기기교육목록조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveMchnEduSearchList(HashMap<String, Object> input);

	/**
	 * open기기 > 기기교육 > 기기교육상세화면
	 * @param input
	 * @return
	 */
	Map<String, Object> retrieveEduInfo(HashMap<String, Object> input);

	/**
	 *open기기 > 기기교육 > 기기교육신청 등록 
	 * @param input
	 * @return
	 */
	void insertEduInfoDetail(HashMap<String, Object> input);

	/* open기기 > 기기교육 > 기기교육 신청 건수 체크*/
	int retrieveEduInfoCnt(HashMap<String, Object> input);

	/**
	 *open기기 > 기기교육 > 기기교육신청 취소 
	 * @param input
	 * @return
	 */
	void updateEduCancel(HashMap<String, Object> input);

}
