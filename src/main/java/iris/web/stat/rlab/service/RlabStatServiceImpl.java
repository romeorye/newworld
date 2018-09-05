package iris.web.stat.rlab.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("rlabStatService")
public class RlabStatServiceImpl implements RlabStatService {

	static final Logger LOGGER = LogManager.getLogger(RlabStatServiceImpl.class);

	@Resource(name="commonDao")
    private CommonDao commonDao;

	@Resource(name="commonDaoPims")
	private CommonDao commonDaoPims;	// 지적재산권 조회 Dao

	 /**
     * 통계 > 년도별 시험구분별 리스트 조회
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	@Override
	public List<Map<String, Object>> retrieveRlabScnStatList(HashMap<String, Object> input){
		return commonDao.selectList("stat.rlab.retrieveRlabScnStatList", input);
	}

	 /**
     * 통계 > 년도별 사업부별 리스트 조회
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	@Override
	public List<Map<String, Object>> retrieveRlabDzdvStatList(HashMap<String, Object> input){
		return commonDao.selectList("stat.rlab.retrieveRlabDzdvStatList", input);
	}

	 /**
     * 통계 > 연도별 시험법별 리스트 조회
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	@Override
	public List<Map<String, Object>> retrieveRlabExprStatList(HashMap<String, Object> input){
		return commonDao.selectList("stat.rlab.retrieveRlabExprStatList", input);
	}

	/**
    * 통계 > 연도별 담당자별 리스트 조회
    * @param input HashMap<String, Object>
    * @return ModelAndView
    * */
	@Override
	public List<Map<String, Object>> retrieveRlabChrgStatList(HashMap<String, Object> input){
		return commonDao.selectList("stat.rlab.retrieveRlabChrgStatList", input);
	}

	/**
    * 통계 > 연도 조회
    * @param input HashMap<String, Object>
    * @return ModelAndView
    * */
	@Override
	public List<Map<String, Object>> retrieveRlabYyList(HashMap<String, Object> input){
		return commonDao.selectList("stat.rlab.retrieveRlabYyList", input);
	}

	/**
    * 통계 > 연도 조회
    * @param input HashMap<String, Object>
    * @return ModelAndView
    * */
	@Override
	public List<Map<String, Object>> retrieveRlabTermStatList(HashMap<String, Object> input){
		return commonDao.selectList("stat.rlab.retrieveRlabTermStatList", input);
	}

}
