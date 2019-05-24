package iris.web.prs.purStts.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.prs.purRq.service.PurRqInfoServiceImpl;

@Service("purSttsService")
public class PurSttsServiceImpl implements PurSttsService{

static final Logger LOGGER = LogManager.getLogger(PurRqInfoServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;

	
	/**
	 *  구매요청현황 리스트 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrievePurSttsList(HashMap<String, Object> input){
		return commonDao.selectList("prs.purStts.retrievePurSttsList", input );
	}
}
