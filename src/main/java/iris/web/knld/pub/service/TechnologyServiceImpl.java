package iris.web.knld.pub.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;

/*********************************************************************************
 * NAME : TechnologyServiceImpl.java
 * DESC : 지식관리 - 시장기술정보관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.08  			최초생성
 *********************************************************************************/

@Service("technologyService")
public class TechnologyServiceImpl implements TechnologyService {

	static final Logger LOGGER = LogManager.getLogger(TechnologyServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getTechnologyList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getTechnologyList", input);
	}

	public Map<String, Object> getTechnologyInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getTechnologyInfo", input);
	}

	/* 공지사항 입력&업데이트 */
	@Override
	public void insertTechnologyInfo(Map<String, Object> input) {
		String techId = NullUtil.nvl(input.get("techId"), "");

		if("".equals(techId)) {
			commonDao.insert("knld.pub.insertTechnologyInfo", input);
		}else {
			commonDao.update("knld.pub.updateTechnologyInfo", input);
		}
	}

	/* 공지사항 삭제  */
	@Override
	public void deleteTechnologyInfo(HashMap<String, String> input) {
		String techId = NullUtil.nvl(input.get("techId"), "");
		commonDao.update("knld.pub.deleteTechnologyInfo", input);
	}

	/* 공지사항 조회건수 증가  */
	@Override
	public void updateTechnologyRtrvCnt(HashMap<String, String> input) {
		String techId = NullUtil.nvl(input.get("techId"), "");
		commonDao.update("knld.pub.updateTechnologyRtrvCnt", input);
	}

}