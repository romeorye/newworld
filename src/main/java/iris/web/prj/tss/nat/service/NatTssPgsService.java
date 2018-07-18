package iris.web.prj.tss.nat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : NatTssPgsService.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

public interface NatTssPgsService {

    //마스터
    public Map<String, Object> retrieveNatTssPgsMst(HashMap<String, String> input);

    public Map<String, Object> retrieveNatTssPgsCsus(HashMap<String, String> input);

    public void deleteNenTssOfTssCd(HashMap<String, String> input);

    //개요
    public Map<String, Object> retrieveNatTssPgsSmry(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssNosYmd(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssPgsSmryInst(HashMap<String, String> input);


    //사업비
    public List<Map<String, Object>> retrieveNatTssPgsTrwiBudg(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssPgsTssYy(HashMap<String, String> input);


    //목표 및 산출물
    public List<Map<String, Object>> retrieveNatTssPgsGoal(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssPgsYld(HashMap<String, String> input);

    public int updateNatTssPgsGoal(List<Map<String, Object>> input);

    public int updateNatTssPgsYld(List<Map<String, Object>> input);


    //투자품목목록
    public List<Map<String, Object>> retrieveNatTssPgsIvst(HashMap<String, String> input);

    public Map<String, Object> retrieveNatTssPgsIvstDtl(HashMap<String, String> input);

    public int updateNatTssPgsIvst(Map<String, Object> ds);

    public int deleteNatTssPgsIvst(Map<String, Object> ds);


    //연구비카드
    public List<Map<String, Object>> retrieveNatTssPgsCrd(HashMap<String, String> input);

    public Map<String, Object> retrieveNatTssPgsCrdDtl(HashMap<String, String> input);

    public int updateNatTssPgsCrd(Map<String, Object> ds);

    public int deleteNatTssPgsCrd(Map<String, Object> ds);


    //변경이력
    public List<Map<String, Object>> retrieveNatTssPgsAltrHist(HashMap<String, String> input);


    //참여연구원
    public List<Map<String, Object>> retrieveNatTssPgsPtcRsstMbr(HashMap<String, String> input);

    /* 변경이력 리스트*/
	public List<Map<String, Object>> retrieveNatTssAltrList(HashMap<String, Object> input);

	/* 변경이력 내용*/
	public Map<String, Object> natTssAltrDetailSearch(HashMap<String, Object> input);

}
