package iris.web.prj.tss.gen.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : GenTssService.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

public interface GenTssPlnService {

    //마스터
    public Map<String, Object> retrieveGenTssPlnMst(HashMap<String, String> input);

    public Map<String, Object> retrieveDupChkWbsCd(HashMap<String, Object> input);

    public Map<String, Object> retrieveDupChkPkWbsCd(HashMap<String, Object> mstDs);

    public int updateGenTssMstWbsCd(HashMap<String, Object> mstDs);

    public int insertGenTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);

    public int updateGenTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, boolean upWbsCd);

    public int updateGenTssPlnMst(HashMap<String, Object> mstDs);

    void deleteGenTssPlnMst(HashMap<String, String> input);


    //개요
    public Map<String, Object> retrieveGenTssPlnSmry(HashMap<String, String> input);

    public int insertGenTssPlnSmry(HashMap<String, Object> input);

    public int updateGenTssPlnSmry(HashMap<String, Object> input);


    //참여연구원
    public List<Map<String, Object>> retrieveGenTssPlnPtcRsstMbr(HashMap<String, String> input);

    public int updateGenTssPlnPtcRsstMbr(List<Map<String, Object>> list);

    public int deleteGenTssPlnPtcRsstMbr(List<Map<String, Object>> list);


    //WBS
    public List<Map<String, Object>> retrieveGenTssPlnWBS(HashMap<String, String> input);

    public int updateGenTssPlnWBS(List<Map<String, Object>> input);

    public int deleteGenTssPlnWBS(List<Map<String, Object>> list);


    //투입예산
    public List<Map<String, Object>> retrieveGenTssPlnTrwiBudg(HashMap<String, String> input);

    public int insertGenTssPlnTrwiBudg(HashMap<String, Object> list);

    public List<Map<String, Object>> retrieveGenTssPlnTrwiBudgMst(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveGenTssPlnTssYy(HashMap<String, String> input);

    public int updateGenTssPlnTrwiBudgMst(List<Map<String, Object>> list);

    public int deleteGenTssPlnTrwiBudgMst(List<Map<String, Object>> list);


    //목표 및 산출물
    public List<Map<String, Object>> retrieveGenTssPlnGoal(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveGenTssPlnYld(HashMap<String, String> input);

    public int updateGenTssPlnGoal(List<Map<String, Object>> input);

    public int updateGenTssPlnYld(List<Map<String, Object>> input);

    public int deleteGenTssPlnGoal(List<Map<String, Object>> input);

    public int deleteGenTssPlnYld(List<Map<String, Object>> input);

    public Map<String, Object> getGenTssPlnTrwiBudgInfo(HashMap<String, Object> input);


    //품의서
    public List<Map<String, Object>> retrieveGenTssPlnBudgGroupYy(HashMap<String, String> input, List<Map<String, Object>> resultTssYy);

    public int insertGenTssPlnCsusRq(Map<String, Object> map);



    public int updateGenTssPlnMstTssSt(Map<String, Object> map);
    //메일발송
    public List<Map<String, Object>> retrieveSendAddrTssGrsPL(HashMap<String, Object> input);

    public void retrieveSendMail(HashMap<String, Object> input);






}