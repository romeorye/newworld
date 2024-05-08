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
 * NAME : GenTssDcacServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("genTssDcacService")
public class GenTssDcacServiceImpl implements GenTssDcacService {

    static final Logger LOGGER = LogManager.getLogger(GenTssDcacServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    //마스터
    @Override
    public Map<String, Object> retrieveGenTssDcacMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public int insertGenTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap) {
        int rtCnt = commonDao.insert("prj.tss.gen.dcac.insertGenTssDcacMst", mstMap);
        if(rtCnt > 0) {
            smryMap.put("tssCd", mstMap.get("tssCd"));
            rtCnt += this.insertGenTssDcacSmry(smryMap);
        }
		//중단 산출물 연결
		smryMap.put("tssCd", mstMap.get("pgTssCd"));
		smryMap.put("yldItmType", "03");
		commonDao.update("prj.tss.com.updateYldFile", smryMap);

        return rtCnt;
    }

    @Override
    public int updateGenTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap) {
        int rtCnt = 0;

        rtCnt  = commonDao.update("prj.tss.gen.dcac.updateGenTssDcacMst", mstMap);
        rtCnt += this.updateGenTssDcacSmry(smryMap);

		//중단 산출물 연결
		smryMap.put("tssCd", mstMap.get("pgTssCd"));
		smryMap.put("yldItmType", "03");
		commonDao.update("prj.tss.com.updateYldFile", smryMap);
        return rtCnt;
    }


    //개요
    @Override
    public Map<String, Object> retrieveGenTssDcacSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.gen.dcac.retrieveGenTssDcacSmry", input);
    }

    @Override
    public int insertGenTssDcacSmry(HashMap<String, Object> input) {
        return commonDao.insert("prj.tss.gen.dcac.insertGenTssDcacSmry", input);
    }

    @Override
    public int updateGenTssDcacSmry(HashMap<String, Object> input) {
        return commonDao.insert("prj.tss.gen.dcac.updateGenTssDcacSmry", input);
    }


    //품의서
    @Override
    public Map<String, Object> retrieveGenTssDcacInfo(HashMap<String, String> input) {
        return commonDao.select("prj.tss.gen.dcac.retrieveGenTssDcacInfo", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssDcacAttc(HashMap<String, String> input) {
        return commonDao.selectList("common.attachFile.getAttachFileList", input);
    }

    @Override
    public int insertGenTssDcacCsusRq(Map<String, Object> input) {
        //        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
        return commonDao.insert("prj.tss.com.insertTssCsusRq", input);
    }

    /* 일반과제 중단 필수값 체크*/
	public String retrieveGenTssDcacCheck(HashMap<String, String> input){
		String rtnMsg ="N";

		//중단 필수항목 체크 (목표)
		String goalYn = commonDao.select("prj.tss.gen.dcac.retrieveGenTssDcacGoalCheck", input);
    	if( goalYn.equals("N")){
    		rtnMsg = "G"; // "목표기술성과 실적값을 모두 입력하셔야 합니다.";
    		return rtnMsg;
    	}
    	//중단 필수항목 체크 (산출물)
    	String itmYn = commonDao.select("prj.tss.gen.dcac.retrieveGenTssDcacItmCheck", input);
    	if( itmYn.equals("N")){
    		rtnMsg = "I"; //"필수산출물이 누락되었습니다.";
    		return rtnMsg;
    	}

		return rtnMsg;
	}
}
