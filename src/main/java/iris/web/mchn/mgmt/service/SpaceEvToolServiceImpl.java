package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("spaceEvToolService")
public class SpaceEvToolServiceImpl  implements SpaceEvToolService{

	static final Logger LOGGER = LogManager.getLogger(SpaceEvToolServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;


	/* 공간평가Tool 리스트 조회 */
	public List<Map<String, Object>> retrieveSpaceEvToolSearchList(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("mgmt.spaceEvTool.retrieveSpaceEvToolSearchList", input);
	    return resultList;
	}
	
	/* 공간평가Tool 상세조회*/
	public HashMap<String, Object> retrieveSpaceEvToolSearchDtl(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("mgmt.spaceEvTool.retrieveSpaceEvToolSearchDtl", input);
		return result;
	}
	
	/* 공간평가Tool 등록  */
	public void saveSpaceEvToolInfo(HashMap<String, Object> input){
		commonDao.insert("mgmt.spaceEvTool.saveSpaceEvToolInfo", input);
	}
}
