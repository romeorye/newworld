package iris.web.prj.tss.tctm.service;

import java.util.*;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("tctmTssService")
public class TctmTssServiceImpl implements TctmTssService {
	static final Logger LOGGER = LogManager.getLogger(TctmTssServiceImpl.class);

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	@Override
	public List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input) {
		return commonDao.selectList("prj.tss.tctm.selectTctmTssList", input);
	}

}
