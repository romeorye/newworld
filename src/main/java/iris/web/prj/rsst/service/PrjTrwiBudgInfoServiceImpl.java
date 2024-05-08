package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/********************************************************************************
 * NAME : RsstServiceImpl.java
 * DESC : 프로젝트 - 연구팀(Project) - 비용&예산(Trwi_Budg) Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.24  IRIS04	최초생성
 *********************************************************************************/

@Service("prjTrwiBudgInfoService")
public class PrjTrwiBudgInfoServiceImpl implements PrjTrwiBudgInfoService {

	static final Logger LOGGER = LogManager.getLogger(PrjTrwiBudgInfoServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/** 비용/예산 1년 통계 조회 **/
	@Override
	public List<Map<String, Object>> retrievePrjTrwiBudgSearchInfo(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.trwibudg.retrievePrjTrwiBudgSearchInfo", input);
	    return resultList;
	}
}