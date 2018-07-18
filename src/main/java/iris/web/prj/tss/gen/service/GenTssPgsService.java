package iris.web.prj.tss.gen.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : GenTssPgsService.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

public interface GenTssPgsService {

    //마스터
    public Map<String, Object> retrieveGenTssPgsMst(HashMap<String, String> input);

    public void deleteGenTssOfTssCd(HashMap<String, String> input);

    public Map<String, Object> retrieveGenTssPtcMbrCnt(HashMap<String, String> input);

    public Map<String, Object> retrieveGenTssAltrMst(HashMap<String, String> input);


    //개요
    public Map<String, Object> retrieveGenTssPgsSmry(HashMap<String, String> input);


    //참여연구원
    public List<Map<String, Object>> retrieveGenTssPgsPtcRsstMbr(HashMap<String, String> input);


    //WBS
    public List<Map<String, Object>> retrieveGenTssPgsWBS(HashMap<String, String> input);

    public int updateGenTssPgsWBS(List<Map<String, Object>> input);


    //투입예산
    public List<Map<String, Object>> retrieveGenTssPgsTrwiBudg(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveGenTssPgsTssYy(HashMap<String, String> input);


    //목표 및 산출물
    public List<Map<String, Object>> retrieveGenTssPgsGoal(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveGenTssPgsYld(HashMap<String, String> input);

    public int updateGenTssPgsGoal(List<Map<String, Object>> input);

    public int updateGenTssPgsYld(List<Map<String, Object>> input);


    //변경이력
    public List<Map<String, Object>> retrieveGenTssPgsAltrHist(HashMap<String, String> input);

    /* 변경이력 상세리스트 조회*/
	public List<Map<String, Object>> retrieveGenTssAltrList(HashMap<String, Object> input);

	/* 변경이력 상세 조회*/
	public Map<String, Object> genTssAltrDetailSearch(HashMap<String, Object> input);
}
