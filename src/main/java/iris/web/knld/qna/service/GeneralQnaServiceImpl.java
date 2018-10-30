package iris.web.knld.qna.service;


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
 * NAME : GeneralQnaServiceImpl.java
 * DESC : 지식관리 - 일반Qna관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.18  			최초생성
 *********************************************************************************/

@Service("generalQnaService")
public class GeneralQnaServiceImpl implements GeneralQnaService {

	static final Logger LOGGER = LogManager.getLogger(GeneralQnaServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	/* 일반QnA 리스트 */
	public List<Map<String, Object>> getGeneralQnaList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.qna.getGeneralQnaList", input);
	}

	/* 일반QnA 상세화면 */
	public Map<String, Object> getGeneralQnaInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.qna.getGeneralQnaInfo", input);
	}

	/* 일반QnA 입력&업데이트 */
	@Override
	public void insertGeneralQnaInfo(Map<String, Object> input) {
		String qnaId = NullUtil.nvl(input.get("qnaId"), "");
		if("".equals(qnaId)) {
			commonDao.insert("knld.qna.insertGeneralQnaInfo", input);
		}else {
			commonDao.update("knld.qna.updateGeneralQnaInfo", input);
		}
	}

	/* 일반QnA 삭제 */
	@Override
	public void deleteGeneralQnaInfo(HashMap<String, String> input) {
		String qnaId = NullUtil.nvl(input.get("qnaId"), "");
		commonDao.update("knld.qna.deleteGeneralQnaInfo", input);
	}

	/* 일반QnA 조회건수 증가 */
	@Override
	public void updateGeneralQnaRtrvCnt(HashMap<String, String> input) {
		String qnaId = NullUtil.nvl(input.get("qnaId"), "");
		commonDao.update("knld.qna.updateGeneralQnaRtrvCnt", input);
	}


	/*덧글*/
	/*덧글 리스트*/
	public List<Map<String, Object>> getGeneralQnaRebList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.qna.getGeneralQnaRebList", input);
	}

	/* 덧글 입력 */
	@Override
	public void insertGeneralQnaRebInfo(Map<String, Object> input) {
		commonDao.insert("knld.qna.insertGeneralQnaRebInfo", input);
	}
	/* 덧글 업데이트 */
	@Override
	public void updateGeneralQnaRebInfo(List<Map<String, Object>> list) {
		commonDao.batchUpdate("knld.qna.updateGeneralQnaRebInfo", list);
	}

	/* 덧글 삭제  */
	@Override
	public void deleteGeneralQnaRebInfo(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		commonDao.update("knld.qna.deleteGeneralQnaRebInfo", input);
	}



}