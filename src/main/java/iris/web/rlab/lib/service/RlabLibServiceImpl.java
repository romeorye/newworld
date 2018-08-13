package iris.web.rlab.lib.service;


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
 * NAME : RlabLibServiceImpl.java
 * DESC : 분석의뢰관리 - 분석자료실관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.27  			최초생성
 *********************************************************************************/

@Service("rlabLibService")
public class RlabLibServiceImpl implements RlabLibService {

	static final Logger LOGGER = LogManager.getLogger(RlabLibServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 리스트 */
	public List<Map<String, Object>> getRlabLibList(HashMap<String, Object> input) {
		return commonDao.selectList("rlab.lib.getRlabLibList", input);
	}

	/* 상세보기 */
	public Map<String, Object> getRlabLibInfo(HashMap<String, Object> input) {
		return commonDao.select("rlab.lib.getRlabLibInfo", input);
	}

	/* 입력&업데이트 */
	@Override
	public void insertRlabLibInfo(Map<String, Object> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");

		if("".equals(bbsId)) {
			commonDao.insert("rlab.lib.insertRlabLibInfo", input);
		}else {
			commonDao.update("rlab.lib.updateRlabLibInfo", input);
		}
	}

	/* 삭제 */
	@Override
	public void deleteRlabLibInfo(HashMap<String, String> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");
		LOGGER.debug("###########bbsId################"+bbsId);
		commonDao.update("rlab.lib.deleteRlabLibInfo", input);
	}

	/* 조회건수 증가  */
	@Override
	public void updateRlabLibRtrvCnt(HashMap<String, String> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");
		LOGGER.debug("###########bbsId################"+bbsId);
		commonDao.update("rlab.lib.updateRlabLibRtrvCnt", input);
	}


	/* QnA 리스트 */
	public List<Map<String, Object>> getRlabQnaList(HashMap<String, Object> input) {
		return commonDao.selectList("rlab.lib.getRlabQnaList", input);
	}

	/*덧글*/
	/*덧글 리스트*/
	public List<Map<String, Object>> getRlabQnaRebList(HashMap<String, Object> input) {
		return commonDao.selectList("rlab.lib.getRlabQnaRebList", input);
	}

	/* 덧글 입력 */
	@Override
	public void insertRlabQnaRebInfo(Map<String, Object> input) {
		commonDao.insert("rlab.lib.insertRlabQnaRebInfo", input);
	}
	/* 덧글 업데이트 */
	@Override
	public void updateRlabQnaRebInfo(List<Map<String, Object>> list) {
		commonDao.batchUpdate("rlab.lib.updateRlabQnaRebInfo", list);
	}

	/* 덧글 삭제  */
	@Override
	public void deleteRlabQnaRebInfo(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		LOGGER.debug("###########rebId################"+rebId);
		commonDao.update("rlab.lib.deleteRlabQnaRebInfo", input);
	}
	
    @Override
    public List<Map<String, Object>> rlabBbsCodeList(HashMap<String, String> input){
        return commonDao.selectList("rlab.lib.rlabBbsCodeList",input);
    }


}