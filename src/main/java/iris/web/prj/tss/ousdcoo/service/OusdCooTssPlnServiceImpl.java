package iris.web.prj.tss.ousdcoo.service;

import java.util.Calendar;
import java.util.HashMap;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


/*********************************************************************************
 * NAME : OusdCooTssPlnServiceImpl.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 계획(Pln) service implements
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.18  IRIS04	최초생성
 *********************************************************************************/

@Service("ousdCooTssPlnService")
public class OusdCooTssPlnServiceImpl implements OusdCooTssPlnService {

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssPlnServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    /** 대외협력 계획 마스터, 개요 입력 **/
    @Override
    public int insertOusdCooTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs) {
        commonDao.insert("prj.tss.com.insertTssMst", mstDs);

        smryDs.put("tssCd" ,mstDs.get("tssCd"));
        commonDao.insert("prj.tss.ousdcoo.insertOusdCooTssSmry", smryDs);

        //필수산출물 생성
        if(!"".equals(String.valueOf(smryDs.get("attcFilId")))) {
            Calendar cal = Calendar.getInstance();

            int year = cal.get(Calendar.YEAR);
            int yy   = cal.get(Calendar.MONTH) + 1;

            smryDs.put("goalY",      year);
            smryDs.put("yldItmType", "01");
            smryDs.put("arslYymm",   year + "-" + yy);

            commonDao.update("prj.tss.com.updateTssYld", smryDs);
        }

        return 1;
    }

    /** 대외협력 계획 마스터, 개요 수정 **/
    @Override
    public int updateOusdCooTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, boolean upWbsCd) {
        commonDao.update("prj.tss.com.updateTssMst", mstDs);
        commonDao.update("prj.tss.ousdcoo.updateOusdCooTssPlnSmry", smryDs);

        return 1;
    }

}