package iris.web.tssbatch.service;

import java.util.HashMap;
import java.util.List;

/********************************************************************************
 * NAME : PrjTmmrService.java
 * DESC : 프로젝트 참여연구원 변경처리 서비스
 * PROJ : IRIS 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.29  소영창	최초생성
 *********************************************************************************/
public interface PrjTmmrService {
	
	/* 프로젝트 팀원 퇴사자 대상조회 */
	List<HashMap<String, Object>> retrievePrjTmmrResignList(HashMap<String, Object> input);
	
	/* 프로젝트 팀원 부서이동(이동 전) 대상조회 */
	List<HashMap<String, Object>> retrievePrjTmmrMoveOutList(HashMap<String, Object> input);
	
	/* 프로젝트 팀원 부서이동(이동 후) 대상조회 */
	List<HashMap<String, Object>> retrievePrjTmmrMoveInList(HashMap<String, Object> input);
	
	/* 프로젝트 팀원 퇴사자 참여종료일 업데이트 */
	void updatePrjTmmrResign( HashMap<String, Object> input);
	
	/* 프로젝트 팀원 부서이동(이동 전) 참여종료일 업데이트 */
	void updatePrjTmmrMoveOut( HashMap<String, Object> input);
	
	/* 프로젝트 팀원 부서이동(이동 후) 신규추가 */
	void insertPrjTmmrMoveIn( HashMap<String, Object> input);
}
