package iris.web.mchn.open.appr.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MchnApprService {


	/**
	 *  분석기기 > open기기 > 보유기기관리 목록조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveMchnApprSearchList(HashMap<String, Object> input);

	/**
	 *  보유기기관리상세 화면(예약)
	 * @param input
	 * @return
	 */
	HashMap<String, Object> retrieveMchnApprInfo(HashMap<String, Object> input);

	/**
	 *  보유기기관리 승인, 반려 업데이트
	 * @param input
	 * @return
	 */
	void updateMachineApprInfo(HashMap<String, Object> input)  throws Exception;
	
}
