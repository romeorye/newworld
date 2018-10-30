package iris.web.anl.bbs.service;


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
 * NAME : AnlBbsServiceImpl.java
 * DESC : 분석의뢰관리 - 분석자료실관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.27  			최초생성
 *********************************************************************************/

@Service("anlBbsService")
public class AnlBbsServiceImpl implements AnlBbsService {

	static final Logger LOGGER = LogManager.getLogger(AnlBbsServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 리스트 */
	public List<Map<String, Object>> getAnlBbsList(HashMap<String, Object> input) {
		return commonDao.selectList("anl.bbs.getAnlBbsList", input);
	}

	/* 리스트 */
	public List<Map<String, Object>> getAnlBbsList2(HashMap<String, Object> input) {
		return commonDao.selectList("anl.bbs.getAnlBbsList2", input);
	}

	/* 상세보기 */
	public Map<String, Object> getAnlBbsInfo(HashMap<String, Object> input) {
		return commonDao.select("anl.bbs.getAnlBbsInfo", input);
	}

	/* 입력&업데이트 */
	@Override
	public void insertAnlBbsInfo(Map<String, Object> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");

		if("".equals(bbsId)) {
			commonDao.insert("anl.bbs.insertAnlBbsInfo", input);
		}else {
			commonDao.update("anl.bbs.updateAnlBbsInfo", input);
		}
	}

	/* 삭제 */
	@Override
	public void deleteAnlBbsInfo(HashMap<String, String> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");
		commonDao.update("anl.bbs.deleteAnlBbsInfo", input);
	}

	/* 조회건수 증가  */
	@Override
	public void updateAnlBbsRtrvCnt(HashMap<String, String> input) {
		String bbsId = NullUtil.nvl(input.get("bbsId"), "");
		commonDao.update("anl.bbs.updateAnlBbsRtrvCnt", input);
	}


	/* QnA 리스트 */
	public List<Map<String, Object>> getAnlQnaList(HashMap<String, Object> input) {
		return commonDao.selectList("anl.bbs.getAnlQnaList", input);
	}

	/*덧글*/
	/*덧글 리스트*/
	public List<Map<String, Object>> getAnlQnaRebList(HashMap<String, Object> input) {
		return commonDao.selectList("anl.bbs.getAnlQnaRebList", input);
	}

	/* 덧글 입력 */
	@Override
	public void insertAnlQnaRebInfo(Map<String, Object> input) {
		commonDao.insert("anl.bbs.insertAnlQnaRebInfo", input);
	}
	/* 덧글 업데이트 */
	@Override
	public void updateAnlQnaRebInfo(List<Map<String, Object>> list) {
		commonDao.batchUpdate("anl.bbs.updateAnlQnaRebInfo", list);
	}

	/* 덧글 삭제  */
	@Override
	public void deleteAnlQnaRebInfo(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		commonDao.update("anl.bbs.deleteAnlQnaRebInfo", input);
	}

    @Override
    public List<Map<String, Object>> anlBbsCodeList(HashMap<String, String> input){
        return commonDao.selectList("anl.bbs.anlBbsCodeList",input);
    }


}