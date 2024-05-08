package iris.web.prj.tss.mkInnoStat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public interface MkInnoStatService {

	static final Logger LOGGER = LogManager.getLogger(MkInnoStatService.class);

	
	//과제건수 사업부별 과제 관리
	List<Map<String, Object>> retrieveCntBizSearchList(HashMap<String, Object> input);

	//과제건수 팀별 과제 관리
	List<Map<String, Object>> retrieveCntTeamSearchList(HashMap<String, Object> input);

	//과제진행현황 사업부별 관리
	List<Map<String, Object>> retrievePgsBizSearchList(HashMap<String, Object> input);
	
	//과제진행현황 팀별 관리
	List<Map<String, Object>> retrievePgsTeamSearchList(HashMap<String, Object> input);
	
}
