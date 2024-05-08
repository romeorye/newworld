/********************************************************************************
 * NAME : IrisUserServiceImpl.java 
 * DESC : 영업자료게시판
 * PROJ : WINS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.25  김찬웅	최초생성            
 *********************************************************************************/
package iris.web.system.user.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("irisUserService")
public class IrisUserServiceImpl implements IrisUserService {

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* LG사용자 조회 */
    public List<Map<String, Object>> getUserList(HashMap<String, Object> input) {
        return commonDao.selectList("common.user.getUserList", input);
    }	
}