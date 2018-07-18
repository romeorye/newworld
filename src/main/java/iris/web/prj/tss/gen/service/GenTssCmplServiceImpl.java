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
 * NAME : GenTssCmplServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("genTssCmplService")
public class GenTssCmplServiceImpl implements GenTssCmplService {

    static final Logger LOGGER = LogManager.getLogger(GenTssCmplServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    //마스터
    @Override
    public Map<String, Object> retrieveGenTssCmplMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public int insertGenTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs) {
        commonDao.insert("prj.tss.gen.cmpl.insertGenTssCmplMst", mstDs);

        smryDs.put("tssCd", mstDs.get("tssCd"));

        return this.insertGenTssCmplSmry(smryDs);
    }

    @Override
    public int updateGenTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs) {
        commonDao.update("prj.tss.gen.cmpl.updateGenTssCmplMst", mstDs);
        return this.updateGenTssCmplSmry(smryDs);
    }


    //개요
    @Override
    public Map<String, Object> retrieveGenTssCmplSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.gen.cmpl.retrieveGenTssCmplSmry", input);
    }

    @Override
    public int insertGenTssCmplSmry(HashMap<String, Object> input) {
        return commonDao.insert("prj.tss.gen.cmpl.insertGenTssCmplSmry", input);
    }

    @Override
    public int updateGenTssCmplSmry(HashMap<String, Object> input) {
        return commonDao.insert("prj.tss.gen.cmpl.updateGenTssCmplSmry", input);
    }


    //품의서
    @Override
    public Map<String, Object> retrieveGenTssCmplInfo(HashMap<String, String> input) {
        return commonDao.select("prj.tss.gen.cmpl.retrieveGenTssCmplInfo", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssCmplAttc(HashMap<String, String> input) {
        return commonDao.selectList("common.attachFile.getAttachFileList", input);
    }

    @Override
    public int insertGenTssCmplCsusRq(Map<String, Object> input) {
        return commonDao.insert("prj.tss.com.insertTssCsusRq", input);
    }
    
    //필수산출물 count	
    @Override
  	public String retrieveGenTssCmplCheck(HashMap<String, String> input){
  		String rtnMsg = "N";
  		
		//진척율
		int pgsVal = commonDao.select("prj.tss.gen.cmpl.retrieveGenTssCmplPgsCheck", input);
		LOGGER.debug("###########################pgsVal################################ : " + pgsVal);	
		if( pgsVal != 100 ) {
			rtnMsg = "P"; // "진척율값이 100이 아닙니다.";
			return rtnMsg;
		}
		//완료 필수항목 체크 (목표)
		String goalYn = commonDao.select("prj.tss.gen.cmpl.retrieveGenTssCmplGoalCheck", input);
		 LOGGER.debug("###########################goalCnt################################ : " + goalYn);	
    	if( goalYn.equals("N")){
    		rtnMsg = "G";  //"목표기술성과 실적값을 모두 입력하셔야 합니다.";
    		return rtnMsg;
    	}
    	//완료 필수항목 체크 (산출물)
    	String itmYn = commonDao.select("prj.tss.gen.cmpl.retrieveGenTssCmplItmCheck", input);
    	LOGGER.debug("###########################itmCnt################################ : " + itmYn);	
    	if( itmYn.equals("N")){
    		rtnMsg = "I";  //"필수산출물을 모두 등록하셔야 합니다.";
    		return rtnMsg;
    	}
		
		return rtnMsg; 
  	}
    
    
}
