package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;

/*********************************************************************************
 * NAME : OusdCooTssDcacService.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 중단(Dcac) service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.21  IRIS04	최초생성
 *********************************************************************************/

public interface OusdCooTssDcacService {

    /** 중단 신규등록(마스터,중단개요) **/
    public int insertOusdCooTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap);
    
    /** 중단 수정(마스터,중단개요) **/
    public int updateOusdCooTssDcacMst(HashMap<String, Object> mstMap, HashMap<String, Object> smryMap);
    
    /** 중단개요 등록 **/
    public int insertOusdCooTssDcacSmry(HashMap<String, Object> input);
    
    /** 중단개요 수정 **/
    public int updateOusdCooTssDcacSmry(HashMap<String, Object> input);

    /** 중단 필수값 체크*/
	public String retrieveOusdCooTssDcacCheck(HashMap<String, String> input);
    
/*	//마스터
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

    public int insertGenTssDcacCsusRq(Map<String, Object> map);*/
}
