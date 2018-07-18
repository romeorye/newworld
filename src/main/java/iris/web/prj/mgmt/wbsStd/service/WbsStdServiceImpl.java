package iris.web.prj.mgmt.wbsStd.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : GrsReqServiceImpl.java 
 * DESC : grsReqServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.28  jih	최초생성            
 *********************************************************************************/

@Service("wbsStdService")
public class WbsStdServiceImpl implements  WbsStdService{
	
	static final Logger LOGGER = LogManager.getLogger(WbsStdServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	
	/*목록조회
	 * (non-Javadoc)
	 * @see iris.web.prj.mgmt.grst.serice.WbsStdService#retrieveWbsStdList(java.util.HashMap)
	 */
	@Override
	public List<Map<String, Object>> retrieveWbsStdList(HashMap<String, Object> input) {
		
		return commonDao.selectList("prj.mgmt.wbsStd.retrieveWbsStdList", input);
	}
	
	/* 상세정보 조회
	 * (non-Javadoc)
	 * @see iris.web.prj.mgmt.grst.serice.WbsStdService#retrieveWbsStdDtl(java.util.HashMap)
	 */
	@Override
	public List<Map<String, Object>> retrieveWbsStdDtl(HashMap<String, Object> inputMap) {
		
		return commonDao.selectList("prj.mgmt.wbsStd.retrieveWbsStdDtl" ,inputMap );
	}


}


