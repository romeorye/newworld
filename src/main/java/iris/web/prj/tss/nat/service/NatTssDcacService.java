package iris.web.prj.tss.nat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : NatTssDcacService.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

public interface NatTssDcacService {

    //마스터
    public Map<String, Object> retrieveNatTssDcacMst(HashMap<String, String> input);

    public Map<String, Object> retrieveNatTssDcacSmryInfo(Map<String, Object> result);

    public int insertNatTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap);

    public int updateNatTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap);


    //중단개요
    public Map<String, Object> retrieveNatTssDcacSmry(HashMap<String, String> input);


    //품의서
    public Map<String, Object> retrieveNatTssDcacInfo(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveNatTssDcacAttc(HashMap<String, String> inputInfo);

    public int insertNatTssDcacCsusRq(Map<String, Object> map);

    public Map<String, Object> retrieveNatTssDcacStoa(HashMap<String, String> inputInfo);

	public String retrieveNatTssDcacCheck(HashMap<String, String> input);


}
