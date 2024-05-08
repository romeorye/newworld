package iris.web.prj.mgmt.trwiBudg.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : TrwiBudgServiceImpl.java 
 * DESC : TrwiBudgServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.28  jih	최초생성            
 *********************************************************************************/

@Service("trwiBudgService")
public class TrwiBudgServiceImpl implements  TrwiBudgService{
	
	static final Logger LOGGER = LogManager.getLogger(TrwiBudgServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	
	/*목록조회
	 * (non-Javadoc)
	 * @see iris.web.prj.mgmt.grst.serice.TrwiBudgService#retrieveTrwiBudgList(java.util.HashMap)
	 */
	@Override
	public List<Map<String, Object>> retrieveTrwiBudgList(HashMap<String, Object> input) {
		
		return commonDao.selectList("prj.mgmt.trwiBudg.retrieveTrwiBudgList", input);
	}
	/* 입력 , 수정 주정보
	 * (non-Javadoc)
	 * @see iris.web.prj.mgmt.grst.serice.TrwiBudgService#saveTrwiBudg(java.util.Map)
	 */
	@Override
	public int saveTrwiBudg(Map<String, Object> input) {
		return commonDao.update("prj.mgmt.trwiBudg.saveTrwiBudg", input);
	}
	
	
	/* 상세정보 조회
	 * (non-Javadoc)
	 * @see iris.web.prj.mgmt.grst.serice.TrwiBudgService#retrieveTrwiBudgDtl(java.util.HashMap)
	 */
	@Override
	public List<Map<String, Object>> retrieveTrwiBudgDtl(HashMap<String, Object> inputMap) {
		
		return commonDao.selectList("prj.mgmt.trwiBudg.retrieveTrwiBudgDtl" ,inputMap );
	}
	/* 삭제
	 * (non-Javadoc)
	 * @see iris.web.prj.mgmt.trwiBudg.service.TrwiBudgService#deleteTrwiBudg(java.util.HashMap)
	 */
	@Override
	public void deleteTrwiBudg(HashMap<String, Object> input) {
		commonDao.delete("prj.mgmt.trwiBudg.deleteTrwiBudg", input);
	}
	@Override
	public void updateTrwiBudgPro(HashMap<String, Object> input) {
		
		commonDao.update("prj.mgmt.trwiBudg.updateTrwiBudgPro", input);
		
	}
}


