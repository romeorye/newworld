package iris.web.fxa.anl.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("fxaAnlService")
public class FxaAnlServiceImpl implements FxaAnlService {

	static final Logger LOGGER = LogManager.getLogger(FxaAnlServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;


	/* 고정자산 리스트 조회 */
	@Override
	public List<Map<String, Object>> retrieveFxaAnlSearchList(HashMap<String, Object> input){
		// TODO Auto-generated method stub
		List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaAnl.retrieveFxaAnlSearchList", input);
		return resultList;
	}

	/* 자산관리 삭제 */
	@Override
	public void deleteFxaInfo(HashMap<String, Object> input){
		commonDao.update("fxaInfo.fxaAnl.deleteFxaInfo", input);
	}

	/* 자산관리 저장 */
	@Override
	public void saveFxaInfo(HashMap<String, Object> input){
		commonDao.update("fxaInfo.fxaAnl.saveFxaInfo", input);
	}

	/**
	 * 자산관리 상세 조회
	 * @param input
	 * @return
	 */
	public Map<String, Object> retrieveFxaAnlSearchDtl(HashMap<String, Object> input){
		return commonDao.select("fxaInfo.fxaAnl.retrieveFxaAnlSearchDtl", input);
	}

}
