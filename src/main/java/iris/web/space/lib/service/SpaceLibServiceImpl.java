package iris.web.space.lib.service;


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
 * NAME : SpaceLibServiceImpl.java
 * DESC : 분석의뢰관리 - 분석자료실관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.27  			최초생성
 *********************************************************************************/

@Service("spaceLibService")
public class SpaceLibServiceImpl implements SpaceLibService {

	static final Logger LOGGER = LogManager.getLogger(SpaceLibServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 리스트 */
	public List<Map<String, Object>> getSpaceLibList(HashMap<String, Object> input) {
		return commonDao.selectList("space.lib.getSpaceLibList", input);
	}

	/* 상세보기 */
	public Map<String, Object> getSpaceLibInfo(HashMap<String, Object> input) {
		return commonDao.select("space.lib.getSpaceLibInfo", input);
	}

	/* 입력&업데이트 */
	@Override
	public void insertSpaceLibInfo(Map<String, Object> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");

		if("".equals(bbsId)) {
			commonDao.insert("space.lib.insertSpaceLibInfo", input);
		}else {
			commonDao.update("space.lib.updateSpaceLibInfo", input);
		}
	}

	/* 삭제 */
	@Override
	public void deleteSpaceLibInfo(HashMap<String, String> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");
		LOGGER.debug("###########bbsId################"+bbsId);
		commonDao.update("space.lib.deleteSpaceLibInfo", input);
	}

	/* 조회건수 증가  */
	@Override
	public void updateSpaceLibRtrvCnt(HashMap<String, String> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");
		LOGGER.debug("###########bbsId################"+bbsId);
		commonDao.update("space.lib.updateSpaceLibRtrvCnt", input);
	}


	/* QnA 리스트 */
	public List<Map<String, Object>> getSpaceQnaList(HashMap<String, Object> input) {
		return commonDao.selectList("space.lib.getSpaceQnaList", input);
	}

	/*덧글*/
	/*덧글 리스트*/
	public List<Map<String, Object>> getSpaceQnaRebList(HashMap<String, Object> input) {
		return commonDao.selectList("space.lib.getSpaceQnaRebList", input);
	}

	/* 덧글 입력 */
	@Override
	public void insertSpaceQnaRebInfo(Map<String, Object> input) {
		commonDao.insert("space.lib.insertSpaceQnaRebInfo", input);
	}
	/* 덧글 업데이트 */
	@Override
	public void updateSpaceQnaRebInfo(List<Map<String, Object>> list) {
		commonDao.batchUpdate("space.lib.updateSpaceQnaRebInfo", list);
	}

	/* 덧글 삭제  */
	@Override
	public void deleteSpaceQnaRebInfo(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		LOGGER.debug("###########rebId################"+rebId);
		commonDao.update("space.lib.deleteSpaceQnaRebInfo", input);
	}
	
    @Override
    public List<Map<String, Object>> spaceBbsCodeList(HashMap<String, String> input){
        return commonDao.selectList("space.lib.spaceBbsCodeList",input);
    }


}