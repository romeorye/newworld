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
 * NAME : ShowServiceImpl.java 
 * DESC : 지식관리 - 전시회관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.13  			최초생성               
 *********************************************************************************/

@Service("showService")
public class ShowServiceImpl implements ShowService {
	
	static final Logger LOGGER = LogManager.getLogger(ShowServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getShowList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getShowList", input);
	}

	public Map<String, Object> getShowInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getShowInfo", input);
	}

	/* 전시회 입력&업데이트 */
	@Override
	public void insertShowInfo(Map<String, Object> input) {
		String showId = NullUtil.nvl(input.get("showId"), "");

		if("".equals(showId)) {
			commonDao.insert("knld.pub.insertShowInfo", input);
		}else {
			commonDao.update("knld.pub.updateShowInfo", input);
		}
	}
	
	/* 전시회 삭제  */
	@Override
	public void deleteShowInfo(HashMap<String, String> input) {
		String showId = NullUtil.nvl(input.get("showId"), "");
		LOGGER.debug("###########showId################"+showId);
		commonDao.update("knld.pub.deleteShowInfo", input);
	}
	
	/* 전시회 조회건수 증가  */
	@Override
	public void updateShowRtrvCnt(HashMap<String, String> input) {
		String showId = NullUtil.nvl(input.get("showId"), "");
		LOGGER.debug("###########showId################"+showId);
		commonDao.update("knld.pub.updateShowRtrvCnt", input);
	}
	
}