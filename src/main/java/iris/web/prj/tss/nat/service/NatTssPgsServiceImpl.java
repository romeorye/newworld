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
 * NAME : NatTssPgsServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("natTssPgsService")
public class NatTssPgsServiceImpl implements NatTssPgsService {

    static final Logger LOGGER = LogManager.getLogger(NatTssPgsServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    //마스터
    @Override
    public Map<String, Object> retrieveNatTssPgsMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public Map<String, Object> retrieveNatTssPgsCsus(HashMap<String, String> input) {

        commonDao.update("prj.tss.com.updateTssMstTssSt", input); //과제상태변경
        commonDao.insert("prj.tss.nat.pgs.insertNatTssMst", input); //마스터 신규
        Map<String, Object> resultMst = commonDao.select("prj.tss.com.retrieveTssMst", input); //마스터조회

        return resultMst;
    }

    @Override
    public void deleteNenTssOfTssCd(HashMap<String, String> input) {
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

        //개요
        commonDao.delete("prj.tss.nat.deleteNatTssSmryOfTssCd", input);
        //개요수행기관
        commonDao.delete("prj.tss.nat.deleteNatTssPlnSmryCrroOfTssCd", input);
        //사업비
        commonDao.delete("prj.tss.nat.deleteNatTssTrwiBudgOfTssCd", input);

        //GRS 마스터
        commonDao.delete("prj.tss.gen.pln.deleteGenTssPlnMst2", input);
        //GRS 상세
        commonDao.delete("prj.tss.gen.pln.deleteGenTssPlnMst3", input);

        input.put("tssCd", input.get("pgTssCd"));

        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
    }


    //개요
    @Override
    public Map<String, Object> retrieveNatTssPgsSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssPlnSmry", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssNosYmd(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.retrieveNatTssNosYmd", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssPgsSmryInst(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.retrieveSmryCrroInstList", input);
    }


    //개발비
    @Override
    public List<Map<String, Object>> retrieveNatTssPgsTssYy(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssTssYy", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssPgsTrwiBudg(HashMap<String, String> input) {
        return  commonDao.selectList("prj.tss.nat.retrieveNatTssPlnTrwiBudg", input);
    }



    //목표 및 산출물
    @Override
    public List<Map<String, Object>> retrieveNatTssPgsGoal(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssGoal", input);
    }

    @Override
    public int updateNatTssPgsGoal(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssGoal", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssPgsYld(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssYld", input);
    }

    @Override
    public int updateNatTssPgsYld(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssYld", input);
    }


    //투자품목목록
    @Override
    public List<Map<String, Object>> retrieveNatTssPgsIvst(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.pgs.retrieveNatTssPgsIvst", input);
    }

    @Override
    public Map<String, Object> retrieveNatTssPgsIvstDtl(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.pgs.retrieveNatTssPgsIvst", input);
    }

    @Override
    public int updateNatTssPgsIvst(Map<String, Object> ds) {
        return commonDao.update("prj.tss.nat.pgs.updateNatTssPgsIvst", ds);
    }

    @Override
    public int deleteNatTssPgsIvst(Map<String, Object> ds) {
        return commonDao.delete("prj.tss.nat.pgs.deleteNatTssPgsIvst", ds);
    }


    //연구비카드
    @Override
    public List<Map<String, Object>> retrieveNatTssPgsCrd(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.pgs.retrieveNatTssPgsCrd", input);
    }

    @Override
    public Map<String, Object> retrieveNatTssPgsCrdDtl(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.pgs.retrieveNatTssPgsCrd", input);
    }

    @Override
    public int updateNatTssPgsCrd(Map<String, Object> ds) {
        return commonDao.update("prj.tss.nat.pgs.updateNatTssPgsCrd", ds);
    }

    @Override
    public int deleteNatTssPgsCrd(Map<String, Object> ds) {
        return commonDao.delete("prj.tss.nat.pgs.deleteNatTssPgsCrd", ds);
    }


    //변경이력
    @Override
    public List<Map<String, Object>> retrieveNatTssPgsAltrHist(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.pgs.retrieveNatTssPgsAltrHist", input);
    }


    //참여연구원
    @Override
    public List<Map<String, Object>> retrieveNatTssPgsPtcRsstMbr(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.pgs.retrieveNatTssPgsPtcRsstMbr", input);
    }
    
    /* 변경이력 리스트*/
	public List<Map<String, Object>> retrieveNatTssAltrList(HashMap<String, Object> input){
		return commonDao.selectList("prj.tss.nat.pgs.retrieveNatTssAltrList", input);
	}

	/* 변경이력 내용*/
	public Map<String, Object> natTssAltrDetailSearch(HashMap<String, Object> input){
		return commonDao.select("prj.tss.nat.pgs.natTssAltrDetailSearch", input);
	}

}
