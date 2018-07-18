package iris.web.knld.pub.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager; 
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;

/*********************************************************************************
 * NAME : OutsideSpecialistServiceImpl.java 
 * DESC : 지식관리 - 사외전문가관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.14  			최초생성               
 *********************************************************************************/

@Service("outsideSpecialistService")
public class OutsideSpecialistServiceImpl implements OutsideSpecialistService {
	
	static final Logger LOGGER = LogManager.getLogger(OutsideSpecialistServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getOutsideSpecialistList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.pub.getOutsideSpeciaList", input);
	}

	public Map<String, Object> getOutsideSpecialistInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.pub.getOutsideSpecialistInfo", input);
	}

	/* 사외전문가 입력&업데이트 */
	@Override
	public void insertOutsideSpecialistInfo(Map<String, Object> input) {
		String outSpclId = NullUtil.nvl(input.get("outSpclId"), "");

		if("".equals(outSpclId)) {
			commonDao.insert("knld.pub.insertOutsideSpecialistInfo", input);
		}else {
			commonDao.update("knld.pub.updateOutsideSpecialistInfo", input);
		}
	}
	
	/* 사외전문가 삭제  */
	@Override
	public void deleteOutsideSpecialistInfo(HashMap<String, String> input) {
		String outSpclId = NullUtil.nvl(input.get("outSpclId"), "");
		LOGGER.debug("###########outSpclIdId################"+outSpclId);
		commonDao.update("knld.pub.deleteOutsideSpecialistInfo", input);
	}
	
	/* 사외전문가 조회건수 증가  */
	@Override
	public void updateOutsideSpecialistRtrvCnt(HashMap<String, String> input) {
		String outSpclId = NullUtil.nvl(input.get("outSpclId"), "");
		LOGGER.debug("###########outSpclId################"+outSpclId);
		commonDao.update("knld.pub.updateOutsideSpecialistRtrvCnt", input);
	}
	
}