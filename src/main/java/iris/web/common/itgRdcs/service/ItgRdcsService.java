package iris.web.common.itgRdcs.service;

import java.util.HashMap;

public interface ItgRdcsService {

	/**
	 * 전자결재 정보 저장
	 * @param input
	 */
	boolean saveItgRdcsInfo(HashMap<String, Object> input) throws Exception;
}