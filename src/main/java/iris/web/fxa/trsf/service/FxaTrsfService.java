package iris.web.fxa.trsf.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FxaTrsfService {

	/**
	 * 자산이관 목록 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaTrsfSearchList(HashMap<String, Object> input);

	/**
	 * 자산관리 > 이관 정보 저장
	 * @param trsfList
	 * */
	String insertFxaTrsfInfo(List<Map<String, Object>> trsfList, HashMap<String, Object> input) throws Exception;

	/**
	 * 자산관리 > 자산이관 목록 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveFxaTrsfPopList(HashMap<String, Object> input);
	 

	/**
	 * 자산관리 > 이관 정보 저장 정보 -> ERP 전달
	 * @param input
	 * @throws JCoException 
	Map fxaInfoTrsfErpIF(HashMap<String, Object> input) throws JCoException;
	 */

}
