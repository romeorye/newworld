package iris.web.knld.pub.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager; 
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;

/*********************************************************************************
 * NAME : SaftyServiceImpl.java 
 * DESC : 지식관리 - 안전환경보건관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.14  			최초생성               
 *********************************************************************************/

@Service("saftyService")
public class SaftyServiceImpl implements SaftyService {
	
	static final Logger LOGGER = LogManager.getLogger(SaftyServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getSaftyList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getSaftyList", input);
	}

	public Map<String, Object> getSaftyInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getSaftyInfo", input);
	}

	/* 안전환경보건 입력&업데이트 */
	@Override
	public void insertSaftyInfo(Map<String, Object> input) {
		String saftyId = NullUtil.nvl(input.get("saftyId"), "");

		if("".equals(saftyId)) {
			commonDao.insert("knld.pub.insertSaftyInfo", input);
		}else {
			commonDao.update("knld.pub.updateSaftyInfo", input);
		}
	}
	
	/* 안전환경보건 삭제  */
	@Override
	public void deleteSaftyInfo(HashMap<String, String> input) {
		String saftyId = NullUtil.nvl(input.get("saftyId"), "");
		LOGGER.debug("###########saftyId################"+saftyId);
		commonDao.update("knld.pub.deleteSaftyInfo", input);
	}
	
	/* 안전환경보건 조회건수 증가  */
	@Override
	public void updateSaftyRtrvCnt(HashMap<String, String> input) {
		String saftyId = NullUtil.nvl(input.get("saftyId"), "");
		LOGGER.debug("###########saftyId################"+saftyId);
		commonDao.update("knld.pub.updateSaftyRtrvCnt", input);
	}
	
}