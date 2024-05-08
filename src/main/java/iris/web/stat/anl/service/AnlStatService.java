package iris.web.stat.anl.service;

import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : AnlStatService.java 
 * DESC : 통계 - 분석 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성                 
 *********************************************************************************/

public interface AnlStatService {

	/* 분석완료 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlCompleteStateList(Map<String, Object> input);

	/* 분석 기기사용 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlMchnUseStateList(Map<String, Object> input);

	/* 분석 업무현황 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlBusinessStateList(Map<String, Object> input);

	/* 분석 사업부 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlDivisionStateList(Map<String, Object> input);

	/* 담당자 분석 통계 리스트 조회 */
	public List<Map<String, Object>> getAnlChrgStateList(Map<String, Object> input);
}