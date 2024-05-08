package iris.web.prj.tss.gen.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : GenTssDcacService.java 
 * DESC : 
 * PROJ : 
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.08.08            
 *********************************************************************************/

public interface GenTssDcacService {
	
	//마스터
	public Map<String, Object> retrieveGenTssDcacMst(HashMap<String, String> input);
	
	public int insertGenTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap);

    public int updateGenTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap);
	
	
	//완료개요
	public Map<String, Object> retrieveGenTssDcacSmry(HashMap<String, String> input);
	
    public int insertGenTssDcacSmry(HashMap<String, Object> input);

    public int updateGenTssDcacSmry(HashMap<String, Object> input);

    
    //품의서
    public Map<String, Object> retrieveGenTssDcacInfo(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveGenTssDcacAttc(HashMap<String, String> inputInfo);

    public int insertGenTssDcacCsusRq(Map<String, Object> map);

    /* 일반과제 중단 필수값 체크*/
	public String retrieveGenTssDcacCheck(HashMap<String, String> input);
}
