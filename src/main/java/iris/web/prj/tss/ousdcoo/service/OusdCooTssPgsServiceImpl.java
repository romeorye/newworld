package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : OusdCooTssPgsServiceImpl.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 진행(PGS) service Implements
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.19  IRIS04	최초생성
 *********************************************************************************/

@Service("ousdCooTssPgsService")
public class OusdCooTssPgsServiceImpl implements OusdCooTssPgsService {

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssPgsServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    /** 변경이력 **/
    @Override
    public List<Map<String, Object>> retrieveOusdCooTssPgsAltrHist(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.ousdcoo.pgs.retrieveOusdCooTssPgsAltrHist", input);
    }

    @Override
    public void deleteOusdTssOfTssCd(HashMap<String, String> input) {
        //참여연구원
        commonDao.delete("prj.tss.com.deleteTssPtcRsstMbrAllOfTssCd", input);
        //목표
        commonDao.delete("prj.tss.com.deleteTssGoalOfTssCd", input);
        //산출물
        commonDao.delete("prj.tss.com.deleteTssYldOfTssCd", input);
        //변경개요
        commonDao.delete("prj.tss.com.deleteTssSmryAltrListOfTssCd", input);
        //마스터
        commonDao.delete("prj.tss.com.deleteTssMstOfTssCd", input);

        //비용지급
        commonDao.delete("prj.tss.ousdcoo.deleteOusdCooTssExpStoa", input);
        //개요
        commonDao.delete("prj.tss.ousdcoo.deleteOusdCooTssSmryOfTssCd", input);

        //GRS 마스터
        commonDao.delete("prj.tss.gen.pln.deleteGenTssPlnMst2", input);
        //GRS 상세
        commonDao.delete("prj.tss.gen.pln.deleteGenTssPlnMst3", input);

        input.put("tssCd", input.get("pgTssCd"));

        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
    }
}
