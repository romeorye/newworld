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
 * NAME : ConferenceServiceImpl.java
 * DESC : 지식관리 - 학회컨퍼런스관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.12  			최초생성
 *********************************************************************************/

@Service("conferenceService")
public class ConferenceServiceImpl implements ConferenceService {

	static final Logger LOGGER = LogManager.getLogger(ConferenceServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getConferenceList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getConferenceList", input);
	}

	public Map<String, Object> getConferenceInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getConferenceInfo", input);
	}

	/* 학회컨퍼런스 입력&업데이트 */
	@Override
	public void insertConferenceInfo(Map<String, Object> input) {
		String conferenceId = NullUtil.nvl(input.get("conferenceId"), "");

		if("".equals(conferenceId)) {
			commonDao.insert("knld.pub.insertConferenceInfo", input);
		}else {
			commonDao.update("knld.pub.updateConferenceInfo", input);
		}
	}

	/* 학회컨퍼런스 삭제  */
	@Override
	public void deleteConferenceInfo(HashMap<String, String> input) {
		String conferenceId = NullUtil.nvl(input.get("conferenceId"), "");
		commonDao.update("knld.pub.deleteConferenceInfo", input);
	}

	/* 학회컨퍼런스 조회건수 증가  */
	@Override
	public void updateConferenceRtrvCnt(HashMap<String, String> input) {
		String conferenceId = NullUtil.nvl(input.get("conferenceId"), "");
		commonDao.update("knld.pub.updateConferenceRtrvCnt", input);
	}

}