package iris.web.stat.anl.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("mchnInfoStatService")
public class MchnInfoStatServiceImpl implements MchnInfoStatService {

	static final Logger LOGGER = LogManager.getLogger(MchnInfoStatServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	/**
	 * 통계 > 분석 > OPEN기기 사용조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> mchnInfoStateList(HashMap<String, Object> input){
		return commonDao.selectList("stat.mchn.mchnInfoStateList", input);
	}
	
}
