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

public interface GenTssAltrService {

    //마스터
    public Map<String, Object> getMstStatusOfAltr(HashMap<String, String> input);

    public Map<String, Object> retrieveGenTssAltrMst(HashMap<String, String> input);

    public Map<String, Object> retrieveGenTssPtcMbrCnt(HashMap<String, String> input);

    public Map<String, Object> retrieveDupChkWbsCd(HashMap<String, Object> mstDs);

    public int insertGenTssAltrMst(HashMap<String, Object> input, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs, boolean upWbsCd);

    public int updateGenTssAltrMst(HashMap<String, Object> input, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs, boolean upWbsCd);


    //변경개요
    public Map<String, Object> retrieveGenTssAltrSmry(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveGenTssAltrSmryList(HashMap<String, String> input);

    public int insertGenTssAltrSmry(HashMap<String, Object> input, List<Map<String, Object>> altrDs);

    public int updateGenTssAltrSmry1(HashMap<String, Object> input, List<Map<String, Object>> altrDs);

    public int updateGenTssAltrSmry2(HashMap<String, Object> input);



    //참여연구원
    public List<Map<String, Object>> retrieveGenTssAltrPtcRsstMbr(HashMap<String, String> input);

    public int updateGenTssAltrPtcRsstMbr(List<Map<String, Object>> list);

    public int deleteGenTssAltrPtcRsstMbr(List<Map<String, Object>> list);


    //WBS
    public List<Map<String, Object>> retrieveGenTssAltrWBS(HashMap<String, String> input);

    public int updateGenTssAltrWBS(List<Map<String, Object>> input);

    public int deleteGenTssAltrWBS(List<Map<String, Object>> list);


    //투입예산
    public void insertGenTssAltrTrwiBudg(HashMap<String, Object> input);


    //목표 및 산출물
    public List<Map<String, Object>> retrieveGenTssAltrGoal(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveGenTssAltrYld(HashMap<String, String> input);

    public int updateGenTssAltrGoal(List<Map<String, Object>> input);

    public int updateGenTssAltrYld(List<Map<String, Object>> input);

    public int deleteGenTssAltrGoal(List<Map<String, Object>> input);

    public int deleteGenTssAltrYld(List<Map<String, Object>> input);


    //품의서
    public List<Map<String, Object>> retrieveGenTssAltrAttc(HashMap<String, String> input);

    public int insertGenTssAltrCsusRq(Map<String, Object> input);





    //변경후 진행에 update

    /*
     * IRIS_TSS_MGMT_MST		- 과제관리마스터
     */
    public int updateGenTssMgmtMstToSelect(Map<String, Object> input);
    /*
     * IRIS_TSS_GEN_SMRY 		- 일반과제 개요
     */
    public int updateGenTssSmryToSelect(Map<String, Object> input);
    /*
     * IRIS_TSS_PTC_RSST_MBR 	- 과제참여연구원
     */
    public int updateGenTssPtcRssMbrToSelect(Map<String, Object> input);
    /*
     * IRIS_TSS_GEN_WBS 		- 일반과제WBS
     */
    public int updateGenTssWbsToSelect(Map<String, Object> input);
    /*
     * IRIS_TSS_GOAL_ARSL 		- 과제목표/실적
     */
    public int updateGenTssGoalArslToSelect(Map<String, Object> input);
    /*
     * IRIS_TSS_YLD_ITM		- 과제산출물
     */
    public int updateGenTssYldItmToSelect(Map<String, Object> input);

    
    
    
    
    /**
     *  변경개요 탭 정보 
     * @param input
     * @return
     */
	public Map<String, Object> retrieveGenTssAltrInfo(HashMap<String, String> input);











}