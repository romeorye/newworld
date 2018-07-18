package iris.web.prj.tss.nat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


/*********************************************************************************
 * NAME : NatTssDcacServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("natTssDcacService")
public class NatTssDcacServiceImpl implements NatTssDcacService {

    static final Logger LOGGER = LogManager.getLogger(NatTssDcacServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    //마스터
    @Override
    public Map<String, Object> retrieveNatTssDcacMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public Map<String, Object> retrieveNatTssDcacSmryInfo(Map<String, Object> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssSmryInfo", input);
    }

    @Override
    public int insertNatTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap) {
        commonDao.update("prj.tss.nat.dcac.updateNatTssDcacMst", mstMap);
        commonDao.insert("prj.tss.nat.dcac.insertNatTssDcacSmry", smryMap);

        return 1;
    }

    @Override
    public int updateNatTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap) {
        commonDao.update("prj.tss.nat.dcac.updateNatTssDcacMst", mstMap);
        commonDao.insert("prj.tss.nat.dcac.updateNatTssDcacSmry", smryMap);

        return 1;
    }


    //중단개요
    @Override
    public Map<String, Object> retrieveNatTssDcacSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssPlnSmry", input);
    }


    //품의서
    @Override
    public Map<String, Object> retrieveNatTssDcacInfo(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.dcac.retrieveNatTssDcacInfo", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssDcacAttc(HashMap<String, String> input) {
        return commonDao.selectList("common.attachFile.getAttachFileList", input);
    }

    @Override
    public int insertNatTssDcacCsusRq(Map<String, Object> input) {
        //        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
        return commonDao.insert("prj.tss.com.insertTssCsusRq", input);
    }

    @Override
    public Map<String, Object> retrieveNatTssDcacStoa(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssStoa", input);
    }
    
    @Override
    public String retrieveNatTssDcacCheck(HashMap<String, String> input){
    	String rtnMsg = "N";
    	
    	//완료 필수항목 체크 (목표)
		String goalYn = commonDao.select("prj.tss.nat.dcac.retrieveNatTssDcacCheck", input);
		LOGGER.debug("###########################goalCnt################################ : " + goalYn);	
	  	if( goalYn.equals("N")){
	  		rtnMsg = "G"; //"목표기술성과 실적값을 모두 입력하셔야 합니다.";
	  		return rtnMsg;
	  	}
	  	
	  	return rtnMsg; 	  	
    }
}
