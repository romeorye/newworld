package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.prj.tss.gen.service.GenTssCmplService;

/*********************************************************************************
 * NAME : OusdCooTssCmplServiceImpl.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 완료(Cmpl) service Implements
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.21  IRIS04	최초생성
 *********************************************************************************/

@Service("ousdCooTssCmplService")
public class OusdCooTssCmplServiceImpl implements OusdCooTssCmplService {

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssCmplServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Resource(name="genTssCmplService")
    private GenTssCmplService genTssCmplService;	// 일반과제 완료 서비스

    /** 대외협력 완료 마스터 복사, 개요 복사 후 업데이트 **/
    @Override
    public int insertOusdCooTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs) {
        // 기존 마스터 복사 + 완료후개발기간 입력
        commonDao.insert("prj.tss.gen.cmpl.insertGenTssCmplMst", mstDs);

        // 기존 개요복사
        smryDs.put("tssCd"   , mstDs.get("tssCd"));
        smryDs.put("pgTssCd" , mstDs.get("pgTssCd"));
        commonDao.insert("prj.tss.ousdcoo.insertCopyOusdCooTssSmry", smryDs);

        // 개요 완료내용 업데이트
        commonDao.update("prj.tss.ousdcoo.updateOusdCooTssCmplSmry", smryDs);

        // 기존(진행) 비용지급실적 복사
        commonDao.insert("prj.tss.ousdcoo.insertCopyOusdCooTssExpStoa", smryDs);

        return 1;
    }

    /** 대외협력 완료 마스터, 개요 수정 **/
    @Override
    public int updateOusdCooTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, boolean upWbsCd) {
        // 마스터 완료후개발기간 수정
        commonDao.update("prj.tss.gen.cmpl.updateGenTssCmplMst", mstDs);

        // 개요 완료내용 업데이트
        commonDao.update("prj.tss.ousdcoo.updateOusdCooTssCmplSmry", smryDs);

        return 1;
    }

    /** 대외협력 완료 필수값 체크*/
    @Override
   	public String retrieveOusdCooTssCmplCheck(HashMap<String, String> input){
    	String rtnMsg = "N";

    	//완료 필수항목 체크 (목표)
		String goalYn = commonDao.select("prj.tss.ousdcoo.retrieveOusdCooTssCmplGoalCheck", input);
	  	if( goalYn.equals("N")){
	  		rtnMsg = "G"; //"목표기술성과 실적값을 모두 입력하셔야 합니다.";
	  		return rtnMsg;
	  	}

	  	//완료 필수항목 체크 (산출물)
	  	String itmYn = commonDao.select("prj.tss.ousdcoo.retrieveOusdCooTssCmplItmCheck", input);
	  	if( itmYn.equals("N")){
	  		rtnMsg = "I"; //"필수산출물을 모두 등록하셔야 합니다.";
	  		return rtnMsg;
	  	}

		return rtnMsg;
    }
}
