package iris.web.knld.pub.service;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.common.util.DateUtil;

/*********************************************************************************
 * NAME : ScheduleServiceImpl.java 
 * DESC : Knowledge - 일정 관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성               
 *********************************************************************************/

@Service("knldScheduleService")
public class ScheduleServiceImpl implements ScheduleService {
	
	static final Logger LOGGER = LogManager.getLogger(ScheduleServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 연구소 주요일정 일별 리스트 조회 */
	public List<Map<String, Object>> getDayScheduleList(Map<String, Object> input) {
		return commonDao.selectList("knld.schedule.getDayScheduleList", input);
	}

	/* 연구소 주요일정 월별 리스트 조회 */
	public List<Map<String, Object>> getMonthScheduleList(Map<String, Object> input) {
		return commonDao.selectList("knld.schedule.getMonthScheduleList", input);
	}

	/* 연구소 주요일정 상세 정보 조회 */
	public Map<String, Object> getScheduleInfo(Map<String, Object> input) {
		return commonDao.select("knld.schedule.getScheduleInfo", input);
	}
	
	/* 연구소 주요일정 저장 */
	public boolean saveSchedule(HashMap<String, Object> input) throws Exception {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		if("".equals(input.get("labtAdscId")) && "Y".equals(input.get("repeatYn"))) {
			/* 연구소 주요일정 그룹 ID 생성 */
			String adscDt = (String)input.get("adscDt");
			int days = DateUtil.daysBetween(adscDt,  (String)input.get("toAdscDt"), "yyyy-MM-dd");
			Integer labtAdscGroupId = commonDao.select("knld.schedule.getScheduleGroupId", null);
			HashMap<String, Object> schedule = null;
			
			for(int i=0; i<=days; i++) {
				schedule = (HashMap<String, Object>)input.clone();
				
				schedule.put("labtAdscGroupId", labtAdscGroupId);
				schedule.put("adscDt", i == 0 ? adscDt : DateUtil.addDays(adscDt, i, "yyyy-MM-dd"));
				
				list.add(schedule);
			}
		} else {
			list.add(input);
		}
		
    	if(commonDao.batchInsert("knld.schedule.saveSchedule", list) == list.size()) {
        	return true;
    	} else {
    		throw new Exception("연구소 주요일정 저장 오류");
    	}
	}
	
	/* 연구소 주요일정 삭제 */
	public boolean deleteSchedule(Map<String, Object> input) throws Exception {
    	if(commonDao.update("knld.schedule.updateScheduleDelYn", input) > 0) {
        	return true;
    	} else {
    		throw new Exception("연구소 주요일정 삭제 오류");
    	}
	}
}