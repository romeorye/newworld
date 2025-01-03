package iris.web.stat.space.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import iris.web.stat.rlab.service.RlabStatServiceImpl;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("spaceStatService")
public class SpaceStatServiceImpl implements SpaceStatService{

	static final Logger LOGGER = LogManager.getLogger(RlabStatServiceImpl.class);

	@Resource(name="commonDao")
    private CommonDao commonDao;

	@Resource(name="commonDaoPims")
	private CommonDao commonDaoPims;	// 지적재산권 조회 Dao

	//연도조회
	@Override
	public List<Map<String, Object>> retrieveSpaceYyList(
			HashMap<String, Object> input) {
		return commonDao.selectList("stat.space.retrieveSpaceYyList", input);
	}

	@Override
	public List<Map<String, Object>> getSpaceBzdvStatList(
			HashMap<String, Object> input) {
		return commonDao.selectList("stat.space.getSpaceBzdvStatList", input);
	}

	@Override
	public List<Map<String, Object>> getSpaceEvAffrSttsList(
			HashMap<String, Object> input) {
		return commonDao.selectList("stat.space.getSpaceEvAffrSttsList", input);
	}

	@Override
	public List<Map<String, Object>> getSpaceAnlStatList(
			HashMap<String, Object> input) {
		return commonDao.selectList("stat.space.getSpaceAnlStatList", input);
	}

	@Override
	public List<Map<String, Object>> getSpaceCrgrStatList(
			HashMap<String, Object> input) {
		return commonDao.selectList("stat.space.getSpaceCrgrStatList", input);
	}

	@Override
	public List<Map<String, Object>> getSpaceAnlWayStatList(
			HashMap<String, Object> input) {
		return commonDao.selectList("stat.space.getSpaceAnlWayStatList", input);
	}

}
