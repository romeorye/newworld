package iris.web.fxa.dsu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.fxa.anl.service.FxaAnlServiceImpl;

@Service("fxaDsuService")
public class FxaDsuServiceImpl implements FxaDsuService {

	static final Logger LOGGER = LogManager.getLogger(FxaAnlServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/**
	 * 자산폐기 목록 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaDsuSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaDsu.retrieveFxaDsuSearchList", input);
		return resultList;
	}
}
