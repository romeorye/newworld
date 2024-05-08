package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : PrjMmInfoService.java
 * DESC : 프로젝트 - 연구팀(Project) - 투입M/M(mm) Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.29  IRIS04	최초생성
 *********************************************************************************/

public interface PrjMmInfoService {

	/** 투입M/M 월별 목록 조회 **/
	List<Map<String, Object>> retrieveMmByMonthSearchInfo(HashMap<String, Object> input);

	/** 투입M/M 년도별 목록 조회 **/
	List<Map<String, Object>> retrieveMmByYearSearchInfo(HashMap<String, Object> input);

}