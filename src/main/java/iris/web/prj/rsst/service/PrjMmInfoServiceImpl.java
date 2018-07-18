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
 * NAME : PrjMmInfoServiceImpl.java
 * DESC : 프로젝트 - 연구팀(Project) - 투입M/M(mm) Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.29  IRIS04	최초생성
 *********************************************************************************/

@Service("prjMmInfoService")
public class PrjMmInfoServiceImpl implements PrjMmInfoService {

	static final Logger LOGGER = LogManager.getLogger(PrjRsstPduInfoServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/** 투입M/M 월별 목록 조회 **/
	@Override
	public List<Map<String, Object>> retrieveMmByMonthSearchInfo(HashMap<String, Object> input){

	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mm.retrieveMmByMonthSearchInfo", input);
	    return resultList;
	}

	/** 투입M/M 년도별 목록 조회 **/
	@Override
	public List<Map<String, Object>> retrieveMmByYearSearchInfo(HashMap<String, Object> input){

	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mm.retrieveMmByYearSearchInfo", input);
	    return resultList;
	}
}