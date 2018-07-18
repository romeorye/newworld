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
 * NAME : NatTssCmplServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("natTssCmplService")
public class NatTssCmplServiceImpl implements NatTssCmplService {

    static final Logger LOGGER = LogManager.getLogger(NatTssCmplServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    //마스터
    @Override
    public Map<String, Object> retrieveNatTssCmplMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }


    @Override
    public Map<String, Object> retrieveNatTssCmplSmryInfo(Map<String, Object> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssSmryInfo", input);
    }

    @Override
    public int insertNatTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs) {
        commonDao.update("prj.tss.nat.cmpl.updateNatTssCmplMst", mstDs);
        commonDao.insert("prj.tss.nat.cmpl.insertNatTssCmplSmry", smryDs);

        return 1;
    }

    @Override
    public int updateNatTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs) {
        commonDao.update("prj.tss.nat.cmpl.updateNatTssCmplMst", mstDs);
        commonDao.insert("prj.tss.nat.cmpl.updateNatTssCmplSmry", smryDs);

        return 1;
    }


    //완료개요
    @Override
    public Map<String, Object> retrieveNatTssCmplSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssPlnSmry", input);
    }


    //품의서
    @Override
    public Map<String, Object> retrieveNatTssCmplInfo(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.cmpl.retrieveNatTssCmplInfo", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssCmplTrwiBudg(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.cmpl.retrieveNatTssCmplTrwiBudg", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssCmplAttc(HashMap<String, String> input) {
        return commonDao.selectList("common.attachFile.getAttachFileList", input);
    }

    @Override
    public int insertNatTssCmplCsusRq(Map<String, Object> input) {
        //        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
        return commonDao.insert("prj.tss.com.insertTssCsusRq", input);
    }

    @Override
    public Map<String, Object> retrieveNatTssCmplStoa(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssStoa", input);
    }
    
    /* wjdtks cjaqnvkdlf*/
    @Override
    public String retrieveNatTssStoal(HashMap<String, String> input){
    	return commonDao.select("prj.tss.nat.retrieveNatTssStoal", input);
    }
    
    /* 국책과제 완료 필수값 체크*/
	@Override
	public String retrieveNatTssCmplCheck(HashMap<String, String> input){
		String rtnMsg = "N";
		
	  	//완료 필수항목 체크 (연구비 카드정보)
	  	String cardYn = commonDao.select("prj.tss.nat.cmpl.retrieveNatTssCmplCardCheck", input);
	  	//LOGGER.debug("###########################cardYn################################ : " + cardYn);	
	  	if( cardYn.equals("N") ){
	  		rtnMsg = "C"; //연구비카드가 1건이상이어야 합니다.";
	  		return rtnMsg;
	  	}
			  	
		if(input.get("flnYn").equals("Y")){
			//완료 필수항목 체크 (산출물)
	    	String itmYn = commonDao.select("prj.tss.nat.cmpl.retrieveNatTssCmplItmCheck", input);
	    	//LOGGER.debug("###########################itmCnt################################ : " + itmYn);	
	    	if( itmYn.equals("N")){
	    		rtnMsg = "I"; //"필수산출물을 모두 등록하셔야 합니다.";
	    		return rtnMsg;
	    	}
	    	
	    	//완료 필수항목 체크 (목표)
			String goalYn = commonDao.select("prj.tss.nat.cmpl.retrieveNatTssCmplCheck", input);
			//LOGGER.debug("###########################goalCnt################################ : " + goalYn);	
		  	if( goalYn.equals("N")){
		  		rtnMsg = "G"; //"목표기술성과 실적값을 모두 입력하셔야 합니다.";
		  		return rtnMsg;
		  	}
		}
		
		return rtnMsg;
	}
}
