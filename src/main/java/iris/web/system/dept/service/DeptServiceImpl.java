/********************************************************************************
 * NAME : DeptServiceImpl.java 
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

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("deptService")
public class DeptServiceImpl implements DeptService {

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 부서 조회 */
    public List<Map<String, Object>> getDeptList(HashMap<String, Object> input) {
        return commonDao.selectList("common.dept.getDeptList", input);
    }

	@Override
	public void saveUpperDeptCdA(Map<String, Object> ds) {
		 commonDao.update("common.dept.saveDeptCdA", ds);
		
	}

	@Override
	public List<Map<String, Object>> retrieveUpperDeptList(HashMap<String, Object> input) {
		 return commonDao.selectList("common.dept.retrieveUpperDeptList", input);
	}	
}