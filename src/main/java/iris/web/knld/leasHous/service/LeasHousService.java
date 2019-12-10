package iris.web.knld.leasHous.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface LeasHousService {

	/**
	 * 임차주택관리 > 임차주택관리 리스트 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveLeasHousSearchList(HashMap<String, Object> input);

	/**
	 * 임차주택관리 > 상세화면 상세조회
	 * @param input
	 * @return
	 */
	Map<String, Object> retrieveLeasHousDtlInfo(HashMap<String, Object> input);

	/**
	 * 임차주택관리 > 임차주택관리 저장
	 * @param input
	 * @throws Exception 
	 */
	String saveLeasHousInfo(Map<String, Object> leasHousInfo) throws Exception;

	/**
	 * 임차주택관리 > 임차주택관리 검토요청 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	String updateLeasHousSt(HashMap<String, Object> input) throws Exception;

	/**
	 * 임차주택관리 > 임차주택관리 검토 결과 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	void updateLeasHousPriSt(Map<String, Object> leasHousInfo) throws Exception ;

	/**
	 * 임차주택관리 > 임차주택관리 계약검토 신청 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	void updateLeasHousCnrReq(Map<String, Object> leasHousInfo) throws Exception;

	/**
	 * 임차주택관리 > 임차주택관리 계약검토 승인 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	void updateLeasHousCnrSt(Map<String, Object> leasHousInfo) throws Exception;

	
	
}
