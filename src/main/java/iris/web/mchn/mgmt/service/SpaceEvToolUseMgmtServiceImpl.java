package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("spaceEvToolUseMgmtService")
public class SpaceEvToolUseMgmtServiceImpl  implements SpaceEvToolUseMgmtService{

	static final Logger LOGGER = LogManager.getLogger(AnlMchnServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;


	/* 공간평가 Tool사용관리 리스트 조회 */
	@Override
	public List<Map<String, Object>> spaceEvToolUseMgmtSearchList(HashMap<String, Object> input) {
		
		List<Map<String, Object>> resultList = commonDao.selectList("mgmt.spaceEvToolUseMgmt.spaceEvToolUseMgmtSearchList", input);
	    return resultList;
	}





}
