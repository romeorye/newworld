package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("rlabTestEqipService")
public class RlabTestEqipServiceImpl  implements RlabTestEqipService{

	static final Logger LOGGER = LogManager.getLogger(AnlMchnServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;


	/* 분석기기 리스트 조회 */
	public List<Map<String, Object>> rlabTestEqipSearchList(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("mgmt.rlabTestEqip.rlabTestEqipSearchList", input);
	    return resultList;
	}


	@Override
	public void saveRlabTestEqip(HashMap<String, Object> input) {
		commonDao.insert("mgmt.rlabTestEqip.saveRlabTestEqip", input);
		
	}


	@Override
	public HashMap<String, Object> rlabTestEqipSearchDtl(HashMap<String, Object> input) {
		HashMap<String, Object> result = commonDao.select("mgmt.rlabTestEqip.rlabTestEqipSearchDtl", input);
		return result;
	}




}
