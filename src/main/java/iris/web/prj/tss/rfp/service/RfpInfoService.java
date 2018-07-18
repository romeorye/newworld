package iris.web.prj.tss.rfp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RfpInfoService {

	/**
     * 연구과제 > RFP요청서 > 요청서 목록 조회
     * */
	List<Map<String, Object>> retrieveRfpSearchList(HashMap<String, Object> input);

	/**
     * 연구과제 > RFP요청서 > 요청서 조회
     * */
	Map<String, Object> retrieveRfpInfo(HashMap<String, Object> input);

	/**
     * 연구과제 > RFP요청서 > 요청서 등록 및 수정
     * */
	void saveRfpInfo(Map<String, Object> saveDataSet);

	/**
     * 연구과제 > RFP요청서 > 요청서삭제
     * */
	void deleteRfpInfo(HashMap<String, Object> input);
	
	/**
	 * 연구과제 > RFP요청서 > 요청서 제출하기
	 * */
	void submitRfpInfo(HashMap<String, Object> input);
}
