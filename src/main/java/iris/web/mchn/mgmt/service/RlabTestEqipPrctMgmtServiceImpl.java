package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("rlabTestEqipPrctMgmtService")
public class RlabTestEqipPrctMgmtServiceImpl  implements RlabTestEqipPrctMgmtService{

	static final Logger LOGGER = LogManager.getLogger(RlabTestEqipPrctMgmtServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;


	/* 신뢰성장비 예약관리 리스트 조회 */
	public List<Map<String, Object>> rlabTestEqipPrctMgmtList(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("mgmt.rlabTestEqipPrctMgmt.retrieveRlabTestEqipPrctMgmtList", input);
	    return resultList;
	}
	
	/**
	 *  신뢰성시험장비 예약관리리스트 상세조회 (예약)
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveRlabTestEqipPrctDtl(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("mgmt.rlabTestEqipPrctMgmt.retrieveRlabTestEqipPrctDtl", input);
	    return result;
	}	
}
