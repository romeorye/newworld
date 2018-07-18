package iris.web.stat.anl.service;


import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : AnlStatServiceImpl.java 
 * DESC : 통계 - 분석 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성               
 *********************************************************************************/

@Service("anlStatService")
public class AnlStatServiceImpl implements AnlStatService {
	
	static final Logger LOGGER = LogManager.getLogger(AnlStatServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 분석완료 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlCompleteStateList(Map<String, Object> input) {
		return commonDao.selectList("stat.anl.getAnlCompleteStateList", input);
	}

	/* 분석 기기사용 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlMchnUseStateList(Map<String, Object> input) {
		return commonDao.selectList("stat.anl.getAnlMchnUseStateList", input);
	}

	/* 분석 업무현황 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlBusinessStateList(Map<String, Object> input) {
		return commonDao.selectList("stat.anl.getAnlBusinessStateList", input);
	}

	/* 분석 사업부 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlDivisionStateList(Map<String, Object> input) {
		return commonDao.selectList("stat.anl.getAnlDivisionStateList", input);
	}

	/* 담당자 분석 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlChrgStateList(Map<String, Object> input) {
		return commonDao.selectList("stat.anl.getAnlChrgStateList", input);
	}
}