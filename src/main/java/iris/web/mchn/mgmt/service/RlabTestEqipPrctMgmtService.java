package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RlabTestEqipPrctMgmtService {

	/* 신뢰성시험장비 예약관리리스트 조회 */
	List<Map<String, Object>> rlabTestEqipPrctMgmtList(HashMap<String, Object> input);
	
	/**
	 *  신뢰성시험장비 예약관리리스트 상세조회 (예약)
	 * @param input
	 * @return
	 */
	HashMap<String, Object> retrieveRlabTestEqipPrctDtl(HashMap<String, Object> input);
	
	/**
	 *  신뢰성장비 예약관리 승인, 반려 업데이트
	 * @param input
	 * @return
	 */
	void updateRlabTestEqipPrctInfo(HashMap<String, Object> input)  throws Exception;

}
