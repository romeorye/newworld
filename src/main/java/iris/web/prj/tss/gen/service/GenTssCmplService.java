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
	Map<String, Object> retrieveGenTssCmplMst(HashMap<String, String> input);

	void insertGenTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);

	void updateGenTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);


	//완료
	Map<String, Object> retrieveGenTssCmplIfm(HashMap<String, String> input);

	int insertGenTssCmplSmry(HashMap<String, Object> input);

	int updateGenTssCmplSmry(HashMap<String, Object> input);


	//품의서
	Map<String, Object> retrieveGenTssCmplInfo(HashMap<String, String> input);

	List<Map<String, Object>> retrieveGenTssCmplAttc(HashMap<String, String> inputInfo);

	int insertGenTssCmplCsusRq(Map<String, Object> map);

	//필수산출물 count
	String retrieveGenTssCmplCheck(HashMap<String, String> input);
	

	

}
