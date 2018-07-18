package iris.web.fxa.rlisCrgrAnl.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("fxaRlisCrgrAnlService")
public class FxaRlisCrgrAnlServiceImpl implements FxaRlisCrgrAnlService{

	static final Logger LOGGER = LogManager.getLogger(FxaRlisCrgrAnlServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;


	/**
	 * 자산담당자 목록 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@Override
	public List<Map<String, Object>> retrieveFxaRlisCrgrAnlSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaRlisCrgrAnl.retrieveFxaRlisCrgrAnlSearchList", input);
		return resultList;
	}
	
	/**
	 * 자산담당자 등록
	 * @param crgrList
	 */
	public void insertCrgrInfo(List<Map<String, Object>> crgrList, List<Map<String, Object>> rfpList)  throws Exception{
		//프로젝트별 담당자 삭제
		commonDao.batchDelete("fxaInfo.fxaRlisCrgrAnl.deletetCrgrInfo", crgrList);
		
		//자산실사 담당자 등록
		if(commonDao.batchInsert("fxaInfo.fxaRlisCrgrAnl.insertCrgrInfo", crgrList) == 0){
			throw new Exception("담당자등록 오류");
		}
		//자산실사 통보자 등록
		try{
			commonDao.batchInsert("fxaInfo.fxaRlisCrgrAnl.insertRfpInfo", rfpList); 
		}catch(Exception e){
			throw new Exception("통보자등록 오류");
		}
	}
	
}
