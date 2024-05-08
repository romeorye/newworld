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
 * NAME : ManualServiceImpl.java
 * DESC : 지식관리 - 규정/업무Manual관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.14  			최초생성
 *********************************************************************************/

@Service("manualService")
public class ManualServiceImpl implements ManualService {

	static final Logger LOGGER = LogManager.getLogger(ManualServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getManualList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getManualList", input);
	}

	public Map<String, Object> getManualInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getManualInfo", input);
	}

	/* 규정/업무Manual 입력&업데이트 */
	@Override
	public void insertManualInfo(Map<String, Object> input) {
		String manualId = NullUtil.nvl(input.get("manualId"), "");

		if("".equals(manualId)) {
			commonDao.insert("knld.pub.insertManualInfo", input);
		}else {
			commonDao.update("knld.pub.updateManualInfo", input);
		}
	}

	/* 규정/업무Manual 삭제  */
	@Override
	public void deleteManualInfo(HashMap<String, String> input) {
		String manualId = NullUtil.nvl(input.get("ManualId"), "");
		commonDao.update("knld.pub.deleteManualInfo", input);
	}

	/* 규정/업무Manual 조회건수 증가  */
	@Override
	public void updateManualRtrvCnt(HashMap<String, String> input) {
		String manualId = NullUtil.nvl(input.get("manualId"), "");
		commonDao.update("knld.pub.updateManualRtrvCnt", input);
	}

}