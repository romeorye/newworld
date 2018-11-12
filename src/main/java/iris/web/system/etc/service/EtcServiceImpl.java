/********************************************************************************
 * NAME : EtcServiceImpl.java
 * DESC : 기타 공통
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.08.09  정현웅	최초생성
 *********************************************************************************/
package iris.web.system.etc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("etcService")
public class EtcServiceImpl implements EtcService {

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* WBS 코드 조회 */
    public List<Map<String, Object>> getWbsCdList(HashMap<String, Object> input) {
        return commonDao.selectList("common.etc.getWbsCdList", input);
    }

}