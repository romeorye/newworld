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
 * NAME : PubNoticeServiceImpl.java
 * DESC : 지식관리 - 공지사항관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.07.15  이주성	최초생성
 *********************************************************************************/

@Service("pubNoticeService")
public class PubNoticeServiceImpl implements PubNoticeService {

	static final Logger LOGGER = LogManager.getLogger(PubNoticeServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getPubNoticeList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getPubNoticeList", input);
	}

	public Map<String, Object> getPubNoticeInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getPubNoticeInfo", input);
	}

	/* 공지사항 입력&업데이트 */
	@Override
	public void insertPubNoticeInfo(Map<String, Object> input) {
		String pwiId = NullUtil.nvl(input.get("pwiId"), "");

		if("".equals(pwiId)) {
			commonDao.insert("knld.pub.insertPubNoticeInfo", input);
		}else {
			commonDao.update("knld.pub.updatePubNoticeInfo", input);
		}
	}

	/* 공지사항 삭제  */
	@Override
	public void deletePubNoticeInfo(HashMap<String, String> input) {
		String pwiId = NullUtil.nvl(input.get("pwiId"), "");
		commonDao.update("knld.pub.deletePubNoticeInfo", input);
	}

	/* 공지사항 조회건수 증가  */
	@Override
	public void updatePubNoticeRtrvCnt(HashMap<String, String> input) {
		String pwiId = NullUtil.nvl(input.get("pwiId"), "");
		commonDao.update("knld.pub.updatePubNoticeRtrvCnt", input);
	}

	/* 공지사항 긴급공지 변경  */
	@Override
	public void updatePubNoticeUgyYn(Map<String, Object> input) {
		String pwiId = NullUtil.nvl(input.get("pwiId"), "");
		commonDao.update("knld.pub.updatePubNoticeUgyYn", input);
	}

}