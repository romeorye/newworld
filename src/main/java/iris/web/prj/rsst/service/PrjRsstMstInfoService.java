package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : PrjRsstMstInfoService.java
 * DESC : 프로젝트 - 연구팀(Project) - 마스터,개요 Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.10  IRIS04	최초생성
 *********************************************************************************/

public interface PrjRsstMstInfoService {

	/* 프로젝트 리스트 조회 */
	List<Map<String, Object>> retrievePrjMstSearchList(HashMap<String, Object> input);

	/* 프로젝트 마스터 정보조회 */
	Map<String, Object> retrievePrjMstInfo(HashMap<String, Object> input);

	/* 프로젝트 상세 정보조회 */
	Map<String, Object> retrievePrjDtlInfo(HashMap<String, Object> input);

	/* 유저의 조직 총 인원수 조회 */
	Map<String, Object> retrieveDeptUserCntInfo(HashMap<String, String> input);

	/* 프로젝트 개요 마스터 저장,업데이트 */
	void insertPrjRsstMstInfo(Map<String, Object> input);

	/* 프로젝트 개요 상세 저장,업데이트 */
	void insertPrjRsstDtlInfo(Map<String, Object> input);

	/* 프로젝트 코드 조회 : null인 경우 "" */
	String retrievePrjCd();

	/* 프로젝트 조회팝업 목록조회" */
	List<Map<String, Object>> retrievePrjSearchPopupSearchList(HashMap<String, Object> input);
	
	/* 팀정보 조회 */
	public Map<String, Object> retrieveTeamDeptInfo(HashMap<String, String> input);
	
	/* WBS_CD 중복여부 */
	public String retrieveDupPrjWbsCd(Map<String, Object> input);

	void updatePrjDeptCdA(Map<String, Object> ds);

	/* 프로젝트신규 전용팝업창 */
	List<Map<String, Object>> retrievePrjPopupSearchList(HashMap<String, Object> input);
	


}