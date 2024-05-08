package iris.web.knld.leasHousMgmt.service;

import java.util.HashMap;
import java.util.Map;

public interface LeasHousMgmtService {

	/**
     * 임차주택관리 > 필수첨부파일 리스트 조회
     *
     * @return ModelAndView
     * */
	Map<String, Object> retrieveAttchFilInfo(HashMap<String, Object> input);

	/**
     * 임차주택관리 > 필수첨부파일 저장
     *
     * @return ModelAndView
     * */
	void saveAttchFil(Map<String, Object> map) throws Exception;

}
