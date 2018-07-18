package iris.web.stat.code.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ComCodeService {


	/**
	 * 통계 > 공통코드 관리 >공통코드 관리 리스트 조회
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> retrieveCcomCodeList(HashMap<String, Object> input);

	/**
	 * 통계 > 공통코드 관리 >공통코드 등록 및 수정
	 * @param input
	 * @return
	 */
	void saveCodeInfo(List<Map<String, Object>> codeList);

}
