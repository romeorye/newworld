package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("mchnMgmtService")
public class MchnMgmtServiceImpl implements MchnMgmtService{

	static final Logger LOGGER = LogManager.getLogger(AnlMchnServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 기기관린 리스트 조회 */
	public List<Map<String, Object>> retrieveMchnMgmtSearchList(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("mgmt.mchnMgmt.retrieveMchnMgmtSearchList", input);
	    return resultList;
	}

	/* 관리 > 분석기기 > 기기관리 조회 > 신규 및수정 팝업Detail 조회*/
	public HashMap<String, Object> retrieveMchnMgmtInfoSearch(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("mgmt.mchnMgmt.retrieveMchnMgmtInfoSearch", input);
		return result;
	}

	/* 관리 > 분석기기 > 기기관리 조회 > 신규 등록 및 수정*/
	public void saveMachineMgmtInfo(HashMap<String, Object> input) throws Exception{
		 
		if( commonDao.update("mgmt.mchnMgmt.saveMachineMgmtInfo", input) > 0 ){
			commonDao.update("mgmt.mchnMgmt.updateMachineInfo", input); 
		}else{
			
		}
		 
	}

}
