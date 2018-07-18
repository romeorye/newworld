package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;

/********************************************************************************
 * NAME : RsstServiceImpl.java 
 * DESC : 프로젝트 - 연구팀(Project) Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.10  IRIS04	최초생성     
 *********************************************************************************/

@Service("prjRsstPduInfoService")
public class PrjRsstPduInfoServiceImpl implements PrjRsstPduInfoService {
	
	static final Logger LOGGER = LogManager.getLogger(PrjRsstPduInfoServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 산출물 리스트 조회 */
	public List<Map<String, Object>> retrievePrjRsstPduSearchInfo(HashMap<String, Object> input){

	    List<Map<String, Object>> resultList = commonDao.selectList("prj.rsst.pdu.retrievePrjRsstPduSearchInfo", input);
	    return resultList;
	}
	
	/* 산출물 삭제 */
	public void deletePrjRsstPduInfo(Map<String, Object> input) {
		commonDao.delete("prj.rsst.pdu.deletePrjRsstPduInfo", input);
	}
	
	/* 산출물 입력, 업데이트 */
	public void insertPrjRsstPduInfo(Map<String, Object> input) {
		String seq = NullUtil.nvl(input.get("seq"), "");
		if("".equals(seq)) {
			commonDao.insert("prj.rsst.pdu.insertPrjRsstPduInfo", input);
		}else {
			commonDao.update("prj.rsst.pdu.updatePrjRsstPduInfo", input);
		}
	}
}