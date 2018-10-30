package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


/*********************************************************************************
 * NAME : OusdCooTssDcacServiceImpl.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 중단(Dcac) service Implements
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.26  IRIS04	최초생성
 *********************************************************************************/

@Service("ousdCooTssDcacService")
public class OusdCooTssDcacServiceImpl implements OusdCooTssDcacService {

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssDcacServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    /** 중단 신규등록(마스터 복사,중단개요 저장) **/
    @Override
    public int insertOusdCooTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap) {
	int rtCnt = commonDao.insert("prj.tss.gen.dcac.insertGenTssDcacMst", mstMap);

        if(rtCnt > 0) {
            smryMap.put("tssCd", mstMap.get("tssCd"));
            rtCnt += this.insertOusdCooTssDcacSmry(smryMap);
        }
	return rtCnt;
    }

    /** 중단 수정(마스터,중단개요 수정) **/
    @Override
    public int updateOusdCooTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap) {
        int rtCnt = 0;

        rtCnt  = commonDao.update("prj.tss.gen.dcac.updateGenTssDcacMst", mstMap);
        rtCnt += this.updateOusdCooTssDcacSmry(smryMap);

        return rtCnt;
    }

    /** 중단개요 등록 **/
    @Override
    public int insertOusdCooTssDcacSmry(HashMap<String, Object> input) {
        return commonDao.insert("prj.tss.ousdcoo.dcac.insertOusdCooTssDcacSmry", input);
    }
    /** 중단개요 수정 **/
    @Override
    public int updateOusdCooTssDcacSmry(HashMap<String, Object> input) {
        return commonDao.insert("prj.tss.ousdcoo.dcac.updateOusdCooTssDcacSmry", input);
    }

    /** 중단 필수값 체크*/
    @Override
	public String retrieveOusdCooTssDcacCheck(HashMap<String, String> input){
    	String rtnMsg = "N";

		//완료 필수항목 체크 (목표)
		String goalYn = commonDao.select("prj.tss.ousdcoo.dcac.retrieveOusdCooTssDcacCheck", input);
    	if( goalYn.equals("N")){
    		rtnMsg = "G"; //"목표기술성과 실적값을 전부 입력하셔야 합니다.";
    	}

		return rtnMsg;
	}

/*
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

	    return rtCnt;
    }

    @Override
    public int updateGenTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap) {
        int rtCnt = 0;

        rtCnt  = commonDao.update("prj.tss.gen.dcac.updateGenTssDcacMst", mstMap);
        rtCnt += this.updateGenTssDcacSmry(smryMap);

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
        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
        return commonDao.insert("prj.tss.com.insertTssCsusRq", input);
    }*/
}
