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

public interface GenTssService {

    List<Map<String, Object>> retrieveGenTssList(HashMap<String, Object> input);

    List<Map<String, Object>> retrieveTssPopupList(HashMap<String, String> input);

    List<Map<String, Object>> retrieveChargeMbr(String input);

    HashMap<String, Object> getWbsCdStd(String string, HashMap<String, Object> mstDs);

    HashMap<String, Object> getTssCd(HashMap<String, Object> input);

    void insertGenTssCsusRq(Map<String, Object> map);

    void updateGenTssCsusRq(Map<String, Object> map);

    Map<String, Object> retrieveGenTssCsus(Map<String, Object> resultMst);

    public Map<String, Object> getTssRegistCnt(HashMap<String, String> input);

    /* 중단, 완료 참가 연구원 수 조회*/
	Map<String, Object> retrieveCmDcTssPtcMbrCnt(HashMap<String, String> input);
	
	public HashMap<String, Object> retrievePrjSearch(HashMap<String, Object> userMap);

	/**
	 * GRS Info 
	 * @param input
	 * @return
	 */
	public Map<String, Object> retrieveGenGrs(HashMap<String, String> input);
}