package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("anlMchnService")
public class AnlMchnServiceImpl  implements AnlMchnService{

	static final Logger LOGGER = LogManager.getLogger(AnlMchnServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;


	/* 분석기기 리스트 조회 */
	public List<Map<String, Object>> retrieveAnlMchnSearchList(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("mgmt.anlMchn.retrieveAnlMchnSearchList", input);
	    return resultList;
	}

	/* 분석기기 등록  */
	public void saveMachineInfo(HashMap<String, Object> input){
		commonDao.insert("mgmt.anlMchn.saveMachineInfo", input);
	}

	/* 고정자산 조회 등록  */
	public List<Map<String, Object>> retrieveFxaInfoSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("mgmt.anlMchn.retrieveFxaInfoSearchList", input);
		return resultList;
	}

	/* 고정자산 조회 등록  */
	public int retrieveFxaInfoCnt(HashMap<String, Object> input){
		return commonDao.select("mgmt.anlMchn.retrieveFxaInfoCnt", input);
	}

	/* 분석기기 상세조회*/
	public HashMap<String, Object> retrieveAnlMchnSearchDtl(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("mgmt.anlMchn.retrieveAnlMchnSearchDtl", input);
		return result;
	}

	/* 전체기기 관리 조회*/
	public List<Map<String, Object>> retrieveAnlMchnAllSearchList(HashMap<String, Object> input){
		return commonDao.selectList("mgmt.anlMchn.retrieveAnlMchnAllSearchList", input);
	}
}
