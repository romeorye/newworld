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
 * NAME : PatentServiceImpl.java 
 * DESC : 지식관리 - 특허관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.13  			최초생성               
 *********************************************************************************/

@Service("patentService")
public class PatentServiceImpl implements PatentService {
	
	static final Logger LOGGER = LogManager.getLogger(PatentServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getPatentList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getPatentList", input);
	}

	public Map<String, Object> getPatentInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getPatentInfo", input);
	}

	/* 특허 입력&업데이트 */
	@Override
	public void insertPatentInfo(Map<String, Object> input) {
		String patentId = NullUtil.nvl(input.get("patentId"), "");

		if("".equals(patentId)) {
			commonDao.insert("knld.pub.insertPatentInfo", input);
		}else {
			commonDao.update("knld.pub.updatePatentInfo", input);
		}
	}
	
	/* 특허 삭제  */
	@Override
	public void deletePatentInfo(HashMap<String, String> input) {
		String patentId = NullUtil.nvl(input.get("patentId"), "");
		LOGGER.debug("###########patentId################"+patentId);
		commonDao.update("knld.pub.deletePatentInfo", input);
	}
	
	/* 특허 조회건수 증가  */
	@Override
	public void updatePatentRtrvCnt(HashMap<String, String> input) {
		String patentId = NullUtil.nvl(input.get("patentId"), "");
		LOGGER.debug("###########patentId################"+patentId);
		commonDao.update("knld.pub.updatePatentRtrvCnt", input);
	}
	
}