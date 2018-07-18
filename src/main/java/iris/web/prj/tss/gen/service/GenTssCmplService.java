package iris.web.prj.tss.gen.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : GenTssCmplService.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

public interface GenTssCmplService {

    //마스터
    public Map<String, Object> retrieveGenTssCmplMst(HashMap<String, String> input);

    public int insertGenTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);

    public int updateGenTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);


    //완료개요
    public Map<String, Object> retrieveGenTssCmplSmry(HashMap<String, String> input);

    public int insertGenTssCmplSmry(HashMap<String, Object> input);

    public int updateGenTssCmplSmry(HashMap<String, Object> input);


    //품의서
    public Map<String, Object> retrieveGenTssCmplInfo(HashMap<String, String> input);

    public List<Map<String, Object>> retrieveGenTssCmplAttc(HashMap<String, String> inputInfo);

    public int insertGenTssCmplCsusRq(Map<String, Object> map);

    //필수산출물 count	
	public String retrieveGenTssCmplCheck(HashMap<String, String> input);

}
