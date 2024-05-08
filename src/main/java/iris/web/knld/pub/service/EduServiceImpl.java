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
 * NAME : EduServiceImpl.java
 * DESC : 지식관리 - 교육세미나관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.12  			최초생성
 *********************************************************************************/

@Service("eduService")
public class EduServiceImpl implements EduService {

	static final Logger LOGGER = LogManager.getLogger(EduServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getEduList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getEduList", input);
	}

	public Map<String, Object> getEduInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getEduInfo", input);
	}

	/* 공지사항 입력&업데이트 */
	@Override
	public void insertEduInfo(Map<String, Object> input) {
		String eduId = NullUtil.nvl(input.get("eduId"), "");

		if("".equals(eduId)) {
			commonDao.insert("knld.pub.insertEduInfo", input);
		}else {
			commonDao.update("knld.pub.updateEduInfo", input);
		}
	}

	/* 공지사항 삭제  */
	@Override
	public void deleteEduInfo(HashMap<String, String> input) {
		String eduId = NullUtil.nvl(input.get("eduId"), "");
		commonDao.update("knld.pub.deleteEduInfo", input);
	}

	/* 공지사항 조회건수 증가  */
	@Override
	public void updateEduRtrvCnt(HashMap<String, String> input) {
		String eduId = NullUtil.nvl(input.get("eduId"), "");
		commonDao.update("knld.pub.updateEduRtrvCnt", input);
	}

}