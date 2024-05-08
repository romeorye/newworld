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
 * NAME : ModalityServiceImpl.java
 * DESC : 지식관리 - 표준양식관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.13  			최초생성
 *********************************************************************************/

@Service("modalityService")
public class ModalityServiceImpl implements ModalityService {

	static final Logger LOGGER = LogManager.getLogger(ModalityServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getModalityList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getModalityList", input);
	}

	public Map<String, Object> getModalityInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getModalityInfo", input);
	}

	/* 표준양식 입력&업데이트 */
	@Override
	public void insertModalityInfo(Map<String, Object> input) {
		String modalityId = NullUtil.nvl(input.get("modalityId"), "");

		if("".equals(modalityId)) {
			commonDao.insert("knld.pub.insertModalityInfo", input);
		}else {
			commonDao.update("knld.pub.updateModalityInfo", input);
		}
	}

	/* 표준양식 삭제  */
	@Override
	public void deleteModalityInfo(HashMap<String, String> input) {
		String modalityId = NullUtil.nvl(input.get("modalityId"), "");
		commonDao.update("knld.pub.deleteModalityInfo", input);
	}

	/* 표준양식 조회건수 증가  */
	@Override
	public void updateModalityRtrvCnt(HashMap<String, String> input) {
		String modalityId = NullUtil.nvl(input.get("modalityId"), "");
		commonDao.update("knld.pub.updateModalityRtrvCnt", input);
	}

}