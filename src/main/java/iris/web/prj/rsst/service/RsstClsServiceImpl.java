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


@Service("rsstClsService")
public class RsstClsServiceImpl implements RsstClsService {
	static final Logger LOGGER = LogManager.getLogger(RsstClsServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 프로젝트  월마감 리스트 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjClsList(HashMap<String, Object> input){

	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsstCls.retrievePrjClsList", input);
	    return resultList;
	}

	/* 프로젝트 월마감 MBO 리스트 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjRsstMboList(HashMap<String, Object> input){

		List<Map<String, Object>> resultList = commonDao.selectList("prj.rsstCls.retrievePrjRsstMboList", input);
		return resultList;
	}
	/* 프로젝트 월마감 필수 산출물 리스트 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjRsstPduList(HashMap<String, Object> input){

		List<Map<String, Object>> resultList = commonDao.selectList("prj.rsstCls.retrievePrjRsstPduList", input);
		return resultList;
	}
	/* 프로젝트 지적재산권 리스트 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjPrptList(HashMap<String, Object> input){

		List<Map<String, Object>> resultList = commonDao.selectList("prj.rsstCls.retrievePrjPrptList", input);
		return resultList;
	}

	/* 프로젝트 월마감 상세정보 조회 */
	@Override
	public HashMap<String, Object> retrievePrjClsDtl(HashMap<String, Object> input){

		HashMap<String, Object> result = commonDao.select("prj.rsstCls.retrievePrjClsDtl", input);
		return result;
	}

	/* 프로젝트 월마감 단건 입력&업데이트 */
	@Override
	public void insertPrjRsstCls(List<Map<String, Object>> dataSetList, HashMap<String, Object> input){
		String hClsPrjCd = NullUtil.nvl(input.get("hClsPrjCd"),"");
		if("".equals(hClsPrjCd)) {
			commonDao.insert("prj.rsstCls.insertPrjRsstCls", input);
			commonDao.batchInsert("prj.rsstCls.insertPrjClsProg", dataSetList);
		}else {
			commonDao.update("prj.rsstCls.updatePrjRsstCls", input);
		}
	}

	/* 과제 진척률 리스트 */
	public List<Map<String, Object>> retrieveTssPgsSearchInfo(HashMap<String, Object> input){
		return commonDao.selectList("prj.rsstCls.retrieveTssPgsSearchInfo", input);
	}
	
	/* 전월 월마감 체크 */
	public int retrievePrjMmCls(HashMap<String, Object> input){
		int cnt = 0;
		int toMonPrj = commonDao.select("prj.rsstCls.retrieveToMonPrj", input);
		
		if( toMonPrj > 0 ){
			cnt = 1;
		}else{
			cnt = commonDao.select("prj.rsstCls.retrievePrjMmCls", input);
		}
		
		return cnt;
	}
	
	public List<Map<String, Object>> retrievePrjClsProgSearchInfo(HashMap<String, Object> input){
		return commonDao.selectList("prj.rsstCls.retrievePrjClsProgSearchInfo", input);
	}
}
