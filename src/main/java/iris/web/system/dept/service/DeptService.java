/********************************************************************************
 * NAME : DeptService.java 
 * DESC : 부서
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.25  김찬웅	최초생성            
 *********************************************************************************/
package iris.web.system.dept.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface DeptService {

	/* 부서 조회 */
    public List<Map<String, Object>> getDeptList(HashMap<String, Object> input);
    /**
     * 부서 저장
     * @param ds
     */
	public void saveUpperDeptCdA(Map<String, Object> ds);
	
	/**
	 * 조직(상위부서 조회)
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveUpperDeptList(HashMap<String, Object> input);
}