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
 * NAME : GenTssPgsServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("genTssPgsService")
public class GenTssPgsServiceImpl implements GenTssPgsService {

    static final Logger LOGGER = LogManager.getLogger(GenTssPgsServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    //마스터
    @Override
    public Map<String, Object> retrieveGenTssPgsMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public Map<String, Object> retrieveGenTssPtcMbrCnt(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssPtcMbrCnt", input);
    }

    @Override
    public Map<String, Object> retrieveGenTssAltrMst(HashMap<String, String> input) {
        Map<String, Object> resultMst = commonDao.select("prj.tss.com.retrieveTssMst", input); //마스터조회
        Map<String, Object> resultMbr = commonDao.select("prj.tss.com.retrieveTssPtcMbrCnt", input); //참여인원수 조회

        resultMst.put("mbrCnt", resultMbr.get("mbrCnt"));

        return resultMst;
    }

    @Override
    public void deleteGenTssOfTssCd(HashMap<String, String> input) {
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
        commonDao.delete("prj.tss.gen.deleteGenTssSmryOfTssCd", input);
        //WBS
        commonDao.delete("prj.tss.gen.deleteGenTssWbsOfTssCd", input);

        //GRS 마스터
        commonDao.delete("prj.tss.gen.pln.deleteGenTssPlnMst2", input);
        //GRS 상세
        commonDao.delete("prj.tss.gen.pln.deleteGenTssPlnMst3", input);

        input.put("tssCd", input.get("pgTssCd"));

        commonDao.update("prj.tss.com.updateTssMstTssSt", input);

        //사업비
        commonDao.delete("prj.tss.gen.deleteGenTssBudgMstOfTssCd", input);
        //사업비목록
        commonDao.delete("prj.tss.gen.deleteGenTssBudgListOfTssCd", input);

        input.put("pgTssCd", String.valueOf(input.get("tssCd")).substring(0, 9)+"1");

        //사업비
        commonDao.delete("prj.tss.gen.altr.insertGenTssTrwlBudgMst", input);
        //사업비목록
        commonDao.delete("prj.tss.gen.altr.insertGenTssTrwlBudgList", input);
    }


    //개요
    @Override
    public Map<String, Object> retrieveGenTssPgsSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.gen.retrieveGenTssSmry", input);
    }



    //참여연구원
    @Override
    public List<Map<String, Object>> retrieveGenTssPgsPtcRsstMbr(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.gen.pgs.retrieveGenTssPgsPtcRsstMbr", input);
    }



    //WBS
    @Override
    public List<Map<String, Object>> retrieveGenTssPgsWBS(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.gen.pgs.retrieveGenTssPgsWBS", input);
    }

    @Override
    public int updateGenTssPgsWBS(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.gen.updateGenTssWBS", input);
    }



    //투입예산
    @Override
    public List<Map<String, Object>> retrieveGenTssPgsTrwiBudg(HashMap<String, String> input) {

        String choiceYm = input.get("choiceYm");
        String tssYy = "";

        String pivotTitle = "[";
        String pivotSum = "ISNULL([";
        String unionTitle = "ROUND([";
        String unionSum = "ROUND(SUM([";

        if("yy".equals(choiceYm)) {
            List<Map<String, Object>> rtList = commonDao.selectList("prj.tss.com.retrieveTssTssYy", input);

            for(int i = 0; i < rtList.size(); i++) {
                tssYy = (String)rtList.get(i).get("tssYy");

                pivotTitle += tssYy + "],[";
                pivotSum   += tssYy + "],0)+ISNULL([";
                unionTitle += tssYy + "],2) AS '" + tssYy + "',ROUND([";
                unionSum   += tssYy + "]),2),ROUND(SUM([";
            }
        }
        else if("mm".equals(choiceYm)) {
            tssYy = input.get("tssYy");
            String mm = "";

            for(int i = 1; i <= 12; i++) {
                if(i < 10) {
                    mm = "0" + String.valueOf(i);
                } else {
                    mm = String.valueOf(i);
                }

                pivotTitle += tssYy + mm + "],[";
                pivotSum   += tssYy + mm + "],0)+ISNULL([";
                unionTitle += tssYy + mm + "],2) AS '" + mm + "',ROUND([";
                unionSum   += tssYy + mm + "]),2),ROUND(SUM([";
            }

        }

        pivotTitle = pivotTitle.substring(0, pivotTitle.length() - 2);
        pivotSum   = pivotSum.substring(0, pivotSum.length() - 9);
        unionTitle = unionTitle.substring(0, unionTitle.length() - 8);
        unionSum   = unionSum.substring(0, unionSum.length() - 12);

        input.put("pivotTitle", pivotTitle);
        input.put("pivotSum",   pivotSum);
        input.put("unionTitle", unionTitle);
        input.put("unionSum",   unionSum);

        return commonDao.selectList("prj.tss.gen.pgs.retrieveGenTssPgsTrwiBudg", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssPgsTssYy(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssTssYy", input);
    }



    //목표 및 산출물
    @Override
    public List<Map<String, Object>> retrieveGenTssPgsGoal(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssGoal", input);
    }

    @Override
    public int updateGenTssPgsGoal(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssGoal", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssPgsYld(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssYld", input);
    }

    @Override
    public int updateGenTssPgsYld(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssYld", input);
    }



    //변경이력
    @Override
    public List<Map<String, Object>> retrieveGenTssPgsAltrHist(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.gen.pgs.retrieveGenTssPgsAltrHist", input);
    }
    
    /* 변경이력 상세리스트 조회*/
	public List<Map<String, Object>> retrieveGenTssAltrList(HashMap<String, Object> input){
		return commonDao.selectList("prj.tss.gen.pgs.retrieveGenTssAltrList", input);
	}

	/* 변경이력 상세 조회*/
	public Map<String, Object> genTssAltrDetailSearch(HashMap<String, Object> input){
		return commonDao.select("prj.tss.gen.pgs.genTssAltrDetailSearch", input);
	}
}
