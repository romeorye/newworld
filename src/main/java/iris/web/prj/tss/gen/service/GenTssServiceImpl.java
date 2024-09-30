package iris.web.prj.tss.gen.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : GenTssServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("genTssService")
public class GenTssServiceImpl implements GenTssService {

    static final Logger LOGGER = LogManager.getLogger(GenTssServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Override
    public List<Map<String, Object>> retrieveGenTssList(HashMap<String, Object> input) {
        //return commonDao.selectPagedList("prj.tss.gen.retrieveGenTssList", input);
        return commonDao.selectList("prj.tss.gen.retrieveGenTssList", input);
    }

    @Override
    public List<Map<String, Object>> retrieveTssPopupList(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssPopupList", input);
    }

    @Override
    public List<Map<String, Object>> retrieveChargeMbr(String input) {
        return commonDao.selectList("prj.tss.com.retrieveChargeMbrList", input);
    }

    @Override
    public HashMap<String, Object> getWbsCdStd(String string, HashMap<String, Object> mstDs) {
        return commonDao.select("prj.tss.com.getWbsCdStd", mstDs);
    }

	@Override
	public HashMap<String, Object> getTssCd(HashMap<String, Object> input) {
        return commonDao.select("prj.tss.com.getTssCd", input);
	}

	@Override
    public void insertGenTssCsusRq(Map<String, Object> map) {
        commonDao.insert("prj.tss.com.insertTssCsusRq", map);
    }

    @Override
    public void updateGenTssCsusRq(Map<String, Object> map) {
        String tssSt = String.valueOf(map.get("tssSt"));
        if("104".equals(tssSt) || "600".equals(tssSt) || "603".equals(tssSt) || "604".equals(tssSt)) { //과제상태 104 품의완료, 600 초기유동작성중, 603 초기유동품의요청, 604 초기유동품의완료
            //전자결재 이력 저장
            commonDao.insert("prj.tss.com.insertTssCsusRqHist", map);
        }
        
        //전자결재 업데이트
        commonDao.update("prj.tss.com.updateTssCsusRq", map);
    }

    @Override
    public Map<String, Object> retrieveGenTssCsus(Map<String, Object> map) {
        return commonDao.select("prj.tss.com.retrieveTssCsus", map);
    }

    @Override
    public Map<String, Object> getTssRegistCnt(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.getTssRegistCnt", input);
    }
    
    /* 중단, 완료 참가 연구원 수 조회*/
    @Override
	public Map<String, Object> retrieveCmDcTssPtcMbrCnt(HashMap<String, String> input){
    	return commonDao.select("prj.tss.com.retrieveCmDcTssPtcMbrCnt", input);
    }
    
    public HashMap<String, Object> retrievePrjSearch(HashMap<String, Object> userMap){
    	return commonDao.select("prj.tss.com.retrievePrjSearch", userMap);
    }

    /**
	 * GRS Info 
	 * @param input
	 * @return
	 */
	public Map<String, Object> retrieveGenGrs(HashMap<String, String> input){
		
		String tssCd = input.get("pgTssCd");
		LOGGER.debug("retrieveGenGrs: " + input.get("tssCd") );
		
		return commonDao.select("prj.tss.com.retrieveGenGrs", tssCd);
	}
}