package iris.web.anl.lib.service;


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
 * NAME : AnlLibServiceImpl.java
 * DESC : 분석의뢰관리 - 분석자료실관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.27  			최초생성
 *********************************************************************************/

@Service("anlLibService")
public class AnlLibServiceImpl implements AnlLibService {

	static final Logger LOGGER = LogManager.getLogger(AnlLibServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 리스트 */
	public List<Map<String, Object>> getAnlLibList(HashMap<String, Object> input) {
		return commonDao.selectList("anl.lib.getAnlLibList", input);
	}

	/* 상세보기 */
	public Map<String, Object> getAnlLibInfo(HashMap<String, Object> input) {
		return commonDao.select("anl.lib.getAnlLibInfo", input);
	}

	/* 입력&업데이트 */
	@Override
	public void insertAnlLibInfo(Map<String, Object> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");

		if("".equals(bbsId)) {
			commonDao.insert("anl.lib.insertAnlLibInfo", input);
		}else {
			commonDao.update("anl.lib.updateAnlLibInfo", input);
		}
	}

	/* 삭제 */
	@Override
	public void deleteAnlLibInfo(HashMap<String, String> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");
		LOGGER.debug("###########bbsId################"+bbsId);
		commonDao.update("anl.lib.deleteAnlLibInfo", input);
	}

	/* 조회건수 증가  */
	@Override
	public void updateAnlLibRtrvCnt(HashMap<String, String> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");
		LOGGER.debug("###########bbsId################"+bbsId);
		commonDao.update("anl.lib.updateAnlLibRtrvCnt", input);
	}


	/* QnA 리스트 */
	public List<Map<String, Object>> getAnlQnaList(HashMap<String, Object> input) {
		return commonDao.selectList("anl.lib.getAnlQnaList", input);
	}

	/*덧글*/
	/*덧글 리스트*/
	public List<Map<String, Object>> getAnlQnaRebList(HashMap<String, Object> input) {
		return commonDao.selectList("anl.lib.getAnlQnaRebList", input);
	}

	/* 덧글 입력 */
	@Override
	public void insertAnlQnaRebInfo(Map<String, Object> input) {
		commonDao.insert("anl.lib.insertAnlQnaRebInfo", input);
	}
	/* 덧글 업데이트 */
	@Override
	public void updateAnlQnaRebInfo(List<Map<String, Object>> list) {
		commonDao.batchUpdate("anl.lib.updateAnlQnaRebInfo", list);
	}

	/* 덧글 삭제  */
	@Override
	public void deleteAnlQnaRebInfo(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		LOGGER.debug("###########rebId################"+rebId);
		commonDao.update("anl.lib.deleteAnlQnaRebInfo", input);
	}


}