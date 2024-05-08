package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;

/********************************************************************************
 * NAME : RsstServiceImpl.java
 * DESC : 프로젝트 - 연구팀(Project) - 지적재산권(Ptot_Prpt) Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.24  IRIS04	최초생성
 *********************************************************************************/

@Service("prjPtotPrptInfoService")
public class PrjPtotPrptInfoServiceImpl implements PrjPtotPrptInfoService {

	static final Logger LOGGER = LogManager.getLogger(PrjRsstPduInfoServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="commonDaoPims")
	private CommonDao commonDaoPims;

	/* 지적재산권 목록 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjPtotPrptSearchInfo(HashMap<String, Object> input){
		String prptGoalYear = "";				// 계획지적재산권 목표년도
		Map<String, Object> resultMap = null; 	// 계획지적재산권 맵
		
		// 1. 계획 지적재산권 리스트 조회
	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.ptotprpt.retrievePrjPtotPrptSearchInfo", input);
	    
	    // 2. 실적 지적재산권 년도별 개수 조회
	    List<Map<String, Object>> ptptYearList = commonDaoPims.selectList("prj.rsst.ptotprpt.oracle.retrievePrjErpPrptByYearList", input);
	    
	    // 3. 년도별 개수 입력처리
	    for(int i=0; i< resultList.size(); i++){
	    	resultMap = resultList.get(i);
	    	
	    	prptGoalYear = NullUtil.nvl(resultMap.get("prptGoalYear"), "");
	    	
	    	for(Map<String, Object> ptptYearMap : ptptYearList) {
	    		if( prptGoalYear != "" && prptGoalYear.equals( NullUtil.nvl(ptptYearMap.get("patYear"), "") ) ) {
	    			resultList.get(i).put("patCnt", ptptYearMap.get("patCnt"));
	    		}
	    	}
	    }
	    
	    return resultList;
	}

	/* 지적재산권 삭제 */
	@Override
	public void deletePrjPtotPrptInfo(Map<String, Object> input) {
		commonDao.delete("prj.rsst.ptotprpt.deletePrjPtotPrptInfo", input);
	}

	/* 지적재산권 리스트 입력&업데이트 */
	@Override
	public void insertPrjPtotPrptInfo(Map<String, Object> input) {
		String prptId = NullUtil.nvl(input.get("prptId"), "");
		if("".equals(prptId)) {
			commonDao.insert("prj.rsst.ptotprpt.insertPrjPtotPrptInfo", input);
		}else {
			commonDao.update("prj.rsst.ptotprpt.updatePrjPtotPrptInfo", input);
		}
	}

	/* 실적 지적재산권 목록 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjErpPrptInfo(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDaoPims.selectList("prj.rsst.ptotprpt.oracle.retrievePrjErpPrptSearchInfo", input);
	    return resultList;
	}
}