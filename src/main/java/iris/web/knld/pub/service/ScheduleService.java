package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : ScheduleService.java 
 * DESC : Knowledge - 일정 관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성                 
 *********************************************************************************/

public interface ScheduleService {

	/* 연구소 주요일정 일별 리스트 조회 */
	public List<Map<String, Object>> getDayScheduleList(Map<String, Object> input);

	/* 연구소 주요일정 월별 리스트 조회 */
	public List<Map<String, Object>> getMonthScheduleList(Map<String, Object> input);

	/* 연구소 주요일정 상세 정보 조회 */
	public Map<String, Object> getScheduleInfo(Map<String, Object> input);
	
	/* 연구소 주요일정 저장 */
	public boolean saveSchedule(HashMap<String, Object> input) throws Exception;
	
	/* 연구소 주요일정 삭제 */
	public boolean deleteSchedule(Map<String, Object> input) throws Exception;
}