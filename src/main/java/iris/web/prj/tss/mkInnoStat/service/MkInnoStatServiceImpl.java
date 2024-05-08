package iris.web.prj.tss.mkInnoStat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("mkInnoStatService")
public class MkInnoStatServiceImpl implements MkInnoStatService{

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	
	//과제건수 사업부별 과제 관리
	public List<Map<String, Object>> retrieveCntBizSearchList(HashMap<String, Object> input){
		return commonDao.selectList("mkInno.stat.retrieveCntBizSearchList", input);
	}

	//과제건수 팀별 과제 관리
	public List<Map<String, Object>> retrieveCntTeamSearchList(HashMap<String, Object> input){
		return commonDao.selectList("mkInno.stat.retrieveCntTeamSearchList", input);
	}

	//과제진행현황 사업부별 관리
	public List<Map<String, Object>> retrievePgsBizSearchList(HashMap<String, Object> input){
		return commonDao.selectList("mkInno.stat.retrievePgsBizSearchList", input);
	}
	
	//과제진행현황 팀별 관리
	public List<Map<String, Object>> retrievePgsTeamSearchList(HashMap<String, Object> input){
		return commonDao.selectList("mkInno.stat.retrievePgsTeamSearchList", input);
	}
	
	
}
