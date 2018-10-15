package iris.web.prj.tss.gen.service;

import devonframe.dataaccess.CommonDao;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

}