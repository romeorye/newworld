package iris.web.prj.rsst.service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : PrjRsstMstInfoServiceImpl.java
 * DESC : 프로젝트 - 연구팀(Project) - 마스터, 개요 Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.10  IRIS04	최초생성
 *********************************************************************************/

@Service("prjRsstMstInfoService")
public class PrjRsstMstInfoServiceImpl implements PrjRsstMstInfoService {

	static final Logger LOGGER = LogManager.getLogger(PrjRsstMstInfoServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="commonDaoPims")
	private CommonDao commonDaoPims;	// 지적재산권 조회 Dao

	/* 프로젝트 리스트 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjMstSearchList(HashMap<String, Object> input){

	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mst.retrievePrjMstSearchList", input);
	    return resultList;
	}

	/* 프로젝트 마스터 정보조회 */
	@Override
	public Map<String, Object> retrievePrjMstInfo(HashMap<String, Object> input){
		Map<String, Object> returnMap = null;

		List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mst.retrievePrjMstInfo", input);
		if(resultList.size() > 0) {
			returnMap =  resultList.get(0);
		}
		return returnMap;
	}

	/* 프로젝트 상세 정보조회 */
	@Override
	public Map<String, Object> retrievePrjDtlInfo(HashMap<String, Object> input){
		Map<String, Object> returnMap = null;

		List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mst.retrievePrjDtlInfo", input);
		if(resultList.size() > 0) {
			returnMap =  resultList.get(0);
		}
		return returnMap;
	}

	/* 조직 총 인원수 조회 */
	@Override
	public Map<String, Object> retrieveDeptUserCntInfo(HashMap<String, String> input){
		Map<String, Object> returnMap = null;
		List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mst.retrieveDeptUserCntInfo", input);
		if(resultList.size() > 0) {
			returnMap =  resultList.get(0);
		}
		return returnMap;
	}

	/* 프로젝트 개요 마스터 저장,업데이트 */
	@Override
	public void insertPrjRsstMstInfo(Map<String, Object> input) {
		String prjCd = NullUtil.nvl(input.get("prjCd"), "");
		if("".equals(prjCd)) {
			commonDao.insert("prj.rsst.mst.insertPrjRsstMstInfo", input);
		}else {
			commonDao.update("prj.rsst.mst.updatePrjRsstMstInfo", input);
		}

		//지적재산권 등록및 수정
		//savePrjPimsInfo(input);
	}

	/* 프로젝트 개요 상세 저장,업데이트 */
	@Override
	public void insertPrjRsstDtlInfo(Map<String, Object> input) {
		String prjCd = NullUtil.nvl(input.get("prjCd"), "");
		if("".equals(prjCd)) {
			input.put("prjCd", input.get("newPrjCd"));
			commonDao.insert("prj.rsst.mst.insertPrjRsstDtlInfo", input);
		}else {
			commonDao.update("prj.rsst.mst.updatePrjRsstDtlInfo", input);
		}
	}

	/* 프로젝트 코드 조회 : null인 경우 "" */
	@Override
	public String retrievePrjCd() {
		List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mst.retrievePrjCd");
		return NullUtil.nvl((resultList.get(0)).get("prjCd"),"");
	}

	/* 프로젝트 조회팝업 목록조회" */
	@Override
	public List<Map<String, Object>> retrievePrjSearchPopupSearchList(HashMap<String, Object> input){

	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mst.retrievePrjSearchPopupSearchList", input);
	    return resultList;
	}

	/* 팀정보 조회
	 * 팀정보조회 + 팀원조회 + 팀 프로젝트 조회
	 * */
	@Override
	public Map<String, Object> retrieveTeamDeptInfo(HashMap<String, String> input){
		// 1. 팀정보 조회
		Map<String, Object> resultMap = commonDao.select("prj.rsst.mst.retrieveTeamDeptInfo", input);

		// 2. 총 팀원 수 조회
		if( resultMap != null && !resultMap.isEmpty() ) {
			Map<String, Object> deptUserCntMap = this.retrieveDeptUserCntInfo(input);
			resultMap.put("teamUserCnt", NullUtil.nvl(deptUserCntMap.get("deptCnt"), "0") );
		}

		// 3. 팀 프로젝트 조회 : 로그인유저 팀으로 등록된 프로젝트 조회
		if( resultMap != null && !resultMap.isEmpty() ) {
	    	HashMap<String,Object> paramMap = new HashMap<String,Object>();
	    	paramMap.put("deptCd", NullUtil.nvl(input.get("_teamDept"), ""));
	    	List<Map<String,Object>> resultUserPrjList = this.retrievePrjSearchPopupSearchList(paramMap);
	    	if( resultUserPrjList.size() > 0 ) {
	    		resultMap.put("isTeamPrj", "Y");
	    	}
		}

		return resultMap;
	}

	/* WBS_CD 중복여부 */
	@Override
	public String retrieveDupPrjWbsCd(Map<String, Object> input){
		String dupYn = "N";

		Map<String, Object> resultMap = commonDao.select("prj.rsst.mst.retrieveDupPrjWbsCd", input);
		if( !resultMap.isEmpty() ) {
			dupYn = NullUtil.nvl(resultMap.get("dupYn"), "N");
		}

		return dupYn;
	}

/* 프로젝트부서별 약어 수정
 * (non-Javadoc)
 * @see iris.web.prj.rsst.service.PrjRsstMstInfoService#updatePrjDeptCdA(java.util.Map)
 */
	@Override
	public void updatePrjDeptCdA(Map<String, Object> ds) {
		commonDao.update("prj.rsst.mst.updatePrjDeptCdA", ds);

	}

	/* 프로젝트신규 전용팝업창 */
	public List<Map<String, Object>> retrievePrjPopupSearchList(HashMap<String, Object> input){
		return commonDao.selectList("prj.rsst.mst.retrievePrjPopupSearchList", input);
	}

	@Override
	public Map<String, Object> retrieveUserDeptInfo(HashMap<String, Object> input) {
		return commonDao.select("prj.rsst.mst.retrieveUserDeptInfo", input);
	}


	public void savePrjPimsInfo(Map<String, Object> input) {
		commonDaoPims.update("prj.rsst.mst.savePrjPimsInfo", input);
	}

}