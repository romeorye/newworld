package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : PrjTmmrInfoService.java
 * DESC : 프로젝트 - 연구팀(Project) - 팀원정보(Tmmr) Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.25  IRIS04	최초생성
 *********************************************************************************/

public interface PrjTmmrInfoService {

	/* 팀원정보 목록 조회 */
	List<Map<String, Object>> retrievePrjTmmrSearchInfo(HashMap<String, Object> input);

	/* 팀원정보 프로젝트단위 삭제 */
	void deletePrjTmmrDeptInfo(Map<String, Object> input);

	/* 팀원정보 프로젝트단위 등록 */
	void insertPrjTmmrDeptInfo(Map<String, Object> input);
	
	/* 팀원정보 프로젝트단위(파트포함) 등록 */
	public void insertPrjTeamTmmrDeptInfo(Map<String, Object> input);

}