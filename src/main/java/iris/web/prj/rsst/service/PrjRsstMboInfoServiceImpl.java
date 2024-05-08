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
 * NAME : PrjRsstMboInfoServiceImpl.java 
 * DESC : 프로젝트 - 연구팀(Project) - MBO(특성지표) Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.21  IRIS04	최초생성     
 *********************************************************************************/

@Service("prjRsstMboInfoService")
public class PrjRsstMboInfoServiceImpl implements PrjRsstMboInfoService {
	
	static final Logger LOGGER = LogManager.getLogger(PrjRsstMboInfoServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* MBO 리스트 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjRsstMboSearchInfo(HashMap<String, Object> input){

	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mbo.retrievePrjRsstMboSearchInfo", input);
	    return resultList;
	}
	
	/* MBO 삭제 */
	@Override
	public void deletePrjRsstMboInfo(Map<String, Object> input) {
		commonDao.delete("prj.rsst.mbo.deletePrjRsstMboInfo", input);
	}
	
	/* MBO 단건 조회 */
	@Override
	public Map<String, Object> retrievePrjRsstMboSearchDtlInfo(HashMap<String, Object> input){
		Map<String, Object> resultMap = null;
	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.mbo.retrievePrjRsstMboSearchDtlInfo", input);
	    if(resultList.size() > 0 ) {
	    	resultMap = resultList.get(0);
	    }
	    return resultMap;
	}
	
	/* MBO 단건 입력, 업데이트 */
	@Override
	public void insertPrjRsstMboInfo(Map<String, Object> input) {
		String seq = NullUtil.nvl(input.get("seq"), "");
		if("".equals(seq)) {
			commonDao.insert("prj.rsst.mbo.insertPrjRsstMboInfo", input);
		}else {
			commonDao.update("prj.rsst.mbo.updatePrjRsstMboInfo", input);
		}
	}
	
	/* MBO 단건 입력, 업데이트(데이터셋)*/
	@Override
	public void savePrjRsstMboInfo(Map<String, Object> dataSet) {
		String seq = NullUtil.nvl(dataSet.get("seq"), "");
		if("".equals(seq)) {
			commonDao.insert("prj.rsst.mbo.insertPrjRsstMboInfo", dataSet);
		}else {
			commonDao.update("prj.rsst.mbo.updatePrjRsstMboInfo", dataSet);
		}
	}
	
	/* MBO 실적년월 중복체크 */
	@Override
	public String getMboDupYn(Map<String, Object> input) {
		return (String)commonDao.select("prj.rsst.mbo.getMboDupYn", input);
	}
	
	/* MBO 목표(목표년도+목표번호) 개수조회 */
	@Override
	public int getMboGoalCnt(Map<String, Object> input) {
		return (int)commonDao.select("prj.rsst.mbo.getMboGoalCnt", input);
	}
	
	/* MBO 실적(실적년월,실적현황,첨부파일) 수정*/
	@Override
	public void updatePrjRsstMboArlsInfo(Map<String, Object> dataSet) {
			commonDao.update("prj.rsst.mbo.updatePrjRsstMboArlsInfo", dataSet);
	}

}