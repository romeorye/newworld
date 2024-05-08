package iris.web.prj.tss.nat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : NatTssCmplService.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

public interface NatTssCmplService {

    //마스터
    public Map<String, Object> retrieveNatTssCmplMst(HashMap<String, String> input);

    public Map<String, Object> retrieveNatTssCmplSmryInfo(Map<String, Object> result);

    public int insertNatTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);

    public int updateNatTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);


    //완료개요
    public Map<String, Object> retrieveNatTssCmplSmry(HashMap<String, String> input);


    //품의서
    public Map<String, Object> retrieveNatTssCmplInfo(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssCmplTrwiBudg(HashMap<String, String> inputInfo);

    public List<Map<String, Object>> retrieveNatTssCmplAttc(HashMap<String, String> inputInfo);

    public int insertNatTssCmplCsusRq(Map<String, Object> map);

    public Map<String, Object> retrieveNatTssCmplStoa(HashMap<String, String> inputInfo);

    /* 정산 첨부파일 */
	public String retrieveNatTssStoal(HashMap<String, String> input);

	/* 국책과제 완료 필수값 체크*/
	public String retrieveNatTssCmplCheck(HashMap<String, String> input);
}
