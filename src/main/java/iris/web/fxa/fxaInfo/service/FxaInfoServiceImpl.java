package iris.web.fxa.fxaInfo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("fxaInfoService")
public class FxaInfoServiceImpl implements FxaInfoService {

	static final Logger LOGGER = LogManager.getLogger(FxaInfoServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/**
	 * 연구팀 > 프로젝트 > 고정자산 리스트 조회
	 * @param input
	 * @return
	 */
	@Override
	public List<Map<String, Object>> retrievePrjFxaSearchInfo(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaInfo.retrievePrjFxaInfo", input);
	    return resultList;
	}

	/**
	 *  고정자산 상세 조회
	 * @param input
	 * @return
	 */
	@Override
	public Map<String, Object> retrieveFxaDtlSearchInfo(HashMap<String, Object> input) {
		Map<String, Object> resultMap = commonDao.select("fxaInfo.fxaInfo.retrieveFxaDtlInfo", input);
		return resultMap;
	}


	/**
	 *  자산이관 목록 > 등록자 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrievePrjUserSearch(HashMap<String, Object> input){
		 List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaInfo.retrievePrjUserSearch", input);
		 return resultList;
	}
}

