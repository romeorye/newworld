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
 * DESC : 프로젝트 - 연구팀(Project) - 팀원정보(Tmmr) Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.25  IRIS04	최초생성
 *********************************************************************************/

@Service("prjTmmrInfoService")
public class PrjTmmrInfoServiceImpl implements PrjTmmrInfoService {

	static final Logger LOGGER = LogManager.getLogger(PrjPtotPrptInfoServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="commonDaoPims")
	private CommonDao commonDaoPims;	// 지적재산권 조회 Dao
	
	
	/* 팀원정보 목록 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjTmmrSearchInfo(HashMap<String, Object> input){

	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.tmmr.retrievePrjTmmrSearchInfo", input);
	    return resultList;
	}

	/* 팀원정보 프로젝트단위 삭제 */
	@Override
	public void deletePrjTmmrDeptInfo(Map<String, Object> input) {
		commonDao.delete("prj.rsst.tmmr.deletePrjTmmrDeptInfo", input);
	}

	/* 팀원정보 프로젝트단위 등록 */
	@Override
	public void insertPrjTmmrDeptInfo(Map<String, Object> input) {
		commonDao.insert("prj.rsst.tmmr.insertPrjTmmrDeptInfo", input);
	}
	
	/* 팀원정보 프로젝트단위(파트포함) 등록 */
	@Override
	public void insertPrjTeamTmmrDeptInfo(Map<String, Object> input) {
		commonDao.insert("prj.rsst.tmmr.insertPrjTeamTmmrDeptInfo", input);
		
		//지적재산권 참여연구원 연동
		//List<Map<String,Object>> tmmrList =  commonDao.selectList("prj.rsst.tmmr.selectPrjTeamTmmrInfo", input);
		//commonDaoPims.batchDelete("prj.rsst.tmmr.deletePrjPimsInfo", tmmrList);
		//commonDaoPims.batchInsert("prj.rsst.tmmr.insertPrjPimsInfo", tmmrList);
	}

}