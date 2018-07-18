package iris.web.prj.tss.nat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : NatTssService.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

public interface NatTssAltrService {

    //마스터
    public Map<String, Object> retrieveNatTssAltrMst(HashMap<String, String> input);

    public Map<String, Object> retrieveNatTssAltrSmryInfo(Map<String, Object> result);

    public int insertNatTssAltrMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs, boolean upWbsCd);

    public int updateNatTssAltrMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs, boolean upWbsCd);


    //변경개요
    public Map<String, Object> retrieveNatTssAltrSmry(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssAltrSmryList(HashMap<String, String> input);


    //개요
    public int updateNatTssAltrSmry2(HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs);

    public List<Map<String, Object>> retrieveNatTssNosYmd(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssAltrSmryInst(HashMap<String, String> input);


    //사업비
    public List<Map<String, Object>> retrieveNatTssAltrTrwiBudg(HashMap<String, String> input);

    public int updateNatTssAltrTrwiBudg(List<Map<String, Object>> input);


    //참여연구원
    public List<Map<String, Object>> retrieveNatTssAltrPtcRsstMbr(HashMap<String, String> input);

    public int updateNatTssAltrPtcRsstMbr(List<Map<String, Object>> list);

    public int deleteNatTssAltrPtcRsstMbr(List<Map<String, Object>> list);


    //목표 및 산출물
    public List<Map<String, Object>> retrieveNatTssAltrGoal(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssAltrYld(HashMap<String, String> input);

    public int updateNatTssAltrGoal(List<Map<String, Object>> input);

    public int updateNatTssAltrYld(List<Map<String, Object>> input);

    public int deleteNatTssAltrGoal(List<Map<String, Object>> input);

    public int deleteNatTssAltrYld(List<Map<String, Object>> input);


    //품의서
    public List<Map<String, Object>> retrieveNatTssAltrAttc(HashMap<String, String> input);

    public Map<String, Object> retrieveNatTssAltrInfo(HashMap<String, String> inputInfo);

    public int insertNatTssAltrCsusRq(Map<String, Object> input);
    /**
     * 개요 update
     * @param input
     */
    public void updateNatTssSmryToSelect(Map<String, Object> input);
    /**
     * 예산 update
     * @param input
     */
    public void updateNatTssTrwiBudgSelect(Map<String, Object> input);
    /**
     * 개요 수행기관
     * @param input
     */
    public void updateNatTssSmryCrroToSelect(Map<String, Object> input);







}